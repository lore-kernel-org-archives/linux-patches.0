Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795022573;
	b=nKDzDxHJRcsJq/0t0q4F75lAYt85cIbXkdaePDQR9RkTbOagUFB/MEjsaHby7+YTxNiu
	 oRR5RWSHceygBceiZI+Kx/G+tHxhxcWXbVg+xsMr4VbnaFB+vSxZZU4bNb7BJM9qb++UG
	 g1rkgJyAlV5Jsboko5m5Y+l70nJ+Nmi3GOWXYoYRXdoIk6ia16i8g5j4vL4lvoqBdcjSI
	 H/e1dTkqsnlO3z3D52qhgWDFmZ2sW+vKpnQPILbe+FHr78hIxYrc4FcNxl+f3t4nCCfuy
	 +tWpX2Wyv9dvFWVA5aUjYqdctz45M9WmQDADZMPVwIW2I9xXmaTuDG26kcFdIi/AnJg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795022573;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=i4sjEKhSmxPikpuxq068HrPcBUlqurZAX24U1TYhUek=;
	b=5dqxEGLsCj1IRT+3UvWk3kkUCEXErhARljlEcC5Pe0XwJAmvYG9Cc0x+I+GtOe4cew2Z
	 CaEgcA50FOfYbcDmWaZk0Twg8gfrJaH/tgaefeBVpp1739Kc22SL28IxTqFE6ejaE+AHX
	 OR3AS4krQxAXLXtYuLaEiG7ltz0Z/rul6i7FqvZyC3PJLMrFQebZCfu6wBWvt2HfwBed9
	 Mgda909Ti7BoIcUt2A70OJyTM4aq0XXS70XbIfuLRp+kyFeNSSkm0bUyU9jyD2QdDNSl5
	 k15DJcqPDtk2eNcOdP3djGABaIKYz1E0qeWpCVJ8LO/UxANrLFzKOlexCbGPczdJEWQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Ym2mBk+T;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0DBB9606A330;
	Wed, 18 Nov 2026 17:22:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Ym2mBk+T
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 44B4A1F000C4;
	Wed, 18 Nov 2026 17:22:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795022572;
	bh=i4sjEKhSmxPikpuxq068HrPcBUlqurZAX24U1TYhUek=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Ym2mBk+T/tc407Cgj4BnJLxxawmt9hcmSx1VhpSyGmv26I/xs6VBK4vduhlqA++17
	 08amCAvo54lysS5sBRsrIRdz6RWET/NXdK8o7U0y8c9Ndaxm20ycBAHNWx1BScY34O
	 l+cNVQ0XYlKEEjtYmLymDvA6rFbujCSKXfZw8eio=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Josh Kasten <jkasten@gmail.com>,
	Mikhail Gavrilov <mikhail.v.gavrilov@gmail.com>,
	Alex Hung <alex.hung@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0062/2151] drm/amd/display: set allow_freesync before validating a new stream
Date: Wed, 18 Nov 2026 15:29:57 +0100
Message-ID: <20261118150124.017545917@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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

From: Mikhail Gavrilov <mikhail.v.gavrilov@gmail.com>

[ Upstream commit ab18dd3061eb2d92e60c8bbf9a435c25962e449f ]

After resume from S3, DC enables SubVP on a single FreeSync display at
a high refresh rate, although dcn32_allow_subvp_high_refresh_rate() is
meant to keep SubVP off that configuration ("For single display cases,
freesync must be disabled").  On an RX 7900 XTX driving a FreeSync TV
at 3840x2160@120, amdgpu_dm_capabilities reports sub-viewport disabled
after boot and enabled after "rtcwake -m mem", and the memory clock
starts switching.  It stays that way until a later commit re-validates
the state; a CRTC gamma change (toggling Night Light) turns SubVP off
again.

The policy reads dc_stream_state::allow_freesync while the new state
is validated, but amdgpu_dm sets that field only in
amdgpu_dm_update_freesync_state_on_stream(), on the first flip after
the commit.  A stream created by a modeset is therefore validated as
if FreeSync were off.  On resume, dm_destroy_cached_state() drops the
streams and forces a modeset, so the resumed state is validated
without FreeSync.

Set allow_freesync in amdgpu_dm_get_freesync_config_for_crtc(), which
atomic check calls for every active CRTC and which already writes
ignore_msa_timing_param to the stream.  It uses vrr_supported, the
condition the flip-time value is derived from.  With this change the
same TV keeps SubVP disabled across "rtcwake -m mem".

On this machine SubVP is also what exposes the single-frame scanout
corruption reported in the thread linked below, so the FreeSync
setting stopped working as a workaround after every suspend.

Fixes: 87f0c16e0eeb ("drm/amd/display: Enable SubVP for high refresh rate displays")
Link: https://lore.kernel.org/all/20260829010525.29935-1-mikhail.v.gavrilov@gmail.com/
Link: https://gitlab.freedesktop.org/drm/amd/-/work_items/5714#note_3736349
Tested-by: Josh Kasten <jkasten@gmail.com>
Signed-off-by: Mikhail Gavrilov <mikhail.v.gavrilov@gmail.com>
Reviewed-by: Alex Hung <alex.hung@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit 29793918b0eb63b6810b248a906f87dd79b70be5)
Cc: stable@vger.kernel.org
[ sashal: Applied the unchanged addition to get_freesync_config_for_crtc(), since the FreeSync helper extraction and renaming are absent. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
index a77b55ff9321f..40ac1a33326fa 100644
--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
@@ -11350,6 +11350,14 @@ static void get_freesync_config_for_crtc(
 					vrefresh >= aconnector->min_vfreq &&
 					vrefresh <= aconnector->max_vfreq;
 
+	/*
+	 * DC reads allow_freesync while validating the new state, for example
+	 * to keep SubVP off a single FreeSync display, but it is otherwise set
+	 * only on the first flip after the commit.  Set it here, so that a
+	 * stream created by this commit is not validated without it.
+	 */
+	new_crtc_state->stream->allow_freesync = new_crtc_state->vrr_supported;
+
 	if (new_crtc_state->vrr_supported) {
 		new_crtc_state->stream->ignore_msa_timing_param = true;
 		fs_vid_mode = new_crtc_state->freesync_config.state == VRR_STATE_ACTIVE_FIXED;
-- 
2.53.0



