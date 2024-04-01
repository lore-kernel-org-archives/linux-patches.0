Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 02423C129;
	Mon,  1 Apr 2024 16:27:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711988862; cv=none; b=VfQghCb/5DLJBpJz+R2G/35R5y2GVVXnt6csO6elX48NMAFXnSfemW4scQBPCjcTk4IV+76PhhAwCpjs9qvSd41+WOPIDyuQZZGlh5thYlUWEJrlR4zX+X46OGTLuwszC36qQ1zSweaReYMvEwxHIwyfTdHiOVRNQz7DsymZcKA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711988862; c=relaxed/simple;
	bh=zEq66HuMsW19f5ZgRCTqqclFYPfKtk6yQ07QDyoPOo4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mF0UbgVVVS9m0alZMYydcD3RtxuIw6/vlscQyAAnhHgH1Ynqws/eF8EQfreklcUHyVvtN1rWQe/nhM2ebs9BM4SSzoRpFzniVQrSc3JoLufYAZNvjqP61alb55xLpSct2tDvrDXWOCUwlMmcNu1d5MvHlsOOlxkyuVki4ZijxUo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JfDIt+0B; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JfDIt+0B"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6848FC433F1;
	Mon,  1 Apr 2024 16:27:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1711988861;
	bh=zEq66HuMsW19f5ZgRCTqqclFYPfKtk6yQ07QDyoPOo4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JfDIt+0BRl589tWk2CoEM+X/zhg/m4/fce4UUAR188wiMSHzU+jm1lY2lARYIWWKn
	 +2ZSrZJdn+XD9/zUW0RCOM/CSLsKhxioPT0Kmr4rdnqU03ikXIERDuL0EWCCXnRevb
	 EJM9d304PkVX1ayJtuBcKLoPZQBb/1STyRvPejvk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Biju Das <biju.das.jz@bp.renesas.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Geert Uytterhoeven <geert+renesas@glider.be>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 310/432] irqchip/renesas-rzg2l: Rename rzg2l_tint_eoi()
Date: Mon,  1 Apr 2024 17:44:57 +0200
Message-ID: <20240401152602.433645324@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240401152553.125349965@linuxfoundation.org>
References: <20240401152553.125349965@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

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
index 3f2f4ebfe4da6..51dda1745ffaa 100644
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



