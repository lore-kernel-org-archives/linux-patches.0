Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E9E31EA8D;
	Mon, 12 Aug 2024 16:11:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723479108; cv=none; b=IDneGfEEzny9P2cI8K5EpwYIrKg0Vau3VlPI3bEsCfaS/Fr3HWTamU1QeGiHEPvSNpZ2CMVdPcuMwgBUZLD0xvYcs0qf+irMnDDo1gvMYfTejJATloQi1MyDd0bDQQ0gBycmks36Sdaj0ia/EnB6GS2J3gcyJpnkOjtByMN+2Sc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723479108; c=relaxed/simple;
	bh=bJbzYe1bB5opsLnAhYNlNDWYJ8qp4ujrggO/ow+QwhM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CS0Cdx9BXVQVUIxNJw6spezrr0nLF1LLuIN+BjNUsE1SpiiijX/6juywgCqoRoQA7YTZDuZdJkfE4cVHnlfb+t6N5almQdi3yvp+sU8L2P2sk46VanOZnRDBQPAr9DMcOPqvxTNcmsCPWWi9dLO1IG7qKJpQ5lofeHhRLTpGuuE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fka7ThaN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fka7ThaN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9E7CEC32782;
	Mon, 12 Aug 2024 16:11:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723479108;
	bh=bJbzYe1bB5opsLnAhYNlNDWYJ8qp4ujrggO/ow+QwhM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fka7ThaNu2m+ped8XY29HJhQJPlU0yq+dSkD7QNcDhKTI/YJ+QWvIMe9cI8sVZ2kA
	 XPdB4o46mYKHKDtOacMaEGlajtpBJO2Braj5uuBRNWaLP1h73DssfbzGJJbUSf3YAC
	 e85+1jyTmFMoggeTzOB1EXnDqbkHMMaDQJdhaYoo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Srinivasan Shanmugam <srinivasan.shanmugam@amd.com>,
	George Zhang <George.zhang@amd.com>,
	Ivan Lipski <ivlipski@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.1 136/150] Revert "drm/amd/display: Add NULL check for afb before dereferencing in amdgpu_dm_plane_handle_cursor_update"
Date: Mon, 12 Aug 2024 18:03:37 +0200
Message-ID: <20240812160130.417288426@linuxfoundation.org>
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

From: Ivan Lipski <ivlipski@amd.com>

commit 778e3979c5dc9cbdb5d1b92afed427de6bc483b4 upstream.

[WHY]
This patch is a dupplicate implementation of 14bcf29b, which we
are reverting due to a regression with kms_plane_cursor IGT tests.

This reverts commit 38e6f715b02b572f74677eb2f29d3b4bc6f1ddff.

Reviewed-by: Srinivasan Shanmugam <srinivasan.shanmugam@amd.com>
Tested-by: George Zhang <George.zhang@amd.com>
Signed-off-by: Ivan Lipski <ivlipski@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_plane.c |   16 ++++------------
 1 file changed, 4 insertions(+), 12 deletions(-)

--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_plane.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_plane.c
@@ -1225,22 +1225,14 @@ void handle_cursor_update(struct drm_pla
 {
 	struct amdgpu_device *adev = drm_to_adev(plane->dev);
 	struct amdgpu_framebuffer *afb = to_amdgpu_framebuffer(plane->state->fb);
-	struct drm_crtc *crtc;
-	struct dm_crtc_state *crtc_state;
-	struct amdgpu_crtc *amdgpu_crtc;
-	u64 address;
+	struct drm_crtc *crtc = afb ? plane->state->crtc : old_plane_state->crtc;
+	struct dm_crtc_state *crtc_state = crtc ? to_dm_crtc_state(crtc->state) : NULL;
+	struct amdgpu_crtc *amdgpu_crtc = to_amdgpu_crtc(crtc);
+	uint64_t address = afb ? afb->address : 0;
 	struct dc_cursor_position position = {0};
 	struct dc_cursor_attributes attributes;
 	int ret;
 
-	if (!afb)
-		return;
-
-	crtc = plane->state->crtc ? plane->state->crtc : old_plane_state->crtc;
-	crtc_state = crtc ? to_dm_crtc_state(crtc->state) : NULL;
-	amdgpu_crtc = to_amdgpu_crtc(crtc);
-	address = afb->address;
-
 	if (!plane->state->fb && !old_plane_state->fb)
 		return;
 


