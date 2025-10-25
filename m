Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 80CB12045B7;
	Sat, 25 Oct 2025 16:09:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761408552; cv=none; b=JzvG9n6TU65xQGyk92FYgOBGWSLIwtXjHqFXgWrO9668knVrYIL7FlW1kV+/qVDW494wiveaJdSnq4AMDESNk3kZdj2jK6xD4ggGg+gxmo3ue2q44xIsgZSFAyVpSztrNIa1l4R4riUaPD6CPicBCYh35lamgwx2F9jtM5tSfCg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761408552; c=relaxed/simple;
	bh=LwDxuiNSRrtBtV/0YrLTHRROukhsm97JHLR6dwLRW4E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=CGufiTwvLIQBXUFwqoUrgLzKCU9G0yochYM60UanIfRu3I0IEkPr9lIhJezzO6bHzIkUTYXozINkClLSrsufOkq1QfVnBalALt7hA9V1rCCcVysEpNx58tnlw1JppC240gYGcdrq/eJTRpmgcM5nRe2p2UlrHln2pCRW85H+5GA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=UF1ZPyhL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="UF1ZPyhL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8B9CCC4CEFB;
	Sat, 25 Oct 2025 16:09:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1761408551;
	bh=LwDxuiNSRrtBtV/0YrLTHRROukhsm97JHLR6dwLRW4E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UF1ZPyhL+gKY0ZxSdbd/HbKqNbcIRrY2nZQdFamS9QAM0+o/bKbM38E6Sub1hVzeE
	 PpFX/1sXdqd1swP+nXmNIiy2IKGg9NC6XQZMTKzipaeLygyf83DXJN3c+3kfUU+xpW
	 b2PamVUGJXD1n/xCFAktrwRDGyXqd4/MlMwan5bYcFMoGEo0HGFFsXS+RNjMWQw9ld
	 edjrvpfZQ1H9UuRJZYjwUl51V6hN2mA9y4jedTcx6SAINOx6vkITNfQ29XWCN/gH3Y
	 Y3EptkqmImESknVsG/Mtg08hLaf/gP3+S5/pLSIpvOveQOIR8TDwZpPB0FJfJRHFRS
	 uL6E5UyIro9pA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Heiner Kallweit <hkallweit1@gmail.com>,
	"Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	andrew@lunn.ch,
	olteanv@gmail.com,
	netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 6.17-6.1] net: phy: fixed_phy: let fixed_phy_unregister free the phy_device
Date: Sat, 25 Oct 2025 11:53:54 -0400
Message-ID: <20251025160905.3857885-3-sashal@kernel.org>
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

[ Upstream commit a0f849c1cc6df0db9083b4c81c05a5456b1ed0fb ]

fixed_phy_register() creates and registers the phy_device. To be
symmetric, we should not only unregister, but also free the phy_device
in fixed_phy_unregister(). This allows to simplify code in users.

Note wrt of_phy_deregister_fixed_link():
put_device(&phydev->mdio.dev) and phy_device_free(phydev) are identical.

Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
Reviewed-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
Link: https://patch.msgid.link/ad8dda9a-10ed-4060-916b-3f13bdbb899d@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

YES

- Fix rationale and scope
  - The change fixes an API asymmetry and a potential memory leak:
    `fixed_phy_register()` allocates and registers a `phy_device`, but
    pre‑patch `fixed_phy_unregister()` only removed it without freeing.
    The commit makes `fixed_phy_unregister()` also free the
    `phy_device`, preventing leaks and simplifying callers.
  - The change is small and localized to fixed PHY/MDIO code; it does
    not alter uAPI or architecture.

- Core change
  - `drivers/net/phy/fixed_phy.c:230` now frees the `phy_device` after
    removal:
    - Calls `phy_device_remove(phy)`, `of_node_put(...)`,
      `fixed_phy_del(...)`, and then `phy_device_free(phy)` to drop the
      device reference and free when the refcount reaches zero.
  - `phy_device_free()` is just a `put_device(&phydev->mdio.dev)`:
    - `drivers/net/phy/phy_device.c:212` confirms that
      `phy_device_free()` equals a `put_device`, matching the commit
      note about identical behavior.

