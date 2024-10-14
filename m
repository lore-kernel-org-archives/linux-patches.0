Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 42B0C1B0137;
	Mon, 14 Oct 2024 15:17:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728919064; cv=none; b=nL3CkTZfOfedaf671RvNGrIUFNHl1pU1Nu/G1H2y7TXQRVTEitLZShAYP+MKCul4/n6ZiWnvCTO7+RPxsjndv/2Kp4Od4eZP9DgTfG8AO5oi4/frJiwzlYnw72jA3YtHZCc1+O7gkd/lj/4VE3hngD/uHxUtnirZ1Peo8tctRwU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728919064; c=relaxed/simple;
	bh=sD7KQ+FYzNhMg5wsnmnegd9cK7vnlZ0DVJJrdLAI77Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UMbw5Lk0vEgaMVBfct1thmen5OFKTy3gFwJ1eqtgaYAs62dCRsf9K/IFM71WMTs+vEh8eE9EqnFFJAY5gpdmOgU1xr4hGqI/Z1bzfbkqwTZWSDURt4CwfBL6UhcljqMXLE5fKRXhSwZH97daTPdXvIHAF9VOUDAfwOs+GtQcpqA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ehWbBow7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ehWbBow7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5A08BC4CEC3;
	Mon, 14 Oct 2024 15:17:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728919063;
	bh=sD7KQ+FYzNhMg5wsnmnegd9cK7vnlZ0DVJJrdLAI77Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ehWbBow7XZ5Ztmwttb72pDvyCU7/2tb+9VkQFdynCwb54ETCeeilJtKbRDQgpjeVC
	 nQuMTjE4UY1qx2iVCSdFwHcQRujwRSC3pVYznIVt/SB1jBMerhvyXNMVe77HHAbvig
	 6Dm6x2zv8LtMw40xogfCIJQip379JM2K63pAaUK8=
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
Subject: [PATCH 6.1 495/798] drm/amd/display: Initialize get_bytes_per_elements default to 1
Date: Mon, 14 Oct 2024 16:17:29 +0200
Message-ID: <20241014141237.418317857@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241014141217.941104064@linuxfoundation.org>
References: <20241014141217.941104064@linuxfoundation.org>
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
index 0fc9f3e3ffaef..f603486af6e30 100644
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
index 618f4b682ab1b..9f28e4d3c664c 100644
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



