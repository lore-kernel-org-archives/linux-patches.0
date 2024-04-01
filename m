Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0428940876;
	Mon,  1 Apr 2024 17:06:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711991182; cv=none; b=Pq4V6cT49X3lb3V7Pxqc282h/cSvEGJb2Pom03MZsJTvBNhrApvqJCik2gr3wJMydi3loCHnvt3m8jAtd+AbBebDZqJz50djmc4qi5FFlAw6IJp8ZwA8Ngs0xI180tfIudYtnr3q1rNSdMBSiF1vz8+ACSrSv/5A/VauDZ25l14=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711991182; c=relaxed/simple;
	bh=epgmo9w4CYtupKg2R/7SRhpRL59eIrqtFzhFzBWK2CI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=o5y2DI6B852jc8KB0Q18MPcuvZ9SUGPVmlEi+IlSSd6eY1w8qeGD4a/3uN4qkxQxr8YT+oSqoz1nW9GZ7xHCuxADduFFDrG9FcKvucSJPBrXZZ8lKXe9s9Z/8RjlSBtM+gfT1tPfPqXJIxk/YwkX6RxAVuHLVAWvvFkDEtvGwng=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XGSALFkN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XGSALFkN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7DF17C433C7;
	Mon,  1 Apr 2024 17:06:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1711991181;
	bh=epgmo9w4CYtupKg2R/7SRhpRL59eIrqtFzhFzBWK2CI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XGSALFkN2G67ATJOxyYrAV0fdFn87Jk/CyI2vje/zNxYIrSegJDwRvh6rNsRHk1Pi
	 /PrAuMrJkfyBxOpXiseOoXN5VMDH1fscqElRfaw4RpyuBhQ5krHGvsLdUXIP1gH2OC
	 zKX0mHulhO0XlsEZ8nvAl8j//i5l7liLea9MnUu0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Biju Das <biju.das.jz@bp.renesas.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Geert Uytterhoeven <geert+renesas@glider.be>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 188/272] irqchip/renesas-rzg2l: Rename rzg2l_tint_eoi()
Date: Mon,  1 Apr 2024 17:46:18 +0200
Message-ID: <20240401152536.735039090@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240401152530.237785232@linuxfoundation.org>
References: <20240401152530.237785232@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Biju Das <biju.das.jz@bp.renesas.com>

[ Upstream commit 7cb6362c63df233172eaecddaf9ce2ce2f769112 ]

Rename rzg2l_tint_eoi()->rzg2l_clear_tint_int() and simplify the code by
removing redundant priv and hw_irq local variables.

Signed-off-by: Biju Das <biju.das.jz@bp.renesas.com>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Reviewed-by: Geert Uytterhoeven <geert+renesas@glider.be>
Stable-dep-of: 853a6030303f ("irqchip/renesas-rzg2l: Prevent spurious interrupts when setting trigger type")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/irqchip/irq-renesas-rzg2l.c | 8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff --git a/drivers/irqchip/irq-renesas-rzg2l.c b/drivers/irqchip/irq-renesas-rzg2l.c
index a74391615ab38..ced5064eb0e9d 100644
--- a/drivers/irqchip/irq-renesas-rzg2l.c
+++ b/drivers/irqchip/irq-renesas-rzg2l.c
@@ -90,11 +90,9 @@ static void rzg2l_irq_eoi(struct irq_data *d)
 	}
 }
 
-static void rzg2l_tint_eoi(struct irq_data *d)
+static void rzg2l_clear_tint_int(struct rzg2l_irqc_priv *priv, unsigned int hwirq)
 {
-	unsigned int hw_irq = irqd_to_hwirq(d) - IRQC_TINT_START;
-	struct rzg2l_irqc_priv *priv = irq_data_to_priv(d);
-	u32 bit = BIT(hw_irq);
+	u32 bit = BIT(hwirq - IRQC_TINT_START);
 	u32 reg;
 
 	reg = readl_relaxed(priv->base + TSCR);
@@ -117,7 +115,7 @@ static void rzg2l_irqc_eoi(struct irq_data *d)
 	if (hw_irq >= IRQC_IRQ_START && hw_irq <= IRQC_IRQ_COUNT)
 		rzg2l_irq_eoi(d);
 	else if (hw_irq >= IRQC_TINT_START && hw_irq < IRQC_NUM_IRQ)
-		rzg2l_tint_eoi(d);
+		rzg2l_clear_tint_int(priv, hw_irq);
 	raw_spin_unlock(&priv->lock);
 	irq_chip_eoi_parent(d);
 }
-- 
2.43.0



