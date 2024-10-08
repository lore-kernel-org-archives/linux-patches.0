Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F296F1DE88F;
	Tue,  8 Oct 2024 12:35:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728390947; cv=none; b=huOIhx/g2Gy/tXwHzPy+FEGoPtGd2X5zVL3GXIQl7vMQJdAVTkvd88mCevZ1PtNEwBJSnWqsYbkWCQpekZgmsbNq9/Ck5K5/Sl6kDtswG0NwarvtXFsndZB3HCaogyaNuoS8ye4ut18jfFqdQBiuC0jjfg29Zn39kg1+ae4uoKI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728390947; c=relaxed/simple;
	bh=L+BSE3yi83u5GMpOSH8S6YMEptx4jjVa6N9N+o7ryLY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fNqQjiMCTbrsEz0frASkDclznz0S44obIQMuKML6bqjxxJEgpvuvGqL/ODL0Zv0NA08EOCgJDJd9G5BmsJfuzZq+YrZWnXWHplCNK0HLoxRrwANAB84/Ps5506NMUXpC/+62HbcrCKOWVla+yqa3Bep5qaw4Yy3IBYjFlqEWeJM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=O8BmQ04e; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="O8BmQ04e"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 75AE1C4CECD;
	Tue,  8 Oct 2024 12:35:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728390946;
	bh=L+BSE3yi83u5GMpOSH8S6YMEptx4jjVa6N9N+o7ryLY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=O8BmQ04e+Hsdc8XjOo0H5lObAjZz700nhJpba5d7Ztio1jBVlrihl+Cz7pJTTVM1H
	 poX/uf7ygUlc6Y5gMlCrzmfbI4Z0f08S9mRS4t+5FLjPUtWbTBT+7dNX+/L2iCFkXJ
	 jaATUPO/y2X6FX5dzq4EKQtQYy4sZddbeaw8E7ac=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mario Limonciello <mario.limonciello@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Rodrigo Siqueira <rodrigo.siqueira@amd.com>,
	Alex Hung <alex.hung@amd.com>,
	Aurabindo Pillai <aurabindo.pillai@amd.com>,
	Daniel Wheeler <daniel.wheeler@amd.com>
Subject: [PATCH 6.10 443/482] drm/amd/display: Add HDR workaround for specific eDP
Date: Tue,  8 Oct 2024 14:08:26 +0200
Message-ID: <20241008115705.957989786@linuxfoundation.org>
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

commit 05af800704ee7187d9edd461ec90f3679b1c4aba upstream.

[WHY & HOW]
Some eDP panels suffer from flicking when HDR is enabled in KDE. This
quirk works around it by skipping VSC that is incompatible with eDP
panels.

Link: https://gitlab.freedesktop.org/drm/amd/-/issues/3151
Cc: Mario Limonciello <mario.limonciello@amd.com>
Cc: Alex Deucher <alexander.deucher@amd.com>
Reviewed-by: Rodrigo Siqueira <rodrigo.siqueira@amd.com>
Signed-off-by: Alex Hung <alex.hung@amd.com>
Signed-off-by: Aurabindo Pillai <aurabindo.pillai@amd.com>
Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit 4d4257280d7957727998ef90ccc7b69c7cca8376)
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c         |   11 ++++++++++-
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_helpers.c |    4 ++++
 drivers/gpu/drm/amd/display/dc/dc_types.h                 |    1 +
 3 files changed, 15 insertions(+), 1 deletion(-)

--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
@@ -6389,12 +6389,21 @@ create_stream_for_sink(struct drm_connec
 	if (stream->signal == SIGNAL_TYPE_DISPLAY_PORT ||
 	    stream->signal == SIGNAL_TYPE_DISPLAY_PORT_MST ||
 	    stream->signal == SIGNAL_TYPE_EDP) {
+		const struct dc_edid_caps *edid_caps;
+		unsigned int disable_colorimetry = 0;
+
+		if (aconnector->dc_sink) {
+			edid_caps = &aconnector->dc_sink->edid_caps;
+			disable_colorimetry = edid_caps->panel_patch.disable_colorimetry;
+		}
+
 		//
 		// should decide stream support vsc sdp colorimetry capability
 		// before building vsc info packet
 		//
 		stream->use_vsc_sdp_for_colorimetry = stream->link->dpcd_caps.dpcd_rev.raw >= 0x14 &&
-						      stream->link->dpcd_caps.dprx_feature.bits.VSC_SDP_COLORIMETRY_SUPPORTED;
+						      stream->link->dpcd_caps.dprx_feature.bits.VSC_SDP_COLORIMETRY_SUPPORTED &&
+						      !disable_colorimetry;
 
 		if (stream->out_transfer_func.tf == TRANSFER_FUNCTION_GAMMA22)
 			tf = TRANSFER_FUNC_GAMMA_22;
--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_helpers.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_helpers.c
@@ -72,6 +72,10 @@ static void apply_edid_quirks(struct edi
 		DRM_DEBUG_DRIVER("Clearing DPCD 0x317 on monitor with panel id %X\n", panel_id);
 		edid_caps->panel_patch.remove_sink_ext_caps = true;
 		break;
+	case drm_edid_encode_panel_id('S', 'D', 'C', 0x4154):
+		DRM_DEBUG_DRIVER("Disabling VSC on monitor with panel id %X\n", panel_id);
+		edid_caps->panel_patch.disable_colorimetry = true;
+		break;
 	default:
 		return;
 	}
--- a/drivers/gpu/drm/amd/display/dc/dc_types.h
+++ b/drivers/gpu/drm/amd/display/dc/dc_types.h
@@ -178,6 +178,7 @@ struct dc_panel_patch {
 	unsigned int skip_avmute;
 	unsigned int mst_start_top_delay;
 	unsigned int remove_sink_ext_caps;
+	unsigned int disable_colorimetry;
 };
 
 struct dc_edid_caps {


