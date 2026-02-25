Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 934642BAF7;
	Wed, 25 Feb 2026 01:31:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771983082; cv=none; b=dQX/UktG7tgDnkoMOCfv/uP7AB9dU1Sr1VuellAZRCw473PXkzXX85qk77rdK5Y3Xg1pf9UxyqMOV2G5DeNTi8hNgfD6XdCbXroU6/FowjhR+l8FG4JUJIFR4nESi3s5osbQlVLneO2VRJ08PdrCJdANXEIKwWa083NiA89X2Jk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771983082; c=relaxed/simple;
	bh=+kdv2p9T3bAjUKwEnr33dZR+qWI1ry+uLW15zIfSimk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KU8GHJRoZcxouEgiAcUGjF+lblcmUYRzUquGHCqP8zU6+CjJ6DZw0KfM6z7qGZqg7WBtNKXFW1bC6Y2ugh+cuuAEsNI1bDhCHSWWem0zLCuyY70Gdueuoap24h3z3rSjdMzpiDXUnOiomv831nMGJHTWg7xQHAUhktgifDuoLv8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=y3lX2UOy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="y3lX2UOy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5AB33C116D0;
	Wed, 25 Feb 2026 01:31:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1771983082;
	bh=+kdv2p9T3bAjUKwEnr33dZR+qWI1ry+uLW15zIfSimk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=y3lX2UOy5JI2v2xwUmrHzKx1YWw8Uc8gjosaIG6tc3ZxBXApQaYSR7rdsZzhnWtIv
	 WojCDGriY+Jh/O0wL4BN5S4rkMMGwlQdLdQDbwW1rIJAniyDpycuGhHD5OghWBAjSq
	 jfaZjLe6FPKQTE8sEa90bAAA+LSG8Gb0yIPBpPy4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ivan Lipski <ivan.lipski@amd.com>,
	Harry Wentland <harry.wentland@amd.com>,
	Dan Wheeler <daniel.wheeler@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 243/781] drm/amd/display: Use local variable for analog_engine initialization
Date: Tue, 24 Feb 2026 17:15:52 -0800
Message-ID: <20260225012405.666566835@linuxfoundation.org>
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

[ Upstream commit 6afc422e1a49d18b63f7042fb1cb6f519a972c8a ]

[Why&How]
Use local variable for analog_engine retrieval and check if it is supported
instead of the struct parameter.

Signed-off-by: Ivan Lipski <ivan.lipski@amd.com>
Reviewed-by: Harry Wentland <harry.wentland@amd.com>
Tested-by: Dan Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Stable-dep-of: 436d0d22aa70 ("drm/amd/display: Pass proper DAC encoder ID to VBIOS")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/dc/link/link_factory.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/amd/display/dc/link/link_factory.c b/drivers/gpu/drm/amd/display/dc/link/link_factory.c
index b3ca83f918747..c79c18efb6f89 100644
--- a/drivers/gpu/drm/amd/display/dc/link/link_factory.c
+++ b/drivers/gpu/drm/amd/display/dc/link/link_factory.c
@@ -478,6 +478,7 @@ static bool construct_phy(struct dc_link *link,
 	struct bp_disp_connector_caps_info disp_connect_caps_info = { 0 };
 	struct graphics_object_id link_encoder = { 0 };
 	enum transmitter transmitter_from_encoder;
+	enum engine_id link_analog_engine;
 
 	DC_LOGGER_INIT(dc_ctx->logger);
 
@@ -507,10 +508,10 @@ static bool construct_phy(struct dc_link *link,
 	 */
 	bp_funcs->get_src_obj(bios, link->link_id, 0, &link_encoder);
 	transmitter_from_encoder = translate_encoder_to_transmitter(link_encoder);
-	enc_init_data.analog_engine = find_analog_engine(link);
+	link_analog_engine = find_analog_engine(link);
 
 	if (transmitter_from_encoder == TRANSMITTER_UNKNOWN &&
-	    !analog_engine_supported(enc_init_data.analog_engine)) {
+	    !analog_engine_supported(link_analog_engine)) {
 		DC_LOG_WARNING("link_id %d has unsupported encoder\n", link->link_id.id);
 		goto create_fail;
 	}
@@ -648,6 +649,7 @@ static bool construct_phy(struct dc_link *link,
 	enc_init_data.hpd_source = get_hpd_line(link);
 	enc_init_data.transmitter = transmitter_from_encoder;
 	enc_init_data.encoder = link_encoder;
+	enc_init_data.analog_engine = link_analog_engine;
 
 	link->hpd_src = enc_init_data.hpd_source;
 
-- 
2.51.0



