Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1ECB613B295;
	Tue, 27 Feb 2024 13:36:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709040989; cv=none; b=UBYVNcgtx1+524ndEVzrf4G9VNT0ANC389LplX3g3lfLBb0qdGU5WVty8wQ+t2Ukh1APKx3lO+2sUwPApcz9qU4N2HoXWaqM1f8hDeCEfBMUytIHsBavaFxe2WKo2zxckM4h6Q7t9cwH6suyVBrRfrc+B3Z+u13BWLO2pRIRa4M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709040989; c=relaxed/simple;
	bh=kPXmSpfo6GAK8llEz5NBvhuAxlJhae+f7LX7w3Cot7A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rIqt/g4EweNAMxQdh+5PCUc4NvqKZNBrZWKsdKpbsCyXm2laeYAQBcix4iQRT0EfLaINpv6+3li+cjNiykfH8tYachS2PabL0yZU1U21drj4MP9ctaES76tmDvWlVytws/sW2QAhsa/GG58ECwJ66O4yCDANU1VpUD+cAXHs/sw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=plC2INQA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="plC2INQA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5AFFEC433F1;
	Tue, 27 Feb 2024 13:36:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709040988;
	bh=kPXmSpfo6GAK8llEz5NBvhuAxlJhae+f7LX7w3Cot7A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=plC2INQA3LVGo0PuINTweTds21yYLgrym6nfuEOU4BatWD+ESrE3MLOy3xuENnx10
	 GEsrHVcPdyCFMRjDDPxbOu2/MWLRFvnfurM+mNjXJ1icOXLvv5/G8GR4FdObEskP58
	 NL9htMcit/2cTWqzYxS+KmRr631yuhznr2thc3+U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mario Limonciello <mario.limonciello@amd.com>,
	Anthony Koo <anthony.koo@amd.com>,
	Rodrigo Siqueira <rodrigo.siqueira@amd.com>,
	Daniel Wheeler <daniel.wheeler@amd.com>,
	Lewis Huang <lewis.huang@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.7 151/334] drm/amd/display: Only allow dig mapping to pwrseq in new asic
Date: Tue, 27 Feb 2024 14:20:09 +0100
Message-ID: <20240227131635.333629692@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240227131630.636392135@linuxfoundation.org>
References: <20240227131630.636392135@linuxfoundation.org>
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

From: Lewis Huang <lewis.huang@amd.com>

commit 4e73826089ce899357580bbf6e0afe4e6f9900b7 upstream.

[Why]
The old asic only have 1 pwrseq hw.
We don't need to map the diginst to pwrseq inst in old asic.

[How]
1. Only mapping dig to pwrseq for new asic.
2. Move mapping function into dcn specific panel control component

Cc: Stable <stable@vger.kernel.org> # v6.6+
Cc: Mario Limonciello <mario.limonciello@amd.com>
Link: https://gitlab.freedesktop.org/drm/amd/-/issues/3122
Reviewed-by: Anthony Koo <anthony.koo@amd.com>
Acked-by: Rodrigo Siqueira <rodrigo.siqueira@amd.com>
Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Lewis Huang <lewis.huang@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/display/dc/dce/dce_panel_cntl.c       |    1 
 drivers/gpu/drm/amd/display/dc/dcn301/dcn301_panel_cntl.c |    1 
 drivers/gpu/drm/amd/display/dc/dcn31/dcn31_panel_cntl.c   |   18 +++++++++
 drivers/gpu/drm/amd/display/dc/inc/hw/panel_cntl.h        |    2 -
 drivers/gpu/drm/amd/display/dc/link/link_factory.c        |   26 --------------
 5 files changed, 21 insertions(+), 27 deletions(-)

--- a/drivers/gpu/drm/amd/display/dc/dce/dce_panel_cntl.c
+++ b/drivers/gpu/drm/amd/display/dc/dce/dce_panel_cntl.c
@@ -290,4 +290,5 @@ void dce_panel_cntl_construct(
 	dce_panel_cntl->base.funcs = &dce_link_panel_cntl_funcs;
 	dce_panel_cntl->base.ctx = init_data->ctx;
 	dce_panel_cntl->base.inst = init_data->inst;
+	dce_panel_cntl->base.pwrseq_inst = 0;
 }
