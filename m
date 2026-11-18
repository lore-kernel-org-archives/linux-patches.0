Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795041366;
	b=CrIC+q7gI10UB4ecJZoK+/mPeJeLq0M4rMCgo1WeCiPYhdgyZB7S7g/49WmxwZjPZvxL
	 JstIJnWU5Xp2cp8uovFUGHTShGoggM+ZUaYuBsF7ww+p48cN27gkWGXqnuL98OyKznsnf
	 WZ63A1QzWW6C3MR7+0WymX/IhGvjbTuy0ZfD9kBibtO1NZ0Wl1SDDvYWdcLvJhjjA4H15
	 R7Ks1zS4IzcS5fc3393MMSfTdYhb0DjFeKsK3A/9M+JhoG5pPZ8IPW/0woVVBKq/FS3wi
	 21kNof9wTXydcdFfsgI1/gbIToPYlGBicE6XvQHMjQ1sI6HYGuzsSfkPHgAXf+RzAdw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795041366;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Al/HGNAajwzDLkJ/jGGt646tB/1gGaz7o/0HeqCT3g4=;
	b=fpZsXWK5RTd8YYa3M5DNsZL1Sb3p07IS3FeczNFO1VqVl5Bvv7tCq5eoH3lkDO9nbjGp
	 RWPcRrvtshANH11IyRPocrjVbwtlMd1Msu6atr8yWQm4KlPR7LtG08PJA6OlsIgBsUIhI
	 VmkxWUBWVZZu0IbZVYm+SbQrBqNRZC+M2SBWS93Q8JwMUnK3q43kRP65i43hrT5q6JyaL
	 RvTkkS2cpXHE4g+NeCfNrxJqR5/Saz9pq6TBlSl8brpO2epu9Bz28QugyGch/KKqySy5H
	 RGgrUzEsm3ICLbevBecQs0DQwuCmPGXOGiY17QjRJPwUkGDv3WehQmknyXXQIGUFFAQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=vDZxwRqr;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A15C8606A320;
	Wed, 18 Nov 2026 22:36:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=vDZxwRqr
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A2FF71F000C4;
	Wed, 18 Nov 2026 22:36:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795041366;
	bh=Al/HGNAajwzDLkJ/jGGt646tB/1gGaz7o/0HeqCT3g4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=vDZxwRqrm6JXCB2bpgo44gcgNvirocWiStXdr8LEGJF1/skrzK1cvNLzryfEVHWfk
	 i64VKR0yunMm/cBqbqQSOHBBEEB2RnT05Gq21VJ6ScWH01MIpBvQQNohjz8BO2Mx7C
	 SME0NetnzmDtY4qZfoisYvCP1UX7zyHxHZkcsaYo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andy Shevchenko <andy.shevchenko@gmail.com>,
	Hugo Villeneuve <hvilleneuve@dimonoff.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 2787/3318] serial: max310x: use common power function for all variants
Date: Wed, 18 Nov 2026 15:56:49 +0100
Message-ID: <20261118150444.300997343@linuxfoundation.org>
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

From: Hugo Villeneuve <hvilleneuve@dimonoff.com>

[ Upstream commit 9464833a765f66a9fbc0b972e89c1e1a13f4d3a0 ]

Simplify driver by defining a common function to handle the power
control of all variants.

Reviewed-by: Andy Shevchenko <andy.shevchenko@gmail.com>
Signed-off-by: Hugo Villeneuve <hvilleneuve@dimonoff.com>
Link: https://lore.kernel.org/r/20240118152213.2644269-15-hugo@hugovil.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Stable-dep-of: 4efacb600bf9 ("serial: max310x: fix breaks not reaching the wire in RS485 mode")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/tty/serial/max310x.c | 44 ++++++++++++++++--------------------
 1 file changed, 19 insertions(+), 25 deletions(-)

diff --git a/drivers/tty/serial/max310x.c b/drivers/tty/serial/max310x.c
index cf68a7a24f4b7..b8aae5bc6083b 100644
--- a/drivers/tty/serial/max310x.c
+++ b/drivers/tty/serial/max310x.c
@@ -269,11 +269,12 @@ struct max310x_devtype {
 		unsigned short max;
 	} slave_addr;
 	int	nr;
-	void	(*power)(struct uart_port *, int);
 	char	name[9];
 	u8	mode1;
 	u8	rev_id_val;
 	u8	rev_id_reg; /* Relevant only if rev_id_val is defined. */
