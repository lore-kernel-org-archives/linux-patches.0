Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795041919;
	b=Av1K4lfIKfv5o+xvaseEIkBbojLd4jRacP6px4ENamoAcjZ1cTqp6j2zsxr5x2DGdxiT
	 7qLxHSvoH8CqDcKQXKg8nzIJq7DeE7nF76AN3tbyxYyfn7lDLnHpRMpqYllj8R/M4UrJt
	 bFHABQ20pCDCCVgSl0wx2ZlB5osJEqZNN5nmkTwSKgMODFlgLV1D56RaPkf2vHdA5Cud6
	 gnTZVw3bTEiaKdsAp7/PyxBOn/bFsLxalHgqHEPORQoMjMWM0pYJ4eJKqVfIKZcYaHM3l
	 HUSrWSHY2nV8q5edLDoUmADhMmHmfHHEapdTydO+BbHFocn0QOEBnQ5comc7WM7GO+g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795041919;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=FxUYxtSvAAM/XA5ETk5ugl4XFvq58AiMwCastQFx9yc=;
	b=P8ln8hd1AgVfZa6mw5LfgOFBzADlAGMQRs1iFDX1A30h0OKeuovr+RJDa8085N6gE4dq
	 sjD+lNK6gmuNVlRottgLZWKPvfXiGZefsmnWonH0eiSYW3t6gyvNZHvNxUqnhhcoi7Icb
	 E3cV2/8iglIYrd1vNdeEZjBvjvH0t8YDcaQdbGig7Gqf4iHcAXyiYRHzDG6IQVN8mBjJQ
	 GxpDkbXAWn25sPEIbm0yqgYYkVwbgnWQBnduQfrrT4yOM3FyJhjJNaZhuMuuvjmcCTA1N
	 NNUqtQfC3NtNjonxEu1j4rwhmcLxjv+S+ik54ioLW+d8pkygONyZV9mmr0ihjy6jUiQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=NzJvWUrw;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D980606A31C;
	Wed, 18 Nov 2026 22:45:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=NzJvWUrw
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 622071F000C4;
	Wed, 18 Nov 2026 22:45:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795041918;
	bh=FxUYxtSvAAM/XA5ETk5ugl4XFvq58AiMwCastQFx9yc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=NzJvWUrw5OrEqRBSBpNBhecXbpMrbySPlFXo80d5jHzFzAEAdVms2tnGgtuj+ctf9
	 SFfYre7luTPWisdWsaHjKq9nimVGDHKHkBJawk1n7Wlyi+qqSh2vwWjoKL1pksafvA
	 5nkF8Y2mYyo8iB3ibHzJqEIE+StLEkLS+6HIu8dI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Abraham Zukor <abe@maticrobots.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 2944/3318] spi: tegra114: initialize native chip selects inactive
Date: Wed, 18 Nov 2026 15:59:26 +0100
Message-ID: <20261118150448.660719630@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Abraham Zukor <abe@maticrobots.com>

[ Upstream commit f8334fdfd858c27f090ce597806794e4a08c9f4f ]

tegra_spi_probe() initializes SPI_COMMAND1 with only SPI_M_S, leaving
CS_POL_INACTIVE clear for every chip select. This drives every native
active-low chip select low until tegra_spi_setup() runs for that device.

SPI children are registered and probed one at a time. A synchronous
probe of an earlier child can therefore transfer while a later child's
chip select is still asserted. On a Tegra234 system with active-low
devices on CS0 and CS1, this caused both devices to be selected when the
CS1 device probed first. Its initialization then intermittently failed.
A logic analyzer showed CS0 remained low throughout the CS1 transfer and
went high only after the CS1 probe failed.

Walk the controller's device tree children before SPI_COMMAND1 is
written and set CS_POL_INACTIVE for each valid chip select without
spi-cs-high. That way the line is already deasserted when the first
child transfers and does not change level when setup runs.

