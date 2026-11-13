Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794590474;
	b=uoy7yV9RbWOPDRC+QeSsXkaS4DOTEBYzuC1XXgLuh92JBQo4LKSIcda8bSRgPrXHqFza
	 mGloDYpn8Li3/eMOQ/r6UONEGIGjKYHwO1W/7Za5TdEOJC2LEv+AUkhQhVjcpkl1eaMM6
	 Zz6oafHEAwitVAqQIq2EVY8wegNHzgTAId3RbiWRUVRW7eph7PQ2OwpoZQ8mmRe+XwHBw
	 4Hz/x0hlugQWudeUcO1jfZlL7o2GlxiU3exwy9GL8n2mVHdTs1IHs339UeJ5EM299qBSy
	 gIIMptFwgtVkENfLC7X7Mwk0r3dVqyBHDaF23L1PmF3pYZ4Q/7v4kF17gHFwl30/3iA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794590474;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=aQWn6iWmac96JjNhM85042cg0caPnmN0P/CmYq1mDzI=;
	b=V6qFqc7qbCJP79BjU23UIqC6k4gEEyEJBz2V6EYJPwTHMMbxpViAW8VgWv4z6l3xh0kv
	 5ID5XLvjpqc1rEiqsiojweN06HqfTa6wd/gFgirbYreGXe8tQLfBP6IFqIBfR7vvQwVUR
	 wV6ka4vw+0Rdi/uOzE6m+OPTuxI7vI4s9WK8B3U8gTFaLEuVkCBoZge8gcdpUjusPa+R0
	 LRR40oKy86phCcHfViIWUT7Ts553/dxW5wyf3b1k4fECdmPN2+EqHgfOi9z8FR3kkRrTz
	 Xm7XzCbL66o+TyiGu8eiJMOW7p5sItdDx2x6ciMLNV0XFpOBORjp22efiYwyA5iT1Fg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=B8X3howD;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 22FA8606B81C;
	Fri, 13 Nov 2026 17:21:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=B8X3howD
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C296B1F000C4;
	Fri, 13 Nov 2026 17:21:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794590474;
	bh=aQWn6iWmac96JjNhM85042cg0caPnmN0P/CmYq1mDzI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=B8X3howDLBrY2xOKjp/Nb4o4IcxiPS/wY7LkBEyXUH4ckzTdtuD1c/On7hjEniCAh
	 jIEyeP73FN+B5NAjXJ1KMki6J9sVDei4UKAtXm3tKFGDf7qWfWy1zASK8pnLc9zlM6
	 3F9/1nT9UYCvGYj87A9WEZbCrYFjn9DzkIdiy/IQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Matthew Schwartz <matthew.schwartz@linux.dev>,
	Ivan Lipski <ivan.lipski@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 410/686] drm/amd/display: Keep the nominal vtotal while VRR is inactive
Date: Fri, 13 Nov 2026 10:49:03 -0500
Message-ID: <20261113153834.872881435@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153820.902362109@linuxfoundation.org>
References: <20261113153820.902362109@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Matthew Schwartz <matthew.schwartz@linux.dev>

[ Upstream commit f2853a06e4b923c77a8cba69d76d2222b198256b ]

Commit 33c995709121 ("drm/amd/display: Allow VRR params change if
unsynced with the stream") derives the inactive vtotal from
max_refresh_in_uhz and rounds it up. The round trip through integer
rates can add a line even with VRR off. The ASUS ROG Xbox Ally X20's
120.0004 Hz mode exceeds its 120 Hz EDID maximum, so 1152 lines
become 1153 and the CRTC vblank counter measures 119.89 Hz.

Take both limits from stream->timing.v_total, as
mod_freesync_build_vrr_params() does, which keeps the resync to the
stream's timing. Active VRR keeps the helper's rounding.

Fixes: 33c995709121 ("drm/amd/display: Allow VRR params change if unsynced with the stream")
Signed-off-by: Matthew Schwartz <matthew.schwartz@linux.dev>
Reviewed-by: Ivan Lipski <ivan.lipski@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit 428c95d380f07694cbbd9ebe3450214404f57b5a)
Cc: stable@vger.kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/modules/freesync/freesync.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/gpu/drm/amd/display/modules/freesync/freesync.c b/drivers/gpu/drm/amd/display/modules/freesync/freesync.c
index 1aae46d703ba0..4a957f87c07c5 100644
--- a/drivers/gpu/drm/amd/display/modules/freesync/freesync.c
+++ b/drivers/gpu/drm/amd/display/modules/freesync/freesync.c
@@ -1265,10 +1265,8 @@ void mod_freesync_handle_v_update(struct mod_freesync *mod_freesync,
 	 * If VRR is inactive, set vtotal min and max to nominal vtotal
 	 */
 	 if (in_out_vrr->state == VRR_STATE_INACTIVE) {
-		in_out_vrr->adjust.v_total_min =
-			mod_freesync_calc_v_total_from_refresh(stream,
-				in_out_vrr->max_refresh_in_uhz);
-		in_out_vrr->adjust.v_total_max = in_out_vrr->adjust.v_total_min;
+		in_out_vrr->adjust.v_total_min = stream->timing.v_total;
+		in_out_vrr->adjust.v_total_max = stream->timing.v_total;
 		return;
 	}
 }
-- 
2.53.0



