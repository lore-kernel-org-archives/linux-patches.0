Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 784941F03DE;
	Wed, 25 Feb 2026 01:31:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771983081; cv=none; b=W+pT/JEfhcdMJOerDTbLOKQqKs/CBo8f2vdDJraCLEFnrtW8frYXiEGM6vqMWUC5Z2fdHVUIEL8DteAO5Ow7EyH0oiPdpTYcJdLnCHK8D+XFEZwdYrpJz1GXuN+DOC19iPlunYeNk0Kyb1b0l8RzY/Nuc1106A9Uj6OpAfzqDWg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771983081; c=relaxed/simple;
	bh=ychzSSXSQZ4foBSuIY+7VFoB/i8xIR0w87AfCfm3/aU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uo8lBzmbZ/bHBKMEFfWpO4bGHcU2F1tOWFfi1rgBGNk0f1dRv01ymXZ/fJ7HyvCCsFaHFk8+QN0YvzThTqOdTPZgQZV9ZYXhlQOmWOdpIk+DIIriiJiaU+dH3udRFZAuHJ3HzlkG5IrNNPYbQ9y9JiRHk1mtvXMAMai99irmbwo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xuzDEDHc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xuzDEDHc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 425D1C116D0;
	Wed, 25 Feb 2026 01:31:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1771983081;
	bh=ychzSSXSQZ4foBSuIY+7VFoB/i8xIR0w87AfCfm3/aU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xuzDEDHcY3Y3V6jusXuOjQY6xZ/P3BZmnHwYOlpZFys3WuS4tNpSwCANjpe3eYPjw
	 byRs9Xzal8sL/VxUNPDcIoDQz8XF64JBdWEAEPZwyDt1XI1qcI47DVOcXks84uZ5ng
	 uDz2lzq1TE5KbnprUikbjMocU6DOO4HRLYStW+wU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ivan Lipski <ivan.lipski@amd.com>,
	Harry Wentland <harry.wentland@amd.com>,
	Dan Wheeler <daniel.wheeler@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 242/781] drm/amd/display: Remove unused encoder types
Date: Tue, 24 Feb 2026 17:15:51 -0800
Message-ID: <20260225012405.642819596@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260225012359.695468795@linuxfoundation.org>
References: <20260225012359.695468795@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ivan Lipski <ivan.lipski@amd.com>

[ Upstream commit 4ab27b01df629545de5a5f9889867b0f19438cd8 ]

[Why&How]
We only support ENCODER_ID_INTERNAL_UNIPHY encoders now, so NUTMEG & TRAVIS
can be removed from translate_encoder_to_transmitter.

Also refactor to use local variables of transmitter to exit early.

V2: Fix construct_phy check for  TRANSMITTER_UKNOWN

Signed-off-by: Ivan Lipski <ivan.lipski@amd.com>
Reviewed-by: Harry Wentland <harry.wentland@amd.com>
Tested-by: Dan Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Stable-dep-of: 436d0d22aa70 ("drm/amd/display: Pass proper DAC encoder ID to VBIOS")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../drm/amd/display/dc/link/link_factory.c    | 47 +++++--------------
 1 file changed, 12 insertions(+), 35 deletions(-)

diff --git a/drivers/gpu/drm/amd/display/dc/link/link_factory.c b/drivers/gpu/drm/amd/display/dc/link/link_factory.c
index a6e2b0821969b..b3ca83f918747 100644
--- a/drivers/gpu/drm/amd/display/dc/link/link_factory.c
+++ b/drivers/gpu/drm/amd/display/dc/link/link_factory.c
@@ -350,24 +350,6 @@ static enum transmitter translate_encoder_to_transmitter(
 			return TRANSMITTER_UNKNOWN;
 		}
 	break;
