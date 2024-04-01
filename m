Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A43774AEDF;
	Mon,  1 Apr 2024 17:06:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711991185; cv=none; b=V5G5VNM7wxoS8zIHI0YCg92Bk1Udp60vzwStrhOb/DMx2hEwCnGA9ztdF5xzK/3uJ19/YikXeQ7CHcWbVsP6Z7Nsjf7YBt9XY6H+++EyTkMZP72KVoezmh/cj45yb8Kj/D9b0YnyGvIERg44euUYp2gRTMPBuFIK4C3ydzJd0Fo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711991185; c=relaxed/simple;
	bh=LSMLb0h7Z9OlNuBFzHOJOz3Ww6IalGwQzFw+6lxGHv4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YOMRAwC1l6tgv/YSbaQl382ZzRbiHaSQI/oF+IZ0FGtpvj5K07shbPbQ0upxzTVGA41S0DDx69qtzafx7dzO7Pmo4YY/TRzINaKuWFFDq7vAaAN/GOifFTOdjIGaVK0CcV6fO9Jyv9ZFIVx9H0hkHWJ+J+d5sB9BBD1BG13zU28=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KH4UMj8G; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KH4UMj8G"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1AE07C433C7;
	Mon,  1 Apr 2024 17:06:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1711991185;
	bh=LSMLb0h7Z9OlNuBFzHOJOz3Ww6IalGwQzFw+6lxGHv4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KH4UMj8Gg/MIox4ugzMGTXzrU+Z7Uv3sS436YkgGcOU21NLtHqfzbJnmx2R5JqlY0
	 +l2haOMKmmAyVnEQ0rYUN+YJvTThxyV5FQOsXXaPCYoj0GFIYDBN96xuAp2fNrfcb8
	 F0Xi1iyfwaxljVJ1ssAFD1B4575qKuvR2RTfLXb4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Geert Uytterhoeven <geert+renesas@glider.be>,
	Biju Das <biju.das.jz@bp.renesas.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 189/272] irqchip/renesas-rzg2l: Rename rzg2l_irq_eoi()
Date: Mon,  1 Apr 2024 17:46:19 +0200
Message-ID: <20240401152536.773655939@linuxfoundation.org>
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

[ Upstream commit b4b5cd61a6fdd92ede0dc39f0850a182affd1323 ]

Rename rzg2l_irq_eoi()->rzg2l_clear_irq_int() and simplify the code by
removing redundant priv local variable.

Suggested-by: Geert Uytterhoeven <geert+renesas@glider.be>
Signed-off-by: Biju Das <biju.das.jz@bp.renesas.com>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Stable-dep-of: 853a6030303f ("irqchip/renesas-rzg2l: Prevent spurious interrupts when setting trigger type")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/irqchip/irq-renesas-rzg2l.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/irqchip/irq-renesas-rzg2l.c b/drivers/irqchip/irq-renesas-rzg2l.c
index ced5064eb0e9d..aa27335ab2eec 100644
--- a/drivers/irqchip/irq-renesas-rzg2l.c
+++ b/drivers/irqchip/irq-renesas-rzg2l.c
@@ -66,10 +66,9 @@ static struct rzg2l_irqc_priv *irq_data_to_priv(struct irq_data *data)
 	return data->domain->host_data;
 }
 
-static void rzg2l_irq_eoi(struct irq_data *d)
+static void rzg2l_clear_irq_int(struct rzg2l_irqc_priv *priv, unsigned int hwirq)
 {
-	unsigned int hw_irq = irqd_to_hwirq(d) - IRQC_IRQ_START;
-	struct rzg2l_irqc_priv *priv = irq_data_to_priv(d);
+	unsigned int hw_irq = hwirq - IRQC_IRQ_START;
 	u32 bit = BIT(hw_irq);
 	u32 iitsr, iscr;
 
@@ -113,7 +112,7 @@ static void rzg2l_irqc_eoi(struct irq_data *d)
 
 	raw_spin_lock(&priv->lock);
 	if (hw_irq >= IRQC_IRQ_START && hw_irq <= IRQC_IRQ_COUNT)
-		rzg2l_irq_eoi(d);
+		rzg2l_clear_irq_int(priv, hw_irq);
 	else if (hw_irq >= IRQC_TINT_START && hw_irq < IRQC_NUM_IRQ)
 		rzg2l_clear_tint_int(priv, hw_irq);
 	raw_spin_unlock(&priv->lock);
-- 
2.43.0



