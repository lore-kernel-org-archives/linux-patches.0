Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 62D3229A30A;
	Tue, 11 Nov 2025 01:45:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762825543; cv=none; b=GTYhLYGPZtaHMLuRz+RBbz7TOb+w5Vy5yKGfP9rHWidI2CZd2z/AALH7m8usGvMaMbUk3bIMp/M1bUHWgsTBzYIDQBqq8oSDblKozwsIkid1CKU+IU2RY3K0DLZAUYPLThbGD4uuLwoFaQ/6xu+KrnOEzXFF6bv2Tp4ZExKALN8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762825543; c=relaxed/simple;
	bh=VCrWwMySMzkGM1n0wmMvQ2u364EyozNQZ+lIcYiVLnQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bHedxiMQkx1BBM7ntAortE5LC9mISz8PvSS8p7xiDu68B9sjK7TdpCXMhZLOHPu0LbpnJ5sHm0XvSz7RMnrGp5uC9g5aBatIK+nB+CguIkfeenphjLQqeP07J6sHxmViitX5CQqEH33how/JGLd1CZa4+7nig8z32O0Qjreoa/E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=olIyFwrq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="olIyFwrq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EB6C7C113D0;
	Tue, 11 Nov 2025 01:45:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762825543;
	bh=VCrWwMySMzkGM1n0wmMvQ2u364EyozNQZ+lIcYiVLnQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=olIyFwrqytrrGcEBnodNGTVvc8t+wI05Ht6aiNy2zD987AP2i+WvOVd9zXAflK8/E
	 +C9r9PDCECwbnp14mFv7nY2VstghvQxcnkyTV0dYQ/QTsAgAamddV/fOt9lO5HDkKj
	 Jna3SbirRezXvf0Mst1w5tF9R/80+ZsyevopFXpU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Abel Vesa <abel.vesa@linaro.org>,
	Jessica Zhang <jessica.zhang@oss.qualcomm.com>,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Subject: [PATCH 6.17 845/849] drm/msm/dpu: Fix adjusted mode clock check for 3d merge
Date: Tue, 11 Nov 2025 09:46:55 +0900
Message-ID: <20251111004556.847128693@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004536.460310036@linuxfoundation.org>
References: <20251111004536.460310036@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jessica Zhang <jessica.zhang@oss.qualcomm.com>

commit f5d079564c44baaeedf5e25f4b943aa042ea0eb1 upstream.

Since 3D merge allows for larger modes to be supported across 2 layer
mixers, filter modes based on adjusted mode clock / 2 when 3d merge is
supported.

Reported-by: Abel Vesa <abel.vesa@linaro.org>
Fixes: 62b7d6835288 ("drm/msm/dpu: Filter modes based on adjusted mode clock")
Signed-off-by: Jessica Zhang <jessica.zhang@oss.qualcomm.com>
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
Reviewed-by: Abel Vesa <abel.vesa@linaro.org>
Tested-by: Abel Vesa <abel.vesa@linaro.org>
Tested-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Patchwork: https://patchwork.freedesktop.org/patch/676353/
Link: https://lore.kernel.org/r/20250923-modeclk-fix-v2-1-01fcd0b2465a@oss.qualcomm.com
Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/msm/disp/dpu1/dpu_crtc.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/gpu/drm/msm/disp/dpu1/dpu_crtc.c
+++ b/drivers/gpu/drm/msm/disp/dpu1/dpu_crtc.c
@@ -1546,6 +1546,9 @@ static enum drm_mode_status dpu_crtc_mod
 	adjusted_mode_clk = dpu_core_perf_adjusted_mode_clk(mode->clock,
 							    dpu_kms->perf.perf_cfg);
 
+	if (dpu_kms->catalog->caps->has_3d_merge)
+		adjusted_mode_clk /= 2;
+
 	/*
 	 * The given mode, adjusted for the perf clock factor, should not exceed
 	 * the max core clock rate


