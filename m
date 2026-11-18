Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795018737;
	b=JN9YRfUoitvi/NmeRLVEUa3XdimJ7Vk+uY0yjsNWx/ukG9EMAoFUqfiy1EBqKELZXexI
	 LCFOHhUmPrSNIUhhXBnuc7YxYY5uG1YPd0nYj2lGwwxqhVA0qShpEuloAu8G56nE+SS+j
	 3pttwUH+UDdyGGTaY8Psou+8pRczws2YvKbxMm5QCf2DBty7/7p0cEFiYjRCowwu/EHY7
	 QqLsllHqW2y9OVqXrNtLLUC2g98sUYQjTXW/Nmc/K/qcDdVx6pyigSqprUHWWA/GkA1M4
	 yKaUDVlumra2iWNjqvI1tbZ5eyxaN8OvrieOBh3jL9lSqpdlXiBUpFbcDYcMvs5UN9g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795018737;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=K0CyBkWdkQpeJ++BFFQGr2dQxg9YN49pjM+edLr2a88=;
	b=VkkTCzPW7X0wZmhZFgnWD9yJ0uIybUcyFp5LjtRLIZWqu4m5tUFKJ2Lq8tGVcybPTZ4J
	 6Lme9Aq6d9CvegD849pXUnEhhzEwD2BR3gsT/TEX2vpbMDgn+94l4O+BjBoW3oEsFxlvr
	 NulcoVwmMvza0ZZWGKKYkPhSKjhp2gQqegGAJyMG6C5gQGinTBycZQvwgUGIK5hQQVbWO
	 nUsAHGy8OpPfVdnkX6GeD8+/fpFSssDy7vyx1+mcpwUYD0NDUV53bviY6r0nyp6mtmEZi
	 HNWZ5gruco3L4XKJxxdUPEwPs+RmGVZop0D9AlvVON2e/qE8AfQH0K9sN4042LzKENQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=cdlXz3Uu;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 38894606A337;
	Wed, 18 Nov 2026 16:18:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=cdlXz3Uu
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3F1511F000C4;
	Wed, 18 Nov 2026 16:18:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795018736;
	bh=K0CyBkWdkQpeJ++BFFQGr2dQxg9YN49pjM+edLr2a88=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=cdlXz3Uuxo5xDQOCffNZ01edd/0AYVMrp2iLwUxnhYLWffraWeygMY7RhCj7o4PXE
	 Pc840CkbDsAncvHpBWR8KX5VDUjhTzxZHWNcty5zhrZvqpCJn9Pp7DkYU3VOEveZ/1
	 B6V21Rq20CYUDfg1Kp9QixDLk5sV6WAa+npnm0nM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	sashiko-bot@kernel.org,
	Frank Li <Frank.Li@nxp.com>,
	Linus Walleij <linusw@kernel.org>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1344/2651] dmaengine: ste_dma40: Fix probe LCLA free
Date: Wed, 18 Nov 2026 15:43:04 +0100
Message-ID: <20261118150336.412223911@linuxfoundation.org>
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
index 58bc08c2ed0fb..e3756d8edc618 100644
--- a/drivers/dma/ste_dma40.c
+++ b/drivers/dma/ste_dma40.c
@@ -3906,7 +3906,8 @@ static int __init d40_probe(struct platform_device *pdev)
 				 SZ_1K * base->num_phy_chans,
 				 DMA_TO_DEVICE);
 
-	if (!base->lcla_pool.base_unaligned && base->lcla_pool.base)
+	if (!base->plat_data->use_esram_lcla &&
+	    !base->lcla_pool.base_unaligned && base->lcla_pool.base)
 		free_pages((unsigned long)base->lcla_pool.base,
 			   base->lcla_pool.alloc_order);
 
-- 
2.53.0



