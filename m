Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE7E01A6161;
	Tue, 30 Jul 2024 16:25:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722356705; cv=none; b=XMtU8II+damvoRlWSS/3nNfVg4BopM2QdQp/HY/5QBzV5W8xop0PZv9QxhrQzXhU33aqABMkafs5QhDO0WMyeCaCMUouqrh10zYL7DgbgD1+cOsmGRsOWBhsnq/quBr6CzsmYETbEU4uDAq3Tj3JgiWHipXL3/ZaNqVlNLzCNYQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722356705; c=relaxed/simple;
	bh=EKsCygSF8isMd8M0uFj9e7l8HAi6lb+vfFKK23jZJpA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=amtwknqA6r3Ze9C7x7I5w+3kQ24zcT3wYSVzDTLkaoG4JdVb4nuWB0DhKsxUmcZLUnZDsEk9Gtw+iNGr5qu9msQwclSdkIjyqrzhZXuYHJxsg+I8NNONqsHIzEbbwN9yDbSofO2912N5cgm/MLVmkAUbOOuvp9Hla/d5LNwzI4o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Qw/5OXNa; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Qw/5OXNa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BE718C4AF13;
	Tue, 30 Jul 2024 16:25:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722356705;
	bh=EKsCygSF8isMd8M0uFj9e7l8HAi6lb+vfFKK23jZJpA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Qw/5OXNayi4C58bLkdwML+X3jhwDVGoSTFvT+TtwpgKOax5Phl6dvZk2+6Zh791Ym
	 7OOXz2EKWHBDmgDCxptK9cvEgYRRCbv2igRobOlAVUqLvO1A+patA7G7CKWeSJGb14
	 b0jhmBo9fsJGfpBwyITc0abxk5ff/tm2Ek4cLGNI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andy Yan <andy.yan@rock-chips.com>,
	Sascha Hauer <s.hauer@pengutronix.de>,
	Heiko Stuebner <heiko@sntech.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 175/568] drm/rockchip: vop2: Fix the port mux of VP2
Date: Tue, 30 Jul 2024 17:44:42 +0200
Message-ID: <20240730151646.721969027@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151639.792277039@linuxfoundation.org>
References: <20240730151639.792277039@linuxfoundation.org>
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
index c5ec4169616de..f2a956f973613 100644
--- a/drivers/gpu/drm/rockchip/rockchip_drm_vop2.c
+++ b/drivers/gpu/drm/rockchip/rockchip_drm_vop2.c
@@ -1927,7 +1927,7 @@ static void vop2_setup_layer_mixer(struct vop2_video_port *vp)
 		port_sel |= FIELD_PREP(RK3568_OVL_PORT_SET__PORT2_MUX,
 			(vp2->nlayers + vp1->nlayers + vp0->nlayers - 1));
 	else
-		port_sel |= FIELD_PREP(RK3568_OVL_PORT_SET__PORT1_MUX, 8);
+		port_sel |= FIELD_PREP(RK3568_OVL_PORT_SET__PORT2_MUX, 8);
 
 	layer_sel = vop2_readl(vop2, RK3568_OVL_LAYER_SEL);
 
-- 
2.43.0



