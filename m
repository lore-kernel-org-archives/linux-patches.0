Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793829320;
	b=ItPyRpI8vq2hVR3p9rt8jqdLnS8dVy2+OG5OREp/aPJToI70IvYZkCz9qrNoZFoVDBgX
	 gE3tw85C45ndA5ZC+n7qlYFS8oMBwK9TLfJBYdV9dWDWySr/JfvuFS2COZDkW16OgG2Wc
	 qzeCZK019Uu0Hc1Z/uFr6xxhpWh7Cv+ZyuCJzNTXXpA8SFEReozWmPesHku/k19wL9fOs
	 k/vyidTAgq3xIts6KpPNePhqMT847eczdSNpFZI+gx7Z3Z0UPqCO9YhTyPSN5kHbC+OJX
	 9QWeJmo5vXw0evb/5PZPrKVumc8XprmP4cCuXcq5WDSM7ri3ReIUj1iqKKI8a8Fq26A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793829320;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=R65u5i0A4vIOP2Z98REIkflVuVdYQHYXQt86seFBhLU=;
	b=L8qjsA8q+xXHaGrgwasphywtb+Qhiab0fHJc1R104IrBgrwN8WeIJ+UIdVhhZ+ZO0aTL
	 tqaNuy4A1V4RwfvBMywY9MKrbikBEAYx3mGNg1/rFf2Zsd+zak2qBfw5qZiDeZWiUNldX
	 rGO4gu9EpCoBM/Z/ufQFWqMnplB7oHdfyoj5Y37SNXv0qfLAKnwxEzbhKrFp7Psz7dY+f
	 HcJNeM77yPGzBzBAhBbxmlIoD6/pMymjdnmgp2uZ0UuB64WWsl5wxQmPM0/dBhDTiqmR+
	 fWT059AFCTB79rf9ADoz6lilKbvOCWOkgTmyGjTflcFQxWCTMW56DWVnS6X45N/Lhdg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="h/rp4jpI";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 711FA6074917;
	Wed,  4 Nov 2026 21:55:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=h/rp4jpI
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 16CCD1F000C1;
	Wed,  4 Nov 2026 21:55:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793829320;
	bh=R65u5i0A4vIOP2Z98REIkflVuVdYQHYXQt86seFBhLU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=h/rp4jpIoIqf1rFF/g/KYR063wHnTPqgkmoGbtht8EMKf4vCxMptcBrNNEAH4TxYR
	 eOadLbj0oaRcplmH5PpBuYU8XDRMUsoS6pspWvY41T158fyVYiD4EPCWam9qGyuOLE
	 wk4hd23+6Yxzr8+aYrmBM1YCFmYDc4lCh3KZHdNw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dillon Varone <dillon.varone@amd.com>,
	Dmytro Laktyushkin <dmytro.laktyushkin@amd.com>,
	Charlene Liu <Charlene.Liu@amd.com>,
	Aurabindo Pillai <aurabindo.pillai@amd.com>,
	Dan Wheeler <daniel.wheeler@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0021/1005] drm/amd/display: fix max dispclk_khz/dppclk_khz double 1000
Date: Wed,  4 Nov 2026 15:55:54 -0500
Message-ID: <20261104211044.147057918@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104211043.516122098@linuxfoundation.org>
References: <20261104211043.516122098@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Charlene Liu <Charlene.Liu@amd.com>

[ Upstream commit f48124ff35357d05a98d9cd5cb7982e7e5509003 ]

[why]
Fix regresson caused by double roundup and index out of range

Reviewed-by: Dillon Varone <dillon.varone@amd.com>
Reviewed-by: Dmytro Laktyushkin <dmytro.laktyushkin@amd.com>
Signed-off-by: Charlene Liu <Charlene.Liu@amd.com>
Signed-off-by: Aurabindo Pillai <aurabindo.pillai@amd.com>
Tested-by: Dan Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/dc/dml2/dml21/dml21_wrapper.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/gpu/drm/amd/display/dc/dml2/dml21/dml21_wrapper.c b/drivers/gpu/drm/amd/display/dc/dml2/dml21/dml21_wrapper.c
index 08f7f03b10231..0167d936feaf5 100644
--- a/drivers/gpu/drm/amd/display/dc/dml2/dml21/dml21_wrapper.c
+++ b/drivers/gpu/drm/amd/display/dc/dml2/dml21/dml21_wrapper.c
@@ -152,16 +152,16 @@ static void dml21_calculate_rq_and_dlg_params(const struct dc *dc, struct dc_sta
 	context->bw_ctx.bw.dcn.clk.bw_dispclk_khz = context->bw_ctx.bw.dcn.clk.dispclk_khz;
 	if (in_ctx->v21.dml_init.soc_bb.clk_table.dispclk.num_clk_values > 1) {
 		context->bw_ctx.bw.dcn.clk.max_supported_dispclk_khz =
-			in_ctx->v21.dml_init.soc_bb.clk_table.dispclk.clk_values_khz[in_ctx->v21.dml_init.soc_bb.clk_table.dispclk.num_clk_values] * 1000;
+			in_ctx->v21.dml_init.soc_bb.clk_table.dispclk.clk_values_khz[in_ctx->v21.dml_init.soc_bb.clk_table.dispclk.num_clk_values - 1];
 	} else {
-		context->bw_ctx.bw.dcn.clk.max_supported_dispclk_khz = in_ctx->v21.dml_init.soc_bb.clk_table.dispclk.clk_values_khz[0] * 1000;
+		context->bw_ctx.bw.dcn.clk.max_supported_dispclk_khz = in_ctx->v21.dml_init.soc_bb.clk_table.dispclk.clk_values_khz[0];
 	}
 
 	if (in_ctx->v21.dml_init.soc_bb.clk_table.dppclk.num_clk_values > 1) {
 		context->bw_ctx.bw.dcn.clk.max_supported_dppclk_khz =
-			in_ctx->v21.dml_init.soc_bb.clk_table.dppclk.clk_values_khz[in_ctx->v21.dml_init.soc_bb.clk_table.dppclk.num_clk_values] * 1000;
+			in_ctx->v21.dml_init.soc_bb.clk_table.dppclk.clk_values_khz[in_ctx->v21.dml_init.soc_bb.clk_table.dppclk.num_clk_values - 1];
 	} else {
-		context->bw_ctx.bw.dcn.clk.max_supported_dppclk_khz = in_ctx->v21.dml_init.soc_bb.clk_table.dppclk.clk_values_khz[0] * 1000;
+		context->bw_ctx.bw.dcn.clk.max_supported_dppclk_khz = in_ctx->v21.dml_init.soc_bb.clk_table.dppclk.clk_values_khz[0];
 	}
 
 	/* get global mall allocation */
-- 
2.53.0



