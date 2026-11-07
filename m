Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794064040;
	b=LI4BT6byRru/ulgnwfqOldNYXrAQlOkwAW1JyZ/HPiOhNfvAdwnMEWfxbSkRYvBn5vMM
	 5oNnNT3kSC97mSx+D+9Ti/6asG1I7niFzk+znHAdORJLdlFAgrKsfL5+tcKaZkL9BvJep
	 DFt8pFYAgNfmkEc/0FWBt9tlqcIjFKGLJ/fvY5XMHMi6ZRQ0rlbn4W3RH72m75Uzah1pe
	 E9QkE3X9HE5vPUasFR+ZhHeZ+HKOW1YiNifYsASo/1+1ryy1+rA6RS2fhCX9O4uFzMwvG
	 2oBcacUIC/jSBQIaIu5KMV+pusdaCnmZ17+SaOH0hRE2vJAPlHFf11VDI7CYXAQH2PA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794064040;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=DfyPRQbQ/T2H71eZRvA3Ou8xNr72XfNODhFYlOKxj0w=;
	b=DD4MXiOzAYWDdVRtK5oY7orgOljMC1K3JM7oGiM3SR+ypuK6HVhinN3km6xPjLqAMDBQ
	 eAXz2XElf83m7oG8Lh5M0TlrnYy8kOZvYoagNq+678OHzb12DIhmD8hUSfSg03dgia/Eq
	 AgHka4OJLJU4wSgiKCVRVi0uVvx9m/T+zoUSlx7Se9YHjil/7GkGXHVgQ+gdKOC70m4M8
	 VV6dKj2fd2/GulXZBm3ef9tsgnXxQCQN0HT1/hxhmGGEWdc3pLnessbmmJJwAEMe4pHk0
	 MnbMk5qRZDyL0CeV8+MlTt+RFiBLrKFQYbmWW8bVH0FYQqvGvYqaptEBzoj4WXM1klg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Me5h2L0w;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 86A1B606A9E0;
	Sat,  7 Nov 2026 15:07:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Me5h2L0w
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 33EFB1F008A1;
	Sat,  7 Nov 2026 15:07:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794064040;
	bh=DfyPRQbQ/T2H71eZRvA3Ou8xNr72XfNODhFYlOKxj0w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Me5h2L0w6PMueJuN2bVDc4K38LzR9HXZQkuDhdgjBaE77Yo4pSdumFxLzocJFQMsn
	 pcP4Dcqnc4DVh+ubu6BnZYfwr4MmAqIBbLJFvS6kZiIi+UB1V3GldnzLQ9fGwq2PXg
	 VpMzEQ+DgJFByEnT8Ipo9sPOtXkVVWDGTgI5YEFQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Cosmin Tanislav <cosmin-gabriel.tanislav.xa@renesas.com>,
	Geert Uytterhoeven <geert+renesas@glider.be>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0166/1257] pinctrl: renesas: rzt2h: Setup IRQ in .irq_{request,release}_resources()
Date: Sat,  7 Nov 2026 08:41:02 -0500
Message-ID: <20261107134943.922050436@linuxfoundation.org>
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

[ Upstream commit d9980f93cef0f90a11f26296c68ed16b61a95ced ]

When exporting a GPIO using the deprecated sysfs GPIO API,
gpio_is_visible() calls gpiod_to_irq() to determine whether a GPIO is
IRQ-capable, which ends up using
struct gpio_irq_chip::child_to_parent_hwirq().

When using the GPIO character device, it is possible to request a line
and to dynamically switch between using it as an IRQ or as a GPIO, by
updating the edge detector.

The current struct gpio_irq_chip::child_to_parent_hwirq() implementation
makes the assumption that it will only be called with the intention of
setting up the IRQ permanently, and that it will only be released when
the IRQ domain is freed.

Since we now know that this is not the case, take the following steps in
order to properly handle that case.

