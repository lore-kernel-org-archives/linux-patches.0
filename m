Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 21E2A38E8A8;
	Sat, 12 Sep 2026 08:10:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789200649; cv=none; b=hsqhkXKx5UUjM/8KdpLd4utHJnT3C9hBTDwcED7O3jjW4QKTtfu1hkV9uWtgi4cjrqIR4qMky0m1clBsGmluPkKS4x23v7swa/eGqKRrjlVjsxx0D08ILV8oS8lWWG/ny+YKKVcjU1k/9Sf04yyqsDBL2pNwK9ga4KJHcKPWtY0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789200649; c=relaxed/simple;
	bh=3iutN3AJTrX9N14f0lAAJsoN9eXiF8ngZAG0lX3Cq/g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hErTkUQVVnC08CyctU0zLA0JLWlTEHAkVxax2hvUOXPDIBS9OeQhH/1JYPx/Bisnz4yt4JXxCZ5etbfrKOUi+x8qCo/AvxSn/LPGONKNgS4O/BwfuTQzy6G04I7KXtYfSZbHNklVNZrQH2Vkic9GPhoUflhJR5tumtlmPzwe7tI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=U60SdNJY; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="U60SdNJY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B5A341F000FF;
	Sat, 12 Sep 2026 08:10:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789200648;
	bh=zBGs1wXf7xHpjd4SAWJY6lUfU55m4fdu6RYTK+dBnJs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=U60SdNJYm/xm6rwafTtpbufmKwpUH+oFRSsHaMVx3thQ6xnnKDUcfYSo8vhaI8z2N
	 qdmOmykFRzzgeZ8wxab2zz6xGEp0G5ZEbHR0IPOUormhLYAN6pPCqfqlp6BC9FEjLe
	 /7A7T8Lq6aXxQUzL7RlGpaDGczvrhb1eEsHXvWN4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Imran Shaik <imran.shaik@oss.qualcomm.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 0834/1815] clk: qcom: gpucc-qcm2290: Drop pm_clk handling
Date: Sat, 12 Sep 2026 08:43:04 +0200
Message-ID: <20260912065708.492656228@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
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

From: Imran Shaik <imran.shaik@oss.qualcomm.com>

[ Upstream commit 1b2e1f5a37dd4c856a9269bc7e5988c642db5847 ]

Drop the pm_clk handling from QCM2290 GPUCC driver as the required GCC AHB
clocks are kept always enabled by the GCC driver during probe.

Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
Reviewed-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Signed-off-by: Imran Shaik <imran.shaik@oss.qualcomm.com>
Link: https://lore.kernel.org/r/20260718-shikra-dispcc-gpucc-v6-8-62703e05ef0f@oss.qualcomm.com
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Stable-dep-of: 7274ea68d2b4 ("clk: qcom: gpucc-qcm2290: Keep the critical clocks always-on from probe")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/qcom/gpucc-qcm2290.c | 11 -----------
 1 file changed, 11 deletions(-)

diff --git a/drivers/clk/qcom/gpucc-qcm2290.c b/drivers/clk/qcom/gpucc-qcm2290.c
index 4e97a02d942ad..f14b4620090ef 100644
--- a/drivers/clk/qcom/gpucc-qcm2290.c
+++ b/drivers/clk/qcom/gpucc-qcm2290.c
@@ -7,7 +7,6 @@
 #include <linux/clk-provider.h>
 #include <linux/module.h>
 #include <linux/platform_device.h>
-#include <linux/pm_clock.h>
 #include <linux/pm_runtime.h>
 #include <linux/regmap.h>
 
@@ -385,16 +384,6 @@ static int gpu_cc_qcm2290_probe(struct platform_device *pdev)
 	if (ret)
 		return ret;
 
-	ret = devm_pm_clk_create(&pdev->dev);
-	if (ret)
-		return ret;
-
-	ret = pm_clk_add(&pdev->dev, NULL);
-	if (ret < 0) {
-		dev_err(&pdev->dev, "failed to acquire ahb clock\n");
-		return ret;
-	}
-
 	ret = pm_runtime_resume_and_get(&pdev->dev);
 	if (ret)
 		return ret;
-- 
2.53.0



