Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 75160171A6
	for <patches@lists.linux.dev>; Wed,  9 Aug 2023 11:01:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E9F15C433C8;
	Wed,  9 Aug 2023 11:01:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1691578891;
	bh=Ncum7HX9sEOSyf191U/G17l2K95yupaM6V6J5ktW78E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ztFNQFGISJZpNqGy0mltfphuu+HO6FuGjbQubRdPefNeER6XvWePLHglxHCEs7DzC
	 8jMTVDqzWMVgRn/Rs1X+ti6AqyjkOWoLc6UGPDCWwM0hFfFwqRt9hwMApYv1wuheB7
	 xXQZgdl4/zQ0YZJJ8fo9BKD36O4mNAlpmL9Sbr14=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thomas Zimmermann <tzimmermann@suse.de>,
	Sam Ravnborg <sam@ravnborg.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 85/92] drm/fsl-dcu: Use drm_plane_helper_destroy()
Date: Wed,  9 Aug 2023 12:42:01 +0200
Message-ID: <20230809103636.476164417@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230809103633.485906560@linuxfoundation.org>
References: <20230809103633.485906560@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Thomas Zimmermann <tzimmermann@suse.de>

[ Upstream commit a4d847df8b440cc667c18f99abe84ccaa83afac4 ]

Replace the driver's own function with drm_plane_helper_destroy(). No
functional changes.

Signed-off-by: Thomas Zimmermann <tzimmermann@suse.de>
Reviewed-by: Sam Ravnborg <sam@ravnborg.org>
Link: https://patchwork.freedesktop.org/patch/msgid/20220720083058.15371-8-tzimmermann@suse.de
Stable-dep-of: ee31742bf176 ("drm/imx/ipuv3: Fix front porch adjustment upon hactive aligning")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/fsl-dcu/fsl_dcu_drm_plane.c | 8 +-------
 1 file changed, 1 insertion(+), 7 deletions(-)

diff --git a/drivers/gpu/drm/fsl-dcu/fsl_dcu_drm_plane.c b/drivers/gpu/drm/fsl-dcu/fsl_dcu_drm_plane.c
index 8fe953d6e0a94..8a9e6db71e46b 100644
--- a/drivers/gpu/drm/fsl-dcu/fsl_dcu_drm_plane.c
+++ b/drivers/gpu/drm/fsl-dcu/fsl_dcu_drm_plane.c
@@ -170,16 +170,10 @@ static const struct drm_plane_helper_funcs fsl_dcu_drm_plane_helper_funcs = {
 	.atomic_update = fsl_dcu_drm_plane_atomic_update,
 };
 
-static void fsl_dcu_drm_plane_destroy(struct drm_plane *plane)
-{
-	drm_plane_cleanup(plane);
-	kfree(plane);
-}
-
 static const struct drm_plane_funcs fsl_dcu_drm_plane_funcs = {
 	.atomic_duplicate_state = drm_atomic_helper_plane_duplicate_state,
 	.atomic_destroy_state = drm_atomic_helper_plane_destroy_state,
-	.destroy = fsl_dcu_drm_plane_destroy,
+	.destroy = drm_plane_helper_destroy,
 	.disable_plane = drm_atomic_helper_disable_plane,
 	.reset = drm_atomic_helper_plane_reset,
 	.update_plane = drm_atomic_helper_update_plane,
-- 
2.40.1



