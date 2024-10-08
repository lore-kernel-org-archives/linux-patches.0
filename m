Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D8F61C9B61;
	Tue,  8 Oct 2024 12:50:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728391812; cv=none; b=bBXlXgy8GvuX02mMzzVNDQei2Firw7kQ6aFLRY6bcUEiEKVr2P6YbtABr/mpb89dtdFfPUO5vm5UVXbDausOxoZzq4ZIXsO7PlMSHcXj/NLAcpJWFwrtEVEqkmpN9S8a2JadxTshHHLOtr9Vbm9PecpWN6FZszesDJF/lc4np1o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728391812; c=relaxed/simple;
	bh=pPp/nBSYG2+9fnUPECftxyPv1BozNMTUsCeBXNtOMjs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gEPKTEOFUg1Y0iC1MRAY5aD6uw7UlVlumqgEPf5EecZd3xuupnJD6T3e6oEg35qEMk2SbYCwaMC1dnLvQwkFcgJZ+6UVIaLL1YnjSBHWCUNG/pp/9nGUlCeYh3Yw9UNQrJx8VPqqrs3pBMYMWb6owgN6UAd+NKdmR49vfkpICAw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=T2NWhkHk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="T2NWhkHk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7E0C7C4CEC7;
	Tue,  8 Oct 2024 12:50:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728391812;
	bh=pPp/nBSYG2+9fnUPECftxyPv1BozNMTUsCeBXNtOMjs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=T2NWhkHkLZhxAYrtiaOEQLz00q1yHC49+LByRBYCbSjsJxWcZl6aI7kzVwoKFiPxd
	 M6XbURPKVqKKxkDDqNyrcPMNveQ1vdhhWiWsP0u8lBA+9LFJXGH6qQT0dWCJzg4Egw
	 tiNPANeVTbbGfXnEYPVlg2SeBGfBaSX7RM58BuNw=
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
Subject: [PATCH 6.11 229/558] drm/amd/display: Add null check for afb in amdgpu_dm_update_cursor (v2)
Date: Tue,  8 Oct 2024 14:04:19 +0200
Message-ID: <20241008115711.353081946@linuxfoundation.org>
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

[ Upstream commit 0fe20258b4989b9112b5e9470df33a0939403fd4 ]

This commit adds a null check for the 'afb' variable in the
amdgpu_dm_update_cursor function. Previously, 'afb' was assumed to be
null at line 8388, but was used later in the code without a null check.
This could potentially lead to a null pointer dereference.

Changes since v1:
- Moved the null check for 'afb' to the line where 'afb' is used. (Alex)

Fixes the below:
drivers/gpu/drm/amd/amdgpu/../display/amdgpu_dm/amdgpu_dm.c:8433 amdgpu_dm_update_cursor()
	error: we previously assumed 'afb' could be null (see line 8388)

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
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
index 188d10820654a..579022bb198d1 100644
--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
@@ -8795,7 +8795,8 @@ static void amdgpu_dm_update_cursor(struct drm_plane *plane,
 	    adev->dm.dc->caps.color.dpp.gamma_corr)
 		attributes.attribute_flags.bits.ENABLE_CURSOR_DEGAMMA = 1;
 
-	attributes.pitch = afb->base.pitches[0] / afb->base.format->cpp[0];
+	if (afb)
+		attributes.pitch = afb->base.pitches[0] / afb->base.format->cpp[0];
 
 	if (crtc_state->stream) {
 		if (!dc_stream_set_cursor_attributes(crtc_state->stream,
-- 
2.43.0



