Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B3FEF383BA;
	Mon,  1 Apr 2024 16:04:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711987455; cv=none; b=B8RWE7FYSO70EkMgXLN30G2pxDJtvsbxOl+NBi+tMAPQFIUxpfw2HD31+k0asASLGNaiYgS7vVmoo9GSEUVY/3byWlGHosnT4aijkyxPOvdce6cVRChYsy8tbCcp4f9NJP9s+67M88hLuDW66S41JqoRqBUNwsWdQOxLumDWT+k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711987455; c=relaxed/simple;
	bh=M72DGopxLtAEcUBX9ZOAIVryhneW05kgZK08TLIdT54=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ConuEj5bZZgmDsScWfJ0hFDtKZlrtrwjFxpg6bCndBiRTV1sIp/B25fGMlLZJyx5N2twDyuVtf6/sUbIkOvtPTCIQcPpZQjbq/w88BgO6ktLFlsF5xAdIBPUtlckdqVBPqHCc6RKZcvSvuMSDzems+HaQz6k4Zcuxcms1JhAeZQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ITcPZKbH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ITcPZKbH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 398FFC433C7;
	Mon,  1 Apr 2024 16:04:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1711987455;
	bh=M72DGopxLtAEcUBX9ZOAIVryhneW05kgZK08TLIdT54=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ITcPZKbHyOctkhTC3pZJlFmVaRVGZXzJf+js/3BLUUIX4E110Df8in6eTBsokRjCQ
	 S/UeHCqe3Q9skqqmXhIMdCCBI7E9aJGI3aUmjTgaq4rP8rxFV012kCd/M0+UMmptKC
	 XAm7qy//OJhCQGS3vDW+hlMAnujnvcvGtEgM5AXs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Geert Uytterhoeven <geert+renesas@glider.be>,
	Biju Das <biju.das.jz@bp.renesas.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.8 264/399] irqchip/renesas-rzg2l: Rename rzg2l_irq_eoi()
Date: Mon,  1 Apr 2024 17:43:50 +0200
Message-ID: <20240401152557.068488243@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240401152549.131030308@linuxfoundation.org>
References: <20240401152549.131030308@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

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
index 599e0aba5cc00..8133f05590b67 100644
--- a/drivers/irqchip/irq-renesas-rzg2l.c
+++ b/drivers/irqchip/irq-renesas-rzg2l.c
@@ -85,10 +85,9 @@ static struct rzg2l_irqc_priv *irq_data_to_priv(struct irq_data *data)
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
 
@@ -132,7 +131,7 @@ static void rzg2l_irqc_eoi(struct irq_data *d)
 
 	raw_spin_lock(&priv->lock);
 	if (hw_irq >= IRQC_IRQ_START && hw_irq <= IRQC_IRQ_COUNT)
-		rzg2l_irq_eoi(d);
+		rzg2l_clear_irq_int(priv, hw_irq);
 	else if (hw_irq >= IRQC_TINT_START && hw_irq < IRQC_NUM_IRQ)
 		rzg2l_clear_tint_int(priv, hw_irq);
 	raw_spin_unlock(&priv->lock);
-- 
2.43.0



