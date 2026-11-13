Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794585812;
	b=agT9J2+7qKm8RUjaxffcL+kkb4KbZiKIY4TBVaPJmQfNfgHCO4hzOA96mEsuzdMikSD9
	 JqZLhhScdu1UaI+tyvjMEUPg3c8H10WaYnnT+BE3w5niIStXgpLSnUn1t530qpxKo92/J
	 xTSI3AkaGVblXwKBSl1+q1oyw0Kqo0CpAJPhadYaoa3AwotF/T4+vriUbKRS3GztdxrQq
	 tvrpgKu2Rvj9+M/dMFvep+NQCMvR2Bh8B8kHt5bHFaen2zwwxdWR576UEnK/vyRgjzm70
	 XiHFnYq8xW6LzmniUfhDfWwyGRJlafs9QMM1JFLys4JEObb3OuFxNB13XfXXH46iRrw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794585812;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=uPzME0KqL9XyVFJjtQ14rQUsfn7ppzXg5rSFnWCYEvw=;
	b=YqkBbwRTFX5XpLJcEjNxcVUVKQDRjwRRgOTfFDwXRxRNf4riPOvpEtOsYP0Crwck0B3p
	 LDVJctnhSBJggt5d69TQkzPGCvx1gu8cjdoDz09FaYYuWx2C4+dBQ+APku6DkTIhzP9NR
	 rLELdm8IGMdf6lEWQU51EI9vT5z9TUcaUIwEUjHb/g3qcsaaY3bNktbrfEbSuiab8yhsa
	 jzq8SK4a6+RIRs1dWIUOFQm0Houc8auboBaHMl3342KQeZVF/J+8tLgRhBd2nzaNPNP4j
	 DAeRkM9BwH64H7oImJOm7866vUEI0qwb17Ick3PFaZkAtgHBegL81l++bEI13IXgCQg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=lcrAnhe+;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D6B53606BA98;
	Fri, 13 Nov 2026 16:03:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=lcrAnhe+
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 82B871F000C5;
	Fri, 13 Nov 2026 16:03:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794585812;
	bh=uPzME0KqL9XyVFJjtQ14rQUsfn7ppzXg5rSFnWCYEvw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=lcrAnhe+lHcj9c7Z2hD9yztWjRQtLcTkSV9JANoKcIWGiPdKTe6N6JDtEIYJ4qfv+
	 Np/kWOWL/01LZLSH58kHp67r2fpGv9LahQw1iU7dc+mBqKgdkbHoN0dR5vIA8l+bwR
	 4BIWWYn8/G3UfOSe3V9CHN3OkGEiXqafQXLHPg0Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Josh Kasten <jkasten@gmail.com>,
	Mikhail Gavrilov <mikhail.v.gavrilov@gmail.com>,
	Alex Hung <alex.hung@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 369/507] drm/amd/display: set allow_freesync before validating a new stream
Date: Fri, 13 Nov 2026 10:51:13 -0500
Message-ID: <20261113153808.567800324@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153753.358973689@linuxfoundation.org>
References: <20261113153753.358973689@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_freesync.c    | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_freesync.c b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_freesync.c
index 7e484adb4120f..f26dd206dffa0 100644
--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_freesync.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_freesync.c
@@ -128,6 +128,14 @@ void amdgpu_dm_get_freesync_config_for_crtc(
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



