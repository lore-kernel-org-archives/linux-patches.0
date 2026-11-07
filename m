Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794063984;
	b=UfJp4vYVeP/WuCdfL2J2qU2yYJXeMUHrwBwULY+ZZnFaq7W6MtdEBL/Tvrpi5hkbk6aT
	 kJcehDh332TY8KtEO0zb2ZerWvV11NylGs07bF2hcTNIMo0uu3PwEUn28NRVmpwVjIvXa
	 UwFJCyxymZYOqA1Xs49kRLBRYwpF47pVlcwzArk03dg9Gm0NTLpsMXBrU6MNxoI7VoALp
	 jgU328IOg744zgL4n0B3NsjH3ZEFn/52sgRjYJ2Cjydy/ISo7d6zVjur/afy9KZSg9/WJ
	 XedopmPawYfHB5Cxs2uVG2XBn86fgeWrzUPR8ziU00ZGtmE6yU3XEq2CCaC/NUEv9bw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794063984;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=sP35i1IvGniSXs8C56Ofy04BqRLfBOKFq2JwQLTiW/E=;
	b=AdeFXi66fRLX1ofbLReNn2V6dAZ6UFobuM0Mgg6O73pE78v9YusYu+KLiInnj6mEnCRU
	 TcSFI8zY/HqPrg5jYLN9E+yxaMSlhAUYvkmN816AGx2M5AzrZguveFMpCXoebEOphkhum
	 bhGlIbBYR7whPWnmoOED7WEsXPeWHNCoBn+bzGTd8wd1bnxjwhK11YgnQnhi1atdUiDBY
	 YB64wed9+Nfl6+A7kBqvIG68t1RYfKU7u/X59Qjr1NgdjLUeYYCBuDdas4J8UdEKgqOre
	 Nl5aFX97mnkx8tVAt4lQVnmqg9OKXUr+Xk5R0pLncfqrmG4qoy0J8cBDGuGDnsvWHzQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=NinCstfh;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 39D1A60A260A;
	Sat,  7 Nov 2026 15:06:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=NinCstfh
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DC44B1F0089F;
	Sat,  7 Nov 2026 15:06:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794063984;
	bh=sP35i1IvGniSXs8C56Ofy04BqRLfBOKFq2JwQLTiW/E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=NinCstfhbHP21zOrQOfAyBse8lMElHz3x10TeJDdpviyX3kkrAZrW1A7ZK93YdtD8
	 ajxds8yv5iIwZPQfRuNtlzA1nPKJalCdTPksHZ1BsCHAQge9gIMIPm8FE+ctaHm5q8
	 IAQFh2fL60Am5V18FT1m6fUIv7ch7gZJIoVB0jh4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Cosmin Tanislav <cosmin-gabriel.tanislav.xa@renesas.com>,
	Geert Uytterhoeven <geert+renesas@glider.be>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0165/1257] pinctrl: renesas: rzt2h: Restore correct pin mode on IRQ free
Date: Sat,  7 Nov 2026 08:41:01 -0500
Message-ID: <20261107134943.893261559@linuxfoundation.org>
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

[ Upstream commit 7df755632142e59a5aec5f85f2654add49220102 ]

rzt2h_gpio_irq_domain_free() calls rzt2h_pinctrl_set_gpio_en() with
false leaving the pin in interrupt function instead of returning it to
GPIO mode.

Pass true to rzt2h_pinctrl_set_gpio_en() to take the pin out of
interrupt function after we're done using it as an IRQ.

rzt2h_pinctrl_set_pfc_mode() switches the pin to Hi-Z, losing the
previous PM value.

Save the PM value before switching to Hi-Z, and restore it after the
IRQ is freed.

Cc: stable@kernel.org
Fixes: 829dde3369a9 ("pinctrl: renesas: rzt2h: Add GPIO IRQ chip to handle interrupts")
Signed-off-by: Cosmin Tanislav <cosmin-gabriel.tanislav.xa@renesas.com>
Reviewed-by: Geert Uytterhoeven <geert+renesas@glider.be>
Link: https://patch.msgid.link/20260913195654.3371385-2-cosmin-gabriel.tanislav.xa@renesas.com
Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pinctrl/renesas/pinctrl-rzt2h.c | 43 +++++++++++++++++++++----
 1 file changed, 37 insertions(+), 6 deletions(-)

