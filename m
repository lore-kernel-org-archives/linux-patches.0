Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D14952C15AB;
	Wed, 20 May 2026 16:40:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779295230; cv=none; b=SxqVWi1VQhIXC0SJfJ3jPxanBiWxnCKt/K5xekGLz4MDgIhK0j/dAiQZdtnnD1fIobQtVTbJ/EuMoIsa9EyzsDnh1QOefLsAvnd3I/AgmPwscHNBbaHQpYe3CQ1pTJagP8K9+VKOgo2F9V33cTXBwXK9GhUwucA4RbzWhGuBUXE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779295230; c=relaxed/simple;
	bh=lxfWCSEYdjlLl6MtfHDMkOYofGOkfPvCtvcqb4iup/4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=l18hWwGAVSwTRX4VL4oMrImgj582bdSgdxIqOUQsbC8O32kbXNs+IjgdcJ+4vVlHq15Z6o5ICv9Smd3K4TQ3TDFZqG/fnjISRtNZjkcCcWjPHO39Xina2La7ouDDX5lnikGMTWJJDH0Qnr+t3F0NQjhtGDUNA87DFECxTPRl6ss=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yPOjo4gd; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yPOjo4gd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 432D21F000E9;
	Wed, 20 May 2026 16:40:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779295229;
	bh=Kjbs68B1YvrBP4hNyd/dAR+HZE0vvDsVai3XzwNmeyQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=yPOjo4gdA7m1Lkw/zt/4lZJvxjdFAXXUsqOOcqiEkXzk9SnTpP83FPOOHqHQhxEPe
	 S3EpwFG0c6b98ktICG0v9lPTUK0e3zjmIGrSZN6R6oB/YduPEMKk84+LP5H/w7Gobh
	 /q+xEt0LRFksPb8/pLI8uKm8oeJYCLpir+es77Qs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Timur=20Krist=C3=B3f?= <timur.kristof@gmail.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 0338/1146] drm/amd/pm/ci: Use highest MCLK on CI when MCLK DPM is disabled
Date: Wed, 20 May 2026 18:09:48 +0200
Message-ID: <20260520162155.849307290@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162148.390695140@linuxfoundation.org>
References: <20260520162148.390695140@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Timur Kristóf <timur.kristof@gmail.com>

[ Upstream commit 894f0d34d66cb47fe718fe2ae5c18729d22c5218 ]

When MCLK DPM is disabled for any reason, populate the MCLK
table with the highest MCLK DPM level, so that the ASIC can
use the highest possible memory clock to get good performance
even when MCLK DPM is disabled.

Fixes: 9f4b35411cfe ("drm/amd/powerplay: add CI asics support to smumgr (v3)")
Signed-off-by: Timur Kristóf <timur.kristof@gmail.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/pm/powerplay/smumgr/ci_smumgr.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/gpu/drm/amd/pm/powerplay/smumgr/ci_smumgr.c b/drivers/gpu/drm/amd/pm/powerplay/smumgr/ci_smumgr.c
index 7d5df18db8d26..c0a04fab3ceca 100644
--- a/drivers/gpu/drm/amd/pm/powerplay/smumgr/ci_smumgr.c
+++ b/drivers/gpu/drm/amd/pm/powerplay/smumgr/ci_smumgr.c
@@ -1322,6 +1322,14 @@ static int ci_populate_all_memory_levels(struct pp_hwmgr *hwmgr)
 			return result;
 	}
 
+	if (data->mclk_dpm_key_disabled && dpm_table->mclk_table.count) {
+		/* Populate the table with the highest MCLK level when MCLK DPM is disabled */
+		for (i = 0; i < dpm_table->mclk_table.count - 1; i++) {
+			levels[i] = levels[dpm_table->mclk_table.count - 1];
+			levels[i].DisplayWatermark = PPSMC_DISPLAY_WATERMARK_HIGH;
+		}
+	}
+
 	smu_data->smc_state_table.MemoryLevel[0].EnabledForActivity = 1;
 
 	dev_id = adev->pdev->device;
-- 
2.53.0



