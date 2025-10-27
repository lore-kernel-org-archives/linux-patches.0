Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 06A07241663;
	Mon, 27 Oct 2025 19:11:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761592269; cv=none; b=EiJmiO6BrKEHQJN9y6QtY3U7iznzZj/6aE583jJbHFbBeDsR2DwOSb1wIPXWbAxkyu4RKRx8o5ISMPuDep2QAR0T4ITL7X/6pmeMfbMtS0CEiO4TmE8Rlmmw9gxeZqVpbtDq2bGt+BMQ0gWzHITLoXZx/vjkTjJ0gZGZi6jsbU4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761592269; c=relaxed/simple;
	bh=PvDus+oGbgJRWVOGz33tR63HGG5ocxq5l9TTCtMrBbY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WwBMkp60vHggVO4VleuyCmt66zXhdO5P4oxHkwzv80Rf9w1WrbTQk70aC+QN16KfXHNNpqedG7A2lX3+oxvkYJm6JC7ufdsTDQOPPBTK+c2bbYPbkHNzUhr+nZFilwkls/iJO3A0yI/LUqfW85cZ5L0FQJZTCaONqlAJLIoSU5I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=q0NnodXB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="q0NnodXB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8B236C4CEF1;
	Mon, 27 Oct 2025 19:11:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761592268;
	bh=PvDus+oGbgJRWVOGz33tR63HGG5ocxq5l9TTCtMrBbY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=q0NnodXBfcRrv3LiOV0DJOmx86O14CYFkB97EUbTlA/nVjT/L2uPglFSpJJknx1Gj
	 a6tdoQO+3BYnJpFw1C5GQp1O0HjHyEWPM8KHk1xsQ1t5vRQRPSNQM4Q511UDcnfUqW
	 Bkg77ETzVbkyO2D93ijWATtM9atDjlEEyO0n1/RI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alok Tiwari <alok.a.tiwari@oracle.com>,
	Andy Yan <andy.yan@rock-chips.com>,
	Heiko Stuebner <heiko@sntech.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 058/157] drm/rockchip: vop2: use correct destination rectangle height check
Date: Mon, 27 Oct 2025 19:35:19 +0100
Message-ID: <20251027183502.845331598@linuxfoundation.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251027183501.227243846@linuxfoundation.org>
References: <20251027183501.227243846@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alok Tiwari <alok.a.tiwari@oracle.com>

[ Upstream commit 7f38a1487555604bc4e210fa7cc9b1bce981c40e ]

The vop2_plane_atomic_check() function incorrectly checks
drm_rect_width(dest) twice instead of verifying both width and height.
Fix the second condition to use drm_rect_height(dest) so that invalid
destination rectangles with height < 4 are correctly rejected.

Fixes: 604be85547ce ("drm/rockchip: Add VOP2 driver")
Signed-off-by: Alok Tiwari <alok.a.tiwari@oracle.com>
Reviewed-by: Andy Yan <andy.yan@rock-chips.com>
Signed-off-by: Heiko Stuebner <heiko@sntech.de>
Link: https://lore.kernel.org/r/20251012142005.660727-1-alok.a.tiwari@oracle.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/rockchip/rockchip_drm_vop2.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/rockchip/rockchip_drm_vop2.c b/drivers/gpu/drm/rockchip/rockchip_drm_vop2.c
index 6efa0a51b7d65..e14557d80efc2 100644
--- a/drivers/gpu/drm/rockchip/rockchip_drm_vop2.c
+++ b/drivers/gpu/drm/rockchip/rockchip_drm_vop2.c
@@ -983,7 +983,7 @@ static int vop2_plane_atomic_check(struct drm_plane *plane,
 		return format;
 
 	if (drm_rect_width(src) >> 16 < 4 || drm_rect_height(src) >> 16 < 4 ||
-	    drm_rect_width(dest) < 4 || drm_rect_width(dest) < 4) {
+	    drm_rect_width(dest) < 4 || drm_rect_height(dest) < 4) {
 		drm_err(vop2->drm, "Invalid size: %dx%d->%dx%d, min size is 4x4\n",
 			drm_rect_width(src) >> 16, drm_rect_height(src) >> 16,
 			drm_rect_width(dest), drm_rect_height(dest));
-- 
2.51.0



