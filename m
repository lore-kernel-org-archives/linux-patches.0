Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795061286;
	b=xC3soPddSm+j/VNB5cskQB0dgZZye9rsMK6V84Mts/L31mUaKTeLOJnmauhTYxmvOQgC
	 40evhKACK7XZLa/GcROvvSKB7nFL8d7iPrE8nLY9Wex+TXcbi+NjE00q1MPgcVp0mxo/6
	 iQqCU7vLQYDIH0lNqFNNqcUXqs4c1yjY/kiy2DQJ9E+Y2W3P2Rbkh5npzgIi4GI7z7hna
	 crl0WzGkqF2bYyGethwOK6Pg6OCOgSM6xSShG+QVRfoO07VxUVLWUu1WATGN1vAPyXu1W
	 CPVc2+E1kYzqF+pv1mdJXIjRg2ZHJMdGeLtxhkknwCCpY1fMV8dwVCxplGd0Bk/UMKQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795061286;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=iqbWldvqaAm/zHwtF9tNhPn6+IVjyjxog/Uc1iz3X0A=;
	b=KTdxvpKr8nW6bbDsQCM7UE0YiGbDXQMzmzfZgDJYlYZAEkIMk3lR9lJxIhAnSQ+H7bBK
	 LNbHMtZRkmUPa6rARx1McVtpZ864Smwz++0hEr9g/RCcCQ7qeHXG9EP6IGfyFykfq9/1n
	 M7At09wsqLEuiGz5FByeSd63pjAmlkpRDJCP8XLhzdCnbi28yctQu8EqgVqMUFl5uQMSK
	 ho146HHbKperI0pXtuREkHSTdBv3Hy5p/9z6olhkw470+kGuN6l9oATZ2xPC60IIckqau
	 cW4nnWZ2kmrfhO9lscw4k1FZlI/ke4ubeIyEj3EVoAmT/nG8/rMKiwGR0bUZhDnQGiQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=OkNKojg5;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3FE39606A325;
	Thu, 19 Nov 2026 04:08:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=OkNKojg5
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9671F1F000C4;
	Thu, 19 Nov 2026 04:08:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795061286;
	bh=iqbWldvqaAm/zHwtF9tNhPn6+IVjyjxog/Uc1iz3X0A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=OkNKojg5Iq9SOa7NO+xnxudJhKbV0li3bD/bnsrcnS6uqeqQMuLAE7Tl84peUqNKG
	 HxSvykc0XHB39CJ1Sgau1qfEZSVsH1hrH4vKEoEN1iGUWGYmJZA7xhZD3eLQP6mndn
	 ZZukh5IN6ASIaUwJF1y4Cy2MVQMM3+DhVQm+GiT8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rosen Penev <rosenp@gmail.com>,
	Linus Walleij <linusw@kernel.org>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 1497/1848] dmaengine: ste_dma40: turn d40_base phy_chans into a flexible array
Date: Wed, 18 Nov 2026 15:58:55 +0100
Message-ID: <20261118150022.022383959@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 4d401c4147f55..020804cc03c11 100644
--- a/drivers/dma/ste_dma40.c
+++ b/drivers/dma/ste_dma40.c
@@ -604,7 +604,6 @@ struct d40_base {
 	struct dma_device		  dma_both;
 	struct dma_device		  dma_slave;
 	struct dma_device		  dma_memcpy;
-	struct d40_chan			 *phy_chans;
 	struct d40_chan			 *log_chans;
 	struct d40_chan			**lookup_log_chans;
 	struct d40_chan			**lookup_phy_chans;
@@ -623,6 +622,7 @@ struct d40_base {
 	u32				 *regs_interrupt;
 	u16				  gcc_pwr_off_mask;
 	struct d40_gen_dmac		  gen_dmac;
+	struct d40_chan			 phy_chans[];
 };
 
 static struct device *chan2dev(struct d40_chan *d40c)
@@ -3184,6 +3184,7 @@ static struct d40_base * __init d40_hw_detect_init(struct platform_device *pdev)
 	struct clk *clk;
 	void __iomem *virtbase;
 	struct d40_base *base;
+	size_t alloc_size;
 	int num_log_chans;
 	int num_phy_chans;
 	int num_memcpy_chans;
@@ -3243,22 +3244,24 @@ static struct d40_base * __init d40_hw_detect_init(struct platform_device *pdev)
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
 		return NULL;
@@ -3271,7 +3274,6 @@ static struct d40_base * __init d40_hw_detect_init(struct platform_device *pdev)
 	base->virtbase = virtbase;
 	base->plat_data = plat_data;
 	base->dev = dev;
-	base->phy_chans = ((void *)base) + ALIGN(sizeof(struct d40_base), 4);
 	base->log_chans = &base->phy_chans[num_phy_chans];
 
 	if (base->plat_data->num_of_phy_chans == 14) {
-- 
2.53.0