Disabled children are walked too. The core only registers available
children, so tegra_spi_setup() never runs for a disabled one and probe
is the only chance to park its chip select at the level its hardware
needs.

If an enabled child shares a chip select with disabled ones, its
polarity takes priority. If only disabled children use a chip select
and they disagree, warn and leave the line inactive high.

Fixes: f333a331adfa ("spi/tegra114: add spi driver")
Assisted-by: Claude:Opus-5
Signed-off-by: Abraham Zukor <abe@maticrobots.com>
Link: https://patch.msgid.link/20261010195503.623287-1-abe@maticrobots.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spi-tegra114.c | 49 ++++++++++++++++++++++++++++++++++++++
 1 file changed, 49 insertions(+)

diff --git a/drivers/spi/spi-tegra114.c b/drivers/spi/spi-tegra114.c
index 2b7fc3e0c244e..3b0fea0821783 100644
--- a/drivers/spi/spi-tegra114.c
+++ b/drivers/spi/spi-tegra114.c
@@ -1308,6 +1308,9 @@ static int tegra_spi_probe(struct platform_device *pdev)
 	struct resource		*r;
 	int ret, spi_irq;
 	int bus_num;
+	u32 conflicting_cs;
+	u32 enabled_child_cs_polarity = 0, disabled_child_cs_low = 0, disabled_child_cs_high = 0;
+	u32 enabled_cs_mask = 0;
 
 	master = spi_alloc_master(&pdev->dev, sizeof(*tspi));
 	if (!master) {
@@ -1407,6 +1410,52 @@ static int tegra_spi_probe(struct platform_device *pdev)
 	udelay(2);
 	reset_control_deassert(tspi->rst);
 	tspi->def_command1_reg  = SPI_M_S;
+
+	/*
+	 * SPI_COMMAND1 is written before any child is registered, so a chip
+	 * select with CS_POL_INACTIVE clear stays asserted until
+	 * tegra_spi_setup() runs for that device. Program the level the
+	 * device tree asks for up front instead.
+	 *
+	 * Disabled children are included deliberately. The core never
+	 * registers them, so this is the only chance to park their chip
+	 * select at the level their hardware needs. An enabled child on the
+	 * same CS takes priority.
+	 */
+	for_each_child_of_node_scoped(pdev->dev.of_node, np) {
+		u32 cs;
+		u32 polarity_bitmask;
+		u32 cs_polarity = 0;
+
+		if (of_property_read_u32(np, "reg", &cs))
+			continue;
+
+		if (cs >= MAX_CHIP_SELECT)
+			continue;
+
+		polarity_bitmask = SPI_CS_POL_INACTIVE(cs);
+		if (!of_property_read_bool(np, "spi-cs-high"))
+			cs_polarity = polarity_bitmask;
+
+		if (of_device_is_available(np)) {
+			enabled_cs_mask |= polarity_bitmask;
+			enabled_child_cs_polarity |= cs_polarity;
+		} else {
+			if (cs_polarity)
+				disabled_child_cs_low |= polarity_bitmask;
+			else
+				disabled_child_cs_high |= polarity_bitmask;
+		}
+	}
+	conflicting_cs = disabled_child_cs_low & disabled_child_cs_high & ~enabled_cs_mask;
+	for (u32 cs = 0; cs < MAX_CHIP_SELECT; cs++) {
+		if (SPI_CS_POL_INACTIVE(cs) & conflicting_cs)
+			dev_warn(&pdev->dev,
+				 "Conflicting CS polarity on disabled nodes at cs %u\n", cs);
+	}
+
+	tspi->def_command1_reg |= enabled_child_cs_polarity |
+		(disabled_child_cs_low & ~enabled_cs_mask);
 	tegra_spi_writel(tspi, tspi->def_command1_reg, SPI_COMMAND1);
 	tspi->spi_cs_timing1 = tegra_spi_readl(tspi, SPI_CS_TIMING1);
 	tspi->spi_cs_timing2 = tegra_spi_readl(tspi, SPI_CS_TIMING2);
-- 
2.53.0



