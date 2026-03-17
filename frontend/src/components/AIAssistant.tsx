import { useState, useRef, useEffect } from "react";
import { Button } from "@/components/ui/button";
import { Input } from "@/components/ui/input";
import { Bot, Send, X } from "lucide-react";
import { getApiBase } from "@/api/client";

/** AI chatbot uses GROQ via our backend /api/chat/ask (API key on server only). */
function getChatApiBase(): string {
  return getApiBase();
}

interface AIAssistantProps {
  isOpen: boolean;
  onClose: () => void;
  topicName?: string;
  chapterName?: string;
  /** Pre-fill input for quiz wrong-answer explanation (e.g. from Class-Quiz results) */
  initialQuestion?: string;
}

const AIAssistant = ({ isOpen, onClose, topicName, chapterName, initialQuestion }: AIAssistantProps) => {
  const defaultGreeting = "Hello! I'm your AI Teaching Assistant. How can I help you with today's lesson?";
  const contextGreeting = topicName && chapterName
    ? `Hello! I'm your AI Teaching Assistant. How can I help you with today's lesson on ${topicName} (${chapterName})?`
    : topicName
      ? `Hello! I'm your AI Teaching Assistant. How can I help you with today's lesson on ${topicName}?`
      : defaultGreeting;

  const [messages, setMessages] = useState<{ role: "user" | "ai"; text: string }[]>([
    { role: "ai", text: defaultGreeting },
  ]);
  const [input, setInput] = useState("");
  const [isLoading, setIsLoading] = useState(false);
  const endRef = useRef<HTMLDivElement>(null);

  useEffect(() => {
    endRef.current?.scrollIntoView({ behavior: "smooth" });
  }, [messages]);

  useEffect(() => {
    if (isOpen && contextGreeting !== defaultGreeting) {
      setMessages([{ role: "ai", text: contextGreeting }]);
    }
  }, [isOpen, topicName, chapterName]);

  useEffect(() => {
    if (isOpen && initialQuestion?.trim()) {
      setInput(initialQuestion);
    }
  }, [isOpen, initialQuestion]);

  const handleSend = async () => {
    if (!input.trim() || isLoading) return;

    const userText = input;
    setMessages(prev => [...prev, { role: "user", text: userText }]);
    setInput("");
    setIsLoading(true);

    try {
      // Build conversation history for context
      const conversationHistory = messages.map(msg => ({
        role: msg.role === "ai" ? "assistant" : "user",
        content: msg.text,
      }));

      const response = await fetch(`${getChatApiBase()}/api/chat/ask`, {
        method: "POST",
        headers: {
          "Content-Type": "application/json",
        },
        body: JSON.stringify({
          question: userText,
        }),
      });

      if (!response.ok) {
        throw new Error(`API error: ${response.status}`);
      }

      const data = await response.json();
      const aiText = data.answer ?? "Sorry, I couldn't generate a response.";
      setMessages(prev => [...prev, { role: "ai", text: aiText }]);
    } catch (error) {
      const isOffline =
        error instanceof TypeError && (error.message === "Failed to fetch" || error.message?.includes("fetch"));
      const msg = isOffline
        ? "Cannot reach the app backend. Make sure the backend is running (npm run server) and GROQ_API_KEY is set in .env."
        : "Oops! Something went wrong connecting to the AI. Please try again.";
      setMessages(prev => [...prev, { role: "ai", text: msg }]);
    } finally {
      setIsLoading(false);
    }
  };

  if (!isOpen) return null;

  return (
    <div className="fixed inset-0 z-50 flex items-center justify-center bg-foreground/30 backdrop-blur-sm p-4">
      <div className="w-full max-w-lg bg-card rounded-2xl shadow-hover border border-border flex flex-col max-h-[80vh]">
        <div className="flex items-center justify-between p-4 border-b border-border">
          <div className="flex items-center gap-2">
            <div className="w-8 h-8 rounded-lg gradient-primary flex items-center justify-center">
              <Bot className="w-4 h-4 text-primary-foreground" />
            </div>
            <h3 className="font-display font-semibold text-foreground">AI Teaching Assistant</h3>
          </div>
          <Button variant="ghost" size="icon" onClick={onClose}><X className="w-4 h-4" /></Button>
        </div>
        <div className="flex-1 overflow-y-auto p-4 space-y-3">
          {messages.map((msg, i) => (
            <div key={i} className={`flex ${msg.role === "user" ? "justify-end" : "justify-start"}`}>
              <div className={`max-w-[80%] rounded-xl px-4 py-2.5 text-sm ${
                msg.role === "user"
                  ? "gradient-primary text-primary-foreground"
                  : "bg-secondary text-secondary-foreground"
              }`}>
                {msg.text}
              </div>
            </div>
          ))}
          {isLoading && (
            <div className="flex justify-start">
              <div className="max-w-[80%] rounded-xl px-4 py-2.5 text-sm bg-secondary text-secondary-foreground">
                <span className="animate-pulse">Thinking...</span>
              </div>
            </div>
          )}
          <div ref={endRef} />
        </div>
        <div className="p-4 border-t border-border flex gap-2">
          <Input
            value={input}
            onChange={e => setInput(e.target.value)}
            onKeyDown={e => e.key === "Enter" && handleSend()}
            placeholder="Ask about the lesson..."
            disabled={isLoading}
          />
          <Button onClick={handleSend} size="icon" disabled={isLoading}><Send className="w-4 h-4" /></Button>
        </div>
      </div>
    </div>
  );
};

export default AIAssistant;