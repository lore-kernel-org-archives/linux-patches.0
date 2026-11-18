Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795017052;
	b=Y9E/wY9eYsO9jPY6PEsQVXmAsRPVXzcSjbmEGIUgjwqWK8Uk8AlTWirfBB/SZqs6u6jF
	 R+XKJJW8BoZnUYxd5G1LkGSyen5RbNSbpaK/2rlrnAZUnjzaW4kwx0zaouYj8j5+1Uiay
	 h/hpAX4tPwQF4gkVVq55fdRXXvXPOodl60TFhCT81xUghSpNCfbVwbI2TgObU/e3Y8gM0
	 TABFvxh8aAnUUpMEz63mYIGeFBsI/jtsuOg/n/ghh4Gna7oc19riA/wcMPoiNkaVY6qhP
	 cPP8LjLdjRLoq2qdXwU69RieCQ8UH5MJOcQxXA/p9T/v/3z6qpgoKsGAXF81TtBEE3g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795017052;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=T8uJ/MHG5mcL0qIUHPxpQqhYCInoQC4NP8i/vPoGhSE=;
	b=Em175Ono+01zV9xTo6P/8cfJeW4cN/CqLqK8o0fCxyFxq/Kc/Gi+GNc5sqRPnAS4JIlu
	 qhSBloIIhmvhTgRMGnj4Wlrzzf+iFlxflY71nfsYR0NXpl8yX+0OqI4HMckJfcrI7yDL3
	 M2SBR5vEmtT/N2DpgXqfUM2mJHKVoA5QvXIJ9H4/CgmCf0dkL/z5tepK7Aqa9vKDFvnTg
	 OA2Fet7PE5LFy7rjmm9YDxvdWTJlL8AlFVOG+y6nnIaqWneCmYB8xZn8T2t00BrvEcmXL
	 pSqwuig0y4Vi9acwdhK6WIIjxoQeh+aPf9C3JdPHSesnst5yDwJGggRgXeLHznxTMsA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=eoDLgmq8;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 506CD606A31C;
	Wed, 18 Nov 2026 15:50:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=eoDLgmq8
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B018B1F000C4;
	Wed, 18 Nov 2026 15:50:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795017052;
	bh=T8uJ/MHG5mcL0qIUHPxpQqhYCInoQC4NP8i/vPoGhSE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=eoDLgmq8R6TdPdezC1Ctoax76dlwb1KP+QHDaShXCYNNjcTy2u5Dh43L8BHoZB6OC
	 kACbMynJP9nA3ewkJI7h7Yveah28lUcuW7tpf4FXq6gBmhlFfP/iwOoHG74IHnU6Nb
	 JjPPMct6ov/IRIAaUUZB/AnJEA/1d8q3pdiKlmhI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <error27@gmail.com>,
	Aurabindo Pillai <aurabindo.pillai@amd.com>,
	Roman Li <Roman.Li@amd.com>,
	Ivan Lipski <ivan.lipski@amd.com>,
	Dan Wheeler <daniel.wheeler@amd.com>,
	Alex Hung <alex.hung@amd.com>,
	Tom Chung <chiahsuan.chung@amd.com>,
	Srinivasan Shanmugam <srinivasan.shanmugam@amd.com>,
	Fangzhi Zuo <jerry.zuo@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0748/2651] drm/amd/display: Fix null deref of link_enc in dce110_enable_tmds_link_output
Date: Wed, 18 Nov 2026 15:33:08 +0100
Message-ID: <20261118150314.808149094@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Srinivasan Shanmugam <srinivasan.shanmugam@amd.com>

[ Upstream commit b51576a5d53eaf53e07b07c4841f6981e542b63c ]

Smatch reports that link->link_enc is unconditionally dereferenced at
the top of dce110_enable_tmds_link_output() while the later
setup_ri_pj_check_in_sw_or_hw_mode calls guard against it being NULL,
making those checks contradictory.

Add an early return when link_enc is NULL and drop the redundant NULL
checks from the two call sites that follow, since link_enc is guaranteed
non-NULL past the guard

Fixes: 992694ad2858 ("drm/amd/display: Enable DCN6 sources compilation")
Reported-by: Dan Carpenter <error27@gmail.com>
Cc: Aurabindo Pillai <aurabindo.pillai@amd.com>
Cc: Roman Li <Roman.Li@amd.com>
Cc: Ivan Lipski <ivan.lipski@amd.com>
Cc: Dan Wheeler <daniel.wheeler@amd.com>
Cc: Alex Hung <alex.hung@amd.com>
Cc: Tom Chung <chiahsuan.chung@amd.com>
Signed-off-by: Srinivasan Shanmugam <srinivasan.shanmugam@amd.com>
Reviewed-by: Alex Hung <alex.hung@amd.com>
Reviewed-by: Fangzhi Zuo <jerry.zuo@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/dc/hwss/dce110/dce110_hwseq.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/amd/display/dc/hwss/dce110/dce110_hwseq.c b/drivers/gpu/drm/amd/display/dc/hwss/dce110/dce110_hwseq.c
index e081f795f4f71..f974968af21b2 100644
--- a/drivers/gpu/drm/amd/display/dc/hwss/dce110/dce110_hwseq.c
+++ b/drivers/gpu/drm/amd/display/dc/hwss/dce110/dce110_hwseq.c
@@ -3487,6 +3487,10 @@ void dce110_enable_tmds_link_output(struct dc_link *link,
 		uint32_t pixel_clock)
 {
 	(void)link_res;
+
+	if (!link->link_enc)
+		return;
+
 	link->link_enc->funcs->enable_tmds_output(
 			link->link_enc,
 			clock_source,
@@ -3497,12 +3501,12 @@ void dce110_enable_tmds_link_output(struct dc_link *link,
 
 	// For dongle Type 2 with no I2C support on board, setup sw mode of Ri/Pj check with proper aux instance
 	if (link->force_to_use_aux) {
-		if (link->link_enc && link->link_enc->funcs->setup_ri_pj_check_in_sw_or_hw_mode)
+		if (link->link_enc->funcs->setup_ri_pj_check_in_sw_or_hw_mode)
 			link->link_enc->funcs->setup_ri_pj_check_in_sw_or_hw_mode(link->link_enc,
 				link->aux_hw_inst, true);
 	} else
 		// For HDMI setup hw mode of Ri/Pj check with proper ddc pin instance
-		if (link->link_enc && link->link_enc->funcs->setup_ri_pj_check_in_sw_or_hw_mode)
+		if (link->link_enc->funcs->setup_ri_pj_check_in_sw_or_hw_mode)
 			link->link_enc->funcs->setup_ri_pj_check_in_sw_or_hw_mode(link->link_enc,
 				link->ddc_hw_inst, false);
 }
-- 
2.53.0



