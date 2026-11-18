Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795061275;
	b=kDS2yPskeMc6/Q1qxZxhYqaqxowNq+MtuDkIIdn5ig6mIkn60o4hGDqt0wlbdy6S8Jgf
	 1t6rJlcLQCSksnd7P4IbGywjVuXDU3Pl9G9MOgJCNCv9NFPUZNlrqgYhvOIxb34XuswTg
	 UrW+VoNFbX6Bmglg4oPSvmYxRzFz0LgalsXwgoQsBwCNsuJnweNz2OiYdqX95SrffNS77
	 ntzmZZT+JDy6brFZ9iIFwrC6E3ojqqpnVp+k4bPTILFRtf0EojuWyQO5zDDjoBonOFoHB
	 IdWiHk5rd6yPOPj6FD+P2lUeac76RqpbdGt5uNz3uV5oxJ+N3u9ifbpzDJ2IIyUYCiA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795061275;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=cRn1JAi+GpagCIUnFB6LUkST0brgAmJn3A2s/6L1imA=;
	b=ymgLHbw+6xWJncSKryjBYObA1x9um11G+TgF5dOl4X/9XENKpifR+xih5xTEwZLT1ZE8
	 xCnNrDLGAd2OB9tkvN14Uxd1dFzFNbnh2Wi+KoJL/wz2XJp6TLaJXf0+u42Ws/2iWv9Ru
	 sNA/+2hxev1x9Rq5Q1bqtNOSo+5qJfVfSYaR/QAhn/VrR14bQmGSRuvXosKmdI8Z51xNC
	 DMzFj7sbjE02V5S3kaVtGTRjHCa2iK3lcT1IQ5+vDYdh9XwX3XAHHyt3UwtAfCinhylwG
	 Jci9PO/9HY7Z5UzJjTYcxU2+z8ZUillyifu98Oigy9ZQjS6x01fsQUplScCEdtWIqqQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=iFBW1UUC;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 613AE606A337;
	Thu, 19 Nov 2026 04:07:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=iFBW1UUC
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6F0901F000C4;
	Thu, 19 Nov 2026 04:07:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795061275;
	bh=cRn1JAi+GpagCIUnFB6LUkST0brgAmJn3A2s/6L1imA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=iFBW1UUCSF+cJT69nWR+65P9oNrey3ARz6fHyunrdbm7Me4kk35UlYfwvwcjp84P/
	 MZhH3iTW7HV8MpSYGCCRRH3moyO9Boc7zQlPDmsIIO15X379sVchH6tFGMg+Yioqf+
	 s3DbpiPZqUAjNanXyjXDA10e9fpxnafDo+HTMD+M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	sashiko-bot@kernel.org,
	Frank Li <Frank.Li@nxp.com>,
	Linus Walleij <linusw@kernel.org>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 1493/1848] dmaengine: ste_dma40: Fix probe LCLA free
Date: Wed, 18 Nov 2026 15:58:51 +0100
Message-ID: <20261118150021.730416576@linuxfoundation.org>
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
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index c4cd9ff90529c..9783841ad1db2 100644
--- a/drivers/dma/ste_dma40.c
+++ b/drivers/dma/ste_dma40.c
@@ -3707,7 +3707,8 @@ static int __init d40_probe(struct platform_device *pdev)
 				 SZ_1K * base->num_phy_chans,
 				 DMA_TO_DEVICE);
 
-	if (!base->lcla_pool.base_unaligned && base->lcla_pool.base)
+	if (!base->plat_data->use_esram_lcla &&
+	    !base->lcla_pool.base_unaligned && base->lcla_pool.base)
 		free_pages((unsigned long)base->lcla_pool.base,
 			   base->lcla_pool.alloc_order);
 
-- 
2.53.0



