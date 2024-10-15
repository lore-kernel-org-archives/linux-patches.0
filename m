Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8AD6B1C57B1;
	Tue, 15 Oct 2024 12:00:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728993620; cv=none; b=qlD2nZQu1XEjgwRw7a1tjM61kdXttJOKjZ+ebv9tt8CY1q6P1K7d/Tn7MiJDejyvL+SYUSO1k2VxwBKCBhLAdKH+G2ulyEtEulQLA6RYYb08mHolhfxU5AT+XQMxmRaYrg9vr+wjvogrlwagcBF0vGA/Imn6rYrS/VyYxHPTz8k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728993620; c=relaxed/simple;
	bh=CH8U/4OSu9mpBevZJ8mgMpIy+LGUOO7w3XpET534T3g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=u+sw/4kvVlmZqvXaBjtxBL/gLGdvdWXNcDe+aQ0pd1SU/Kvlpo1w4ROG0QlBJ7ehNUFvYpSBRpFZiitOMBijmGvDjEaWJ8oO+PpUSFCYg7HHriToCXaYhe+sxQHBaC6W76Mw6a5wM99XQe6cJcI5yvE6bWgD/ou5ZrxFrBRw14o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wtWnRZph; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wtWnRZph"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ADCC8C4CEC6;
	Tue, 15 Oct 2024 12:00:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728993619;
	bh=CH8U/4OSu9mpBevZJ8mgMpIy+LGUOO7w3XpET534T3g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wtWnRZph7PAj9dOKOuHAo0AHk8naW+9bNH1fvM8+fdHmDTtRBJ6RK0w+tS3gon4vv
	 MjlbppO0r4u3nmJ6TYoIViwOV5gruOLaoUa6XcrKXWTwTROGwC9lVPcS+vZ39KXplT
	 beYT5WKoB2Xe3fund+oeOxmcSP2xMjNSt/DkeD/M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alex Hung <alex.hung@amd.com>,
	Aurabindo Pillai <aurabindo.pillai@amd.com>,
	Daniel Wheeler <daniel.wheeler@amd.com>,
	Rodrigo Siqueira <rodrigo.siqueira@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 466/691] drm/amd/display: Initialize get_bytes_per_elements default to 1
Date: Tue, 15 Oct 2024 13:26:54 +0200
Message-ID: <20241015112458.840274790@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241015112440.309539031@linuxfoundation.org>
References: <20241015112440.309539031@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alex Hung <alex.hung@amd.com>

[ Upstream commit 4067f4fa0423a89fb19a30b57231b384d77d2610 ]

Variables, used as denominators and maybe not assigned to other values,
should not be 0. bytes_per_element_y & bytes_per_element_c are
initialized by get_bytes_per_element() which should never return 0.

This fixes 10 DIVIDE_BY_ZERO issues reported by Coverity.

Signed-off-by: Alex Hung <alex.hung@amd.com>
Reviewed-by: Aurabindo Pillai <aurabindo.pillai@amd.com>
Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Rodrigo Siqueira <rodrigo.siqueira@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../gpu/drm/amd/display/dc/dml/dcn20/display_rq_dlg_calc_20v2.c | 2 +-
 .../gpu/drm/amd/display/dc/dml/dcn21/display_rq_dlg_calc_21.c   | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/amd/display/dc/dml/dcn20/display_rq_dlg_calc_20v2.c b/drivers/gpu/drm/amd/display/dc/dml/dcn20/display_rq_dlg_calc_20v2.c
index 26ececfd40cdc..99b19d1c7e0b0 100644
--- a/drivers/gpu/drm/amd/display/dc/dml/dcn20/display_rq_dlg_calc_20v2.c
+++ b/drivers/gpu/drm/amd/display/dc/dml/dcn20/display_rq_dlg_calc_20v2.c
@@ -78,7 +78,7 @@ static void calculate_ttu_cursor(struct display_mode_lib *mode_lib,
 
 static unsigned int get_bytes_per_element(enum source_format_class source_format, bool is_chroma)
 {
-	unsigned int ret_val = 0;
+	unsigned int ret_val = 1;
 
 	if (source_format == dm_444_16) {
 		if (!is_chroma)
diff --git a/drivers/gpu/drm/amd/display/dc/dml/dcn21/display_rq_dlg_calc_21.c b/drivers/gpu/drm/amd/display/dc/dml/dcn21/display_rq_dlg_calc_21.c
index 736978c4d40a1..9a6d5a6b6748b 100644
--- a/drivers/gpu/drm/amd/display/dc/dml/dcn21/display_rq_dlg_calc_21.c
+++ b/drivers/gpu/drm/amd/display/dc/dml/dcn21/display_rq_dlg_calc_21.c
@@ -53,7 +53,7 @@ static void calculate_ttu_cursor(
 
 static unsigned int get_bytes_per_element(enum source_format_class source_format, bool is_chroma)
 {
-	unsigned int ret_val = 0;
+	unsigned int ret_val = 1;
 
 	if (source_format == dm_444_16) {
 		if (!is_chroma)
-- 
2.43.0



