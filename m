Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795030964;
	b=McOjIGz9P3OhVF03J8TO+C1etHya/+Q9AWes9UCCCpP/mN+d4TCOLJMQYMjcY/orevMy
	 EU4R5a02uHDNN0cS/wtp8tUBGVj6Khcvdv/7MLJWAPxtUsQrC9kr+XO6cuz1eas+DWIbV
	 zOXWwYUwEBv0lyyO51FJKty1FKmTdVhnq3Cmx1v8KWbY/PXQlFxXnmlqsfOr/n/lj+7tF
	 G4ogFVODFzKweSs/v69YZctYDR374E8V0SlvGu6x9QigQPRJm9wM0nkz/21NqGBpK4QWm
	 N19O0ijCJPywYDgIGCOp/aKh7dFZMkHXM27zuW6RiBckEFtAUt4paopThwgFjuiYOKQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795030964;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=u94EqSqa1iObAluX0U+EHiag7mwmd7PYmMToLdg19EQ=;
	b=Mr3RZHovK43up+9XLtN/WPZN/hCzyDYUIazdT3B944KAa5V9J/3LtG9wEbjaT8BC8QP+
	 H+e345I/HtG0F+G+1TMU9TgDZ0SxY1yyajodrVA/+FfWGAcprc3GRPoSj1+RVwG5d06KI
	 E9PPbTiQ45wbnaDwdBzX27ZfApy/PLUMJNnL9a6QJzh28nukF42TZJ+HkGzQqq/lbK+3Q
	 xF9wSvL8S8K9UqUmgHm5d02hoKejt1w+MJ+Q92bEPFrxMBlL2MbBaifqpXWlL1yaaNupl
	 Pq7z0hsOCKPMkBcJWjasBRoa7b1D+jghGXZ1YlgCJHyu0SfVg4ScBJHSnMr5UWZfsrg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=TjW8gzDa;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E9740606A911;
	Wed, 18 Nov 2026 19:42:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=TjW8gzDa
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4A07C1F000C4;
	Wed, 18 Nov 2026 19:42:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795030963;
	bh=u94EqSqa1iObAluX0U+EHiag7mwmd7PYmMToLdg19EQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=TjW8gzDa4mbigSH8GkzhhZNCt1xVYoALVrPzghvNWHImc2D6T0sHcuEYHOZESzc/L
	 9bj1v0rHKtf1dVl4rtinjG1NfLQXvtkzITML1WuqTOj7W0ug6+wJ+EBvSQL3EHSsDm
	 pw89f8hUwek2Hh8ASYte9+mLKb9qB837LZ2GC/rE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rosen Penev <rosenp@gmail.com>,
	Linus Walleij <linusw@kernel.org>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0891/1756] dmaengine: ste_dma40: turn d40_base phy_chans into a flexible array
Date: Wed, 18 Nov 2026 15:50:18 +0100
Message-ID: <20261118150045.330083223@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Rosen Penev <rosenp@gmail.com>

[ Upstream commit cc4fea19daeb0460fe3569e0a2d523f427b2bac1 ]

Convert the separately-offset phy_chans pointer to a C99 flexible array
member at the end of struct d40_base, and switch the allocation to
struct_size(). The log_chans and memcpy_chans slots continue to live
in the same allocation immediately after phy_chans, indexed via
base->log_chans. This removes the hand-rolled pointer fixup that
recomputed phy_chans from base + ALIGN(sizeof(struct d40_base), 4).

The ALIGN(sizeof(struct d40_base), 4) requirement is met implicitly by the
C compiler when using a flexible array member. With struct d40_chan
phy_chans[] as the last member, the C standard guarantees
sizeof(struct d40_base) includes trailing padding to satisfy the alignment
of the flexible array element type (struct d40_chan). Since struct d40_chan
contains members like spinlock_t, pointers, and struct dma_chan — all with
alignment ≥ 4 — the compiler ensures sizeof(struct d40_base) is already a
multiple of _Alignof(struct d40_chan) >= 4. The struct_size() macro then
computes sizeof(struct d40_base) + sizeof(struct d40_chan) * num_phy_chans,
so phy_chans[0] lands at a properly aligned offset without needing the manual
ALIGN.

