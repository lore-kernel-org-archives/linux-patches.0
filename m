Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 86FAA3B813A;
	Sat, 12 Sep 2026 07:07:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789196873; cv=none; b=HvjubA2FHkUBQbMtkYHHEY6HRWsjGoU6rGSHdhozjzB/LHyIeHl86K+xJvq2uSv2Qk0mrflPnlBjfltzPH+Pona9PcvY/zh6E+h/jEded801QLNIMByFziwGs67yoJEJoztE2M7V+MBXQdhoFwEv5s+rdNUzmMZJAO3B3hCIgBE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789196873; c=relaxed/simple;
	bh=4pM4OmVZI0AXPgVH8mnEXVz1m9P9OYLYsYBynvJ1Bxo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nQKEtPpedcZyIHB8qHHFg07bR89KRUK3RJP7Pcf7p0tDzScOJU/IBEzb1YWOfKwdeU/hQPjlCGnZ5qFUwspx4AsACMyIXM4RxdBhXPBFwyBGfYK1oRCtQQVmuBNBaZECLY0V+/FIA19ISlIZ3FLLRqCz2rsD2gy8cxvOko2vlkE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oKoNBw1J; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oKoNBw1J"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 20AF01F000FF;
	Sat, 12 Sep 2026 07:07:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789196872;
	bh=JXrc1kIq9Wl5NLIJGUVFOKwj3sc+az3V1BQHEz07yUE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=oKoNBw1JXtN98IoUgaV+Wx9MorrQOIyMLMctf1IAfbjr7tomGoH2flzrrLqC84G0X
	 Nvq4Xi5kFyab3NQIxOmnQumZIw+UvRENGTmPyhBAb2Ow/EGChkgySvjsb3M3skNGU/
	 vatXinJJlWpILXKfYO9/48THPbQcwBBen3BrP2sk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thomas Zimmermann <tzimmermann@suse.de>,
	Luca Ceresoli <luca.ceresoli@bootlin.com>,
	Maxime Ripard <mripard@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 0055/1815] drm/bridge: cdns-mhdp8546: Return an error pointer on allocation failure
Date: Sat, 12 Sep 2026 08:30:05 +0200
Message-ID: <20260912065650.307318321@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

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
index 36c07b71fe04b..46779b49545bd 100644
--- a/drivers/gpu/drm/bridge/cadence/cdns-mhdp8546-core.c
+++ b/drivers/gpu/drm/bridge/cadence/cdns-mhdp8546-core.c
@@ -1927,7 +1927,7 @@ cdns_mhdp_bridge_atomic_reset(struct drm_bridge *bridge)
 
 	cdns_mhdp_state = kzalloc_obj(*cdns_mhdp_state);
 	if (!cdns_mhdp_state)
-		return NULL;
+		return ERR_PTR(-ENOMEM);
 
 	__drm_atomic_helper_bridge_reset(bridge, &cdns_mhdp_state->base);
 
-- 
2.53.0