diff --git a/drivers/pinctrl/renesas/pinctrl-rzt2h.c b/drivers/pinctrl/renesas/pinctrl-rzt2h.c
index a37f1e3994467..7b44db3d0470a 100644
--- a/drivers/pinctrl/renesas/pinctrl-rzt2h.c
+++ b/drivers/pinctrl/renesas/pinctrl-rzt2h.c
@@ -96,6 +96,7 @@ struct rzt2h_pinctrl {
 	struct gpio_chip		gpio_chip;
 	struct pinctrl_gpio_range	gpio_range;
 	DECLARE_BITMAP(used_irqs, RZT2H_INTERRUPTS_NUM);
+	u8				saved_pm[RZT2H_INTERRUPTS_NUM];
 	raw_spinlock_t			lock; /* lock read/write registers */
 	struct mutex			mutex; /* serialize adding groups and functions */
 	bool				safety_port_enabled;
@@ -170,6 +171,26 @@ static int rzt2h_validate_pin(struct rzt2h_pinctrl *pctrl, unsigned int offset)
 	return (pincfg & BIT(pin)) ? 0 : -EINVAL;
 }
 
+static u8 rzt2h_pin_read_pm(struct rzt2h_pinctrl *pctrl, u8 port, u8 pin)
+{
+	u16 reg = rzt2h_pinctrl_readw(pctrl, port, PM(port));
+
+	return field_get(PM_PIN_MASK(pin), reg);
+}
+
+static void rzt2h_pin_write_pm(struct rzt2h_pinctrl *pctrl, u8 port, u8 pin,
+			       unsigned int pm)
+{
+	u16 reg;
+
+	guard(raw_spinlock_irqsave)(&pctrl->lock);
+
+	reg = rzt2h_pinctrl_readw(pctrl, port, PM(port));
+	reg &= ~PM_PIN_MASK(pin);
+	reg |= pm << (pin * 2);
+	rzt2h_pinctrl_writew(pctrl, port, reg, PM(port));
+}
+
 static void rzt2h_pinctrl_set_gpio_en(struct rzt2h_pinctrl *pctrl,
 				      u8 port, u8 pin, bool en)
 {
@@ -1023,16 +1044,23 @@ static int rzt2h_gpio_child_to_parent_hwirq(struct gpio_chip *gc,
 	struct rzt2h_pinctrl *pctrl = gpiochip_get_data(gc);
 	u8 port = RZT2H_PIN_ID_TO_PORT(child);
 	u8 pin = RZT2H_PIN_ID_TO_PIN(child);
-	u8 parent_irq;
+	u8 parent_irq, irq_idx;
 
 	parent_irq = rzt2h_gpio_irq_map[child];
 	if (parent_irq < RZT2H_INTERRUPTS_START)
 		return -EINVAL;
 
-	if (test_and_set_bit(parent_irq - RZT2H_INTERRUPTS_START,
-			     pctrl->used_irqs))
+	irq_idx = parent_irq - RZT2H_INTERRUPTS_START;
+	if (test_and_set_bit(irq_idx, pctrl->used_irqs))
 		return -EBUSY;
 
+	/*
+	 * rzt2h_pinctrl_set_pfc_mode() sets PM to Hi-Z before switching to the
+	 * interrupt function, losing the previous PM value.
+	 * Save it so it can be restored when the IRQ is freed.
+	 */
+	pctrl->saved_pm[irq_idx] = rzt2h_pin_read_pm(pctrl, port, pin);
+
 	rzt2h_pinctrl_set_pfc_mode(pctrl, port, pin, PFC_FUNC_INTERRUPT);
 
 	*parent = parent_irq;
@@ -1050,14 +1078,17 @@ static void rzt2h_gpio_irq_domain_free(struct irq_domain *domain, unsigned int v
 	irq_hw_number_t hwirq = irqd_to_hwirq(d);
 	u8 port = RZT2H_PIN_ID_TO_PORT(hwirq);
 	u8 pin = RZT2H_PIN_ID_TO_PIN(hwirq);
-	u8 parent_irq;
+	u8 parent_irq, irq_idx;
 
 	parent_irq = rzt2h_gpio_irq_map[hwirq];
 	if (parent_irq < RZT2H_INTERRUPTS_START)
 		return;
 
-	if (test_and_clear_bit(parent_irq - RZT2H_INTERRUPTS_START, pctrl->used_irqs))
-		rzt2h_pinctrl_set_gpio_en(pctrl, port, pin, false);
+	irq_idx = parent_irq - RZT2H_INTERRUPTS_START;
+	if (test_and_clear_bit(irq_idx, pctrl->used_irqs)) {
+		rzt2h_pin_write_pm(pctrl, port, pin, pctrl->saved_pm[irq_idx]);
+		rzt2h_pinctrl_set_gpio_en(pctrl, port, pin, true);
+	}
 
 	irq_domain_free_irqs_common(domain, virq, nr_irqs);
 }
-- 
2.53.0



