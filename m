Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795030958;
	b=AyQxJ7cWqkdiyE2ORfFJYWR8K9unFlmnfZiwOTyCkRa0Ep2Xkgh+T0gbdJmjZbGMhek1
	 wjB3JjqfaaqyNN5EeNC5BomaUmma785TWCbiKhrxqR+Kgb7YNbE4sXdXagaIxJW+ITuJV
	 vViwg83qX7YP93K/O9lKkz1YlL0BGqBT774sHvgI6y1Ii/Y8NiC8DZTr/1ErsSEsRbg23
	 GNIPlPMpaytY1P55gExTEFAJ6VJLP8BsJATe7xY9FW9hJdn4Zxq5bFTQfWsd9pY3Y6TWZ
	 kipBbN9DAld0BNHbdD5D9wWreDPj5CptyQd/OZC47UrwR9bVr8Ln3ChyRByW3SZZYbA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795030958;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=IqZdhacbrn4Hyzsrd/vqav8qoGtaU5Uq10RYm0Yjn0g=;
	b=FgEODg6f3BkAnXyCzlqRRY+WWZ8GIzOIFTCXXGodgtspF4P8KeM4Ln9d25/Qhl8jxShB
	 6JriA5VConXqswmKmwoyzdf4Tt7k+wfETtxQW1isyaTqYytDb21iFf4N2UExSeZVpDroc
	 VqNXmT/0ZPQp0dFyF7A5xDVEEMpqSYxmRy5Wuk9PUdSV+rmaQRHMRTHWYFSHxqxFr8WlN
	 MyZch35JglW7oxCGWkThpdooz3Ch8A3vg/arpyRDXJ3H1dfoFYerM5Y+c5fAylVb0HGo8
	 jP7V4Cs4HnMNYC+x2ICVCEtSud+i95cTJ5ALEnicFhey7Rdk+UeSOsHWaVNBn6d5e9w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=0o0osSHR;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5CA82606A325;
	Wed, 18 Nov 2026 19:42:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=0o0osSHR
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B23D71F000C5;
	Wed, 18 Nov 2026 19:42:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795030958;
	bh=IqZdhacbrn4Hyzsrd/vqav8qoGtaU5Uq10RYm0Yjn0g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=0o0osSHRD7TJUr7ybglR821Lz0ovS1oBTObhGOfSOq7dmxSw0BmU4EMDacouoOBuJ
	 PNJ6+m1mVGCFgfsCxCK1kihCdY9OnOvptu7tk6EjG63x6y66pat7kmqf/Vx+o05IAX
	 HTnTdr7gdtyTWzUekNK765ksL96cvfoC7avLBBpA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	sashiko-bot@kernel.org,
	Frank Li <Frank.Li@nxp.com>,
	Linus Walleij <linusw@kernel.org>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0889/1756] dmaengine: ste_dma40: Fix probe LCLA free
Date: Wed, 18 Nov 2026 15:50:16 +0100
Message-ID: <20261118150045.178970722@linuxfoundation.org>
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

From: Linus Walleij <linusw@kernel.org>

[ Upstream commit 750dfcdb7a406bdd52d604099a631bbe96ddda91 ]

When LCLA is placed in ESRAM, d40_probe() stores a devm_ioremap()
address in lcla_pool.base and leaves base_unaligned unset. The
destroy_cache error path can then pass the ioremap address to
free_pages().

Only free lcla_pool.base with free_pages() when the driver allocated the
LCLA pool from normal memory. The ESRAM mapping is devm-managed.

Fixes: 339f5041089a ("dmaengine: ste_dma40: Use managed resources")
Reported-by: sashiko-bot@kernel.org
Closes: https://lore.kernel.org/dmaengine/20260819225114.AE1511F000E9@smtp.kernel.org/
Assisted-by: LLM
Reviewed-by: Frank Li <Frank.Li@nxp.com>
Signed-off-by: Linus Walleij <linusw@kernel.org>
Link: https://patch.msgid.link/20260927-dma40-fixes-v7-13-89f595e8851d@kernel.org
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/dma/ste_dma40.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/dma/ste_dma40.c b/drivers/dma/ste_dma40.c
index 9b38672db3d90..2dea28bdd5e8a 100644
--- a/drivers/dma/ste_dma40.c
+++ b/drivers/dma/ste_dma40.c
@@ -3741,7 +3741,8 @@ static int __init d40_probe(struct platform_device *pdev)
 				 SZ_1K * base->num_phy_chans,
 				 DMA_TO_DEVICE);
 
-	if (!base->lcla_pool.base_unaligned && base->lcla_pool.base)
+	if (!base->plat_data->use_esram_lcla &&
+	    !base->lcla_pool.base_unaligned && base->lcla_pool.base)
 		free_pages((unsigned long)base->lcla_pool.base,
 			   base->lcla_pool.alloc_order);
 
-- 
2.53.0



