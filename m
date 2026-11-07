Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794063992;
	b=jb/vpuwA9GS0AMRubVioDPYLIvlqT+1hXTRuUVQaoJE8dZ+tgGFj0pXj9xIVF/G2Yg/z
	 N0lU9AuApjU7UjhlpAA88LARK/EFqEqyStf2ggp7nFkIOHPz/rOTjGV8XFCa6fjM9NQFx
	 LNoBt4IuHzrmzUqA9J/hmkJLAFIpDhgholGPf0yD9UhRM+0ob7Y2FmqRaiQxCF3c51lSw
	 AjOVNdkB3UM+LW/9w3jKBPjma7X9DvD4vyVMzWqumlvInZ4n4W2EplDvcYwS0YS8efc7l
	 kOl/tL/2L28kh3L0ytvSKhZ3slxhCWKUrlprIeIzf9DNUXrTky6snkCQLhl4ACj+1YA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794063992;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=NodC98CwZFdVdpOjeU8yY18UxKPuYZuidO4AzYRmuCU=;
	b=ny1NO/L1L1mWoVctn7GNV6UudkLL6wRdEZTVvZpn7n77/es06NAt05qQJWZTCFe0rn7I
	 8HW39dS44+R8J3kqCyanl019BaE5kQKt3+fQsW8tynjD7VdFJpYWZd6TKXRoeBdtHg+14
	 8OVWXk33t8zS/dD8fQ6ZiFuOSm5n1QI4Hui1NZdnxhtF8QEKRUUEtnIP7odrYYhuuOxqV
	 Dy4NbIrPtkO6k121ZLnBxBEr54eC2glxuLqKsI32NPxJdE5pw7OvJXj5UQfPLRhJ5i116
	 21XxMr8uVxghiofbfyh+G4E7a1ozxi6VnN+84g2Rs7rDc2e6ebCc1dRVeS6+ennstfA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=qKjQjsRi;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6895F606D82B;
	Sat,  7 Nov 2026 15:06:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=qKjQjsRi
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 15FB11F008A1;
	Sat,  7 Nov 2026 15:06:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794063992;
	bh=NodC98CwZFdVdpOjeU8yY18UxKPuYZuidO4AzYRmuCU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=qKjQjsRiDRk9uttvT46LNHRRZ5JSC8ZugyeTb3cIqgrtdsxlguKfCeonf4QwVL1E4
	 yoVQfcjdmpKExK2fvHhgJS/i63otOnPontErqk+a22Rk2jGdv2YwVA7cjsqyZPfw3Y
	 7RRImop4QFCXOpl+hx6A5+e9AI5edtsReWm2VU2w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Cosmin Tanislav <cosmin-gabriel.tanislav.xa@renesas.com>,
	Geert Uytterhoeven <geert+renesas@glider.be>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0167/1257] pinctrl: renesas: rzt2h: Fix reading pin value in IRQ function
Date: Sat,  7 Nov 2026 08:41:03 -0500
Message-ID: <20261107134943.952070062@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134939.434104957@linuxfoundation.org>
References: <20261107134939.434104957@linuxfoundation.org>
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

From: Cosmin Tanislav <cosmin-gabriel.tanislav.xa@renesas.com>

[ Upstream commit 55297a587c3748f320485a3b37fcccfe6f0440bb ]

rzt2h_gpio_get() only reports a level for pins in input or output mode
and returns -EINVAL otherwise. When a pin is requested as an interrupt
it is switched to IRQ function and its I/O mode is set to Hi-Z, so its
value can no longer be read.

gpiolib calls gpiod_get_value_cansleep() to determine the edge's
direction when a line is watched with GPIO_V2_LINE_FLAG_EDGE_BOTH.
Non-zero values are translated to a rising edge, zero to a falling edge.

Since gpiod_get_value_cansleep() ends up calling rzt2h_gpio_get() which
returns -EINVAL when the pin is in IRQ function, every edge is reported
as rising.

When using the IRQ function, the input buffers are enabled and the PINm
registers reflect the live state of the input.

Report the input level even when the pin is used as an IRQ.

Cc: stable@kernel.org
Fixes: 829dde3369a9 ("pinctrl: renesas: rzt2h: Add GPIO IRQ chip to handle interrupts")
Signed-off-by: Cosmin Tanislav <cosmin-gabriel.tanislav.xa@renesas.com>
Reviewed-by: Geert Uytterhoeven <geert+renesas@glider.be>
Link: https://patch.msgid.link/20260913195654.3371385-4-cosmin-gabriel.tanislav.xa@renesas.com
Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pinctrl/renesas/pinctrl-rzt2h.c | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/drivers/pinctrl/renesas/pinctrl-rzt2h.c b/drivers/pinctrl/renesas/pinctrl-rzt2h.c
index f8e64c3a015cd..5cfce6d68cd98 100644
--- a/drivers/pinctrl/renesas/pinctrl-rzt2h.c
+++ b/drivers/pinctrl/renesas/pinctrl-rzt2h.c
@@ -171,6 +171,16 @@ static int rzt2h_validate_pin(struct rzt2h_pinctrl *pctrl, unsigned int offset)
 	return (pincfg & BIT(pin)) ? 0 : -EINVAL;
 }
 
+static bool rzt2h_pin_mode_is_peripheral(struct rzt2h_pinctrl *pctrl, u8 port, u8 bit)
+{
+	return rzt2h_pinctrl_readb(pctrl, port, PMC(port)) & BIT(bit);
+}
+
+static bool rzt2h_pin_read_input(struct rzt2h_pinctrl *pctrl, u8 port, u8 bit)
+{
+	return rzt2h_pinctrl_readb(pctrl, port, PIN(port)) & BIT(bit);
+}
+
 static u8 rzt2h_pin_read_pm(struct rzt2h_pinctrl *pctrl, u8 port, u8 pin)
 {
 	u16 reg = rzt2h_pinctrl_readw(pctrl, port, PM(port));
@@ -848,6 +858,9 @@ static int rzt2h_gpio_get(struct gpio_chip *chip, unsigned int offset)
 	u8 bit = RZT2H_PIN_ID_TO_PIN(offset);
 	u16 reg;
 
+	if (rzt2h_pin_mode_is_peripheral(pctrl, port, bit))
+		return rzt2h_pin_read_input(pctrl, port, bit);
+
 	reg = rzt2h_pinctrl_readw(pctrl, port, PM(port));
 	reg = (reg >> (bit * 2)) & PM_MASK;
 	if (reg & PM_INPUT)
-- 
2.53.0



