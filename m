Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1DFB41991BE;
	Thu,  6 Jun 2024 14:12:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717683157; cv=none; b=Lj6kylc9F+PnSQNU6GwugkQ20zW98ZhIv2pGVBkYX/RcbWBfxHepGhD/lVB+d4IHgnAUm9wdhG3MrL9WznPPhRdRutKXOys6shoDwy32B3Cgc9n1Ta8BXF+gC7k845pCTUr+8VKcgHvROMTBn3i/tm23dvIsCCus+kr19aOwMwo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717683157; c=relaxed/simple;
	bh=+XBJdTj0Q2asgJYrdzwXlwX5hYNG5MIkX0Gu5NXocW4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=deAIt+anuepWu+/Ov63x/uzNAs9upKO6yR+KdRmYhgvHSiAK1vuEsqNJwC0+GmeTiHthZmBPTykXk6mWhjasSAc9VWCCXVbZbw5mYsw8KWqa97QlvQee9J25UeCknZDSEuDcUvvN6RuqXXFaVa2izzx+QPF8Hmdh5wWzhGdnZDs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=r1jvnOnt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="r1jvnOnt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EFA2FC2BD10;
	Thu,  6 Jun 2024 14:12:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717683157;
	bh=+XBJdTj0Q2asgJYrdzwXlwX5hYNG5MIkX0Gu5NXocW4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=r1jvnOntDO6gjOBgpGvdsJsPYGTPv+Xv2mDxuYuCtSfM5jksmI+rLVH9wLa8+LVe1
	 jEl9US/r11AuH2ujTBdiSug0Wa0B1HX6r2k2muXxSzPiMJfR6JKJ3t4qpkovgg2bGX
	 G5yVgrw8qfACrQS7VS+zqZrGHv49Uh8uGFJSML4c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wayne Lin <wayne.lin@amd.com>,
	Rodrigo Siqueira <Rodrigo.Siqueira@amd.com>,
	Daniel Wheeler <daniel.wheeler@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 079/744] drm/amd/display: Add VCO speed parameter for DCN31 FPU
Date: Thu,  6 Jun 2024 15:55:51 +0200
Message-ID: <20240606131734.936386584@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240606131732.440653204@linuxfoundation.org>
References: <20240606131732.440653204@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index deb6d162a2d5c..7307b7b8d8ad7 100644
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



