Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3BE851DED55;
	Tue,  8 Oct 2024 12:20:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728390051; cv=none; b=GZEUzptpHvZPl55EIGLtUJD6QssqcU+G8UAw1evlIhvHO3V6F0sCOb/Xb6791xujHbq0EkP8T+X+hhjOFPw65n98XwfMa7wfVG1EUp2pDaa2NGe509dfkkIx8PHlCRsYaBfgyF3S2bHFvDCBUfB0bJO/ufxo5fKcj+bxiJJULSU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728390051; c=relaxed/simple;
	bh=Ws782mtOJxQCEAMRMTr42LUt4DNAWNbS1Y6c/GFduCk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mfp6F4FUSeotTHlyom+JokH8cQwgAP5nqr1yVZ+nVRf+NUGb9R+zajGNpKK3Z7Lq6hs9Jk/Yyy0LPsLeATjY/kiOfTr42GtM1S6N67aq7ukjci8TRjugXh++SE1XNGp/zNj5JeyQg9+nlnkj9Fb2uZYxYVJwEC94h1TvINYxIzU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uj8aqc0G; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uj8aqc0G"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B8EFFC4CEC7;
	Tue,  8 Oct 2024 12:20:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728390051;
	bh=Ws782mtOJxQCEAMRMTr42LUt4DNAWNbS1Y6c/GFduCk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uj8aqc0Ge6nMwYDwY4cAazyu9XkcogfR0gCnqR+O59SrNq112B5mAsY/IVzDsx409
	 UVxbPbS5ldED2XbwXGzbzpllxrt7EM1g/FWJV8Pin9lgxxMd+DHHnZ5eJUF11H3mFw
	 YRIPnqylVwXAXK7+3nfCNgYc8RQ+ikkWNquZxTrc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rodrigo Siqueira <rodrigo.siqueira@amd.com>,
	Jerry Zuo <jerry.zuo@amd.com>,
	Alex Hung <alex.hung@amd.com>,
	Daniel Wheeler <daniel.wheeler@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 175/482] drm/amd/display: Check null pointers before using them
Date: Tue,  8 Oct 2024 14:03:58 +0200
Message-ID: <20241008115655.192606061@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241008115648.280954295@linuxfoundation.org>
References: <20241008115648.280954295@linuxfoundation.org>
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

From: Alex Hung <alex.hung@amd.com>

[ Upstream commit 1ff12bcd7deaeed25efb5120433c6a45dd5504a8 ]

[WHAT & HOW]
These pointers are null checked previously in the same function,
indicating they might be null as reported by Coverity. As a result,
they need to be checked when used again.

This fixes 3 FORWARD_NULL issue reported by Coverity.

Reviewed-by: Rodrigo Siqueira <rodrigo.siqueira@amd.com>
Signed-off-by: Jerry Zuo <jerry.zuo@amd.com>
Signed-off-by: Alex Hung <alex.hung@amd.com>
Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c | 12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff --git a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
index 3541d154cc8d0..9a578b1df141f 100644
--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
@@ -6951,6 +6951,9 @@ create_validate_stream_for_sink(struct amdgpu_dm_connector *aconnector,
 	int requested_bpc = drm_state ? drm_state->max_requested_bpc : 8;
 	enum dc_status dc_result = DC_OK;
 
+	if (!dm_state)
+		return NULL;
+
 	do {
 		stream = create_stream_for_sink(connector, drm_mode,
 						dm_state, old_stream,
@@ -8963,7 +8966,7 @@ static void amdgpu_dm_commit_streams(struct drm_atomic_state *state,
 		if (acrtc)
 			old_crtc_state = drm_atomic_get_old_crtc_state(state, &acrtc->base);
 
-		if (!acrtc->wb_enabled)
+		if (!acrtc || !acrtc->wb_enabled)
 			continue;
 
 		dm_old_crtc_state = to_dm_crtc_state(old_crtc_state);
@@ -9362,9 +9365,10 @@ static void amdgpu_dm_atomic_commit_tail(struct drm_atomic_state *state)
 
 			DRM_INFO("[HDCP_DM] hdcp_update_display enable_encryption = %x\n", enable_encryption);
 
-			hdcp_update_display(
-				adev->dm.hdcp_workqueue, aconnector->dc_link->link_index, aconnector,
-				new_con_state->hdcp_content_type, enable_encryption);
+			if (aconnector->dc_link)
+				hdcp_update_display(
+					adev->dm.hdcp_workqueue, aconnector->dc_link->link_index, aconnector,
+					new_con_state->hdcp_content_type, enable_encryption);
 		}
 	}
 
-- 
2.43.0



