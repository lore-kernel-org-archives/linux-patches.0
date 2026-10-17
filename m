Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8429138654F;
	Sat, 17 Oct 2026 16:22:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792254130; cv=none; b=Q7QXI62hJepv02aZNb35AK6YV1UR3b4dJXm7wOkNbawfBHjXBIbE6gWnMnIkh2ELVWaeN+s3D/GdGd94/CGjFn/YBaoi1h43lnpPDbgzzFwE+TglIn8zf+QyKQ4rCWwKhQjR3GFJ/ZFVwUgTr2Jhp/j/PWnOVFCE7ZqcWQuSXi4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792254130; c=relaxed/simple;
	bh=N8mDlGKawHCKo6cu5w8PTRuzt1JtRibrlXuEyDxNPBM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ewVrKe9p155vGbe+j7FbfYCsv9VGkiiMsp6deXdXsE9l633LJfvF4VxYisGeyUYK7of9aeLDJCmPWwJUIAe2eAIsDtvP4vlR3doBwEJx0bLnlK4mHBmRvdO0g73taEkjssDweQHZE2gwsVgPErf8Roiopevv6Kge0OgyZ8Qy6oE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YDbk1FRH; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YDbk1FRH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 883201F000C4;
	Sat, 17 Oct 2026 16:22:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792254129;
	bh=eRwJXeL8n/p2wOPjTYFSz14qpwljrPbjh7tFTk3W0CA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=YDbk1FRHFgEOye+575O4HcbNP/d5W5fQFqOfZRoR8zJGmg8rMTGjoVAQXXMfOu+XO
	 R+Q+0jO49RDJgh9BaVHHBagRUNHTLTj5t8tyCvpS1Jw2l3Q+tV3WKMBwd776D+7UCN
	 tyRgXiGHN2c9p6DZPJ0WuPtdQrFX33Pt5F9LCU20=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	Vitaly Prosyak <vitaly.prosyak@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 346/869] drm/amdgpu: fix amdgpu_hmm_range_get_pages
Date: Sat, 17 Oct 2026 17:53:07 +0200
Message-ID: <20261017160045.969869582@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160036.979869304@linuxfoundation.org>
References: <20261017160036.979869304@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
 drivers/gpu/drm/amd/amdgpu/amdgpu_hmm.c | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_hmm.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_hmm.c
index e36fede7f74c3..52882d88c290a 100644
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
@@ -170,12 +168,14 @@ int amdgpu_hmm_range_get_pages(struct mmu_interval_notifier *notifier,
 			       void *owner, struct page **pages,
 			       struct hmm_range **phmm_range)
 {
+	const u64 max_bytes = SZ_2G;
+
 	struct hmm_range *hmm_range;
-	unsigned long end;
 	unsigned long timeout;
-	unsigned long i;
 	unsigned long *pfns;
-	int r = 0;
+	unsigned long end;
+	unsigned long i;
+	int r;
 
 	hmm_range = kzalloc(sizeof(*hmm_range), GFP_KERNEL);
 	if (unlikely(!hmm_range))
@@ -196,8 +196,9 @@ int amdgpu_hmm_range_get_pages(struct mmu_interval_notifier *notifier,
 	end = start + npages * PAGE_SIZE;
 	hmm_range->dev_private_owner = owner;
 
+	hmm_range->notifier_seq = mmu_interval_read_begin(notifier);
 	do {
-		hmm_range->end = min(hmm_range->start + MAX_WALK_BYTE, end);
+		hmm_range->end = min(hmm_range->start + max_bytes, end);
 
 		pr_debug("hmm range: start = 0x%lx, end = 0x%lx",
 			hmm_range->start, hmm_range->end);
@@ -205,7 +206,6 @@ int amdgpu_hmm_range_get_pages(struct mmu_interval_notifier *notifier,
 		timeout = jiffies + msecs_to_jiffies(HMM_RANGE_DEFAULT_TIMEOUT);
 
 retry:
-		hmm_range->notifier_seq = mmu_interval_read_begin(notifier);
 		r = hmm_range_fault(hmm_range);
 		if (unlikely(r)) {
 			if (r == -EBUSY && !time_after(jiffies, timeout))
@@ -215,7 +215,7 @@ int amdgpu_hmm_range_get_pages(struct mmu_interval_notifier *notifier,
 
 		if (hmm_range->end == end)
 			break;
-		hmm_range->hmm_pfns += MAX_WALK_BYTE >> PAGE_SHIFT;
+		hmm_range->hmm_pfns += max_bytes >> PAGE_SHIFT;
 		hmm_range->start = hmm_range->end;
 	} while (hmm_range->end < end);
 
-- 
2.53.0



