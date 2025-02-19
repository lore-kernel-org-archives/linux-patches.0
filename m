Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 73FF61B4F21;
	Wed, 19 Feb 2025 09:14:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739956486; cv=none; b=BS6j/02RidkqUCQZCAo1YpujSGqJATW8nfRieyVqsI17ZmpJj39/RklL63KDjLGhzEKHnWwSXHkO3nF1iBFeN5v/E+MvgaIpL3GwGNrDbiwaeqNdLxMtC51lbgdxn89JPhDIc26IvbOcvOiL1CEKsrm18y8u2OgZvdGNAeIgcRg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739956486; c=relaxed/simple;
	bh=zQ7ACg1w4BXQGRH9SWQgyuDubza2W281ubV1aNZwRfI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=V05fD4ji8PiflD0HFLUbqpj9gvkKapv9RrwJeHpx+Yjs1ZLtRQ9cD15qKg5gHfv0weRtmQUZdWLgesAEMPywg6PZg7c92TRCHB/e4SFvy8ZKr30y2rR40AJhh0LiulfuBmjo5dsdiqRosLqV5k0sCIAf9HsT/y2VH9IKh89lHL8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qdHG39jU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qdHG39jU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8857DC4CED1;
	Wed, 19 Feb 2025 09:14:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739956485;
	bh=zQ7ACg1w4BXQGRH9SWQgyuDubza2W281ubV1aNZwRfI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qdHG39jUvRG9zRuwADL04Sw6+R6wxKKj5WaZPYXsOUu6y6RhQUdEYI1wwuJG6jEvC
	 HYsqkQ7cXpANlUYQ0d+03Qf+CAp3oeZ1PtUSGAcSoFBnvv3gQ5NFhSvdfEwYi8KQWj
	 NI0Jz/8O5lGTYh14OxRG/gWvfUW7yQdxCn2dEM5U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiasheng Jiang <jiashengjiangcool@gmail.com>,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 195/578] media: camif-core: Add check for clk_enable()
Date: Wed, 19 Feb 2025 09:23:19 +0100
Message-ID: <20250219082700.630797266@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250219082652.891560343@linuxfoundation.org>
References: <20250219082652.891560343@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Jiasheng Jiang <jiashengjiangcool@gmail.com>

[ Upstream commit 77ed2470ac09c2b0a33cf3f98cc51d18ba9ed976 ]

Add check for the return value of clk_enable() to gurantee the success.

Fixes: babde1c243b2 ("[media] V4L: Add driver for S3C24XX/S3C64XX SoC series camera interface")
Signed-off-by: Jiasheng Jiang <jiashengjiangcool@gmail.com>
Reviewed-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../media/platform/samsung/s3c-camif/camif-core.c   | 13 +++++++++++--
 1 file changed, 11 insertions(+), 2 deletions(-)

diff --git a/drivers/media/platform/samsung/s3c-camif/camif-core.c b/drivers/media/platform/samsung/s3c-camif/camif-core.c
index 6e8ef86566b78..38c586b01b174 100644
--- a/drivers/media/platform/samsung/s3c-camif/camif-core.c
+++ b/drivers/media/platform/samsung/s3c-camif/camif-core.c
@@ -528,10 +528,19 @@ static int s3c_camif_remove(struct platform_device *pdev)
 static int s3c_camif_runtime_resume(struct device *dev)
 {
 	struct camif_dev *camif = dev_get_drvdata(dev);
+	int ret;
+
+	ret = clk_enable(camif->clock[CLK_GATE]);
+	if (ret)
+		return ret;
 
-	clk_enable(camif->clock[CLK_GATE]);
 	/* null op on s3c244x */
-	clk_enable(camif->clock[CLK_CAM]);
+	ret = clk_enable(camif->clock[CLK_CAM]);
+	if (ret) {
+		clk_disable(camif->clock[CLK_GATE]);
+		return ret;
+	}
+
 	return 0;
 }
 
-- 
2.39.5



