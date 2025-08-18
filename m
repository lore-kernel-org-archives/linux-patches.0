Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C2B03375C0;
	Mon, 18 Aug 2025 14:02:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755525753; cv=none; b=duJhYPSfkEVfCG/1VlWhP0NrohVX93A/edgFXqOoFuUZBAiLfI1+mwaR6b46pB3877hi3YDefo7+ffR7fXU4dZeM8PQtYEfFSLFlMq/VGRPD+vHDqbjsIY0YtB7PPm2fA7zyvSEOZFtO9x9fmpNxRHWkQOa2WJPCrWb380uGFoE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755525753; c=relaxed/simple;
	bh=Alq5anS3oBdQvMzJBY6ycbrFy89gNbtQdAo7bpopJGA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YxXdyjtPDJ92KMR2SC+W2dRrSAQl5lkDM/g30GgI62sr7u8BxyKMhJ+Eydjk4UXD3P1xz5TkBbBsgJToj8gMtoPotxaYoJRgRd1GljiXo+blZdmrh77PRcSsQnGpdykKcKMM1w5GLC09mkzneM0Y6L01E2Trnnnf9gPhr0qdxGQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eRAqUWWl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eRAqUWWl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3C5AAC4CEEB;
	Mon, 18 Aug 2025 14:02:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755525752;
	bh=Alq5anS3oBdQvMzJBY6ycbrFy89gNbtQdAo7bpopJGA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=eRAqUWWl0cFB+OUP8l4A+o4uEP+0kWonU7n5va0IyRvNSMnHO23WeLFRXG2AIciGl
	 hkY2i61BoV5dIaVRGTyi+KZQomUs3oeEwgz4NAQZn4u4gl3FJm9QyuWRqB1XUIpYt5
	 Jbb2ezrclrnbBDREQ7Ov92XZqWrmmimYq2Q+xpa0=
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
Subject: [PATCH 6.16 357/570] drm/amd/display: Avoid configuring PSR granularity if PSR-SU not supported
Date: Mon, 18 Aug 2025 14:45:44 +0200
Message-ID: <20250818124519.609566671@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250818124505.781598737@linuxfoundation.org>
References: <20250818124505.781598737@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

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
index f984cb0cb889..ff7b867ae98b 100644
--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_psr.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_psr.c
@@ -119,8 +119,10 @@ bool amdgpu_dm_link_setup_psr(struct dc_stream_state *stream)
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



