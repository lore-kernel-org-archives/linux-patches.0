Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F283186295;
	Mon, 12 Aug 2024 16:06:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723478803; cv=none; b=qrZa0yysIQd0VdcjGNpZI7Cef+1Uvt41cJ5QknNhsnBRAu37lgI/vkD/2AN6+G9WDwkLi4Hao1/BLC35eBgZBmFnp6Vc9lXKPpA2Rzdn78srDEUyUU5Jprw+bJCuy8KPHzr1rviACfqGPu/q6JKnEAggL8LOk4Apxz+WJwE4fVo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723478803; c=relaxed/simple;
	bh=YikAgcnntTP/okxF56LwhmkLKggU16V745ZBkYngBPg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Il1k1o9jRuSBuVspRS5n7/ay7YTdoAIupzqQC3Ob+39CD1oHutc4A/yszTQL++0M4dXEHKle/u8mR2TPfNzgNZGto/n52jt+QmkfLzQcg6y6sqw0Ejwt18KRhipAWfVzt3hjsHbdMhwQGGnggCrEgoXqww2JqGge9dNCBXdWNI0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=X9NRUi4U; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="X9NRUi4U"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 739EDC32782;
	Mon, 12 Aug 2024 16:06:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723478803;
	bh=YikAgcnntTP/okxF56LwhmkLKggU16V745ZBkYngBPg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=X9NRUi4Urbte8uh3Szs6DIwaqO5qynyTOyrmTpNw2hKwWRwEgBBY36GOHAusBbi1f
	 Q7PomoiSzkdpB6EYqq7A9ME21aQwI01SFttll02TgZiEVc7AvXtpCN06eBqB4ThJnu
	 qKzbAEc9yguW6idzpNnTs9jPQ6IeuwNKIXcFWkOE=
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
Subject: [PATCH 6.1 041/150] drm/amd/display: Add NULL check for afb before dereferencing in amdgpu_dm_plane_handle_cursor_update
Date: Mon, 12 Aug 2024 18:02:02 +0200
Message-ID: <20240812160126.749885027@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240812160125.139701076@linuxfoundation.org>
References: <20240812160125.139701076@linuxfoundation.org>
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
index cd6e99cf74a06..984a5affc5af1 100644
--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_plane.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_plane.c
@@ -1225,14 +1225,22 @@ void handle_cursor_update(struct drm_plane *plane,
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



