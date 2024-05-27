Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 040E2168C4;
	Mon, 27 May 2024 19:21:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716837661; cv=none; b=fS7GR+9Ur534AmtTJW4b3C32ouchwz2b6PSedas/vIHWLXe2/2blWIGJEHFicafkhUYesucnBS7nmPQtzG/89ObXaCk2KSo1YDbGcpktXgaLBLiKATaDeYIONgGW0TDTS336oKPiIg8dyoAtIuVO3WyhhLOiVeqaFNDQrqlS0Nc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716837661; c=relaxed/simple;
	bh=h1Ml+mmEJ5IxK973B2wd6O16x2XRTwIdatFHKxwNO+Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KoYjihhC2KTK3yOzaA/3YZCg5ca0UwCvJtjVltenDpPAU3DkbzKUwijEZQu/PSjKOcmKiNYyahaXNIz2wwUNHK9R9SjSr0/qky5MLPEEHA4bUlNBrF0CNzJQohrNV88lWgjLjAlt9ZpQJi9VZlZ5bVIOWYzIIgEby0kP8478whU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ocfS3mtK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ocfS3mtK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8F147C2BBFC;
	Mon, 27 May 2024 19:21:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1716837660;
	bh=h1Ml+mmEJ5IxK973B2wd6O16x2XRTwIdatFHKxwNO+Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ocfS3mtKDDS1FTAK6g7B1KBB4iYDVDuJVUGepiR7XyczXiT8f2Patkpk7sfij3mnS
	 frE8Xlt0xH8OYEs5xT5kQM/XJagwOXMgSSwBwN/j1iIJbW8VVK+sqn+V9P7V2CdmQn
	 Pc1GbewtDHwlc+NUZpNgxuhR+tnj2QUBE9eRNzIE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wayne Lin <wayne.lin@amd.com>,
	Rodrigo Siqueira <Rodrigo.Siqueira@amd.com>,
	Daniel Wheeler <daniel.wheeler@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.8 096/493] drm/amd/display: Add VCO speed parameter for DCN31 FPU
Date: Mon, 27 May 2024 20:51:38 +0200
Message-ID: <20240527185633.572595161@linuxfoundation.org>
X-Mailer: git-send-email 2.45.1
In-Reply-To: <20240527185626.546110716@linuxfoundation.org>
References: <20240527185626.546110716@linuxfoundation.org>
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



