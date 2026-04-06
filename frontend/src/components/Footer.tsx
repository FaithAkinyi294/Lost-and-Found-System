import { MapPin } from "lucide-react";

const Footer = () => (
  <footer className="border-t border-border bg-card/50 mt-auto">
    <div className="container mx-auto px-4 py-8">
      <div className="flex flex-col md:flex-row items-center justify-between gap-4">
        <div className="flex items-center gap-2 text-primary font-bold">
          <MapPin className="w-5 h-5" />
          <span>Lost & Found System</span>
        </div>
        <p className="text-sm text-muted-foreground">
          © {new Date().getFullYear()} University Lost & Found System. All rights reserved.
        </p>
      </div>
    </div>
  </footer>
);

export default Footer;
