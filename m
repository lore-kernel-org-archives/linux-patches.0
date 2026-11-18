Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795049185;
	b=Eirdj2bQJy8XTZe+keUoRZ9Rw4r4uIzzkChWFisKM4mTVHIGi2Ckk2uV5ID73rvKC+IB
	 FQH97ZTl2yEtetmbUx89VLScMjOWfNo4XCRyJvVFro46tcpJ7nT3c0JRhnV5rQfnfta1t
	 z++gwLv/JL5lkfDu1MzIwoD0uFKA9WipXcTsD9WSyNvktb3RB+laGx/TBITq1STvJL4Qb
	 HyC8W1KVjeRUZ90dsjfvtMlcjcj15BPzViH5vWJdEVUjdfkrLYzaoyqog+27Dz2ZKh8SW
	 ER2vyaEdEOBgGodSVefUaOzWJlR0RZS4iJpjT80+jzQb2a0CfVn2q6xeG0RJTtq5T8w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795049185;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=fsSjp2VcL4WWaHLGqQ86zSrztCos0cBk+MCoGtPQtMU=;
	b=1FYMHeEQbg4LPHS7RvPhUtuizIqpifUkz5woKG/tUz3AJlAjuRsLIjTpWfx/MyAXzL4J
	 jTnn6z3j/W1HaPr4VIPmf9mwXW0UicPgOu7fEY8gC4ZB1NcyuuPMDGVowIFYl8UOC8r20
	 JjJYKfeCXEaWMlaVO/os+KOA0klNIzNW0snP+yvtEmREcEIXRO1a90+zPmQKqoMeioOss
	 ClK/+YLVloAydC4K1i3UT7SYojmXW0QFUdyCmWfVht7fGLS8ls4QlK2452pzz9R3D03RZ
	 B7bMc8Hxx6V6mFqtZW0zILUTCjQEg9wEpBwYHackmyYV0/zqfg4qHdl2WKhhmu1pL4g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=MSDaSD+m;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B9455606A31C;
	Thu, 19 Nov 2026 00:46:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=MSDaSD+m
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1546E1F000C6;
	Thu, 19 Nov 2026 00:46:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795049185;
	bh=fsSjp2VcL4WWaHLGqQ86zSrztCos0cBk+MCoGtPQtMU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=MSDaSD+miFEggTRsR8TFvMGWQf3QveCvXOrbrpovQdMnmFF/Z2pIjBcs9tSWVBGvL
	 m3Lw2z39lPu4MvxKcyF9+oblWhj375NPxCVhp+rDcWRDOuy4Vqbg1WTba3oMdhvEiR
	 mXm40oqKSkuifkdUQWZjOD4H95hYAgUiIYGpJbiI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Frank Li <Frank.Li@nxp.com>,
	Linus Walleij <linusw@kernel.org>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 2260/2857] dmaengine: ste_dma40: Put the LCPA SRAM node
Date: Wed, 18 Nov 2026 15:54:54 +0100
Message-ID: <20261118150322.822791484@linuxfoundation.org>
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
index 0773f2b4fb1ae..87825a157d470 100644
--- a/drivers/dma/ste_dma40.c
+++ b/drivers/dma/ste_dma40.c
@@ -3578,6 +3578,7 @@ static int __init d40_probe(struct platform_device *pdev)
 	}
 	/* This is no device so read the address directly from the node */
 	ret = of_address_to_resource(np_lcpa, 0, &res_lcpa);
+	of_node_put(np_lcpa);
 	if (ret) {
 		dev_err(dev, "no LCPA SRAM resource\n");
 		goto report_failure;
-- 
2.53.0



