Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DCB28183CA6;
	Mon, 12 Aug 2024 16:18:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723479481; cv=none; b=uJ/BUB4qAUCcwfD7PBGn1H3nyT8S9VQkjn0s5cl8sWtKgDGHMazL3StoHYXXjAcWwoL++iOa0SltPTIh7OM9HyXkpZ7Atqd6VHTNnpkaVXVGWSbfQXWrZDorh7f7f3ZCT5fjBSaeDT9ML/JOsSOcRsBgr1HN3KFrfT7rwU9oJFE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723479481; c=relaxed/simple;
	bh=PQRmGC643jD46ncHFybyaXNaSquTxnFdaGjbee9VwPY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eAJXR/FOK1mkaBcYYxbocKncGK/maGQLB90eUPwgusGExdTPyoAXKB07qkhhb9joaRRmKxaNyslxlmWcLMr0mxn88OBjblOgFJjScztbVcsXi3W2A8en6F061O2av8nEmQ0FtfKD993L3fvpGKysfd2QSLcYxvoFdmasdpC08Ho=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=emRY3a+Z; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="emRY3a+Z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B4EB7C32782;
	Mon, 12 Aug 2024 16:17:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723479480;
	bh=PQRmGC643jD46ncHFybyaXNaSquTxnFdaGjbee9VwPY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=emRY3a+ZMA7N4XVZ53tPU+FV4XJF2Xix7ZRy7y3yFUzAp1v+gACFi1PQUxPgU0M+8
	 DO358ed8NfpU2E6CLt0TGe2kObw+Ob4n0lEnXz+jh+5yJn7wOmCtEzcJhfYUF2yEpv
	 Ks1kT6uD61xkaYkUgIdvg4CbsDht3Na/tET0IeYo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tom Chung <chiahsuan.chung@amd.com>,
	Rodrigo Siqueira <Rodrigo.Siqueira@amd.com>,
	Roman Li <roman.li@amd.com>,
	Hersen Wu <hersenxs.wu@amd.com>,
	Alex Hung <alex.hung@amd.com>,
	Aurabindo Pillai <aurabindo.pillai@amd.com>,
	Harry Wentland <harry.wentland@amd.com>,
	Srinivasan Shanmugam <srinivasan.shanmugam@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 059/189] drm/amd/display: Add NULL check for afb before dereferencing in amdgpu_dm_plane_handle_cursor_update
Date: Mon, 12 Aug 2024 18:01:55 +0200
Message-ID: <20240812160134.415983217@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240812160132.135168257@linuxfoundation.org>
References: <20240812160132.135168257@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Srinivasan Shanmugam <srinivasan.shanmugam@amd.com>

[ Upstream commit 38e6f715b02b572f74677eb2f29d3b4bc6f1ddff ]

This commit adds a null check for the 'afb' variable in the
amdgpu_dm_plane_handle_cursor_update function. Previously, 'afb' was
assumed to be null, but was used later in the code without a null check.
This could potentially lead to a null pointer dereference.

Fixes the below:
drivers/gpu/drm/amd/amdgpu/../display/amdgpu_dm/amdgpu_dm_plane.c:1298 amdgpu_dm_plane_handle_cursor_update() error: we previously assumed 'afb' could be null (see line 1252)

Cc: Tom Chung <chiahsuan.chung@amd.com>
Cc: Rodrigo Siqueira <Rodrigo.Siqueira@amd.com>
Cc: Roman Li <roman.li@amd.com>
Cc: Hersen Wu <hersenxs.wu@amd.com>
Cc: Alex Hung <alex.hung@amd.com>
Cc: Aurabindo Pillai <aurabindo.pillai@amd.com>
Cc: Harry Wentland <harry.wentland@amd.com>
Signed-off-by: Srinivasan Shanmugam <srinivasan.shanmugam@amd.com>
Reviewed-by: Harry Wentland <harry.wentland@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../drm/amd/display/amdgpu_dm/amdgpu_dm_plane.c  | 16 ++++++++++++----
 1 file changed, 12 insertions(+), 4 deletions(-)

diff --git a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_plane.c b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_plane.c
index cc74dd69acf2b..eb77de95f26f5 100644
--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_plane.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_plane.c
@@ -1225,14 +1225,22 @@ void amdgpu_dm_plane_handle_cursor_update(struct drm_plane *plane,
 {
 	struct amdgpu_device *adev = drm_to_adev(plane->dev);
 	struct amdgpu_framebuffer *afb = to_amdgpu_framebuffer(plane->state->fb);
-	struct drm_crtc *crtc = afb ? plane->state->crtc : old_plane_state->crtc;
-	struct dm_crtc_state *crtc_state = crtc ? to_dm_crtc_state(crtc->state) : NULL;
-	struct amdgpu_crtc *amdgpu_crtc = to_amdgpu_crtc(crtc);
-	uint64_t address = afb ? afb->address : 0;
+	struct drm_crtc *crtc;
+	struct dm_crtc_state *crtc_state;
+	struct amdgpu_crtc *amdgpu_crtc;
+	u64 address;
 	struct dc_cursor_position position = {0};
 	struct dc_cursor_attributes attributes;
 	int ret;
 
+	if (!afb)
+		return;
+
+	crtc = plane->state->crtc ? plane->state->crtc : old_plane_state->crtc;
+	crtc_state = crtc ? to_dm_crtc_state(crtc->state) : NULL;
+	amdgpu_crtc = to_amdgpu_crtc(crtc);
+	address = afb->address;
+
 	if (!plane->state->fb && !old_plane_state->fb)
 		return;
 
-- 
2.43.0



