Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795049696;
	b=iUTgiwZvwX32mhvxeaPAXfxPDhZ8UfuTsBzOnl5t/zXFwJFQ4Xq/++sjxdObhXf2A1tn
	 2wGI3haEw9R85Qcbqv4bR9os5gIY05QOvAzyH3uO1NGr/3KPTWLniccJmR+IZqE/4zqKc
	 L2ALDwtPPk4wNMtAH6qvOihlNHIoaGSarwDzamarsLqnEaT6z9VRG1nhQ39fuhQJiAVce
	 ZHnfSOGdpq/m9BisKwlYp6oC9MixZW2Vy9O6ANVQe/72x2r8GRZG1HzVy0yapGsZGImru
	 lEJrXYZVEnAlJZs7G+zpGPudp3OAAc6nqzBdlF4W+WG6nEL4uNIQoYhUl0qsMOouqLg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795049696;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=TXwhdygK9PF/iqcTRVrYmoqUAr02FPxwKtpqrvJpbJo=;
	b=YC+Jqa/QTLWA7KdvOCgOKGPtboKo1lJYuMTdk+DpcIsMx4KcE48obKLzvkI1XkmuEuy9
	 1L+ncDLL+JB9lXMan4+Z4chQNVTl7pyYJ44FrdNQ0N5/qBfrl+GEeVA9tq8tCN8+dBwmr
	 ypJc3e3TuA6hYCwu6GL59cnCAmwp77LXZ+RLxM3tb/zvjCSz7cAG+Ii58CXGanIsQ39rE
	 jTO3MnUzJa1zvzNPtiYqMANu6NFcxflPFKZqSO7g6a8dbN7kdM/jpC3JcDKU06TCfK3n1
	 f71LVZ+66n6nWOcpd8VoUqn/BZjWFzjg22Lax54SiSAVi9Abqi9i4tfPPkhs+/uTLrw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=sNYcDT2l;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC057606A32A;
	Thu, 19 Nov 2026 00:54:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=sNYcDT2l
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2207A1F000C5;
	Thu, 19 Nov 2026 00:54:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795049696;
	bh=TXwhdygK9PF/iqcTRVrYmoqUAr02FPxwKtpqrvJpbJo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=sNYcDT2l8ZohPPk0NUQ2InBqPTuYwSrSrBryyig/QlMlhAf0YpVRdGJxUVwee80n6
	 x69HUIwpqyvQRE6CXwGhSAxV91Id5s0J5COyaP3AlsmDXX6++TEeCX0RgwQZyv4qW1
	 WauYdMRjq6u6Qhl9gHAiIBnFJ7wigMnRklhn1AgU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andy Shevchenko <andy.shevchenko@gmail.com>,
	Hugo Villeneuve <hvilleneuve@dimonoff.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 2407/2857] serial: max310x: use common power function for all variants
Date: Wed, 18 Nov 2026 15:57:21 +0100
Message-ID: <20261118150328.209815113@linuxfoundation.org>
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
index 014461ce8b703..887451a2e215a 100644
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
@@ -1054,10 +1051,9 @@ static int max310x_rs485_config(struct uart_port *port, struct ktermios *termios
 
 static int max310x_startup(struct uart_port *port)
 {
-	struct max310x_port *s = dev_get_drvdata(port->dev);
 	unsigned int val;
 
-	s->devtype->power(port, 1);
+	max310x_power(port, 1);
 
 	/*
 	 * Clear a latched break: nothing clears TXBREAK when a port is
@@ -1109,12 +1105,10 @@ static int max310x_startup(struct uart_port *port)
 
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
@@ -1176,7 +1170,7 @@ static int __maybe_unused max310x_suspend(struct device *dev)
 
 	for (i = 0; i < s->devtype->nr; i++) {
 		uart_suspend_port(&max310x_uart, &s->p[i].port);
-		s->devtype->power(&s->p[i].port, 0);
+		max310x_power(&s->p[i].port, 0);
 	}
 
 	return 0;
@@ -1188,7 +1182,7 @@ static int __maybe_unused max310x_resume(struct device *dev)
 	int i;
 
 	for (i = 0; i < s->devtype->nr; i++) {
-		s->devtype->power(&s->p[i].port, 1);
+		max310x_power(&s->p[i].port, 1);
 		uart_resume_port(&max310x_uart, &s->p[i].port);
 	}
 
@@ -1428,7 +1422,7 @@ static int max310x_probe(struct device *dev, const struct max310x_devtype *devty
 		set_bit(line, max310x_lines);
 
 		/* Go to suspend mode */
-		devtype->power(&s->p[i].port, 0);
+		max310x_power(&s->p[i].port, 0);
 	}
 
 #ifdef CONFIG_GPIOLIB
@@ -1483,7 +1477,7 @@ static void max310x_remove(struct device *dev)
 		if (test_and_clear_bit(s->p[i].port.line, max310x_lines))
 			uart_remove_one_port(&max310x_uart, &s->p[i].port);
 
-		s->devtype->power(&s->p[i].port, 0);
+		max310x_power(&s->p[i].port, 0);
 	}
 
 	clk_disable_unprepare(s->clk);
-- 
2.53.0



