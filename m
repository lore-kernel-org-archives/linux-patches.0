Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E1D61474AF;
	Fri,  6 Dec 2024 14:49:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733496582; cv=none; b=jltr5dzScE6prJCiS2LgKLdFcLT4bM+W9ni2s1fqBDSU6S7sVNMOMweUrtkfZQ0gGJF3ivuIeSqTid5u/pcV7cMs/MIvwTaIkmj9iRfjebKq92362eKjO+0aiX7Nj4LZBGGREX5L11Y8XgXZK/GTTUcLEqguiV9/AkdZAxm6S8g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733496582; c=relaxed/simple;
	bh=rob3UG7Luoio8NoVT942/7SjXGKe3Nt0W67gw9ZioPs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=M7Ny3UjLdhk9S8r2LDll8gXoIS6AC8+3OWkKrs+7ovIMYgYEIrdbQFlaavuVSetN+u5B3LG37SiW4dyLOzZTAL82eqW38IrQqjzqzU6YFKvCwyZ4HuqbqW5LqyG9+4Cq08iqrVb4Iyh8lUmcXF1cRoMzzUXjHLcvbonv1HXQ3FI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MSjOW2Xc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MSjOW2Xc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8AFCFC4CED1;
	Fri,  6 Dec 2024 14:49:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733496581;
	bh=rob3UG7Luoio8NoVT942/7SjXGKe3Nt0W67gw9ZioPs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MSjOW2XceRKPyrtw5RtX99ama8bze4Yi/guqV2EZFpGgfoicAvGNPRXtmqzhPmVOh
	 LzuPtfFcHQ6LZXgMfGCuiEhwynoaxymXv0aHu7OnCFKDv/rkezZSWDo4o0w9EfaBJ1
	 DbS8vUDLrc1W32zZ0WGyEQoPiOfi+0iPFbAo3TlU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Harry Wentland <harry.wentland@amd.com>,
	Jerry Zuo <jerry.zuo@amd.com>,
	Alex Hung <alex.hung@amd.com>,
	Daniel Wheeler <daniel.wheeler@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Xiangyu Chen <xiangyu.chen@windriver.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 039/676] drm/amd/display: Initialize denominators default to 1
Date: Fri,  6 Dec 2024 15:27:38 +0100
Message-ID: <20241206143654.881661950@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241206143653.344873888@linuxfoundation.org>
References: <20241206143653.344873888@linuxfoundation.org>
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

From: Alex Hung <alex.hung@amd.com>

[ Upstream commit b995c0a6de6c74656a0c39cd57a0626351b13e3c ]

[WHAT & HOW]
Variables used as denominators and maybe not assigned to other values,
should not be 0. Change their default to 1 so they are never 0.

This fixes 10 DIVIDE_BY_ZERO issues reported by Coverity.

Reviewed-by: Harry Wentland <harry.wentland@amd.com>
Signed-off-by: Jerry Zuo <jerry.zuo@amd.com>
Signed-off-by: Alex Hung <alex.hung@amd.com>
Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
[Xiangyu: Bp to fix CVE: CVE-2024-49899
Discard the dml2_core/dml2_core_shared.c due to this file no exists]
Signed-off-by: Xiangyu Chen <xiangyu.chen@windriver.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../gpu/drm/amd/display/dc/dml/dcn20/display_rq_dlg_calc_20.c   | 2 +-
 drivers/gpu/drm/amd/display/dc/dml/dml1_display_rq_dlg_calc.c   | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/amd/display/dc/dml/dcn20/display_rq_dlg_calc_20.c b/drivers/gpu/drm/amd/display/dc/dml/dcn20/display_rq_dlg_calc_20.c
index 548cdef8a8ade..543ce9a08cfd3 100644
--- a/drivers/gpu/drm/amd/display/dc/dml/dcn20/display_rq_dlg_calc_20.c
+++ b/drivers/gpu/drm/amd/display/dc/dml/dcn20/display_rq_dlg_calc_20.c
@@ -78,7 +78,7 @@ static void calculate_ttu_cursor(struct display_mode_lib *mode_lib,
 
 static unsigned int get_bytes_per_element(enum source_format_class source_format, bool is_chroma)
 {
-	unsigned int ret_val = 0;
+	unsigned int ret_val = 1;
 
 	if (source_format == dm_444_16) {
 		if (!is_chroma)
diff --git a/drivers/gpu/drm/amd/display/dc/dml/dml1_display_rq_dlg_calc.c b/drivers/gpu/drm/amd/display/dc/dml/dml1_display_rq_dlg_calc.c
index 3df559c591f89..70df992f859d7 100644
--- a/drivers/gpu/drm/amd/display/dc/dml/dml1_display_rq_dlg_calc.c
+++ b/drivers/gpu/drm/amd/display/dc/dml/dml1_display_rq_dlg_calc.c
@@ -39,7 +39,7 @@
 
 static unsigned int get_bytes_per_element(enum source_format_class source_format, bool is_chroma)
 {
-	unsigned int ret_val = 0;
+	unsigned int ret_val = 1;
 
 	if (source_format == dm_444_16) {
 		if (!is_chroma)
-- 
2.43.0



