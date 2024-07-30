Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B9C71898EC;
	Tue, 30 Jul 2024 16:42:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722357737; cv=none; b=pyrWAiaNqUqJYqfdcremlYaQqnmAPauQcJwcKhAddjmbXs0pVn5pSXLyqMUAPYKnLOAFN+FtvcVEt6SGl8/Y4q8nLVRnXi0I1RaEb2YNx/lNcYi9Szl2xxA2zbye7SB9fWJdP/6d6mqvMGz42Uhyv/XidsXfW+/aZlPQWICJPOM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722357737; c=relaxed/simple;
	bh=Vwx1ZgODKzaXqfUx+5mmi9Ok8dzqTBa/gV0W5q0g750=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=O6buSxeyn5+c8y+I9ts02RW7ZateTKA6H80em9qW8n4zMD36vYae0e+xJJ1K8y0LfrY/qngKzOijhqfMAlFI1vx5R5NFOsrwqaEMgjV36ieqXiK0cmhsJqWrTwM8KkLmBIZ0PhyyOfLLyRw25B6LfYFaI8Eai46ZtJnQDIKO/d8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=o81845wT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="o81845wT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F0616C32782;
	Tue, 30 Jul 2024 16:42:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722357737;
	bh=Vwx1ZgODKzaXqfUx+5mmi9Ok8dzqTBa/gV0W5q0g750=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=o81845wTv3PXMmidy/2hH/XDzS85uMWCUh+4mh5hqRdMUb2V3AHLQSS40K5yEOVNC
	 8AbUxje2RuNyYH4DM5be1d079oblgcTr3qCICCkOdYxrY0wmmgcoHIl+4UH3+fJorv
	 Sk1PYeQJwbQxQSn2kk9ZC5AaASGEYT6d/4TJijP8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andy Yan <andy.yan@rock-chips.com>,
	Sascha Hauer <s.hauer@pengutronix.de>,
	Heiko Stuebner <heiko@sntech.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 265/809] drm/rockchip: vop2: Fix the port mux of VP2
Date: Tue, 30 Jul 2024 17:42:21 +0200
Message-ID: <20240730151735.057949919@linuxfoundation.org>
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

From: Andy Yan <andy.yan@rock-chips.com>

[ Upstream commit 2bdb481bf7a93c22b9fea8daefa2834aab23a70f ]

The port mux of VP2 should be RK3568_OVL_PORT_SET__PORT2_MUX.

Fixes: 604be85547ce ("drm/rockchip: Add VOP2 driver")
Signed-off-by: Andy Yan <andy.yan@rock-chips.com>
Acked-by: Sascha Hauer <s.hauer@pengutronix.de>
Tested-by: Heiko Stuebner <heiko@sntech.de>
Signed-off-by: Heiko Stuebner <heiko@sntech.de>
Link: https://patchwork.freedesktop.org/patch/msgid/20240422101905.32703-2-andyshrk@163.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/rockchip/rockchip_drm_vop2.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/rockchip/rockchip_drm_vop2.c b/drivers/gpu/drm/rockchip/rockchip_drm_vop2.c
index 62ebbdb16253d..9873172e3fd33 100644
--- a/drivers/gpu/drm/rockchip/rockchip_drm_vop2.c
+++ b/drivers/gpu/drm/rockchip/rockchip_drm_vop2.c
@@ -2344,7 +2344,7 @@ static void vop2_setup_layer_mixer(struct vop2_video_port *vp)
 		port_sel |= FIELD_PREP(RK3568_OVL_PORT_SET__PORT2_MUX,
 			(vp2->nlayers + vp1->nlayers + vp0->nlayers - 1));
 	else
-		port_sel |= FIELD_PREP(RK3568_OVL_PORT_SET__PORT1_MUX, 8);
+		port_sel |= FIELD_PREP(RK3568_OVL_PORT_SET__PORT2_MUX, 8);
 
 	layer_sel = vop2_readl(vop2, RK3568_OVL_LAYER_SEL);
 
-- 
2.43.0



