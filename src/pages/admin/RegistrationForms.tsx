import React, { useState } from "react";
import { Button } from "@/components/ui/button";
import { Input } from "@/components/ui/input";
import { Label } from "@/components/ui/label";
import { Select, SelectTrigger, SelectValue, SelectContent, SelectItem } from "@/components/ui/select";
import { Card, CardContent } from "@/components/ui/card";
import { registerStudent, registerTeacher } from "@/api/client";

type School = { id: string; name: string };
type ClassItem = { id: string; name: string; schoolId: string; grade: number };

type StudentFormProps = {
  onClose?: () => void;
  schools?: School[];
  classes?: ClassItem[];
  onSuccess?: () => void;
};

export const StudentForm: React.FC<StudentFormProps> = ({ onClose, schools = [], classes = [], onSuccess }) => {
  const [firstName, setFirstName] = useState("");
  const [lastName, setLastName] = useState("");
  const [rollNo, setRollNo] = useState("");
  const [section, setSection] = useState("");
  const [password, setPassword] = useState("");
  const [schoolId, setSchoolId] = useState("");
  const [classId, setClassId] = useState("");
  const [submitting, setSubmitting] = useState(false);
  const [error, setError] = useState<string | null>(null);

  const schoolList = schools ?? [];
  const classList = classes ?? [];
  const classesForSchool = schoolId
    ? classList.filter((c) => c.schoolId === schoolId)
    : classList;

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault();
    setError(null);
    const full_name = [firstName.trim(), lastName.trim()].filter(Boolean).join(" ") || "Student";
    if (!schoolId?.trim()) {
      setError("Please select a school.");
      return;
    }
    const rollNum = rollNo.trim() !== "" ? parseInt(rollNo, 10) : undefined;
    if (rollNum === undefined || Number.isNaN(rollNum) || rollNum < 0) {
      setError("Roll number is required and must be a non-negative number.");
      return;
    }
    if (!section || (section !== "A" && section !== "B" && section !== "C")) {
      setError("Please select a section (A, B, or C).");
      return;
    }
    const finalClassId = (classId?.trim() && classId !== "__none__") ? classId.trim() : null;
    if (!finalClassId) {
      setError("Please select a class (grade 6–10).");
      return;
    }
    setSubmitting(true);
    try {
      await registerStudent({
        full_name,
        roll_no: rollNum,
        section: section.trim(),
        school_id: schoolId.trim(),
        class_id: finalClassId ?? undefined,
        password: password.trim() || undefined,
      });
      onSuccess?.();
      onClose?.();
    } catch (err) {
      setError(err instanceof Error ? err.message : "Failed to register student.");
    } finally {
      setSubmitting(false);
    }
  };

  return (
    <Card>
      <CardContent>
        <form onSubmit={handleSubmit} className="grid grid-cols-1 md:grid-cols-2 gap-4" autoComplete="off">
          <div className="space-y-2">
            <Label>School (required)</Label>
            <Select value={schoolId} onValueChange={(v) => { setSchoolId(v); setClassId(""); }}>
              <SelectTrigger className="h-9">
                <SelectValue placeholder="Select school" />
              </SelectTrigger>
              <SelectContent>
                {schoolList.map((s) => (
                  <SelectItem key={s.id} value={s.id}>{s.name}</SelectItem>
                ))}
              </SelectContent>
            </Select>
          </div>
          <div className="space-y-2">
            <Label>Roll number (required)</Label>
            <Input type="number" min={0} placeholder="e.g. 1" value={rollNo} onChange={(e) => setRollNo(e.target.value)} required />
          </div>
          <div className="space-y-2">
            <Label>Section (required)</Label>
            <Select value={section || "__none__"} onValueChange={(v) => setSection(v === "__none__" ? "" : v)}>
              <SelectTrigger className="h-9">
                <SelectValue placeholder="Select section" />
              </SelectTrigger>
              <SelectContent>
                <SelectItem value="__none__">Select section</SelectItem>
                <SelectItem value="A">A</SelectItem>
                <SelectItem value="B">B</SelectItem>
                <SelectItem value="C">C</SelectItem>
              </SelectContent>
            </Select>
          </div>
          <div className="space-y-2">
            <Label>Full name (required)</Label>
            <div className="flex gap-2">
              <Input placeholder="First name" value={firstName} onChange={(e) => setFirstName(e.target.value)} required autoComplete="given-name" />
              <Input placeholder="Last name" value={lastName} onChange={(e) => setLastName(e.target.value)} autoComplete="family-name" />
            </div>
          </div>
          <div className="space-y-2">
            <Label>Password (optional)</Label>
            <Input type="password" placeholder="Leave blank if not needed" value={password} onChange={(e) => setPassword(e.target.value)} autoComplete="new-password" />
          </div>
          <div className="space-y-2">
            <Label>Class (required, grades 6–10)</Label>
            <Select value={classId || "__none__"} onValueChange={(v) => setClassId(v === "__none__" ? "" : v)}>
              <SelectTrigger className="h-9">
                <SelectValue placeholder="Select class" />
              </SelectTrigger>
              <SelectContent>
                <SelectItem value="__none__">Select class</SelectItem>
                {classesForSchool.map((c) => (
                  <SelectItem key={c.id} value={c.id}>{c.name}</SelectItem>
                ))}
              </SelectContent>
            </Select>
          </div>
          {error && <p className="md:col-span-2 text-sm text-destructive">{error}</p>}
          <div className="md:col-span-2 flex justify-end">
            <Button type="submit" disabled={submitting}>{submitting ? "Saving…" : "Register Student"}</Button>
          </div>
        </form>
      </CardContent>
    </Card>
  );
};

