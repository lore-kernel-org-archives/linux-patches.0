Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C78CF1EB37;
	Mon,  1 Apr 2024 16:30:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711989019; cv=none; b=YlHtb64HGBs4K0LAhpQysnfpJ8Ox1zTPSoWUda4Ih7z3r1QAElpNeAqyhZKGXGi7GNaDgiRM1wREPRIJU7xsXlnYFMqmAQ16iOAc3MGJJUqzDSdxe8R8iAm7qpGd9JuUsDalDw6uDo/DfT6oLbAijvD1g1QpvFsuoKAWrAkMDQE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711989019; c=relaxed/simple;
	bh=GuH1vpSXgqeQu6XFn1a2Z/5Ix/8+3L4GSZ7HMUsrFKw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QyuHuIsI/OGioHx7XEX1ynnN6ru0JxiNC8OsB+1QDmOiLv9KuuNAznIEoA2L08NIlazhXVTSHRMrsfW7cZ0S8CoCUTtyNFVZiPscIitwRDbg4TG9PSvWj27rqArqpJYMuOJgmjVNCxnBhJcStVfqVLwL1cxHqnjsJDzGE1I0ihg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PEevseiX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PEevseiX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 50055C433F1;
	Mon,  1 Apr 2024 16:30:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1711989019;
	bh=GuH1vpSXgqeQu6XFn1a2Z/5Ix/8+3L4GSZ7HMUsrFKw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PEevseiXyHxu/G9twC5HzKQQpW25GCDpySnVTLvi5w8T4ytRxWQLz9R9FDFbW8BK8
	 gEqFrvY5Ae6OlxZ3edgYg1tCzRqatUjTjfGP/cqZPvjhCFYWIddCQHyE0MTEwdH93S
	 ZjOrr1Rpf65G3Pdiiu+Y47BnDqJphuooerKDl3ZM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Harry Wentland <harry.wentland@amd.com>,
	Rodrigo Siqueira <Rodrigo.Siqueira@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.7 350/432] Revert "drm/amd/display: Fix sending VSC (+ colorimetry) packets for DP/eDP displays without PSR"
Date: Mon,  1 Apr 2024 17:45:37 +0200
Message-ID: <20240401152603.683764985@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240401152553.125349965@linuxfoundation.org>
References: <20240401152553.125349965@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Harry Wentland <harry.wentland@amd.com>

commit 78aca9ee5e012e130dbfbd7191bc2302b0cf3b37 upstream.

This causes flicker on a bunch of eDP panels. The info_packet code
also caused regressions on other OSes that we haven't' seen on Linux
yet, but that is likely due to the fact that we haven't had a chance
to test those environments on Linux.

We'll need to revisit this.

This reverts commit 202260f64519e591b5cd99626e441b6559f571a3.

Closes: https://gitlab.freedesktop.org/drm/amd/-/issues/3207
Closes: https://gitlab.freedesktop.org/drm/amd/-/issues/3151
Signed-off-by: Harry Wentland <harry.wentland@amd.com>
Reviewed-by: Rodrigo Siqueira <Rodrigo.Siqueira@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c             |    8 ++----
 drivers/gpu/drm/amd/display/modules/info_packet/info_packet.c |   13 +++-------
 2 files changed, 8 insertions(+), 13 deletions(-)

--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
@@ -6163,9 +6163,8 @@ create_stream_for_sink(struct drm_connec
 
 	if (stream->signal == SIGNAL_TYPE_HDMI_TYPE_A)
 		mod_build_hf_vsif_infopacket(stream, &stream->vsp_infopacket);
-	else if (stream->signal == SIGNAL_TYPE_DISPLAY_PORT ||
-			 stream->signal == SIGNAL_TYPE_DISPLAY_PORT_MST ||
-			 stream->signal == SIGNAL_TYPE_EDP) {
+
+	if (stream->link->psr_settings.psr_feature_enabled || stream->link->replay_settings.replay_feature_enabled) {
 		//
 		// should decide stream support vsc sdp colorimetry capability
 		// before building vsc info packet
@@ -6181,9 +6180,8 @@ create_stream_for_sink(struct drm_connec
 		if (stream->out_transfer_func->tf == TRANSFER_FUNCTION_GAMMA22)
 			tf = TRANSFER_FUNC_GAMMA_22;
 		mod_build_vsc_infopacket(stream, &stream->vsc_infopacket, stream->output_color_space, tf);
+		aconnector->psr_skip_count = AMDGPU_DM_PSR_ENTRY_DELAY;
 
-		if (stream->link->psr_settings.psr_feature_enabled)
-			aconnector->psr_skip_count = AMDGPU_DM_PSR_ENTRY_DELAY;
 	}
 finish:
 	dc_sink_release(sink);
--- a/drivers/gpu/drm/amd/display/modules/info_packet/info_packet.c
+++ b/drivers/gpu/drm/amd/display/modules/info_packet/info_packet.c
@@ -147,15 +147,12 @@ void mod_build_vsc_infopacket(const stru
 	}
 
 	/* VSC packet set to 4 for PSR-SU, or 2 for PSR1 */
-	if (stream->link->psr_settings.psr_feature_enabled) {
-		if (stream->link->psr_settings.psr_version == DC_PSR_VERSION_SU_1)
-			vsc_packet_revision = vsc_packet_rev4;
-		else if (stream->link->psr_settings.psr_version == DC_PSR_VERSION_1)
-			vsc_packet_revision = vsc_packet_rev2;
-	}
-
-	if (stream->link->replay_settings.config.replay_supported)
+	if (stream->link->psr_settings.psr_version == DC_PSR_VERSION_SU_1)
+		vsc_packet_revision = vsc_packet_rev4;
+	else if (stream->link->replay_settings.config.replay_supported)
 		vsc_packet_revision = vsc_packet_rev4;
+	else if (stream->link->psr_settings.psr_version == DC_PSR_VERSION_1)
+		vsc_packet_revision = vsc_packet_rev2;
 
 	/* Update to revision 5 for extended colorimetry support */
 	if (stream->use_vsc_sdp_for_colorimetry)


