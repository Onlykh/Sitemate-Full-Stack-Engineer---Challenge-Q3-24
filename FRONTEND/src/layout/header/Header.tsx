import { Container, Text } from "@mantine/core";
import classes from "./Header.module.css";

export function Header() {
  return (
    <header className={classes.header}>
      <Container p="md" size="md">
        <Text fw={700}>Sitemate Full Stack Engineer - Challenge Q3 24</Text>
      </Container>
    </header>
  );
}