Assisted-by: Claude:Opus-4.7
Signed-off-by: Rosen Penev <rosenp@gmail.com>
Reviewed-by: Linus Walleij <linusw@kernel.org>
Link: https://patch.msgid.link/20260531020843.594892-1-rosenp@gmail.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Stable-dep-of: f2baf04a695d ("dmaengine: ste_dma40: Fix memcpy channel parsing")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/dma/ste_dma40.c | 14 ++++++++------
 1 file changed, 8 insertions(+), 6 deletions(-)

diff --git a/drivers/dma/ste_dma40.c b/drivers/dma/ste_dma40.c
index 1e17a4fff6d54..0a91166061e90 100644
--- a/drivers/dma/ste_dma40.c
+++ b/drivers/dma/ste_dma40.c
@@ -602,7 +602,6 @@ struct d40_base {
 	struct dma_device		  dma_both;
 	struct dma_device		  dma_slave;
 	struct dma_device		  dma_memcpy;
-	struct d40_chan			 *phy_chans;
 	struct d40_chan			 *log_chans;
 	struct d40_chan			**lookup_log_chans;
 	struct d40_chan			**lookup_phy_chans;
@@ -621,6 +620,7 @@ struct d40_base {
 	u32				 *regs_interrupt;
 	u16				  gcc_pwr_off_mask;
 	struct d40_gen_dmac		  gen_dmac;
+	struct d40_chan			 phy_chans[];
 };
 
 static struct device *chan2dev(struct d40_chan *d40c)
@@ -3210,6 +3210,7 @@ static int __init d40_hw_detect_init(struct platform_device *pdev,
 	struct clk *clk;
 	void __iomem *virtbase;
 	struct d40_base *base;
+	size_t alloc_size;
 	int num_log_chans;
 	int num_phy_chans;
 	int num_memcpy_chans;
@@ -3267,22 +3268,24 @@ static int __init d40_hw_detect_init(struct platform_device *pdev,
 	else
 		num_phy_chans = 4 * (readl(virtbase + D40_DREG_ICFG) & 0x7) + 4;
 
+	num_phy_chans = min(num_phy_chans, STEDMA40_MAX_PHYS);
+
 	/* The number of channels used for memcpy */
 	if (plat_data->num_of_memcpy_chans)
 		num_memcpy_chans = plat_data->num_of_memcpy_chans;
 	else
 		num_memcpy_chans = ARRAY_SIZE(dma40_memcpy_channels);
 
+	num_memcpy_chans = min(num_memcpy_chans, D40_MEMCPY_MAX_CHANS);
 	num_log_chans = num_phy_chans * D40_MAX_LOG_CHAN_PER_PHY;
 
 	dev_info(dev,
 		 "hardware rev: %d with %d physical and %d logical channels\n",
 		 rev, num_phy_chans, num_log_chans);
 
-	base = devm_kzalloc(dev,
-		ALIGN(sizeof(struct d40_base), 4) +
-		(num_phy_chans + num_log_chans + num_memcpy_chans) *
-		sizeof(struct d40_chan), GFP_KERNEL);
+	alloc_size = struct_size(base, phy_chans, num_phy_chans);
+	alloc_size += sizeof(*base->log_chans) * (num_log_chans + num_memcpy_chans);
+	base = devm_kzalloc(dev, alloc_size, GFP_KERNEL);
 
 	if (!base)
 		return -ENOMEM;
@@ -3295,7 +3298,6 @@ static int __init d40_hw_detect_init(struct platform_device *pdev,
 	base->virtbase = virtbase;
 	base->plat_data = plat_data;
 	base->dev = dev;
-	base->phy_chans = ((void *)base) + ALIGN(sizeof(struct d40_base), 4);
 	base->log_chans = &base->phy_chans[num_phy_chans];
 
 	if (base->plat_data->num_of_phy_chans == 14) {
-- 
2.53.0



