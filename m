Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1754078F36;
	Sat, 25 Oct 2025 16:17:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761409050; cv=none; b=W+WCcDdoV+FwSRYahyFKBn61Y05fgQvlj0NpyOrUpKPNEfvu/9ewCYjPXTnQmVk/u8zh989vrRx1fvWHHcMtITsqWTDqXKhlyBAYPHjkQJ6yOK1QD3CceiUK651tyOJBHyYg0cBsPPcNqElBAbdrOlp+JwPt8ffoaAqDDRLtoyU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761409050; c=relaxed/simple;
	bh=C43KW3vGlEt+q3uUBqwWjxYB5EjytjQhkqdm5zGjskc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=mPRKj7EZcRuzoqSgLRft1FU/DQsZ7tHarPVl6HusmbFIMkE0gIH9bNLHvyLXbTsB7Sd1nDOdbnP79fMEewYMk9i0y+wfbZAwaATuSIx7lLthuo4/PP0sKWa5aXWFDaoTAcI9Vluy6l1iTihABKNiSiQLomB95oKFKvWiFQllaiA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=BUmk0dkc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="BUmk0dkc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EF604C4CEF5;
	Sat, 25 Oct 2025 16:17:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1761409050;
	bh=C43KW3vGlEt+q3uUBqwWjxYB5EjytjQhkqdm5zGjskc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BUmk0dkcXk0wtz+n3FC8W+TISd+I/NW8PGt4Qx31BvxuFDCl8VYLjCUb+8EqLKrIA
	 RYC7R8mhjJijsqtd1I5tb9Wq7ceX5TxmL1AygUeiDfViL2XQBQC6QUS/IMrvRtFNP1
	 wrKsUDHP+602N356dmQA/LwyYhRYofi08LeCiJ9zqK0CZRHCCiGEUUQD7vfoXYJBOJ
	 okO5o0CnyR2sLVRByFJSihCW55RBfGlcTD23zY6MXXi+AGe8MbJVfJOpBLHG25lyUI
	 oC0tu35CJj/MRXkI1wKQ734QmtpLtgiyna7RYezccERoZv2nzHbIlUQFXYTtxDNpGd
	 UCrVVlO9lpuyg==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Heiner Kallweit <hkallweit1@gmail.com>,
	Maxime Chevallier <maxime.chevallier@bootlin.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	richardcochran@gmail.com,
	andrew@lunn.ch,
	netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 6.17] net: phy: dp83640: improve phydev and driver removal handling
Date: Sat, 25 Oct 2025 11:56:54 -0400
Message-ID: <20251025160905.3857885-183-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251025160905.3857885-1-sashal@kernel.org>
References: <20251025160905.3857885-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.17.5
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Heiner Kallweit <hkallweit1@gmail.com>

[ Upstream commit 42e2a9e11a1dcb81c83d50d18c547dc9a1c6d6ed ]

Once the last user of a clock has been removed, the clock should be
removed. So far orphaned clocks are cleaned up in dp83640_free_clocks()
only. Add the logic to remove orphaned clocks in dp83640_remove().
This allows to simplify the code, and use standard macro
module_phy_driver(). dp83640 was the last external user of
phy_driver_register(), so we can stop exporting this function afterwards.

Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
Reviewed-by: Maxime Chevallier <maxime.chevallier@bootlin.com>
Link: https://patch.msgid.link/6d4e80e7-c684-4d95-abbd-ea62b79a9a8a@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

YES
- The driver grabs a reference on the MDIO bus every time it
  instantiates a PTP clock (`drivers/net/phy/dp83640.c:956-988`),
  but—before this change—those references were only dropped from the
  module-exit helper that got deleted here. On built-in kernels or when
  the MAC unregisters its MDIO bus without unloading the PHY module,
  that meant the last PHY removal leaked the `struct dp83640_clock`, its
  `pin_config` allocation, and the extra `get_device()` reference,
  preventing clean bus teardown.
- The new removal path now tears the clock down as soon as the last PHY
  using it disappears, releasing every piece of state (`list_del`, mutex
  destruction, `put_device`, frees;
  `drivers/net/phy/dp83640.c:1486-1501`). That closes the leak for real-
  world hot-unplug and unbind scenarios while keeping the existing
  locking discipline (clock lock followed by `phyter_clocks_lock`).
