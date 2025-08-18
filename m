Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2FB3E230D0D;
	Mon, 18 Aug 2025 13:04:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755522297; cv=none; b=orxLDvZ/1AHD2Aj6lGPn2H2AjmGqp4sphZl/rCj2R4PvVsb8OUtv2MSVU0zK4cFLW8jACxyqgc1DIWL98ozT0RVxD0p/AoHVgg3munPL+KVVxCDYszvMIPNXdDYN4e/WVINBIJvoSRDaU/YMY21ep4F2onnfq+UMJJTGowxkAak=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755522297; c=relaxed/simple;
	bh=uUl6W3T4mEJwSir4SirtHQ2v02Lm1DAhPu5OH65L+TE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=f0iLILsOo2FsGmuHVbwmHqZfqqTZ4BZtJuLssoCwVfxDV20BvvDw7/T3AOomKSrKMpP7uYd7NtkqaYGq3Jvklwky7Xw+CsCRx/puEeGPRNhlFHhXgbdp6dkk6hMBfhpc9pmN6uOmBf2JuCL4xn9hWl0bzmdHoFQAwTdKFNp+IZI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=A5itGeW7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="A5itGeW7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 936C0C4CEEB;
	Mon, 18 Aug 2025 13:04:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755522297;
	bh=uUl6W3T4mEJwSir4SirtHQ2v02Lm1DAhPu5OH65L+TE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=A5itGeW7ZZzFWk0funn/iU7nI7PhJovKyB0ad6X4gkTCe4WONA1QCOalUfrMZafNF
	 WCPo8pEFHkhde60+soQjW4/Tv3IftpgcgUAJKmiSUpeNewvVVQ2uzi0sPrfIsvGVGm
	 YqNqMd0mu0y0ml0pOgBibjjZLJIrY7hS6M9+RU2M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Sun peng (Leo) Li" <sunpeng.li@amd.com>,
	Mario Limonciello <mario.limonciello@amd.com>,
	Ivan Lipski <ivan.lipski@amd.com>,
	Daniel Wheeler <daniel.wheeler@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 274/444] drm/amd/display: Avoid configuring PSR granularity if PSR-SU not supported
Date: Mon, 18 Aug 2025 14:45:00 +0200
Message-ID: <20250818124459.246294194@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250818124448.879659024@linuxfoundation.org>
References: <20250818124448.879659024@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Mario Limonciello <mario.limonciello@amd.com>

[ Upstream commit a5ce8695d6d1b40d6960d2d298b579042c158f25 ]

[Why]
If PSR-SU is disabled on the link, then configuring su_y granularity in
mod_power_calc_psr_configs() can lead to assertions in
psr_su_set_dsc_slice_height().

[How]
Check the PSR version in amdgpu_dm_link_setup_psr() to determine whether
or not to configure granularity.

Reviewed-by: Sun peng (Leo) Li <sunpeng.li@amd.com>
Signed-off-by: Mario Limonciello <mario.limonciello@amd.com>
Signed-off-by: Ivan Lipski <ivan.lipski@amd.com>
Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_psr.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_psr.c b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_psr.c
index e140b7a04d72..d63038ec4ec7 100644
--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_psr.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_psr.c
@@ -127,8 +127,10 @@ bool amdgpu_dm_link_setup_psr(struct dc_stream_state *stream)
 		psr_config.allow_multi_disp_optimizations =
 			(amdgpu_dc_feature_mask & DC_PSR_ALLOW_MULTI_DISP_OPT);
 
-		if (!psr_su_set_dsc_slice_height(dc, link, stream, &psr_config))
-			return false;
+		if (link->psr_settings.psr_version == DC_PSR_VERSION_SU_1) {
+			if (!psr_su_set_dsc_slice_height(dc, link, stream, &psr_config))
+				return false;
+		}
 
 		ret = dc_link_setup_psr(link, stream, &psr_config, &psr_context);
 
-- 
2.39.5



