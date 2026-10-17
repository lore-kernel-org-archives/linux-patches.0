Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3038938F233;
	Sat, 17 Oct 2026 17:41:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792258900; cv=none; b=iSEvs39SYfbSWniuaWXoeAGjdn2fKZbkc+6C4sSGAs5tswvPsTSqh9/CyQ5+pW4EruHmsDr7ZTXUz+a8kmSlfyB7p2mx4Wioon39WkY5/Tl0EsMaQRwTOckbviELFoeXfevN6U4TyGe4yOGHrwJbQxXzOWcaG3KFt/a51I3k8GY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792258900; c=relaxed/simple;
	bh=j+6VgMjl+wCQuEmkGc9LxoQWjlD8M8soTpRBeRlcX6Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=XUa+MI0GVRqeK0riM7IeESX1wUPFSHx0fqVJHycjmhSWCyi9npVkKIr20ucvPv2b/DrbRLaEqA0pC7fE0sNQd/gGn5W9VAxd2kGCkKV20h9TmhnWg4n6xBZFcjwKI4Z+Jm3Vq0ZywJk02eH/rMHvsgmosGJ2qyDRCCQSVtQCvns=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Z4L82hz9; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Z4L82hz9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7E7A91F000C4;
	Sat, 17 Oct 2026 17:41:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792258899;
	bh=GrDy3IszTgwT71cQ8yaHT1EFajW9Rnb0n8TJmk0LjV8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Z4L82hz9NxCdPdI7xmJtY4jrjTgmRwy56H4tCgCf2NvONimsH9OvNc+S1b/HD3Wzn
	 EKkm+4kTrm4ZO59FJzAZflJvql6C5rHoxbM7AXg1/bued5gZKhVs2jd6WtarILCruh
	 k3nV0DEQoAVvFYwBz/60pmge/NtmqD981xopYznk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	Vitaly Prosyak <vitaly.prosyak@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1036/1674] drm/amdgpu: fix amdgpu_hmm_range_get_pages
Date: Sat, 17 Oct 2026 17:55:08 +0200
Message-ID: <20261017160457.723401225@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
 drivers/gpu/drm/amd/amdgpu/amdgpu_hmm.c | 15 +++++++--------
 1 file changed, 7 insertions(+), 8 deletions(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_hmm.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_hmm.c
index 57516a8c5db34..03b04ee725dbb 100644
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
@@ -170,12 +168,13 @@ int amdgpu_hmm_range_get_pages(struct mmu_interval_notifier *notifier,
 			       void *owner, struct page **pages,
 			       struct hmm_range **phmm_range)
 {
+	const u64 max_bytes = SZ_2G;
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
@@ -196,8 +195,9 @@ int amdgpu_hmm_range_get_pages(struct mmu_interval_notifier *notifier,
 	end = start + npages * PAGE_SIZE;
 	hmm_range->dev_private_owner = owner;
 
+	hmm_range->notifier_seq = mmu_interval_read_begin(notifier);
 	do {
-		hmm_range->end = min(hmm_range->start + MAX_WALK_BYTE, end);
+		hmm_range->end = min(hmm_range->start + max_bytes, end);
 
 		pr_debug("hmm range: start = 0x%lx, end = 0x%lx",
 			hmm_range->start, hmm_range->end);
@@ -208,7 +208,6 @@ int amdgpu_hmm_range_get_pages(struct mmu_interval_notifier *notifier,
 		timeout = jiffies + msecs_to_jiffies(timeout);
 
 retry:
-		hmm_range->notifier_seq = mmu_interval_read_begin(notifier);
 		r = hmm_range_fault(hmm_range);
 		if (unlikely(r)) {
 			/*
@@ -222,7 +221,7 @@ int amdgpu_hmm_range_get_pages(struct mmu_interval_notifier *notifier,
 
 		if (hmm_range->end == end)
 			break;
-		hmm_range->hmm_pfns += MAX_WALK_BYTE >> PAGE_SHIFT;
+		hmm_range->hmm_pfns += max_bytes >> PAGE_SHIFT;
 		hmm_range->start = hmm_range->end;
 		schedule();
 	} while (hmm_range->end < end);
-- 
2.53.0



