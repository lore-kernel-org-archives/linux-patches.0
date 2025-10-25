Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D905205AB6;
	Sat, 25 Oct 2025 16:09:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761408568; cv=none; b=NGwpreO5rxgPvhpIuVCC4AWIDVrqdaFuWia/h3Ztk70MyoZKKQ4GYYUCsL6MBwVENexaNScrwfIcvVPSVmlyVrhOstkY2fKdArwl/2OJJ2aKiQ97K+DlZ2mwyEGL+zUCLb1FuV3c5CeCFgdLyZ/6oXWQkluAhqxq6wkOdDpOf+g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761408568; c=relaxed/simple;
	bh=2d7hUEiGhg9UfEShfuwiWA5RNuIZNt9wq3EFNmRce8k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Ao68ov1Dj8MFkX0N52H3+PXHklLOJZYxXQEJhHNqm42LD3Gm3f2OW5k9VGYeiOkRoOYvzHYQggXVJwLNBibAksfbNVxQeRNULKM5kted7R1IwcBTJmYJbaGCYDOJ7OuLRr9vx+E25Jldm+enOCOZCR0LW2neW8pf5+TgpPJH7WA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=eP6GeIMg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="eP6GeIMg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9E6C7C4AF09;
	Sat, 25 Oct 2025 16:09:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1761408567;
	bh=2d7hUEiGhg9UfEShfuwiWA5RNuIZNt9wq3EFNmRce8k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=eP6GeIMg3ssMpqmoGnpAQltBurH994gSf5jBUoukHAiS+INja8zNrBTsnApw9iqTn
	 KxfzIIZDIVRK/ms9g6AVzfsOBePfajM1Ik5o9ft/Azoi2Q9C7DSQNhXFEOYuAOPODG
	 eccrOoEcce4D5sZYrzk8cvMifJ3J6qdW8ed5pOMTJTiWq0r33KxQCZa0lmB3mC9yyg
	 J0WhvrzeL9OCv8phiLEZk+cTk72LGB9wFRSV3iYN2LFqaqSHoRpDe0LFC25mMzFlk6
	 rQyg/9m9zEVZ3uJR+gZ0AdIN0u9EyZlqr8QZZHEOGJKoloGn64C99D0Z68HbXXow83
	 ExtD8jGIhc/qw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Karthi Kandasamy <karthi.kandasamy@amd.com>,
	Aric Cyr <aric.cyr@amd.com>,
	Ivan Lipski <ivan.lipski@amd.com>,
	Dan Wheeler <daniel.wheeler@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>,
	Wayne.Lin@amd.com,
	roman.li@amd.com,
	alvin.lee2@amd.com,
	ray.wu@amd.com,
	Dillon.Varone@amd.com,
	PeiChen.Huang@amd.com,
	Charlene.Liu@amd.com,
	Sung.Lee@amd.com,
	alexandre.f.demers@gmail.com,
	Richard.Chiang@amd.com,
	ryanseto@amd.com,
	linux@treblig.org,
	mario.limonciello@amd.com,
	alex.hung@amd.com,
	chiahsuan.chung@amd.com,
	harry.wentland@amd.com,
	chris.park@amd.com,
	make24@iscas.ac.cn,
	rvojvodi@amd.com,
	haoping.liu@amd.com,
	siqueira@igalia.com,
	mwen@igalia.com
Subject: [PATCH AUTOSEL 6.17-6.6] drm/amd/display: Add AVI infoframe copy in copy_stream_update_to_stream
Date: Sat, 25 Oct 2025 11:53:59 -0400
Message-ID: <20251025160905.3857885-8-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251025160905.3857885-1-sashal@kernel.org>
References: <20251025160905.3857885-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.17.5
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Karthi Kandasamy <karthi.kandasamy@amd.com>

[ Upstream commit c8bedab2d9a1a0daa49ac20f9928a943f7205582 ]

[WHY]
Ensure AVI infoframe updates from stream updates are applied to the active
stream so OS overrides are not lost.

[HOW]
Copy avi_infopacket to stream when valid flag is set.
Follow existing infopacket copy pattern and perform a basic validity check before assignment.

Reviewed-by: Aric Cyr <aric.cyr@amd.com>
Signed-off-by: Karthi Kandasamy <karthi.kandasamy@amd.com>
Signed-off-by: Ivan Lipski <ivan.lipski@amd.com>
Tested-by: Dan Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

YES. This change plugs a real bug: when userspace/OS pushes an AVI
infoframe override through `dc_stream_update`, the override was never
persisted into the active `dc_stream_state`, so the next
`resource_build_info_frame()` rebuilt the packet from defaults and
silently threw the override away. The fix mirrors the existing handling
for other info packets: it copies the provided AVI packet into the
stream state (`drivers/gpu/drm/amd/display/dc/core/dc.c:3313`) and adds
storage for it in the stream/update structs
(`drivers/gpu/drm/amd/display/dc/dc_stream.h:206` and
`drivers/gpu/drm/amd/display/dc/dc_stream.h:339`). Once stored,
`set_avi_info_frame()` now reuses the cached packet whenever it’s marked
valid (`drivers/gpu/drm/amd/display/dc/core/dc_resource.c:4413`), so
overrides survive later updates. The patch also hooks the new field into
the existing update machinery—triggering info-frame reprogramming
(`drivers/gpu/drm/amd/display/dc/core/dc.c:3611`) and forcing a full
update when necessary
(`drivers/gpu/drm/amd/display/dc/core/dc.c:5083`)—again matching the
pattern used by the other infoframes.

