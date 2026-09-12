Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3AFDB1DA62E;
	Sat, 12 Sep 2026 07:41:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789198885; cv=none; b=KIrOEoE3VlKk8eOJkYYYdL24U2py+ncUtSL1/qfp4orb45FExoIqkUStJN30CdSmm00V6QPT+IvgDSjb2+4jAibsa0VNrCNZUot4RVAnsR+3YWH9RtG3b/g+nJah8NipB1b/+FMhzq5d6xPrbl9r/FDc7+7d0z6MCGi5y+jTsMk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789198885; c=relaxed/simple;
	bh=yhP//FVm/+fjVbh79mYUIT01IznwXwyOCLN9OF5w0DA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lru23gF91QkyYbaTAvbmxPeFX29I2F4e0wcz+7IF7pYgkjbadLxtKI518pX5r9SBWkutIzcCc2TG6z6JUOpdVaGSP9FDtJNg39SzWqmwbm0cWH56ExjwxdpgND+0XcrApOrIe2o+g1oGqlSdnTmLfoOABLJi4Sfapfq4VkloY5U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jGAX95U7; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jGAX95U7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DA4BB1F000FF;
	Sat, 12 Sep 2026 07:41:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789198883;
	bh=hI5byBZYEYNSDvirllJAohyg47Kmqf+f+FCXIqmSdfo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jGAX95U7QZ8XREnvPgFvnlCM/zXvBsz/ADFxdwwib++nw8k9AH54Nj55ZC8H2IQJR
	 Sst7WzBkSYERI1sa72RnM19fdy+bo1Gxvqi/1Ut0UNv02HrhLK1VfbXy4VxO/D7qUx
	 swHyiYX+3pUWJiVo6AH8Yib/4f1vc2ToyYFodYwQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shivam Rawat <shivrawa@qti.qualcomm.com>,
	Akhil P Oommen <akhilpo@oss.qualcomm.com>,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Rob Clark <robin.clark@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>,
	Neil Armstrong <neil.armstrong@linaro.org>
Subject: [PATCH 7.2 0473/1815] drm/msm/a6xx: Fix stale rpmh votes after suspend
Date: Sat, 12 Sep 2026 08:37:03 +0200
Message-ID: <20260912065659.989975153@linuxfoundation.org>
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

From: Shivam Rawat <shivrawa@qti.qualcomm.com>

[ Upstream commit d9108bfdb746edacdb05bd27959a4ae63c6c7f3f ]

There are stale RPMH votes (BCM votes) observed after GMU suspend. This
is because the rpmh stop sequences are skipped during gmu suspend. Fix
this and also move GMU to reset state to avoid any further activity.

Fixes: f248d5d5159a ("drm/msm/a6xx: Fix PDC sleep sequence")
Signed-off-by: Shivam Rawat <shivrawa@qti.qualcomm.com>
Signed-off-by: Akhil P Oommen <akhilpo@oss.qualcomm.com>
Tested-by: Neil Armstrong <neil.armstrong@linaro.org> # on SM8650-HDK
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
Reviewed-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Patchwork: https://patchwork.freedesktop.org/patch/730652/
Message-ID: <20260605-assorted-fixes-june-v1-1-2caa04f7287c@oss.qualcomm.com>
Signed-off-by: Rob Clark <robin.clark@oss.qualcomm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/msm/adreno/a6xx_gmu.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/msm/adreno/a6xx_gmu.c b/drivers/gpu/drm/msm/adreno/a6xx_gmu.c
index 2e5d7b53a0c38..a2f6918c4f7f2 100644
--- a/drivers/gpu/drm/msm/adreno/a6xx_gmu.c
+++ b/drivers/gpu/drm/msm/adreno/a6xx_gmu.c
@@ -642,7 +642,7 @@ static void a6xx_rpmh_stop(struct a6xx_gmu *gmu)
 	int ret;
 	u32 val;
 
-	if (test_and_clear_bit(GMU_STATUS_FW_START, &gmu->status))
+	if (!test_and_clear_bit(GMU_STATUS_FW_START, &gmu->status))
 		return;
 
 	if (adreno_is_a840(adreno_gpu))
@@ -1465,6 +1465,9 @@ static void a6xx_gmu_shutdown(struct a6xx_gmu *gmu)
 	/* Stop the interrupts and mask the hardware */
 	a6xx_gmu_irq_disable(gmu);
 
+	/* Halt the gmu cm3 core */
+	gmu_write(gmu, REG_A6XX_GMU_CM3_SYSRESET, 1);
+
 	/* Tell RPMh to power off the GPU */
 	a6xx_rpmh_stop(gmu);
 
-- 
2.53.0



