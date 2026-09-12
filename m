Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D986C25B09D;
	Sat, 12 Sep 2026 19:45:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789242315; cv=none; b=ml184EjceYoA1IlX+5Hx3AuvBtjc//CRs4RWnPIIy9ytJgiwG9CpJF8IN3Ye61ZGUXNhgmOV6W0Z2/9T9Ycv6NHn+Uf4ECb03JtiFoe/X4Z+CsoKCLCR43RoHiyAhNJcC6sdibhSI6oCjT5G+8CQy8U1Bm9HZBsFga4V+rmVgqs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789242315; c=relaxed/simple;
	bh=HOd15c+KOvgbIjVW7eVCWeqrUgL/5vOMIupoXOZinHw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=g1WXEo76ntLguPHodIJvGkXG2VOlykDM6Rtw1aYWufEe2hXxKQJiA/vk94sxoWiKPLmvfZvxHfBgCjcffGTkWihuRkzWhRw2kO09U+gbwO2E9y2nFQamyOrAckJEHIyRD8PR4VyyHcOqSErxNzc0GFgRMT49wROELYRzd+sHYCQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dkOp/O/r; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dkOp/O/r"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 41A171F000FF;
	Sat, 12 Sep 2026 19:45:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789242313;
	bh=QM3p6ywNODvMeChL3/EmXXg3V5nwwcPWL/uyQGFMrxI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dkOp/O/riY0nUNVEl/asw6vPjUSGAsyUXjETNcMfPpNXpF6Xv6VnD61c1vc8THIMy
	 VmBizKnTk8b/1/MHOUPJt/ogJgqTeqVk+aVxNnzIIX+2lnCNFZNriJA8F+O4RXqu9x
	 tF9+1u38atxjJbtGAZPqMn86sw0fb3Fxio5QT40g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thomas Zimmermann <tzimmermann@suse.de>,
	Luca Ceresoli <luca.ceresoli@bootlin.com>,
	Maxime Ripard <mripard@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 334/798] drm/bridge: cdns-mhdp8546: Return an error pointer on allocation failure
Date: Sat, 12 Sep 2026 08:59:22 +0200
Message-ID: <20260912065524.817211261@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065516.948645775@linuxfoundation.org>
References: <20260912065516.948645775@linuxfoundation.org>
User-Agent: quilt/0.69
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

From: Maxime Ripard <mripard@kernel.org>

[ Upstream commit 30ac1d403438a6c6039f0af5bb2df3d021f96036 ]

The drm_bridge_funcs.atomic_reset documentation states that the hook
must return either a valid drm_bridge_state object or an ERR_PTR().

The cdns_mhdp_bridge_atomic_reset() callback returns NULL when the
allocation of its state fails, violating this contract.

Return ERR_PTR(-ENOMEM) instead.

Fixes: fb43aa0acdfd ("drm: bridge: Add support for Cadence MHDP8546 DPI/DP bridge")
Reviewed-by: Thomas Zimmermann <tzimmermann@suse.de>
Reviewed-by: Luca Ceresoli <luca.ceresoli@bootlin.com>
Tested-by: Luca Ceresoli <luca.ceresoli@bootlin.com> # imx8mp + sn65dsi84 + bridge hotplug
Link: https://patch.msgid.link/20260619-drm-no-more-bridge-reset-v3-2-ff399263111b@kernel.org
Signed-off-by: Maxime Ripard <mripard@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/bridge/cadence/cdns-mhdp8546-core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/bridge/cadence/cdns-mhdp8546-core.c b/drivers/gpu/drm/bridge/cadence/cdns-mhdp8546-core.c
index 5876589d42b7d..f290432c15e3b 100644
--- a/drivers/gpu/drm/bridge/cadence/cdns-mhdp8546-core.c
+++ b/drivers/gpu/drm/bridge/cadence/cdns-mhdp8546-core.c
@@ -2076,7 +2076,7 @@ cdns_mhdp_bridge_atomic_reset(struct drm_bridge *bridge)
 
 	cdns_mhdp_state = kzalloc(sizeof(*cdns_mhdp_state), GFP_KERNEL);
 	if (!cdns_mhdp_state)
-		return NULL;
+		return ERR_PTR(-ENOMEM);
 
 	 __drm_atomic_helper_bridge_reset(bridge, &cdns_mhdp_state->base);
 
-- 
2.53.0



