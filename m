Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795022992;
	b=NjUDPu34fSaniu+ShLqaNf/CXMlWlvkgZFDcMLOz7/JbkB9BiUsmV9TyZdaqyLz5VNqB
	 6mIfPhTUTbOsHcTkasmBSnD8/Jdz7UMXWbKRN1111qNA3Xp+ZZwSIrNrrwoZT+039YPC7
	 vvjlGp7BsmZyzjfPvWZCZ8bIXstgxFwo1aU2lPUytqBt71B5E9HzY9kC8RokTJYAxwKna
	 p7mNryncApCcWhyiZm6Ni0IEnjEsaW+jMyF2mQeqzpGaDerkqMU72fwhqxjgJZ0JCCYEF
	 eNoWNjQxT6aSq161XoVL7kx71CWGcCJN302XrnlmM5/Mwt9wAF6FVY4luand2DlcM5Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795022992;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Gqql6TeVWeilEQAZgVQeNpw8TovcY92qAk4zn6HIPc0=;
	b=xzy67U8OVZomm+oUVK1Hc5CBeBs7efXIgkyXnI55u1I8mxFeMyVUHKYydhp51WZKgqE5
	 ZthN+1oCQAC9izCamBpOEfBHhVU39LZ5n+PwjjL731AwVvhAK/CqVrWtjXMYrrPeO11pS
	 iPRmYvEkvw8kVr009/h/JPnYi2Sdo8GTHVDmcQNARdrTzteXIyuHFkuFTZxmab5ZCjnne
	 5omlvE9qvgzBcbUMvpiL5ue/4dzEkvSsmRfNAdqvp4Uyou5b1ME3u8+Ynugjl/HH4pzN9
	 DJCkzNkf4IuRekIgO62j5d0QozLoRqa4fV9Q0caQ3p0b9hjzMQv+m7Y6EML8S4auKSw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=yWF3SZlg;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A5888606A320;
	Wed, 18 Nov 2026 17:29:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=yWF3SZlg
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 080351F000C4;
	Wed, 18 Nov 2026 17:29:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795022992;
	bh=Gqql6TeVWeilEQAZgVQeNpw8TovcY92qAk4zn6HIPc0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=yWF3SZlg4OTiSw4bvOhU/ZBEU/0b0i4OlYfbCSAKb0Mp5EktwdRCCjNnhUtjvKyIH
	 ThZf7Dm0xkCkN9olXOKI3Q4SfbfZPWf8JstXLsFoKbdt6zcaH8T+Dr5A2BuwbHWK+F
	 p1/VQd9MChl3Zhd6bDV1+qXU8inHlaYgnU6+8K6c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rosen Penev <rosenp@gmail.com>,
	Frank Li <Frank.Li@nxp.com>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0210/2151] dmaengine: fsl_raid: avoid free_q underflow in free_chan_resources
Date: Wed, 18 Nov 2026 15:32:25 +0100
Message-ID: <20261118150129.430967935@linuxfoundation.org>
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

[ Upstream commit d805aa5b6088b193debabaa80cc0991bfa2bd057 ]

fsl_re_free_chan_resources() loops alloc_count times calling
list_first_entry() on free_q without checking whether the list still
has entries. If descriptors remain un-acked or pending in submit_q /
active_q / ack_q when the channel resources are freed, free_q becomes
smaller than alloc_count and list_first_entry() returns the list head,
causing list_del() to corrupt the list head and dereference a bogus
pointer.

Walk free_q with list_for_each_entry_safe() until it is empty,
decrementing alloc_count per freed descriptor, instead of relying on
the alloc_count count.

Fixes: ad80da658bbc ("dmaengine: Driver support for FSL RaidEngine device.")
Assisted-by: opencode:hy3-free
Signed-off-by: Rosen Penev <rosenp@gmail.com>
Reviewed-by: Frank Li <Frank.Li@nxp.com>
Link: https://patch.msgid.link/20260718235227.385108-1-rosenp@gmail.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/dma/fsl_raid.c | 9 +++------
 1 file changed, 3 insertions(+), 6 deletions(-)

diff --git a/drivers/dma/fsl_raid.c b/drivers/dma/fsl_raid.c
index ad77694520e9e..fa8e40fdb005c 100644
--- a/drivers/dma/fsl_raid.c
+++ b/drivers/dma/fsl_raid.c
@@ -613,18 +613,15 @@ static int fsl_re_alloc_chan_resources(struct dma_chan *chan)
 static void fsl_re_free_chan_resources(struct dma_chan *chan)
 {
 	struct fsl_re_chan *re_chan;
-	struct fsl_re_desc *desc;
+	struct fsl_re_desc *desc, *_desc;
 
 	re_chan = container_of(chan, struct fsl_re_chan, chan);
-	while (re_chan->alloc_count--) {
-		desc = list_first_entry(&re_chan->free_q,
-					struct fsl_re_desc,
-					node);
-
+	list_for_each_entry_safe(desc, _desc, &re_chan->free_q, node) {
 		list_del(&desc->node);
 		dma_pool_free(re_chan->re_dev->cf_desc_pool, desc->cf_addr,
 			      desc->cf_paddr);
 		kfree(desc);
+		re_chan->alloc_count--;
 	}
 
 	if (!list_empty(&re_chan->free_q))
-- 
2.53.0



