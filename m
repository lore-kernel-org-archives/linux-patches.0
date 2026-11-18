Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795029403;
	b=V9r7nJ6JDuJmuBZopStMferRFeKxAHBI2aneVx3zNyyUncksz7uwqMXgvyAKA16FJvpi
	 STeeCFvJz61HjjD3f7yzOQlBr0yDAUpr8RhK4L49yRPOpsOQpeVpE964jdBilG5y9svov
	 qfvuxBehLvZSbunkZ1p1Vw9yx+gVHdHdAGOc32o4TeJwSq4KmBNG/FCDZaKz0zLhPA/DJ
	 pjcfrrd3Nv8Nz3UXAoydTQaUNexx1HZ6+H/WLPgP8PF2gsS7pJxCQ7TkGhPXh02JEsWq0
	 24omVdwrx1EkPpsEHBUxRqraZ1OILNHBMPRSpiTuvnJTQ8pPSf/U7e142ak/WDyDBmg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795029403;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=d8uSicZ/g8PDPiVLOkncHWNX5ozkPYD2goigerc12zw=;
	b=I2ooS8qK0Iy5ZkDVqaZKNy8dxcc8yxLrsdRDZfq9uCT7ezdMgTWvdz8BzNMPBU2x5xRW
	 dLEZNYnbrcNiVIg8ZiSSmLoZR8LnuV7cHiKNyp+lzCLYg7BGkPMWOEFsHs2DytcVfP13k
	 iOJt40CTJfa+CXaRr+g3TCPuNV9VGCaeRbtGsti8Qx8idI1BYqeq4+bvZx2R8gRcOPqva
	 1OKIDPeGlLUG3aqPDGOYrNtVVsvJbx2QaBlCf15VOpbYGIKjwFOkn1g1CzcSfgMzVXI57
	 vzl7nHAt3uYrdFCjB+LELRCPTI1OrxEBSK3b5dMAgyWu6ar7boearXMzvLSlmdjd4DA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=RLu77nTi;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B4DF606A325;
	Wed, 18 Nov 2026 19:16:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=RLu77nTi
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4BA201F000C4;
	Wed, 18 Nov 2026 19:16:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795029402;
	bh=d8uSicZ/g8PDPiVLOkncHWNX5ozkPYD2goigerc12zw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=RLu77nTiHavKXdGpmWmK4G/xlK4Im76v+Z3hGrrtq8tUqnd8/f8dXZI5ae+CNnoMy
	 Xla8KEghUBqIYI3LArnzDzr1m66i1si1LSjYeptAVnbM3NOXGhGLIr9FETHFAtO3sD
	 FcClryMjKN/B00eJfm7ISDFvOi5q66sj1pcViZ+8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rosen Penev <rosenp@gmail.com>,
	Frank Li <Frank.Li@nxp.com>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0338/1756] dmaengine: fsl_raid: zero CF descriptor pool allocations
Date: Wed, 18 Nov 2026 15:41:05 +0100
Message-ID: <20261118150021.701617685@linuxfoundation.org>
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
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Rosen Penev <rosenp@gmail.com>

[ Upstream commit 26d48e9fb6997f4026dd86daecf8d2c12258f698 ]

The compound frame descriptors and embedded CDBs are allocated from the
cf_desc_pool with dma_pool_alloc(), which does not zero the memory. Only
cdb32, the gfm coefficients and the frame address/length fields are
programmed; the dpi_dest_spec/dpi_src_spec fields in the CDBs and the
rbro32 field of each frame are left uninitialized. The hardware reads
the whole block (frame 0 length is sizeof(struct fsl_re_xor_cdb) or
sizeof(struct fsl_re_pq_cdb)), so uninitialized heap contents are
exposed to the device on each new descriptor.

Use dma_pool_zalloc() in both fsl_re_chan_alloc_desc() and
fsl_re_alloc_chan_resources() so the descriptor and CDB memory is
zeroed before it is handed to the RAID engine.

Fixes: ad80da658bbc ("dmaengine: Driver support for FSL RaidEngine device.")
Assisted-by: opencode:deepseek-v4-flash-free
Signed-off-by: Rosen Penev <rosenp@gmail.com>
Reviewed-by: Frank Li <Frank.Li@nxp.com>
Link: https://patch.msgid.link/20260820031654.28450-1-rosenp@gmail.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/dma/fsl_raid.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/dma/fsl_raid.c b/drivers/dma/fsl_raid.c
index 5c4f1d0f0c115..4d96a0594ee69 100644
--- a/drivers/dma/fsl_raid.c
+++ b/drivers/dma/fsl_raid.c
@@ -305,8 +305,8 @@ static struct fsl_re_desc *fsl_re_chan_alloc_desc(struct fsl_re_chan *re_chan,
 		if (!desc)
 			return NULL;
 
-		cf = dma_pool_alloc(re_chan->re_dev->cf_desc_pool, GFP_NOWAIT,
-				    &paddr);
+		cf = dma_pool_zalloc(re_chan->re_dev->cf_desc_pool, GFP_NOWAIT,
+				     &paddr);
 		if (!cf) {
 			kfree(desc);
 			return NULL;
@@ -594,8 +594,8 @@ static int fsl_re_alloc_chan_resources(struct dma_chan *chan)
 		if (!desc)
 			break;
 
-		cf = dma_pool_alloc(re_chan->re_dev->cf_desc_pool, GFP_KERNEL,
-				    &paddr);
+		cf = dma_pool_zalloc(re_chan->re_dev->cf_desc_pool, GFP_KERNEL,
+				     &paddr);
 		if (!cf) {
 			kfree(desc);
 			break;
-- 
2.53.0



