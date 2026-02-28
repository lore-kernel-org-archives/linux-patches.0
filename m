Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 546C7340A47
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 17:50:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772301005; cv=none; b=E5e9waWA7VW5QbWtjvFkcKE8BwnjJVInjuhmOBHhU2J4LUF4+XzN8WGNqKfQGa3h1eMR8MRaC23cUBmFpxuIJUkyeVlOKy7UXCWkPI9vN5Zk1UHqYXQT+Ugr4hzDPCQHQSonq4L31kT66xyDnjl6k3ZlW9CO5C+vkWUqiY5GR1c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772301005; c=relaxed/simple;
	bh=QOd+ndstvpJ58Pk4i8Md7ln+l+STGIjvMvKy5ZP5Vrg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TOon3G6X2eRS8aBwlsh8iOabfUjK1cxCYGH5pVQI/m33lXWREgtGHpl5l/ZzY0vOw7PnwnvnXdUCjvhJoUwGMvCruYhygo3YRvxj4i3WMbz1waGyabjJg5WkwkWvVw3NL8Nxcp4ODgw/YgRb4EIbiniCQtYQi5xpP11pGEEXXa4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ik/YmFij; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ik/YmFij"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 27B04C116D0;
	Sat, 28 Feb 2026 17:50:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772301004;
	bh=QOd+ndstvpJ58Pk4i8Md7ln+l+STGIjvMvKy5ZP5Vrg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ik/YmFij4zn+nz7Y3gkJaYNUzlmtdysK9dpmFTE5NsOdcYSN/oYugXvhxKwDAXUJ2
	 Ec/8Sbjr0/ZqnWrBupH/xs+W/ahp3qYYL/1AaoGjOOQj01cMZmRl4+caVKtIOAm0jM
	 Kp44FCQaIk6h0cFEIf94vZdWb5lhzfEjLazD12d39PR2IrdjS/VteCTGXcJETTPQsD
	 +/Rvn23VV1iMGjKs3BXw4zqGiPQ8U43qulvS/m/94B5vMdqZZ1dulgq1dILYJ4mIXx
	 P5+c7Foc91KrXktJlRwlgQvYBxQSVT5mzMDNo8RzbB0QsqOQl1bVOXI/mRi0twlegq
	 fWoUShSAeB+rw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Charlene Liu <Charlene.Liu@amd.com>,
	Mohit Bawa <mohit.bawa@amd.com>,
	Chenyu Chen <chen-yu.chen@amd.com>,
	Daniel Wheeler <daniel.wheeler@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 138/752] drm/amd/display: Fix dsc eDP issue
Date: Sat, 28 Feb 2026 12:37:29 -0500
Message-ID: <20260228174750.1542406-138-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228174750.1542406-1-sashal@kernel.org>
References: <20260228174750.1542406-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Charlene Liu <Charlene.Liu@amd.com>

[ Upstream commit 878a4b73c11111ff5f820730f59a7f8c6fd59374 ]

[why]
Need to add function hook check before use

Reviewed-by: Mohit Bawa <mohit.bawa@amd.com>
Signed-off-by: Charlene Liu <Charlene.Liu@amd.com>
Signed-off-by: Chenyu Chen <chen-yu.chen@amd.com>
Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../drm/amd/display/dc/hwss/dce110/dce110_hwseq.c    | 12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

diff --git a/drivers/gpu/drm/amd/display/dc/hwss/dce110/dce110_hwseq.c b/drivers/gpu/drm/amd/display/dc/hwss/dce110/dce110_hwseq.c
index 39be5a58f837a..7e36c063f0da5 100644
--- a/drivers/gpu/drm/amd/display/dc/hwss/dce110/dce110_hwseq.c
+++ b/drivers/gpu/drm/amd/display/dc/hwss/dce110/dce110_hwseq.c
@@ -1790,6 +1790,9 @@ static void disable_vga_and_power_gate_all_controllers(
 	struct timing_generator *tg;
 	struct dc_context *ctx = dc->ctx;
 
+	if (dc->caps.ips_support)
+		return;
+
 	for (i = 0; i < dc->res_pool->timing_generator_count; i++) {
 		tg = dc->res_pool->timing_generators[i];
 
@@ -1866,13 +1869,16 @@ static void clean_up_dsc_blocks(struct dc *dc)
 			/* disable DSC in OPTC */
 			if (i < dc->res_pool->timing_generator_count) {
 				tg = dc->res_pool->timing_generators[i];
-				tg->funcs->set_dsc_config(tg, OPTC_DSC_DISABLED, 0, 0);
+				if (tg->funcs->set_dsc_config)
+					tg->funcs->set_dsc_config(tg, OPTC_DSC_DISABLED, 0, 0);
 			}
 			/* disable DSC in stream encoder */
 			if (i < dc->res_pool->stream_enc_count) {
 				se = dc->res_pool->stream_enc[i];
-				se->funcs->dp_set_dsc_config(se, OPTC_DSC_DISABLED, 0, 0);
-				se->funcs->dp_set_dsc_pps_info_packet(se, false, NULL, true);
+				if (se->funcs->dp_set_dsc_config)
+					se->funcs->dp_set_dsc_config(se, OPTC_DSC_DISABLED, 0, 0);
+				if (se->funcs->dp_set_dsc_pps_info_packet)
+					se->funcs->dp_set_dsc_pps_info_packet(se, false, NULL, true);
 			}
 			/* disable DSC block */
 			if (dccg->funcs->set_ref_dscclk)
-- 
2.51.0

