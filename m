Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B448A281357;
	Wed, 23 Apr 2025 15:19:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745421594; cv=none; b=qP60YaqZDQWnoJyJOiAfClbfiqVEQthRKkxfLncbkKS6FWrOVW3ZZ10/u8ZJdnGeTwownZz1HwHyQAZYYG2VLTSrN4pFd8N4a19ii9n92ODZTs5q1QwVKbI64fdR0QyKx4R5Ij2YqexsjB+vwryfTxUyOPclrY/H/DDLDU2MNMI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745421594; c=relaxed/simple;
	bh=oj+7VVXXA5Ca/PKmp3l2NN5ESuQ7mUhy7wZIRX6yo40=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=A8U20v73UrQutXLbzXDiL8ysvq65fKxbhvvGn4ZHk5O4tCl1CWs2B1zmzKkuOu1SgR/gonUDmHQP7jMdSsL4w8zWK4cohrtfyxlbhKOcTGVKzZOzb1M4H+dfvINVyqAiuIgPmOASkrDjqTJEcJPSeXd8KfUl+FrHHkHW6VBNGqc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xVj1QPVY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xVj1QPVY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3F4F3C4CEE2;
	Wed, 23 Apr 2025 15:19:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745421594;
	bh=oj+7VVXXA5Ca/PKmp3l2NN5ESuQ7mUhy7wZIRX6yo40=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xVj1QPVYisy3p79DL1S+TXpFK/khy7fOJX5qaGOEnitHm0n9Ca4xWHpZ4OG5oBJFe
	 Jq8r2c+HasC92VxWDqMg0InnlF897B1aPnZp/oZG4fl1Q3w1evYAJjwKCI1cE6uBOD
	 0cIzPmeTDosK547s19E3qBLTdhiDFavSLMb4JgvE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sun peng Li <sunpeng.li@amd.com>,
	Tom Chung <chiahsuan.chung@amd.com>,
	Fangzhi Zuo <jerry.zuo@amd.com>,
	Daniel Wheeler <daniel.wheeler@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.14 209/241] drm/amd/display: Do not enable Replay and PSR while VRR is on in amdgpu_dm_commit_planes()
Date: Wed, 23 Apr 2025 16:44:33 +0200
Message-ID: <20250423142629.074643999@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250423142620.525425242@linuxfoundation.org>
References: <20250423142620.525425242@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tom Chung <chiahsuan.chung@amd.com>

commit 69a46ce1f15b4391c128d581f6936750f9bfa052 upstream.

[Why]
Replay and PSR will cause some video corruption while VRR is enabled.

[How]
Do not enable the Replay and PSR while VRR is active in
amdgpu_dm_enable_self_refresh().

Fixes: 67edb81d6e9a ("drm/amd/display: Disable replay and psr while VRR is enabled")
Reviewed-by: Sun peng Li <sunpeng.li@amd.com>
Signed-off-by: Tom Chung <chiahsuan.chung@amd.com>
Signed-off-by: Fangzhi Zuo <jerry.zuo@amd.com>
Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_crtc.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_crtc.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_crtc.c
@@ -113,6 +113,7 @@ bool amdgpu_dm_crtc_vrr_active(const str
  *
  * Panel Replay and PSR SU
  * - Enable when:
+ *      - VRR is disabled
  *      - vblank counter is disabled
  *      - entry is allowed: usermode demonstrates an adequate number of fast
  *        commits)
@@ -131,19 +132,20 @@ static void amdgpu_dm_crtc_set_panel_sr_
 	bool is_sr_active = (link->replay_settings.replay_allow_active ||
 				 link->psr_settings.psr_allow_active);
 	bool is_crc_window_active = false;
+	bool vrr_active = amdgpu_dm_crtc_vrr_active_irq(vblank_work->acrtc);
 
 #ifdef CONFIG_DRM_AMD_SECURE_DISPLAY
 	is_crc_window_active =
 		amdgpu_dm_crc_window_is_activated(&vblank_work->acrtc->base);
 #endif
 
-	if (link->replay_settings.replay_feature_enabled &&
+	if (link->replay_settings.replay_feature_enabled && !vrr_active &&
 		allow_sr_entry && !is_sr_active && !is_crc_window_active) {
 		amdgpu_dm_replay_enable(vblank_work->stream, true);
 	} else if (vblank_enabled) {
 		if (link->psr_settings.psr_version < DC_PSR_VERSION_SU_1 && is_sr_active)
 			amdgpu_dm_psr_disable(vblank_work->stream, false);
-	} else if (link->psr_settings.psr_feature_enabled &&
+	} else if (link->psr_settings.psr_feature_enabled && !vrr_active &&
 		allow_sr_entry && !is_sr_active && !is_crc_window_active) {
 
 		struct amdgpu_dm_connector *aconn =


