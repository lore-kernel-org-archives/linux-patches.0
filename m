Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6346837E2F3;
	Sat, 12 Sep 2026 19:18:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789240729; cv=none; b=n9RzdJNN14XS5Bt362H4S/cjGWC/ehZMENbKr2u3RSppBW3/AUgm/Kj45L45oroIm9vv9aqUgB3IcA24RIIpWrGzG4U9VNiM1wITQY6pQ96MehvYuv6J0ZrIirsCU4bI5urHqPqjufl1rHoPyr+OWdUyBs7b/esukefp5783SDw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789240729; c=relaxed/simple;
	bh=uJqouFQSFsQGz46zoNriuq0NMIne/32+yKyKNvcVKyI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UjdwAJLFvENyzFRxzgsXxlpGDk63kmdc8KAPS3n/a9/OB18M4vFzazCfA+yOLsQ2NO6QnP1kfTjYToyJaV03QC8EoXi2sHuk0ViWvAX4y32m/48KlFfzIA6+bK/Cu5aqUrWh2nY+KmcJmM9PytE3jn8z+4Y1DRE0pVCMhz09uIw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=awzT0RYI; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="awzT0RYI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 26E941F000FF;
	Sat, 12 Sep 2026 19:18:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789240728;
	bh=CVfp8YCnDm+YdsNV5Yl9cRutoGE5BO9PYdSwd4A9+dw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=awzT0RYIcrCLBBrKy+qUZXwsRDVuRkn84ZtvRrkFDPbUR9Ageg+LWE91WcFLuy8KW
	 bmq7OFCUWJNJdvYNGBR03WfR49+tZSy3sq1IyeZi45B44xBEFM/Af0caTFy6Ijc2Bd
	 YChUzGLbfnlx05QvrlhwVabqgN35Yjp8x2vbpDsk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Abel Vesa <abel.vesa@linaro.org>,
	Bjorn Andersson <bjorn.andersson@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 927/935] clk: qcom: Drop mmcx gdsc supply for dispcc and videocc
Date: Sat, 12 Sep 2026 09:05:57 +0200
Message-ID: <20260912065548.079982886@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065526.833703348@linuxfoundation.org>
References: <20260912065526.833703348@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Abel Vesa <abel.vesa@linaro.org>

[ Upstream commit b1ec8b53c9ae5fae33d60e9638d39ca5346b941b ]

Both dispcc and videocc use mmcx power domain now.
Lets drop the supply mmcx from every gdsc.

Cc: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Fixes: 266e5cf39a0f ("arm64: dts: qcom: sm8250: remove mmcx regulator")
Signed-off-by: Abel Vesa <abel.vesa@linaro.org>
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Reviewed-by: Bjorn Andersson <bjorn.andersson@linaro.org>
Signed-off-by: Bjorn Andersson <bjorn.andersson@linaro.org>
Link: https://lore.kernel.org/r/20220713143200.3686765-1-abel.vesa@linaro.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/qcom/dispcc-sm8250.c  | 1 -
 drivers/clk/qcom/videocc-sm8250.c | 4 ----
 2 files changed, 5 deletions(-)

diff --git a/drivers/clk/qcom/dispcc-sm8250.c b/drivers/clk/qcom/dispcc-sm8250.c
index 2adb38ada9bfb..85bb2181bbafe 100644
--- a/drivers/clk/qcom/dispcc-sm8250.c
+++ b/drivers/clk/qcom/dispcc-sm8250.c
@@ -1136,7 +1136,6 @@ static struct gdsc mdss_gdsc = {
 	},
 	.pwrsts = PWRSTS_OFF_ON,
 	.flags = HW_CTRL,
-	.supply = "mmcx",
 };
 
 static struct clk_regmap *disp_cc_sm8250_clocks[] = {
diff --git a/drivers/clk/qcom/videocc-sm8250.c b/drivers/clk/qcom/videocc-sm8250.c
index 7b435a1c2c4b5..eedef85d90e51 100644
--- a/drivers/clk/qcom/videocc-sm8250.c
+++ b/drivers/clk/qcom/videocc-sm8250.c
@@ -276,7 +276,6 @@ static struct gdsc mvs0c_gdsc = {
 	},
 	.flags = 0,
 	.pwrsts = PWRSTS_OFF_ON,
-	.supply = "mmcx",
 };
 
 static struct gdsc mvs1c_gdsc = {
@@ -286,7 +285,6 @@ static struct gdsc mvs1c_gdsc = {
 	},
 	.flags = 0,
 	.pwrsts = PWRSTS_OFF_ON,
-	.supply = "mmcx",
 };
 
 static struct gdsc mvs0_gdsc = {
@@ -296,7 +294,6 @@ static struct gdsc mvs0_gdsc = {
 	},
 	.flags = HW_CTRL,
 	.pwrsts = PWRSTS_OFF_ON,
-	.supply = "mmcx",
 };
 
 static struct gdsc mvs1_gdsc = {
@@ -306,7 +303,6 @@ static struct gdsc mvs1_gdsc = {
 	},
 	.flags = HW_CTRL,
 	.pwrsts = PWRSTS_OFF_ON,
-	.supply = "mmcx",
 };
 
 static struct clk_regmap *video_cc_sm8250_clocks[] = {
-- 
2.53.0



