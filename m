Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2143B3BE175;
	Sat, 12 Sep 2026 07:08:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789196908; cv=none; b=PrKLf7K0RRhBnTWdIv8mYPMkAjzV40mv+ZteF31h0Ak9FrsYzg5vGsHIfMSaa29Bg9Me89Tl70wieFiv5aBDJtNVhwavKii9VGYFnxh8VRJCtHULpeuMsn8HFYByt7ryqDjKW2XjJ/0RsEapuKQZOoQRwk3GKYlj3oNnQBAElUY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789196908; c=relaxed/simple;
	bh=G6ntpvuiQkYHDyhJyN7VCKUWE8S9VgoWldLp91J/1VI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oR5fu3eMzOmCNmNjxSjxTuuJZJzBzM2orZwBHkk1eWRJ0HJL/Ukd9wO9tVwTvlS5C3YTKU+uxkBOTio7n34H00EEuMDw1Fob6kEDG/ZSih1W7eyJakFGlFd9UT62Dfv9+jjG8ccrw9bVPCxj+glI2L7NJFKF+TAiIL+5xWLOTS8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GJrAOrZS; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GJrAOrZS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E783F1F000FF;
	Sat, 12 Sep 2026 07:08:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789196907;
	bh=pdCj8Bzs0tmJZ2vDQ6CFSIXPbU2sFopqNw7uDnmw5NU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=GJrAOrZSfZCaNMsq6RWSm/aMqkMD35uMtGD0NNOm/xyAcgnXJZkNnx5Vuy5KG7deE
	 HrbUspRsxgOlh99YwO3kLG8nlsnQuI9z1JynH+A5P89nfp2pjesSFjw4grXADXaRdI
	 20sO0mv3Belg2Ll+OLXPBmsugBHFwpFyMrPnjVUg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <lkp@intel.com>,
	Damon Ding <damon.ding@rock-chips.com>,
	Luca Ceresoli <luca.ceresoli@bootlin.com>,
	Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 0062/1815] drm/bridge: of-display-mode-bridge: Fix missing static const for the bridge funcs
Date: Sat, 12 Sep 2026 08:30:12 +0200
Message-ID: <20260912065650.466071217@linuxfoundation.org>
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

From: Damon Ding <damon.ding@rock-chips.com>

[ Upstream commit 6648301c5bb2ef23f0fb15bcb01d21ff66f36799 ]

Add static qualifier for of_display_mode_bridge_funcs to resolve the
sparse warning:

drivers/gpu/drm/bridge/of-display-mode-bridge.c:54:25: sparse: sparse:
symbol 'of_display_mode_bridge_funcs' was not declared. Should it be
static?

Also mark the structure const as required by devm_drm_bridge_alloc()
parameter type constraints.

Fixes: ba2db93cf3d5 ("drm/bridge: Move legacy bridge driver out of imx directory for multi-platform use")
Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202606170744.FUStcWaB-lkp@intel.com/
Signed-off-by: Damon Ding <damon.ding@rock-chips.com>
Reviewed-by: Luca Ceresoli <luca.ceresoli@bootlin.com>
Reviewed-by: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
Link: https://patch.msgid.link/20260617080755.186368-1-damon.ding@rock-chips.com
Signed-off-by: Luca Ceresoli <luca.ceresoli@bootlin.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/bridge/of-display-mode-bridge.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/bridge/of-display-mode-bridge.c b/drivers/gpu/drm/bridge/of-display-mode-bridge.c
index cb15713f3a796..e66dae168fd0d 100644
--- a/drivers/gpu/drm/bridge/of-display-mode-bridge.c
+++ b/drivers/gpu/drm/bridge/of-display-mode-bridge.c
@@ -51,7 +51,7 @@ static int of_display_mode_bridge_get_modes(struct drm_bridge *bridge,
 	return 0;
 }
 
-struct drm_bridge_funcs of_display_mode_bridge_funcs = {
+static const struct drm_bridge_funcs of_display_mode_bridge_funcs = {
 	.attach = of_display_mode_bridge_attach,
 	.get_modes = of_display_mode_bridge_get_modes,
 };
-- 
2.53.0



