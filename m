Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795025565;
	b=VYSccRVQFTm+Mj5pFhoZsY9OzRVkYd/rtxUhpSKlrR3B7jFgAurTezvaHTFwTaLnqz/w
	 A2gO5a9CQREp8iDG1e0mJJy1/tmbmXNs0TEe1oSMpaXPJcBUsMnhESmzl8uiTW33t4Xkh
	 zpaIbbCwJ7X4NMGEmIpqnkpnM3BQsNT2FwoiopfehBiePtjIiFLyaJuLTCudt2/fSZZ16
	 yLsun8b1rIIm80vc7I8gkUve2drfPRqg4qA0oBhtiBsL72jEnfkPUaC8iiAPu7jvH2IyG
	 bkhKPX52jN1+ahPtKIlSGsxfVb6mI1bt4Q4HFtrOPB8nxcmO8IFznrDN/xe0puA9ROA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795025565;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=oX+vPxDngns7eGe6JdO+PNwd9DbXn2EEVPCOxmiMZyM=;
	b=zugH7sHtApCwIeVrGQ7LicaU7/s2JUaj+DW/kPt32+iF6N9ABq14kf+hNYnusrtpYRPQ
	 q7/gNrFgGWCF3COsOQ9s9sk6AbcxojxLycvJBJ8MqYVYmRomaEOMjeqJHaaf5R6Tae37L
	 EgW+O9oK0EO9exfLcb3DvmhCRF8KNrkb/G+u+SHdEZ2yuOXSTahPfcHHYISDNTmn4Yht3
	 2iFYZvs2bkXm2vQOd6YyRuxHQeVgmHK7/ujQ97gEhda5IXTTfMAqeMLIMmCagqrRPNYx9
	 ZYm9sTtFV/88PtQSK4j0Ij8tIbUsLmgAKE71vw8QwcoIbZCb4a38/wKgU5DnU/TRD6g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=sQ9Np47r;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4AFC6606A32A;
	Wed, 18 Nov 2026 18:12:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=sQ9Np47r
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 99F4E1F000C5;
	Wed, 18 Nov 2026 18:12:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795025565;
	bh=oX+vPxDngns7eGe6JdO+PNwd9DbXn2EEVPCOxmiMZyM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=sQ9Np47rpOb6mn52rKKDy9MEGCjuqvYl2D0VeO1NOORAXskwEokwZbYTOy1ynoLZ9
	 ktyk9kENAVzd0ybpOQd7fUZ7ZLENye0QWA5Gl97sTtdNKyfFlx2OXPJMQU4P6XPfiO
	 msJH2ly5balQP+iel/Dh68gI+Z+bm9AWClkueZ+o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Frank Li <Frank.Li@nxp.com>,
	Linus Walleij <linusw@kernel.org>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1125/2151] dmaengine: ste_dma40: Put the LCPA SRAM node
Date: Wed, 18 Nov 2026 15:47:40 +0100
Message-ID: <20261118150203.183543279@linuxfoundation.org>
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
index 2dea28bdd5e8a..1e17a4fff6d54 100644
--- a/drivers/dma/ste_dma40.c
+++ b/drivers/dma/ste_dma40.c
@@ -3606,6 +3606,7 @@ static int __init d40_probe(struct platform_device *pdev)
 	}
 	/* This is no device so read the address directly from the node */
 	ret = of_address_to_resource(np_lcpa, 0, &res_lcpa);
+	of_node_put(np_lcpa);
 	if (ret) {
 		dev_err(dev, "no LCPA SRAM resource\n");
 		goto report_failure;
-- 
2.53.0



