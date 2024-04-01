Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A5C15481B3;
	Mon,  1 Apr 2024 16:30:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711989009; cv=none; b=Wxjypr0Vd6StwxEZRD3AifDmCj2DR7AYEhiiTVCtZH3W+vOduKFEK6Cu1t230mC8BoiIkrmFQ4iwaY/Pdkskfw3Q5AsvVoT4IYbCHUuRwTXk1G8mMFZW9gnv5X3PSNnFVmWLDTEcuYSobwha+nfM77tG5qvNMwlLyWoKWZd8viE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711989009; c=relaxed/simple;
	bh=/D/gOunw4DLIz2g2H8buW8qAbMmOkM75rWMSnDyetMI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=sJ8sHrJhS4wh0vdZOSGfm1xrMX+tGHTtT0YkfC+JAesbYSbkCbpop1aZNQKxX0zLb2+ownGIcLTRAdKTKYYuNnteUJ8gm8jr/C+Zv0h05xcYNLrm9/8Uafl8aoj2zvZOYEXLGwJ+EMt89WWhFVmolcSJ1UAyUcbX+qWuEaEdn7U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=P//hjzO/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="P//hjzO/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 158A9C433F1;
	Mon,  1 Apr 2024 16:30:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1711989009;
	bh=/D/gOunw4DLIz2g2H8buW8qAbMmOkM75rWMSnDyetMI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=P//hjzO/56+yKznRTuAzIB2PuGHvNFT1eGE4u61KOxobRWarVVjz2r0XyyKuN3zaS
	 FZMYX1C4Utd8uRUryxTYWeYYTqlh6AeHWlfhtfSVYl3EfmbQYGGZmBDQgcZeeRO9kh
	 T4LW/SwNwOBddOsG4mOJ+6N852r5hv+eJHUOqPlQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Ville=20Syrj=C3=A4l=C3=A4?= <ville.syrjala@linux.intel.com>,
	Jani Nikula <jani.nikula@intel.com>
Subject: [PATCH 6.7 326/432] drm/i915: Use named initializers for DPLL info
Date: Mon,  1 Apr 2024 17:45:13 +0200
Message-ID: <20240401152602.938630473@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240401152553.125349965@linuxfoundation.org>
References: <20240401152553.125349965@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ville Syrjälä <ville.syrjala@linux.intel.com>

commit f215038f4133ea9d1b525e9bb812527fe002db2b upstream.

Use named initializers when populating the DPLL info. This
is just more convenient and less error prone as we no longer
have to keep the initializers in a specific order.

Signed-off-by: Ville Syrjälä <ville.syrjala@linux.intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20231012123522.26045-2-ville.syrjala@linux.intel.com
Reviewed-by: Jani Nikula <jani.nikula@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/i915/display/intel_dpll_mgr.c |  130 +++++++++++++-------------
 1 file changed, 67 insertions(+), 63 deletions(-)

