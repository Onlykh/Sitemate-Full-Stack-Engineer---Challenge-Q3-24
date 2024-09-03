import { Group, Burger, Image, Badge } from "@mantine/core";
import { useDisclosure } from "@mantine/hooks";
import classes from "./HeaderSearch.module.css";
import ImageLogo from "@/assets/logo.png";
import UserMenu from "@/components/buttons/UserMenu";
import DecimalFormatter from "@/components/inputs/DecimalFormatter";
import { useGetLoggedInUser } from "@/hooks/api/auth.api";

export function HeaderSearch() {
  const [opened, { toggle }] = useDisclosure(false);
  const { data: loggedInUserData, isSuccess } = useGetLoggedInUser();
  const balance = isSuccess
    ? parseFloat(loggedInUserData?.company?.ballance)
    : 0;
  return (
    <header className={classes.header}>
      <div className={classes.inner}>
        <Group>
          <Burger opened={opened} onClick={toggle} size="sm" hiddenFrom="sm" />
          <Image src={ImageLogo} alt="it's me" w={80} />
        </Group>

        <Group>
          <Badge variant="default" size="xl" radius="md">
            <DecimalFormatter suffix={"AED "} value={balance} />
          </Badge>
          <UserMenu />
        </Group>
      </div>
    </header>
  );
}
