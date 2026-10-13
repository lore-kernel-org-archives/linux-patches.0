Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED98A4FDE44;
	Tue, 13 Oct 2026 12:10:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791893459; cv=none; b=okzxYbkYG4HCu3mJ36bShzYKf56yuj+VDafzlSHu9ERMcJDRev7OtSRvV6kGBo9uJd0LoqVXtbDDODAqPrVc2qWuGLKDkWLqyTCP6OEMEpYMzMUy93C9eDeV+vFMk75poRSObrLba5dK/yX4mv93eV0Jav5lGz+8BMl0QSDjgQE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791893459; c=relaxed/simple;
	bh=SJw1xsMhxV8HjwYNW/9GxMzrl2gRwj6SVgdwW8VifB0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=SzU4bUuau4wDC2xXdzKoVwr1cRQ5fmFlb3svisDyB3J/zKDj1SIj650LgSbtakPYAjySmIl8pPFJi8RStIfXhY4HQu98Z60b342KGziv50ObY9Xaa3ZJNdmg93gOL8HM/pmVyB3muJzPlt89DF2YCX6tftBaPzHYux/aBomxgVo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YsmBKes1; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YsmBKes1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 10E861F000FF;
	Tue, 13 Oct 2026 12:10:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791893456;
	bh=xjEZ7c4WM1Nhr+TGWqFE6yDohA/gLY+WkqOLeWFEXTA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=YsmBKes15Kxfnhdq3Sj6279bspStD7PppSsuxVj1nMbVy0RwU+yPj+G090dDGf7hz
	 QUBJV2W+ZuI5ZT4ZwEdRTEq9J/vDy8SuLCDhsLkKcVdAUR/CG9MJFz3hVpGyoBEmQE
	 +jEOs9E2MkS098+548EPbS8LWDKCqjgELBV2YQVM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	Vitaly Prosyak <vitaly.prosyak@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 231/621] drm/amdgpu: fix amdgpu_hmm_range_get_pages
Date: Tue, 13 Oct 2026 13:33:46 +0200
Message-ID: <20261013112926.340871496@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261013112920.855194808@linuxfoundation.org>
References: <20261013112920.855194808@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Christian König <christian.koenig@amd.com>

[ Upstream commit 962d684b5dc0741dcd93485d41b450de402d5592 ]

The notifier sequence must only be read once or otherwise we could work
with invalid pages.

While at it also fix the coding style, e.g. drop the pre-initialized
return value and use the common define for 2G range.

Signed-off-by: Christian König <christian.koenig@amd.com>
Reviewed-by: Vitaly Prosyak <vitaly.prosyak@amd.com>
Tested-by: Vitaly Prosyak <vitaly.prosyak@amd.com>
Reviewed-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit c08972f555945cda57b0adb72272a37910153390)
Cc: stable@vger.kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_hmm.c | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_hmm.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_hmm.c
index f60f26470af03..db2bb5cb671d3 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_hmm.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_hmm.c
@@ -51,8 +51,6 @@
 #include "amdgpu_amdkfd.h"
 #include "amdgpu_hmm.h"
 
-#define MAX_WALK_BYTE	(2UL << 30)
-
 /**
  * amdgpu_hmm_invalidate_gfx - callback to notify about mm change
  *
@@ -172,11 +170,13 @@ int amdgpu_hmm_range_get_pages(struct mmu_interval_notifier *notifier,
 			       void *owner,
 			       struct hmm_range **phmm_range)
 {
+	const u64 max_bytes = SZ_2G;
+
 	struct hmm_range *hmm_range;
-	unsigned long end;
 	unsigned long timeout;
 	unsigned long *pfns;
-	int r = 0;
+	unsigned long end;
+	int r;
 
 	hmm_range = kzalloc(sizeof(*hmm_range), GFP_KERNEL);
 	if (unlikely(!hmm_range))
@@ -197,8 +197,9 @@ int amdgpu_hmm_range_get_pages(struct mmu_interval_notifier *notifier,
 	end = start + npages * PAGE_SIZE;
 	hmm_range->dev_private_owner = owner;
 
+	hmm_range->notifier_seq = mmu_interval_read_begin(notifier);
 	do {
-		hmm_range->end = min(hmm_range->start + MAX_WALK_BYTE, end);
+		hmm_range->end = min(hmm_range->start + max_bytes, end);
 
 		pr_debug("hmm range: start = 0x%lx, end = 0x%lx",
 			hmm_range->start, hmm_range->end);
@@ -206,7 +207,6 @@ int amdgpu_hmm_range_get_pages(struct mmu_interval_notifier *notifier,
 		timeout = jiffies + msecs_to_jiffies(HMM_RANGE_DEFAULT_TIMEOUT);
 
 retry:
-		hmm_range->notifier_seq = mmu_interval_read_begin(notifier);
 		r = hmm_range_fault(hmm_range);
 		if (unlikely(r)) {
 			if (r == -EBUSY && !time_after(jiffies, timeout))
@@ -216,7 +216,7 @@ int amdgpu_hmm_range_get_pages(struct mmu_interval_notifier *notifier,
 
 		if (hmm_range->end == end)
 			break;
-		hmm_range->hmm_pfns += MAX_WALK_BYTE >> PAGE_SHIFT;
+		hmm_range->hmm_pfns += max_bytes >> PAGE_SHIFT;
 		hmm_range->start = hmm_range->end;
 	} while (hmm_range->end < end);
 
-- 
2.53.0



