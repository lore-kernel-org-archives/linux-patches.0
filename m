Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD210187FF6;
	Tue, 30 Jul 2024 16:44:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722357851; cv=none; b=ePMd6dBEH3eBhXkbbqIXFFYlI6DTSuRH5+cjRBpUYpSHE396CQESzHaMoXH6+oEAF5SBbLh3bUp/177pW0003IFYEZb8xK+SDSsQtzKUajTHPBirm17Se3VJ4NeCPanIjoBUqAoRuFrocOTtZNX8RtN83gvp370tKGjiRnCwyfw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722357851; c=relaxed/simple;
	bh=CjZQqRUX+H3XDlOqNIbd1R7ON0TTMLz0+3B5s0eeq+w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JEwWiuk3nMUHx5/sg/FNCO7jOrrtnh6MK4MrpcAw5L8JRP8W25QKA3cN9F4100ljSwGGdxCxyyZTfsJKtPJX4ETo2nLdVgTV8bzHdBQcfi2hKM0FUmcr6DCHtKP1HV4sOx1mq2sZT01P0edF0nsyLK3TajsziC3Q/6Dw/zNl5PI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=k9fFGc4d; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="k9fFGc4d"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 40784C4AF0C;
	Tue, 30 Jul 2024 16:44:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722357851;
	bh=CjZQqRUX+H3XDlOqNIbd1R7ON0TTMLz0+3B5s0eeq+w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=k9fFGc4dKaOuATZrK1WLmToZYqW+TxyvG1m5c8S1WwgKJdHRJwEVOG+eEm6YDd/mh
	 1RaHYWGq4pVek1Zt7yPDEhbTXiTCgLmQFNjGMspu/YmHG6UTKrjnq9MBcviofye61U
	 MOGYoGLrO/FvDRo1v+dt/i+0lNk8JqZjJL9w4tWo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Junhao Xie <bigfoot@classfun.cn>,
	Konrad Dybcio <konrad.dybcio@linaro.org>,
	Abhinav Kumar <quic_abhinavk@quicinc.com>,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Rob Clark <robdclark@chromium.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 298/809] drm/msm/dpu: drop duplicate drm formats from wb2_formats arrays
Date: Tue, 30 Jul 2024 17:42:54 +0200
Message-ID: <20240730151736.363443929@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151724.637682316@linuxfoundation.org>
References: <20240730151724.637682316@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Junhao Xie <bigfoot@classfun.cn>

[ Upstream commit 6ed817592638348e83facfe6a4deedb8d5e83357 ]

There are duplicate items in wb2_formats_rgb and wb2_formats_rgb_yuv,
which cause weston assertions failed.

weston: libweston/drm-formats.c:131: weston_drm_format_array_add_format:
Assertion `!weston_drm_format_array_find_format(formats, format)' failed.

Signed-off-by: Junhao Xie <bigfoot@classfun.cn>
Reviewed-by: Konrad Dybcio <konrad.dybcio@linaro.org>
Fixes: 8c16b988ba2d ("drm/msm/dpu: introduce separate wb2_format arrays for rgb and yuv")
Fixes: 53324b99bd7b ("drm/msm/dpu: add writeback blocks to the sm8250 DPU catalog")
Reviewed-by: Abhinav Kumar <quic_abhinavk@quicinc.com>
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Patchwork: https://patchwork.freedesktop.org/patch/596847/
Link: https://lore.kernel.org/r/20240524150128.1878297-2-bigfoot@classfun.cn
Signed-off-by: Abhinav Kumar <quic_abhinavk@quicinc.com>
Signed-off-by: Rob Clark <robdclark@chromium.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/msm/disp/dpu1/dpu_hw_catalog.c | 6 ------
 1 file changed, 6 deletions(-)

diff --git a/drivers/gpu/drm/msm/disp/dpu1/dpu_hw_catalog.c b/drivers/gpu/drm/msm/disp/dpu1/dpu_hw_catalog.c
index f2b6eac7601dd..9b72977feafa4 100644
--- a/drivers/gpu/drm/msm/disp/dpu1/dpu_hw_catalog.c
+++ b/drivers/gpu/drm/msm/disp/dpu1/dpu_hw_catalog.c
@@ -220,12 +220,9 @@ static const u32 wb2_formats_rgb[] = {
 	DRM_FORMAT_RGBA4444,
 	DRM_FORMAT_RGBX4444,
 	DRM_FORMAT_XRGB4444,
-	DRM_FORMAT_BGR565,
 	DRM_FORMAT_BGR888,
-	DRM_FORMAT_ABGR8888,
 	DRM_FORMAT_BGRA8888,
 	DRM_FORMAT_BGRX8888,
-	DRM_FORMAT_XBGR8888,
 	DRM_FORMAT_ABGR1555,
 	DRM_FORMAT_BGRA5551,
 	DRM_FORMAT_XBGR1555,
@@ -254,12 +251,9 @@ static const u32 wb2_formats_rgb_yuv[] = {
 	DRM_FORMAT_RGBA4444,
 	DRM_FORMAT_RGBX4444,
 	DRM_FORMAT_XRGB4444,
-	DRM_FORMAT_BGR565,
 	DRM_FORMAT_BGR888,
-	DRM_FORMAT_ABGR8888,
 	DRM_FORMAT_BGRA8888,
 	DRM_FORMAT_BGRX8888,
-	DRM_FORMAT_XBGR8888,
 	DRM_FORMAT_ABGR1555,
 	DRM_FORMAT_BGRA5551,
 	DRM_FORMAT_XBGR1555,
-- 
2.43.0



