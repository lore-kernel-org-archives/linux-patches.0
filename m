Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 893214FD27C;
	Wed, 30 Sep 2026 19:39:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790797146; cv=none; b=eaqk8sYmy4MML/xHyXSDqVsO85vWEwahrP4sWBdksWhzdXp8edJcAqumi0R/2/Bu4GwEQyZFwDsY9LuEyGC+Aor5/vOiYI5bvLbQDHwp7OZkK6w/LworjBfrvRkwVxof2TcN5of4p1cbbMWq4C8PycQQYZxypOGjoXb2tpcdI+M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790797146; c=relaxed/simple;
	bh=JAmjbBlVcy8Eq/0ofqRmzgPfY64zKIJMygqDYVzbk5M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tPVswUI1B/Vko8X96nc/3lhzGnGDjQZKHIGpKwMlOYAX8Q+pC+Lz/E5PoRtEqRwny+mcYnQqMxOfrlRxLxl3VWtdMJRDeyb5rf4GMC0p4k1YcuHbCa1fKi6hO5xIRHAr3azFpKzT5Ro0oAGKcUbMHA8k9IgLdgLsmnRwAWnSZmE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HoDt5AJQ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HoDt5AJQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D8B521F000FF;
	Wed, 30 Sep 2026 19:39:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790797145;
	bh=YIj+3bRm2Lj6LnMbiW0SwGuGYGdWvdcH4Hc/fVTAyHo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=HoDt5AJQ2JZJnec374yDqbbo50KqzQCzoUiUwGA9a37nUv+bBchSGf2fMwsTMZvkp
	 h1qs8LyjM+030WH3Haz/lCbccYFv+9YDWYPramLRvM5TDVlzzQXiZ8ExGaqVE2RLVU
	 16m11rbmmnVhXUpW5lVKlzWVIzcJXGpLtdGRLTaE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rodrigo Siqueira <rodrigo.siqueira@amd.com>,
	Jerry Zuo <jerry.zuo@amd.com>,
	Alex Hung <alex.hung@amd.com>,
	Daniel Wheeler <daniel.wheeler@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Artem Dinaburg <artem@trailofbits.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1163/1193] drm/amd/display: Check null pointers before using them
Date: Wed, 30 Sep 2026 17:30:47 +0200
Message-ID: <20260930152500.083395216@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152434.301151190@linuxfoundation.org>
References: <20260930152434.301151190@linuxfoundation.org>
User-Agent: quilt/0.69
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

From: Alex Hung <alex.hung@amd.com>

[ Upstream commit 1ff12bcd7deaeed25efb5120433c6a45dd5504a8 ]

[WHAT & HOW]
These pointers are null checked previously in the same function,
indicating they might be null as reported by Coverity. As a result,
they need to be checked when used again.

This fixes 3 FORWARD_NULL issue reported by Coverity.

[ Backport to 6.6.y: kept the applicable dm_state and dc_link guards; the
  vulnerable acrtc loop shape is absent. ]

Reviewed-by: Rodrigo Siqueira <rodrigo.siqueira@amd.com>
Signed-off-by: Jerry Zuo <jerry.zuo@amd.com>
Signed-off-by: Alex Hung <alex.hung@amd.com>
Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Assisted-by: LLM
Signed-off-by: Artem Dinaburg <artem@trailofbits.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c | 13 ++++++++++---
 1 file changed, 10 insertions(+), 3 deletions(-)

diff --git a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
index 54433b56d4210..4b03bb4b913f8 100644
--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
@@ -6630,6 +6630,9 @@ create_validate_stream_for_sink(struct amdgpu_dm_connector *aconnector,
 	int requested_bpc = drm_state ? drm_state->max_requested_bpc : 8;
 	enum dc_status dc_result = DC_OK;
 
+	if (!dm_state)
+		return NULL;
+
 	do {
 		stream = create_stream_for_sink(aconnector, drm_mode,
 						dm_state, old_stream,
@@ -8859,9 +8862,13 @@ static void amdgpu_dm_atomic_commit_tail(struct drm_atomic_state *state)
 
 			DRM_INFO("[HDCP_DM] hdcp_update_display enable_encryption = %x\n", enable_encryption);
 
-			hdcp_update_display(
-				adev->dm.hdcp_workqueue, aconnector->dc_link->link_index, aconnector,
-				new_con_state->hdcp_content_type, enable_encryption);
+			if (aconnector->dc_link)
+				hdcp_update_display(
+					adev->dm.hdcp_workqueue,
+					aconnector->dc_link->link_index,
+					aconnector,
+					new_con_state->hdcp_content_type,
+					enable_encryption);
 		}
 	}
 
-- 
2.53.0