- Callers adjusted to avoid double-free
  - `drivers/net/dsa/dsa_loop.c:398` removes the explicit
    `phy_device_free(phydevs[i])` after
    `fixed_phy_unregister(phydevs[i])`.
  - `drivers/net/mdio/of_mdio.c:475` now calls only
    `fixed_phy_unregister(phydev)` followed by
    `put_device(&phydev->mdio.dev)` at `drivers/net/mdio/of_mdio.c:477`,
    which correctly drops the extra reference obtained by
    `of_phy_find_device(np)` (see `drivers/net/mdio/of_mdio.c:471`).
    This is safe because `fixed_phy_unregister()`’s `phy_device_free()`
    and the extra `put_device()` account for two separate refs (the
    device’s own and the one grabbed by `of_phy_find_device()`).

- Other in-tree users remain correct and benefit
  - Callers which already did not free explicitly remain correct and now
    won’t leak:
    - Example: `drivers/net/ethernet/faraday/ftgmac100.c:1763` calls
      `fixed_phy_unregister(phydev)` (after `phy_disconnect()`), and
      does not call `phy_device_free()`.
    - `drivers/net/ethernet/hisilicon/hibmcge/hbg_mdio.c:236` similarly
      calls only `fixed_phy_unregister((struct phy_device *)data)`.
  - We searched for all in-tree callers of `fixed_phy_unregister()` and
    `of_phy_deregister_fixed_link()` and found no remaining explicit
    frees which would cause a double free.

- Risk and stable suitability
  - Minimal regression risk: change is contained, behavior is well-
    defined, and in‑tree callers are updated or already compatible. No
    architectural changes; no uAPI impact.
  - Positive impact: fixes a likely leak for paths that didn’t free
    after unregister (e.g., NCSI fixed PHY path in `ftgmac100`).
  - Meets stable criteria: it’s a bug fix (memory management), small and
    self-contained, with low risk of regression.

 drivers/net/dsa/dsa_loop.c  | 9 +++------
 drivers/net/mdio/of_mdio.c  | 1 -
 drivers/net/phy/fixed_phy.c | 1 +
 3 files changed, 4 insertions(+), 7 deletions(-)

diff --git a/drivers/net/dsa/dsa_loop.c b/drivers/net/dsa/dsa_loop.c
index d8a35f25a4c82..ad907287a853a 100644
--- a/drivers/net/dsa/dsa_loop.c
+++ b/drivers/net/dsa/dsa_loop.c
@@ -386,13 +386,10 @@ static struct mdio_driver dsa_loop_drv = {
 
 static void dsa_loop_phydevs_unregister(void)
 {
-	unsigned int i;
-
-	for (i = 0; i < NUM_FIXED_PHYS; i++)
-		if (!IS_ERR(phydevs[i])) {
+	for (int i = 0; i < NUM_FIXED_PHYS; i++) {
+		if (!IS_ERR(phydevs[i]))
 			fixed_phy_unregister(phydevs[i]);
-			phy_device_free(phydevs[i]);
-		}
+	}
 }
 
 static int __init dsa_loop_init(void)
diff --git a/drivers/net/mdio/of_mdio.c b/drivers/net/mdio/of_mdio.c
index 98f667b121f7d..d8ca63ed87194 100644
--- a/drivers/net/mdio/of_mdio.c
+++ b/drivers/net/mdio/of_mdio.c
@@ -473,6 +473,5 @@ void of_phy_deregister_fixed_link(struct device_node *np)
 	fixed_phy_unregister(phydev);
 
 	put_device(&phydev->mdio.dev);	/* of_phy_find_device() */
-	phy_device_free(phydev);	/* fixed_phy_register() */
 }
 EXPORT_SYMBOL(of_phy_deregister_fixed_link);
diff --git a/drivers/net/phy/fixed_phy.c b/drivers/net/phy/fixed_phy.c
index 033656d574b89..b8bec7600ef8e 100644
--- a/drivers/net/phy/fixed_phy.c
+++ b/drivers/net/phy/fixed_phy.c
@@ -309,6 +309,7 @@ void fixed_phy_unregister(struct phy_device *phy)
 	phy_device_remove(phy);
 	of_node_put(phy->mdio.dev.of_node);
 	fixed_phy_del(phy->mdio.addr);
+	phy_device_free(phy);
 }
 EXPORT_SYMBOL_GPL(fixed_phy_unregister);
 
-- 
2.51.0

