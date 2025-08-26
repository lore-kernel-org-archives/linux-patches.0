Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C50BC31CA74;
	Tue, 26 Aug 2025 11:43:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756208625; cv=none; b=T/FUE/8mLkxUfKX4TRw1lohCjsut8oskx1tZnW6ASodh0mD1EKz0y8o5lhG8XeecPJ8pdYtj1U/0raXQRsh/fM9ojx0tvBl9envB2Tf5/CVzJK+no/aL0ECSFH906vzIR4UEyNTu3jJiVymuOXeZjMjo1HFqh61XzIpLQGb9Gh4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756208625; c=relaxed/simple;
	bh=PU4Qc6TF96wfmcouoa/a9gEIhdJYIQLvsVz0PTttNUo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lqYaM26IPxWIMiS3eZA+8v7HVacaM1YcwRb+TA2hk01NbX0m6q+5gTHPOAJIguksc/tMlIXCjsoaiEZtiM2wlW9yQlDl56XE8UDo74t1YAVNaJNuUV9QhBs8E4vGCxvfomgf6043ySwaeurl1V1Bs9NHwQRqMuJrciRyIFL9t9s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QMKe0ben; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QMKe0ben"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 110CEC4CEF1;
	Tue, 26 Aug 2025 11:43:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756208625;
	bh=PU4Qc6TF96wfmcouoa/a9gEIhdJYIQLvsVz0PTttNUo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QMKe0ben1mwFZFQmrN4u9i8TGBqEQs1CaFD0ketwrIrJLMEWObklvJyykqwZJj6Sf
	 hd0iTivwzFpQBT9LF35vz5MLnMHUJPmCiIJmePyBHUoqTMsv3SdPFspnhuvRqk4uLL
	 eNHzZQtrem7BF7d7Nh5GWsydwkkfDn6X4M1cuJnQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mario Limonciello <mario.limonciello@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	"Sun peng (Leo) Li" <sunpeng.li@amd.com>,
	Tom Chung <chiahsuan.chung@amd.com>,
	Alex Hung <alex.hung@amd.com>,
	Dan Wheeler <daniel.wheeler@amd.com>
Subject: [PATCH 6.12 184/322] drm/amd/display: Fix Xorg desktop unresponsive on Replay panel
Date: Tue, 26 Aug 2025 13:09:59 +0200
Message-ID: <20250826110920.409912079@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110915.169062587@linuxfoundation.org>
References: <20250826110915.169062587@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tom Chung <chiahsuan.chung@amd.com>

commit 66af73a1c319336694a8610fe4c2943f7b33066c upstream.

[WHY & HOW]
IPS & self-fresh feature can cause vblank counter resets between
vblank disable and enable.
It may cause system stuck due to wait the vblank counter.

Call the drm_crtc_vblank_restore() during vblank enable to estimate
missed vblanks by using timestamps and update the vblank counter in
DRM.

It can make the vblank counter increase smoothly and resolve this issue.

Cc: Mario Limonciello <mario.limonciello@amd.com>
Cc: Alex Deucher <alexander.deucher@amd.com>
Reviewed-by: Sun peng (Leo) Li <sunpeng.li@amd.com>
Signed-off-by: Tom Chung <chiahsuan.chung@amd.com>
Signed-off-by: Alex Hung <alex.hung@amd.com>
Tested-by: Dan Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit 34d66bc7ff10e146a4cec76cf286979740a10954)
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_crtc.c |   19 +++++++++++++++++
 1 file changed, 19 insertions(+)

--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_crtc.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_crtc.c
@@ -302,6 +302,25 @@ static inline int amdgpu_dm_crtc_set_vbl
 	irq_type = amdgpu_display_crtc_idx_to_irq_type(adev, acrtc->crtc_id);
 
 	if (enable) {
+		struct dc *dc = adev->dm.dc;
+		struct drm_vblank_crtc *vblank = drm_crtc_vblank_crtc(crtc);
+		struct psr_settings *psr = &acrtc_state->stream->link->psr_settings;
+		struct replay_settings *pr = &acrtc_state->stream->link->replay_settings;
+		bool sr_supported = (psr->psr_version != DC_PSR_VERSION_UNSUPPORTED) ||
+								pr->config.replay_supported;
+
+		/*
+		 * IPS & self-refresh feature can cause vblank counter resets between
+		 * vblank disable and enable.
+		 * It may cause system stuck due to waiting for the vblank counter.
+		 * Call this function to estimate missed vblanks by using timestamps and
+		 * update the vblank counter in DRM.
+		 */
+		if (dc->caps.ips_support &&
+			dc->config.disable_ips != DMUB_IPS_DISABLE_ALL &&
+			sr_supported && vblank->config.disable_immediate)
+			drm_crtc_vblank_restore(crtc);
+
 		/* vblank irq on -> Only need vupdate irq in vrr mode */
 		if (amdgpu_dm_crtc_vrr_active(acrtc_state))
 			rc = amdgpu_dm_crtc_set_vupdate_irq(crtc, true);


