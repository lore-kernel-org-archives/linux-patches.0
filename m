Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA10F1E507;
	Fri, 27 Sep 2024 12:31:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727440279; cv=none; b=FIUsQCOCRNsw15AXI1UwqvAxYC92CWzOssIVTnt5pkcilzFbKinwnB2ZdZdd2u+ixxyPq6mfXVh8RDXLyIdJH7Iq0mURVEPUW6llTysqQf+Ls0l3QztZpAomD2el5QH9urENz8q58OjGFmXVVxSF9NEVAxdwctJMdEwJIWa/mvA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727440279; c=relaxed/simple;
	bh=GMwXb+k6jFcpGwYrSDlRo+IrrmQpiNvctDk6psuEqfU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IxY+o857S+k3Rr3381YF2bmFN4+lpxIhUz5yG+6a+7XAzxrlH0dyzM1p9cXjV9242oog0ubpt6dqdl74YaSfCszmOOHfN2Nny2BS85q7rljaONBaWaaWF23fsC+7FCpCV02D4ZhY+kqujPxIPtb41OTvo9564msPykSPQ1PatwA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DhlPdmJs; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DhlPdmJs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 77FD5C4CEC4;
	Fri, 27 Sep 2024 12:31:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727440278;
	bh=GMwXb+k6jFcpGwYrSDlRo+IrrmQpiNvctDk6psuEqfU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DhlPdmJsLPyZ8ZCrgn29iLHDZShDJKg7YZE8kx6dnB9xgHI0/8xS05da5v80GUtsU
	 Ed2cuqadyoqd6EcthIJ5T8fme7uYSvXt60R3wcpCa/9WVv15rOUb4eTJl+Vfv06OHG
	 x5CfQSqy/SbcdipFgAOSD77H+c2xqsE/jrefGu3s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Liao Chen <liaochen4@huawei.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 24/73] spi: bcm63xx: Enable module autoloading
Date: Fri, 27 Sep 2024 14:23:35 +0200
Message-ID: <20240927121720.871216732@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20240927121719.897851549@linuxfoundation.org>
References: <20240927121719.897851549@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Liao Chen <liaochen4@huawei.com>

[ Upstream commit 709df70a20e990d262c473ad9899314039e8ec82 ]

Add MODULE_DEVICE_TABLE(), so modules could be properly autoloaded based
on the alias from of_device_id table.

Signed-off-by: Liao Chen <liaochen4@huawei.com>
Link: https://patch.msgid.link/20240831094231.795024-1-liaochen4@huawei.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spi-bcm63xx.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/spi/spi-bcm63xx.c b/drivers/spi/spi-bcm63xx.c
index 147199002df1e..a9921dcd6b797 100644
--- a/drivers/spi/spi-bcm63xx.c
+++ b/drivers/spi/spi-bcm63xx.c
@@ -482,6 +482,7 @@ static const struct of_device_id bcm63xx_spi_of_match[] = {
 	{ .compatible = "brcm,bcm6358-spi", .data = &bcm6358_spi_reg_offsets },
 	{ },
 };
+MODULE_DEVICE_TABLE(of, bcm63xx_spi_of_match);
 
 static int bcm63xx_spi_probe(struct platform_device *pdev)
 {
-- 
2.43.0



