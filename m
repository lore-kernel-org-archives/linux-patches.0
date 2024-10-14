Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C63D04087C;
	Mon, 14 Oct 2024 14:55:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728917718; cv=none; b=YHJhIy6UQCtTwGzydwffUihDdn376pymMvbNIVsZBj7ywsDx0g1uWr7lgR5M9/VqOOnbE8L8lQ29+F2uVq22yZthv5JAICQ5GD6VxMHBuhW8MAOiSF8c9MRyezzvPiKpXifCWm5Bzm2dQDnsdQitw8+j8wFPArrIWF3uVgdWwOU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728917718; c=relaxed/simple;
	bh=1pAMdbR3bx1EAvw993PXB4k0v+PW+rQs3EmYb41Hpnw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qq62oUOxXREiJPo+FKsQEmp2I1nHeQmGSIGF0v+hn3Q69/wvvlhPLEkpeWXEsTTb2lKzyD3pANpZpMhLgFA/v3yUYVozsIMGsjsIutNDWgM8V0APGvQy2eXeIR6CH10ZuUTfCCA6aU0yA3krJ+zLiGcSPZZQl7PfMCYTAiFeyHc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VY+gHA4/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VY+gHA4/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 36E08C4CECF;
	Mon, 14 Oct 2024 14:55:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728917718;
	bh=1pAMdbR3bx1EAvw993PXB4k0v+PW+rQs3EmYb41Hpnw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VY+gHA4/WTJ+BsGUfWfT+EI/3SDNzBinB7Q8ZNaMWaXMwR4Bjz1/DetNvCgn3ctdq
	 +0hMsvv+r9CbRtI3YbWvC4x8A90tUygdhZ3LGB7hU8CTux3duFjyow0f+D/Q/n0WTF
	 4/fhT6oTqf4it2G0F8qCmbcMt0Ye2eFBR6WuytN0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alex Bee <knaerzche@gmail.com>,
	Jonas Karlman <jonas@kwiboo.se>,
	Heiko Stuebner <heiko@sntech.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 113/798] drm/rockchip: vop: Allow 4096px width scaling
Date: Mon, 14 Oct 2024 16:11:07 +0200
Message-ID: <20241014141222.365213143@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241014141217.941104064@linuxfoundation.org>
References: <20241014141217.941104064@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 632ab8941eb44..59fde46f6dff8 100644
--- a/drivers/gpu/drm/rockchip/rockchip_drm_vop.c
+++ b/drivers/gpu/drm/rockchip/rockchip_drm_vop.c
@@ -385,8 +385,8 @@ static void scl_vop_cal_scl_fac(struct vop *vop, const struct vop_win_data *win,
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



