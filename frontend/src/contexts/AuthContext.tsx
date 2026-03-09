import React, { createContext, useContext, useState, ReactNode } from "react";

type Role = "teacher" | "admin" | "student" | null;

interface AuthContextType {
  role: Role;
  userName: string;
  studentId: string | null;
  teacherId: string | null;
  login: (role: Role, name?: string, studentId?: string, teacherId?: string) => void;
  logout: () => void;
  isAuthenticated: boolean;
}

const AuthContext = createContext<AuthContextType>({
  role: null,
  userName: "",
  studentId: null,
  teacherId: null,
  login: () => {},
  logout: () => {},
  isAuthenticated: false,
});

export const useAuth = () => useContext(AuthContext);

export const AuthProvider = ({ children }: { children: ReactNode }) => {
  const [role, setRole] = useState<Role>(null);
  const [userName, setUserName] = useState("");
  const [studentId, setStudentId] = useState<string | null>(null);
  const [teacherId, setTeacherId] = useState<string | null>(null);

  const login = (r: Role, name = "", sId?: string, tId?: string) => {
    setRole(r);
    setUserName(name || (r === "admin" ? "Administrator" : r === "student" ? "Student" : "Teacher"));
    setStudentId(sId || null);
    setTeacherId(tId || null);
  };

  const logout = () => {
    setRole(null);
    setUserName("");
    setStudentId(null);
    setTeacherId(null);
  };

  return (
    <AuthContext.Provider value={{ role, userName, studentId, teacherId, login, logout, isAuthenticated: !!role }}>
      {children}
    </AuthContext.Provider>
  );
};
