Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F00C25EF97;
	Sun, 10 Aug 2025 16:52:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754844748; cv=none; b=j6ZdqBBXFAveTV1uo8mpw/UbxshLe2ptteQ1pUI3ehLaKM9qd/ntXPW0WIlUdgc9fb6TjcfV1Nmsm+RNYepMTZMb08kDdZmREBJ4zZoYIeoE+ic8oUaoN9HqD1a94DmKWNNAqiGUaplZ4zaBhzzKsGq1J1hW57oCoN+jDasJ+gw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754844748; c=relaxed/simple;
	bh=nYgR7em2aeS0YyUudfHaKy0auQKd/qpw6ZkRCDvdQHE=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=c+mGQdXpANffrsTJ+PGNnrYdSM0VYUuL0fC/KVmIOnXO/YuMdCErTrTsIk5gZ88E45B4ohrFieAbd16JibF8vnm52Edwf5HjuDL6iXwPPKvrT3Ek8bNpu1358FdK3T3tDWggDOLCPq6QaWk9oYYn7wUttBbyxmbfYly6Lt7jT44=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ch24JM3d; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ch24JM3d"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B261DC4CEF7;
	Sun, 10 Aug 2025 16:52:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1754844748;
	bh=nYgR7em2aeS0YyUudfHaKy0auQKd/qpw6ZkRCDvdQHE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ch24JM3d4KGIhQogYDFg2M/l2WhFSVZUyieDr3V+LJ27t+lNGGN+IDB+Nu5JDd8s/
	 gOnuIO0idkD4abl3sxb59yqXSgLX258q2KXtcEyTDPxt1xgq+C+Dr5stkZIwDqD8NJ
	 QFVTuEhqUhTH3gem0Mgh8zaW4Bm+G4XZY5Lj85r2pYNlpL1igzVqxuJ2RUaXhHVPo/
	 7yHCaRBq0i9vKtGmqibFah2p/uRpLABOodsv32Ia5MIIs2jy22DyFhE0BF522H2DSb
	 LuYZlr1kQxH70v8ge3U6XzolfEShXQuMnHk3eLFMHBl0uYXhOKD0jD8ZSQOp3/0Zom
	 vhAGnfIoo4ljw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Buday Csaba <buday.csaba@prolan.hu>,
	=?UTF-8?q?Cs=C3=B3k=C3=A1s=20Bence?= <csokas.bence@prolan.hu>,
	Andrew Lunn <andrew@lunn.ch>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	hkallweit1@gmail.com,
	netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 6.16-5.4] net: phy: smsc: add proper reset flags for LAN8710A
Date: Sun, 10 Aug 2025 12:51:51 -0400
Message-Id: <20250810165158.1888206-9-sashal@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250810165158.1888206-1-sashal@kernel.org>
References: <20250810165158.1888206-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.16
Content-Transfer-Encoding: 8bit

From: Buday Csaba <buday.csaba@prolan.hu>

[ Upstream commit 57ec5a8735dc5dccd1ee68afdb1114956a3fce0d ]

According to the LAN8710A datasheet (Rev. B, section 3.8.5.1), a hardware
reset is required after power-on, and the reference clock (REF_CLK) must be
established before asserting reset.

Signed-off-by: Buday Csaba <buday.csaba@prolan.hu>
Cc: Csókás Bence <csokas.bence@prolan.hu>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Link: https://patch.msgid.link/20250728152916.46249-2-csokas.bence@prolan.hu
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

**YES**

This commit should be backported to stable kernel trees for the
following reasons:

1. **Hardware Requirement Fix**: The commit addresses a documented
   hardware requirement from the LAN8710A datasheet (section 3.8.5.1)
   that specifies a hardware reset is required after power-on with the
   reference clock established before asserting reset. This is fixing
   incorrect hardware initialization that could lead to device
   malfunction.

2. **Regression Fix**: Looking at the git history, the
   `PHY_RST_AFTER_CLK_EN` flag was:
   - Originally added in commit 7f64e5b18ebb (2017) for LAN8710/20 based
     on datasheet requirements
   - Removed in commit d65af21842f8 (2020) when refclk support was
     added, with the assumption that the refclk mechanism would handle
     the reset
   - Still present for LAN8740 (added in commit 76db2d466f6a in 2019)

   The removal in 2020 appears to have been premature, as it relied on
optional clock provider support that may not be configured in all
systems. This commit re-adds the flag specifically for LAN8710A,
restoring proper hardware initialization.

3. **Minimal and Contained Change**: The fix is a single-line addition
   of the `PHY_RST_AFTER_CLK_EN` flag to the driver structure for the
   LAN8710/LAN8720 PHY entry. This flag is already used by other PHYs in
   the same driver (LAN8740) and has well-established kernel
   infrastructure to handle it properly through
   `phy_reset_after_clk_enable()`.

4. **Bug Fix Nature**: This fixes a real hardware initialization issue
   that could cause the PHY to not work properly if the reference clock
   timing requirements aren't met. Systems without proper clock provider
   configuration would experience PHY initialization failures.

5. **Low Risk**: The change only affects the specific PHY model
   (LAN8710/LAN8720) and uses an existing, well-tested mechanism
   (`PHY_RST_AFTER_CLK_EN` flag). The flag is already successfully used
   by LAN8740 in the same driver, demonstrating its safety and
   effectiveness.

6. **Clear Problem Statement**: The commit message clearly documents the
   hardware requirement from the datasheet, making it evident this is
   fixing a specification compliance issue rather than adding a new
   feature.

The commit meets stable kernel criteria as it fixes a hardware
initialization bug with minimal risk and a very contained change scope.

 drivers/net/phy/smsc.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/phy/smsc.c b/drivers/net/phy/smsc.c
index b6489da5cfcd..48487149c225 100644
--- a/drivers/net/phy/smsc.c
+++ b/drivers/net/phy/smsc.c
@@ -785,6 +785,7 @@ static struct phy_driver smsc_phy_driver[] = {
 
 	/* PHY_BASIC_FEATURES */
 
+	.flags		= PHY_RST_AFTER_CLK_EN,
 	.probe		= smsc_phy_probe,
 
 	/* basic functions */
-- 
2.39.5

