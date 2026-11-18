Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795049666;
	b=pZa0u4pmhMMUM37wSNq/V30dF4t5GuQZGYy2H30v8lPyeGGtJRHIM5YC48NGjytEPuSe
	 l66LAUmw9nlNfPciDX31RjWb81DmamCK1UUSPDKMnpMXD5XAFBDY0dg4sqQOiIdifXsiH
	 0UWTnJEJIOJI8qZuqKBSwEu7OVuYvKKDPzsp/kKlXfLIRwlAWpU/AuZiwesygGFcI95zr
	 cKc9mb6sszOYAkmbsvGWteOJiGMm6iJbjCh6qBEtluV/3wGeU/4Aq5QdWPAaC154v2Yti
	 GvyKSKH38HZd+P+HkcVd+oveRLj1Su6rycBQOVxl3icwphFpv0yViv9kdUtzf1Cj+3A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795049666;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=j+C7Fr74jTZ6ub5T3r5QmLORYHqv8tFggTWOEawi9cY=;
	b=rbM7/BFrXB4n3Wi8UcDsJ7Dq/g+wYNCeuNn+P32wCSzHjjt+5wrLFA+mZFh5GqDfhU8l
	 2QqWH/ylIEWxtC+1zDBEhAJgoqYYdjAEQ1VqRO94Mk5ceWL8tddQef7hfHG+l8ICl2nXh
	 xGqsrf+LLiCM37cuc/MOXOX17L6dpzuxA2tDMGePQWkgm/iuTi2hWMs7lzPZNhl/Oc+6t
	 170SVLvNmN0LP2Ddo9ndJNBZ2lrM+XeF9js7fga+m+N+xUoXjKWdQzw7ZMMilvnbsMNFN
	 i4nqdhCgBygeIECBuf+LhrmLraQptiITX5xkKagC2W3HX/qZzcOoccKa67oIQjGJYRA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ziTHhMlI;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C8B8606A325;
	Thu, 19 Nov 2026 00:54:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ziTHhMlI
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9CE0B1F000C5;
	Thu, 19 Nov 2026 00:54:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795049666;
	bh=j+C7Fr74jTZ6ub5T3r5QmLORYHqv8tFggTWOEawi9cY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ziTHhMlISqD2HVu5gYPN/+df49m7eEkVJDLYEA+MdeOAKPlrTz/a+nIiyHV0c3ypk
	 7zqBztozT9fiwGUpvx/h0ENnpg/RGDtMloew1A5R2rZuDCDp8TZf7nwUODoyzyhrCV
	 YIQYHpyX+u+7KP5TLkxNndKoFqD9LBtssck+FeX0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andy Shevchenko <andy.shevchenko@gmail.com>,
	Hugo Villeneuve <hvilleneuve@dimonoff.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 2406/2857] serial: max310x: use common detect function for all variants
Date: Wed, 18 Nov 2026 15:57:20 +0100
Message-ID: <20261118150328.172060542@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hugo Villeneuve <hvilleneuve@dimonoff.com>

[ Upstream commit 74fe93eae5389c96d4cfd4bc0cc5a547373ab96a ]

Simplify driver by defining a common function to handle the detection
of all variants.

Reviewed-by: Andy Shevchenko <andy.shevchenko@gmail.com>
Signed-off-by: Hugo Villeneuve <hvilleneuve@dimonoff.com>
Link: https://lore.kernel.org/r/20240118152213.2644269-14-hugo@hugovil.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Stable-dep-of: 4efacb600bf9 ("serial: max310x: fix breaks not reaching the wire in RS485 mode")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/tty/serial/max310x.c | 134 ++++++++++++++---------------------
 1 file changed, 54 insertions(+), 80 deletions(-)

diff --git a/drivers/tty/serial/max310x.c b/drivers/tty/serial/max310x.c
index 204ea3d16a41f..014461ce8b703 100644
--- a/drivers/tty/serial/max310x.c
+++ b/drivers/tty/serial/max310x.c
@@ -66,6 +66,7 @@
 #define MAX310X_BRGDIVMSB_REG		(0x1d) /* Baud rate divisor MSB */
 #define MAX310X_CLKSRC_REG		(0x1e) /* Clock source */
 #define MAX310X_REG_1F			(0x1f)
+#define MAX310X_EXTREG_START		(0x20) /* Only relevant in SPI mode. */
 
 #define MAX310X_REVID_REG		MAX310X_REG_1F /* Revision ID */
 
@@ -73,9 +74,9 @@
 #define MAX310X_GLOBALCMD_REG		MAX310X_REG_1F /* Global Command (WO) */
 
 /* Extended registers */
-#define MAX310X_SPI_REVID_EXTREG	MAX310X_REG_05 /* Revision ID */
-#define MAX310X_I2C_REVID_EXTREG	(0x25) /* Revision ID */
-
+#define MAX310X_REVID_EXTREG		(0x25) /* Revision ID
+						* (extended addressing space)
+						*/
 /* IRQ register bits */
 #define MAX310X_IRQ_LSR_BIT		(1 << 0) /* LSR interrupt */
 #define MAX310X_IRQ_SPCHR_BIT		(1 << 1) /* Special char interrupt */
