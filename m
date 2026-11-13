Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794591415;
	b=Rp29ai+LAYjTLIPytOe5DDwOJlBs6Yf72HrOVUSc/rLAqtr1V6l5/JWWTawlx5fbYXDx
	 kocSW/d16BW3/nWkDerxWoIpjDqkTBbr4jcCSvwU3WpxGjug6/tcoX0CQYT78Pz+yHAXy
	 UYtGiCNvyMuvBsOPHSzOvz4DxvmXvth9tReJeCau+UJ8LEh3CQIlX0FRY4QWQcJDU1+Va
	 5nwwMLlrV4FM7PTtqmAqmJOBgf+bNiaa8TS/iOquwuERx+cRHfAFxHSUbD6CGmW7AtIdx
	 bk1wsrnnG3nXhSvKYCvt7RuV9mjL2msKM4BqCH91PVgU8Hw5T9i3RaJThu5cxkQR9XA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794591415;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=QUdUykA0+L7N81BYe00EgDsJqwYhjB+jYT9i9TC7vC0=;
	b=SC1QCS+UEU/W0vQjhHRJyQyjborucajO7EcUnmR9C6/34PnIxXpsvRqguH/w0C7Pc28J
	 SLe62Q8PH4EEM7gGFOpDFhU34l7jqg7cZLimGwsdXVSuKa9TUPX9BK6KZw9Dqn5AW0RRQ
	 DcsHYRRDGqOSWfDFcV4K6FgYNyNmsoht8PqW5P0otidnch66CKpVMy0wR3c9m5bi226u4
	 qd5FdJX6G19GhcRDKKo4k1m/56WeVwXXSxMTp6WmczGE17tLxF6404pNwYg2pkSexML3I
	 4PZKDsXaLJe9knV92dlHAs5W6e4weFW0Cmk7chgic49Zg2IaZ/caNa+lkj5ExQ6rFfw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=q+iV2O2Q;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 33611606B23B;
	Fri, 13 Nov 2026 17:36:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=q+iV2O2Q
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D24E81F000C5;
	Fri, 13 Nov 2026 17:36:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794591415;
	bh=QUdUykA0+L7N81BYe00EgDsJqwYhjB+jYT9i9TC7vC0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=q+iV2O2Q1xjNOy/BBpwWaxoFau2Fsl2CTrzJppyd7ZMEsrbLZ+5/P/TufDFTVIEkW
	 Co7IWVBzvALN/miOAjjDk0mH8LY9NEDCcUiyzEw664opPNB1u94IkMDwUa4Kri0VKz
	 iDlFp/ek30wl/0iTRUUfUSLgs+Zz7gA1hBKS0Au8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Deepak Kumar Singh <deepak.singh@oss.qualcomm.com>,
	Vishnu Santhosh <vishnu.santhosh@oss.qualcomm.com>,
	Frank Li <Frank.Li@nxp.com>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 509/670] dmaengine: qcom: bam_dma: Defer IRQ trigger type to device tree
Date: Fri, 13 Nov 2026 10:51:13 -0500
Message-ID: <20261113153829.199156526@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153811.177190860@linuxfoundation.org>
References: <20261113153811.177190860@linuxfoundation.org>
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

From: Vishnu Santhosh <vishnu.santhosh@oss.qualcomm.com>

[ Upstream commit 3cee6f79553202d7d3954555560ac38d719344b8 ]

The driver hardcodes IRQF_TRIGGER_HIGH when registering the BAM
interrupt, which overrides the trigger type specified in the device
tree. On Qualcomm Shikra SoC, the A2 BAM signals an edge interrupt
to the apps processor; registering it as level-high causes the
interrupt to not fire, resulting in missed DMA completions.

Use IRQF_TRIGGER_NONE instead, which causes the kernel to use the
trigger type already configured by platform_get_irq() when it parsed
the device tree interrupts property. This makes the driver
platform-agnostic.

Fixes: e7c0fe2a5c84 ("dmaengine: add Qualcomm BAM dma driver")
Co-developed-by: Deepak Kumar Singh <deepak.singh@oss.qualcomm.com>
Signed-off-by: Deepak Kumar Singh <deepak.singh@oss.qualcomm.com>
Signed-off-by: Vishnu Santhosh <vishnu.santhosh@oss.qualcomm.com>
Reviewed-by: Frank Li <Frank.Li@nxp.com>
Link: https://patch.msgid.link/20260717-qcom-bam-dma-irq-trigger-v1-1-6405eac86f00@oss.qualcomm.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Stable-dep-of: 82eed160cfa7 ("dmaengine: qcom: bam_dma: free interrupt before the clock in error path")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/dma/qcom/bam_dma.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/dma/qcom/bam_dma.c b/drivers/dma/qcom/bam_dma.c
index cf647662ae81c..9f712e7c7e07f 100644
--- a/drivers/dma/qcom/bam_dma.c
+++ b/drivers/dma/qcom/bam_dma.c
@@ -1323,7 +1323,7 @@ static int bam_dma_probe(struct platform_device *pdev)
 		bam_channel_init(bdev, &bdev->channels[i], i);
 
 	ret = devm_request_irq(bdev->dev, bdev->irq, bam_dma_irq,
-			IRQF_TRIGGER_HIGH, "bam_dma", bdev);
+			IRQF_TRIGGER_NONE, "bam_dma", bdev);
 	if (ret)
 		goto err_bam_channel_exit;
 
-- 
2.53.0



