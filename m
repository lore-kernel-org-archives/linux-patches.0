Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF6C3242D65;
	Sat, 12 Sep 2026 11:27:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789212449; cv=none; b=HwbC7wnm5dgrYWSoTk/9W3ObIf1vANnbFcUoAYrBWybTmMg0Pf51k5UECo1hcDRboSG1km9zcxfLo+hIp9dLXoiiHlxRN1oIxBWtMtmMFV7ZGileJUS29z/RL4dNKyqo2E8t814lRUH9znKmbfcsOnXW7PoBDhVJxhbfSdPUKnw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789212449; c=relaxed/simple;
	bh=TdEgrFa7NS5Ng/xtXDNoaP6b/6j8f43cJV0uenxYYro=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ka9TiJ16iS7X12yKZTzYyVkz5JzNQELSVwXYXzV0dL4YRnrlgfQVk2I0ridMDTFAm/jlsqK1tsEFap6BM5Q/1Hq8Bj1SQp9onWKtOuQoMLxjV8MeH/RRF1LeNc/YS3F6gP4SC6XbzbJByMXH9cwrfWf6auCEdW91usRzp4FvgiE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rALmXOfh; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rALmXOfh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0CEDB1F000FF;
	Sat, 12 Sep 2026 11:27:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789212448;
	bh=JIUAde3lcl/2BRt/ARJJ5vAGhiqZ3r8TblFom7dWRDg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=rALmXOfhqeSUwcNi58Cgz1aNBxtSY/K8fpS1MlGBMufjmWBNY4YgsOpkN2ZbM0sAJ
	 eR9MGh+t4ClJVxWLgNOI2B2eE2lYwSXJivODoPCSJ1v4U8/W5mDXIBxg0Gzu7jDK8F
	 1ilQu2zS2CYu4pwzpK5u4oMgtT2J+T7KjrnLUEdc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Balasubramani Vivekanandan <balasubramani.vivekanandan@intel.com>,
	Matt Roper <matthew.d.roper@intel.com>,
	Rodrigo Vivi <rodrigo.vivi@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1440/1518] drm/xe/xe_gt_idle: Add CCS to the powergating info print
Date: Sat, 12 Sep 2026 09:00:09 +0200
Message-ID: <20260912065656.131042902@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065623.398859879@linuxfoundation.org>
References: <20260912065623.398859879@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Balasubramani Vivekanandan <balasubramani.vivekanandan@intel.com>

[ Upstream commit 369ba0d1efe91cccabe98ae53c53b7425f327edf ]

While reading the main GT powergating info from debugfs, include both
RCS and CCS engine masks.

Fixes: 0914c1e45d3a1 ("drm/xe/xe_gt_idle: add debugfs entry for powergating info")
Signed-off-by: Balasubramani Vivekanandan <balasubramani.vivekanandan@intel.com>
Link: https://patch.msgid.link/20260819073457.1812722-2-balasubramani.vivekanandan@intel.com
Reviewed-by: Matt Roper <matthew.d.roper@intel.com>
Signed-off-by: Matt Roper <matthew.d.roper@intel.com>
(cherry picked from commit 8899e413c5ab85443ec9bbc50cffe924c6b596de)
Signed-off-by: Rodrigo Vivi <rodrigo.vivi@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/xe/xe_gt_idle.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/xe/xe_gt_idle.c b/drivers/gpu/drm/xe/xe_gt_idle.c
index 3e3d1d52f6302..81e3ec7ff4fdd 100644
--- a/drivers/gpu/drm/xe/xe_gt_idle.c
+++ b/drivers/gpu/drm/xe/xe_gt_idle.c
@@ -236,7 +236,8 @@ int xe_gt_idle_pg_print(struct xe_gt *gt, struct drm_printer *p)
 		xe_force_wake_put(gt_to_fw(gt), fw_ref);
 	}
 
-	if (gt->info.engine_mask & XE_HW_ENGINE_RCS_MASK) {
+	if (gt->info.engine_mask &
+	    (XE_HW_ENGINE_RCS_MASK | XE_HW_ENGINE_CCS_MASK)) {
 		drm_printf(p, "Render Power Gating Enabled: %s\n",
 			   str_yes_no(pg_enabled & RENDER_POWERGATE_ENABLE));
 
-- 
2.53.0