-	case ENCODER_ID_EXTERNAL_NUTMEG:
-		switch (encoder.enum_id) {
-		case ENUM_ID_1:
-			return TRANSMITTER_NUTMEG_CRT;
-		default:
-			return TRANSMITTER_UNKNOWN;
-		}
-	break;
-	case ENCODER_ID_EXTERNAL_TRAVIS:
-		switch (encoder.enum_id) {
-		case ENUM_ID_1:
-			return TRANSMITTER_TRAVIS_CRT;
-		case ENUM_ID_2:
-			return TRANSMITTER_TRAVIS_LCD;
-		default:
-			return TRANSMITTER_UNKNOWN;
-		}
-	break;
 	default:
 		return TRANSMITTER_UNKNOWN;
 	}
@@ -477,14 +459,6 @@ static enum engine_id find_analog_engine(struct dc_link *link)
 	return ENGINE_ID_UNKNOWN;
 }
 
-static bool transmitter_supported(const enum transmitter transmitter)
-{
-	return transmitter != TRANSMITTER_UNKNOWN &&
-		transmitter != TRANSMITTER_NUTMEG_CRT &&
-		transmitter != TRANSMITTER_TRAVIS_CRT &&
-		transmitter != TRANSMITTER_TRAVIS_LCD;
-}
-
 static bool analog_engine_supported(const enum engine_id engine_id)
 {
 	return engine_id == ENGINE_ID_DACA ||
@@ -502,6 +476,8 @@ static bool construct_phy(struct dc_link *link,
 	struct dc_bios *bios = init_params->dc->ctx->dc_bios;
 	const struct dc_vbios_funcs *bp_funcs = bios->funcs;
 	struct bp_disp_connector_caps_info disp_connect_caps_info = { 0 };
+	struct graphics_object_id link_encoder = { 0 };
+	enum transmitter transmitter_from_encoder;
 
 	DC_LOGGER_INIT(dc_ctx->logger);
 
@@ -522,21 +498,21 @@ static bool construct_phy(struct dc_link *link,
 	link->link_id =
 		bios->funcs->get_connector_id(bios, init_params->connector_index);
 
+	link->ep_type = DISPLAY_ENDPOINT_PHY;
+
+	DC_LOG_DC("BIOS object table - link_id: %d", link->link_id.id);
+
 	/* Determine early if the link has any supported encoders,
 	 * so that we avoid initializing DDC and HPD, etc.
 	 */
-	bp_funcs->get_src_obj(bios, link->link_id, 0, &enc_init_data.encoder);
-	enc_init_data.transmitter = translate_encoder_to_transmitter(enc_init_data.encoder);
+	bp_funcs->get_src_obj(bios, link->link_id, 0, &link_encoder);
+	transmitter_from_encoder = translate_encoder_to_transmitter(link_encoder);
 	enc_init_data.analog_engine = find_analog_engine(link);
 
-	link->ep_type = DISPLAY_ENDPOINT_PHY;
-
-	DC_LOG_DC("BIOS object table - link_id: %d", link->link_id.id);
-
-	if (!transmitter_supported(enc_init_data.transmitter) &&
+	if (transmitter_from_encoder == TRANSMITTER_UNKNOWN &&
 	    !analog_engine_supported(enc_init_data.analog_engine)) {
 		DC_LOG_WARNING("link_id %d has unsupported encoder\n", link->link_id.id);
-		goto unsupported_fail;
+		goto create_fail;
 	}
 
 	if (bios->funcs->get_disp_connector_caps_info) {
@@ -670,6 +646,8 @@ static bool construct_phy(struct dc_link *link,
 	enc_init_data.connector = link->link_id;
 	enc_init_data.channel = get_ddc_line(link);
 	enc_init_data.hpd_source = get_hpd_line(link);
+	enc_init_data.transmitter = transmitter_from_encoder;
+	enc_init_data.encoder = link_encoder;
 
 	link->hpd_src = enc_init_data.hpd_source;
 
@@ -806,7 +784,6 @@ static bool construct_phy(struct dc_link *link,
 		link->hpd_gpio = NULL;
 	}
 
-unsupported_fail:
 	DC_LOG_DC("BIOS object table - %s failed.\n", __func__);
 	return false;
 }
-- 
2.51.0



