Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795030961;
	b=5c70bfybaM8xTVKaXe57NWGOHzpTP9YBxDlPFpr5Scn5tpuu1AyM3TNldYU5jKTVEXN5
	 7g4S+6b2RmxGh6i2Z1Uk6TYt8oOntYPnbwRUdcNYxqjOcm1fdzieAGLsx1nX7TTz2k3t8
	 n0aZ4HtleN33WGqbXrsjL3QtmEGupOpJXlY8f41OZckpF6YNNiQ01/nqrvXbTDZHpEmu2
	 5O0gkNSMuBje8zhbcKKMi2o1tKQgORpjv1eoYQiL2xHsC27qCcPnTqoGr3EhDZmJ1goJo
	 UnrA9wwoGjV6KHYdKvbSxQlnnfyvc1XGPnirzRK2A64pEsgmXRlFgOLUkvv9T2A0FFw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795030961;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=+Is3+hTznYKlrCB8dFcM71/LCp+dIR+D3dfKzFGk0jk=;
	b=VLgPJdTEZPC9sonzNOlnMVWP4Aalcx4cEZ1Xj17noGn9Kuk7pRusBhQS82PqItiJLj/T
	 gmoNEZ/9rnemgTb2E9R4deC+6SIErBXQaylQhOFrqCytBVOuPFT7zUUGQPc3VHutDZtRT
	 r8QkTPbXtYOrS3IEDOHtKruK9NKhRCsS6Jq0o7t0wgdateXc+RdMDe7tJMBXhJbLxi1mC
	 Q9xIgeXq7XO1VElBW0vL4RYsE0hSNcNdtgBNCut7UfTqAx6UZ7pv+4ggoc/GR8pIf/wRP
	 rU5LkATspAj3GNkQk0GfyHagufpKJ4SiZ51sYU/ffwt94K/Ep0vJAn3AWAsbJLopZcw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="U3/Fdgn+";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E1B9606A911;
	Wed, 18 Nov 2026 19:42:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=U3/Fdgn+
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 81A7D1F000C5;
	Wed, 18 Nov 2026 19:42:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795030961;
	bh=+Is3+hTznYKlrCB8dFcM71/LCp+dIR+D3dfKzFGk0jk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=U3/Fdgn+jIiL6NxLravfd8nyTBQVeYN5SA5ZqeDRj/HkGDs6URKn0qSIMDx0pgd3K
	 0xgrWXdNN6zSFyIDd8McBbHMSQcDrNF7UMlbzzyQ+Wi/4U56GynS5GCjy1B7D2y1T5
	 iO7+xGKpyXRaF6Yjlc+w+Ou+8MJwVr7dml5Yfo30=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Frank Li <Frank.Li@nxp.com>,
	Linus Walleij <linusw@kernel.org>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0890/1756] dmaengine: ste_dma40: Put the LCPA SRAM node
Date: Wed, 18 Nov 2026 15:50:17 +0100
Message-ID: <20261118150045.260229372@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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



