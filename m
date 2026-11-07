Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794064922;
	b=QASujdJqGirEWLjjIALHimEoTylDyo0qLTZZbgyjL+Gf/Zvr05SZXZbhq8UieA1xTL2h
	 EJ4Ee+J9MWKACZNSeWz/tOWSqNt5NGTDec/IXp5/Jo4fhPT/UHdcZ5HUhfBFji9fZ1PbW
	 phgWv7vZ15CU7PTZuq2IOHFT2nZArMgZwJibwapJNBr3ZlRUlasmpW2HhTNwii6UmJrVq
	 SA1V3ysCHkAiNWsfU2uYsUpPl6Xyli8ip5KFRSf9J75wd3J3csdLam1N1U0+VSfFVs/HU
	 kDVZD4HBn0yej65VXLSgmVrJpETlVYAKy5aSJwTM5CNuOECEogWf1k9polWavK2dc4g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794064922;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Z+AfgfqUqflqsTkkW3mBdOG7SmHImeitXf6KNFuPK9I=;
	b=UGvm1awMXDp7H1niYcYVvCnZbs3f8MPy/a91KkCKeq29lsLRogxnEtm75+bJGU+1/P2Q
	 v13YcmQzEr9znrVFQ5Kmd0a0v8HDxGHpuvhEaOrMkvXIN+/yNMJGDAa5zW0TKxpnAmRZz
	 BjjyxdO4nMyPLSB9ZvAFKUs158PIKO6ZmcHLFs2KuJhUkdCG7g1HGtA4rf/NGiiDm48sJ
	 x+e62X6xP4hLBwVbrC40G9j27azCnwv/JGRLodGFkZBXYSFC7y2PGsKYWvsG7IV45OvaQ
	 UJmYumR5tiuAEnT3IagX/pFAKu7jevEXTTJ8vdVeau1yes/n+uNSs34G7Nub6TfJ2DQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ukLW+UqF;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 339B4606A33E;
	Sat,  7 Nov 2026 15:22:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ukLW+UqF
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D22C81F0089F;
	Sat,  7 Nov 2026 15:22:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794064922;
	bh=Z+AfgfqUqflqsTkkW3mBdOG7SmHImeitXf6KNFuPK9I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ukLW+UqFGOqgppSeWh85bos21LbmzD6F7WXMHHgtwK2jpsUxBMA6Md23StAHRryeP
	 vExbLyzdzhLNkehZbbvu+YDzpATESbp35tAlNjGNGa0gqCPlm2enHjNxtm21dPbIPT
	 5WjkUhxqjoINUNhJCPC8kJjdIodNggm0T5kc7BQs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Au Dang <au.dang.jx@renesas.com>,
	Tommaso Merciai <tommaso.merciai.xr@bp.renesas.com>,
	Thomas Gleixner <tglx@kernel.org>,
	Biju Das <biju.das.jz@bp.renesas.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0792/1257] irqchip/renesas-rzv2h: Preserve TIEN state in rzv2h_tint_set_type()
Date: Sat,  7 Nov 2026 08:51:28 -0500
Message-ID: <20261107135001.201194267@linuxfoundation.org>
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

From: Au Dang <au.dang.jx@renesas.com>

[ Upstream commit 42bedd4af8cd50c32a1560d8744bd22d25be79cc ]

rzv2h_tint_set_type() clears TIEN while switching the TINT source and
then unconditionally sets it again, enabling the interrupt even if it
was disabled before the call.

Restore the previous TIEN state instead of forcing it on.

Fixes: 0d7605e75ac2 ("irqchip: Add RZ/V2H(P) Interrupt Control Unit (ICU) driver")
Signed-off-by: Au Dang <au.dang.jx@renesas.com>
Signed-off-by: Tommaso Merciai <tommaso.merciai.xr@bp.renesas.com>
Signed-off-by: Thomas Gleixner <tglx@kernel.org>
Reviewed-by: Biju Das <biju.das.jz@bp.renesas.com>
Cc: stable@vger.kernel.org
Link: https://patch.msgid.link/20261014095927.635132-1-tommaso.merciai.xr@bp.renesas.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/irqchip/irq-renesas-rzv2h.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/irqchip/irq-renesas-rzv2h.c b/drivers/irqchip/irq-renesas-rzv2h.c
index 1a4703a353e95..485c3eea76328 100644
--- a/drivers/irqchip/irq-renesas-rzv2h.c
+++ b/drivers/irqchip/irq-renesas-rzv2h.c
@@ -420,9 +420,9 @@ static void rzv2h_clear_tint_int(struct rzv2h_icu_priv *priv, unsigned int hwirq
 static int rzv2h_tint_set_type(struct irq_data *d, unsigned int type)
 {
 	u32 titsr, titsr_k, titsel_n, tien;
+	u32 titsr_cur, tssr_cur, tien_cur;
 	struct rzv2h_icu_priv *priv;
 	u32 tssr, tssr_k, tssel_n;
-	u32 titsr_cur, tssr_cur;
 	unsigned int hwirq;
 	u32 tint, sense;
 	int tint_nr;
@@ -477,6 +477,8 @@ static int rzv2h_tint_set_type(struct irq_data *d, unsigned int type)
 		if (tssr_cur == tint && titsr_cur == sense)
 			goto set_parent_type;
 
+		tien_cur = tssr & tien;
+
 		tssr &= ~(ICU_TSSR_TSSEL_MASK(tssel_n, priv->info->field_width) | tien);
 		tssr |= ICU_TSSR_TSSEL_PREP(tint, tssel_n, priv->info->field_width);
 
@@ -489,7 +491,7 @@ static int rzv2h_tint_set_type(struct irq_data *d, unsigned int type)
 
 		rzv2h_clear_tint_int(priv, hwirq);
 
-		writel_relaxed(tssr | tien, priv->base + priv->info->t_offs + ICU_TSSR(tssr_k));
+		writel_relaxed(tssr | tien_cur, priv->base + priv->info->t_offs + ICU_TSSR(tssr_k));
 	}
 set_parent_type:
 	return irq_chip_set_type_parent(d, IRQ_TYPE_LEVEL_HIGH);
-- 
2.53.0



