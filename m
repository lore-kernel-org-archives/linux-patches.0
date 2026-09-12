Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D0C0037757A;
	Sat, 12 Sep 2026 09:28:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789205304; cv=none; b=LHy7KFZdTnE3+xw5eA/rwn9A+8yhUEYb9SgYv6ksDGkr7xPwK2D1UhozFb4tYXhaCS7zcoZDuA8D20acK7cBUsIsv/iUxDvhUPc+bFMUI8+ujqbkmspJbux6OBZMUVjFM4VIVqw6EeuicvmcImX20DMqkhBcbEb7yzUjIT8EbRk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789205304; c=relaxed/simple;
	bh=beq+hcajiBGglg33y6SkTNuAbfqs3osdWYsWKTXhkb0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fJ+XPafFl1h4xdkRTIa2SUU9LWT3ll97aHeB3QH81+LTaCcRi/Gz8r6N+Fy5poPTgsMlcs03cS4twV5ClYhdYTQtOo98GHY6KTBfO5Axw2e+neUSavMYBgraGRQ6bjMw8+wxz1050ATpOyvmxMRDI1X9sA0qHpbFeGFxV08S4hU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KDoDg4oK; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KDoDg4oK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D594B1F000FF;
	Sat, 12 Sep 2026 09:28:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789205302;
	bh=0dcGi/OrcUVk5esui43jac8VnxGBavsSOe40VN3HttU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=KDoDg4oKgp6ai+RtrO0uxpwy5HLd5dcVptlKeLto5VwbZSsvTIS+dyubgejLpYta9
	 qK/n1X7AiFJpWxFq5El5vvwyV3GwlsrO4TADKZcDZTz1eP2AVA/68Ww6PzGaB07lNQ
	 yl6v2nJpMnA+nJwJ1SpR95n7rjx8MF3XzwEJUnmw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Balasubramani Vivekanandan <balasubramani.vivekanandan@intel.com>,
	Matt Roper <matthew.d.roper@intel.com>,
	Rodrigo Vivi <rodrigo.vivi@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 1783/1815] drm/xe/xe_gt_idle: Add CCS to the powergating info print
Date: Sat, 12 Sep 2026 08:58:53 +0200
Message-ID: <20260912065730.888084375@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

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
index 04b24e1c8b78e..7dc9873aef545 100644
--- a/drivers/gpu/drm/xe/xe_gt_idle.c
+++ b/drivers/gpu/drm/xe/xe_gt_idle.c
@@ -248,7 +248,8 @@ int xe_gt_idle_pg_print(struct xe_gt *gt, struct drm_printer *p)
 		pg_status = xe_mmio_read32(&gt->mmio, POWERGATE_DOMAIN_STATUS);
 	}
 
-	if (gt->info.engine_mask & XE_HW_ENGINE_RCS_MASK) {
+	if (gt->info.engine_mask &
+	    (XE_HW_ENGINE_RCS_MASK | XE_HW_ENGINE_CCS_MASK)) {
 		drm_printf(p, "Render Power Gating Enabled: %s\n",
 			   str_yes_no(pg_enabled & RENDER_POWERGATE_ENABLE));
 
-- 
2.53.0



