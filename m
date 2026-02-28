Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 11F6E32AABE
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 17:53:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772301209; cv=none; b=uNTU+Q10wtQa/ZpPTMmNzUVG46NDXcefDmfUDhsEEyqQ8csFU/K2xc41wJ8j/tN5DentVblDbYVwXAxlEPhitJQA0sUfE0j0Zomov4uwoNtIfKE3PfNKfUEr7NTorfoL+iXMKkm0Co5eiibVh9YFG58nC3NOvMIZnT9baQq/ILs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772301209; c=relaxed/simple;
	bh=A70QdWd1xQxJRbkkBaBkljdqabpHQFVj50qpFwPpgTw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mF9coKa58W+dBcBAGJgAZzK1EYU9VaXtzHYlJWQvfjzfiRLqVFSDORcz60zk8AfTu6jgqMZ9hDEEkEDXaIc9QxHcljypg/iEu1nXt0w2Qi06gukPSXn2Z0mPt5qyLyLZkA7B1vL9OSmZDvBiIQVS8Jr6iJSxQQz4jEKURDKruEM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=A75FZ6LR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="A75FZ6LR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 48D22C116D0;
	Sat, 28 Feb 2026 17:53:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772301209;
	bh=A70QdWd1xQxJRbkkBaBkljdqabpHQFVj50qpFwPpgTw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=A75FZ6LRAf8Mn/OheXgJUJYhnNchf3BDryylqB9OzEm0ywks1gw+NT8X2dcBHLeES
	 YUByjyPEngqdgFEFk5eJJHXzO+jFGfJIDAAlLqOddp/90G0TsIdDPAJQ/143cCDOjy
	 f+bRX8xTKtioCo2/615aTJi3lMMd8irbPy3LyfBnfrJPyPVITuwE2n2UobFFylOU1n
	 6HDiWhKoArbjEQPjdPwupi4CdPKgV5t0/LziBrBVYEgk5zDjhQZdmF55509i/DTqff
	 Iuz49bp8bgxdEQ6O9qcwGOszL0pb3VtTAKHTCkxqF9WzTB7mK13xE3OESTx4CxAGNo
	 Tt8wj00bt9AfA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Clay King <clayking@amd.com>,
	Aric Cyr <aric.cyr@amd.com>,
	Tom Chung <chiahsuan.chung@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 383/752] drm/amd/display: bypass post csc for additional color spaces in dal
Date: Sat, 28 Feb 2026 12:41:34 -0500
Message-ID: <20260228174750.1542406-383-sashal@kernel.org>
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

From: Clay King <clayking@amd.com>

[ Upstream commit 7d9ec9dc20ecdb1661f4538cd9112cd3d6a5f15a ]

[Why]
For RGB BT2020 full and limited color spaces, overlay adjustments were
applied twice (once by MM and once by DAL). This results in incorrect
colours and a noticeable difference between mpo and non-mpo cases.

[How]
Add RGB BT2020 full and limited color spaces to list that bypasses post
csc adjustment.

Reviewed-by: Aric Cyr <aric.cyr@amd.com>
Signed-off-by: Clay King <clayking@amd.com>
Signed-off-by: Tom Chung <chiahsuan.chung@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../drm/amd/display/dc/dpp/dcn30/dcn30_dpp.c  | 21 ++++++++++++++++---
 .../drm/amd/display/dc/dpp/dcn30/dcn30_dpp.h  |  4 ++++
 .../amd/display/dc/dpp/dcn401/dcn401_dpp.c    |  6 +++---
 3 files changed, 25 insertions(+), 6 deletions(-)

diff --git a/drivers/gpu/drm/amd/display/dc/dpp/dcn30/dcn30_dpp.c b/drivers/gpu/drm/amd/display/dc/dpp/dcn30/dcn30_dpp.c
index 4f569cd8a5d61..272ebdd8b9ebd 100644
--- a/drivers/gpu/drm/amd/display/dc/dpp/dcn30/dcn30_dpp.c
+++ b/drivers/gpu/drm/amd/display/dc/dpp/dcn30/dcn30_dpp.c
@@ -360,10 +360,10 @@ void dpp3_cnv_setup (
 
 		tbl_entry.color_space = input_color_space;
 
-		if (color_space >= COLOR_SPACE_YCBCR601)
-			select = INPUT_CSC_SELECT_ICSC;
-		else
+		if (dpp3_should_bypass_post_csc_for_colorspace(color_space))
 			select = INPUT_CSC_SELECT_BYPASS;
+		else
+			select = INPUT_CSC_SELECT_ICSC;
 
 		dpp3_program_post_csc(dpp_base, color_space, select,
 				      &tbl_entry);
@@ -1521,3 +1521,18 @@ bool dpp3_construct(
 	return true;
 }
 
+bool dpp3_should_bypass_post_csc_for_colorspace(enum dc_color_space dc_color_space)
+{
+	switch (dc_color_space) {
+	case COLOR_SPACE_UNKNOWN:
+	case COLOR_SPACE_SRGB:
+	case COLOR_SPACE_XR_RGB:
+	case COLOR_SPACE_SRGB_LIMITED:
+	case COLOR_SPACE_MSREF_SCRGB:
+	case COLOR_SPACE_2020_RGB_FULLRANGE:
+	case COLOR_SPACE_2020_RGB_LIMITEDRANGE:
+		return true;
+	default:
+		return false;
+	}
+}
diff --git a/drivers/gpu/drm/amd/display/dc/dpp/dcn30/dcn30_dpp.h b/drivers/gpu/drm/amd/display/dc/dpp/dcn30/dcn30_dpp.h
index f236824126e94..2a76105fa9b1c 100644
--- a/drivers/gpu/drm/amd/display/dc/dpp/dcn30/dcn30_dpp.h
+++ b/drivers/gpu/drm/amd/display/dc/dpp/dcn30/dcn30_dpp.h
@@ -642,4 +642,8 @@ void dpp3_program_cm_dealpha(
 
 void dpp3_cm_get_gamut_remap(struct dpp *dpp_base,
 			     struct dpp_grph_csc_adjustment *adjust);
+
+bool dpp3_should_bypass_post_csc_for_colorspace(
+		enum dc_color_space dc_color_space);
+
 #endif /* __DC_HWSS_DCN30_H__ */
diff --git a/drivers/gpu/drm/amd/display/dc/dpp/dcn401/dcn401_dpp.c b/drivers/gpu/drm/amd/display/dc/dpp/dcn401/dcn401_dpp.c
index 36187f890d5d0..b62bbadb0d440 100644
--- a/drivers/gpu/drm/amd/display/dc/dpp/dcn401/dcn401_dpp.c
+++ b/drivers/gpu/drm/amd/display/dc/dpp/dcn401/dcn401_dpp.c
@@ -206,10 +206,10 @@ void dpp401_dpp_setup(
 
 		tbl_entry.color_space = input_color_space;
 
-		if (color_space >= COLOR_SPACE_YCBCR601)
-			select = INPUT_CSC_SELECT_ICSC;
-		else
+		if (dpp3_should_bypass_post_csc_for_colorspace(color_space))
 			select = INPUT_CSC_SELECT_BYPASS;
+		else
+			select = INPUT_CSC_SELECT_ICSC;
 
 		dpp3_program_post_csc(dpp_base, color_space, select,
 			&tbl_entry);
-- 
2.51.0