--- a/drivers/gpu/drm/i915/display/intel_dpll_mgr.c
+++ b/drivers/gpu/drm/i915/display/intel_dpll_mgr.c
@@ -631,9 +631,9 @@ static const struct intel_shared_dpll_fu
 };
 
 static const struct dpll_info pch_plls[] = {
-	{ "PCH DPLL A", &ibx_pch_dpll_funcs, DPLL_ID_PCH_PLL_A, 0 },
-	{ "PCH DPLL B", &ibx_pch_dpll_funcs, DPLL_ID_PCH_PLL_B, 0 },
-	{ },
+	{ .name = "PCH DPLL A", .funcs = &ibx_pch_dpll_funcs, .id = DPLL_ID_PCH_PLL_A, },
+	{ .name = "PCH DPLL B", .funcs = &ibx_pch_dpll_funcs, .id = DPLL_ID_PCH_PLL_B, },
+	{}
 };
 
 static const struct intel_dpll_mgr pch_pll_mgr = {
@@ -1239,13 +1239,16 @@ static const struct intel_shared_dpll_fu
 };
 
 static const struct dpll_info hsw_plls[] = {
-	{ "WRPLL 1",    &hsw_ddi_wrpll_funcs, DPLL_ID_WRPLL1,     0 },
-	{ "WRPLL 2",    &hsw_ddi_wrpll_funcs, DPLL_ID_WRPLL2,     0 },
-	{ "SPLL",       &hsw_ddi_spll_funcs,  DPLL_ID_SPLL,       0 },
-	{ "LCPLL 810",  &hsw_ddi_lcpll_funcs, DPLL_ID_LCPLL_810,  INTEL_DPLL_ALWAYS_ON },
-	{ "LCPLL 1350", &hsw_ddi_lcpll_funcs, DPLL_ID_LCPLL_1350, INTEL_DPLL_ALWAYS_ON },
-	{ "LCPLL 2700", &hsw_ddi_lcpll_funcs, DPLL_ID_LCPLL_2700, INTEL_DPLL_ALWAYS_ON },
-	{ },
+	{ .name = "WRPLL 1", .funcs = &hsw_ddi_wrpll_funcs, .id = DPLL_ID_WRPLL1, },
+	{ .name = "WRPLL 2", .funcs = &hsw_ddi_wrpll_funcs, .id = DPLL_ID_WRPLL2, },
+	{ .name = "SPLL", .funcs = &hsw_ddi_spll_funcs, .id = DPLL_ID_SPLL, },
+	{ .name = "LCPLL 810", .funcs = &hsw_ddi_lcpll_funcs, .id = DPLL_ID_LCPLL_810,
+	  .flags = INTEL_DPLL_ALWAYS_ON, },
+	{ .name = "LCPLL 1350", .funcs = &hsw_ddi_lcpll_funcs, .id = DPLL_ID_LCPLL_1350,
+	  .flags = INTEL_DPLL_ALWAYS_ON, },
+	{ .name = "LCPLL 2700", .funcs = &hsw_ddi_lcpll_funcs, .id = DPLL_ID_LCPLL_2700,
+	  .flags = INTEL_DPLL_ALWAYS_ON, },
+	{}
 };
 
 static const struct intel_dpll_mgr hsw_pll_mgr = {
@@ -1921,11 +1924,12 @@ static const struct intel_shared_dpll_fu
 };
 
 static const struct dpll_info skl_plls[] = {
-	{ "DPLL 0", &skl_ddi_dpll0_funcs, DPLL_ID_SKL_DPLL0, INTEL_DPLL_ALWAYS_ON },
-	{ "DPLL 1", &skl_ddi_pll_funcs,   DPLL_ID_SKL_DPLL1, 0 },
-	{ "DPLL 2", &skl_ddi_pll_funcs,   DPLL_ID_SKL_DPLL2, 0 },
-	{ "DPLL 3", &skl_ddi_pll_funcs,   DPLL_ID_SKL_DPLL3, 0 },
-	{ },
+	{ .name = "DPLL 0", .funcs = &skl_ddi_dpll0_funcs, .id = DPLL_ID_SKL_DPLL0,
+	  .flags = INTEL_DPLL_ALWAYS_ON, },
+	{ .name = "DPLL 1", .funcs = &skl_ddi_pll_funcs, .id = DPLL_ID_SKL_DPLL1, },
+	{ .name = "DPLL 2", .funcs = &skl_ddi_pll_funcs, .id = DPLL_ID_SKL_DPLL2, },
+	{ .name = "DPLL 3", .funcs = &skl_ddi_pll_funcs, .id = DPLL_ID_SKL_DPLL3, },
+	{}
 };
 
 static const struct intel_dpll_mgr skl_pll_mgr = {
@@ -2376,10 +2380,10 @@ static const struct intel_shared_dpll_fu
 };
 
 static const struct dpll_info bxt_plls[] = {
-	{ "PORT PLL A", &bxt_ddi_pll_funcs, DPLL_ID_SKL_DPLL0, 0 },
-	{ "PORT PLL B", &bxt_ddi_pll_funcs, DPLL_ID_SKL_DPLL1, 0 },
-	{ "PORT PLL C", &bxt_ddi_pll_funcs, DPLL_ID_SKL_DPLL2, 0 },
-	{ },
+	{ .name = "PORT PLL A", .funcs = &bxt_ddi_pll_funcs, .id = DPLL_ID_SKL_DPLL0, },
+	{ .name = "PORT PLL B", .funcs = &bxt_ddi_pll_funcs, .id = DPLL_ID_SKL_DPLL1, },
+	{ .name = "PORT PLL C", .funcs = &bxt_ddi_pll_funcs, .id = DPLL_ID_SKL_DPLL2, },
+	{}
 };
 
 static const struct intel_dpll_mgr bxt_pll_mgr = {
@@ -4014,14 +4018,14 @@ static const struct intel_shared_dpll_fu
 };
 
 static const struct dpll_info icl_plls[] = {
-	{ "DPLL 0",   &combo_pll_funcs, DPLL_ID_ICL_DPLL0,  0 },
-	{ "DPLL 1",   &combo_pll_funcs, DPLL_ID_ICL_DPLL1,  0 },
-	{ "TBT PLL",  &tbt_pll_funcs, DPLL_ID_ICL_TBTPLL, 0 },
-	{ "MG PLL 1", &mg_pll_funcs, DPLL_ID_ICL_MGPLL1, 0 },
-	{ "MG PLL 2", &mg_pll_funcs, DPLL_ID_ICL_MGPLL2, 0 },
-	{ "MG PLL 3", &mg_pll_funcs, DPLL_ID_ICL_MGPLL3, 0 },
-	{ "MG PLL 4", &mg_pll_funcs, DPLL_ID_ICL_MGPLL4, 0 },
-	{ },
+	{ .name = "DPLL 0", .funcs = &combo_pll_funcs, .id = DPLL_ID_ICL_DPLL0, },
+	{ .name = "DPLL 1", .funcs = &combo_pll_funcs, .id = DPLL_ID_ICL_DPLL1, },
+	{ .name = "TBT PLL", .funcs = &tbt_pll_funcs, .id = DPLL_ID_ICL_TBTPLL, },
+	{ .name = "MG PLL 1", .funcs = &mg_pll_funcs, .id = DPLL_ID_ICL_MGPLL1, },
+	{ .name = "MG PLL 2", .funcs = &mg_pll_funcs, .id = DPLL_ID_ICL_MGPLL2, },
+	{ .name = "MG PLL 3", .funcs = &mg_pll_funcs, .id = DPLL_ID_ICL_MGPLL3, },
+	{ .name = "MG PLL 4", .funcs = &mg_pll_funcs, .id = DPLL_ID_ICL_MGPLL4, },
+	{}
 };
 
 static const struct intel_dpll_mgr icl_pll_mgr = {
@@ -4035,10 +4039,10 @@ static const struct intel_dpll_mgr icl_p
 };
 
 static const struct dpll_info ehl_plls[] = {
-	{ "DPLL 0", &combo_pll_funcs, DPLL_ID_ICL_DPLL0, 0 },
-	{ "DPLL 1", &combo_pll_funcs, DPLL_ID_ICL_DPLL1, 0 },
-	{ "DPLL 4", &combo_pll_funcs, DPLL_ID_EHL_DPLL4, 0 },
-	{ },
+	{ .name = "DPLL 0", .funcs = &combo_pll_funcs, .id = DPLL_ID_ICL_DPLL0, },
+	{ .name = "DPLL 1", .funcs = &combo_pll_funcs, .id = DPLL_ID_ICL_DPLL1, },
+	{ .name = "DPLL 4", .funcs = &combo_pll_funcs, .id = DPLL_ID_EHL_DPLL4, },
+	{}
 };
 
 static const struct intel_dpll_mgr ehl_pll_mgr = {
@@ -4058,16 +4062,16 @@ static const struct intel_shared_dpll_fu
 };
 
 static const struct dpll_info tgl_plls[] = {
-	{ "DPLL 0", &combo_pll_funcs, DPLL_ID_ICL_DPLL0,  0 },
-	{ "DPLL 1", &combo_pll_funcs, DPLL_ID_ICL_DPLL1,  0 },
-	{ "TBT PLL",  &tbt_pll_funcs, DPLL_ID_ICL_TBTPLL, 0 },
-	{ "TC PLL 1", &dkl_pll_funcs, DPLL_ID_ICL_MGPLL1, 0 },
-	{ "TC PLL 2", &dkl_pll_funcs, DPLL_ID_ICL_MGPLL2, 0 },
-	{ "TC PLL 3", &dkl_pll_funcs, DPLL_ID_ICL_MGPLL3, 0 },
-	{ "TC PLL 4", &dkl_pll_funcs, DPLL_ID_ICL_MGPLL4, 0 },
-	{ "TC PLL 5", &dkl_pll_funcs, DPLL_ID_TGL_MGPLL5, 0 },
-	{ "TC PLL 6", &dkl_pll_funcs, DPLL_ID_TGL_MGPLL6, 0 },
-	{ },
+	{ .name = "DPLL 0", .funcs = &combo_pll_funcs, .id = DPLL_ID_ICL_DPLL0, },
+	{ .name = "DPLL 1", .funcs = &combo_pll_funcs, .id = DPLL_ID_ICL_DPLL1, },
+	{ .name = "TBT PLL", .funcs = &tbt_pll_funcs, .id = DPLL_ID_ICL_TBTPLL, },
+	{ .name = "TC PLL 1", .funcs = &dkl_pll_funcs, .id = DPLL_ID_ICL_MGPLL1, },
+	{ .name = "TC PLL 2", .funcs = &dkl_pll_funcs, .id = DPLL_ID_ICL_MGPLL2, },
+	{ .name = "TC PLL 3", .funcs = &dkl_pll_funcs, .id = DPLL_ID_ICL_MGPLL3, },
+	{ .name = "TC PLL 4", .funcs = &dkl_pll_funcs, .id = DPLL_ID_ICL_MGPLL4, },
+	{ .name = "TC PLL 5", .funcs = &dkl_pll_funcs, .id = DPLL_ID_TGL_MGPLL5, },
+	{ .name = "TC PLL 6", .funcs = &dkl_pll_funcs, .id = DPLL_ID_TGL_MGPLL6, },
+	{}
 };
 
 static const struct intel_dpll_mgr tgl_pll_mgr = {
@@ -4081,10 +4085,10 @@ static const struct intel_dpll_mgr tgl_p
 };
 
 static const struct dpll_info rkl_plls[] = {
-	{ "DPLL 0", &combo_pll_funcs, DPLL_ID_ICL_DPLL0, 0 },
-	{ "DPLL 1", &combo_pll_funcs, DPLL_ID_ICL_DPLL1, 0 },
-	{ "DPLL 4", &combo_pll_funcs, DPLL_ID_EHL_DPLL4, 0 },
-	{ },
+	{ .name = "DPLL 0", .funcs = &combo_pll_funcs, .id = DPLL_ID_ICL_DPLL0, },
+	{ .name = "DPLL 1", .funcs = &combo_pll_funcs, .id = DPLL_ID_ICL_DPLL1, },
+	{ .name = "DPLL 4", .funcs = &combo_pll_funcs, .id = DPLL_ID_EHL_DPLL4, },
+	{}
 };
 
 static const struct intel_dpll_mgr rkl_pll_mgr = {
@@ -4097,11 +4101,11 @@ static const struct intel_dpll_mgr rkl_p
 };
 
 static const struct dpll_info dg1_plls[] = {
-	{ "DPLL 0", &combo_pll_funcs, DPLL_ID_DG1_DPLL0, 0 },
-	{ "DPLL 1", &combo_pll_funcs, DPLL_ID_DG1_DPLL1, 0 },
-	{ "DPLL 2", &combo_pll_funcs, DPLL_ID_DG1_DPLL2, 0 },
-	{ "DPLL 3", &combo_pll_funcs, DPLL_ID_DG1_DPLL3, 0 },
-	{ },
+	{ .name = "DPLL 0", .funcs = &combo_pll_funcs, .id = DPLL_ID_DG1_DPLL0, },
+	{ .name = "DPLL 1", .funcs = &combo_pll_funcs, .id = DPLL_ID_DG1_DPLL1, },
+	{ .name = "DPLL 2", .funcs = &combo_pll_funcs, .id = DPLL_ID_DG1_DPLL2, },
+	{ .name = "DPLL 3", .funcs = &combo_pll_funcs, .id = DPLL_ID_DG1_DPLL3, },
+	{}
 };
 
 static const struct intel_dpll_mgr dg1_pll_mgr = {
@@ -4114,11 +4118,11 @@ static const struct intel_dpll_mgr dg1_p
 };
 
 static const struct dpll_info adls_plls[] = {
-	{ "DPLL 0", &combo_pll_funcs, DPLL_ID_ICL_DPLL0, 0 },
-	{ "DPLL 1", &combo_pll_funcs, DPLL_ID_ICL_DPLL1, 0 },
-	{ "DPLL 2", &combo_pll_funcs, DPLL_ID_DG1_DPLL2, 0 },
-	{ "DPLL 3", &combo_pll_funcs, DPLL_ID_DG1_DPLL3, 0 },
-	{ },
+	{ .name = "DPLL 0", .funcs = &combo_pll_funcs, .id = DPLL_ID_ICL_DPLL0, },
+	{ .name = "DPLL 1", .funcs = &combo_pll_funcs, .id = DPLL_ID_ICL_DPLL1, },
+	{ .name = "DPLL 2", .funcs = &combo_pll_funcs, .id = DPLL_ID_DG1_DPLL2, },
+	{ .name = "DPLL 3", .funcs = &combo_pll_funcs, .id = DPLL_ID_DG1_DPLL3, },
+	{}
 };
 
 static const struct intel_dpll_mgr adls_pll_mgr = {
@@ -4131,14 +4135,14 @@ static const struct intel_dpll_mgr adls_
 };
 
 static const struct dpll_info adlp_plls[] = {
-	{ "DPLL 0", &combo_pll_funcs, DPLL_ID_ICL_DPLL0,  0 },
-	{ "DPLL 1", &combo_pll_funcs, DPLL_ID_ICL_DPLL1,  0 },
-	{ "TBT PLL",  &tbt_pll_funcs, DPLL_ID_ICL_TBTPLL, 0 },
-	{ "TC PLL 1", &dkl_pll_funcs, DPLL_ID_ICL_MGPLL1, 0 },
-	{ "TC PLL 2", &dkl_pll_funcs, DPLL_ID_ICL_MGPLL2, 0 },
-	{ "TC PLL 3", &dkl_pll_funcs, DPLL_ID_ICL_MGPLL3, 0 },
-	{ "TC PLL 4", &dkl_pll_funcs, DPLL_ID_ICL_MGPLL4, 0 },
-	{ },
+	{ .name = "DPLL 0", .funcs = &combo_pll_funcs, .id = DPLL_ID_ICL_DPLL0, },
+	{ .name = "DPLL 1", .funcs = &combo_pll_funcs, .id = DPLL_ID_ICL_DPLL1, },
+	{ .name = "TBT PLL", .funcs = &tbt_pll_funcs, .id = DPLL_ID_ICL_TBTPLL, },
+	{ .name = "TC PLL 1", .funcs = &dkl_pll_funcs, .id = DPLL_ID_ICL_MGPLL1, },
+	{ .name = "TC PLL 2", .funcs = &dkl_pll_funcs, .id = DPLL_ID_ICL_MGPLL2, },
+	{ .name = "TC PLL 3", .funcs = &dkl_pll_funcs, .id = DPLL_ID_ICL_MGPLL3, },
+	{ .name = "TC PLL 4", .funcs = &dkl_pll_funcs, .id = DPLL_ID_ICL_MGPLL4, },
+	{}
 };
 
 static const struct intel_dpll_mgr adlp_pll_mgr = {


