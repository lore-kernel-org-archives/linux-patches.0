Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795026971;
	b=FV7hVKKYapwAZgal8JweXbrdfFpWUFZi+qVH2GbZwBOQKaumXYqzjccmcKPI70xVPYkh
	 yLSVS6EnynN1yHdDFEP6xCL1j/7EHo7rRrzsbzBkiEr0v5RFqvGyvFQGnkOzNbjM6AgCP
	 twAk8DiqpihQvjbzbJBfaGXBcqBegN+LqnS2ukat7s0Muy/DhkS3PaB6Ln/PNqZGWqmaA
	 qX/OfqZeq8jtP87krIcJTa0P/yoEuGS6nQImMttHBsgeVWk7oyNpQpvFo8ixbM4kbeSEK
	 CUe9fi0Y/c3peF2gsWtdhKVwmVOF1IEh9RVsG4yi7knS4DpFYOvyBNt9pLHIex6E48A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795026971;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=0Uh5n9/iOJR8DoKs0dpBaWzmkXSFwmbE6pKyukCI9+U=;
	b=BAblN8lYPuJObfgskiQ0w3lK9ACmqY4sz0U2/rKMXq03YYyP4rgr+A/u2VsAGBRFtYSQ
	 4dQ7b6710IT/KXguiamjzIupKyXgc0dOAbOP+ZOnvHCNFxfmvtkQjY4SDJiyxE57x5eMu
	 PlGkCa0ezGOjc0lXrTuvycyDTZpiX+KkYjCfuXT8C1O1180aHblVD+BcVDoEOcuV8axDf
	 lgJZudpTEvfol4333Q0C5CiWekPjvFUyFNiNNsJoYEKEQZGuh9y8gfC/cfuPV1Y85xT79
	 zHtalPt1W5vnsGgnU8ECKhltQqKF3krKXaQitMyr4d4lkYhYMZ4dA3Mlg1vBvQqbW5w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=KXSz163w;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A035606A330;
	Wed, 18 Nov 2026 18:36:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=KXSz163w
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C1A7A1F000C4;
	Wed, 18 Nov 2026 18:36:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795026971;
	bh=0Uh5n9/iOJR8DoKs0dpBaWzmkXSFwmbE6pKyukCI9+U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=KXSz163whfPHgo4FH9mEJ6t+UWv9N46jZYqy2gZuv7DXdLwmlpEd5ttWembHz++5C
	 37EUk0Gs1lGC1liisRBS1yedeWW+GrcS+Z/MAZo1iZB3XKotAT8y7kioqbuGzVGLBl
	 fIAGEptMDetXy7DDpKfpZgQjQzmBnx7VzkMDm+pQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Abraham Zukor <abe@maticrobots.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1624/2151] spi: tegra114: initialize native chip selects inactive
Date: Wed, 18 Nov 2026 15:55:59 +0100
Message-ID: <20261118150221.034288544@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index b696c34d83de3..98b66105cff5e 100644
--- a/drivers/spi/spi-tegra114.c
+++ b/drivers/spi/spi-tegra114.c
@@ -1308,6 +1308,9 @@ static int tegra_spi_probe(struct platform_device *pdev)
 	struct resource		*r;
 	int ret, spi_irq;
 	int bus_num;
+	u32 conflicting_cs;
+	u32 enabled_child_cs_polarity = 0, disabled_child_cs_low = 0, disabled_child_cs_high = 0;
+	u32 enabled_cs_mask = 0;
 
 	host = spi_alloc_host(&pdev->dev, sizeof(*tspi));
 	if (!host) {
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



