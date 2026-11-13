Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794590696;
	b=FgSEKCGHOHs97feVjz1WGWCR34f9dHImtjYMZxOn2u5wnizN7JEPiojpLSMlQvYD5Lhd
	 ApwtzwgLuU56UnIQWn/mVvupTf07IBebtD9n88XOXOt5xZbvZNFQdOpfGOQQCTlfQdEJJ
	 HqWz0Gph9YBrD7pgFwdecMqnQlxweXT2AY9i8qSxQ6eifyzfL3+4P7lIVSKaCawOiIXAI
	 0/xPbr1DEnB+6WI77q+jslF6SHA78ZM1P6Ycu0vV/xsBWzcV7qCC5mw7reo+auxt4zRAc
	 99VKKjWQM2BIGQR9gEFLrOsIp1Mb8E4/xcMhT4SoRt5Jxdg/PMguMsMVaxX7wFefXNQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794590696;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=98sby4dGAFZS1zUMWb9yh86Ff3oi6rLXl/HLWd4i0fY=;
	b=ZO9ZG0PrFX3CrJa+7Gt20/04+6Jo15XxaxwEeEBZipVCoGqhXAmZ4cRk8m78gUFcKbbD
	 fh9tsQy7jmrvKOhL3rcEwrqOURgaUwS8tyKkUjhfPESYQd1fWrRNq+iT7De6fwN/sskfM
	 lOOSvzN2Y+3Gs8D2lcUpH7sjZ/6wPT22E7IcdOpOPaDPaWwHMbJUIbpc67AMyT0PgMZhB
	 6brHeDaJJdMivh74BI7CSvcJmHaUgYLiy7Bx/1z4zEY3Hub8tjRl0aP57l4jderzkcmBa
	 XGW9nCD3lBCDX29m9MQBwe+5Wzh12kctfV0yJSZGQo0uMFM5Qe1xVq2CtqE5/eVqFhw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ci2ZjcOl;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C70760A3834;
	Fri, 13 Nov 2026 17:24:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ci2ZjcOl
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ECDEF1F000C5;
	Fri, 13 Nov 2026 17:24:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794590696;
	bh=98sby4dGAFZS1zUMWb9yh86Ff3oi6rLXl/HLWd4i0fY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ci2ZjcOl/tmC8Q8WJ2Wd+yZEQDaLrfjk2m8C3FDrAx2YjFeq7waLHlfJn/+VTtWCk
	 zHH57Db56sc/BI7IB/2KYZD3c5WoObZ3Ebm6jzV/EcCAaiWI3jQWhtbyIAJWIaETlQ
	 vgdS4+oddY0rGOctBG/9eABN4DvrryVCEA+PIftc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Deepak Kumar Singh <deepak.singh@oss.qualcomm.com>,
	Vishnu Santhosh <vishnu.santhosh@oss.qualcomm.com>,
	Frank Li <Frank.Li@nxp.com>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 554/686] dmaengine: qcom: bam_dma: Defer IRQ trigger type to device tree
Date: Fri, 13 Nov 2026 10:51:27 -0500
Message-ID: <20261113153840.355507006@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153820.902362109@linuxfoundation.org>
References: <20261113153820.902362109@linuxfoundation.org>
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
index 781cea16196f5..c8cd6112f9003 100644
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



