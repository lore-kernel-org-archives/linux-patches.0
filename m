Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6038531280A;
	Mon, 13 Oct 2025 15:11:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760368263; cv=none; b=k+CsdOL3AhRZjMBOfbMXXcmRgkGhqFXJwaxSC3hUxgJos9zgpcX2nwUhSf05y3lh2O55VHg7YiQr5I7j2yL5zp9TPqedhnrEFFJkWbNU4g9k1IM7zwZ3NHo/6p306bGVdafVPGxkB2z9GzS/eqm0bHWFz087IP4njjMhRlruy9Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760368263; c=relaxed/simple;
	bh=sCKT9uHxbbqYTVPZr2on4IgKwapgcfQhn003v96NR4Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RTbRHZM8MQoP4vZISpAlLgarLy9fs7ovwLZvVNNiS88xKO3UMcnQns78GJILywxh9YDAUqimNQ+oi+15EBQhHRG0+t4uMFfgbQML4txkzXfDudRVSHapFm6hK7jrdMEZZIE8dEg8rTNXJ2C10paXA8cnbsWzO8qA/VuuSvuo+2k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=v+UZVupF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="v+UZVupF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E56AEC4CEE7;
	Mon, 13 Oct 2025 15:11:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760368263;
	bh=sCKT9uHxbbqYTVPZr2on4IgKwapgcfQhn003v96NR4Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=v+UZVupFAucCq+rl8pcfwFhtmCVht3OX4rIxeCkIrpQyQ/La3GjuB5An/lW3JmKTv
	 JhO7UuiGarZg2wibJcI++qt0cSxXC0hoxF2PLgkZxK2rIxDQUvt90ogWOvpcJzj5vX
	 DQO90D4mh0LguuGUY/6jVK1taPrsGlHP1L1qZwbw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Liao Yuanhong <liaoyuanhong@vivo.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 099/262] drm/amd/display: Remove redundant semicolons
Date: Mon, 13 Oct 2025 16:44:01 +0200
Message-ID: <20251013144329.696350017@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251013144326.116493600@linuxfoundation.org>
References: <20251013144326.116493600@linuxfoundation.org>
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

From: Liao Yuanhong <liaoyuanhong@vivo.com>

[ Upstream commit 90b810dd859c0df9db2290da1ac5842e5f031267 ]

Remove unnecessary semicolons.

Fixes: dda4fb85e433 ("drm/amd/display: DML changes for DCN32/321")
Signed-off-by: Liao Yuanhong <liaoyuanhong@vivo.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../gpu/drm/amd/display/dc/dml/dcn32/display_rq_dlg_calc_32.c    | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/display/dc/dml/dcn32/display_rq_dlg_calc_32.c b/drivers/gpu/drm/amd/display/dc/dml/dcn32/display_rq_dlg_calc_32.c
index 9ba6cb67655f4..6c75aa82327ac 100644
--- a/drivers/gpu/drm/amd/display/dc/dml/dcn32/display_rq_dlg_calc_32.c
+++ b/drivers/gpu/drm/amd/display/dc/dml/dcn32/display_rq_dlg_calc_32.c
@@ -139,7 +139,6 @@ void dml32_rq_dlg_get_rq_reg(display_rq_regs_st *rq_regs,
 	if (dual_plane) {
 		unsigned int p1_pte_row_height_linear = get_dpte_row_height_linear_c(mode_lib, e2e_pipe_param,
 				num_pipes, pipe_idx);
-		;
 		if (src->sw_mode == dm_sw_linear)
 			ASSERT(p1_pte_row_height_linear >= 8);
 
-- 
2.51.0



