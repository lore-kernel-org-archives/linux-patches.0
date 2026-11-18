Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795015471;
	b=hbdYRcwyvYVk3J/Z2XU3xA+++2pSAU4j2g6lXBBAKZ3Sgf3vnZOCgtzmuIS/CUgcCc9P
	 JLduVFWcDoOXl82IZu/bd3qJ+3aYHbLgGsmLPDdsuMgWZ0AdaeyTpEaghn60Demumnw6T
	 Xh8T1u6hF/8tU3tolXVXGPWftGyN0dcwGOcU5elU0eGQ6pSQyq91pqONvPFPtGMd/Y5c7
	 0RYazvV/n/g2s/W9hRcqz6rroJs+ryGhc6dwsu3Gakz4VFgKjsBZQNSv9CpTETbgnBgm0
	 Efl9cLrCRPENgPQbtujDn21WcWhgFw8CTj1teDOtPIQ0B4amOTEIql3A9LYD20ePfyA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795015471;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=LSxRD4qQKp672YHOPWsqrPvAXxa/kL07JUzPG6SGwX0=;
	b=EBAuGOrskDG/XZBB2xslKPz/1yRcHUDWzTEq0HUIpyl+1sskZVpqTY9rDzQWsHPH3Fq8
	 qjoGJKw4gePlB543MUda0VWgL1kIhx0rCvu5GCSSICG1+wXMtr+9CDgEh/BwXPdtuY5zR
	 +Ifl+IZsrVfc86xH9NA0rtpHPJjmatTFvocLNcFOPe3Q1xW31aCWtPdkzL8TLEAGOEn/w
	 9dGe8Cx+R7FFCNNVV45Ok+UCobBloFXUZBT5DwPwR5+Hb6Ydkyx3G5G+bOy+PMZBrE0GW
	 8yeh1ybIB83Wu44NpZJbkcUzm4kby5oPIG5dqI3lK7/3EZ0ybBa/WvuQrU0ygXx1p/A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=BU33u9eF;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1581D606A32A;
	Wed, 18 Nov 2026 15:24:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=BU33u9eF
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6B82A1F000C4;
	Wed, 18 Nov 2026 15:24:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795015470;
	bh=LSxRD4qQKp672YHOPWsqrPvAXxa/kL07JUzPG6SGwX0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=BU33u9eFqXPhjhQ+vIzrzFKoUqh6T7Jkh3Wmb3KoE0sWhhCMGljB2B93/GOsAvA+t
	 0qJTWKhEE+rWiA7VfG3YhL1n6xXxtyUK7Gvj23x7ydXQ9qIcx4rmAclb+CrfKfxPKs
	 KZv44rTjdLK93+drAN0g8846EupC4H4i6iMfmoI4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <lkp@intel.com>,
	Rosen Penev <rosenp@gmail.com>,
	Frank Li <Frank.Li@nxp.com>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0185/2651] dmaengine: at_hdmac: fix sparse __iomem cast warning in memset helpers
Date: Wed, 18 Nov 2026 15:23:45 +0100
Message-ID: <20261118150254.524776462@linuxfoundation.org>
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

From: Rosen Penev <rosenp@gmail.com>

[ Upstream commit fdae0d0f096c92dd05d3722759fd614ea341e0dc ]

Both atc_prep_dma_memset() and atc_prep_dma_memset_sg() declare vaddr
as 'void __iomem *' but assign the return of dma_pool_alloc(), which
returns 'void *' (not iomem memory). This causes sparse to warn about
a cast removing the __iomem address space at the dereference site.

The struct field memset_vaddr is also typed as 'int *', which is
neither the type returned by dma_pool_alloc() nor the type used for
the actual writes.

Fix by declaring vaddr as 'u32 *' in both functions and changing
memset_vaddr in struct at_desc from 'int *' to 'u32 *'. This matches
the actual usage and eliminates the need for the (u32 *) cast.

Fixes: 5d8c5bea0da9 ("dmaengine: at_hdmac: add COMPILE_TEST support")
Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202607231110.8MqNRj0Q-lkp@intel.com/
Assisted-by: opencode:big-pickle
Signed-off-by: Rosen Penev <rosenp@gmail.com>
Link: https://lore.kernel.org/oe-kbuild-all/202607231110.8MqNRj0Q-lkp@intel.com/
Reviewed-by: Frank Li <Frank.Li@nxp.com>
Link: https://patch.msgid.link/20260724225958.43925-1-rosenp@gmail.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/dma/at_hdmac.c | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/dma/at_hdmac.c b/drivers/dma/at_hdmac.c
index e5b30a57c477a..7c071e6496371 100644
--- a/drivers/dma/at_hdmac.c
+++ b/drivers/dma/at_hdmac.c
@@ -244,7 +244,7 @@ struct at_desc {
 	/* Memset temporary buffer */
 	bool				memset_buffer;
 	dma_addr_t			memset_paddr;
-	int				*memset_vaddr;
+	u32				*memset_vaddr;
 	struct atdma_sg			sg[] __counted_by(sglen);
 };
 
@@ -1097,7 +1097,7 @@ atc_prep_dma_memset(struct dma_chan *chan, dma_addr_t dest, int value,
 	struct at_dma_chan	*atchan = to_at_dma_chan(chan);
 	struct at_dma		*atdma = to_at_dma(chan->device);
 	struct at_desc		*desc;
-	void __iomem		*vaddr;
+	u32			*vaddr;
 	dma_addr_t		paddr;
 	char			fill_pattern;
 	int			ret;
@@ -1126,10 +1126,10 @@ atc_prep_dma_memset(struct dma_chan *chan, dma_addr_t dest, int value,
 	/* Only the first byte of value is to be used according to dmaengine */
 	fill_pattern = (char)value;
 
-	*(u32*)vaddr = (fill_pattern << 24) |
-		       (fill_pattern << 16) |
-		       (fill_pattern << 8) |
-		       fill_pattern;
+	*vaddr = (fill_pattern << 24) |
+		 (fill_pattern << 16) |
+		 (fill_pattern << 8) |
+		  fill_pattern;
 
 	desc = kzalloc_flex(*desc, sg, 1, GFP_ATOMIC);
 	if (!desc)
@@ -1168,7 +1168,7 @@ atc_prep_dma_memset_sg(struct dma_chan *chan,
 	struct at_dma		*atdma = to_at_dma(chan->device);
 	struct at_desc		*desc;
 	struct scatterlist	*sg;
-	void __iomem		*vaddr;
+	u32			*vaddr;
 	dma_addr_t		paddr;
 	size_t			total_len = 0;
 	int			i;
@@ -1189,7 +1189,7 @@ atc_prep_dma_memset_sg(struct dma_chan *chan,
 			__func__);
 		return NULL;
 	}
-	*(u32*)vaddr = value;
+	*vaddr = value;
 
 	desc = kzalloc_flex(*desc, sg, sg_len, GFP_ATOMIC);
 	if (!desc)
-- 
2.53.0



