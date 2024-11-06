Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B1C2E1D5AD7;
	Wed,  6 Nov 2024 12:11:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730895062; cv=none; b=fmr45nGe11E6APzgEPlK3ToeO13EVEH8Muhp0RdNnflIdWElxJc603pIFCmOp4SBDpGWEdRZn5duejRHi/3rgy9t1O9o7dxepD2Kte2aTTAEF3xnXRMmcDscm/eKz9kLxoAfAH+KMAMg4OsNc3nvxnDAzV9idzlRK0eWwi3L0Yw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730895062; c=relaxed/simple;
	bh=n1+RJTJBOrIyOZBHrxodSB/yMMJIqhfkQk+yqceCmkg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=l63mJYvxDF5nrT4lK978QY3sgWicLVQWt7tpSQWo8yVPbAxoIq7DP18BTSpjZ0Jo0iajDZlqt8U4YvO84uXypnWV8Oh7HQ1fSs/Zwh4cZTQVC1TeWjQihrt5RwHc+msfoPVeM5l74bFMlHNJKxiyN8iWHzIsq69OPbWBBB7QWoU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Xv+tj48G; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Xv+tj48G"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 31683C4CECD;
	Wed,  6 Nov 2024 12:11:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730895062;
	bh=n1+RJTJBOrIyOZBHrxodSB/yMMJIqhfkQk+yqceCmkg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Xv+tj48GZHc+TVOwubKOcvtxTNMFk0p+/jT9Msc5/gnude/2VSpkcgJGZEDAX5Sej
	 RdHNrUvacbQDRqcTfellQomlYz2dUqmB91ohqsnScW4KNp3Mn8XdsHi2Av3TW5QBiF
	 FV3mVlUzhrZzvgIUnEnTjGFHYqVMX24VBwa2aBb0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alex Bee <knaerzche@gmail.com>,
	Jonas Karlman <jonas@kwiboo.se>,
	Heiko Stuebner <heiko@sntech.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 056/350] drm/rockchip: vop: Allow 4096px width scaling
Date: Wed,  6 Nov 2024 12:59:44 +0100
Message-ID: <20241106120322.274475690@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241106120320.865793091@linuxfoundation.org>
References: <20241106120320.865793091@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alex Bee <knaerzche@gmail.com>

[ Upstream commit 0ef968d91a20b5da581839f093f98f7a03a804f7 ]

There is no reason to limit VOP scaling to 3840px width, the limit of
RK3288, when there are newer VOP versions that support 4096px width.

Change to enforce a maximum of 4096px width plane scaling, the maximum
supported output width of the VOP versions supported by this driver.

Fixes: 4c156c21c794 ("drm/rockchip: vop: support plane scale")
Signed-off-by: Alex Bee <knaerzche@gmail.com>
Signed-off-by: Jonas Karlman <jonas@kwiboo.se>
Signed-off-by: Heiko Stuebner <heiko@sntech.de>
Link: https://patchwork.freedesktop.org/patch/msgid/20240615170417.3134517-4-jonas@kwiboo.se
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/rockchip/rockchip_drm_vop.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/rockchip/rockchip_drm_vop.c b/drivers/gpu/drm/rockchip/rockchip_drm_vop.c
index c502d24b8253e..63c4e16ec449d 100644
--- a/drivers/gpu/drm/rockchip/rockchip_drm_vop.c
+++ b/drivers/gpu/drm/rockchip/rockchip_drm_vop.c
@@ -308,8 +308,8 @@ static void scl_vop_cal_scl_fac(struct vop *vop, const struct vop_win_data *win,
 	if (info->is_yuv)
 		is_yuv = true;
 
-	if (dst_w > 3840) {
-		DRM_DEV_ERROR(vop->dev, "Maximum dst width (3840) exceeded\n");
+	if (dst_w > 4096) {
+		DRM_DEV_ERROR(vop->dev, "Maximum dst width (4096) exceeded\n");
 		return;
 	}
 
-- 
2.43.0



