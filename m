Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795040866;
	b=smfT0Bu0p+PDggqx7Pb758qgOYnz6LDvuzMq7R1juKCUeTCe490F8m3OzW7l+7ojGmVp
	 +skIx66I40XuAl4T28/js3M7lOT9l1Cyy0sDr5ugUGdcmeCobK2bA38TSV6QlT9WL3oQh
	 VKGIZzse8BTDpH9x+RvXH3FjViuCPqfi0h7Z9k7i32ah8xlAb2I9io6K5gavTfbNl2NB9
	 JhWFbsn0QCvDmYn9RuAY8XitIHGL10vRbqPV+Xt6AZ1JhustGmZYLAbgrEUr3dc92xUXV
	 dz6cI7o135fhdgkRMSoEOkrATLU2cufrHGJUJ2uvmjQAhD8eawBEWp2JvQ4xlvy1gqQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795040866;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=DrU+xXLkmn5U0K7kwfrYyxY4lJ0YY6iyWlb3poYrZbM=;
	b=1LjItA2YVgeCNg1IDv6zb8Qt1cnmd2IqGkhtrb6kSC4VoYQpAxn3wDR1FAVTNyWLbJ4+
	 Xgnn+CoOj7erIvvTQmcfvOruHYZqZdqPS/sYqdYbEw9PpKa8MsNYwdpjX7J/UWBPguciD
	 16OCCJdJivkAnr74nBzNbnSOoFLg6f15DPlWJYoI/C4W8eLLapQZmOLKZdupqAY9ABw2o
	 G4NnCBIB4Zbip6+0mJwOnNwD7lNdLGeURzJaDkInxURqEcOmso3lpLuPm3iWcn44VkgEV
	 2BQax1/2IgCRfBGf6B38+gCyo8Nk14t84JjrkWumwHzu0mgxVKHubuT242zhaYFiLsQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=vWIcfhH+;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 22583606A32C;
	Wed, 18 Nov 2026 22:27:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=vWIcfhH+
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 49D891F000C4;
	Wed, 18 Nov 2026 22:27:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795040866;
	bh=DrU+xXLkmn5U0K7kwfrYyxY4lJ0YY6iyWlb3poYrZbM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=vWIcfhH+y/9dwC9lRcyUX3qe8RoNOK7Cav5BDK/Tf4tIAEJ5fDHvLMBAKDj98MgIo
	 NxlT0fGnNEHcJUxIEil/K50I05914M8B1LvOdC2fUHMzP2+alxpfOHph7PYOfy83So
	 +04Aw0T6ZY5p+Nnr0LaB2RjL1M7Sl68zI/xJEleI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	sashiko-bot@kernel.org,
	Frank Li <Frank.Li@nxp.com>,
	Linus Walleij <linusw@kernel.org>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 2609/3318] dmaengine: ste_dma40: Fix probe LCLA free
Date: Wed, 18 Nov 2026 15:53:51 +0100
Message-ID: <20261118150439.413831917@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 7ad8c95d251fa..066188e289286 100644
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



