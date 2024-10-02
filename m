Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA5831D0BB2;
	Wed,  2 Oct 2024 14:02:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727877767; cv=none; b=hU7nZlEA0xG5vzu+f8x1P+VFU/hmWimwvOq1cpEoE+gRMfgoPo/wQJe/L44RvEGHlqfGVF0NJeZyTo+jjcHp/wzmlCM0JgmPVLtldyRFRf1t8kn1bRK70aYp7qlpwKctYy2r6SUfEtxzHq7l1lTYZ9uN0HyVtE/d/xiolA01q9A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727877767; c=relaxed/simple;
	bh=jYKiReDE0CDXoflQT7i/9wCzvZEvTC1RbZ53GA7/Q58=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IVWR7qr8WSaARQ7vY/vF6C7Qn2g0HIXi9ZImGe3IIC8s/Mvo0Wha/airdggg7HA+vlHnk5zX0xDAmKhHMT7Q1wZdHLATzfLwoUeCTKjV+jUg7fS5ZprNYSS77i1NWadm0P6X6qATUcfELOaf3SpfFUiP0qDSxv3Tfbje4stTJJU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jtwE6Z6F; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jtwE6Z6F"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 52139C4CECD;
	Wed,  2 Oct 2024 14:02:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727877767;
	bh=jYKiReDE0CDXoflQT7i/9wCzvZEvTC1RbZ53GA7/Q58=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jtwE6Z6FOewob30BgKRvVdV3amHTAN3DmaX0Pj+Q56MsYFm0sQC+2psNN3gtTkqJc
	 xA4ioO1zipNbbbv0/inrX5tU0RkG41mhwRz2HWYLtO0q2rAZbnSoyapgbHzGRQrnEl
	 owjYX+vjOBvoA2prcqLDKM7siZ9c1m7vK+Ws6ksw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alex Bee <knaerzche@gmail.com>,
	Jonas Karlman <jonas@kwiboo.se>,
	Heiko Stuebner <heiko@sntech.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 187/634] drm/rockchip: vop: Allow 4096px width scaling
Date: Wed,  2 Oct 2024 14:54:47 +0200
Message-ID: <20241002125818.487995905@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125811.070689334@linuxfoundation.org>
References: <20241002125811.070689334@linuxfoundation.org>
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
index a13473b2d54c4..4a9c6ea7f15dc 100644
--- a/drivers/gpu/drm/rockchip/rockchip_drm_vop.c
+++ b/drivers/gpu/drm/rockchip/rockchip_drm_vop.c
@@ -396,8 +396,8 @@ static void scl_vop_cal_scl_fac(struct vop *vop, const struct vop_win_data *win,
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