type TeacherFormProps = {
  onClose?: () => void;
  schools: School[];
  onSuccess?: () => void;
};

export const TeacherForm: React.FC<TeacherFormProps> = ({ onClose, schools, onSuccess }) => {
  const [firstName, setFirstName] = useState("");
  const [lastName, setLastName] = useState("");
  const [email, setEmail] = useState("");
  const [password, setPassword] = useState("");
  const [schoolId, setSchoolId] = useState("");
  const [submitting, setSubmitting] = useState(false);
  const [error, setError] = useState<string | null>(null);

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault();
    setError(null);
    const full_name = [firstName.trim(), lastName.trim()].filter(Boolean).join(" ") || "Teacher";
    if (!schoolId) {
      setError("Please select a school.");
      return;
    }
    if (!email.trim()) {
      setError("Email is required.");
      return;
    }
    if (!password.trim()) {
      setError("Password is required.");
      return;
    }
    const fullNameCheck = [firstName.trim(), lastName.trim()].filter(Boolean).join(" ");
    if (!fullNameCheck) {
      setError("First name and last name are required.");
      return;
    }
    setSubmitting(true);
    try {
      await registerTeacher({
        full_name,
        email: email.trim(),
        school_id: schoolId,
        password: password.trim(),
      });
      onSuccess?.();
      onClose?.();
    } catch (err) {
      setError(err instanceof Error ? err.message : "Failed to register teacher.");
    } finally {
      setSubmitting(false);
    }
  };

  return (
    <Card>
      <CardContent>
        <form onSubmit={handleSubmit} className="grid grid-cols-1 md:grid-cols-2 gap-4" autoComplete="off">
          <div className="space-y-2">
            <Label>School (required)</Label>
            <Select value={schoolId} onValueChange={setSchoolId}>
              <SelectTrigger className="h-9">
                <SelectValue placeholder="Select school" />
              </SelectTrigger>
              <SelectContent>
                {schools.map((s) => (
                  <SelectItem key={s.id} value={s.id}>{s.name}</SelectItem>
                ))}
              </SelectContent>
            </Select>
          </div>
          <div className="space-y-2">
            <Label>Email (required)</Label>
            <Input type="email" placeholder="e.g. teacher@school.com" value={email} onChange={(e) => setEmail(e.target.value)} required autoComplete="email" />
          </div>
          <div className="space-y-2">
            <Label>Full name (required)</Label>
            <div className="flex gap-2">
              <Input placeholder="First name" value={firstName} onChange={(e) => setFirstName(e.target.value)} required autoComplete="given-name" />
              <Input placeholder="Last name" value={lastName} onChange={(e) => setLastName(e.target.value)} required autoComplete="family-name" />
            </div>
          </div>
          <div className="space-y-2">
            <Label>Password (required)</Label>
            <Input type="password" placeholder="Enter password" value={password} onChange={(e) => setPassword(e.target.value)} required autoComplete="new-password" />
          </div>
          {error && <p className="md:col-span-2 text-sm text-destructive">{error}</p>}
          <div className="md:col-span-2 flex justify-end">
            <Button type="submit" disabled={submitting}>{submitting ? "Saving…" : "Register Teacher"}</Button>
          </div>
        </form>
      </CardContent>
    </Card>
  );
};

export default {} as any;
