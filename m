Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3FEED1D86FF;
	Tue, 11 Nov 2025 01:23:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762824231; cv=none; b=kZ7+fMOyhAovjbr27ZpKNVEWmfcLgGAd3RDX1vsUYWKi4j/AfwciRq7AGyW4r/Q4lV3lxMIbyH5wfAMOHuKiZvNVZd+hucNJqeivFYBG1B+SgtUCi6gNyBF21XRpJI4hmp8XhCnIxKDL71GDhY20A0uDxq8ieZgQm/havgAKT78=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762824231; c=relaxed/simple;
	bh=O25uRdn8PHlDkGlnMyQTJ7i97k0Y/wKHUExqjdiUDug=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rnBb92LiMRHyLiP8SN9oKZmqdOKdNapAIsC4Gz0GoWwX+Wp9EAXnnnpZbFuoF0UFqyktc4G+VrL0/t4kvvA/rDr1H+ZMv/SNU3NMb5R/jxY/RUr8510JdPCDB6U3Xs6solKewQYAk0sY7TxadeQ3mnkWlv1pC3vyzucJ45kJg8E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ES5nLR31; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ES5nLR31"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D1E4AC4CEF5;
	Tue, 11 Nov 2025 01:23:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762824231;
	bh=O25uRdn8PHlDkGlnMyQTJ7i97k0Y/wKHUExqjdiUDug=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ES5nLR31EuDwGA7dE1cG/W0JVpAgvzEej7tX3hx19avgmV/qYADke3lBy+0TNGZ9J
	 qKEzgLWm48/rl6mIHb3vAx5Fun4A0liwtpvt6X24Sx065A2MRvfX+D/i0yk91LwCl6
	 SwFHXPwoI/5K+hctE6fGrJV5715ANcFjfZN9lFyg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alvin Lee <alvin.lee2@amd.com>,
	Sridevi Arvindekar <sarvinde@amd.com>,
	Ivan Lipski <ivan.lipski@amd.com>,
	Dan Wheeler <daniel.wheeler@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 415/565] drm/amd/display: Fix for test crash due to power gating
Date: Tue, 11 Nov 2025 09:44:31 +0900
Message-ID: <20251111004536.201533753@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004526.816196597@linuxfoundation.org>
References: <20251111004526.816196597@linuxfoundation.org>
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

From: Sridevi Arvindekar <sarvinde@amd.com>

[ Upstream commit 0bf6b216d4783cb51f9af05a49d3cce4fc22dc24 ]

[Why/How]
Call power gating routine only if it is defined.

Reviewed-by: Alvin Lee <alvin.lee2@amd.com>
Signed-off-by: Sridevi Arvindekar <sarvinde@amd.com>
Signed-off-by: Ivan Lipski <ivan.lipski@amd.com>
Tested-by: Dan Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/dc/hwss/dcn20/dcn20_hwseq.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/display/dc/hwss/dcn20/dcn20_hwseq.c b/drivers/gpu/drm/amd/display/dc/hwss/dcn20/dcn20_hwseq.c
index 55f067c9e4948..8a1ba78c27f97 100644
--- a/drivers/gpu/drm/amd/display/dc/hwss/dcn20/dcn20_hwseq.c
+++ b/drivers/gpu/drm/amd/display/dc/hwss/dcn20/dcn20_hwseq.c
@@ -3086,7 +3086,8 @@ void dcn20_fpga_init_hw(struct dc *dc)
 		res_pool->dccg->funcs->dccg_init(res_pool->dccg);
 
 	//Enable ability to power gate / don't force power on permanently
-	hws->funcs.enable_power_gating_plane(hws, true);
+	if (hws->funcs.enable_power_gating_plane)
+		hws->funcs.enable_power_gating_plane(hws, true);
 
 	// Specific to FPGA dccg and registers
 	REG_WRITE(RBBMIF_TIMEOUT_DIS, 0xFFFFFFFF);
-- 
2.51.0



