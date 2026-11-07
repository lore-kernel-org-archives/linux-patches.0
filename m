Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794063716;
	b=4FKDHqCCCW1Iu3a3fTIko6fYKTnSJWew0LQSL+oAvo4LYFdyphQqwsOlj7P8B/LmwxUB
	 FINhTzt4th2u/z/CWNtsEcuULEO5RG+vjkq6vzE/0iVCyMg3jmQudpHV5n+5TUIs5e54A
	 2baSkeCQS5RKMfS1+hAYKr8wUpSnNoqhXg+fAUo6ZQxqvLtrMugTYXKsbE4AN1Wbpu7wv
	 wRPTtD3SlbU0L3aPczTKg6HHOSdKC1HLeRB/NflFykw9eCkVajq0ItF0IVLu+/NHdUjKd
	 5phcqwcFSQMKwpabLVR5zHkJUyljsG8pbwuMrYvzVGrKV/dRpFJx1jm4eiwkDErSEKQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794063716;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=fRhzJfqiid+6Ywsw1qHSovfHvn63J+YFZSrzAbX6/oM=;
	b=EGOLDeIpNQ03TjCRaElEMyjvjD7zct6mbk2XFEaUgr8Wic+0jauoRxmLDK+M2Z2Np3Ai
	 6kpxbwmzMZv4ud/ce62yXuui/0RtX4DR2ju0y9pHEvJxWj3dxQBs0H17unZ1pYnzcKGNa
	 pSenehrVLOHgiWv8WWNX5Ylj8ikZxo5R0aE+yHmWu5CIpPK1QeQ7oVIeHCBIqvSgPo8N0
	 HuLjF8Pn3dGzzWX2As8Jsgf1XQiOuf8L1EnJdIFXEH2oeFM5ESwv5kSWewhlFCs0Vqe8/
	 R9zVl3+61mD2drlwGKETb+CDmrPzBBBn7WyjRf9lusSiqIh+u3K+SbxUTb49+JlvTrQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Sik0ko03;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C532606A32E;
	Sat,  7 Nov 2026 15:01:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Sik0ko03
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4F7FF1F0089F;
	Sat,  7 Nov 2026 15:01:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794063716;
	bh=fRhzJfqiid+6Ywsw1qHSovfHvn63J+YFZSrzAbX6/oM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Sik0ko03bgOMb2ShmZeXdLT7jxI51OqDH15KX5XvKFGt4345Y8KC2Xtbs/TZq62dP
	 H9CKAE5TYvStAQG7lUW0mhrno68luWSIsUUa0Adl01bvHg1ZEG2nbut0Xu0OP83ml8
	 KapYHx6lYjl8H1GJze9Jf7fLD/Svn7CoArJ4y1hU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Avi Weiss <thnkslprpt@gmail.com>,
	Ray Wu <ray.wu@amd.com>,
	Harry Wentland <harry.wentland@amd.com>,
	Daniel Wheeler <daniel.wheeler@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 817/869] drm/amd/display: Initialize missing TD-LUT programming inputs
Date: Sat,  7 Nov 2026 08:58:19 -0500
Message-ID: <20261107134920.700828959@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134852.069646174@linuxfoundation.org>
References: <20261107134852.069646174@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Avi Weiss <thnkslprpt@gmail.com>

[ Upstream commit 167df3b94680b8670c4cacc08af232e3bfcab5ff ]

dml_core_mode_programming() memsets (clears) its scratch structure
before calculating TD-LUT settings, but does not initialize
tdlut_mpc_width_flag or is_gfx11.

Both inputs therefore remain false regardless of the plane
configuration which can result in incorrect calculations.

Initialize both fields using the same sources as the mode
support path (now both paths are aligned).

Fixes: 70839da63605 ("drm/amd/display: Add new DCN401 sources")
Signed-off-by: Avi Weiss <thnkslprpt@gmail.com>
Signed-off-by: Ray Wu <ray.wu@amd.com>
Reviewed-by: Harry Wentland <harry.wentland@amd.com>
Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit ad8d216e7d9fc050cdf39278e5fae17f61c36931)
Cc: stable@vger.kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../display/dc/dml2/dml21/src/dml2_core/dml2_core_dcn4_calcs.c  | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/gpu/drm/amd/display/dc/dml2/dml21/src/dml2_core/dml2_core_dcn4_calcs.c b/drivers/gpu/drm/amd/display/dc/dml2/dml21/src/dml2_core/dml2_core_dcn4_calcs.c
index d2a237fcf5b08..ccc7ce0db2e1a 100644
--- a/drivers/gpu/drm/amd/display/dc/dml2/dml21/src/dml2_core/dml2_core_dcn4_calcs.c
+++ b/drivers/gpu/drm/amd/display/dc/dml2/dml21/src/dml2_core/dml2_core_dcn4_calcs.c
@@ -10921,6 +10921,8 @@ static bool dml_core_mode_programming(struct dml2_core_calcs_mode_programming_ex
 		calculate_tdlut_setting_params->cursor_buffer_size = mode_lib->ip.cursor_buffer_size;
 		calculate_tdlut_setting_params->gpuvm_enable = display_cfg->gpuvm_enable;
 		calculate_tdlut_setting_params->gpuvm_page_size_kbytes = display_cfg->plane_descriptors[k].overrides.gpuvm_min_page_size_kbytes;
+		calculate_tdlut_setting_params->tdlut_mpc_width_flag = display_cfg->plane_descriptors[k].tdlut.tdlut_mpc_width_flag;
+		calculate_tdlut_setting_params->is_gfx11 = dml_get_gfx_version(display_cfg->plane_descriptors[k].surface.tiling);
 
 		// output
 		calculate_tdlut_setting_params->tdlut_pte_bytes_per_frame = &s->tdlut_pte_bytes_per_frame[k];
-- 
2.53.0



