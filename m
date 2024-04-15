Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E3A96762E0;
	Mon, 15 Apr 2024 14:31:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713191516; cv=none; b=pA4cFilftXJe+BLY1/dCAiU70uSm7HC+kzTUFgPPVVYiuGilfUD8rE8mmCg4u6Umf8aAmvXJwwruq2Ods3cb5uXkxeetydb4PBpwdK+/+mnyHtgK5PJReAoo8XdqYbdknGdTQ5WFzkrRh1tlH8bOx2CcjyK9O+0KeFu9kr98V8w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713191516; c=relaxed/simple;
	bh=ZwhNbdoi4oyZ88BErf/My+A6gHE2i4+RRmGUAvgsfTM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IdwbEIo0hW+FCL+L0epjyBfY7XnqsUfB5+ckZ79tP/YcdUFgX1Dc1pHfncei0BPJ83kvpdwjHVd9nMNYeStVmEvvk29jZC3PzHgkrlPXXdqWI0/pdGnA9p8YCO8DKEQh6VSTBazXjCu8f9P2/ved/Suw6p3pNwpI537lJopxNl4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LW1N+bqM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LW1N+bqM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6C865C113CC;
	Mon, 15 Apr 2024 14:31:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1713191515;
	bh=ZwhNbdoi4oyZ88BErf/My+A6gHE2i4+RRmGUAvgsfTM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LW1N+bqM6VQqDqcFuPlGZ3QCLwtqmfJLkIKLELp4h0WGsw/gBqqS2QVFxax7bRAOa
	 ddsA5JUVjO7ykYGh1qOfw396aRV7Bv2nNBTqR6xVFeWTyFEuZMlO5Eabt3Y9BFQQlx
	 BeEMh9gy4d9MIwWjBXzpLLNNjlTOdoL0+l0pdEr8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Joshua Ashton <joshua@froggi.es>,
	Xaver Hugl <xaver.hugl@gmail.com>,
	Melissa Wen <mwen@igalia.com>,
	Agustin Gutierrez <Agustin.Gutierrez@amd.com>,
	Agustin Gutierrez <agustin.gutierrez@amd.com>,
	Hamza Mahfooz <hamza.mahfooz@amd.com>,
	Harry Wentland <harry.wentland@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.8 167/172] drm/amd/display: Program VSC SDP colorimetry for all DP sinks >= 1.4
Date: Mon, 15 Apr 2024 16:21:06 +0200
Message-ID: <20240415142005.421236674@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240415141959.976094777@linuxfoundation.org>
References: <20240415141959.976094777@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Harry Wentland <harry.wentland@amd.com>

commit 9e61ef8d219877202d4ee51d0d2ad9072c99a262 upstream.

In order for display colorimetry to work correctly on DP displays
we need to send the VSC SDP packet. We should only do so for
panels with DPCD revision greater or equal to 1.4 as older
receivers might have problems with it.

Cc: stable@vger.kernel.org
Cc: Joshua Ashton <joshua@froggi.es>
Cc: Xaver Hugl <xaver.hugl@gmail.com>
Cc: Melissa Wen <mwen@igalia.com>
Cc: Agustin Gutierrez <Agustin.Gutierrez@amd.com>
Reviewed-by: Agustin Gutierrez <agustin.gutierrez@amd.com>
Acked-by: Hamza Mahfooz <hamza.mahfooz@amd.com>
Signed-off-by: Harry Wentland <harry.wentland@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
@@ -6257,7 +6257,9 @@ create_stream_for_sink(struct drm_connec
 	if (stream->signal == SIGNAL_TYPE_HDMI_TYPE_A)
 		mod_build_hf_vsif_infopacket(stream, &stream->vsp_infopacket);
 
-	if (stream->link->psr_settings.psr_feature_enabled || stream->link->replay_settings.replay_feature_enabled) {
+	if (stream->signal == SIGNAL_TYPE_DISPLAY_PORT ||
+	    stream->signal == SIGNAL_TYPE_DISPLAY_PORT_MST ||
+	    stream->signal == SIGNAL_TYPE_EDP) {
 		//
 		// should decide stream support vsc sdp colorimetry capability
 		// before building vsc info packet
@@ -6267,7 +6269,8 @@ create_stream_for_sink(struct drm_connec
 			stream->use_vsc_sdp_for_colorimetry =
 				aconnector->dc_sink->is_vsc_sdp_colorimetry_supported;
 		} else {
-			if (stream->link->dpcd_caps.dprx_feature.bits.VSC_SDP_COLORIMETRY_SUPPORTED)
+			if (stream->link->dpcd_caps.dpcd_rev.raw >= 0x14 &&
+			    stream->link->dpcd_caps.dprx_feature.bits.VSC_SDP_COLORIMETRY_SUPPORTED)
 				stream->use_vsc_sdp_for_colorimetry = true;
 		}
 		if (stream->out_transfer_func->tf == TRANSFER_FUNCTION_GAMMA22)


