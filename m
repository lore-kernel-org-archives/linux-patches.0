Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A2BFF30ACE1;
	Sat, 25 Oct 2025 16:19:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761409191; cv=none; b=kReWB7Cado4TklH3buK4Dbr3i1yLomLoXWQrr1RQQQzYIzYpCSJzgEn0ul4EG0th4qRrD2k+Rdo1+ggtD8XuauCLr+tvI/kLwyxVPy20Nw6/mcJdgqXGI/GlqjYhrmf0AXqmpUfA/80Ot+3pKAtQ7LuOLQuTw2C5KbOj+nf4kyA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761409191; c=relaxed/simple;
	bh=xLEtVHn1p3rV5+E0tr6l1dRZ759RXBHDgi3Lg9BFAHE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Qnu4Dg/eu3EI2s/0XU41MEflxRX6WZu0bG+i/TdXCS5U1Ns6dKpi0N3wDMf/pPZoAXpPLhNBRnAZpzi+rrJIiH5u1AHmHVQq08DO6AnMfpom57Sp2GHih31+QiadzNPOhXNWcLfpD0/Z67BXN6ZyixGh7Z9ctHzijO/sVo9NLQ0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=P/xlfYPx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="P/xlfYPx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B353DC4CEFF;
	Sat, 25 Oct 2025 16:19:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1761409191;
	bh=xLEtVHn1p3rV5+E0tr6l1dRZ759RXBHDgi3Lg9BFAHE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=P/xlfYPxAGyWZ4W6QgGpQx9jcSk5p3ivoo+x24AFpMbnkqt+GeY9pFF3+ob7I+j3n
	 x79YapJznR3lBudr8h0HgzAUnHMofbvSFEfxh4vVYQTS/JxNe6yjgU2ZT+iD8Hjdpo
	 gAKGEKA0jWMpamT3jIRWdRERdVPP6E1LGk82SsbGGsheSW+3/RYQWP+XyJTb3F+O0g
	 NdWV+Puvo4ETy9FBFhkI/izWWOTYN1haSIA1mFP2Sl34flU2AkEZIpDEHsG4efKa52
	 0KBirCUKmr3dDAfxNGg5szsr22qtqX9rWmeK8aGph8PlXBpNs+gOPTgwlMiKhgDwLf
	 GuDR4nSxxJNUA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Michael Dege <michael.dege@renesas.com>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	alexandre.f.demers@gmail.com,
	alexander.deucher@amd.com
Subject: [PATCH AUTOSEL 6.17-6.6] phy: renesas: r8a779f0-ether-serdes: add new step added to latest datasheet
Date: Sat, 25 Oct 2025 11:57:47 -0400
Message-ID: <20251025160905.3857885-236-sashal@kernel.org>
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

From: Michael Dege <michael.dege@renesas.com>

[ Upstream commit e4a8db93b5ec9bca1cc66b295544899e3afd5e86 ]

R-Car S4-8 datasheet Rev.1.20 describes some additional register
settings at the end of the initialization.

Signed-off-by: Michael Dege <michael.dege@renesas.com>
Link: https://lore.kernel.org/r/20250703-renesas-serdes-update-v4-2-1db5629cac2b@renesas.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

YES

- What changed and where
  - Adds a safe read helper for banked registers:
    `r8a779f0_eth_serdes_read32()` to mirror the existing writer
    (drivers/phy/renesas/r8a779f0-ether-serdes.c:52).
  - Extends the late init sequence to perform two datasheet‑mandated
    strobes with explicit completion waits:
    - Pulse BIT(8) in `0x00c0` (bank `0x180`), then wait for status
      `0x0100` BIT(0) to assert and deassert
      (drivers/phy/renesas/r8a779f0-ether-serdes.c:343,
      drivers/phy/renesas/r8a779f0-ether-serdes.c:345,
      drivers/phy/renesas/r8a779f0-ether-serdes.c:349).
    - Pulse BIT(4) in `0x0144` (bank `0x180`), then wait for status
      `0x0180` BIT(0) to assert and deassert
      (drivers/phy/renesas/r8a779f0-ether-serdes.c:353,
      drivers/phy/renesas/r8a779f0-ether-serdes.c:355,
      drivers/phy/renesas/r8a779f0-ether-serdes.c:359).
  - These additions are contained to
    `r8a779f0_eth_serdes_hw_init_late()` which is invoked by `.power_on`
    (drivers/phy/renesas/r8a779f0-ether-serdes.c:366,
    drivers/phy/renesas/r8a779f0-ether-serdes.c:370).

