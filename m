Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7AF4963BB
	for <patches@lists.linux.dev>; Mon, 20 Feb 2023 13:59:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 010E4C433EF;
	Mon, 20 Feb 2023 13:59:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1676901559;
	bh=4KLMRmXFwHw9jfP/NyiuIHUrBIS0EUbyrDRrdI25NpA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YxtfzegcaJ94SomR16GLTvqLr6/jCddHv6Umi2tk8mblw0Vq+0KiwBNKOccrJxDA7
	 wmGfh0SaQM4i4a+z/3S2lrKp9efGNiNPpqx7tvFC32aPV00xF+GIQcNCSydYQhE0aK
	 BFuAmn8cm5MlanQpE+sgaG62p1IfznQ5p+7CyEP4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alvin Lee <Alvin.Lee2@amd.com>,
	Alex Hung <alex.hung@amd.com>,
	George Shen <george.shen@amd.com>,
	Daniel Wheeler <daniel.wheeler@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 035/118] drm/amd/display: Unassign does_plane_fit_in_mall function from dcn3.2
Date: Mon, 20 Feb 2023 14:35:51 +0100
Message-Id: <20230220133601.831941764@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230220133600.368809650@linuxfoundation.org>
References: <20230220133600.368809650@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: George Shen <george.shen@amd.com>

[ Upstream commit 275d8a1db261a1272a818d40ebc61b3b865b60e5 ]

[Why]
The hwss function does_plane_fit_in_mall not applicable to dcn3.2 asics.
Using it with dcn3.2 can result in undefined behaviour.

[How]
Assign the function pointer to NULL.

Reviewed-by: Alvin Lee <Alvin.Lee2@amd.com>
Acked-by: Alex Hung <alex.hung@amd.com>
Signed-off-by: George Shen <george.shen@amd.com>
Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/dc/dcn32/dcn32_init.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/display/dc/dcn32/dcn32_init.c b/drivers/gpu/drm/amd/display/dc/dcn32/dcn32_init.c
index 45a949ba6f3f3..7b7f0e6b2a2ff 100644
--- a/drivers/gpu/drm/amd/display/dc/dcn32/dcn32_init.c
+++ b/drivers/gpu/drm/amd/display/dc/dcn32/dcn32_init.c
@@ -94,7 +94,7 @@ static const struct hw_sequencer_funcs dcn32_funcs = {
 	.get_vupdate_offset_from_vsync = dcn10_get_vupdate_offset_from_vsync,
 	.calc_vupdate_position = dcn10_calc_vupdate_position,
 	.apply_idle_power_optimizations = dcn32_apply_idle_power_optimizations,
-	.does_plane_fit_in_mall = dcn30_does_plane_fit_in_mall,
+	.does_plane_fit_in_mall = NULL,
 	.set_backlight_level = dcn21_set_backlight_level,
 	.set_abm_immediate_disable = dcn21_set_abm_immediate_disable,
 	.hardware_release = dcn30_hardware_release,
-- 
2.39.0



