Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 84BF3522A;
	Wed,  5 Feb 2025 14:27:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738765679; cv=none; b=VbdYn+J7yGrLh7SGMtiVh6Y1SdwiyjP9vollQz1Ngn4c1ORYW7ZZn/LtwRLp3qqjBZHVHOaMBND7S1p9hREupsjMtuzDF2m1epmK3jJA0VKbRWViuuvuugQ9LDT0NIxPdGnIKmsmUeEjj3WiEe/OEi2bE8gN2/pskTU6NDjnSCI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738765679; c=relaxed/simple;
	bh=HRSbf9sdFHdrc4YL2rWOMSj/O70BsEvc3Vhi2Zye4jE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Bdr6b5LnzS1vgAlmWtwyZEiKZ+EfYJ1yQtqO6VwQRl5lZxgak3OPsw61UGLK8SKyC0bzARYKQsxFnBR/u/X4TxGy/+F2jeiizv0jHKGxl/9JeFSQ+IfXQhWBeRY+6WGKuHrJvAEeW/xxoWAVe1QO/1T2JS6UIpWbg0+mfAbX1mI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Tuxa2eri; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Tuxa2eri"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E2212C4CED1;
	Wed,  5 Feb 2025 14:27:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738765679;
	bh=HRSbf9sdFHdrc4YL2rWOMSj/O70BsEvc3Vhi2Zye4jE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Tuxa2eri5RXMZ8aQpSWO/SCI3Jx58nBAz1hJh9qD4mBfQU9za57CJB4Hl+9x02eKv
	 aVjNa+RIjVOmjE/3o2wF/oyu5VslaUtMyW+hCdcBZsN5GvZHHdXEm4brsB3vFfcMyL
	 buN+uSqziBH+vboebfrt6ZyY8aIfrz5wIegcG1MI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiasheng Jiang <jiashengjiangcool@gmail.com>,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 289/393] media: camif-core: Add check for clk_enable()
Date: Wed,  5 Feb 2025 14:43:28 +0100
Message-ID: <20250205134431.370207401@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250205134420.279368572@linuxfoundation.org>
References: <20250205134420.279368572@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index e4529f666e206..8c597dd01713a 100644
--- a/drivers/media/platform/samsung/s3c-camif/camif-core.c
+++ b/drivers/media/platform/samsung/s3c-camif/camif-core.c
@@ -527,10 +527,19 @@ static void s3c_camif_remove(struct platform_device *pdev)
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



