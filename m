Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795055815;
	b=GbNQ9H0WvMDXhwxE1D14UOdxRGC+j8IRmAWaIRoznmGVaOlpcMcRXs6BI3SsIJZjM9yJ
	 fcsVIvX3hzbRSpCHHUHYafDlkjn6AbIsQO3PN1hQPf3kQP8IAtwnmNOcTkyuILm02E/uv
	 Gnsb+Jl689yLr1xy5SbPUcX412ciE+nEmNRUqrT6rPyajuBteqlZPXeoNCr0NvWOx92T6
	 iRmDppxkgAe73U/SV8WElPQh7lhsJXTNyJjXpvEZIHflsukZkCz9969NtnoHkgP6BL5oR
	 B+zt20rLNm3VgVuWTkwYDQz1mcLmYj2S2zK+oMR9LJf9xr+qnfBdXM639+bgU0REbyQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795055815;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=bzYDEIW6a5N5jNxpsE51fYiGrgw8IN1McOBVgsY3Ozs=;
	b=D3JVcbOwuZS9mbPyVc0imXBE4nWPf9zPr/kGSk2aaeUnpufWtG8LEew/TvEL4ao3eEHQ
	 pxz8a7MsFw9SzxjxfemIxR34PLVcAAZl3sXGVUDGjnL7uv6eRxWoY4+wrAaCp6QKrlTtm
	 d+ncp9ZbHc8+rni03GJ4fua2kYyM2pmdGc8GZ6MHPZubUQbpOwHVw3ZFWyTkopmnrkI13
	 sDmieNxRlGSd5r9iFsTQzwtdk+df5Sonoxuj36D+TGl/XCuFtfs2+LpP2BTG6v+yYVY4X
	 qyV1CbPApeI6VKkRpI8SlNBP6CB0G4PdY5hje91II7aq3S6Jc1IKcw62serR4Q5+zTQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ZBssi6l8;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5AC0A606A32A;
	Thu, 19 Nov 2026 02:36:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ZBssi6l8
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B27D41F000C4;
	Thu, 19 Nov 2026 02:36:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795055815;
	bh=bzYDEIW6a5N5jNxpsE51fYiGrgw8IN1McOBVgsY3Ozs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ZBssi6l8Pe4fGGOI8fRdO/2Y4dd6WQYHQQlkZ5hmiio8vUlwKpQAfpqmnDI7jKHQR
	 ls694LXnbLLdnK9kd1X4Kb3jTP+jvGE94VEM9S6jz33ciOoUgNGNp+IvWOa2wrJvND
	 vV4K74cqbddqL6H3e/5XPPaXY90Aa1wYsFK4hGkY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Frank Li <Frank.Li@nxp.com>,
	Linus Walleij <linusw@kernel.org>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 1764/2214] dmaengine: ste_dma40: Put the LCPA SRAM node
Date: Wed, 18 Nov 2026 15:57:20 +0100
Message-ID: <20261118150122.099004602@linuxfoundation.org>
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
index e017298156f9c..4670d5bf9aef2 100644
--- a/drivers/dma/ste_dma40.c
+++ b/drivers/dma/ste_dma40.c
@@ -3558,6 +3558,7 @@ static int __init d40_probe(struct platform_device *pdev)
 	}
 	/* This is no device so read the address directly from the node */
 	ret = of_address_to_resource(np_lcpa, 0, &res_lcpa);
+	of_node_put(np_lcpa);
 	if (ret) {
 		dev_err(dev, "no LCPA SRAM resource\n");
 		goto report_failure;
-- 
2.53.0



