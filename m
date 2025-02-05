Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D0CB5DF71;
	Wed,  5 Feb 2025 15:02:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738767777; cv=none; b=Fuw9D0K3/72gMFJ7EN79J8vZ5K9QMax36VSsI3irunbJIfsffRWD11j4Uip/mMS2AH9ZnL3OACBip2QTeD+72QI6C64pbqFrHoEMlSfMGl1XruGZ0079ranhxqlKYB6kWs5gqlaoHcaboqh0MBJQY/8ZnjVEzAtQ4mpfGTav1nY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738767777; c=relaxed/simple;
	bh=0sBno1v49j39QQIOOTWLVUCJ3+HSkwN2QWYWoO+kY5Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jKboH2AH5Z5MEsv1hXfy2uT6+mCr/PLLvHqMmGL/DUcUlSlyh5gnJ0T6sdokWtMrCjcboZgZPzU8wnttJW+vYLqDBHhiU7qg47TKLOBHVahAX6ZUpeXanVSBljXGBI/fU+UfAqPnTm360Ku3YukX1bJRjLZA2rsBbKRoMwPl0wY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=i+qNavFK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="i+qNavFK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 346D0C4CED1;
	Wed,  5 Feb 2025 15:02:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738767777;
	bh=0sBno1v49j39QQIOOTWLVUCJ3+HSkwN2QWYWoO+kY5Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=i+qNavFKJ386nY9OMNslTbs79Qy9JYw0ogcZ/Y0Rbmeie/OVoDVM/07FdqQJpKnRd
	 mZc5gL9lXZj7dFBrHPfbHjMDgxu21ekNEt3/Qo3RshW+afsEo8314E0yLTmfbtNu9e
	 ArQGsAfk0ez3lfNQPnedQTSGC9GQNRb9S4mbn9hQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiasheng Jiang <jiashengjiangcool@gmail.com>,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 452/623] media: camif-core: Add check for clk_enable()
Date: Wed,  5 Feb 2025 14:43:14 +0100
Message-ID: <20250205134513.508410965@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250205134456.221272033@linuxfoundation.org>
References: <20250205134456.221272033@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

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
index de6e8f1518496..221e3c447f361 100644
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



