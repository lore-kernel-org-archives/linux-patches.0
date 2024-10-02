Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1BBD81D1F5D;
	Wed,  2 Oct 2024 14:31:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727879518; cv=none; b=BtmIOzA2FcW3xGG+2hNlf0NsjOoILC4hryguyNu5JZ0MWL8BLnD/vyz87z6c0rl1Xw/cACHShoj0cpAgccs9wh2mbiIOheQcNFQe2kqE69Rgu27+i15ktwshuZ6x+tWoNWpxn06BP0uzAQIYiHJDxKHqUBG+St4uz1ZDHXOzkp0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727879518; c=relaxed/simple;
	bh=vTwl1kAc7HqGrXDHAKKOm1gSfx1qxLqs3pfmUny4Gdg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LnPL0KVuqMPF6t6MDsfZeVZ0WEVwudGT/n6id5NRNODa0mKzS/QeIrL6Wg/51Sv16Br6WKYZ/4Dz1EmPoeMxfWN98IInjGiFO3KdePKYBqVIPXE5n+a+IUvHhEC5WZq0RjK/nYF5XLYLXVHk+kCYoFvyGL5pAP/PrDbU6lMBIeU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=q0X/SGA4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="q0X/SGA4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 99955C4CECE;
	Wed,  2 Oct 2024 14:31:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727879518;
	bh=vTwl1kAc7HqGrXDHAKKOm1gSfx1qxLqs3pfmUny4Gdg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=q0X/SGA4lLh4HzYN6xHhTeUVpp0aC5CCtB7RzddJCeXkmneJLgS7Iqop4cmtk3/Uq
	 gZ5glZshV+5sV5hKYCVwT09UPRZrTNfD+y8NAJ8YkqiueBNJTOGVZMP2IefHhTWPQS
	 nE9PQB3JZpeBMF7uo3KgLR6oIWy9MVVv3TmuQewQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alex Bee <knaerzche@gmail.com>,
	Jonas Karlman <jonas@kwiboo.se>,
	Heiko Stuebner <heiko@sntech.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 146/538] drm/rockchip: vop: Allow 4096px width scaling
Date: Wed,  2 Oct 2024 14:56:25 +0200
Message-ID: <20241002125758.017623659@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125751.964700919@linuxfoundation.org>
References: <20241002125751.964700919@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 4b338cb89d32d..c6fbfc0baeccd 100644
--- a/drivers/gpu/drm/rockchip/rockchip_drm_vop.c
+++ b/drivers/gpu/drm/rockchip/rockchip_drm_vop.c
@@ -381,8 +381,8 @@ static void scl_vop_cal_scl_fac(struct vop *vop, const struct vop_win_data *win,
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



