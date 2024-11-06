Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 57CE11EE01A;
	Wed,  6 Nov 2024 13:01:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730898062; cv=none; b=ZJ+7Jsnlacj9lObF+XR6IjOFppdeD5hTJYiikq/GGna65LIn79rEHVaJ1PwaeLM4E3fGL0HhnmzBfGQ0uKppnr2iYgAYE4l0uO5LSI+aw9Ii1SM9lULByygMD2c6Kt7UCHATw5YuRg4En9q8iBq+hGGybhH3emkT3B13S3QiUeg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730898062; c=relaxed/simple;
	bh=wTqCusAVtKAK3tiSEnesdOv5oN4uQR3/hXwba1cpaKA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ouEdMKqg6ODyus7N0nc0THuUXp1W9+ltZ5MW92krddYre9eyRqaml+bgaL+XcjqpCNIOm/By6oq22h5K4JZbxkeOf4T7uV555PNG1wl5jL5uPolqmX/izxTgE/lxytovYjyGa3BnTTrzlcZw2xYrWJOHLHmi9W/OJbPePH+zYO0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ck5vzG6o; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ck5vzG6o"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CE9A5C4CECD;
	Wed,  6 Nov 2024 13:01:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730898062;
	bh=wTqCusAVtKAK3tiSEnesdOv5oN4uQR3/hXwba1cpaKA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ck5vzG6oYeOjfdSPr5QvxgM28GkJn5xGRHnm+VV/fZqXxgUJLazHgx+ByPo4TFkaW
	 fV/2wlwQEk6vJrRihlAM0r50t1lrXkGhf2YPK0b8Ga3ezuPrdrt2AhD3qyGZt4IZL3
	 wxeQPJq8Cqn0d7yEbTg4J5geBgAIRk6QZw8I+6bc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alex Bee <knaerzche@gmail.com>,
	Jonas Karlman <jonas@kwiboo.se>,
	Heiko Stuebner <heiko@sntech.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 074/462] drm/rockchip: vop: Allow 4096px width scaling
Date: Wed,  6 Nov 2024 12:59:27 +0100
Message-ID: <20241106120333.336607457@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241106120331.497003148@linuxfoundation.org>
References: <20241106120331.497003148@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
index f2edb94214761..20da0c993039a 100644
--- a/drivers/gpu/drm/rockchip/rockchip_drm_vop.c
+++ b/drivers/gpu/drm/rockchip/rockchip_drm_vop.c
@@ -333,8 +333,8 @@ static void scl_vop_cal_scl_fac(struct vop *vop, const struct vop_win_data *win,
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



