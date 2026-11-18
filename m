Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795052915;
	b=bjQCQlpqNEJoEo7zalVjp60RmT0kBqT+W6/TJWsWMbNLKOzP/cNb8RgUfalHBLPKhhi7
	 nERG3gEL/jnIth62AWGvPrGcubcCd8Q8RggiYoPmCz+FL0YW643A0n4RFsYvYXASqWHIZ
	 NsfmHrkL9COHbUWMEhGpbH5+PvHWzy8DJSLrV3X12DjpyWb9XJD9+xw1MCUpvukR/NyeD
	 +Sv1QyvPux16yjtVKn2yEvGfJEooJkrLVXFu3Y36yTq0xvIPQRnstZTQK2F7/Sg+X3e+O
	 9EdAn9NGRQY3xdAPP3Q/ytcnlO2yC2eYLHVgq/Hqc/Vd9n6Sm5iNU6Hx3dL8jAGLU3w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795052915;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=dPID0QSCfU6QzN4JCNbkgdmRxTpVTsiRnpTybpJW084=;
	b=d1ebPy1cpxdpU/nxzL89dJWArrzAA0USHOZgpi5yJpQnPmR4o2ikNOoXamEuPSpoVEwD
	 /iZzbp7BN4e80gCPTnm1NhzglAtZI7RW4D4SjrB4IFtl73/xt3y8RGA8FXk3IOTWp7HXQ
	 ugXwrszNcQZ74tt+OwybrMECBZMwJlXuQdaxjapCKxnR6teJgI0iPJ2aK6Pv1SfrS/Jp6
	 uj5G6vQo1cEyA2qHAaIL0pkN6f5dZZ79pVw6s9Wq8vK8N1hMBF4bTCLrTREliUu4p5o9q
	 81GukaQ8vopVJMvF9r/9F5WcXpp84+xXf+6gSucVUtDUx0V9KZz1U6ZKqCpMW5xohnw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=1JvIpw99;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD988606A31C;
	Thu, 19 Nov 2026 01:48:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=1JvIpw99
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0DD4E1F000C4;
	Thu, 19 Nov 2026 01:48:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795052915;
	bh=dPID0QSCfU6QzN4JCNbkgdmRxTpVTsiRnpTybpJW084=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1JvIpw993ebsdV7nuc4j82kxzuR2JYTP+BPhSAss3bdTuwMZ5LxCqMR0Fex0LZJdF
	 VxiJHsY0xXO6ro6dE4Bi4Ov+13jAaNRBKm+GFQ+/ko3O4zvKCeqSV180a0hN/buyD4
	 p5Ksd4Rrq+t/S+KCkSxP31njQHlAjvDtRvas7OVw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alex Deucher <alexander.deucher@amd.com>,
	Luigi Lauro <luigi.lauro@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 0730/2214] drm/amd/display: take a runtime PM reference only when a CRTC turns on
Date: Wed, 18 Nov 2026 15:40:06 +0100
Message-ID: <20261118150041.047146874@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Luigi Lauro <luigi.lauro@gmail.com>

[ Upstream commit b456f591f925fbd6b33770d0eec1b51c2f9d41c1 ]

amdgpu_dm_commit_streams() takes a runtime PM reference for every
active CRTC that needs a modeset and has a new stream, but
amdgpu_dm_atomic_commit_tail() drops one only for each CRTC that goes
from active to inactive. A modeset of a CRTC that is already active (a
mode change, or anything else that needs a full modeset) therefore
leaks one reference. Once that has happened, the usage count no longer
returns to zero with every CRTC off, and the device cannot runtime
suspend again until reboot. The two also disagree the other way when a
CRTC turns on without a stream ("Failed to create new stream"): no
reference is taken, but one is dropped when it turns off.

Take the reference in the loop that counts the disabled CRTCs, on the
mirror condition: when the CRTC goes from inactive to active, which is
what the commit that added it intended ("every time we enable a
previously disabled CRTC"). Each active CRTC then holds exactly one
reference.

Tested on an RX 9070 XT (Navi 48) over OCuLink, with the change
backported to 7.2.9: an unplugged connector forced on, then mode A on a
CRTC, mode B on the same active CRTC, and the CRTC off, three rounds in
a row. The usage count rose by 3 with the stock module, by 0 with this
patch, and by 3 again after reloading the stock module.

Fixes: 97028037a38a ("drm/amdgpu: Grab/put runtime PM references in atomic_commit_tail()")
Closes: https://gitlab.freedesktop.org/drm/amd/-/issues/5951
Assisted-by: Claude:claude-opus-5-5
Reviewed-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Luigi Lauro <luigi.lauro@gmail.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit 59ef9a435499777b8e1c4e0eff52f813c64fb920)
Cc: stable@vger.kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c | 11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

diff --git a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
index d22c05f68f876..b1fab9ba82963 100644
--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
@@ -9640,8 +9640,6 @@ static void amdgpu_dm_atomic_commit_tail(struct drm_atomic_state *state)
 			if (dm_old_crtc_state->stream)
 				remove_stream(adev, acrtc, dm_old_crtc_state->stream);
 
-			pm_runtime_get_noresume(dev->dev);
-
 			acrtc->enabled = true;
 			acrtc->hw_mode = new_crtc_state->mode;
 			crtc->hwmode = new_crtc_state->mode;
@@ -9911,8 +9909,13 @@ static void amdgpu_dm_atomic_commit_tail(struct drm_atomic_state *state)
 		struct crc_rd_work *crc_rd_wrk;
 #endif
 #endif
-		/* Count number of newly disabled CRTCs for dropping PM refs later. */
-		if (old_crtc_state->active && !new_crtc_state->active)
+		/*
+		 * One runtime PM reference per active CRTC: take it when the
+		 * CRTC turns on, count it when it turns off for dropping later.
+		 */
+		if (!old_crtc_state->active && new_crtc_state->active)
+			pm_runtime_get_noresume(dev->dev);
+		else if (old_crtc_state->active && !new_crtc_state->active)
 			crtc_disable_count++;
 
 		dm_new_crtc_state = to_dm_crtc_state(new_crtc_state);
-- 
2.53.0



