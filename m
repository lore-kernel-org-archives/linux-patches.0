Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BDDF0183CA6;
	Mon, 12 Aug 2024 16:21:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723479719; cv=none; b=AapnN4dtOHdQHdnrDWIoSbH9BjQ6k0Ns3QfUEJ+TOlL9Y0/4hRR0PbgGh4b1ELxy8VtdyyGIXvEAV5qYiQWtaU66W/R+kwsgL0pNPEcRz4fhwol4SRJZpu0xBJuUyG3JubH3m/qZWLN0AoTUBJK23WbABYfEyA1ZgJHTqvNWDGY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723479719; c=relaxed/simple;
	bh=IiVRSicv+o5LUB3cuLQroKBf9PQjMTcmJrRz1S4uylI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UDeuTL2l81fsz1rzgS6xwo+krbXtHbUsxaE3xUfqOikCWPra1eLiGfcSn7ARg8kzyz6hxoowK7IQdVeauk2rzLW/ehALu9HjxcbSaphAtZth58idSCyjakEIFwrYShQJptnvGQrAZtZqaOMzM2FYWYcVmWQUs/2UeMswbRjLSU0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=a8AjG7lF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="a8AjG7lF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CAEA5C32782;
	Mon, 12 Aug 2024 16:21:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723479719;
	bh=IiVRSicv+o5LUB3cuLQroKBf9PQjMTcmJrRz1S4uylI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=a8AjG7lF+uHscZHZOkAqn/sVP5mVXIsC++PctL/1KueOVlV+yAxPLIygq4Wdyq44b
	 yqKNhJ4aqpxJFtiZLhGmZwcFm+1ZVuKEryRljdsC6lHx47Ie9iwAsKILgJzpsm0qLJ
	 SZDe3ZtMXh4sNXWjoSnBi66G2PL6iCDTHExvxd7k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Srinivasan Shanmugam <srinivasan.shanmugam@amd.com>,
	George Zhang <George.zhang@amd.com>,
	Ivan Lipski <ivlipski@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.6 172/189] Revert "drm/amd/display: Add NULL check for afb before dereferencing in amdgpu_dm_plane_handle_cursor_update"
Date: Mon, 12 Aug 2024 18:03:48 +0200
Message-ID: <20240812160138.766796293@linuxfoundation.org>
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
@@ -1225,22 +1225,14 @@ void amdgpu_dm_plane_handle_cursor_updat
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
 


