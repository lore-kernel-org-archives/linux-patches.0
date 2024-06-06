Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AFD71199227;
	Thu,  6 Jun 2024 14:13:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717683181; cv=none; b=ehV/bP2CR+xLyxnySGX4IfQGXOkPRiCAhFi1KvMPELxwiTwYo/T1u5+g37jLLb3iQLPbTmgZUEP5EEtLsdEq+zAExWIGlBnaRLFPUgCU857pKSprcr/eNYyYwG8TEUBlysHmCxwVIPeQ1Q/FYdH3Mazl1imBwgx+RmDXFhZUw1I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717683181; c=relaxed/simple;
	bh=4+lqhQfLyOypY1z/8EPBnZYUK8GzzEgKIHGAmdngZKY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ElVTRKiLs7y83LacF6waxlBhOP1SS2du/PQ7Wy3E+5gfOt+Yv6IFXsUVAZjv7EWezd3YnJV7Uos4kBsDmrybWH0CUsCXUeFrFokM3kyBHyfbrO6bpA8Cut0MpEknUd3OemLntxHRIA5CoOCWA3DZG3LREQbCCrPE+Tz7T2gpmjQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pi8hzya9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pi8hzya9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8F40BC32781;
	Thu,  6 Jun 2024 14:13:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717683181;
	bh=4+lqhQfLyOypY1z/8EPBnZYUK8GzzEgKIHGAmdngZKY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pi8hzya9gkggsI++DECqpXr2o4661MkfX9FAM8hFue/g6UptMMbVRuBrJEoZkHwXu
	 mKHhra5Wb3kMjfgjDdDbjJOc2fareM5n3C0MDICOjytsCUBFdXgC1U7DlWimYu6/Tn
	 HpcjdvQm+s21gZgzHqQeg+8iEP3MPWf9tb1Ti7IQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wayne Lin <wayne.lin@amd.com>,
	Rodrigo Siqueira <Rodrigo.Siqueira@amd.com>,
	Daniel Wheeler <daniel.wheeler@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 056/473] drm/amd/display: Add VCO speed parameter for DCN31 FPU
Date: Thu,  6 Jun 2024 15:59:45 +0200
Message-ID: <20240606131701.737668195@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240606131659.786180261@linuxfoundation.org>
References: <20240606131659.786180261@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Rodrigo Siqueira <Rodrigo.Siqueira@amd.com>

[ Upstream commit 0e62103bdcbc88281e16add299a946fb3bd02fbe ]

Add VCO speed parameters in the bounding box array.

Acked-by: Wayne Lin <wayne.lin@amd.com>
Signed-off-by: Rodrigo Siqueira <Rodrigo.Siqueira@amd.com>
Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/dc/dml/dcn31/dcn31_fpu.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/gpu/drm/amd/display/dc/dml/dcn31/dcn31_fpu.c b/drivers/gpu/drm/amd/display/dc/dml/dcn31/dcn31_fpu.c
index 19d034341e640..cb2f6cd73af54 100644
--- a/drivers/gpu/drm/amd/display/dc/dml/dcn31/dcn31_fpu.c
+++ b/drivers/gpu/drm/amd/display/dc/dml/dcn31/dcn31_fpu.c
@@ -291,6 +291,7 @@ static struct _vcs_dpi_soc_bounding_box_st dcn3_15_soc = {
 	.do_urgent_latency_adjustment = false,
 	.urgent_latency_adjustment_fabric_clock_component_us = 0,
 	.urgent_latency_adjustment_fabric_clock_reference_mhz = 0,
+	.dispclk_dppclk_vco_speed_mhz = 2400.0,
 	.num_chans = 4,
 	.dummy_pstate_latency_us = 10.0
 };
@@ -438,6 +439,7 @@ static struct _vcs_dpi_soc_bounding_box_st dcn3_16_soc = {
 	.do_urgent_latency_adjustment = false,
 	.urgent_latency_adjustment_fabric_clock_component_us = 0,
 	.urgent_latency_adjustment_fabric_clock_reference_mhz = 0,
+	.dispclk_dppclk_vco_speed_mhz = 2500.0,
 };
 
 void dcn31_zero_pipe_dcc_fraction(display_e2e_pipe_params_st *pipes,
-- 
2.43.0



