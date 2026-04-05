import { Link } from "react-router-dom";
import { motion } from "framer-motion";
import { Search, FileText, CheckCircle, ArrowRight } from "lucide-react";
import Layout from "@/components/Layout";
import egertonLogo from "@/assets/egerton-logo.png";

const steps = [
  {
    icon: FileText,
    title: "Report an Item",
    description: "Submit details about a lost or found item with description, category, and optional photo.",
  },
  {
    icon: Search,
    title: "Search & Match",
    description: "Browse reported items using filters like category, date, location, and status.",
  },
  {
    icon: CheckCircle,
    title: "Recover Your Item",
    description: "Connect with the finder or owner through contact details and get your item back.",
  },
];

const Index = () => (
  <Layout>
    {/* Hero */}
    <section className="relative overflow-hidden">
      <div className="absolute inset-0 bg-gradient-to-br from-primary/5 via-transparent to-primary/10" />
      <div className="container mx-auto px-4 py-20 md:py-32 relative">
        <motion.div
          initial={{ opacity: 0, y: 30 }}
          animate={{ opacity: 1, y: 0 }}
          transition={{ duration: 0.6 }}
          className="max-w-2xl mx-auto text-center"
        >
          <div className="mb-8">
            <div className="w-28 h-28 md:w-36 md:h-36 mx-auto rounded-full bg-card shadow-xl border border-border/60 flex items-center justify-center p-3">
              <img src={egertonLogo} alt="Egerton University Logo" className="w-full h-full object-contain drop-shadow-md" />
            </div>
          </div>
          <span className="inline-block px-4 py-1.5 rounded-full bg-primary/10 text-primary text-sm font-medium mb-4">
            Egerton University — Lost & Found Platform
          </span>
          <h1 className="text-4xl md:text-6xl font-extrabold tracking-tight text-foreground mb-6 leading-tight">
            Lost Something?{" "}
            <span className="text-primary">Find It Here.</span>
          </h1>
          <p className="text-lg text-muted-foreground mb-10 max-w-lg mx-auto">
            A centralized platform for university students and staff to report, search, and recover lost items quickly and easily.
          </p>
          <div className="flex flex-col sm:flex-row gap-3 justify-center">
            <Link
              to="/report-lost"
              className="inline-flex items-center justify-center gap-2 px-6 py-3.5 bg-primary text-primary-foreground font-semibold rounded-xl hover:opacity-90 transition-opacity shadow-lg shadow-primary/25"
            >
              Report Lost Item
              <ArrowRight className="w-4 h-4" />
            </Link>
            <Link
              to="/report-found"
              className="inline-flex items-center justify-center gap-2 px-6 py-3.5 bg-card text-foreground font-semibold rounded-xl border border-border hover:bg-accent transition-colors"
            >
              Report Found Item
            </Link>
          </div>
        </motion.div>
      </div>
    </section>

    {/* How it works */}
    <section className="container mx-auto px-4 py-20">
      <div className="text-center mb-14">
        <h2 className="text-3xl font-bold text-foreground mb-3">How It Works</h2>
        <p className="text-muted-foreground">Three simple steps to recover your lost items</p>
      </div>
      <div className="grid md:grid-cols-3 gap-6 max-w-4xl mx-auto">
        {steps.map((step, i) => (
          <motion.div
            key={step.title}
            initial={{ opacity: 0, y: 20 }}
            animate={{ opacity: 1, y: 0 }}
            transition={{ delay: 0.2 + i * 0.15 }}
            className="glass-card rounded-2xl p-8 text-center hover:shadow-xl transition-shadow"
          >
            <div className="w-14 h-14 rounded-xl bg-primary/10 flex items-center justify-center mx-auto mb-5">
              <step.icon className="w-7 h-7 text-primary" />
            </div>
            <h3 className="font-bold text-lg text-foreground mb-2">{step.title}</h3>
            <p className="text-sm text-muted-foreground leading-relaxed">{step.description}</p>
          </motion.div>
        ))}
      </div>
    </section>
  </Layout>
);

export default Index;
