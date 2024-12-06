Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A210149DF0;
	Fri,  6 Dec 2024 14:46:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733496360; cv=none; b=B229dWFkQ2fgu6kVV/TYLPrPy9rbkuugMygt7N5fqDy6ID/ia/Rykw4eWPmNWaUVk7SQK+rgsgQOAHE65E21wJKbX6sRjIPgh5mF2vzVafw02zqNpGNXgGhtjXnjRwo9phnqGvMxen4SC+soeDs4TS74fngG0GLhBpasF1s+ukA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733496360; c=relaxed/simple;
	bh=Cf9XvtGZlBVQYpK0WOnOx79J2p3k1H6Yx4DgVbYmy08=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=AZU+NQqPIl8Bw8uEiZqWYpsSLDR3TCdbNAdmXaiI5hNEdK5u/l5yY6mdrOnwR6X+qa5q/gJj7Vt1Hjyj7l5q3/4SrstD4DJpaPqvKUQbfCxkLmAlvQyhxbQCIgrrFAFRXh4n0kMLzSHe9qebAHtheYbYfJbff67vB1vHO96ckY8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oqMKwm4F; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oqMKwm4F"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D9F49C4CEDE;
	Fri,  6 Dec 2024 14:45:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733496360;
	bh=Cf9XvtGZlBVQYpK0WOnOx79J2p3k1H6Yx4DgVbYmy08=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oqMKwm4FVgnzuaV4DitPquBI8HyM6whD7IG8IBSvsu0bg+qLAoMlbkq1+4sPMM12L
	 yiIpS/TYjtDf9CGEcOK6vLoHJtlbtG/ZZbBlre0JxkUqr1qAzLR/deKSCUai/pZbAZ
	 HWnb3F5UGi0icAQqLN5zRxrFNznoa2sFLnSLM7HM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Matthew Auld <matthew.auld@intel.com>,
	Matthew Brost <matthew.brost@intel.com>,
	Nirmoy Das <nirmoy.das@intel.com>,
	=?UTF-8?q?Thomas=20Hellstr=C3=B6m?= <thomas.hellstrom@linux.intel.com>
Subject: [PATCH 6.12 130/146] drm/xe/migrate: fix pat index usage
Date: Fri,  6 Dec 2024 15:37:41 +0100
Message-ID: <20241206143532.657975092@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241206143527.654980698@linuxfoundation.org>
References: <20241206143527.654980698@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Matthew Auld <matthew.auld@intel.com>

commit 23346f85163de83aca6dc30dde3944131cf54706 upstream.

XE_CACHE_WB must be converted into the per-platform pat index for that
particular caching mode, otherwise we are just encoding whatever happens
to be the value of that enum.

Fixes: e8babb280b5e ("drm/xe: Convert multiple bind ops into single job")
Signed-off-by: Matthew Auld <matthew.auld@intel.com>
Cc: Matthew Brost <matthew.brost@intel.com>
Cc: Nirmoy Das <nirmoy.das@intel.com>
Cc: <stable@vger.kernel.org> # v6.12+
Reviewed-by: Nirmoy Das <nirmoy.das@intel.com>
Reviewed-by: Matthew Brost <matthew.brost@intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20241126181259.159713-3-matthew.auld@intel.com
(cherry picked from commit f3dc9246f9c3cd5a7d8fd70cfd805bfc52214e2e)
Signed-off-by: Thomas Hellström <thomas.hellstrom@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/xe/xe_migrate.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/xe/xe_migrate.c b/drivers/gpu/drm/xe/xe_migrate.c
index cfd31ae49cc1..48e205a40fd2 100644
--- a/drivers/gpu/drm/xe/xe_migrate.c
+++ b/drivers/gpu/drm/xe/xe_migrate.c
@@ -1350,6 +1350,7 @@ __xe_migrate_update_pgtables(struct xe_migrate *m,
 
 	/* For sysmem PTE's, need to map them in our hole.. */
 	if (!IS_DGFX(xe)) {
+		u16 pat_index = xe->pat.idx[XE_CACHE_WB];
 		u32 ptes, ofs;
 
 		ppgtt_ofs = NUM_KERNEL_PDE - 1;
@@ -1409,7 +1410,7 @@ __xe_migrate_update_pgtables(struct xe_migrate *m,
 						pt_bo->update_index = current_update;
 
 					addr = vm->pt_ops->pte_encode_bo(pt_bo, 0,
-									 XE_CACHE_WB, 0);
+									 pat_index, 0);
 					bb->cs[bb->len++] = lower_32_bits(addr);
 					bb->cs[bb->len++] = upper_32_bits(addr);
 				}
-- 
2.47.1



