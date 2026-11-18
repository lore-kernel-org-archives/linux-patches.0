Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795055809;
	b=NtZhWh80ZpcbjGLMq0FpyHABc6t3uXSRut2WptPTdfH3qUzjjmq8k8rOExvLCHEaEmni
	 4zT7V4S/P0Z3bCtf/kK9YA9dZKZR2mwxGRsTKjGs1Ex13rcvDqXQhsdO4ma9M2dV1ONCv
	 k3bOdpE31ninC+PhYkeAfDZzE+6qMJgxgn962Mb7ceMkIdeGE2t9A4f41Wac/UgCdEN6K
	 tAJJJyMuZuIp0BsLxSa/rEUxWy8aAlrCmrPHCxhukjj3LcQUlp0UeEPtNB2Ins3tgdtBF
	 zZOKw4BKk9NG+gFBgLO6QSdIyKcRWuVtNxUoBb95n45B3PpiDShLsLRnNLjBe8rihrA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795055809;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=/lAiZDSQ8yLqtpaebQiWNnY7/Bu+xSb22WAXMHS8CZI=;
	b=z9BtrNHYCh2jPpswkFU0H+FcROJ0RMYJoIvKZB2QiHj+7BMWqjce4FYnZAfmqztxodJ+
	 MAmIIgar0ZRss4pTa2HNy6KVHO2tUrOSy4FZ6oGbHNdm7C6HcKNmy+E8Uac1duW+z9AOS
	 qy3tjLK52M8HzGYPeNaoJEgCvB5Onm4xFlOEU7QXDdf0F0zKpbieL774Z8zLi9KytMJRU
	 KNwvS8z5HVVao/XsIW4N5QFszJHktYRCZvHSmDQ3Ma/qxUxt1+4e4o390nVb7DsY57tfe
	 jEElnD3OsqxPPezhEfLURU9urcsasrTqvF08RwsrUvwJaze/fLhs+3XFhTvz9t3H7zA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ByIcfxGA;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C1F8D60A2606;
	Thu, 19 Nov 2026 02:36:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ByIcfxGA
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1C97F1F000C7;
	Thu, 19 Nov 2026 02:36:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795055809;
	bh=/lAiZDSQ8yLqtpaebQiWNnY7/Bu+xSb22WAXMHS8CZI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ByIcfxGA4wsnjk+sTA8lwUvJLILwu/6y52qCYOje6PH4CNsmpOSIPUklsDflIfA4h
	 o+Lif2N9SuOObZaeiOwjtHprBjQe8iZjIqIeBnF0xvVtOd77VaH8j5XipJURmd7a0U
	 /rJbMDT1QiUEQGw0oEYDqGqaE5dU0MT7txpBUdn0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	sashiko-bot@kernel.org,
	Frank Li <Frank.Li@nxp.com>,
	Linus Walleij <linusw@kernel.org>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 1763/2214] dmaengine: ste_dma40: Fix probe LCLA free
Date: Wed, 18 Nov 2026 15:57:19 +0100
Message-ID: <20261118150122.066189538@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 13c632d292dbe..e017298156f9c 100644
--- a/drivers/dma/ste_dma40.c
+++ b/drivers/dma/ste_dma40.c
@@ -3684,7 +3684,8 @@ static int __init d40_probe(struct platform_device *pdev)
 				 SZ_1K * base->num_phy_chans,
 				 DMA_TO_DEVICE);
 
-	if (!base->lcla_pool.base_unaligned && base->lcla_pool.base)
+	if (!base->plat_data->use_esram_lcla &&
+	    !base->lcla_pool.base_unaligned && base->lcla_pool.base)
 		free_pages((unsigned long)base->lcla_pool.base,
 			   base->lcla_pool.alloc_order);
 
-- 
2.53.0



