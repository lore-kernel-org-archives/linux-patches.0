Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795020536;
	b=pGigAzg8EbPxtOJ9Z2UlfR52hzDS/SfB6ExBumMCSLouNO+7blKz1r1Q4yhS5uv1ZXuo
	 DN+/yOfPYDCiiC7ikD0gZopKdFiIudUdm86w37atOAVv7wKfG6iBiSx2qobErLsWKEkOj
	 w6e8AAhFVFyOKkgPTKHXCqWNlp4StIR5r++69anUyZlRkwYmtvKbFtbzFoNgHufHz1X5i
	 6g3UIf8OrEVWwjEQSwaETunL7yX2/HDzJc8vLcGLuzp5YuhncP4vtoFKYXoRmpdB2Mq+m
	 +15CezLczbWvV5IAgjlQF1sxsdP9tWG1Nmyx6ViAiPw2QqYXgPRh4+LQ3/dfVRe8CBg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795020536;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=bEo341F+/uJwXZmWUEtLAfj7aSg5Nbjw/G30X/TUpDc=;
	b=KK7yxPVDHgFgSS/FzrYQ/XBI8rnKa1vzvnq5X1XITnuaYS6UVLEA9SZghIgAUZL4vTJU
	 d6vtiLRUsvU4qKN31J+QznRtbjthkNKsf4KSreR53dPiIAmzD+FoBP3LEWL1U7cBQJquE
	 5MLE+0gWV336HF5eCai5DeHid9nDfWumit5fGFSLtq3jbePhgODNZHeI6mSVA1buFjtWA
	 7S6B95cFBDCRCz/OEowmz5DkOg1+GuP5XZ4+GdfpD8ph4+wnCJlQEGt7xGDoy6TsiQJ9i
	 uk6t8b5uHTBxBTvYREW6lX69dYBWhNsz7ywal78oterDg9QT80MkCm9X8PKkd3C3Wpw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=oRo0C5wx;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 050D3606A31C;
	Wed, 18 Nov 2026 16:48:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=oRo0C5wx
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 55F5B1F000C5;
	Wed, 18 Nov 2026 16:48:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795020535;
	bh=bEo341F+/uJwXZmWUEtLAfj7aSg5Nbjw/G30X/TUpDc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=oRo0C5wxiRSoZrow77x1gFAmKviO+CrWgDkBMXyu6BLitJHPNkQ3Gt1HAOILlu9d3
	 Ywn6Gzb+YLPeUnhmhb/hdZoxF4/xd7IcoxfV1gpR+DW4GYmsjotllV/33vQ+SFronm
	 7BC3p3nzMAVAt+QVEbpyXjVX9wd9rlPbq2M46k84=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Abraham Zukor <abe@maticrobots.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1986/2651] spi: tegra114: initialize native chip selects inactive
Date: Wed, 18 Nov 2026 15:53:46 +0100
Message-ID: <20261118150357.879730182@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

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
index 5f8d8da7a3fc1..f43f2df478b45 100644
--- a/drivers/spi/spi-tegra114.c
+++ b/drivers/spi/spi-tegra114.c
@@ -1308,6 +1308,9 @@ static int tegra_spi_probe(struct platform_device *pdev)
 	struct resource		*r;
 	int ret, spi_irq;
 	int bus_num;
+	u32 conflicting_cs;
+	u32 enabled_child_cs_polarity = 0, disabled_child_cs_low = 0, disabled_child_cs_high = 0;
+	u32 enabled_cs_mask = 0;
 
 	host = devm_spi_alloc_host(&pdev->dev, sizeof(*tspi));
 	if (!host) {
@@ -1402,6 +1405,52 @@ static int tegra_spi_probe(struct platform_device *pdev)
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



