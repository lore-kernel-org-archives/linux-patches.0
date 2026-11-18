Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795025562;
	b=zAVjMANznyR3XELsM0a0nN+U+0t5NTK5JKzaylhoM2GuIr98ZSDL5sA0QChuqPGQBygD
	 Pp7ZkBgTzVxdslJ/C/Kj+x5gkcTWK2i9wZcNS46umYchLk/7i/jOTuitbsJBwQZR4mhKq
	 izzr7wawHzWMgJwnHnuMi2XfvKDsGR4p3X5oVRB/YbiPp/SwiNgEWvGoUFMLlEzYk9sfx
	 fOn7x1YAQrteIbH++GtsOLnMAcVNmLywOz0O0ZgLxv0OimIHKLGAms1xfspFKehFstc+3
	 ViTmoOF0DlCUOtSixTB7BqxOIXebo4gfIm8Xbou7z6yUbopiy8Nli+ZV2/aP02nKWYQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795025562;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Y+Vrjp+GNzPeJHyOKoGpGToaz84WjMKvq2jrVmgMOf8=;
	b=zzWTgr8m97NaTY6mxfHf4s8JW7x6LOxAhXyZuXTDasmUcGyYivHB88K4+Nk9/stFRcDF
	 Ga9PfpD/XpzcW4YQ0mN9rBS4thQPZpwLcEyRbHOLFs2T4MTRftNZTWm3x69nj3ARVHT7L
	 wEse7L28zee542IxWf437wAhH8mfzRQRpchA7BKCge+kdueRGW4KqXMjrLqMSBMt2EnYy
	 ROTl6n0f1NHoay58r7tBOzvDqDNg3dMfpT90FDe1EcVpPY7r3Csm9sZuX4vqbI+zAluJ5
	 +OVEYeaIQ+SUwlbAWk9RDS/cYRwJEZx/+xeBKuAmGgW2JyxJZTcZM/vrbFvIQjgQLbw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Ojhai9oC;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 698C9606A325;
	Wed, 18 Nov 2026 18:12:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Ojhai9oC
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BAC181F000C5;
	Wed, 18 Nov 2026 18:12:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795025562;
	bh=Y+Vrjp+GNzPeJHyOKoGpGToaz84WjMKvq2jrVmgMOf8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Ojhai9oCDYcumX2u+1/hA5rp8QWTHlYvUUr0HksQGjv5KWtY9LDb8H7hnySzNnBpm
	 N6jXUBd9gTFnE8IE6OnPKyC4Wr+VpR6N2Coxm7zSUmComGDn1WtH9R9C4a+9iYW6eQ
	 vkw2gSyKcTkihsIvfpWCS0yoCiFOWM/0O0U8sQ88=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	sashiko-bot@kernel.org,
	Frank Li <Frank.Li@nxp.com>,
	Linus Walleij <linusw@kernel.org>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1124/2151] dmaengine: ste_dma40: Fix probe LCLA free
Date: Wed, 18 Nov 2026 15:47:39 +0100
Message-ID: <20261118150203.144015602@linuxfoundation.org>
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



