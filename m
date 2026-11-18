Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795018740;
	b=EBCQKxEXJlJ+Eo8qUZyPY1CiQSUz6gk5eiRvAuT8X9efIsgeA9etU4vlu/PrKUCd5jD0
	 RbKbr6iwzGtOY5cnkNDx+QCF0dJ5I2mrS7SmhKg46wVF3mFIWNQxVY8wjG50oLA6MEQB+
	 yaDQfGeenVc59Z5O89Pnb/NX1wnCuCPnyz+rjhOyOAsS67UUZ0mwsI4MYg6N+LHQNCF+K
	 X42R8fo0YOv448wOi+4renMD3K0OQuh4C8cLR0sNtIEWlvRhQ8dLy5pUFRQOPHbtEmhso
	 W0vzjWAZGNkS8ovtWb1TBqPWd/QmT/b11lRC1tVFbOkTN3gPqY7iwBPPzfC7AA4JKfg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795018740;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=1WILOy+Ma7x3DnsUzIpfD6jXhs4GZB1ESeOSkxsa+O4=;
	b=lQ2zmqrMUKWeSuAeG6YHpVcqOD7MwO64C3oPQY/SzWBj5DQLZPew+b15WNlZ9uzmuSOH
	 Yt4bKNG3M+fhZugJfUU5VPFRTXEuDGebAwnZdXtpWfHy+4P1fPRUN3d7bYbSHCcm9f1+x
	 0tfAXe0BpPjTTIwK7udJcE70V+NQFcEqmdbnybGnaD5WZ+LKJsJ6UKmszW9KIkq7+Czjf
	 8lBR7d6SV9uYzrLqDYXkvdmkFhk2WwCgQJ8fBP8vlS+LM5Fbh7dROF45KpTXaj+Ya21nv
	 NL+MaGOTzG9N4C25UYsJYkaErxoDIuuPp2byY2EPaQOcTdb6GiJc7sZo0NEte5L9n/g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=DIfr2T+O;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 05674606A325;
	Wed, 18 Nov 2026 16:18:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=DIfr2T+O
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 18D461F000C4;
	Wed, 18 Nov 2026 16:18:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795018739;
	bh=1WILOy+Ma7x3DnsUzIpfD6jXhs4GZB1ESeOSkxsa+O4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DIfr2T+OEKcyb5LWAMjkbSnVxXI4P+Xhb/tiqc1N+L5mH/CQ3m+hfCBI2eyVpIMZa
	 wyJWo/h8vLpsxMtMJ/OSjFBAoB3NXX3AyQWpQ2Vi1ztvXMf43KpddfjZnDllHHssCh
	 mj7eKsIxwLj0MBKMw4dkU4Z3MU3FUE+PfKPHoICc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Frank Li <Frank.Li@nxp.com>,
	Linus Walleij <linusw@kernel.org>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1345/2651] dmaengine: ste_dma40: Put the LCPA SRAM node
Date: Wed, 18 Nov 2026 15:43:05 +0100
Message-ID: <20261118150336.447658329@linuxfoundation.org>
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

[ Upstream commit 9a3762b470421658214baeb6cce3eed7344bb435 ]

of_parse_phandle() takes a reference to the LCPA SRAM node, but d40_probe()
does not release it after translating the node into a resource. This leaks
the node reference for the lifetime of the system.

Put the node immediately after of_address_to_resource() so both the success
and error paths release the reference.

Fixes: 5a1a3b9c19dd ("dmaengine: ste_dma40: Get LCPA SRAM from SRAM node")
Assisted-by: LLM
Reviewed-by: Frank Li <Frank.Li@nxp.com>
Signed-off-by: Linus Walleij <linusw@kernel.org>
Link: https://patch.msgid.link/20260927-dma40-fixes-v7-14-89f595e8851d@kernel.org
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/dma/ste_dma40.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/dma/ste_dma40.c b/drivers/dma/ste_dma40.c
index e3756d8edc618..70f2a6594945c 100644
--- a/drivers/dma/ste_dma40.c
+++ b/drivers/dma/ste_dma40.c
@@ -3771,6 +3771,7 @@ static int __init d40_probe(struct platform_device *pdev)
 	}
 	/* This is no device so read the address directly from the node */
 	ret = of_address_to_resource(np_lcpa, 0, &res_lcpa);
+	of_node_put(np_lcpa);
 	if (ret) {
 		dev_err(dev, "no LCPA SRAM resource\n");
 		goto report_failure;
-- 
2.53.0