Implement struct irq_chip::irq_{request,release}_resources() based on
the default GPIOCHIP_IRQ_RESOURCE_HELPERS implementations.

Move the IRQ setup and release logic inside them.

Keep the mapping logic inside ::child_to_parent_hwirq() to be able to
provide a proper HW IRQ number, but do not actually setup the IRQ.

Remove rzt2h_gpio_irq_domain_free() as its only purpose was to free the
acquired IRQs. irq_domain_free_irqs_common() will still be set up as
struct gpio_irq_chip::child_irq_domain_ops::free by
gpiochip_hierarchy_setup_domain_ops().

Cc: stable@kernel.org
Fixes: 829dde3369a9 ("pinctrl: renesas: rzt2h: Add GPIO IRQ chip to handle interrupts")
Signed-off-by: Cosmin Tanislav <cosmin-gabriel.tanislav.xa@renesas.com>
Reviewed-by: Geert Uytterhoeven <geert+renesas@glider.be>
Link: https://patch.msgid.link/20260913195654.3371385-3-cosmin-gabriel.tanislav.xa@renesas.com
Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pinctrl/renesas/pinctrl-rzt2h.c | 79 +++++++++++++++----------
 1 file changed, 49 insertions(+), 30 deletions(-)

diff --git a/drivers/pinctrl/renesas/pinctrl-rzt2h.c b/drivers/pinctrl/renesas/pinctrl-rzt2h.c
index 7b44db3d0470a..f8e64c3a015cd 100644
--- a/drivers/pinctrl/renesas/pinctrl-rzt2h.c
+++ b/drivers/pinctrl/renesas/pinctrl-rzt2h.c
@@ -1021,32 +1021,17 @@ static int rzt2h_gpio_irq_set_wake(struct irq_data *d, unsigned int on)
 	return 0;
 }
 
