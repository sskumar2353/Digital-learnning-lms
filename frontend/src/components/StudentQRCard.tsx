import { useRef, useCallback } from "react";
import { QRCodeSVG } from "qrcode.react";
import { Button } from "@/components/ui/button";
import { Download, GraduationCap } from "lucide-react";

interface Student {
  id: string;
  name: string;
  rollNo: number;
  classId: string;
  schoolId: string;
}

interface StudentQRCardProps {
  student: Student;
  schoolName: string;
  className: string;
}

const StudentQRCard = ({ student, schoolName, className }: StudentQRCardProps) => {
  const cardRef = useRef<HTMLDivElement>(null);

  const downloadCard = useCallback(() => {
    const card = cardRef.current;
    if (!card) return;

    const svg = card.querySelector("svg");
    if (!svg) return;

    // Create a canvas to render the full card
    const canvas = document.createElement("canvas");
    const scale = 3;
    canvas.width = 320 * scale;
    canvas.height = 420 * scale;
    const ctx = canvas.getContext("2d");
    if (!ctx) return;

    ctx.scale(scale, scale);

    // Background
    ctx.fillStyle = "#ffffff";
    ctx.beginPath();
    ctx.roundRect(0, 0, 320, 420, 16);
    ctx.fill();

    // Header bar
    ctx.fillStyle = "#1a9988";
    ctx.beginPath();
    ctx.roundRect(0, 0, 320, 70, [16, 16, 0, 0]);
    ctx.fill();

    // Header text
    ctx.fillStyle = "#ffffff";
    ctx.font = "bold 14px 'Space Grotesk', sans-serif";
    ctx.textAlign = "center";
    ctx.fillText("ITDA AI Classroom", 160, 30);
    ctx.font = "11px 'Plus Jakarta Sans', sans-serif";
    ctx.fillText("Student Identity Card", 160, 50);

    // QR code - render SVG to canvas
    const svgData = new XMLSerializer().serializeToString(svg);
    const img = new Image();
    const svgBlob = new Blob([svgData], { type: "image/svg+xml;charset=utf-8" });
    const url = URL.createObjectURL(svgBlob);

    img.onload = () => {
      // QR code
      ctx.drawImage(img, 80, 90, 160, 160);

      // Border around QR
      ctx.strokeStyle = "#e5e7eb";
      ctx.lineWidth = 1;
      ctx.beginPath();
      ctx.roundRect(70, 80, 180, 180, 12);
      ctx.stroke();

      // Student info
      ctx.fillStyle = "#1a2b3c";
      ctx.font = "bold 18px 'Space Grotesk', sans-serif";
      ctx.textAlign = "center";
      ctx.fillText(student.name, 160, 295);

      ctx.fillStyle = "#6b7280";
      ctx.font = "12px 'Plus Jakarta Sans', sans-serif";
      ctx.fillText(`Roll No: ${student.rollNo}`, 160, 318);
      ctx.fillText(className, 160, 338);
      ctx.fillText(schoolName, 160, 358);

      // ID at bottom
      ctx.fillStyle = "#f0f9f8";
      ctx.beginPath();
      ctx.roundRect(60, 375, 200, 28, 8);
      ctx.fill();
      ctx.fillStyle = "#1a9988";
      ctx.font = "bold 11px monospace";
      ctx.fillText(`ID: ${student.id}`, 160, 394);

      // Download
      const link = document.createElement("a");
      link.download = `QR-${student.name.replace(/\s+/g, "-")}-${student.id}.png`;
      link.href = canvas.toDataURL("image/png");
      link.click();
      URL.revokeObjectURL(url);
    };
    img.src = url;
  }, [student, schoolName, className]);

  const qrValue = JSON.stringify({
    student_id: student.id,
    name: student.name,
    roll: student.rollNo,
    class: className,
  });

  return (
    <div className="flex flex-col items-center gap-3">
      <div
        ref={cardRef}
        className="w-[280px] bg-card rounded-2xl shadow-card border border-border overflow-hidden"
      >
        {/* Header */}
        <div className="gradient-primary px-4 py-3 text-center">
          <div className="flex items-center justify-center gap-1.5 mb-0.5">
            <GraduationCap className="w-4 h-4 text-primary-foreground" />
            <span className="text-primary-foreground font-display font-bold text-sm">ITDA AI Classroom</span>
          </div>
          <p className="text-primary-foreground/80 text-xs">Student Identity Card</p>
        </div>

        {/* QR Code */}
        <div className="flex justify-center py-5">
          <div className="p-3 border border-border rounded-xl">
            <QRCodeSVG
              value={qrValue}
              size={140}
              level="M"
              bgColor="transparent"
              fgColor="hsl(200, 25%, 10%)"
            />
          </div>
        </div>

        {/* Student Info */}
        <div className="text-center px-4 pb-4">
          <h4 className="font-display font-bold text-foreground text-lg">{student.name}</h4>
          <p className="text-muted-foreground text-xs mt-1">Roll No: {student.rollNo}</p>
          <p className="text-muted-foreground text-xs">{className}</p>
          <p className="text-muted-foreground text-xs">{schoolName}</p>
          <div className="mt-3 bg-teal-light rounded-lg px-3 py-1.5">
            <code className="text-xs font-mono text-primary font-medium">ID: {student.id}</code>
          </div>
        </div>
      </div>

      <Button variant="outline" size="sm" onClick={downloadCard} className="gap-1.5">
        <Download className="w-3.5 h-3.5" /> Download Card
      </Button>
    </div>
  );
};

export default StudentQRCard;
