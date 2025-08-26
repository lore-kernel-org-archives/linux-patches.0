Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 634A21A00F0;
	Tue, 26 Aug 2025 12:58:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756213095; cv=none; b=sP6Ao2uFFJauZAkQFsyiSXIoT0+bYzXnKTj19YxXP7RKY0jjxHO/CPgAK2RNCfB3wSEzU+Ap1HSutLPLIsFPB7E5DfKzS0BKZfsbu7SppsBvZ/cdTRuwsJjhM+6pB0W90L9ugdZWZzOWCHGvA0Fj5TAuMDXndXmQBC71ET4lEPI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756213095; c=relaxed/simple;
	bh=AZ7o7r+b/WNY9JkPpOAXJvDwhRp5XRKfa191T6weFmQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=r09OuBFb3Bx/G8QsINgjKCzW+eA90v3ki8BVUUiqyPRoNrE+3NXuHddxR1EZEPUSOPXoFJJizXXvsWSmezOz1bo9GmrROshPAY3QabidqtHFCWzcjaUd/si1yXX6A3yjoWtU9NQTz7bVthKgV01LgrIgrkyLvD+1OanSg7haeUo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ghWDnIkU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ghWDnIkU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E8D52C4CEF1;
	Tue, 26 Aug 2025 12:58:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756213095;
	bh=AZ7o7r+b/WNY9JkPpOAXJvDwhRp5XRKfa191T6weFmQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ghWDnIkU5V9Isim3P2Ixk67Q6uY6fZkqS8Xd8txiIox3Kuox2BaGAduzVZIEFLyC9
	 oZnQ9maGCUImhP6PEdTOOa3TzsnxkC3Vi98FknmG2x2Ds3YV4ySocGnlIZ/tqsuB3J
	 DQOVJEB/U/azKdEvngPkjNNWtAfxJTyliC+NyMW0=
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
Subject: [PATCH 6.6 218/587] drm/amd/display: Avoid configuring PSR granularity if PSR-SU not supported
Date: Tue, 26 Aug 2025 13:06:07 +0200
Message-ID: <20250826110958.481120069@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110952.942403671@linuxfoundation.org>
References: <20250826110952.942403671@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index fe96bab7d05d..67972d25366e 100644
--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_psr.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_psr.c
@@ -124,8 +124,10 @@ bool amdgpu_dm_link_setup_psr(struct dc_stream_state *stream)
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



