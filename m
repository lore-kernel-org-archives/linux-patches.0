Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795046952;
	b=J/27E8zNafFcYrvx79ZnIrFiVxdK3fMgzfW78L5b3L0dVQ2E+mbeszI2nXmZjVirhrzZ
	 f5xO/y8OSLIQlx3cseleExi4RP3zWEGHq1LfxvVDMbwZjirkbpZRGEGl3YkQn1yQlISoZ
	 erqp1P+aT6Ixbm/hd+Ig6ppsqM++L1F8X/XwtzfMav3ik/EFo6uod3hxtoWBMOPxagI9M
	 kttRcQbGK+LJAHd79dvkzVMjM6lpaFrmUQWZxVngu2JuTfOQpwqR0DTlpCP6E6oq/rt8Q
	 ZiWJN1Bi8GIt6E5NdbIShEf+GPzHl0dNbWBtz7u1oWj2RPfLbMY653EXSSZrgY8FDoA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795046952;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=7Ihd6DxFfE7q3nJUTVtG17ZRjTmtGTWf4UKVx4gBw0I=;
	b=LKEbhwKIW9GyVB9hmI9Xdt6JKgw2Y2gGTsu/MW3iN/3DH5EY965DMcJ+DYqtrEJmZGl0
	 AFEK7bBbiWMlmcA6OjfYzN7SNx/IRNVKMgusrdUfpk7nQuoSYnMT9BhDaZPM1LeO7nIQX
	 jCNj9kpHw58n7xRjUjgG8djNlmhrN8OjvdmBM44OeAOkXpMhPCpw2oGejfF61EmJ4lp8w
	 sk1zXGT+Wcb+k3lUZ9mWbYguDhuAAVnmgyHP2nwDc5oxXmZfLCdXeBHjOIiJzxW6GeJKS
	 IaBLr5m1gb3HK85CWgUJZGGHr2PcmbuZeXoUEtmhiXVYv1BwuInGz6i3a2aFrZqxp6Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=mMPZR0My;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A8D5606A320;
	Thu, 19 Nov 2026 00:09:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=mMPZR0My
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A9F451F000C6;
	Thu, 19 Nov 2026 00:09:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795046952;
	bh=7Ihd6DxFfE7q3nJUTVtG17ZRjTmtGTWf4UKVx4gBw0I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mMPZR0MyB0MovPraiJPt/nx/DaWgh9tXNl2sUNhTjupDouVDxl9cUTE447XJbxzX9
	 5leDoiKL4XtTjztSatw+WQu3hPOaKXn4EXx5zm2kV4NT+nqPlCedgR1hAWB1i2/AaU
	 wvWFIqlrZvaMxeaNsyyGEHeOVPVQcoxclq14ybQg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Deepak Kumar Singh <deepak.singh@oss.qualcomm.com>,
	Vishnu Santhosh <vishnu.santhosh@oss.qualcomm.com>,
	Frank Li <Frank.Li@nxp.com>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1424/2857] dmaengine: qcom: bam_dma: Defer IRQ trigger type to device tree
Date: Wed, 18 Nov 2026 15:40:58 +0100
Message-ID: <20261118150252.592451357@linuxfoundation.org>
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
index 68295eed43d8e..a8cf834867353 100644
--- a/drivers/dma/qcom/bam_dma.c
+++ b/drivers/dma/qcom/bam_dma.c
@@ -1325,7 +1325,7 @@ static int bam_dma_probe(struct platform_device *pdev)
 		bam_channel_init(bdev, &bdev->channels[i], i);
 
 	ret = devm_request_irq(bdev->dev, bdev->irq, bam_dma_irq,
-			IRQF_TRIGGER_HIGH, "bam_dma", bdev);
+			IRQF_TRIGGER_NONE, "bam_dma", bdev);
 	if (ret)
 		goto err_bam_channel_exit;
 
-- 
2.53.0



