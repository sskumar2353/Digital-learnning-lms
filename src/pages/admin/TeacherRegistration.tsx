import React from "react";
import DashboardLayout from "@/components/DashboardLayout";
import { Card, CardHeader, CardTitle } from "@/components/ui/card";
import { TeacherForm } from "./RegistrationForms";

const TeacherRegistration: React.FC = () => {
  return (
    <DashboardLayout title="Teacher Registration">
      <Card>
        <CardHeader>
          <CardTitle>Teacher Registration</CardTitle>
        </CardHeader>
        <div className="p-4">
          <TeacherForm />
        </div>
      </Card>
    </DashboardLayout>
  );
};

export default TeacherRegistration;
