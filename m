Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795621837;
	b=y7e6H7SAGmHaE4bWefPB7fA+LUzOvFURmQkGLE5i7K2gfPfjisqENmEqXr/YOpzzDi/e
	 2+ok43+rs4C8la1Jau8H7V+QD2bWDgGXwuUvdS3Pij8syCXcrSP74gSg7bntlUwe3Upjx
	 Hv6tRpIU/WsvTjDmNRA1a8+IRK6WIKee7YwG158kk8IrNcYX7HwwkF7E3Sze4KON5uePE
	 sZne/UBeKvlTeb+FGXzxMX6L6ygm+IdRDqnPr5q8Q4yqusJPzd32pM1pevM0YbGbiEqbO
	 4LajZ1L5LCH9fCoEHK79A/r9fvXaMRMdAUoR94tAlsLaa+lVcHj51xGTtCNDpwKLw/Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795621837;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=lfY6+ACkKkMJkIiJJyXZaNfUJtxH402RHVK27od4sFw=;
	b=xThl0XS38y+kqnaXmwCWqQxstFfDCdqhYM7bgpdsG9OqixOYTmcKXVm9aFgDfp3bzeKU
	 j+CoP5BdCdjFT340c3DbJ54ubHYPkhXsTGvYAq/k51ZODNMnp6BnqOGcXCtjWPJp9BIde
	 TDsRk2MUWM8x+6KawLPFKIPhTwDkelDSaAH6HdEloNWYMvTF++F4iZe/SpWJtHz2QZGhE
	 DAAQKAYcUnJC3+iRyUKcYRVANx1dQUumN7rrwE5pVdNVCVx9Bju8ThCXkcBWYS0sQZZal
	 c58hwDkdawePjF24l4uafn7naUqG4asntqnh/Xv2zJBiTEfgbIBB/R7e5YfXNByE3tQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=L5Fnntom;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 65A09606A33B;
	Wed, 25 Nov 2026 15:50:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=L5Fnntom
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 218EF1F000D2;
	Wed, 25 Nov 2026 15:50:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795621836;
	bh=lfY6+ACkKkMJkIiJJyXZaNfUJtxH402RHVK27od4sFw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=L5FnntomSFufEQ/bT6bd3ERkIFti0AJN5jLmAakwlZ448cFcjEPPPPGodmxQtYAi1
	 J7NedflCsS+pw14jhZpZXFFKDSmvRGEZM+mAxQuJ/1KnTOYqgDlfBuseozh/nh36Q9
	 8bCq79tpvK/dw+aPTcaC7oaYrAG+fDYXtNHbul1A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Raag Jadav <raag.jadav@intel.com>,
	Riana Tauro <riana.tauro@intel.com>,
	Matt Roper <matthew.d.roper@intel.com>,
	Matthew Brost <matthew.brost@intel.com>,
	Dave Airlie <airlied@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 348/990] drm/xe/hw_error: Guard csc_hw_error_work() with runtime PM
Date: Wed, 25 Nov 2026 15:28:35 +0100
Message-ID: <20261125143830.243694842@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143822.072087159@linuxfoundation.org>
References: <20261125143822.072087159@linuxfoundation.org>
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

From: Raag Jadav <raag.jadav@intel.com>

[ Upstream commit a890a885b982f73e6e984e828ffda06b5121c4b6 ]

xe_device_declare_wedged() callers are expected to hold a runtime PM
reference. Fix it.

Fixes: a7df563b45b0 ("drm/xe/xe_hw_error: Handle CSC Firmware reported Hardware errors")
Signed-off-by: Raag Jadav <raag.jadav@intel.com>
Reviewed-by: Riana Tauro <riana.tauro@intel.com>
Link: https://patch.msgid.link/20261022051303.282805-4-raag.jadav@intel.com
Signed-off-by: Matt Roper <matthew.d.roper@intel.com>
(cherry picked from commit fc8d229d76102489b6f56538a818c285a87db1e9)
Signed-off-by: Matthew Brost <matthew.brost@intel.com>
Signed-off-by: Dave Airlie <airlied@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/xe/xe_hw_error.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/gpu/drm/xe/xe_hw_error.c b/drivers/gpu/drm/xe/xe_hw_error.c
index 3c105269e6fa8..0cf3c6d7b3731 100644
--- a/drivers/gpu/drm/xe/xe_hw_error.c
+++ b/drivers/gpu/drm/xe/xe_hw_error.c
@@ -12,6 +12,7 @@
 #include "xe_device.h"
 #include "xe_hw_error.h"
 #include "xe_mmio.h"
+#include "xe_pm.h"
 #include "xe_survivability_mode.h"
 
 #define  HEC_UNCORR_FW_ERR_BITS 4
@@ -56,6 +57,7 @@ static void csc_hw_error_work(struct work_struct *work)
 	struct xe_tile *tile = container_of(work, typeof(*tile), csc_hw_error_work);
 	struct xe_device *xe = tile_to_xe(tile);
 
+	guard(xe_pm_runtime)(xe);
 	xe_survivability_mode_runtime_enable(xe);
 }
 
-- 
2.53.0



