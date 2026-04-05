import { useState, FormEvent } from "react";
import { Link } from "react-router-dom";
import { motion } from "framer-motion";
import { Loader2, MapPin } from "lucide-react";
import Layout from "@/components/Layout";
import Toast from "@/components/Toast";

const Login = () => {
  const [loading, setLoading] = useState(false);
  const [errors, setErrors] = useState<Record<string, string>>({});
  const [toast, setToast] = useState<{ message: string; type: "success" | "error" } | null>(null);

  const handleSubmit = (ev: FormEvent<HTMLFormElement>) => {
    ev.preventDefault();
    const fd = new FormData(ev.currentTarget);
    const e: Record<string, string> = {};
    const email = (fd.get("email") as string)?.trim();
    if (!email) e.email = "Email is required";
    else if (!/^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(email)) e.email = "Invalid email format";
    else if (email.length > 255) e.email = "Email must be under 255 characters";
    const password = fd.get("password") as string;
    if (!password) e.password = "Password is required";
    else if (password.length < 6) e.password = "Password must be at least 6 characters";
    setErrors(e);
    if (Object.keys(e).length) return;

    setLoading(true);
    setTimeout(() => {
      setLoading(false);
      setToast({ message: "Login successful!", type: "success" });
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
            <h1 className="text-2xl font-bold text-foreground">Welcome Back</h1>
            <p className="text-sm text-muted-foreground mt-1">Sign in to your account</p>
          </div>

          <form onSubmit={handleSubmit} className="space-y-4">
            <div>
              <label className="block text-sm font-medium text-foreground mb-1.5">Email *</label>
              <input name="email" type="email" placeholder="you@university.edu" maxLength={255} onChange={() => clearError("email")} className={fieldClass("email")} />
              {errors.email && <p className="text-xs text-destructive mt-1">{errors.email}</p>}
            </div>
            <div>
              <label className="block text-sm font-medium text-foreground mb-1.5">Password *</label>
              <input name="password" type="password" placeholder="At least 6 characters" maxLength={128} onChange={() => clearError("password")} className={fieldClass("password")} />
              {errors.password && <p className="text-xs text-destructive mt-1">{errors.password}</p>}
            </div>
            <button
              type="submit"
              disabled={loading}
              className="w-full py-3.5 bg-primary text-primary-foreground font-semibold rounded-xl hover:opacity-90 transition-opacity disabled:opacity-60 flex items-center justify-center gap-2"
            >
              {loading ? <><Loader2 className="w-4 h-4 animate-spin" /> Signing in...</> : "Sign In"}
            </button>
          </form>

          <p className="text-center text-sm text-muted-foreground mt-6">
            Don't have an account?{" "}
            <Link to="/register" className="text-primary font-medium hover:underline">Register</Link>
          </p>
        </motion.div>
      </div>
    </Layout>
  );
};

export default Login;
