Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795015994;
	b=cHF6Qu80cbC3Mxs+u/qLcBWmRqAQzuRc+yd+f2bMz7HzVKG7P9w7BCP4wyUYq9SWLvGy
	 qoCixYP2I7S3OHOPnFt68qNUHSP+MZ9aCQkWbcVgPvlA4ZmnENpqalnJUg5BGOMKPFKl0
	 y+pxgbZF6RH5cAxbouUnNsdDJ5C2AcFRXsbci1jTqRChMeHa23pxkNwKrIci4f+MORbui
	 ROv8ELNHQUJzV4IJrcxPD8gRYpcDdlQ2p3ZSnnJachAGhjMesf/P0bmt4GtMqKBsNrjqV
	 IgLX1a5JdL1lXeNxIDhpbjsVVX9eSb+WCYXWyY5evSrnI1bf6Surjv7PZlWV+dW8Jyw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795015994;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=8CViDpwNwafQm1Mi8dAvUQU1450aGBBtcTO5xjYOd5o=;
	b=MA31mcn74o0TpRi/LI9Zd950ZeXHomcqg9pZnoNbuCSrZwe4La3JTFKs8IICQO9/79vK
	 Ve9lA/ukL27IRE0GvzMRPMu53OpapUvHJPc1UAcm+PC04zQn8My/oYGF2d4qhXHSWSsoj
	 yjCNUKnLwtApKVfDZbQiDuWaNnUtZOH93XzZS5WRpAd1hEfGsERfgt6MbALZR6Ciszkwi
	 Hgk7tuqYIT5kpe1dvdkSp8VvlUjWfjP+93B8tTcoNr9NSehSp3jb9Sm2h/bDxStrFOwYw
	 Tho7YDngfmkcnxp50CinwA+w6bNulPS2UoKMaO5Ez5kjTZgXD54SwZfVGQWtm2JIwOg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="aDJSqMJ/";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B37D606A320;
	Wed, 18 Nov 2026 15:33:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=aDJSqMJ/
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B02141F000C5;
	Wed, 18 Nov 2026 15:33:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795015994;
	bh=8CViDpwNwafQm1Mi8dAvUQU1450aGBBtcTO5xjYOd5o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=aDJSqMJ/nQqzKzTM+5SYMwvSbJCugZpJb6aM9SduUmBlzBEDm3OdFeBG67RoVwwr+
	 rXBIatNZ4posdA3Hv1t1LMhfLm//6uJLyxGtq+3idtJQZS1LRDI+XrmP1h7NHSa6qb
	 0SCgEDMSODWc2SPFG5BcEl4butRVAjsEcyDtHihc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rosen Penev <rosenp@gmail.com>,
	Frank Li <Frank.Li@nxp.com>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0370/2651] dmaengine: fsl_raid: zero CF descriptor pool allocations
Date: Wed, 18 Nov 2026 15:26:50 +0100
Message-ID: <20261118150301.154834793@linuxfoundation.org>
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
index e698c40b2ebca..befb4bb69d545 100644
--- a/drivers/dma/fsl_raid.c
+++ b/drivers/dma/fsl_raid.c
@@ -306,8 +306,8 @@ static struct fsl_re_desc *fsl_re_chan_alloc_desc(struct fsl_re_chan *re_chan,
 		if (!desc)
 			return NULL;
 
-		cf = dma_pool_alloc(re_chan->re_dev->cf_desc_pool, GFP_NOWAIT,
-				    &paddr);
+		cf = dma_pool_zalloc(re_chan->re_dev->cf_desc_pool, GFP_NOWAIT,
+				     &paddr);
 		if (!cf) {
 			kfree(desc);
 			return NULL;
@@ -595,8 +595,8 @@ static int fsl_re_alloc_chan_resources(struct dma_chan *chan)
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



