Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5477386347;
	Tue, 27 May 2025 17:43:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748367830; cv=none; b=SBYY8XNr5q7g+7OUi953pVIp1TvPZexviguXVW2Js+3t/9rAqleRuEsuWn99+V+QsK6TWzTWfIEE9OoILAwx7cBC0CJsWYw5wvJT5qHHC//7envLnJYCtFnKziediatIJYB4OTAo47M97tphvvcZibDTlrz8lL8phRYJcvewfq8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748367830; c=relaxed/simple;
	bh=oG8XYTifS+M3IoNujl7Z3ILD0ERivUYJjxqa5AEysCU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lJ4lYRltjsSQDS1LOosnsBdvBx+e4lGux0y0vqD7KXvGwwR8mV5nB97D2EExRkgWTZTOVi+Rg3Ot1THvIY3orHTMZ3QfPTNylngqPHENO2aPZei1ih4Z74bo7vHhMBpxE5U9VX0CFWOA/EnKc2B8BEIhXX4+AiaAt1JD2y/Koa4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zVxjglNP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zVxjglNP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B1097C4CEE9;
	Tue, 27 May 2025 17:43:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748367830;
	bh=oG8XYTifS+M3IoNujl7Z3ILD0ERivUYJjxqa5AEysCU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zVxjglNP3bY1abs+1zUmgWuOs2VoQ9Ddh9Z8NaAJaU/9K4IWQafAXVCztn6qA3A1N
	 Q7jhiH/NrUA19npG8R8R2SLrpqlj60Mn6Ku+q6n9FMwZiS1G09mBVzbKkjonHEVylm
	 V6mjzXEdyCu66PZ5ZQgOEXT9szpz0Ri0bvUneYWI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Navid Assadian <navid.assadian@amd.com>,
	Samson Tam <Samson.Tam@amd.com>,
	Aurabindo Pillai <aurabindo.pillai@amd.com>,
	Daniel Wheeler <daniel.wheeler@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 482/783] drm/amd/display: remove TF check for LLS policy
Date: Tue, 27 May 2025 18:24:39 +0200
Message-ID: <20250527162532.757402641@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250527162513.035720581@linuxfoundation.org>
References: <20250527162513.035720581@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Samson Tam <Samson.Tam@amd.com>

[ Upstream commit 2a4519c4e9b2e1f622ab4c5f5841abdb9760cb0b ]

[Why & How]
LLS policy not affected by TF.
Remove check in don't care case and use
 pixel format only.

Reviewed-by: Navid Assadian <navid.assadian@amd.com>
Signed-off-by: Samson Tam <Samson.Tam@amd.com>
Signed-off-by: Aurabindo Pillai <aurabindo.pillai@amd.com>
Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/dc/spl/dc_spl.c | 31 +++++----------------
 1 file changed, 7 insertions(+), 24 deletions(-)

diff --git a/drivers/gpu/drm/amd/display/dc/spl/dc_spl.c b/drivers/gpu/drm/amd/display/dc/spl/dc_spl.c
index 153b7a8904e1e..047f05ab01810 100644
--- a/drivers/gpu/drm/amd/display/dc/spl/dc_spl.c
+++ b/drivers/gpu/drm/amd/display/dc/spl/dc_spl.c
@@ -784,25 +784,13 @@ static enum scl_mode spl_get_dscl_mode(const struct spl_in *spl_in,
 	return SCL_MODE_SCALING_420_YCBCR_ENABLE;
 }
 
-static bool spl_choose_lls_policy(enum spl_pixel_format format,
-	enum spl_transfer_func_type tf_type,
-	enum spl_transfer_func_predefined tf_predefined_type,
+static void spl_choose_lls_policy(enum spl_pixel_format format,
 	enum linear_light_scaling *lls_pref)
 {
-	if (spl_is_video_format(format)) {
+	if (spl_is_subsampled_format(format))
 		*lls_pref = LLS_PREF_NO;
-		if ((tf_type == SPL_TF_TYPE_PREDEFINED) ||
-			(tf_type == SPL_TF_TYPE_DISTRIBUTED_POINTS))
-			return true;
-	} else { /* RGB or YUV444 */
-		if ((tf_type == SPL_TF_TYPE_PREDEFINED) ||
-			(tf_type == SPL_TF_TYPE_BYPASS)) {
-			*lls_pref = LLS_PREF_YES;
-			return true;
-		}
-	}
-	*lls_pref = LLS_PREF_NO;
-	return false;
+	else /* RGB or YUV444 */
+		*lls_pref = LLS_PREF_YES;
 }
 
 /* Enable EASF ?*/
@@ -811,7 +799,6 @@ static bool enable_easf(struct spl_in *spl_in, struct spl_scratch *spl_scratch)
 	int vratio = 0;
 	int hratio = 0;
 	bool skip_easf = false;
-	bool lls_enable_easf = true;
 
 	if (spl_in->disable_easf)
 		skip_easf = true;
@@ -827,17 +814,13 @@ static bool enable_easf(struct spl_in *spl_in, struct spl_scratch *spl_scratch)
 		skip_easf = true;
 
 	/*
-	 * If lls_pref is LLS_PREF_DONT_CARE, then use pixel format and transfer
-	 *  function to determine whether to use LINEAR or NONLINEAR scaling
+	 * If lls_pref is LLS_PREF_DONT_CARE, then use pixel format
+	 *  to determine whether to use LINEAR or NONLINEAR scaling
 	 */
 	if (spl_in->lls_pref == LLS_PREF_DONT_CARE)
-		lls_enable_easf = spl_choose_lls_policy(spl_in->basic_in.format,
-			spl_in->basic_in.tf_type, spl_in->basic_in.tf_predefined_type,
+		spl_choose_lls_policy(spl_in->basic_in.format,
 			&spl_in->lls_pref);
 
-	if (!lls_enable_easf)
-		skip_easf = true;
-
 	/* Check for linear scaling or EASF preferred */
 	if (spl_in->lls_pref != LLS_PREF_YES && !spl_in->prefer_easf)
 		skip_easf = true;
-- 
2.39.5



