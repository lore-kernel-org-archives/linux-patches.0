Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D38A36E484;
	Sat, 12 Sep 2026 10:05:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789207511; cv=none; b=tLTkdQipqI22MTu/Z7PFhF87OL5DIgCwPBqriAzIYW3vP4YdbVt3lJiM6E2A75KUFIVlMcgl4kzRM7Y4P6hoRa+eEgDub/m1vWGjE/HE78y/IKBC28rgFggfUYJt49DcYNkOxejV50jz/Qu7nQZO0iMUluUcIIzYFppGMZj9Lno=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789207511; c=relaxed/simple;
	bh=U/sy5azezLNVxXhBtvpbnvuTcTdyl6THidzB75fZ2Es=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dRF23aXLRFq2dVgtut1qPhEZURXQnjbWVp66IQkT53orxDJ5tfGgIqFk1oIEi550fu4OFRCJygAITSjc74Y/BN/KesV1l0W7mYy/85ReGRTucA5ZbDCJT4+dmPgVmysZg9ggXZlVZ/b9aUk2tNrEOx1qjd3XoRU0mbnWgELkGmQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ac+z6jvK; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ac+z6jvK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1D7A81F000FF;
	Sat, 12 Sep 2026 10:05:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789207509;
	bh=fg1bT0NQMgCzwReJ7R2XviXzy2LfkDSLuIAPkXOZ9Zg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Ac+z6jvKiACUxkKfDPZ1mjM1R5dkkhkw0S0pJAqaAWMFTOxPlQA+NC0/xZMgymFDn
	 mJ1gqNtE3x8UA/HysfFPP00DdNGC8qgms014+BW7Qt62H7H4CPn+XBxaj5Rhy5EQWG
	 qwxPPxJfMfPLe4BYkHJe5kfv+tlHaJfum4xhhXyw=
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
Subject: [PATCH 6.18 0428/1518] drm/msm/a6xx: Fix stale rpmh votes after suspend
Date: Sat, 12 Sep 2026 08:43:17 +0200
Message-ID: <20260912065633.132913474@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065623.398859879@linuxfoundation.org>
References: <20260912065623.398859879@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index 21a3f9b0ab4c2..d06d874e19773 100644
--- a/drivers/gpu/drm/msm/adreno/a6xx_gmu.c
+++ b/drivers/gpu/drm/msm/adreno/a6xx_gmu.c
@@ -564,7 +564,7 @@ static void a6xx_rpmh_stop(struct a6xx_gmu *gmu)
 	int ret;
 	u32 val;
 
-	if (test_and_clear_bit(GMU_STATUS_FW_START, &gmu->status))
+	if (!test_and_clear_bit(GMU_STATUS_FW_START, &gmu->status))
 		return;
 
 	gmu_write(gmu, REG_A6XX_GMU_RSCC_CONTROL_REQ, 1);
@@ -1256,6 +1256,9 @@ static void a6xx_gmu_shutdown(struct a6xx_gmu *gmu)
 	/* Stop the interrupts and mask the hardware */
 	a6xx_gmu_irq_disable(gmu);
 
+	/* Halt the gmu cm3 core */
+	gmu_write(gmu, REG_A6XX_GMU_CM3_SYSRESET, 1);
+
 	/* Tell RPMh to power off the GPU */
 	a6xx_rpmh_stop(gmu);
 
-- 
2.53.0



