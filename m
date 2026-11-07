Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794061855;
	b=n/EY8AwaMOw3DYrVfG4oz0VmxC4zmSLBCv/aAKfIGLEZdOs1sL8Jp6MbNQeBaweaXtsk
	 PXWzOrIWiLoXDf8WHCs+JPoG4GG0Co1eUto/ZTXO/BVmzItMIqo3NVTQB6wLWr3nQ7qwA
	 IEOIN7+zMw1Zr6nFAhuJNRGMh++QRb1Q7b8rw8Ld/BpXXK1FF6QlJFGA4rK79QMimQxGy
	 ljsGKik5p4Lurxi9Tg8eKE249KGq7tmTDgub/4yV8R5gSuF6+BHU/c69HMEAsBAGoNpRw
	 HUplcO45hem0J8PwleQvJfU/IyWWba+4calqDLK9ZshQESAQzMD0KEIM+UmJJgvdnog==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794061855;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=1Oqb3rj0x4Xk1l3fStDlCfIn1pPFTlTdRtIVuy/Hqaw=;
	b=Hg+f4VjyHia+CHVifcEC83UnGQ3aJvnynkxmNiZksPcdC87c/iKfuS5vVlABKOXSKSjL
	 Ff6TnwuJuoJ7HRe5aH52xGdwQ4V4r0qOU+Ayklaj6H9xyIL6bol8Twq5aK98kko2MMHUo
	 CBwA/QHxgz5fXrUb9iaI3w064wGbxSbLB1XBJiW9iKm2i7BBUBA3ZexieilhCvCHeUPH+
	 bVOBb8p0+loJgyoujLhSlEzHqE8zhA11baqpQ6VxiUR/jiS9RdC7bF2g2KGTLE8KhXv68
	 LNdPo+za82M3rznzvuhdoBucmquBwbL/MQ5Fe37mpxtTWx/5KdUfQQ0SMRnuSr5UfyQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Rc5hXzAk;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1DC46606A32E;
	Sat,  7 Nov 2026 14:30:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Rc5hXzAk
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C01D51F0089F;
	Sat,  7 Nov 2026 14:30:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794061855;
	bh=1Oqb3rj0x4Xk1l3fStDlCfIn1pPFTlTdRtIVuy/Hqaw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Rc5hXzAkJEi02urpchcHcfrjrLpxfbMwq9Y9LymA7p7rH1bCYmkraA36QHBWt5Tx6
	 OZQy2hQ1GIny5+38P1VH2gPxk13zqL7Mfc9ZfT7yiDVWR9Iyg6wY2DP4BvAmia265g
	 uZUCaABCgiMEv5/O1wJOEeN/IZc22UC5Ha9B1PeU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	Honglei Huang <honghuan@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0865/1536] drm/amdgpu: drop retry loop in amdgpu_hmm_range_get_pages
Date: Sat,  7 Nov 2026 08:48:01 -0500
Message-ID: <20261107135021.844664117@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134957.653319350@linuxfoundation.org>
References: <20261107134957.653319350@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Honglei Huang <honghuan@amd.com>

[ Upstream commit 342981fff32802a819d6fc7cf3c9fedf9f3d9d60 ]

Since commit c08972f55594 ("drm/amdgpu: fix amdgpu_hmm_range_get_pages")
moved mmu_interval_read_begin() out of the per-chunk loop, the
captured notifier_seq is no longer refreshed across retries. As a
result, the existing -EBUSY retry path can never make progress:

  hmm_range_fault() returns -EBUSY only when
  mmu_interval_check_retry(notifier, notifier_seq) reports that the
  sequence is stale. Once the sequence has advanced, the stored seq
  will never match again, so every subsequent call within the same
  invocation returns -EBUSY immediately.

The "goto retry" therefore degenerates into a busy spin that simply
burns CPU for the full HMM_RANGE_DEFAULT_TIMEOUT (~1s) window before
finally bailing out with -EAGAIN. This is pure latency with no chance
of recovery, and it actively hurts the KFD userptr stack: the caller
ends up blocked for a second while holding mmap_lock, only to return
-EAGAIN to the restore worker (or to userspace) which would have
re-driven the operation immediately anyway.

Drop the retry/timeout entirely and let -EBUSY propagate straight to
out_free_pfns, where it is already translated to -EAGAIN. Recovery is
handled at a higher level: the KFD restore_userptr_worker reschedules
itself, and the userptr ioctl path returns -EAGAIN to userspace.

No functional regression: the previous behaviour on -EBUSY was already
to fail with -EAGAIN after a 1s stall; we just skip the stall.

Reviewed-by: Christian König <christian.koenig@amd.com>
Signed-off-by: Honglei Huang <honghuan@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
[ sashal: Removed the timeout/retry: loop and the -EBUSY special case; the only adaptation is keeping this tree's kzalloc'd struct hmm_range *hmm_range; declaration instead of upstream's &range->hmm_range context. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_hmm.c | 9 +--------
 1 file changed, 1 insertion(+), 8 deletions(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_hmm.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_hmm.c
index 52882d88c290a..f58f6cfdf4e0e 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_hmm.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_hmm.c
@@ -171,7 +171,6 @@ int amdgpu_hmm_range_get_pages(struct mmu_interval_notifier *notifier,
 	const u64 max_bytes = SZ_2G;
 
 	struct hmm_range *hmm_range;
-	unsigned long timeout;
 	unsigned long *pfns;
 	unsigned long end;
 	unsigned long i;
@@ -203,15 +202,9 @@ int amdgpu_hmm_range_get_pages(struct mmu_interval_notifier *notifier,
 		pr_debug("hmm range: start = 0x%lx, end = 0x%lx",
 			hmm_range->start, hmm_range->end);
 
-		timeout = jiffies + msecs_to_jiffies(HMM_RANGE_DEFAULT_TIMEOUT);
-
-retry:
 		r = hmm_range_fault(hmm_range);
-		if (unlikely(r)) {
-			if (r == -EBUSY && !time_after(jiffies, timeout))
-				goto retry;
+		if (unlikely(r))
 			goto out_free_pfns;
-		}
 
 		if (hmm_range->end == end)
 			break;
-- 
2.53.0



