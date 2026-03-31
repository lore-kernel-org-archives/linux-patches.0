Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3FB19426EDA;
	Tue, 31 Mar 2026 16:39:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774975141; cv=none; b=ZIcMJWLioFQsQJJMqwzqRaPkCiHYkN7LCcqKeLGB1ka7yY70tlLR/HdyUeZnBBtufRSYksILGKBfbGKSaLY0dE+O2TeEmcYxf4HuhBlbHrReewFGh1GZnWRePANjOhGRX4XXs4cYI8v1F+GykBptXGuAx5q3+VAxcqnhrDPook4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774975141; c=relaxed/simple;
	bh=3eILs24/6V+2+lmj+h7E/m3eJotuenDoqi7BbXTlUhM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FHO/sgOxbEvsuRF0yRxy/WKDrZzD1Tdn2zHDC7DaWFOXWuVkMnxcaf1KQ6dMds/uZzbFJRpJ35t7hB34UA3Nfaoe1K2JpCp3IxoPC4yram2RM5FQaubXE6r/y8TIjdoqCkwiTYw5mqUhLQUMxdOAkvGGO82YI9TmEnvYXDPEWOM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=u9+h1oGQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="u9+h1oGQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 81463C19423;
	Tue, 31 Mar 2026 16:39:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774975140;
	bh=3eILs24/6V+2+lmj+h7E/m3eJotuenDoqi7BbXTlUhM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=u9+h1oGQKR2LpSKvMBmPUCPbB7lsoMvo6wk76EmEuJld/g6dlQrsqwIqGdoRdb/s0
	 lkuLNn00dIhQWBC5OxY8B+rKLROtVx9ik3dwKZrW4BEqBrgEQqIjSIWlUhjH1bLoU1
	 E0Wvj7F0MfLl85hCMsEVGlE0Dh1A08r4HIiRK+aU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Matt Atwood <matthew.s.atwood@intel.com>,
	Matt Roper <matthew.d.roper@intel.com>,
	Rodrigo Vivi <rodrigo.vivi@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 179/342] drm/xe: Implement recent spec updates to Wa_16025250150
Date: Tue, 31 Mar 2026 18:20:12 +0200
Message-ID: <20260331161805.591872870@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260331161758.909578033@linuxfoundation.org>
References: <20260331161758.909578033@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Matt Roper <matthew.d.roper@intel.com>

[ Upstream commit 56781a4597706cd25185b1dedc38841ec6c31496 ]

The hardware teams noticed that the originally documented workaround
steps for Wa_16025250150 may not be sufficient to fully avoid a hardware
issue.  The workaround documentation has been augmented to suggest
programming one additional register; make the corresponding change in
the driver.

Fixes: 7654d51f1fd8 ("drm/xe/xe2hpg: Add Wa_16025250150")
Reviewed-by: Matt Atwood <matthew.s.atwood@intel.com>
Link: https://patch.msgid.link/20260319-wa_16025250150_part2-v1-1-46b1de1a31b2@intel.com
Signed-off-by: Matt Roper <matthew.d.roper@intel.com>
(cherry picked from commit a31566762d4075646a8a2214586158b681e94305)
Signed-off-by: Rodrigo Vivi <rodrigo.vivi@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/xe/regs/xe_gt_regs.h | 1 +
 drivers/gpu/drm/xe/xe_wa.c           | 3 ++-
 2 files changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/xe/regs/xe_gt_regs.h b/drivers/gpu/drm/xe/regs/xe_gt_regs.h
index 917a088c28f24..ec1ae2dc6cabe 100644
--- a/drivers/gpu/drm/xe/regs/xe_gt_regs.h
+++ b/drivers/gpu/drm/xe/regs/xe_gt_regs.h
@@ -544,6 +544,7 @@
 #define   ENABLE_SMP_LD_RENDER_SURFACE_CONTROL	REG_BIT(44 - 32)
 #define   FORCE_SLM_FENCE_SCOPE_TO_TILE		REG_BIT(42 - 32)
 #define   FORCE_UGM_FENCE_SCOPE_TO_TILE		REG_BIT(41 - 32)
+#define   L3_128B_256B_WRT_DIS			REG_BIT(40 - 32)
 #define   MAXREQS_PER_BANK			REG_GENMASK(39 - 32, 37 - 32)
 #define   DISABLE_128B_EVICTION_COMMAND_UDW	REG_BIT(36 - 32)
 
diff --git a/drivers/gpu/drm/xe/xe_wa.c b/drivers/gpu/drm/xe/xe_wa.c
index 4039a6428e6c1..c15b0288e0ff5 100644
--- a/drivers/gpu/drm/xe/xe_wa.c
+++ b/drivers/gpu/drm/xe/xe_wa.c
@@ -261,7 +261,8 @@ static const struct xe_rtp_entry_sr gt_was[] = {
 				   LSN_DIM_Z_WGT_MASK,
 				   LSN_LNI_WGT(1) | LSN_LNE_WGT(1) |
 				   LSN_DIM_X_WGT(1) | LSN_DIM_Y_WGT(1) |
-				   LSN_DIM_Z_WGT(1)))
+				   LSN_DIM_Z_WGT(1)),
+			SET(LSC_CHICKEN_BIT_0_UDW, L3_128B_256B_WRT_DIS))
 	},
 
 	/* Xe2_HPM */
-- 
2.53.0



