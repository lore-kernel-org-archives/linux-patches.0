Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F7A833688F;
	Tue, 16 Jun 2026 16:11:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781626297; cv=none; b=kpZUsMcUx2tOu0B2O7awZf2r5sq/m7NikJ672faiGJZ7QMmBizpoSY2Ym6d6nFVENy5NuPiLrxgidUQkjkoz2J7OTS8tYvce1qNLWwFwb6gwXasOuEaEz4mYNnOmO77+8MosDFnZBo4+07ytsmNCBAOPYgm0yFqgupMd1KeRiGc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781626297; c=relaxed/simple;
	bh=MiKL/U7LHuc1wDulqXreuzc2c4Vv7KfScloidDszlrk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=joorcnVKp9y8LEAEFvRPrY1i1PD743I9hPeUQUsDaKsYliwEbxtsnoO939d5FdzSuvPNs6GodiBEGRi5mP47LIOvi/+1oxdZ1F4LDLlP+uSweFuiNIC1z6RrNacWk5H9hkeOsFbETYalw56UpxMgx4EAOkGlFvHg8LdpWNU+1N0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yuZzsw98; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yuZzsw98"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 110551F000E9;
	Tue, 16 Jun 2026 16:11:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781626296;
	bh=4w6WT6TTACHoeJtvIhMyqZxJn4YUS9G1cJJ2aroN6a4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=yuZzsw98tw66mV/dz4Qji9d4ifravMAwmDspa6XKQ/I/yMiH2+ntVGNdVnEWn/Uf4
	 CLJTiSQTAryzgTD19lWhE3ijAEcvXX4V8VT+NXkQAeEsMe9u/rduoBl1o+qF9Sbo7s
	 uEyooRZFO/A7rZ2KKvli2sdm7qOHrB4Tqm8C8lGA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Leorize <leorize+oss@disroot.org>,
	Alex Hung <alex.hung@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.18 300/325] drm/amd/display: add missing CSC entries for BT.2020 for DCE IPs
Date: Tue, 16 Jun 2026 20:31:36 +0530
Message-ID: <20260616145113.877235221@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145057.827196531@linuxfoundation.org>
References: <20260616145057.827196531@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Leorize <leorize+oss@disroot.org>

commit 6590fe323ce2807f5d9454e7fccf3fab875d4352 upstream.

DCE-based hardware does not have the CSC matrices for BT.2020, which
causes the driver to fallback to the GPU built-in matrices. This does
not appear to cause any issues for RGB sinks, but causes major color
artifacts for YCbCr ones (e.g. black becomes green).

This commit adds the missing CSC matrices (taken from DC common) to DCE
CSC tables, resolving the issue.

Closes: https://gitlab.freedesktop.org/drm/amd/-/work_items/3358
Closes: https://gitlab.freedesktop.org/drm/amd/-/work_items/5333
Assisted-by: oh-my-pi:GPT-5.5
Signed-off-by: Leorize <leorize+oss@disroot.org>
Reviewed-by: Alex Hung <alex.hung@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit 51e6668ab4baf55b082c376318d51ef965757196)
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/display/dc/dce/dce_transform.c       |   10 +++++++++-
 drivers/gpu/drm/amd/display/dc/dce110/dce110_opp_csc_v.c |   10 +++++++++-
 2 files changed, 18 insertions(+), 2 deletions(-)

--- a/drivers/gpu/drm/amd/display/dc/dce/dce_transform.c
+++ b/drivers/gpu/drm/amd/display/dc/dce/dce_transform.c
@@ -110,7 +110,15 @@ static const struct out_csc_color_matrix
 { COLOR_SPACE_YCBCR601_LIMITED, { 0xE00, 0xF447, 0xFDB9, 0x1000, 0x991,
 	0x12C9, 0x3A6, 0x200, 0xFB47, 0xF6B9, 0xE00, 0x1000} },
 { COLOR_SPACE_YCBCR709_LIMITED, { 0xE00, 0xF349, 0xFEB7, 0x1000, 0x6CE, 0x16E3,
-	0x24F, 0x200, 0xFCCB, 0xF535, 0xE00, 0x1000} }
+	0x24F, 0x200, 0xFCCB, 0xF535, 0xE00, 0x1000} },
+{ COLOR_SPACE_2020_RGB_FULLRANGE,
+	{ 0x2000, 0, 0, 0, 0, 0x2000, 0, 0, 0, 0, 0x2000, 0} },
+{ COLOR_SPACE_2020_RGB_LIMITEDRANGE,
+	{ 0x1B67, 0, 0, 0x201, 0, 0x1B67, 0, 0x201, 0, 0, 0x1B67, 0x201} },
+{ COLOR_SPACE_2020_YCBCR_LIMITED, { 0x1000, 0xF149, 0xFEB7, 0x1004, 0x0868,
+	0x15B2, 0x01E6, 0x201, 0xFB88, 0xF478, 0x1000, 0x1004} },
+{ COLOR_SPACE_2020_YCBCR_FULL, { 0x1000, 0xF149, 0xFEB7, 0x1004, 0x0868, 0x15B2,
+	0x01E6, 0x201, 0xFB88, 0xF478, 0x1000, 0x1004} }
 };
 
 static bool setup_scaling_configuration(
--- a/drivers/gpu/drm/amd/display/dc/dce110/dce110_opp_csc_v.c
+++ b/drivers/gpu/drm/amd/display/dc/dce110/dce110_opp_csc_v.c
@@ -88,7 +88,15 @@ static const struct out_csc_color_matrix
 { COLOR_SPACE_YCBCR601_LIMITED, { 0xE00, 0xF447, 0xFDB9, 0x1000, 0x991,
 	0x12C9, 0x3A6, 0x200, 0xFB47, 0xF6B9, 0xE00, 0x1000} },
 { COLOR_SPACE_YCBCR709_LIMITED, { 0xE00, 0xF349, 0xFEB7, 0x1000, 0x6CE, 0x16E3,
-	0x24F, 0x200, 0xFCCB, 0xF535, 0xE00, 0x1000} }
+	0x24F, 0x200, 0xFCCB, 0xF535, 0xE00, 0x1000} },
+{ COLOR_SPACE_2020_RGB_FULLRANGE,
+	{ 0x2000, 0, 0, 0, 0, 0x2000, 0, 0, 0, 0, 0x2000, 0} },
+{ COLOR_SPACE_2020_RGB_LIMITEDRANGE,
+	{ 0x1B67, 0, 0, 0x201, 0, 0x1B67, 0, 0x201, 0, 0, 0x1B67, 0x201} },
+{ COLOR_SPACE_2020_YCBCR_LIMITED, { 0x1000, 0xF149, 0xFEB7, 0x1004, 0x0868,
+	0x15B2, 0x01E6, 0x201, 0xFB88, 0xF478, 0x1000, 0x1004} },
+{ COLOR_SPACE_2020_YCBCR_FULL, { 0x1000, 0xF149, 0xFEB7, 0x1004, 0x0868, 0x15B2,
+	0x01E6, 0x201, 0xFB88, 0xF478, 0x1000, 0x1004} }
 };
 
 enum csc_color_mode {


