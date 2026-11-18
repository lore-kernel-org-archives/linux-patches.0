Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795023428;
	b=XaOppVWGfX0+S7riUAZrXprmrp9DJdG+WCLSsCj9M5s04GWmJ6DtdczFgfzq6aTyWXxY
	 fAgGKh9kybV/jdMA9KguRDSFdtY7oi7ZLiKWH7cxRei4Wlgi6ynWNe1AkX2dQFPuD8b+Q
	 SqRau7wpLyFTfGYyiYQcNvMsSbmCZJME2lc1xsueyelWusMzEmoqR/IahdupsTfTjSp49
	 5DCD2HKOSW8PIVupte1/Q3np0eMM8Iuobh1l1FWnaU8lZBgL2Ll21Kak9atha5dIggT+R
	 i+q22TwHm52h8jF+2cIHhBirhtjhhZWhqAMatsoPfLkRLr7Rsl/Xl5sitZHGy2XM8Ng==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795023428;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ma8juwQl/XnaF2XC6zZ/RMhAjobysY/zlRwPIEOKSzc=;
	b=ZLEmCnYjmwud3WAMmd2/aW6UQYeCRp46Z7Dh0NQym+5DESto0iU1yP66ST3/1xhCeOhv
	 zr6EXT+ROnow0PJoYEAQKCZe35BCpForIOmVw7PGsHtFhssxTP88hgkYFAmWnTX2SfLhz
	 SwV3Hd1OhjedFu/3md1lNuCY6ncxLbz0BlFVzzuRmKcesMNypAqu93w7yb337gxaO6KXd
	 X28WqqGOchLR07nscCRTnr+NVzVirMQswWgDYvk5YijF0+jPdlVNDutYqG+BXyGnwoe9w
	 uPjxrA6yOwHpmhW6g505xWU2h4MA6VymCdb4VNfAUeZbWz9CgNZJgRvRlY5nB5OtEZw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=KTt67WbF;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A2A8E606CA66;
	Wed, 18 Nov 2026 17:37:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=KTt67WbF
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0185B1F000C5;
	Wed, 18 Nov 2026 17:37:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795023428;
	bh=ma8juwQl/XnaF2XC6zZ/RMhAjobysY/zlRwPIEOKSzc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=KTt67WbFoLW2kmZRdXnp9asQ4EqyA0IB9/FI7DG2wkqvbGXytTFIDvLCtrf0LPDW4
	 8DMD8IDip8cOTcuD8w4t17xU/+spulQD6MPEnnu8nElfhKJJdG5amaA3iH9ZNaWrkh
	 apGYIDcyXE4Gc2jJF2w4OQmhc1PiIogHr9mpKi/I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rosen Penev <rosenp@gmail.com>,
	Frank Li <Frank.Li@nxp.com>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0366/2151] dmaengine: fsl_raid: zero CF descriptor pool allocations
Date: Wed, 18 Nov 2026 15:35:01 +0100
Message-ID: <20261118150135.421922976@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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
index fa8e40fdb005c..c8b1a537207fa 100644
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



