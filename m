Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794062627;
	b=PwxOeILab7VYhm3XBEzLxKjlRDEI0OkQ1K/Sm3G4j3yYEQG+8+xtY2DpotLnBg6TBx0k
	 dfd3egorrtFO1MqWMeGl6IVxO50mBKlr0SrFpGQOfs9CVHATt+7NFb9b62jeVnysEUAft
	 lQ6zbBdwumklXd8PuC26e3fGm8IHaa9nDWljP5u9fOMegXA9D9yG7pg3nku0Xac2dttQw
	 uA1ZMYMpSHeMkZfINZOwIbZ/8pDzLInihBUgMwav1bCLEA0LZ3Bvffumm9LfrPtkt13rj
	 Fw/6XXOeeBlAibYelxdfr9uyzbNSxe4Z1BOjOgYU3d8Kn+ipyjG/e9f7CBf/LU4OubQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794062627;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=s+QUKCiTDtShMAT8BTa+FcD5TrBw8juFM0aWHfj3nCA=;
	b=e2/qsvDu0NnqIlTw1sOjbt1bL/ZZJmFeKAg5PuTapk2jZ2Vp/GiM1OTtbZVxQyQyktkv
	 uvAMGG7ZJDTZxcVRmJY2Aj3LfGiwdJDrmf0XnxrE9ujtcwdOd1kPSvwVV8WCUnsRzp0Zj
	 lqwkc9EEaylCpp7n8O2u1W92Sc4//KbAS4PIIhzCt9bcFb8kmkg9+LShVAbrXAUDQCLO0
	 IHiRoVIHTCNdXwa9qtgcyf8QVmzq2Ip4UQaEhdpJiLFv3kJ9wR/oCk6itQHGFFSPilAOE
	 LIV+rlTRyem6Pd5WstBnRCUyRM3FR6+zl5U1qhbwb2/7x6ugR5GJOMHYVUdYgW3ZUfg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=pMEzRdj8;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E568606A331;
	Sat,  7 Nov 2026 14:43:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=pMEzRdj8
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 00DB51F0089F;
	Sat,  7 Nov 2026 14:43:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794062627;
	bh=s+QUKCiTDtShMAT8BTa+FcD5TrBw8juFM0aWHfj3nCA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=pMEzRdj8s7WtAYG+przgUClczGRaUnqDyjty7sZsLeZ1SsMhD76mJFJDCVfUEM3XR
	 c1vKP1M24unmPPQdbxkDkzWjPmioRsjN7bfaYKc7sAHs53P72YRN8+hFlIQ3Pkh0e6
	 dXfv7W95lGc5ZT4+RkhLuCzEOp0F7IxfYMkExT9o=
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
Subject: [PATCH 6.12 1498/1536] drm/amd/display: Initialize missing TD-LUT programming inputs
Date: Sat,  7 Nov 2026 08:58:34 -0500
Message-ID: <20261107135039.937812143@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134957.653319350@linuxfoundation.org>
References: <20261107134957.653319350@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 37dd05d917685..043baa4283311 100644
--- a/drivers/gpu/drm/amd/display/dc/dml2/dml21/src/dml2_core/dml2_core_dcn4_calcs.c
+++ b/drivers/gpu/drm/amd/display/dc/dml2/dml21/src/dml2_core/dml2_core_dcn4_calcs.c
@@ -10557,6 +10557,8 @@ static bool dml_core_mode_programming(struct dml2_core_calcs_mode_programming_ex
 		calculate_tdlut_setting_params->cursor_buffer_size = mode_lib->ip.cursor_buffer_size;
 		calculate_tdlut_setting_params->gpuvm_enable = display_cfg->gpuvm_enable;
 		calculate_tdlut_setting_params->gpuvm_page_size_kbytes = display_cfg->plane_descriptors[k].overrides.gpuvm_min_page_size_kbytes;
+		calculate_tdlut_setting_params->tdlut_mpc_width_flag = display_cfg->plane_descriptors[k].tdlut.tdlut_mpc_width_flag;
+		calculate_tdlut_setting_params->is_gfx11 = dml_get_gfx_version(display_cfg->plane_descriptors[k].surface.tiling);
 
 		// output
 		calculate_tdlut_setting_params->tdlut_pte_bytes_per_frame = &s->tdlut_pte_bytes_per_frame[k];
-- 
2.53.0



