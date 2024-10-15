Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A43B1C07F4;
	Tue, 15 Oct 2024 13:00:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728997214; cv=none; b=dOGL/mR1JU6UV8aMctjbgm/KZo50+KDMIZogMQWnrCnvRZu2Gxhi6q+C/6Fbp5Yrw/tUeZvcJvhOwozv1swSqJgqb3lCmQoOfKneLWYh+Zputof1C/KFsgLoOZ0KExKTpd3kdi8AbYh4/BZx4gA+zjKymHe4xQ8i3RpUowD5P2A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728997214; c=relaxed/simple;
	bh=8RrIjGIBIYRB3HDU/rzwWZDHZ1zdUAXu7dG6W+4f6uc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rN5rFg1PizT0+D/QYGZxYKgbXIevZW56Qh8JzHaB9AQ0vW1JbBe6dAcDFiBO0cF8+c9xOCj7xuUMS+qy+X9p7p0z0RfppU25rimDVHKAnDfAjLB8zgCLtCzrtK/eG33cBvi9vXLzplncAuZUi50z7rwci+cb966Yg4/WyVXP8+w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2g6OC+eB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2g6OC+eB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AD02FC4CEC6;
	Tue, 15 Oct 2024 13:00:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728997214;
	bh=8RrIjGIBIYRB3HDU/rzwWZDHZ1zdUAXu7dG6W+4f6uc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2g6OC+eBMM/BAUxvSHTj/kPSsnwIHeM01qVYtbe1RPR1UnUXxC+D/11xV6TSvUs6J
	 W6nL4W4WqaJcGSsuMh1xwDC53x2bBriqbw9DzLL9TFIpiJfklmFxOjl+ThGKKaVejm
	 McypoWLGW0hpPx/DF14Rwib1NWy2gizXO48PW9nA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alex Bee <knaerzche@gmail.com>,
	Jonas Karlman <jonas@kwiboo.se>,
	Heiko Stuebner <heiko@sntech.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 119/518] drm/rockchip: vop: Allow 4096px width scaling
Date: Tue, 15 Oct 2024 14:40:23 +0200
Message-ID: <20241015123921.588464436@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241015123916.821186887@linuxfoundation.org>
References: <20241015123916.821186887@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 682d78fab9a59..d4a3170d1678c 100644
--- a/drivers/gpu/drm/rockchip/rockchip_drm_vop.c
+++ b/drivers/gpu/drm/rockchip/rockchip_drm_vop.c
@@ -370,8 +370,8 @@ static void scl_vop_cal_scl_fac(struct vop *vop, const struct vop_win_data *win,
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



