Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 98F61223E90;
	Thu, 12 Dec 2024 16:40:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734021628; cv=none; b=jxfk4wbkaYCE+4/DDbVdEmHxXpJJTxflNW6yyH1gIAR0Z3VMcI6ffo6oWX5L2zBbbiTHWMPCuHTqDuR+2XOBgMbza6tz9lt9FYqXLtMPrAVxNd4QsGiYX1tl6W1cpa+wFHBQsfXVC4vOLyoH/0WZ07zE3PgWwRt79IlnQ4p5wcM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734021628; c=relaxed/simple;
	bh=L2FQ91vA3uwptVgjWu3oEECwj8CuVpDgJxB+eT5+jKM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Df9SKlHK1CrkL/NeBAoG2tozEPx7FEg9fVrHCEoqq4JxD7Rc23qn5JjcowdDzgM+ONg6iNQWyf5nNWhKp7nVDqn5d4Z2fiuB2BE/T+mjZTQ8aJbxyJJaVcYFkXaVH9qudBrzBQQsP37SqjLOdFxxAemrBrEW06uD5CBudvKi7aU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MWzzlQUI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MWzzlQUI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6481EC4CECE;
	Thu, 12 Dec 2024 16:40:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734021627;
	bh=L2FQ91vA3uwptVgjWu3oEECwj8CuVpDgJxB+eT5+jKM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MWzzlQUIa4gUgpl6CEhh9guSzlZTeLR575900sb7/a+qKl4jZW3/Xv2LVcKEztkqv
	 aVw4SI84W3juuzPXPRYB8gnl9OnlVyDgvUzKE9nxY7K63wSGSe7ox2BiMKnpU9UxVd
	 bC/UfVCX3/l/Uhb6TZ43j2PMJDuPsF7NlQQGMrGU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andy Yan <andy.yan@rock-chips.com>,
	Heiko Stuebner <heiko@sntech.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 018/565] drm/rockchip: vop: Fix a dereferenced before check warning
Date: Thu, 12 Dec 2024 15:53:33 +0100
Message-ID: <20241212144312.171486851@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144311.432886635@linuxfoundation.org>
References: <20241212144311.432886635@linuxfoundation.org>
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

From: Andy Yan <andy.yan@rock-chips.com>

[ Upstream commit ab1c793f457f740ab7108cc0b1340a402dbf484d ]

The 'state' can't be NULL, we should check crtc_state.

Fix warning:
drivers/gpu/drm/rockchip/rockchip_drm_vop.c:1096
vop_plane_atomic_async_check() warn: variable dereferenced before check
'state' (see line 1077)

Fixes: 5ddb0bd4ddc3 ("drm/atomic: Pass the full state to planes async atomic check and update")
Signed-off-by: Andy Yan <andy.yan@rock-chips.com>
Signed-off-by: Heiko Stuebner <heiko@sntech.de>
Link: https://patchwork.freedesktop.org/patch/msgid/20241021072818.61621-1-andyshrk@163.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/rockchip/rockchip_drm_vop.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/gpu/drm/rockchip/rockchip_drm_vop.c b/drivers/gpu/drm/rockchip/rockchip_drm_vop.c
index 40e733fd8862a..ef1f5da600d8c 100644
--- a/drivers/gpu/drm/rockchip/rockchip_drm_vop.c
+++ b/drivers/gpu/drm/rockchip/rockchip_drm_vop.c
@@ -1065,10 +1065,10 @@ static int vop_plane_atomic_async_check(struct drm_plane *plane,
 	if (!plane->state->fb)
 		return -EINVAL;
 
-	if (state)
-		crtc_state = drm_atomic_get_existing_crtc_state(state,
-								new_plane_state->crtc);
-	else /* Special case for asynchronous cursor updates. */
+	crtc_state = drm_atomic_get_existing_crtc_state(state, new_plane_state->crtc);
+
+	/* Special case for asynchronous cursor updates. */
+	if (!crtc_state)
 		crtc_state = plane->crtc->state;
 
 	return drm_atomic_helper_check_plane_state(plane->state, crtc_state,
-- 
2.43.0



