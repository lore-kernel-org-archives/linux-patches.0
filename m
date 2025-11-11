Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 31B031D86FF;
	Tue, 11 Nov 2025 01:38:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762825120; cv=none; b=D2Zid0lDXWho31xs1zLjnprlhGC5RGotz6NMS8Os4Vpo33tLlHlX7shTd/HQ1TTtec2l2w67BC1nG9j1QtOtruQ24XdK4Sv0AyaakoPTT9TiqUf7tXB6EarAzsiywgfXEEBa+2uy3zhhcO0ooAZdBdSMDs/iwOWpaJzKvNBJdGI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762825120; c=relaxed/simple;
	bh=dCMIo1o94GdAQuUKTKyxzhUxv+JCuHMqlwv5rXD96Us=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oY7fiZFsQ1Nc/TYQF+4xeBirAblEWlm4nKUBbnDwpg1LmcDjNhKaaTBeEMoJvy7eXVHKwGiNNxBhWp8dvrHv+H6Ig8rldfqyyjRd3Dq3GS5Yobfs/oHd+rEtAJHjr+7yD5tzLYGABzt9wDKyY1/ad2W6VHS9cy3BJWyFTW4z8LI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aGZ2EYBy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aGZ2EYBy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C3E80C4CEF5;
	Tue, 11 Nov 2025 01:38:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762825120;
	bh=dCMIo1o94GdAQuUKTKyxzhUxv+JCuHMqlwv5rXD96Us=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=aGZ2EYBy+7sVkft4KytLYdfp7thRfd/D81YQSx6ucK/WNmu3lzAiWc44Z4COgPZ0L
	 ITk4RaUiMY8Xx0x+gyMsyT3Qn/vGIyA7Kl+TqKZAbw7kUdyvv4Z//shLOpo5otrPYr
	 RSRhGYOhAabQqd6+0TZUYoGHBdLVfs2Ryn8unJxg=
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
Subject: [PATCH 6.17 626/849] drm/amd/display: Fix for test crash due to power gating
Date: Tue, 11 Nov 2025 09:43:16 +0900
Message-ID: <20251111004551.568355582@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004536.460310036@linuxfoundation.org>
References: <20251111004536.460310036@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

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
index 9d3946065620a..f7b72b24b7509 100644
--- a/drivers/gpu/drm/amd/display/dc/hwss/dcn20/dcn20_hwseq.c
+++ b/drivers/gpu/drm/amd/display/dc/hwss/dcn20/dcn20_hwseq.c
@@ -3129,7 +3129,8 @@ void dcn20_fpga_init_hw(struct dc *dc)
 		res_pool->dccg->funcs->dccg_init(res_pool->dccg);
 
 	//Enable ability to power gate / don't force power on permanently
-	hws->funcs.enable_power_gating_plane(hws, true);
+	if (hws->funcs.enable_power_gating_plane)
+		hws->funcs.enable_power_gating_plane(hws, true);
 
 	// Specific to FPGA dccg and registers
 	REG_WRITE(RBBMIF_TIMEOUT_DIS, 0xFFFFFFFF);
-- 
2.51.0



