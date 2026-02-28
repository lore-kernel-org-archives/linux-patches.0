Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB7A4340A47
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 17:50:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772301006; cv=none; b=gSPVz/afbvL/j7xqXyWQlVME8V50o4/+c4RvEVE9/a8PKZ5twEe+kQIq4FTvbKehwJ92x1tBR4WwXeB4oSrabP98JBcXoQULkkRDbdKDDZqCKblzVop9jzddiaryiUcZ8bcA4NJ1Q5XqRDg5Kr6pDkVxtV+wZCRgfLCcJZVOt3Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772301006; c=relaxed/simple;
	bh=+BD+VqCL1KobxZUL+46hf9GFYvMskfP7sXjdXJA9VnY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pHUu23OYFhGWtIREyGRQCE8X0k7NuWyroxpAdpvKgUa21rMMd6EKELK+1q09oYMAd1PR0rajzV6FvqofsX1vz087Fa+C91rHYtb1dWpqvR0WVc4Ma95hBi8mW+JnvqrBDfdY60rOxxCG0B0pnEh/gdbEzSIMK0CV9P/01tXZIM0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=kKmzqCIE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="kKmzqCIE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E39A8C116D0;
	Sat, 28 Feb 2026 17:50:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772301006;
	bh=+BD+VqCL1KobxZUL+46hf9GFYvMskfP7sXjdXJA9VnY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kKmzqCIENoFzPbGcFoOdc2nDSUnwbH90uT1AqAk64VeMBYtyMVFA+f0nkNE/jbOjY
	 el2gu8OVh8ifFR1urtiaS2yPTSD9Qzdzc25MGHCGh64he3hFO1LSu90EuKpbgx335N
	 LgwoqFTwj/I3XeRLu1Kb1SmRP1ShCwuoVt8dNA2rPBgENhwhP6NWlGt/NF4bJubaNW
	 LQhNV+ZAoZi5zgWc96ae9PreThM/bIwZAfphhMvOX56dLhnUqJn6uU9z6lOLHCl/Ya
	 tFXVStYB4fnC5yKlOKWajdxzB0/sBF6x+HwbbncAWMuT3gugYeYGlzWaZvojh09hPQ
	 8/WrDZOXuoDvg==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Dmytro Laktyushkin <dmytro.laktyushkin@amd.com>,
	Charlene Liu <charlene.liu@amd.com>,
	Chenyu Chen <chen-yu.chen@amd.com>,
	Daniel Wheeler <daniel.wheeler@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 140/752] drm/amd/display: Add signal type check for dcn401 get_phyd32clk_src
Date: Sat, 28 Feb 2026 12:37:31 -0500
Message-ID: <20260228174750.1542406-140-sashal@kernel.org>
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

From: Dmytro Laktyushkin <dmytro.laktyushkin@amd.com>

[ Upstream commit c979d8db7b0f293111f2e83795ea353c8ed75de9 ]

Trying to access link enc on a dpia link will cause a crash otherwise

Reviewed-by: Charlene Liu <charlene.liu@amd.com>
Signed-off-by: Dmytro Laktyushkin <dmytro.laktyushkin@amd.com>
Signed-off-by: Chenyu Chen <chen-yu.chen@amd.com>
Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/dc/hwss/dcn401/dcn401_hwseq.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/gpu/drm/amd/display/dc/hwss/dcn401/dcn401_hwseq.c b/drivers/gpu/drm/amd/display/dc/hwss/dcn401/dcn401_hwseq.c
index bbfefc9edd1f1..483217a91029a 100644
--- a/drivers/gpu/drm/amd/display/dc/hwss/dcn401/dcn401_hwseq.c
+++ b/drivers/gpu/drm/amd/display/dc/hwss/dcn401/dcn401_hwseq.c
@@ -914,10 +914,10 @@ static void dcn401_enable_stream_calc(
 			pipe_ctx->stream->link->cur_link_settings.lane_count;
 	uint32_t active_total_with_borders;
 
-	if (dc->link_srv->dp_is_128b_132b_signal(pipe_ctx))
+	if (dc->link_srv->dp_is_128b_132b_signal(pipe_ctx)) {
 		*dp_hpo_inst = pipe_ctx->stream_res.hpo_dp_stream_enc->inst;
-
-	*phyd32clk = get_phyd32clk_src(pipe_ctx->stream->link);
+		*phyd32clk = get_phyd32clk_src(pipe_ctx->stream->link);
+	}
 
 	if (dc_is_tmds_signal(pipe_ctx->stream->signal))
 		dcn401_calculate_dccg_tmds_div_value(pipe_ctx, tmds_div);
-- 
2.51.0

