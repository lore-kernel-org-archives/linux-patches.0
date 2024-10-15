Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 907591D9A42;
	Tue, 15 Oct 2024 11:43:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728992616; cv=none; b=eto0Li0ZQSwEotMuMTvSO9YETqKIAlbPypTH/an+ctZW2KBc4Mjer3siHU6XaA177g0nRGavsIDJHzoOMLZ4kVhCcsxKBE2lLN+tHreGYH9xn7b/9jwYILtwBzvzpNRfWMd9ACMrKzCTZ3eM8bPNUwP/cc4awrEuAVGE9VqS+Kg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728992616; c=relaxed/simple;
	bh=QeSpCYfoJWoRYJTOCrWuOkY3jjTUd4M06YWwgwR1l2U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=a8R+ayw79xfzLQhcVr2N+vIfdUQKOGS9rSRuJNX96lAofKLTCMdpIV3WlK9I1GhudAfr4M9vOy6fTzLu/MRUpFPjG96qSca6eVWWxR0cCB4UbzTFUOAUf2OGiuqVGsG6VWd/tx4TNrl2xk39oJ9tnrUG+b2mT+WdQ/LOe579Rgs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=G3IiscjG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="G3IiscjG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 141E4C4CEC6;
	Tue, 15 Oct 2024 11:43:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728992616;
	bh=QeSpCYfoJWoRYJTOCrWuOkY3jjTUd4M06YWwgwR1l2U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=G3IiscjGX3xQXGopi/xTOsJJh3MvLS0S8hl+beEr1dQEqSjCYqyqzD/xsZwg1NVgv
	 fc0XhiAeYhS6V+D2hxy5hh6YkJHT2LDRvTIOlOPjvZLUYqMmZ+D4n1UG3TruLg0V7v
	 QsFqelwtGgDU+ZRpfVVWahJO6JxZq7697+65/+ao=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alex Bee <knaerzche@gmail.com>,
	Jonas Karlman <jonas@kwiboo.se>,
	Heiko Stuebner <heiko@sntech.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 168/691] drm/rockchip: vop: Allow 4096px width scaling
Date: Tue, 15 Oct 2024 13:21:56 +0200
Message-ID: <20241015112447.035543364@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241015112440.309539031@linuxfoundation.org>
References: <20241015112440.309539031@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index c7106f1165466..c9056bf8659ad 100644
--- a/drivers/gpu/drm/rockchip/rockchip_drm_vop.c
+++ b/drivers/gpu/drm/rockchip/rockchip_drm_vop.c
@@ -371,8 +371,8 @@ static void scl_vop_cal_scl_fac(struct vop *vop, const struct vop_win_data *win,
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



