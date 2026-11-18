Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795044206;
	b=Wa7+troAJrqi/vkyxq+2rz7wfpO0gwyT8qKqtBXBmf8qVe5RhJ40jrMdbCh/X5G3T3Ha
	 QdNMND/gkhl7VxCoM96116X9HlJBb3EzQfPUnu0Og7vo/53oUiLIK3ME6i81zPi2IiHB7
	 fyo9UEQ6tYqS1Y5VbtcIUHVcVDSA/Kl56gnRXUGO6SgRtXPTiXfGfSRn+Y/JvKP5R2eD0
	 ti9LdCqo3fGtyEmLSx7A4M/4WiMvsdVOjvOaUrBWcRM7BpsSxyRRarE2FcV1EO02pLUcX
	 QsUoJ4d4c3DESpTmuhJGq5QFPzU2hS8roumCC6Ul0vi7d0Tbdptwcln0lSd+xJXa0CQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795044206;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=jncQoly2h2r3VgnYMjP+M8MbZT7zERbB36KyCU/suoU=;
	b=JclDTNwVVhzfPoeSMyroxw718Wd5c34HBa6t5v1PYHiiG2J+DhkZ45b66cGPi3dWgqOU
	 KKp7AG10c3Liwh8nbY1f8JtcPiC54dhh81+WItRStedw0GzRytQE/3XQaMIOF4eXsDY6q
	 tqgd8HlOK5PNs1+AotntA5ZCp+V8r5C/xfWoROfTTebaBEZWO+yUlsAMnC2F1qXF4P3g8
	 6lDG7NzPiN12Lijor5e9cuQYqWByLaNK7ikPgfkzR6m4sZreGImo7vKmFMxH/aGX2bh9J
	 sLxCOaP6CANWhW3rovg4i6MWdeF4K6zdfHBfQua7WBQBbzTYi+PJbxjk1IUec/NDKZQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=cbtnuM8V;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 662EA606A320;
	Wed, 18 Nov 2026 23:23:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=cbtnuM8V
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 69F7B1F000C4;
	Wed, 18 Nov 2026 23:23:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795044206;
	bh=jncQoly2h2r3VgnYMjP+M8MbZT7zERbB36KyCU/suoU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=cbtnuM8VByM9LvZ1n9x4rhQk7lohlIE5H/MdQs/Lk51Y/o2kPbow79BCk0rAHP8PQ
	 rPPjLwl8o15Lc69Srr4Oo2Ko28uJUNQ1WJCXpXr6XUbbgxnkdGihWB2LoNKa45aHR0
	 eXQHNouMXYAJvQBX/WuUYKHwNlLqMT2EYd5ORJ+Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Leo Li <sunpeng.li@amd.com>,
	Harry Wentland <harry.wentland@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0485/2857] drm/amd/display: Fix direct scanout alpha on some DRM_FORMATs
Date: Wed, 18 Nov 2026 15:25:19 +0100
Message-ID: <20261118150218.896464022@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Leo Li <sunpeng.li@amd.com>

[ Upstream commit 7744262f5d63f9faa4d59dec127ae1c8b2d56495 ]

[Why]

DM was declaring it's own list of has_alpha DRM formats to check against
for enabling alpha blending, when the format->has_alpha already does
that for us.

The self-declared list missed some has_alpha formats, causing
direct-scanout planes with such formats to appear opaque.

[How]

Drop the self-declared list, instead use the format->has_alpha field
directly.

Signed-off-by: Leo Li <sunpeng.li@amd.com>
Reviewed-by: Harry Wentland <harry.wentland@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit 9ecdac91ed43d836683d5daa467f4907405420e2)
Cc: stable@vger.kernel.org
[ sashal: Dropped the 3-entry alpha_formats list (instead of upstream's 8-entry list) in fill_blending_from_plane_state(), replacing it with the has_alpha assignment. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../drm/amd/display/amdgpu_dm/amdgpu_dm_plane.c   | 15 +--------------
 1 file changed, 1 insertion(+), 14 deletions(-)

diff --git a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_plane.c b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_plane.c
index bf80846192641..6191a005d03b8 100644
--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_plane.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_plane.c
@@ -101,20 +101,7 @@ void fill_blending_from_plane_state(const struct drm_plane_state *plane_state,
 
 	if (plane_state->pixel_blend_mode == DRM_MODE_BLEND_PREMULTI ||
 		plane_state->pixel_blend_mode == DRM_MODE_BLEND_COVERAGE) {
-		static const uint32_t alpha_formats[] = {
-			DRM_FORMAT_ARGB8888,
-			DRM_FORMAT_RGBA8888,
-			DRM_FORMAT_ABGR8888,
-		};
-		uint32_t format = plane_state->fb->format->format;
-		unsigned int i;
-
-		for (i = 0; i < ARRAY_SIZE(alpha_formats); ++i) {
-			if (format == alpha_formats[i]) {
-				*per_pixel_alpha = true;
-				break;
-			}
-		}
+		*per_pixel_alpha = plane_state->fb->format->has_alpha;
 
 		if (*per_pixel_alpha && plane_state->pixel_blend_mode == DRM_MODE_BLEND_COVERAGE)
 			*pre_multiplied_alpha = false;
-- 
2.53.0