-static const struct irq_chip rzt2h_gpio_irqchip = {
-	.name = "rzt2h-gpio",
-	.irq_disable = rzt2h_gpio_irq_disable,
-	.irq_enable = rzt2h_gpio_irq_enable,
-	.irq_mask = irq_chip_mask_parent,
-	.irq_unmask = irq_chip_unmask_parent,
-	.irq_set_type = irq_chip_set_type_parent,
-	.irq_set_wake = rzt2h_gpio_irq_set_wake,
-	.irq_eoi = irq_chip_eoi_parent,
-	.irq_set_affinity = irq_chip_set_affinity_parent,
-	.flags = IRQCHIP_IMMUTABLE,
-	GPIOCHIP_IRQ_RESOURCE_HELPERS,
-};
-
-static int rzt2h_gpio_child_to_parent_hwirq(struct gpio_chip *gc,
-					    unsigned int child,
-					    unsigned int child_type,
-					    unsigned int *parent,
-					    unsigned int *parent_type)
+static int rzt2h_gpio_irq_request_resources(struct irq_data *d)
 {
+	struct gpio_chip *gc = irq_data_get_irq_chip_data(d);
 	struct rzt2h_pinctrl *pctrl = gpiochip_get_data(gc);
-	u8 port = RZT2H_PIN_ID_TO_PORT(child);
-	u8 pin = RZT2H_PIN_ID_TO_PIN(child);
+	irq_hw_number_t hwirq = irqd_to_hwirq(d);
+	u8 port = RZT2H_PIN_ID_TO_PORT(hwirq);
+	u8 pin = RZT2H_PIN_ID_TO_PIN(hwirq);
 	u8 parent_irq, irq_idx;
+	int ret;
 
-	parent_irq = rzt2h_gpio_irq_map[child];
+	parent_irq = rzt2h_gpio_irq_map[hwirq];
 	if (parent_irq < RZT2H_INTERRUPTS_START)
 		return -EINVAL;
 
@@ -1063,18 +1048,21 @@ static int rzt2h_gpio_child_to_parent_hwirq(struct gpio_chip *gc,
 
 	rzt2h_pinctrl_set_pfc_mode(pctrl, port, pin, PFC_FUNC_INTERRUPT);
 
-	*parent = parent_irq;
-	*parent_type = child_type;
+	ret = gpiochip_lock_as_irq(gc, hwirq);
+	if (ret) {
+		clear_bit(irq_idx, pctrl->used_irqs);
+		rzt2h_pin_write_pm(pctrl, port, pin, pctrl->saved_pm[irq_idx]);
+		rzt2h_pinctrl_set_gpio_en(pctrl, port, pin, true);
+		return ret;
+	}
 
 	return 0;
 }
 
-static void rzt2h_gpio_irq_domain_free(struct irq_domain *domain, unsigned int virq,
-				       unsigned int nr_irqs)
+static void rzt2h_gpio_irq_release_resources(struct irq_data *d)
 {
-	struct irq_data *d = irq_domain_get_irq_data(domain, virq);
 	struct gpio_chip *gc = irq_data_get_irq_chip_data(d);
-	struct rzt2h_pinctrl *pctrl = container_of(gc, struct rzt2h_pinctrl, gpio_chip);
+	struct rzt2h_pinctrl *pctrl = gpiochip_get_data(gc);
 	irq_hw_number_t hwirq = irqd_to_hwirq(d);
 	u8 port = RZT2H_PIN_ID_TO_PORT(hwirq);
 	u8 pin = RZT2H_PIN_ID_TO_PIN(hwirq);
@@ -1090,7 +1078,39 @@ static void rzt2h_gpio_irq_domain_free(struct irq_domain *domain, unsigned int v
 		rzt2h_pinctrl_set_gpio_en(pctrl, port, pin, true);
 	}
 
-	irq_domain_free_irqs_common(domain, virq, nr_irqs);
+	gpiochip_unlock_as_irq(gc, hwirq);
+}
+
+static const struct irq_chip rzt2h_gpio_irqchip = {
+	.name = "rzt2h-gpio",
+	.irq_disable = rzt2h_gpio_irq_disable,
+	.irq_enable = rzt2h_gpio_irq_enable,
+	.irq_mask = irq_chip_mask_parent,
+	.irq_unmask = irq_chip_unmask_parent,
+	.irq_set_type = irq_chip_set_type_parent,
+	.irq_set_wake = rzt2h_gpio_irq_set_wake,
+	.irq_eoi = irq_chip_eoi_parent,
+	.irq_request_resources = rzt2h_gpio_irq_request_resources,
+	.irq_release_resources = rzt2h_gpio_irq_release_resources,
+	.irq_set_affinity = irq_chip_set_affinity_parent,
+	.flags = IRQCHIP_IMMUTABLE,
+};
+
+static int rzt2h_gpio_child_to_parent_hwirq(struct gpio_chip *gc,
+					    unsigned int child,
+					    unsigned int child_type,
+					    unsigned int *parent,
+					    unsigned int *parent_type)
+{
+	u8 parent_irq = rzt2h_gpio_irq_map[child];
+
+	if (parent_irq < RZT2H_INTERRUPTS_START)
+		return -EINVAL;
+
+	*parent = parent_irq;
+	*parent_type = child_type;
+
+	return 0;
 }
 
 static void rzt2h_gpio_init_irq_valid_mask(struct gpio_chip *gc,
@@ -1158,7 +1178,6 @@ static int rzt2h_gpio_register(struct rzt2h_pinctrl *pctrl)
 		girq->parent_domain = parent_domain;
 		girq->child_to_parent_hwirq = rzt2h_gpio_child_to_parent_hwirq;
 		girq->populate_parent_alloc_arg = gpiochip_populate_parent_fwspec_twocell;
-		girq->child_irq_domain_ops.free = rzt2h_gpio_irq_domain_free;
 		girq->init_valid_mask = rzt2h_gpio_init_irq_valid_mask;
 	}
 
-- 
2.53.0



