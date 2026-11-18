Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795061278;
	b=dusXZftOWC8flu8r80spnpaHXLsDEeu3XMgU+ePR7BxS2xHWKv1ci/N6hNLj7ROTEYjR
	 nBT7hpSRw+grr6VMo0BVxn6SX6lgOXGC/z8A8kz8SK7CCEJqfwWbqEm/uqMszYlf+guZu
	 wezP0KymBDw4DuUzdPFRboaxylBgiXfIppRHVnHFBKbBr11+kYzrrSnIE+zwmuAIcKHEx
	 LISe6syaXsMONVZb5XzdxjtA7YMqKdF0w/5E54rdYsoGO2RXAlCZZrlOEjh2QIK0o5mTl
	 UHkOxU4tnx8l0argEFLeZrhWr5JJILJl5aOUJQt2Ztfs1wSDevIBbKymRHaNZnZmuKg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795061278;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=NMB6a61udFKeTqOsZwI8hCJr++t51P1txWsWETySoiM=;
	b=Wq3CHRG44gbNkSakuiLog9fLPjJZQRGjivq/FAU1t2tZXhZnPeIXnxhBOA7k380ul9rs
	 iRTICNAaa4ktPQLf7wP0p73uPUNUpIHW7p2T9k/0aAapOoMnHJAmyn9KEsjTWysB6EqPn
	 yFWXWj2cPly1GbARl6zVWilze9J4M1LgfCzJH5bgU5Byep5DMcDgFU80Y2a3+YKcHHrMl
	 92qNUI5pebMdo2ShGGsY6PUDIgvanW/H11HXVHwBVgbaH5lYhsq1m7BxNMX0F0NB6Q8wM
	 ru1EC5jrFV5Kl3/I1uwlLDn40blCaKVfac8/uf8G9KkPoT0F8dQCnUwUbnweNAEqvew==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=JyCzMdHj;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E4FEB606A337;
	Thu, 19 Nov 2026 04:07:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=JyCzMdHj
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 43FE31F000C4;
	Thu, 19 Nov 2026 04:07:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795061277;
	bh=NMB6a61udFKeTqOsZwI8hCJr++t51P1txWsWETySoiM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=JyCzMdHjHvmbYeUS7bxb6gKQQptMrKz1xyctRI1uQA/WWuFNXcOt0f0P5lAhmL1YQ
	 0tc81ngieyCziuaDr3LOZNHqMH69Po4m7L3SQdBnxj1dLWfe7o0+G9xru51jUbhGFe
	 r1JK3//A5hF8YufL/w/hsCoAhZZ3OUPLRcD/NvbM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Frank Li <Frank.Li@nxp.com>,
	Linus Walleij <linusw@kernel.org>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 1494/1848] dmaengine: ste_dma40: Put the LCPA SRAM node
Date: Wed, 18 Nov 2026 15:58:52 +0100
Message-ID: <20261118150021.768986994@linuxfoundation.org>
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
index 9783841ad1db2..b790c3c9285aa 100644
--- a/drivers/dma/ste_dma40.c
+++ b/drivers/dma/ste_dma40.c
@@ -3579,6 +3579,7 @@ static int __init d40_probe(struct platform_device *pdev)
 	}
 	/* This is no device so read the address directly from the node */
 	ret = of_address_to_resource(np_lcpa, 0, &res_lcpa);
+	of_node_put(np_lcpa);
 	if (ret) {
 		dev_err(dev, "no LCPA SRAM resource\n");
 		goto report_failure;
-- 
2.53.0