- The remaining diff is the mechanical switch to `module_phy_driver()`
  (`drivers/net/phy/dp83640.c:1505-1520`); it just replaces open-coded
  init/exit hooks and doesn’t alter runtime behaviour beyond the fix
  above.
- No new functionality is introduced, and the change stays confined to
  the dp83640 PHY driver, so regression risk is low compared with the
  benefit of finally releasing the bus and memory when the PHY is
  removed.

 drivers/net/phy/dp83640.c | 58 ++++++++++++++-------------------------
 1 file changed, 20 insertions(+), 38 deletions(-)

diff --git a/drivers/net/phy/dp83640.c b/drivers/net/phy/dp83640.c
index daab555721df8..74396453f5bb2 100644
--- a/drivers/net/phy/dp83640.c
+++ b/drivers/net/phy/dp83640.c
@@ -953,30 +953,6 @@ static void decode_status_frame(struct dp83640_private *dp83640,
 	}
 }
 
-static void dp83640_free_clocks(void)
-{
-	struct dp83640_clock *clock;
-	struct list_head *this, *next;
-
-	mutex_lock(&phyter_clocks_lock);
-
-	list_for_each_safe(this, next, &phyter_clocks) {
-		clock = list_entry(this, struct dp83640_clock, list);
-		if (!list_empty(&clock->phylist)) {
-			pr_warn("phy list non-empty while unloading\n");
-			BUG();
-		}
-		list_del(&clock->list);
-		mutex_destroy(&clock->extreg_lock);
-		mutex_destroy(&clock->clock_lock);
-		put_device(&clock->bus->dev);
-		kfree(clock->caps.pin_config);
-		kfree(clock);
-	}
-
-	mutex_unlock(&phyter_clocks_lock);
-}
-
 static void dp83640_clock_init(struct dp83640_clock *clock, struct mii_bus *bus)
 {
 	INIT_LIST_HEAD(&clock->list);
@@ -1479,6 +1455,7 @@ static void dp83640_remove(struct phy_device *phydev)
 	struct dp83640_clock *clock;
 	struct list_head *this, *next;
 	struct dp83640_private *tmp, *dp83640 = phydev->priv;
+	bool remove_clock = false;
 
 	if (phydev->mdio.addr == BROADCAST_ADDR)
 		return;
@@ -1506,11 +1483,27 @@ static void dp83640_remove(struct phy_device *phydev)
 		}
 	}
 
+	if (!clock->chosen && list_empty(&clock->phylist))
+		remove_clock = true;
+
 	dp83640_clock_put(clock);
 	kfree(dp83640);
+
+	if (remove_clock) {
+		mutex_lock(&phyter_clocks_lock);
+		list_del(&clock->list);
+		mutex_unlock(&phyter_clocks_lock);
+
+		mutex_destroy(&clock->extreg_lock);
+		mutex_destroy(&clock->clock_lock);
+		put_device(&clock->bus->dev);
+		kfree(clock->caps.pin_config);
+		kfree(clock);
+	}
 }
 
-static struct phy_driver dp83640_driver = {
+static struct phy_driver dp83640_driver[] = {
+{
 	.phy_id		= DP83640_PHY_ID,
 	.phy_id_mask	= 0xfffffff0,
 	.name		= "NatSemi DP83640",
@@ -1521,26 +1514,15 @@ static struct phy_driver dp83640_driver = {
 	.config_init	= dp83640_config_init,
 	.config_intr    = dp83640_config_intr,
 	.handle_interrupt = dp83640_handle_interrupt,
+},
 };
 
-static int __init dp83640_init(void)
-{
-	return phy_driver_register(&dp83640_driver, THIS_MODULE);
-}
-
-static void __exit dp83640_exit(void)
-{
-	dp83640_free_clocks();
-	phy_driver_unregister(&dp83640_driver);
-}
+module_phy_driver(dp83640_driver);
 
 MODULE_DESCRIPTION("National Semiconductor DP83640 PHY driver");
 MODULE_AUTHOR("Richard Cochran <richardcochran@gmail.com>");
 MODULE_LICENSE("GPL");
 
-module_init(dp83640_init);
-module_exit(dp83640_exit);
-
 static const struct mdio_device_id __maybe_unused dp83640_tbl[] = {
 	{ DP83640_PHY_ID, 0xfffffff0 },
 	{ }
-- 
2.51.0

