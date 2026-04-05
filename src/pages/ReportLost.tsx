import { useEffect } from "react";

// Redirect to the HTML page that renders properly
const ReportLost = () => {
  useEffect(() => {
    window.location.href = "/ReportLost.html";
  }, []);

  return (
    <div className="flex items-center justify-center min-h-screen">
      <div className="text-center">
        <div className="animate-spin rounded-full h-12 w-12 border-b-2 border-primary mx-auto mb-4"></div>
        <p className="text-muted-foreground">Redirecting to Report Lost form...</p>
      </div>
    </div>
  );
};

export default ReportLost;