@@ -259,8 +260,7 @@
 
 struct max310x_if_cfg {
 	int (*extended_reg_enable)(struct device *dev, bool enable);
-
-	unsigned int rev_id_reg;
+	u8 rev_id_offset;
 };
 
 struct max310x_devtype {
@@ -269,10 +269,11 @@ struct max310x_devtype {
 		unsigned short max;
 	} slave_addr;
 	int	nr;
-	int	(*detect)(struct device *);
 	void	(*power)(struct uart_port *, int);
 	char	name[9];
 	u8	mode1;
+	u8	rev_id_val;
+	u8	rev_id_reg; /* Relevant only if rev_id_val is defined. */
 };
 
 struct max310x_one {
@@ -333,62 +334,52 @@ static void max310x_port_update(struct uart_port *port, u8 reg, u8 mask, u8 val)
 	regmap_update_bits(one->regmap, reg, mask, val);
 }
 
-static int max3107_detect(struct device *dev)
+static int max310x_detect(struct device *dev)
 {
 	struct max310x_port *s = dev_get_drvdata(dev);
 	unsigned int val = 0;
 	int ret;
 
-	ret = regmap_read(s->regmap, MAX310X_REVID_REG, &val);
-	if (ret)
-		return ret;
-
-	if (((val & MAX310x_REV_MASK) != MAX3107_REV_ID)) {
-		dev_err(dev,
-			"%s ID 0x%02x does not match\n", s->devtype->name, val);
-		return -ENODEV;
-	}
+	/* Check if variant supports REV ID register: */
+	if (s->devtype->rev_id_val) {
+		u8 rev_id_reg = s->devtype->rev_id_reg;
 
-	return 0;
-}
+		/* Check if REV ID is in extended addressing space: */
+		if (s->devtype->rev_id_reg >= MAX310X_EXTREG_START) {
+			ret = s->if_cfg->extended_reg_enable(dev, true);
+			if (ret)
+				return ret;
 
-static int max3108_detect(struct device *dev)
-{
-	struct max310x_port *s = dev_get_drvdata(dev);
-	unsigned int val = 0;
-	int ret;
-
-	/* MAX3108 have not REV ID register, we just check default value
-	 * from clocksource register to make sure everything works.
-	 */
-	ret = regmap_read(s->regmap, MAX310X_CLKSRC_REG, &val);
-	if (ret)
-		return ret;
-
-	if (val != (MAX310X_CLKSRC_EXTCLK_BIT | MAX310X_CLKSRC_PLLBYP_BIT)) {
-		dev_err(dev, "%s not present\n", s->devtype->name);
-		return -ENODEV;
-	}
+			/* Adjust REV ID extended addressing space address: */
+			if (s->if_cfg->rev_id_offset)
+				rev_id_reg -= s->if_cfg->rev_id_offset;
+		}
 
-	return 0;
-}
+		regmap_read(s->regmap, rev_id_reg, &val);
 
-static int max3109_detect(struct device *dev)
-{
-	struct max310x_port *s = dev_get_drvdata(dev);
-	unsigned int val = 0;
-	int ret;
+		if (s->devtype->rev_id_reg >= MAX310X_EXTREG_START) {
+			ret = s->if_cfg->extended_reg_enable(dev, false);
+			if (ret)
+				return ret;
+		}
 
-	ret = s->if_cfg->extended_reg_enable(dev, true);
-	if (ret)
-		return ret;
+		if (((val & MAX310x_REV_MASK) != s->devtype->rev_id_val))
+			return dev_err_probe(dev, -ENODEV,
+					     "%s ID 0x%02x does not match\n",
+					     s->devtype->name, val);
+	} else {
+		/*
+		 * For variant without REV ID register, just check default value
+		 * from clocksource register to make sure everything works.
+		 */
+		ret = regmap_read(s->regmap, MAX310X_CLKSRC_REG, &val);
+		if (ret)
+			return ret;
 
-	regmap_read(s->regmap, s->if_cfg->rev_id_reg, &val);
-	s->if_cfg->extended_reg_enable(dev, false);
-	if (((val & MAX310x_REV_MASK) != MAX3109_REV_ID)) {
-		dev_err(dev,
-			"%s ID 0x%02x does not match\n", s->devtype->name, val);
-		return -ENODEV;
+		if (val != (MAX310X_CLKSRC_EXTCLK_BIT | MAX310X_CLKSRC_PLLBYP_BIT))
+			return dev_err_probe(dev, -ENODEV,
+					     "%s not present\n",
+					     s->devtype->name);
 	}
 
 	return 0;
@@ -403,27 +394,6 @@ static void max310x_power(struct uart_port *port, int on)
 		msleep(50);
 }
 
-static int max14830_detect(struct device *dev)
-{
-	struct max310x_port *s = dev_get_drvdata(dev);
-	unsigned int val = 0;
-	int ret;
-
-	ret = s->if_cfg->extended_reg_enable(dev, true);
-	if (ret)
-		return ret;
-
-	regmap_read(s->regmap, s->if_cfg->rev_id_reg, &val);
-	s->if_cfg->extended_reg_enable(dev, false);
-	if (((val & MAX310x_REV_MASK) != MAX14830_REV_ID)) {
-		dev_err(dev,
-			"%s ID 0x%02x does not match\n", s->devtype->name, val);
-		return -ENODEV;
-	}
-
-	return 0;
-}
-
 static void max14830_power(struct uart_port *port, int on)
 {
 	max310x_port_update(port, MAX310X_BRGCFG_REG,
@@ -437,7 +407,8 @@ static const struct max310x_devtype max3107_devtype = {
 	.name	= "MAX3107",
 	.nr	= 1,
 	.mode1	= MAX310X_MODE1_AUTOSLEEP_BIT | MAX310X_MODE1_IRQSEL_BIT,
-	.detect	= max3107_detect,
+	.rev_id_val = MAX3107_REV_ID,
+	.rev_id_reg = MAX310X_REVID_REG,
 	.power	= max310x_power,
 	.slave_addr	= {
 		.min = 0x2c,
@@ -449,7 +420,8 @@ static const struct max310x_devtype max3108_devtype = {
 	.name	= "MAX3108",
 	.nr	= 1,
 	.mode1	= MAX310X_MODE1_AUTOSLEEP_BIT,
-	.detect	= max3108_detect,
+	.rev_id_val = 0, /* Unsupported. */
+	.rev_id_reg = 0, /* Irrelevant when rev_id_val is not defined. */
 	.power	= max310x_power,
 	.slave_addr	= {
 		.min = 0x60,
@@ -461,7 +433,8 @@ static const struct max310x_devtype max3109_devtype = {
 	.name	= "MAX3109",
 	.nr	= 2,
 	.mode1	= MAX310X_MODE1_AUTOSLEEP_BIT,
-	.detect	= max3109_detect,
+	.rev_id_val = MAX3109_REV_ID,
+	.rev_id_reg = MAX310X_REVID_EXTREG,
 	.power	= max310x_power,
 	.slave_addr	= {
 		.min = 0x60,
@@ -473,7 +446,8 @@ static const struct max310x_devtype max14830_devtype = {
 	.name	= "MAX14830",
 	.nr	= 4,
 	.mode1	= MAX310X_MODE1_IRQSEL_BIT,
-	.detect	= max14830_detect,
+	.rev_id_val = MAX14830_REV_ID,
+	.rev_id_reg = MAX310X_REVID_EXTREG,
 	.power	= max14830_power,
 	.slave_addr	= {
 		.min = 0x60,
@@ -1371,7 +1345,7 @@ static int max310x_probe(struct device *dev, const struct max310x_devtype *devty
 	dev_set_drvdata(dev, s);
 
 	/* Check device to ensure we are talking to what we expect */
-	ret = devtype->detect(dev);
+	ret = max310x_detect(dev);
 	if (ret)
 		goto out_clk;
 
@@ -1550,7 +1524,7 @@ static int max310x_spi_extended_reg_enable(struct device *dev, bool enable)
 
 static const struct max310x_if_cfg __maybe_unused max310x_spi_if_cfg = {
 	.extended_reg_enable = max310x_spi_extended_reg_enable,
-	.rev_id_reg = MAX310X_SPI_REVID_EXTREG,
+	.rev_id_offset = MAX310X_EXTREG_START,
 };
 
 static int max310x_spi_probe(struct spi_device *spi)
@@ -1621,7 +1595,7 @@ static struct regmap_config regcfg_i2c = {
 	.writeable_reg = max310x_reg_writeable,
 	.volatile_reg = max310x_reg_volatile,
 	.precious_reg = max310x_reg_precious,
-	.max_register = MAX310X_I2C_REVID_EXTREG,
+	.max_register = MAX310X_REVID_EXTREG,
 	.writeable_noinc_reg = max310x_reg_noinc,
 	.readable_noinc_reg = max310x_reg_noinc,
 	.max_raw_read = MAX310X_FIFO_SIZE,
@@ -1630,7 +1604,7 @@ static struct regmap_config regcfg_i2c = {
 
 static const struct max310x_if_cfg max310x_i2c_if_cfg = {
 	.extended_reg_enable = max310x_i2c_extended_reg_enable,
-	.rev_id_reg = MAX310X_I2C_REVID_EXTREG,
+	.rev_id_offset = 0, /* No offset in I2C mode. */
 };
 
 static unsigned short max310x_i2c_slave_addr(unsigned short addr,
-- 
2.53.0