The change is tightly scoped to AMD DC, introduces no behavioural change
unless an override is actually provided, and the new fields are zeroed
via the existing `kzalloc`/`memset` initialisation paths
(`drivers/gpu/drm/amd/display/dc/core/dc_stream.c:172` and e.g.
`drivers/gpu/drm/amd/display/dc/link/link_dpms.c:144`), so there’s
little regression risk. Given that losing AVI overrides breaks colour-
space/format configuration for affected HDMI users, this is an
appropriate, low-risk candidate for stable backport. Natural next step:
queue it for the AMD display stable picks that cover HDMI infoframe
fixes.

 drivers/gpu/drm/amd/display/dc/core/dc.c          | 7 ++++++-
 drivers/gpu/drm/amd/display/dc/core/dc_resource.c | 6 ++++++
 drivers/gpu/drm/amd/display/dc/dc_stream.h        | 3 +++
 3 files changed, 15 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/display/dc/core/dc.c b/drivers/gpu/drm/amd/display/dc/core/dc.c
index 74efd50b7c23a..77a842cf84e08 100644
--- a/drivers/gpu/drm/amd/display/dc/core/dc.c
+++ b/drivers/gpu/drm/amd/display/dc/core/dc.c
@@ -3307,6 +3307,9 @@ static void copy_stream_update_to_stream(struct dc *dc,
 	if (update->adaptive_sync_infopacket)
 		stream->adaptive_sync_infopacket = *update->adaptive_sync_infopacket;
 
+	if (update->avi_infopacket)
+		stream->avi_infopacket = *update->avi_infopacket;
+
 	if (update->dither_option)
 		stream->dither_option = *update->dither_option;
 
@@ -3601,7 +3604,8 @@ static void commit_planes_do_stream_update(struct dc *dc,
 					stream_update->vsp_infopacket ||
 					stream_update->hfvsif_infopacket ||
 					stream_update->adaptive_sync_infopacket ||
-					stream_update->vtem_infopacket) {
+					stream_update->vtem_infopacket ||
+					stream_update->avi_infopacket) {
 				resource_build_info_frame(pipe_ctx);
 				dc->hwss.update_info_frame(pipe_ctx);
 
@@ -5073,6 +5077,7 @@ static bool full_update_required(struct dc *dc,
 			stream_update->hfvsif_infopacket ||
 			stream_update->vtem_infopacket ||
 			stream_update->adaptive_sync_infopacket ||
+			stream_update->avi_infopacket ||
 			stream_update->dpms_off ||
 			stream_update->allow_freesync ||
 			stream_update->vrr_active_variable ||
diff --git a/drivers/gpu/drm/amd/display/dc/core/dc_resource.c b/drivers/gpu/drm/amd/display/dc/core/dc_resource.c
index d712548b1927d..d37fc14e27dbf 100644
--- a/drivers/gpu/drm/amd/display/dc/core/dc_resource.c
+++ b/drivers/gpu/drm/amd/display/dc/core/dc_resource.c
@@ -4417,8 +4417,14 @@ static void set_avi_info_frame(
 	unsigned int fr_ind = pipe_ctx->stream->timing.fr_index;
 	enum dc_timing_3d_format format;
 
+	if (stream->avi_infopacket.valid) {
+		*info_packet = stream->avi_infopacket;
+		return;
+	}
+
 	memset(&hdmi_info, 0, sizeof(union hdmi_info_packet));
 
+
 	color_space = pipe_ctx->stream->output_color_space;
 	if (color_space == COLOR_SPACE_UNKNOWN)
 		color_space = (stream->timing.pixel_encoding == PIXEL_ENCODING_RGB) ?
diff --git a/drivers/gpu/drm/amd/display/dc/dc_stream.h b/drivers/gpu/drm/amd/display/dc/dc_stream.h
index 5fc6fea211de3..76cf9fdedab0e 100644
--- a/drivers/gpu/drm/amd/display/dc/dc_stream.h
+++ b/drivers/gpu/drm/amd/display/dc/dc_stream.h
@@ -203,6 +203,7 @@ struct dc_stream_state {
 	struct dc_info_packet hfvsif_infopacket;
 	struct dc_info_packet vtem_infopacket;
 	struct dc_info_packet adaptive_sync_infopacket;
+	struct dc_info_packet avi_infopacket;
 	uint8_t dsc_packed_pps[128];
 	struct rect src; /* composition area */
 	struct rect dst; /* stream addressable area */
@@ -335,6 +336,8 @@ struct dc_stream_update {
 	struct dc_info_packet *hfvsif_infopacket;
 	struct dc_info_packet *vtem_infopacket;
 	struct dc_info_packet *adaptive_sync_infopacket;
+	struct dc_info_packet *avi_infopacket;
+
 	bool *dpms_off;
 	bool integer_scaling_update;
 	bool *allow_freesync;
-- 
2.51.0

