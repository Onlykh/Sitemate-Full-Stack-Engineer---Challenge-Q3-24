import { AppShell, Container } from "@mantine/core";
import { Header } from "./header/Header";

type AppLayoutProps = {
  children: React.ReactNode;
};

const AppLayout = ({ children }: AppLayoutProps) => {
  return (
    <AppShell withBorder padding="md">
      <Header />
      <Container size="lg" p="md">
        {children}
      </Container>
    </AppShell>
  );
};

export default AppLayout;
