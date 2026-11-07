Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794065494;
	b=1J0iGPQt2BdfUyylSozoFzL30LYb9lCG8i5zNBSMiqfPWuQbrFMjitg26atlJTLZmafn
	 yx01HMRZV2B3+T4h1mA8SUb+mBFYqRlkTZ8G08Wreu67DapPBLfMx/51U95V95SgsKAZp
	 FCg4NtG5A+pxsJ9jwLRUppf25P3mNwji0vr/KAGcqgkJA62ASVYEdrfHnGSugkRsPjWIb
	 Kk1kQTYii4K5AsEK/zqX6JJranX+/vKV8cq8ViEDMaOl88QURf/zPfekf00QWMMtta9X6
	 +aNBgx5KcVffgfs9vamYmOzrdye4iqGsZSEQr6cPxYAb5nRemSpW7BKRqnxzfDWU9Lw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794065494;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=w42MmA579+yHLGtYvk6FHiv7CWlElcRiaG2JKbN0T4g=;
	b=OY6fMf3tVWTf+bkZYqPPcKtm8zvY/cAgOYhptwTLL3xycsTLZJh4kMhHPF0Wv9vwDizD
	 MxBR3KuYOBNzgQbNFy6EbCMpJQOAAQrZrlFLfpDXB9hsFTwXTvO1wBMQzAKs028oPAFOO
	 R8oszLDlHrn1N33MziJt5OHF6wvRWNbfXNUU/NsE4rqXW4qqvwvJ/iMP755qC3y0iCjlA
	 SkVFKGpY0C+mZQiifd3fRKKEWURPW18yHAmemxDbQW4o8EfYNTj+7cmC+BY88SjweawSx
	 IymsYvFkjDKXu8fzxM1jw1T/QUxSe+qhe1q0nxbDUOzgPXnQpPebxgqZeiwGRIDG+gg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Hnf5VF0n;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A6C9E606A33D;
	Sat,  7 Nov 2026 15:31:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Hnf5VF0n
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4ED281F008A1;
	Sat,  7 Nov 2026 15:31:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794065493;
	bh=w42MmA579+yHLGtYvk6FHiv7CWlElcRiaG2JKbN0T4g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Hnf5VF0nHsxbhZR53RD8EfXxvbMoGtkA9AmLhg9xutpJzM8wBgFE0SLi3TWjn9wmN
	 tu/SfdI0zd8q/Yhkeu0tHaA9XA4fXXuauJBhbDHoY2BcJgB9QaOyGQtpmQO0ulWLqu
	 T6GJTl1812wuwn3IWJtifGZJ2849F6RzJOcOngms=
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
Subject: [PATCH 7.3 1183/1257] drm/amd/display: Initialize missing TD-LUT programming inputs
Date: Sat,  7 Nov 2026 08:57:59 -0500
Message-ID: <20261107135011.844428946@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134939.434104957@linuxfoundation.org>
References: <20261107134939.434104957@linuxfoundation.org>
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
 .../dc/dml2_0/dml21/src/dml2_core/dml2_core_dcn4_calcs.c        | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/gpu/drm/amd/display/dc/dml2_0/dml21/src/dml2_core/dml2_core_dcn4_calcs.c b/drivers/gpu/drm/amd/display/dc/dml2_0/dml21/src/dml2_core/dml2_core_dcn4_calcs.c
index 72acf12e92516..0ee385e8ba5f5 100644
--- a/drivers/gpu/drm/amd/display/dc/dml2_0/dml21/src/dml2_core/dml2_core_dcn4_calcs.c
+++ b/drivers/gpu/drm/amd/display/dc/dml2_0/dml21/src/dml2_core/dml2_core_dcn4_calcs.c
@@ -11074,6 +11074,8 @@ static bool dml_core_mode_programming(struct dml2_core_calcs_mode_programming_ex
 		calculate_tdlut_setting_params->cursor_buffer_size = mode_lib->ip.cursor_buffer_size;
 		calculate_tdlut_setting_params->gpuvm_enable = display_cfg->gpuvm_enable;
 		calculate_tdlut_setting_params->gpuvm_page_size_kbytes = display_cfg->plane_descriptors[k].overrides.gpuvm_min_page_size_kbytes;
+		calculate_tdlut_setting_params->tdlut_mpc_width_flag = display_cfg->plane_descriptors[k].tdlut.tdlut_mpc_width_flag;
+		calculate_tdlut_setting_params->is_gfx11 = dml_get_gfx_version(display_cfg->plane_descriptors[k].surface.tiling);
 
 		// output
 		calculate_tdlut_setting_params->tdlut_pte_bytes_per_frame = &s->tdlut_pte_bytes_per_frame[k];
-- 
2.53.0



