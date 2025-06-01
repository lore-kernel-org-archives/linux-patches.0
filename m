Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7970525F979;
	Sun,  1 Jun 2025 23:29:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748820583; cv=none; b=VsU9QWUNDv41UI9H17vUiaz9L02yMIrSPnlU+d1hsq5qnRSsA8H+Cm467Gs1dKAOTFLO3a81utFYK/xANSmRYCEPj8ZQkQ2aGUEdpF6NWZzop9XtlUDzQqQNIBoRLibFiTpfGz9gJPRzPJEHOBxxLyZ6OG9xLvd55/sTae5H4t8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748820583; c=relaxed/simple;
	bh=QunUx6lLV3dhy+NK3nTekyHKo1r/v7uCfScUvkXwkhk=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=HaC+KSntTUQc3F2QogSLbfrnYhYv+43LTYumXM3fR5EQreesmtxpJsWj1qAVwA3rRtRKolVRPOC1D4JukrBs5TG/BF3iZ72C+44es6tm+BgeDRJ/KTCeierf5JGdFZKT+/8u2kAjzoVZGzTFR3HZ9er4Xv6xmYgvzpR2qFouB3c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Nb8nCSrn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Nb8nCSrn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DA8A1C4CEF1;
	Sun,  1 Jun 2025 23:29:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1748820583;
	bh=QunUx6lLV3dhy+NK3nTekyHKo1r/v7uCfScUvkXwkhk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Nb8nCSrn4PjE02SljE02SzAbgC+M7sSEAiid8/taHWBuz6wuLN/xKsf90dxJGOSUp
	 JEObPbKmfQEijdPJT0brMam5WVFtU8mtZGbmkkk12CteI70uf14GFKNLb/WPHBBRtk
	 JriJXM3PiVK4X82HUO+q9OvuS/AGjJ4HgHjJvl+vwsmp6z8i35bGA+YZLVc4bYCxpb
	 oFGD0XWPlau0v/xsSPXh1KekZ9lSzU5fWLOndgU7QjB3WoEY4ArgMcScJydOdY6pVu
	 gN3DJgpbmXbSxDWUUmib8pVKFgxoF980TW+ANQWeTGLtH3Q6pIVoa4SqUtYE2s0MMf
	 2gz/GXLFx+y2w==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
	Neil Armstrong <neil.armstrong@linaro.org>,
	Sasha Levin <sashal@kernel.org>,
	andrzej.hajda@intel.com,
	rfoss@kernel.org,
	maarten.lankhorst@linux.intel.com,
	mripard@kernel.org,
	tzimmermann@suse.de,
	airlied@gmail.com,
	simona@ffwll.ch,
	dri-devel@lists.freedesktop.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.14 002/102] drm/bridge: select DRM_KMS_HELPER for AUX_BRIDGE
Date: Sun,  1 Jun 2025 19:27:54 -0400
Message-Id: <20250601232937.3510379-2-sashal@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250601232937.3510379-1-sashal@kernel.org>
References: <20250601232937.3510379-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.14.9
Content-Transfer-Encoding: 8bit

From: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>

[ Upstream commit b12fa5e76e1463fc5a196f2717040e4564e184b6 ]

The aux bridge uses devm_drm_of_get_bridge() from the panel bridge (and
correctly selects DRM_PANEL_BRIDGE). However panel bridge is not a
separate module, it is compiled into the drm_kms_helper.o. Select
DRM_KMS_HELPER too to express this dependency.

Reviewed-by: Neil Armstrong <neil.armstrong@linaro.org>
Link: https://lore.kernel.org/r/20250411-aux-select-kms-v1-1-c4276f905a56@oss.qualcomm.com
Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

Based on my analysis, here is my determination: **YES** This commit
should be backported to stable kernel trees for the following reasons:
1. **It fixes a missing dependency issue**: The commit addresses a real
dependency problem where `DRM_AUX_BRIDGE` uses
`devm_drm_of_get_bridge()` which is implemented in `bridge/panel.c`. As
shown in the Makefile analysis, `panel.o` is built into
`drm_kms_helper.o` when `CONFIG_DRM_PANEL_BRIDGE` is selected (line 149
of drivers/gpu/drm/Makefile: `drm_kms_helper-$(CONFIG_DRM_PANEL_BRIDGE)
+= bridge/panel.o`). 2. **It prevents build failures**: Without
selecting `DRM_KMS_HELPER`, the aux bridge can fail to link properly
because the actual implementation of `devm_drm_of_get_bridge()` won't be
available. This can lead to undefined reference errors during linking,
similar to the issue described in Similar Commit #1 where
`devm_drm_of_get_bridge` was undefined. 3. **The fix is minimal and
safe**: The change is a simple one-line addition to select
`DRM_KMS_HELPER` in the Kconfig. This is a build configuration fix with
no runtime impact - it merely ensures the correct dependencies are
satisfied at build time. 4. **It follows established patterns**: Looking
at other bridge drivers in the same Kconfig file, we can see that
drivers using similar functionality already select `DRM_KMS_HELPER`
(e.g., lines 38, 53, 64, 88, 99 in the Kconfig show other drivers
selecting it). 5. **Similar to backported commit #2**: This fix is
conceptually similar to Similar Commit #2 which was backported and dealt
with circular dependencies and proper module organization for
`devm_drm_of_get_bridge()`. 6. **No architectural changes**: This commit
doesn't introduce new features or change any architecture - it simply
fixes a missing Kconfig dependency that should have been there from the
beginning when `DRM_AUX_BRIDGE` was introduced. The commit meets the
stable tree criteria as it: - Fixes a real bug (missing dependency
leading to potential build failures) - Is minimal and contained (single
line Kconfig change) - Has no risk of regression (only affects build
configuration) - Doesn't introduce new features or architectural changes

 drivers/gpu/drm/bridge/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/gpu/drm/bridge/Kconfig b/drivers/gpu/drm/bridge/Kconfig
index 6b4664d91faa8..631b8db08ecf7 100644
--- a/drivers/gpu/drm/bridge/Kconfig
+++ b/drivers/gpu/drm/bridge/Kconfig
@@ -16,6 +16,7 @@ config DRM_AUX_BRIDGE
 	tristate
 	depends on DRM_BRIDGE && OF
 	select AUXILIARY_BUS
+	select DRM_KMS_HELPER
 	select DRM_PANEL_BRIDGE
 	help
 	  Simple transparent bridge that is used by several non-DRM drivers to
-- 
2.39.5

