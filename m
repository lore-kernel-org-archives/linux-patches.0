Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AAA56132111;
	Wed,  5 Feb 2025 13:48:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738763302; cv=none; b=oMxrC1eMTws+1j2ycBDEfARlGGPhYqTXjafqYMCwbJqr+/oO+OaVsp9VjrW8RCbSRrSCXGnOxzpJnrm1xZ+cHF25IpupwAGTlw1qR77tTSCjy0DCtfCiowCvuNhetCPOLy2Eei1Z1QVDEKTg9HMCWMvbCkcDtA9h6j8AE5lhmww=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738763302; c=relaxed/simple;
	bh=I+LeXld/XE95o62Ffcslms1exlxj6Ider3mh1GuOXaI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GEWQyuF3yPGXhFdryBAGNZooquuEPFwHhaNczSdO/Dv904PWncQ1EtiasIwhra/1EkSvfcyYPbRffWZhrPAS5wko6t/+OWXvMjloCtxnmOq8bO3ERE0FbUHsUYxgZWAPUMlj9GmxZJRy5lKvAOAVwIoeZuUgCNvMrG+VCNI0icU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ipCVjM+R; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ipCVjM+R"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 134C0C4CED1;
	Wed,  5 Feb 2025 13:48:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738763302;
	bh=I+LeXld/XE95o62Ffcslms1exlxj6Ider3mh1GuOXaI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ipCVjM+RnQabwMRY3BX/1a/gk+rlGcm97X/r8oxv1ywRi+GHcu+55V74f3ByE11jC
	 0zBGpDmSopMb7Nt/uwg4WyTUpYxO4RX8bBcLBE1yyzcpBygVKdQZo3US0gLDfeq29O
	 rdYSBsLRudIp+P8Kmkli35G9JZ2IENfLUlNB9cRc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Derek Foreman <derek.foreman@collabora.com>,
	Andy Yan <andy.yan@rock-chips.com>,
	Heiko Stuebner <heiko@sntech.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 027/393] drm/rockchip: vop2: Fix cluster windows alpha ctrl regsiters offset
Date: Wed,  5 Feb 2025 14:39:06 +0100
Message-ID: <20250205134421.339018422@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250205134420.279368572@linuxfoundation.org>
References: <20250205134420.279368572@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Andy Yan <andy.yan@rock-chips.com>

[ Upstream commit 17b4b10a0df1a1421d5fbdc03bad0bd3799bc966 ]

The phy_id of cluster windws are not increase one for each window.

Fixes: 604be85547ce ("drm/rockchip: Add VOP2 driver")
Tested-by: Derek Foreman <derek.foreman@collabora.com>
Signed-off-by: Andy Yan <andy.yan@rock-chips.com>
Signed-off-by: Heiko Stuebner <heiko@sntech.de>
Link: https://patchwork.freedesktop.org/patch/msgid/20241209122943.2781431-6-andyshrk@163.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/rockchip/rockchip_drm_vop2.c | 18 +++++++++++++++++-
 1 file changed, 17 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/rockchip/rockchip_drm_vop2.c b/drivers/gpu/drm/rockchip/rockchip_drm_vop2.c
index d1de12e850e74..f8fdbdf52e907 100644
--- a/drivers/gpu/drm/rockchip/rockchip_drm_vop2.c
+++ b/drivers/gpu/drm/rockchip/rockchip_drm_vop2.c
@@ -1741,7 +1741,6 @@ static int vop2_find_start_mixer_id_for_vp(struct vop2 *vop2, u8 port_id)
 
 static void vop2_setup_cluster_alpha(struct vop2 *vop2, struct vop2_win *main_win)
 {
-	u32 offset = (main_win->data->phys_id * 0x10);
 	struct vop2_alpha_config alpha_config;
 	struct vop2_alpha alpha;
 	struct drm_plane_state *bottom_win_pstate;
@@ -1749,6 +1748,7 @@ static void vop2_setup_cluster_alpha(struct vop2 *vop2, struct vop2_win *main_wi
 	u16 src_glb_alpha_val, dst_glb_alpha_val;
 	bool premulti_en = false;
 	bool swap = false;
+	u32 offset = 0;
 
 	/* At one win mode, win0 is dst/bottom win, and win1 is a all zero src/top win */
 	bottom_win_pstate = main_win->base.state;
@@ -1767,6 +1767,22 @@ static void vop2_setup_cluster_alpha(struct vop2 *vop2, struct vop2_win *main_wi
 	vop2_parse_alpha(&alpha_config, &alpha);
 
 	alpha.src_color_ctrl.bits.src_dst_swap = swap;
+
+	switch (main_win->data->phys_id) {
+	case ROCKCHIP_VOP2_CLUSTER0:
+		offset = 0x0;
+		break;
+	case ROCKCHIP_VOP2_CLUSTER1:
+		offset = 0x10;
+		break;
+	case ROCKCHIP_VOP2_CLUSTER2:
+		offset = 0x20;
+		break;
+	case ROCKCHIP_VOP2_CLUSTER3:
+		offset = 0x30;
+		break;
+	}
+
 	vop2_writel(vop2, RK3568_CLUSTER0_MIX_SRC_COLOR_CTRL + offset,
 		    alpha.src_color_ctrl.val);
 	vop2_writel(vop2, RK3568_CLUSTER0_MIX_DST_COLOR_CTRL + offset,
-- 
2.39.5



