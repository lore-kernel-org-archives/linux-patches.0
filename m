Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795020413;
	b=HW7uUeVmVCzOpKMwsmmbQ3Edrd4okTN4CRQoB53Kh7O2slKlxn757bM1pzVhyqWm2Ig8
	 6TBbZlz/ZIa6c8XZtQeUjJixxAJP6PcZMZ0BhG6wlz1nPYPcgNQQ/eh9m/jwsWgw/8NlV
	 M3gwYBOF5RK1l6AmcSLJkNsy1GVRshoQT0G4VqTWjuAsFiqwvPdaEYcX7XhfpLFum7Uu2
	 aGOYASxwjS+I7t91ItRKMfD4efhzn1nwOVLacdx/QAPPgNplT7Veu426yTNNUoycIj/wl
	 ssaBE09MmkNXpDRy9TnvNoElVD4GxRDW4BTmyAK3f0VgrJLPwZerABdMpz8qQDrkFwg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795020413;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=5PnKbNCoRNFYrtv+pq69x1Y/AekEwmXmp5t5vq5/FVw=;
	b=UQKIldwyRpWFyTV6gDsnwV5/5r8ikTJ/viy1W1jIhUe27zVTgNkqluMIUCR/RSky8M7f
	 EWo80I0phL6vMq9SpaAz11xBqvjPCKm9wYmnB5i0P0eP6ogA3DvfHkoT+OY958v3MyASX
	 cvV1uGqEtdTIZmfYEjmDDnPQ0vEhJPi1Mu7O8PiCGRICyg+lUozVVNE8B9plDXcnPLkS/
	 4KJPytAO2zeMTpXtPGYYAcrG3ZowOS5ywEztob5mPFLriLpFDyaBiavRHZyn8kLIGcawc
	 e+AGFb0A4oVqqOmXZL82356KGu6leYfgYLf3xLDH9T92cj0xkMmzMclRJGxz9NMmGjg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="JXHIH6/1";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 93387606A32C;
	Wed, 18 Nov 2026 16:46:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=JXHIH6/1
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E33DF1F000C5;
	Wed, 18 Nov 2026 16:46:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795020413;
	bh=5PnKbNCoRNFYrtv+pq69x1Y/AekEwmXmp5t5vq5/FVw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=JXHIH6/1wscmYrXO/xWji0tcnTVmvSdza8v3IUdoI702HcHCg36drCdpAkfbEso5V
	 6kch/sAXqUSqPLjMiHpFCMtetuX9pQ2yxPB3LNsQo3wGABuHHhhLgrsYFJ49WDFfCb
	 Z2WzS7jlPKvMOVD7dwd5PEAdI5qdJPG8L6RvMKwo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pengpeng Hou <hppiscas@163.com>,
	Thomas Gleixner <tglx@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1943/2651] irqchip/sifive-plic: Avoid signed shift in interrupt enable mask
Date: Wed, 18 Nov 2026 15:53:03 +0100
Message-ID: <20261118150356.560527035@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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

From: Pengpeng Hou <hppiscas@163.com>

[ Upstream commit 0f214e5bbee59d5952d3c061fd65ed9a1e175981 ]

__plic_toggle() builds a 32-bit interrupt enable mask using a signed
integer literal. A valid interrupt selecting bit 31 evaluates 1 << 31,
which shifts a signed int into its sign bit.

Use BIT(), matching the equivalent mask construction in plic_irq_eoi().
The resulting mask remains representable in u32 on both RV32 and RV64.

The issue was found by our static-analysis tool.

Fixes: 8237f8bc4f6e ("irqchip: add a SiFive PLIC driver")
Signed-off-by: Pengpeng Hou <hppiscas@163.com>
Signed-off-by: Thomas Gleixner <tglx@kernel.org>
Assisted-by: gpt 5
Link: https://patch.msgid.link/caplitmus-rv.v2.plic.87a8fc444de44e109889ba28703c76f3@163.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/irqchip/irq-sifive-plic.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/irqchip/irq-sifive-plic.c b/drivers/irqchip/irq-sifive-plic.c
index 5b0dac1048140..d3d4187b96ab9 100644
--- a/drivers/irqchip/irq-sifive-plic.c
+++ b/drivers/irqchip/irq-sifive-plic.c
@@ -108,7 +108,7 @@ static int plic_irq_set_type(struct irq_data *d, unsigned int type);
 static void __plic_toggle(struct plic_handler *handler, int hwirq, int enable)
 {
 	u32 __iomem *base = handler->enable_base;
-	u32 hwirq_mask = 1 << (hwirq % 32);
+	u32 hwirq_mask = BIT(hwirq % 32);
 	int group = hwirq / 32;
 	u32 value;
 
-- 
2.53.0



