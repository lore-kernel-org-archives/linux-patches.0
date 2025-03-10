Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8619417CA12;
	Mon, 10 Mar 2025 17:50:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741629006; cv=none; b=BotS7OB2QOicbfdsz8IA/g0UIWoi3n9QS6fMgNI40P3r9eLq7EteXEIg/6g29WZ2Wh4PDFNdycIiCDv0oxAQQyfMB4e0ly6V7KbZRNULxj2gOTP1xSzo6MUUyQINl0+p+pHH3c9uzinyjA/XpdJcV9IetYWLzuDf6DbcPSG73W8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741629006; c=relaxed/simple;
	bh=aDWSD/osikZzlNJYXu9iLvQu2UicE0SByXbFORjEGOQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KEpcpV64SmXv4XdFPAUPJ0g5Y32m6QFg29ar9lvYT4IStxAi/smigy/dQA0MyGzmqeV4xDV5knuCEOE9/izzSLZJuJxxXojEZgrsJttSR1RfCripGO2S3WUnCAOfOH1papuN3s2wKVQkXWfWfIISVzYvtbxcvxFDSguvLA+ccks=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HYfQVyk7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HYfQVyk7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0C17DC4CEE5;
	Mon, 10 Mar 2025 17:50:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741629006;
	bh=aDWSD/osikZzlNJYXu9iLvQu2UicE0SByXbFORjEGOQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HYfQVyk7AjQ+pdZIipl+lV8qStlqTNR80YBezVIM8vbBWUHg5FeyNv81xF2U0v/jc
	 cQ6ulqOPaj2YKSCY0mHy9p17DSXaYmwdlNCHNgsjtRdDgVptReZQ358zAfqhqS0910
	 WDlGzH8oNwMU7s3r1vY59IR/O98KtqjjLfm+NVE4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiasheng Jiang <jiashengjiangcool@gmail.com>,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 143/620] media: camif-core: Add check for clk_enable()
Date: Mon, 10 Mar 2025 17:59:49 +0100
Message-ID: <20250310170551.242958696@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250310170545.553361750@linuxfoundation.org>
References: <20250310170545.553361750@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
 drivers/media/platform/s3c-camif/camif-core.c | 13 +++++++++++--
 1 file changed, 11 insertions(+), 2 deletions(-)

diff --git a/drivers/media/platform/s3c-camif/camif-core.c b/drivers/media/platform/s3c-camif/camif-core.c
index e1d51fd3e7008..e4c8e3f19626d 100644
--- a/drivers/media/platform/s3c-camif/camif-core.c
+++ b/drivers/media/platform/s3c-camif/camif-core.c
@@ -532,10 +532,19 @@ static int s3c_camif_remove(struct platform_device *pdev)
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



