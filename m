Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D8844198A39;
	Thu,  6 Jun 2024 14:11:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717683068; cv=none; b=b/y5Ln+hyn4hOgoA41RipK5o4EDqs9CfMcX3nNQ4g2Z3D/Bzh6EaQaaJVUYgTsxYlYnzEdikl4p2dZHlXdDKuWEpFpI9GBq3V3hNVl5Y3b6oePKO7LCwH31A3RRs06Eiok/qIOOdzshUlaBiZcqhjcidIxk3GHEoCuT9cvXwzg0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717683068; c=relaxed/simple;
	bh=0BLPlyD9iKo2iVCtCvEBRcTgzakcx/qC8zcw7p9SoXE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=mXDHT/XavU2G06Lmmr8euGi1P4yRWML6X5PVsmotS0nS/FGV/CYM+etcxYJJQUJssM5QNEl/etmZ4PQQroZSiccAxgGPMqnTUJ/H1np3EuoemvDvGB/azZLqm4Iw12TP0fqjDIcrE83dCK2VzsG+BVEU9uDLkBDE//Lez9hud/U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=t1wWnGP1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="t1wWnGP1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AFDC9C32781;
	Thu,  6 Jun 2024 14:11:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717683068;
	bh=0BLPlyD9iKo2iVCtCvEBRcTgzakcx/qC8zcw7p9SoXE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=t1wWnGP1tz7vuI7jcPIFsy2C6Lcv8tCihv6/kdPJREWkZVHFRNc7bF+ysmGP4PdIN
	 EbtZ4E5Gfo14smYMHbEXpcmnvLqFUM6h++qoQioZ9iIyuBb2kwwuUPv5DEaXxxUjl4
	 aEpkE9J9+uDkfhqrj9+z7TE99MGteV2lDD5BDB/I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lucas De Marchi <lucas.demarchi@intel.com>,
	Rodrigo Vivi <rodrigo.vivi@intel.com>,
	Himal Prasad Ghimiray <himal.prasad.ghimiray@intel.com>,
	=?UTF-8?q?Thomas=20Hellstr=C3=B6m?= <thomas.hellstrom@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 328/374] drm/xe: Change pcode timeout to 50msec while polling again
Date: Thu,  6 Jun 2024 16:05:07 +0200
Message-ID: <20240606131702.849269900@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240606131651.683718371@linuxfoundation.org>
References: <20240606131651.683718371@linuxfoundation.org>
User-Agent: quilt/0.67
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

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Himal Prasad Ghimiray <himal.prasad.ghimiray@intel.com>

[ Upstream commit 77b79df0268bee3ef38fd5e76e86a076ce02995d ]

Polling is initially attempted with timeout_base_ms enabled for
preemption, and if it exceeds this timeframe, another attempt is made
without preemption, allowing an additional 50 ms before timing out.

v2
- Rebase

v3
- Move warnings to separate patch (Lucas)

Cc: Lucas De Marchi <lucas.demarchi@intel.com>
Cc: Rodrigo Vivi <rodrigo.vivi@intel.com>
Signed-off-by: Himal Prasad Ghimiray <himal.prasad.ghimiray@intel.com>
Fixes: 7dc9b92dcfef ("drm/xe: Remove i915_utils dependency from xe_pcode.")
Reviewed-by: Lucas De Marchi <lucas.demarchi@intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20240508152216.3263109-2-himal.prasad.ghimiray@intel.com
Signed-off-by: Rodrigo Vivi <rodrigo.vivi@intel.com>
(cherry picked from commit c81858eb52266b3d6ba28ca4f62a198231a10cdc)
Signed-off-by: Thomas Hellström <thomas.hellstrom@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/xe/xe_pcode.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/xe/xe_pcode.c b/drivers/gpu/drm/xe/xe_pcode.c
index c674c87c7f40b..81f4ae2ea08f3 100644
--- a/drivers/gpu/drm/xe/xe_pcode.c
+++ b/drivers/gpu/drm/xe/xe_pcode.c
@@ -191,7 +191,7 @@ int xe_pcode_request(struct xe_gt *gt, u32 mbox, u32 request,
 	drm_WARN_ON_ONCE(&gt_to_xe(gt)->drm, timeout_base_ms > 1);
 	preempt_disable();
 	ret = pcode_try_request(gt, mbox, request, reply_mask, reply, &status,
-				true, timeout_base_ms * 1000, true);
+				true, 50 * 1000, true);
 	preempt_enable();
 
 out:
-- 
2.43.0



