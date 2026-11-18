Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795029071;
	b=ByJtoIiGdodEEmFxI/XEBqsrrOA6Zut73XUniVLKrP3VTSqpyiE7k9ox0aEIjco+aTF1
	 7zbAqg9sG5KGdQ6LWrmuOCMBWfSgXq8dZQSCVrajXPILtnDq49a1+JuN7nkxlM/wiIM3b
	 ph7JExYm/Ft3CxGbITyXJ0yPAGLfOffp2XRtvIvQg618OHBVOllfvGP69wv8FUC4Gx3Ii
	 UxUgEpj85T3od+d5HWEaRKd9l42z6DD0kWo5Ch8noM31szkKmjw83dBa74lykX01ycnI8
	 Bu041bdLPsbDPacDeFjmHKHZ0ZOTojtUyL9tLjHBaTiUFHoT2j6PUp1OPkPlGK/xgYA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795029071;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=IWr6xHgCwuaL4ShIPnbVjhtfzUTJOmpZc7fdGntctaQ=;
	b=P+vt3ic76gddpTOvVFACuTTkyACzRMSgwWfnqHXq6q3+TgHttbjkZu46szuPMfuO+9mx
	 /AiFnyK7Jjrl3tmkctVIcAhh59Ah7G1hz3OLMad+09XuCNBTL5srv7xyQF/CmUkX/0NDq
	 +vc+swUwtXGAJqbxofrZbs+gO11si/vT0LH/+N8b4vXGzcDiQ59eRiGmh1MLVrP4Ostzj
	 8UaS6pwrxkwCr1uUEp1vlw7fv89IajCm75g/cJOK+C2gSlCoGia696C8+TOgQOI46MOo7
	 HiOf8NAoBHZJDkVVBZAMnJ2PJIlEi2k7u21BiBtGGfRq2flAZ++kQqNE7Vt9noKLn3A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=wWxF26b+;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 99024606A320;
	Wed, 18 Nov 2026 19:11:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=wWxF26b+
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F2EB01F000C4;
	Wed, 18 Nov 2026 19:11:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795029071;
	bh=IWr6xHgCwuaL4ShIPnbVjhtfzUTJOmpZc7fdGntctaQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=wWxF26b+3yT7hmguY9liOhg+QtaJb+1ZcwzVDwYp0QgpQ/8D9RQvpjnXhduKhRGp/
	 Fbn3T3Z1vUZiy8C8Bn4YLUDnIygRreVxRijVs8XcdvfDR0uJITuVDq+PzmkVDtLYBa
	 dVJvJ2t7QCjdmWIkZyfqFCIEM09WOLjH/5EJm7iI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rosen Penev <rosenp@gmail.com>,
	Frank Li <Frank.Li@nxp.com>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0213/1756] dmaengine: fsl_raid: avoid free_q underflow in free_chan_resources
Date: Wed, 18 Nov 2026 15:39:00 +0100
Message-ID: <20261118150016.814992682@linuxfoundation.org>
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
index 399b4d2a8bac1..5c4f1d0f0c115 100644
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



