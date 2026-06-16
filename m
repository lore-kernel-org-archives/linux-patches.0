Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D8BB47798F;
	Tue, 16 Jun 2026 16:36:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781627778; cv=none; b=rRCjmfTgF/8zFpLnuwug749oFH0uNWjtzk/SwMFhFqZuuJLwOCv2lz5Vjz5N/4vbJRIP/jM9HRY/7S/AOv9sGiaw7bxasPYADSeBh0Kq7nO9P+7tVlBepkitbF+4hlJMrkAf9/GYXIZp/VHqwLLay6xJ4OWHMAwfUgK9BCJQ8M8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781627778; c=relaxed/simple;
	bh=uwgrWCaU6Jm3hCZw3cq0F+IJvEPhaL5FtdMDTtxCiq8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZCYNCXBTMI6DSL88aq10wotdCjy3+bh3v4oJ3S+2cetHaQUDDX4IEvX83pklMeIiQ+WSK0mliECWY5EuHC1vp4J0yCDX1OetKHjLXcY0yReqZS8k4MWtg18IDENyd18i3Q6vOUnMmOguTiAN6dvRlWf/6IYImYBTPOn6oaK66kY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fN6tqsZI; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fN6tqsZI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 752FF1F000E9;
	Tue, 16 Jun 2026 16:36:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781627777;
	bh=lhbfTzweo7yeC9ZJyUP6wVHwuxAQAjO8nnnw3Hdcbkw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=fN6tqsZIthui4mo2X2Bsidd46tjTyFVecyg2j6Sshf+G48fLxiWFfq52XYWCMi+8d
	 WdkCJ31eKTGFQBtCYdjr5BeERodA8aG4A4os/7VdYvxxT5nYQVRonIjdXShXMbCiV3
	 GaZ9/6ipVvZFy68Lihc1lO4xbn2zTPVvuSlh7SVk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Leorize <leorize+oss@disroot.org>,
	Alex Hung <alex.hung@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.12 226/261] drm/amd/display: add missing CSC entries for BT.2020 for DCE IPs
Date: Tue, 16 Jun 2026 20:31:04 +0530
Message-ID: <20260616145055.503363264@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145044.869532709@linuxfoundation.org>
References: <20260616145044.869532709@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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


