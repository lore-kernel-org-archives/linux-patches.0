Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F52929A2;
	Tue, 30 Jul 2024 16:09:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722355763; cv=none; b=e2E/uTZ1jq2OZu5UiV7JTCdnmzkXoEndIStJ+c2a8AftLrkmY4dFqyw9YuTB4C+GiNTrCqH9g03gBM09yKzSkh/Aq6BToQhuChnHFmFg4m5vcSZXGSu5djfBlCj5NjKLyrIe0sP58dt27SSJJqPiKkfwNDOaTfFN8yky9nn5CL4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722355763; c=relaxed/simple;
	bh=m8qizXLrjnyq1uikQinmKkXcvlscgZ5RFao8DHWah60=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=T05rrlx7KmbHRmF1W/FKa1/bsUOlfTDf/8DuxbCvJFSty5XZi7rpyO7y17MOdDWttIl1E1PyCwAEdEgBgCJ4yEZ5fd+hv6J0B+SjrwAIy/8SJFCKgaBjyDN6a4QyqB61sh+VRN48YyNYwUfGRoFIieIJFuiPA0SgTlpC+38x8UI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=l/XfQFES; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="l/XfQFES"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4E588C32782;
	Tue, 30 Jul 2024 16:09:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722355762;
	bh=m8qizXLrjnyq1uikQinmKkXcvlscgZ5RFao8DHWah60=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=l/XfQFESumxlW3LKTnUsiDuo3SIuiS5xTbjLOJmfy/XfZZNAyaOqgAROBAROxubDE
	 WsC93jMC+KblnPLz7IPO6L6cD/v8Ml6THBmilpoSRpgl5swUtAHKen50zthMjMoV8f
	 q2idrrZNK2SINok4cOISs0dOxIY/wKmCAhqDuw/U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andy Yan <andy.yan@rock-chips.com>,
	Sascha Hauer <s.hauer@pengutronix.de>,
	Heiko Stuebner <heiko@sntech.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 128/440] drm/rockchip: vop2: Fix the port mux of VP2
Date: Tue, 30 Jul 2024 17:46:01 +0200
Message-ID: <20240730151620.883733547@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151615.753688326@linuxfoundation.org>
References: <20240730151615.753688326@linuxfoundation.org>
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
index a72642bb9cc60..80b8c83342840 100644
--- a/drivers/gpu/drm/rockchip/rockchip_drm_vop2.c
+++ b/drivers/gpu/drm/rockchip/rockchip_drm_vop2.c
@@ -1923,7 +1923,7 @@ static void vop2_setup_layer_mixer(struct vop2_video_port *vp)
 		port_sel |= FIELD_PREP(RK3568_OVL_PORT_SET__PORT2_MUX,
 			(vp2->nlayers + vp1->nlayers + vp0->nlayers - 1));
 	else
-		port_sel |= FIELD_PREP(RK3568_OVL_PORT_SET__PORT1_MUX, 8);
+		port_sel |= FIELD_PREP(RK3568_OVL_PORT_SET__PORT2_MUX, 8);
 
 	layer_sel = vop2_readl(vop2, RK3568_OVL_LAYER_SEL);
 
-- 
2.43.0



