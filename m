Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 06C521494B8;
	Mon, 12 Aug 2024 16:37:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723480646; cv=none; b=RuSxI4RpIDU9DkZv9PQOgbWv4HoohA2qm15vb+aPNrpFBygzrzuHWce+dfXS74JabkW18V6Cf50O/oMEfeojQgBoBY+ErL5E4KcroyZfFYjtWIe18dtc7vFdvFDFSR6a3gqyVNiUTRubqJfUvZwQ7Rb9oclInqsLDmwnAa8iOY0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723480646; c=relaxed/simple;
	bh=XBz0FAfJB6U7d58uWH/pn5vuxLBZ4akmiv1dX9RLFR0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GFnscTio3F8H8hCXrlZJ5oeujv3/R0ztJvzOG+Yy9mXDIvEnCh94uy56BJR+gkyQWY5vZzOjmM6FEMNjPXvDnNj8MTv6Ks6KkYhTuMjaOmmNLOkzksclRuyryVLmTVtu0AksxmuHv8vF5gMXmqJda6LzPfgwVwjE9CKb6Q07Uss=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=snmHD1ue; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="snmHD1ue"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 60B1AC32782;
	Mon, 12 Aug 2024 16:37:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723480645;
	bh=XBz0FAfJB6U7d58uWH/pn5vuxLBZ4akmiv1dX9RLFR0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=snmHD1ueqqTlwXgZZcdaPOs43RQR5e0v4NMuzjQTdVdtqMhpglT8VyIeqKfrCuBFC
	 vmFXVGryG2GbxcycDYMf92sExh50uXJb5pHNsI/GWkS7rUD+deVSgBLEbOLF4suifG
	 efkyHVLPI8dDcRJBmBWWnH7VCxdqlvRMHwVHY1Fc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Srinivasan Shanmugam <srinivasan.shanmugam@amd.com>,
	George Zhang <George.zhang@amd.com>,
	Ivan Lipski <ivlipski@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.10 252/263] Revert "drm/amd/display: Add NULL check for afb before dereferencing in amdgpu_dm_plane_handle_cursor_update"
Date: Mon, 12 Aug 2024 18:04:13 +0200
Message-ID: <20240812160156.190495950@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240812160146.517184156@linuxfoundation.org>
References: <20240812160146.517184156@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1231,22 +1231,14 @@ void amdgpu_dm_plane_handle_cursor_updat
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
 