- Why this is a bug fix
  - The commit implements “additional register settings at the end of
    the initialization” per R‑Car S4‑8 datasheet Rev.1.20. Omitting
    datasheet‑required init steps is a correctness issue that can
    manifest as unreliable bring‑up, failed calibration/training, or
    intermittent link.
  - The second strobe uses register `0x0144`, already used by the driver
    as a link “restart” control (drivers/phy/renesas/r8a779f0-ether-
    serdes.c:253 to drivers/phy/renesas/r8a779f0-ether-serdes.c:255),
    reinforcing that this affects required control sequencing rather
    than adding a feature.

- Risk and containment
  - Scope is limited to the Renesas R‑Car S4‑8 Ethernet SERDES PHY
    driver; no core or ABI changes; no DT changes.
  - Waits use `readl_poll_timeout_atomic()` with a bounded timeout
    (`R8A779F0_ETH_SERDES_TIMEOUT_US` = 100ms) preventing hangs
    (drivers/phy/renesas/r8a779f0-ether-serdes.c:20,
    drivers/phy/renesas/r8a779f0-ether-serdes.c:59 to
    drivers/phy/renesas/r8a779f0-ether-serdes.c:77).
  - The registers being toggled are already part of this IP’s register
    space; `0x0144` is pre‑existing in the code path. Worst case is a
    small increase in init time; best case fixes real bring‑up issues.

- Stable policy alignment
  - Fixes a hardware initialization deficiency per the vendor datasheet;
    small, self‑contained change; minimal regression risk; confined to a
    single driver file of a specific SoC family.
  - No architectural changes, no new features, no API surface
    modifications. This matches stable backport guidelines for important
    bug fixes with low risk.

- Recommendation
  - Backport to stable trees that include this driver (i.e., where
    `drivers/phy/renesas/r8a779f0-ether-serdes.c` exists). It improves
    reliability of SERDES initialization for R‑Car S4‑8 platforms
    without broader impact.

 drivers/phy/renesas/r8a779f0-ether-serdes.c | 28 +++++++++++++++++++++
 1 file changed, 28 insertions(+)

diff --git a/drivers/phy/renesas/r8a779f0-ether-serdes.c b/drivers/phy/renesas/r8a779f0-ether-serdes.c
index 3b2d8cef75e52..4d12d091b0ab0 100644
--- a/drivers/phy/renesas/r8a779f0-ether-serdes.c
+++ b/drivers/phy/renesas/r8a779f0-ether-serdes.c
@@ -49,6 +49,13 @@ static void r8a779f0_eth_serdes_write32(void __iomem *addr, u32 offs, u32 bank,
 	iowrite32(data, addr + offs);
 }
 
+static u32 r8a779f0_eth_serdes_read32(void __iomem *addr, u32 offs,  u32 bank)
+{
+	iowrite32(bank, addr + R8A779F0_ETH_SERDES_BANK_SELECT);
+
+	return ioread32(addr + offs);
+}
+
 static int
 r8a779f0_eth_serdes_reg_wait(struct r8a779f0_eth_serdes_channel *channel,
 			     u32 offs, u32 bank, u32 mask, u32 expected)
@@ -274,6 +281,7 @@ static int r8a779f0_eth_serdes_hw_init_late(struct r8a779f0_eth_serdes_channel
 *channel)
 {
 	int ret;
+	u32 val;
 
 	ret = r8a779f0_eth_serdes_chan_setting(channel);
 	if (ret)
@@ -287,6 +295,26 @@ static int r8a779f0_eth_serdes_hw_init_late(struct r8a779f0_eth_serdes_channel
 
 	r8a779f0_eth_serdes_write32(channel->addr, 0x03d0, 0x380, 0x0000);
 
+	val = r8a779f0_eth_serdes_read32(channel->addr, 0x00c0, 0x180);
+	r8a779f0_eth_serdes_write32(channel->addr, 0x00c0, 0x180, val | BIT(8));
+	ret = r8a779f0_eth_serdes_reg_wait(channel, 0x0100, 0x180, BIT(0), 1);
+	if (ret)
+		return ret;
+	r8a779f0_eth_serdes_write32(channel->addr, 0x00c0, 0x180, val & ~BIT(8));
+	ret = r8a779f0_eth_serdes_reg_wait(channel, 0x0100, 0x180, BIT(0), 0);
+	if (ret)
+		return ret;
+
+	val = r8a779f0_eth_serdes_read32(channel->addr, 0x0144, 0x180);
+	r8a779f0_eth_serdes_write32(channel->addr, 0x0144, 0x180, val | BIT(4));
+	ret = r8a779f0_eth_serdes_reg_wait(channel, 0x0180, 0x180, BIT(0), 1);
+	if (ret)
+		return ret;
+	r8a779f0_eth_serdes_write32(channel->addr, 0x0144, 0x180, val & ~BIT(4));
+	ret = r8a779f0_eth_serdes_reg_wait(channel, 0x0180, 0x180, BIT(0), 0);
+	if (ret)
+		return ret;
+
 	return r8a779f0_eth_serdes_monitor_linkup(channel);
 }
 
-- 
2.51.0

