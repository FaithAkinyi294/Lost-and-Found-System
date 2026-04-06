import { useState, useMemo } from "react";
import { motion } from "framer-motion";
import { Search, MapPin, Calendar } from "lucide-react";
import Layout from "@/components/Layout";

interface Item {
  id: number;
  name: string;
  description: string;
  category: string;
  status: "Lost" | "Found";
  date: string;
  location: string;
  image?: string;
}

const sampleItems: Item[] = [
  { id: 1, name: "Black Laptop Bag", description: "Dell laptop bag with charger inside", category: "Bags", status: "Lost", date: "2026-04-01", location: "Library" },
  { id: 2, name: "Student ID Card", description: "University ID card, name: John Doe", category: "ID", status: "Found", date: "2026-04-02", location: "Cafeteria" },
  { id: 3, name: "MacBook Pro 14\"", description: "Silver MacBook Pro with stickers on the back", category: "Electronics", status: "Lost", date: "2026-03-28", location: "Lecture Hall B" },
  { id: 4, name: "Calculus Textbook", description: "Stewart Calculus 8th Edition", category: "Books", status: "Found", date: "2026-04-03", location: "Study Room 3" },
  { id: 5, name: "Blue Backpack", description: "Nike blue backpack with notebook and water bottle", category: "Bags", status: "Lost", date: "2026-03-30", location: "Gym" },
  { id: 6, name: "AirPods Pro", description: "White AirPods Pro case, slightly scratched", category: "Electronics", status: "Found", date: "2026-04-04", location: "Bus Stop" },
];

const categories = ["All", "ID", "Electronics", "Books", "Bags", "Others"];

const SearchItems = () => {
  const [query, setQuery] = useState("");
  const [category, setCategory] = useState("All");
  const [status, setStatus] = useState<"All" | "Lost" | "Found">("All");

  const filtered = useMemo(() => {
    return sampleItems.filter((item) => {
      const matchesQuery =
        !query ||
        item.name.toLowerCase().includes(query.toLowerCase()) ||
        item.description.toLowerCase().includes(query.toLowerCase());
      const matchesCategory = category === "All" || item.category === category;
      const matchesStatus = status === "All" || item.status === status;
      return matchesQuery && matchesCategory && matchesStatus;
    });
  }, [query, category, status]);

  return (
    <Layout>
      <div className="container mx-auto px-4 py-12">
        <motion.div initial={{ opacity: 0, y: 20 }} animate={{ opacity: 1, y: 0 }}>
          <h1 className="text-3xl font-bold text-foreground mb-2">Search Items</h1>
          <p className="text-muted-foreground mb-8">Browse and filter reported lost and found items.</p>

          {/* Search & Filters */}
          <div className="glass-card rounded-2xl p-5 mb-8 space-y-4">
            <div className="relative">
              <Search className="absolute left-4 top-1/2 -translate-y-1/2 w-5 h-5 text-muted-foreground" />
              <input
                value={query}
                onChange={(e) => setQuery(e.target.value)}
                placeholder="Search by name or description..."
                className="w-full pl-12 pr-4 py-3 rounded-xl border border-border bg-card text-foreground text-sm focus:outline-none focus:ring-2 focus:ring-primary/40"
              />
            </div>
            <div className="flex flex-wrap gap-3">
              <select
                value={category}
                onChange={(e) => setCategory(e.target.value)}
                className="px-4 py-2.5 rounded-xl border border-border bg-card text-foreground text-sm focus:outline-none focus:ring-2 focus:ring-primary/40"
              >
                {categories.map((c) => (
                  <option key={c} value={c}>{c === "All" ? "All Categories" : c}</option>
                ))}
              </select>
              <select
                value={status}
                onChange={(e) => setStatus(e.target.value as "All" | "Lost" | "Found")}
                className="px-4 py-2.5 rounded-xl border border-border bg-card text-foreground text-sm focus:outline-none focus:ring-2 focus:ring-primary/40"
              >
                <option value="All">All Status</option>
                <option value="Lost">Lost</option>
                <option value="Found">Found</option>
              </select>
            </div>
          </div>

          {/* Results */}
          {filtered.length === 0 ? (
            <div className="text-center py-16 text-muted-foreground">
              <Search className="w-12 h-12 mx-auto mb-4 opacity-40" />
              <p className="text-lg font-medium">No items found</p>
              <p className="text-sm">Try adjusting your search or filters</p>
            </div>
          ) : (
            <div className="grid sm:grid-cols-2 lg:grid-cols-3 gap-5">
              {filtered.map((item, i) => (
                <motion.div
                  key={item.id}
                  initial={{ opacity: 0, y: 15 }}
                  animate={{ opacity: 1, y: 0 }}
                  transition={{ delay: i * 0.05 }}
                  className="glass-card rounded-2xl overflow-hidden hover:shadow-xl transition-shadow group"
                >
                  {/* Placeholder image area */}
                  <div className="h-40 bg-gradient-to-br from-primary/10 to-primary/5 flex items-center justify-center">
                    <span className="text-4xl opacity-40">📦</span>
                  </div>
                  <div className="p-5">
                    <div className="flex items-start justify-between mb-2">
                      <h3 className="font-bold text-foreground group-hover:text-primary transition-colors">{item.name}</h3>
                      <span
                        className={`px-2.5 py-0.5 rounded-full text-xs font-semibold ${
                          item.status === "Lost"
                            ? "bg-destructive/10 text-destructive"
                            : "bg-success/10 text-success"
                        }`}
                      >
                        {item.status}
                      </span>
                    </div>
                    <p className="text-sm text-muted-foreground mb-3 line-clamp-2">{item.description}</p>
                    <div className="flex items-center gap-4 text-xs text-muted-foreground">
                      <span className="flex items-center gap-1">
                        <MapPin className="w-3.5 h-3.5" />
                        {item.location}
                      </span>
                      <span className="flex items-center gap-1">
                        <Calendar className="w-3.5 h-3.5" />
                        {item.date}
                      </span>
                    </div>
                    <button className="mt-4 w-full py-2.5 text-sm font-medium text-primary border border-primary/20 rounded-xl hover:bg-primary hover:text-primary-foreground transition-colors">
                      View Details
                    </button>
                  </div>
                </motion.div>
              ))}
            </div>
          )}
        </motion.div>
      </div>
    </Layout>
  );
};

export default SearchItems;
