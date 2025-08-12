Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8DC82305E08;
	Tue, 12 Aug 2025 18:10:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755022225; cv=none; b=mvc5vTVI1wIoL7U7QAJfBvEUK26vm0xRc2zBsHEpOvfLDgF1DxnxfkD/9vnkNjDKAivCfCOQahd+im9iJxj1mDXxlpU1DyZeciyNBtsMwVeISO5cRPOxry6U8TdBMJi2TtiTVqUw1QbPq4MQC8xCZYtdQa1JjoBcZH98Hp+FhkU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755022225; c=relaxed/simple;
	bh=A7Ali4ztDuqXAX2CXDkGynw49zXo07irer7cTQAUhhg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mZAx46VLn8lFYJqfNfDbIfsCoTu8BbJMVHLDEUWTMEIb/qQ6+7Aspi/bPhQIWW41xWAn29XI+CS42AZJgJmF8xykCRk7nOs91/MuejYswLfSelRDVJe6AYdbF5cz7nkfJwjP1WBHo4lbNhG3zdd9kcJyJ87JPcKSwXH65DFIkgw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=az99JpJ/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="az99JpJ/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E9EF5C4CEF0;
	Tue, 12 Aug 2025 18:10:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755022225;
	bh=A7Ali4ztDuqXAX2CXDkGynw49zXo07irer7cTQAUhhg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=az99JpJ/taORXIc0MEFwfZmxyBMDdgxbOnMdHLwW/1D4CbeeEn3bRbDkudHu+Eedd
	 i2ZxC8YgnbaATQydBpcHNadU9u4Z5I52EwRbUgDJfXchRrWO9DG0fh40VIx6Hg//CI
	 n/57+biKxQ0t0NmADUeU8+bnGkKsJTt5Pb+QOiVQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 092/369] drm/msm/dpu: Fill in min_prefill_lines for SC8180X
Date: Tue, 12 Aug 2025 19:26:29 +0200
Message-ID: <20250812173018.244474496@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812173014.736537091@linuxfoundation.org>
References: <20250812173014.736537091@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>

[ Upstream commit 5136acc40afc0261802e5cb01b04f871bf6d876b ]

Based on the downstream release, predictably same value as for SM8150.

Signed-off-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Fixes: f3af2d6ee9ab ("drm/msm/dpu: Add SC8180x to hw catalog")
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
Patchwork: https://patchwork.freedesktop.org/patch/657794/
Link: https://lore.kernel.org/r/20250610-topic-dpu_8180_mpl-v1-1-f480cd22f11c@oss.qualcomm.com
Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/msm/disp/dpu1/catalog/dpu_5_1_sc8180x.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/gpu/drm/msm/disp/dpu1/catalog/dpu_5_1_sc8180x.h b/drivers/gpu/drm/msm/disp/dpu1/catalog/dpu_5_1_sc8180x.h
index 485c3041c801..67f0694a2f10 100644
--- a/drivers/gpu/drm/msm/disp/dpu1/catalog/dpu_5_1_sc8180x.h
+++ b/drivers/gpu/drm/msm/disp/dpu1/catalog/dpu_5_1_sc8180x.h
@@ -383,6 +383,7 @@ static const struct dpu_perf_cfg sc8180x_perf_data = {
 	.min_core_ib = 2400000,
 	.min_llcc_ib = 800000,
 	.min_dram_ib = 800000,
+	.min_prefill_lines = 24,
 	.danger_lut_tbl = {0xf, 0xffff, 0x0},
 	.safe_lut_tbl = {0xfff0, 0xf000, 0xffff},
 	.qos_lut_tbl = {
-- 
2.39.5



