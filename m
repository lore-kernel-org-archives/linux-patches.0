Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E7D362459D7;
	Tue, 16 Dec 2025 11:20:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765884009; cv=none; b=U8MY5vehyIMrFOYG/w0PyOhL5mg9BSiwcDEaAA+B72R3Q75wifjgzJMDu3OEhKuI68AmM9tjt6r0j59Xx69sp5X0LIXoIqHGHBni3+4UpatXWHxjTXydJ35tcdX488lhZA+2TzyBOLhfdUdtwyYskmELBznKulpogxJdh5JjgTA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765884009; c=relaxed/simple;
	bh=pANH9Kyw4OxapbpOlLZ8VyjulaKSJE3veQit2yqa21w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Z2+gv3stch9JwiYsikPZaDZrccN96T6VOi1hUnk0FWHROrLUoatYv6X51/aNlP2zvgC8fgEcAlPOP2E05bw+Y0zs31fkIFaWlw41dudire78CZ6XyWB7P8b+1+TeHvY6ue4vJ8InVHIxBPxznzHxPwCsLdCFqfBCn3hyMAeB2VA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AZIOR+zN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AZIOR+zN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 60919C4CEF1;
	Tue, 16 Dec 2025 11:20:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765884008;
	bh=pANH9Kyw4OxapbpOlLZ8VyjulaKSJE3veQit2yqa21w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AZIOR+zNU3g+BsDqBxBWpTwxaZpspbQN3jXhNGhhFfv/WBoI/iJEXEWzFjo92/G1H
	 vbSwVpEiETXgxpGTtS70NyOVv34xZVZZHsAFM0X7Ysj/nyhVTkwBAKbqMTjYwtfXcq
	 CuDnYgxWTXMI7KiW0fhTY/zA74Rb4frNGxn9YZOc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johan Hovold <johan@kernel.org>,
	Thomas Gleixner <tglx@linutronix.de>,
	Florian Fainelli <florian.fainelli@broadcom.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 032/354] irqchip/irq-brcmstb-l2: Fix section mismatch
Date: Tue, 16 Dec 2025 12:09:59 +0100
Message-ID: <20251216111322.076328515@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251216111320.896758933@linuxfoundation.org>
References: <20251216111320.896758933@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johan Hovold <johan@kernel.org>

[ Upstream commit bbe1775924478e95372c2f896064ab6446000713 ]

Platform drivers can be probed after their init sections have been
discarded so the irqchip init callbacks must not live in init.

Fixes: 51d9db5c8fbb ("irqchip/irq-brcmstb-l2: Switch to IRQCHIP_PLATFORM_DRIVER")
Signed-off-by: Johan Hovold <johan@kernel.org>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Reviewed-by: Florian Fainelli <florian.fainelli@broadcom.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/irqchip/irq-brcmstb-l2.c | 12 ++++--------
 1 file changed, 4 insertions(+), 8 deletions(-)

diff --git a/drivers/irqchip/irq-brcmstb-l2.c b/drivers/irqchip/irq-brcmstb-l2.c
index c988886917f73..60863b2548f5a 100644
--- a/drivers/irqchip/irq-brcmstb-l2.c
+++ b/drivers/irqchip/irq-brcmstb-l2.c
@@ -168,10 +168,8 @@ static void brcmstb_l2_intc_resume(struct irq_data *d)
 	irq_gc_unlock_irqrestore(gc, flags);
 }
 
-static int __init brcmstb_l2_intc_of_init(struct device_node *np,
-					  struct device_node *parent,
-					  const struct brcmstb_intc_init_params
-					  *init_params)
+static int brcmstb_l2_intc_of_init(struct device_node *np, struct device_node *parent,
+				   const struct brcmstb_intc_init_params *init_params)
 {
 	unsigned int clr = IRQ_NOREQUEST | IRQ_NOPROBE | IRQ_NOAUTOEN;
 	unsigned int set = 0;
@@ -287,14 +285,12 @@ static int __init brcmstb_l2_intc_of_init(struct device_node *np,
 	return ret;
 }
 
-static int __init brcmstb_l2_edge_intc_of_init(struct device_node *np,
-	struct device_node *parent)
+static int brcmstb_l2_edge_intc_of_init(struct device_node *np, struct device_node *parent)
 {
 	return brcmstb_l2_intc_of_init(np, parent, &l2_edge_intc_init);
 }
 
-static int __init brcmstb_l2_lvl_intc_of_init(struct device_node *np,
-	struct device_node *parent)
+static int brcmstb_l2_lvl_intc_of_init(struct device_node *np, struct device_node *parent)
 {
 	return brcmstb_l2_intc_of_init(np, parent, &l2_lvl_intc_init);
 }
-- 
2.51.0



