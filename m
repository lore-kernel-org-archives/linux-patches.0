Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E7E347FB10;
	Tue, 25 Aug 2026 13:31:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787664674; cv=none; b=Ivn70qUCXs0ntxDH0SRcR8btzfBl7T8e7ZilI3jKulVV//7ijskhDxKr2UNBZBZi6qUm7LUgUzkdxDVecUFGn7mN+XHL48/7U4BrxdttyIm1tBhcgeMFRTilKrx2yOiKQLYEQYcGQilU+OvVTPegNA1fbwUTmcdbl3/xO6Tw+0o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787664674; c=relaxed/simple;
	bh=2x0aSf8Jb9izXmlzQb0Ukaurcv7A6WFyXLYJrNPQRN0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uh7/2mGO8RSOb7mDdb520eVcRhvWKkLwQuJ0RS4dthPnL4uzno4MMXmy7lWCApV97cfBirLA+y0w9cQrI5zrX1kvp4834VZZRrIMu2m3iYuTekKROvIw42YgdN2t0SpiHGbHpIlsMhCFYKgSHBbde6r7Ws3o9hzXHZ9dGHyeviI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cHy14Txm; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cHy14Txm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 740BB1F000E9;
	Tue, 25 Aug 2026 13:31:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787664673;
	bh=rxSRPEjfOLm7O42lgV5rhizdSc/CA8a+TxQm5+duJ2U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=cHy14Txm2KmH2jLJ8eO4Umy/6G0yictjcrh3DtQGE8/Dmy+3hps90zmBD11uzqwJE
	 DdifI6DxVXg5R+AHX11nMJx705F91XOxkoBsMbDlk7mDfQl+TMxssvingO1ET7rowr
	 BEznHrJ8ZPrYJ0nIn1MQzvb6mtD07HW8OqndCX7E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Frank Li <Frank.Li@nxp.com>,
	Vinod Koul <vkoul@kernel.org>,
	imx@lists.linux.dev,
	Griffin Kroah-Hartman <griffin@kroah.com>
Subject: [PATCH 7.2 49/82] dmaengine: fsl-edma: Add error handling for devm_kasprintf
Date: Tue, 25 Aug 2026 15:25:36 +0200
Message-ID: <20260825132543.436484289@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260825132541.560541185@linuxfoundation.org>
References: <20260825132541.560541185@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Griffin Kroah-Hartman <griffin@kroah.com>

commit bf1af4dfdc017dfe989c0dbcf0e608dc95f1d2cb upstream.

Add error handling statement to fls_edma3_irq_init() for the
devm_kasprintf call.

Assisted-by: gkh_clanker_2000
Cc: stable <stable@kernel.org>
Cc: Frank Li <Frank.Li@nxp.com>
Cc: Vinod Koul <vkoul@kernel.org>
Cc: imx@lists.linux.dev
Signed-off-by: Griffin Kroah-Hartman <griffin@kroah.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Reviewed-by: Frank Li <Frank.Li@nxp.com>
Link: https://patch.msgid.link/2026070605-frying-fling-b9c5@gregkh
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/dma/fsl-edma-main.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/dma/fsl-edma-main.c
+++ b/drivers/dma/fsl-edma-main.c
@@ -414,6 +414,8 @@ static int fsl_edma3_irq_init(struct pla
 
 		errirq_name = devm_kasprintf(&pdev->dev, GFP_KERNEL, "%s-err",
 					     dev_name(&pdev->dev));
+		if (!errirq_name)
+			return -ENOMEM;
 
 		ret = devm_request_irq(&pdev->dev, fsl_edma->errirq, fsl_edma3_err_handler_shared,
 				       0, errirq_name, fsl_edma);


