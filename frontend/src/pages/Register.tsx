import { useState, FormEvent } from "react";
import { Link } from "react-router-dom";
import { motion } from "framer-motion";
import { Loader2, MapPin } from "lucide-react";
import Layout from "@/components/Layout";
import Toast from "@/components/Toast";

const Register = () => {
  const [loading, setLoading] = useState(false);
  const [errors, setErrors] = useState<Record<string, string>>({});
  const [toast, setToast] = useState<{ message: string; type: "success" | "error" } | null>(null);

  const handleSubmit = (ev: FormEvent<HTMLFormElement>) => {
    ev.preventDefault();
    const fd = new FormData(ev.currentTarget);
    const e: Record<string, string> = {};

    const fullName = (fd.get("fullName") as string)?.trim();
    if (!fullName) e.fullName = "Full name is required";
    else if (fullName.length < 2) e.fullName = "Name must be at least 2 characters";
    else if (fullName.length > 100) e.fullName = "Name must be under 100 characters";
    else if (!/^[a-zA-Z\s'-]+$/.test(fullName)) e.fullName = "Name can only contain letters, spaces, hyphens, and apostrophes";

    const email = (fd.get("email") as string)?.trim();
    if (!email) e.email = "Email is required";
    else if (!/^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(email)) e.email = "Invalid email format";
    else if (email.length > 255) e.email = "Email must be under 255 characters";

    const password = fd.get("password") as string;
    if (!password) e.password = "Password is required";
    else if (password.length < 6) e.password = "Password must be at least 6 characters";
    else if (password.length > 128) e.password = "Password must be under 128 characters";
    else if (!/(?=.*[a-z])(?=.*[A-Z])(?=.*\d)/.test(password))
      e.password = "Must include uppercase, lowercase, and a number";

    const confirmPassword = fd.get("confirmPassword") as string;
    if (!confirmPassword) e.confirmPassword = "Please confirm your password";
    else if (confirmPassword !== password) e.confirmPassword = "Passwords do not match";

    setErrors(e);
    if (Object.keys(e).length) return;

    setLoading(true);
    setTimeout(() => {
      setLoading(false);
      setToast({ message: "Registration successful!", type: "success" });
      (ev.target as HTMLFormElement).reset();
    }, 1500);
  };

  const clearError = (name: string) => {
    if (errors[name]) setErrors((prev) => { const { [name]: _, ...rest } = prev; return rest; });
  };

  const fieldClass = (name: string) =>
    `w-full px-4 py-3 rounded-xl border bg-card text-foreground text-sm transition-colors focus:outline-none focus:ring-2 focus:ring-primary/40 ${
      errors[name] ? "border-destructive" : "border-border"
    }`;

  return (
    <Layout>
      {toast && <Toast {...toast} onClose={() => setToast(null)} />}
      <div className="container mx-auto px-4 py-16 flex justify-center">
        <motion.div
          initial={{ opacity: 0, y: 20 }}
          animate={{ opacity: 1, y: 0 }}
          className="w-full max-w-md glass-card rounded-2xl p-8"
        >
          <div className="text-center mb-8">
            <div className="w-14 h-14 rounded-xl bg-primary/10 flex items-center justify-center mx-auto mb-4">
              <MapPin className="w-7 h-7 text-primary" />
            </div>
            <h1 className="text-2xl font-bold text-foreground">Create Account</h1>
            <p className="text-sm text-muted-foreground mt-1">Join the Lost & Found community</p>
          </div>

          <form onSubmit={handleSubmit} className="space-y-4">
            <div>
              <label className="block text-sm font-medium text-foreground mb-1.5">Full Name *</label>
              <input name="fullName" placeholder="John Doe" maxLength={100} onChange={() => clearError("fullName")} className={fieldClass("fullName")} />
              {errors.fullName && <p className="text-xs text-destructive mt-1">{errors.fullName}</p>}
            </div>
            <div>
              <label className="block text-sm font-medium text-foreground mb-1.5">Email *</label>
              <input name="email" type="email" placeholder="you@university.edu" maxLength={255} onChange={() => clearError("email")} className={fieldClass("email")} />
              {errors.email && <p className="text-xs text-destructive mt-1">{errors.email}</p>}
            </div>
            <div>
              <label className="block text-sm font-medium text-foreground mb-1.5">Password *</label>
              <input name="password" type="password" placeholder="Uppercase, lowercase & number" maxLength={128} onChange={() => clearError("password")} className={fieldClass("password")} />
              {errors.password && <p className="text-xs text-destructive mt-1">{errors.password}</p>}
            </div>
            <div>
              <label className="block text-sm font-medium text-foreground mb-1.5">Confirm Password *</label>
              <input name="confirmPassword" type="password" placeholder="••••••••" maxLength={128} onChange={() => clearError("confirmPassword")} className={fieldClass("confirmPassword")} />
              {errors.confirmPassword && <p className="text-xs text-destructive mt-1">{errors.confirmPassword}</p>}
            </div>
            <button
              type="submit"
              disabled={loading}
              className="w-full py-3.5 bg-primary text-primary-foreground font-semibold rounded-xl hover:opacity-90 transition-opacity disabled:opacity-60 flex items-center justify-center gap-2"
            >
              {loading ? <><Loader2 className="w-4 h-4 animate-spin" /> Creating account...</> : "Create Account"}
            </button>
          </form>

          <p className="text-center text-sm text-muted-foreground mt-6">
            Already have an account?{" "}
            <Link to="/login" className="text-primary font-medium hover:underline">Sign In</Link>
          </p>
        </motion.div>
      </div>
    </Layout>
  );
};

export default Register;
