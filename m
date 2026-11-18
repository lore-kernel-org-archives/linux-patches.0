Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795049182;
	b=qwkM131ozIixYubqw25RhAE0ghL0onh2+spfp8ucL7AyfWlNN0yFjwoNV1vfutPcWMPk
	 rLVWiR3bnNwnox3PyRSEHdrEuyO6a+BgqVN7187AMZgo2Af+onQDE4Kt2VnnDkst3Lz+x
	 BijYBmBLdXeE1lPdKx9y6YbOPutci8aJGKPRQ5y++bN7R3wy29DIOkgS7bqRUknoko6Io
	 A5TS7cRhvtulfMVdLtwrVZWJHZyeW4dPLmkWIqq9d/as3zl8BUSeSLHAF7Z5xTvsMzIRz
	 Mq4BKk0u534HV3LUUTQVYJqkMZZERTd3JCFHQIWfP8jMkuIeVSPwmYLmaXihfKPe1aA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795049182;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Zb67/pyH2CtGMKQeRlOuJ4sZwI/Avp8/mDshoStGuAQ=;
	b=qMGXAXPnVR8GJUYkyGEASLOTGYgyQigRR5gtUrDidOnygoSVIviPV+tKeWwYdf78Bj0E
	 7o+1ypukkt3Jb4Rn1EbNJZa9ui/yjENLV+84CC2PlFbrILhcMHkw/8tqKo22KnqqhGV6+
	 JuV8MSoZoTb/RllcfURjmrAIJkOiV1RZYMyeumFeKsAnz5g2HzsWVgUQ9RKjAWWJ6ypA3
	 hIN5Ke1TXV1HVgTzmSb0myF7awI0+lQhK6qYYzzOivtcdCtCWZrO4p7EyW15f1PY/Btgs
	 iOmJVskH5PVvCWrJWLoqmBCDfLGDr0v3wduFROEd2kcVtmnex7S4b4/MQKYG8+J15mw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=j8gAp6Zf;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE3D6606A320;
	Thu, 19 Nov 2026 00:46:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=j8gAp6Zf
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3F0FE1F000C7;
	Thu, 19 Nov 2026 00:46:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795049182;
	bh=Zb67/pyH2CtGMKQeRlOuJ4sZwI/Avp8/mDshoStGuAQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=j8gAp6ZfvA+HOC/5bSHfiv2YqRsmZnvbbPzHMvTl5N+I0z0qtBCjGWw8sSuM+NaGS
	 alqtM8xorGiqOZdm+LOvJxoEyAKC4m2n6G/JNuVEVkT/pCsoe/LDjv1XA4eLboBTbH
	 9q0EoRYhCb80MlC+IjZDeJKdKB56BkWoY+07BSCs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	sashiko-bot@kernel.org,
	Frank Li <Frank.Li@nxp.com>,
	Linus Walleij <linusw@kernel.org>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 2259/2857] dmaengine: ste_dma40: Fix probe LCLA free
Date: Wed, 18 Nov 2026 15:54:53 +0100
Message-ID: <20261118150322.785878505@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 0176cf07af183..0773f2b4fb1ae 100644
--- a/drivers/dma/ste_dma40.c
+++ b/drivers/dma/ste_dma40.c
@@ -3706,7 +3706,8 @@ static int __init d40_probe(struct platform_device *pdev)
 				 SZ_1K * base->num_phy_chans,
 				 DMA_TO_DEVICE);
 
-	if (!base->lcla_pool.base_unaligned && base->lcla_pool.base)
+	if (!base->plat_data->use_esram_lcla &&
+	    !base->lcla_pool.base_unaligned && base->lcla_pool.base)
 		free_pages((unsigned long)base->lcla_pool.base,
 			   base->lcla_pool.alloc_order);
 
-- 
2.53.0



