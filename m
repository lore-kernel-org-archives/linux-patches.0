Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794590776;
	b=3V3GaOUPIrKBojzHtAuiyy9dfUlftqb0nZhdC6Xh3cTf71RU1i4xLbeenlXAEK3d/VJu
	 Ay8AQ5GS4jHkYTOv8y+MZLJnsAt150rCn3TULg58814eyEelH5J8NVtsUjP6hK0CtI7pf
	 Gzr6fSpc5JQ+tL7vx7FEwof1WmOR54+fftHW9507d+HEWDjicZw3WBqrq+FcSQto4TiNv
	 o8d/5gDiuxMd8aPRFXvtlTPWcpcPNsbmDohl+cUJl2Pw7BryPnh3DWWdzqzGzwbWLzC19
	 alTA0HsooJ0Javzjg3WdEugcSnVtfft7pTkR5y4l+VAdG7bvoQu1JNitt3zFIJWw4uQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794590776;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=rAablLASTNwta7kVWPp8XryH/mES8JNFVk45k5jVkm8=;
	b=PrW9h+YNLQDIB9zjoCO2wahOxf92xv/oeWAmgK+/HIwYsa/QPo0EPElGL+D7s6eJ3yaW
	 XAUOhGBMlWe/TnDH9ULLzdwVvGuLzzi5lQ0KS99bkPmKjmOYvvekFnCa4ivDWWLTXzOsJ
	 g8zRm569P03LXh48q/vg4wFib7hGnR6gen/mUq1iiHQ5edDwUbxohzT/m0kSXEYmHrBra
	 aBa8dgEPYE+L4zaKjJ3F3rFtqSbkpiyS9IYQOsxBxtlFXnXLdx5nrVMV3XA03ps5CVSGY
	 QdIrbUFr9us2EDnZrJvzLe12Q0d7AXH6UD6k3LnnZ+dp8eqZtU1OOdiUheFBnrn7K2g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=GwuTHgaC;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 23F4F607C353;
	Fri, 13 Nov 2026 17:26:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=GwuTHgaC
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C53931F000C4;
	Fri, 13 Nov 2026 17:26:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794590776;
	bh=rAablLASTNwta7kVWPp8XryH/mES8JNFVk45k5jVkm8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=GwuTHgaC9WjPk7n6k8bXZiSXQKrp5U67qfw3pSRq1/hUZpBu/tp/BdjzhqMKnq2wM
	 XzAaxGuieWDo6qYi3nxWO4ueq4QYy+OHYS0RLh05JksJdCBhjzq8KE3a+Wx9KtSdx8
	 h+HuSGhJ1tvxvxs0yXKQhxphLNE4BuIC7amxdovI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Au Dang <au.dang.jx@renesas.com>,
	Tommaso Merciai <tommaso.merciai.xr@bp.renesas.com>,
	Thomas Gleixner <tglx@kernel.org>,
	Biju Das <biju.das.jz@bp.renesas.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 672/686] irqchip/renesas-rzv2h: Preserve TIEN state in rzv2h_tint_set_type()
Date: Fri, 13 Nov 2026 10:53:25 -0500
Message-ID: <20261113153844.444844875@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153820.902362109@linuxfoundation.org>
References: <20261113153820.902362109@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
[ sashal: Adjusted context and indentation to fit the existing shared interrupt-chip dispatcher structure. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/irqchip/irq-renesas-rzv2h.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/irqchip/irq-renesas-rzv2h.c b/drivers/irqchip/irq-renesas-rzv2h.c
index c9f9099a51294..927b5ffa0c7cb 100644
--- a/drivers/irqchip/irq-renesas-rzv2h.c
+++ b/drivers/irqchip/irq-renesas-rzv2h.c
@@ -328,9 +328,9 @@ static void rzv2h_clear_tint_int(struct rzv2h_icu_priv *priv, unsigned int hwirq
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
@@ -386,6 +386,8 @@ static int rzv2h_tint_set_type(struct irq_data *d, unsigned int type)
 	if (tssr_cur == tint && titsr_cur == sense)
 		return 0;
 
+	tien_cur = tssr & tien;
+
 	tssr &= ~(ICU_TSSR_TSSEL_MASK(tssel_n, priv->info->field_width) | tien);
 	tssr |= ICU_TSSR_TSSEL_PREP(tint, tssel_n, priv->info->field_width);
 
@@ -398,7 +400,7 @@ static int rzv2h_tint_set_type(struct irq_data *d, unsigned int type)
 
 	rzv2h_clear_tint_int(priv, hwirq);
 
-	writel_relaxed(tssr | tien, priv->base + priv->info->t_offs + ICU_TSSR(tssr_k));
+	writel_relaxed(tssr | tien_cur, priv->base + priv->info->t_offs + ICU_TSSR(tssr_k));
 
 	return 0;
 }
-- 
2.53.0