+	u8	power_reg; /* Register address for power/sleep control. */
+	u8	power_bit; /* Bit for sleep or power-off mode (active high). */
 };
 
 struct max310x_one {
@@ -387,18 +388,10 @@ static int max310x_detect(struct device *dev)
 
 static void max310x_power(struct uart_port *port, int on)
 {
-	max310x_port_update(port, MAX310X_MODE1_REG,
-			    MAX310X_MODE1_FORCESLEEP_BIT,
-			    on ? 0 : MAX310X_MODE1_FORCESLEEP_BIT);
-	if (on)
-		msleep(50);
-}
+	struct max310x_port *s = dev_get_drvdata(port->dev);
 
-static void max14830_power(struct uart_port *port, int on)
-{
-	max310x_port_update(port, MAX310X_BRGCFG_REG,
-			    MAX14830_BRGCFG_CLKDIS_BIT,
-			    on ? 0 : MAX14830_BRGCFG_CLKDIS_BIT);
+	max310x_port_update(port, s->devtype->power_reg, s->devtype->power_bit,
+			    on ? 0 : s->devtype->power_bit);
 	if (on)
 		msleep(50);
 }
@@ -409,7 +402,8 @@ static const struct max310x_devtype max3107_devtype = {
 	.mode1	= MAX310X_MODE1_AUTOSLEEP_BIT | MAX310X_MODE1_IRQSEL_BIT,
 	.rev_id_val = MAX3107_REV_ID,
 	.rev_id_reg = MAX310X_REVID_REG,
-	.power	= max310x_power,
+	.power_reg = MAX310X_MODE1_REG,
+	.power_bit = MAX310X_MODE1_FORCESLEEP_BIT,
 	.slave_addr	= {
 		.min = 0x2c,
 		.max = 0x2f,
@@ -422,7 +416,8 @@ static const struct max310x_devtype max3108_devtype = {
 	.mode1	= MAX310X_MODE1_AUTOSLEEP_BIT,
 	.rev_id_val = 0, /* Unsupported. */
 	.rev_id_reg = 0, /* Irrelevant when rev_id_val is not defined. */
-	.power	= max310x_power,
+	.power_reg = MAX310X_MODE1_REG,
+	.power_bit = MAX310X_MODE1_FORCESLEEP_BIT,
 	.slave_addr	= {
 		.min = 0x60,
 		.max = 0x6f,
@@ -435,7 +430,8 @@ static const struct max310x_devtype max3109_devtype = {
 	.mode1	= MAX310X_MODE1_AUTOSLEEP_BIT,
 	.rev_id_val = MAX3109_REV_ID,
 	.rev_id_reg = MAX310X_REVID_EXTREG,
-	.power	= max310x_power,
+	.power_reg = MAX310X_MODE1_REG,
+	.power_bit = MAX310X_MODE1_FORCESLEEP_BIT,
 	.slave_addr	= {
 		.min = 0x60,
 		.max = 0x6f,
@@ -448,7 +444,8 @@ static const struct max310x_devtype max14830_devtype = {
 	.mode1	= MAX310X_MODE1_IRQSEL_BIT,
 	.rev_id_val = MAX14830_REV_ID,
 	.rev_id_reg = MAX310X_REVID_EXTREG,
-	.power	= max14830_power,
+	.power_reg = MAX310X_BRGCFG_REG,
+	.power_bit = MAX14830_BRGCFG_CLKDIS_BIT,
 	.slave_addr	= {
 		.min = 0x60,
 		.max = 0x6f,
@@ -1052,10 +1049,9 @@ static int max310x_rs485_config(struct uart_port *port, struct ktermios *termios
 
 static int max310x_startup(struct uart_port *port)
 {
-	struct max310x_port *s = dev_get_drvdata(port->dev);
 	unsigned int val;
 
-	s->devtype->power(port, 1);
+	max310x_power(port, 1);
 
 	/*
 	 * Clear a latched break: nothing clears TXBREAK when a port is
@@ -1107,12 +1103,10 @@ static int max310x_startup(struct uart_port *port)
 
 static void max310x_shutdown(struct uart_port *port)
 {
-	struct max310x_port *s = dev_get_drvdata(port->dev);
-
 	/* Disable all interrupts */
 	max310x_port_write(port, MAX310X_IRQEN_REG, 0);
 
-	s->devtype->power(port, 0);
+	max310x_power(port, 0);
 }
 
 static const char *max310x_type(struct uart_port *port)
@@ -1174,7 +1168,7 @@ static int __maybe_unused max310x_suspend(struct device *dev)
 
 	for (i = 0; i < s->devtype->nr; i++) {
 		uart_suspend_port(&max310x_uart, &s->p[i].port);
-		s->devtype->power(&s->p[i].port, 0);
+		max310x_power(&s->p[i].port, 0);
 	}
 
 	return 0;
@@ -1186,7 +1180,7 @@ static int __maybe_unused max310x_resume(struct device *dev)
 	int i;
 
 	for (i = 0; i < s->devtype->nr; i++) {
-		s->devtype->power(&s->p[i].port, 1);
+		max310x_power(&s->p[i].port, 1);
 		uart_resume_port(&max310x_uart, &s->p[i].port);
 	}
 
@@ -1431,7 +1425,7 @@ static int max310x_probe(struct device *dev, const struct max310x_devtype *devty
 		set_bit(line, max310x_lines);
 
 		/* Go to suspend mode */
-		devtype->power(&s->p[i].port, 0);
+		max310x_power(&s->p[i].port, 0);
 	}
 
 #ifdef CONFIG_GPIOLIB
@@ -1486,7 +1480,7 @@ static void max310x_remove(struct device *dev)
 		if (test_and_clear_bit(s->p[i].port.line, max310x_lines))
 			uart_remove_one_port(&max310x_uart, &s->p[i].port);
 
-		s->devtype->power(&s->p[i].port, 0);
+		max310x_power(&s->p[i].port, 0);
 	}
 
 	clk_disable_unprepare(s->clk);
-- 
2.53.0



