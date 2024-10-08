Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5642C1D54D1;
	Tue,  8 Oct 2024 12:50:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728391822; cv=none; b=CJeLr2VLSCDORrsLuoYUNczE2DncszT63R9rx7tWLWfJUFUDDoOga2W6cRuEGPiPxEFgJjeOmT068c6K/pCCvYfCKsaUyavJgfKjxkYh540ldUTpW5lEDWaegbjVqfCNvy705gw2QOQyIaHde7FYgXMvuT9brMDLXGJSK3xPPE0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728391822; c=relaxed/simple;
	bh=+t9VqaikdCr0lV/0CyLFqJJ2gxixQwQluVIYPgKan4k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ohrd88OHhPgawG/nxLTefo3rBkBNadu2macWKYg/AErS9CUImDR8Vms/pYlokXC3wUnEtc5T4jVjbaWwedLEShW0KdPbIRrYiPI2LHaYbwrQ9icJr32IJb1TpWY+/6DG1md1IeY0es4rEwmxsOyvvkAyr8VcNOV1uJSk2dEwSx8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MZ1CyS12; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MZ1CyS12"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B8F26C4CEC7;
	Tue,  8 Oct 2024 12:50:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728391822;
	bh=+t9VqaikdCr0lV/0CyLFqJJ2gxixQwQluVIYPgKan4k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MZ1CyS12knsDgd6otEmLjM0IJv0PLhDf8vTQF/UWEsOkjLRDa6bnRmFqI1P+7B/qH
	 6XvKNQzeFrE9wGXEY7M7GfcRgIoFPQInLVQA4NyqoP8AAKs7FzsYquVSU114OjQ8jJ
	 ZN1YGeqsLZj74rnPI+fFGQwXNC5sTQCjiu136XYs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tom Chung <chiahsuan.chung@amd.com>,
	Rodrigo Siqueira <Rodrigo.Siqueira@amd.com>,
	Roman Li <roman.li@amd.com>,
	Alex Hung <alex.hung@amd.com>,
	Aurabindo Pillai <aurabindo.pillai@amd.com>,
	Harry Wentland <harry.wentland@amd.com>,
	Srinivasan Shanmugam <srinivasan.shanmugam@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 232/558] drm/amd/display: Add null check for afb in amdgpu_dm_plane_handle_cursor_update (v2)
Date: Tue,  8 Oct 2024 14:04:22 +0200
Message-ID: <20241008115711.472806351@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241008115702.214071228@linuxfoundation.org>
References: <20241008115702.214071228@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Srinivasan Shanmugam <srinivasan.shanmugam@amd.com>

[ Upstream commit cd9e9e0852d501f169aa3bb34e4b413d2eb48c37 ]

This commit adds a null check for the 'afb' variable in the
amdgpu_dm_plane_handle_cursor_update function. Previously, 'afb' was
assumed to be null, but was used later in the code without a null check.
This could potentially lead to a null pointer dereference.

Changes since v1:
- Moved the null check for 'afb' to the line where 'afb' is used. (Alex)

Fixes the below:
drivers/gpu/drm/amd/amdgpu/../display/amdgpu_dm/amdgpu_dm_plane.c:1298 amdgpu_dm_plane_handle_cursor_update() error: we previously assumed 'afb' could be null (see line 1252)

Cc: Tom Chung <chiahsuan.chung@amd.com>
Cc: Rodrigo Siqueira <Rodrigo.Siqueira@amd.com>
Cc: Roman Li <roman.li@amd.com>
Cc: Alex Hung <alex.hung@amd.com>
Cc: Aurabindo Pillai <aurabindo.pillai@amd.com>
Cc: Harry Wentland <harry.wentland@amd.com>
Co-developed-by: Alex Hung <alex.hung@amd.com>
Signed-off-by: Alex Hung <alex.hung@amd.com>
Signed-off-by: Srinivasan Shanmugam <srinivasan.shanmugam@amd.com>
Reviewed-by: Tom Chung <chiahsuan.chung@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_plane.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_plane.c b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_plane.c
index 5cb11cc2d0636..a573a66398984 100644
--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_plane.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_plane.c
@@ -1377,7 +1377,8 @@ void amdgpu_dm_plane_handle_cursor_update(struct drm_plane *plane,
 	    adev->dm.dc->caps.color.dpp.gamma_corr)
 		attributes.attribute_flags.bits.ENABLE_CURSOR_DEGAMMA = 1;
 
-	attributes.pitch = afb->base.pitches[0] / afb->base.format->cpp[0];
+	if (afb)
+		attributes.pitch = afb->base.pitches[0] / afb->base.format->cpp[0];
 
 	if (crtc_state->stream) {
 		mutex_lock(&adev->dm.dc_lock);
-- 
2.43.0