--- a/drivers/gpu/drm/amd/display/dc/dcn301/dcn301_panel_cntl.c
+++ b/drivers/gpu/drm/amd/display/dc/dcn301/dcn301_panel_cntl.c
@@ -215,4 +215,5 @@ void dcn301_panel_cntl_construct(
 	dcn301_panel_cntl->base.funcs = &dcn301_link_panel_cntl_funcs;
 	dcn301_panel_cntl->base.ctx = init_data->ctx;
 	dcn301_panel_cntl->base.inst = init_data->inst;
+	dcn301_panel_cntl->base.pwrseq_inst = 0;
 }
--- a/drivers/gpu/drm/amd/display/dc/dcn31/dcn31_panel_cntl.c
+++ b/drivers/gpu/drm/amd/display/dc/dcn31/dcn31_panel_cntl.c
@@ -154,8 +154,24 @@ void dcn31_panel_cntl_construct(
 	struct dcn31_panel_cntl *dcn31_panel_cntl,
 	const struct panel_cntl_init_data *init_data)
 {
+	uint8_t pwrseq_inst = 0xF;
+
 	dcn31_panel_cntl->base.funcs = &dcn31_link_panel_cntl_funcs;
 	dcn31_panel_cntl->base.ctx = init_data->ctx;
 	dcn31_panel_cntl->base.inst = init_data->inst;
-	dcn31_panel_cntl->base.pwrseq_inst = init_data->pwrseq_inst;
+
+	switch (init_data->eng_id) {
+	case ENGINE_ID_DIGA:
+		pwrseq_inst = 0;
+		break;
+	case ENGINE_ID_DIGB:
+		pwrseq_inst = 1;
+		break;
+	default:
+		DC_LOG_WARNING("Unsupported pwrseq engine id: %d!\n", init_data->eng_id);
+		ASSERT(false);
+		break;
+	}
+
+	dcn31_panel_cntl->base.pwrseq_inst = pwrseq_inst;
 }
--- a/drivers/gpu/drm/amd/display/dc/inc/hw/panel_cntl.h
+++ b/drivers/gpu/drm/amd/display/dc/inc/hw/panel_cntl.h
@@ -56,7 +56,7 @@ struct panel_cntl_funcs {
 struct panel_cntl_init_data {
 	struct dc_context *ctx;
 	uint32_t inst;
-	uint32_t pwrseq_inst;
+	uint32_t eng_id;
 };
 
 struct panel_cntl {
--- a/drivers/gpu/drm/amd/display/dc/link/link_factory.c
+++ b/drivers/gpu/drm/amd/display/dc/link/link_factory.c
@@ -368,30 +368,6 @@ static enum transmitter translate_encode
 	}
 }
 
-static uint8_t translate_dig_inst_to_pwrseq_inst(struct dc_link *link)
-{
-	uint8_t pwrseq_inst = 0xF;
-	struct dc_context *dc_ctx = link->dc->ctx;
-
-	DC_LOGGER_INIT(dc_ctx->logger);
-
-	switch (link->eng_id) {
-	case ENGINE_ID_DIGA:
-		pwrseq_inst = 0;
-		break;
-	case ENGINE_ID_DIGB:
-		pwrseq_inst = 1;
-		break;
-	default:
-		DC_LOG_WARNING("Unsupported pwrseq engine id: %d!\n", link->eng_id);
-		ASSERT(false);
-		break;
-	}
-
-	return pwrseq_inst;
-}
-
-
 static void link_destruct(struct dc_link *link)
 {
 	int i;
@@ -655,7 +631,7 @@ static bool construct_phy(struct dc_link
 			link->link_id.id == CONNECTOR_ID_LVDS)) {
 		panel_cntl_init_data.ctx = dc_ctx;
 		panel_cntl_init_data.inst = panel_cntl_init_data.ctx->dc_edp_id_count;
-		panel_cntl_init_data.pwrseq_inst = translate_dig_inst_to_pwrseq_inst(link);
+		panel_cntl_init_data.eng_id = link->eng_id;
 		link->panel_cntl =
 			link->dc->res_pool->funcs->panel_cntl_create(
 								&panel_cntl_init_data);


