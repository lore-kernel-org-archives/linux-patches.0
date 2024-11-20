Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F58B1991AA;
	Wed, 20 Nov 2024 13:01:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732107664; cv=none; b=PjKF8Ks10YbvoOMAPpGeoml4BwyyVOKpE5zPgq517eAi6Pa/Jpuy+5peVjpQIdHgOG1X5/zwc14rJr+8JYlGMitwGsLrMpIQBY+LZdxK0zj0zN2QyNku789piQtMX9CK5HkFUSnKyw3VhIDEm2iwZjMuxLqwORZRoB3YopA2elY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732107664; c=relaxed/simple;
	bh=YKumQPy99o+TCHi0A4WjtVKFG1E0C9T7nJ3VnbHG59k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=e0dorMJhbNJvp8f3Uow3S7gehwA35zlPB8xyCLzUeSpeYSEkyo+BFHW1cCytuf/iNEKsCVXb+pTRSasOTPbRPaHA3CeWVFK2G0ONZjmUfcI3ZScVdyf5DiGDHZh8+WcvaPNzbf7IdrvMG6pIOFeMTwrh8fPvXyBa/dICsYAp1oo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=W027vDPe; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="W027vDPe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E5D4AC4CED1;
	Wed, 20 Nov 2024 13:01:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1732107664;
	bh=YKumQPy99o+TCHi0A4WjtVKFG1E0C9T7nJ3VnbHG59k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=W027vDPev5DtyjF3MJmLoBHKxu5/foudN4WQxjLLXypKgss56XvZby2XM2FAfBano
	 yWt69JbLkf4ZLMvSDBzUo5osQdk6piyopPMKcgnMOGAHKExDMW0nEnKYhIwcNyjFgV
	 rtD5CuknXu9sb4A9W3w+RRvdHlm8URbiwdldSQYA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andy Yan <andy.yan@rock-chips.com>,
	Heiko Stuebner <heiko@sntech.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 03/73] drm/rockchip: vop: Fix a dereferenced before check warning
Date: Wed, 20 Nov 2024 13:57:49 +0100
Message-ID: <20241120125809.707106399@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241120125809.623237564@linuxfoundation.org>
References: <20241120125809.623237564@linuxfoundation.org>
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
index b2289a523c408..e5b2112af1381 100644
--- a/drivers/gpu/drm/rockchip/rockchip_drm_vop.c
+++ b/drivers/gpu/drm/rockchip/rockchip_drm_vop.c
@@ -1080,10 +1080,10 @@ static int vop_plane_atomic_async_check(struct drm_plane *plane,
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



