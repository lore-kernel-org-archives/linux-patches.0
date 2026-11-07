Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794060363;
	b=efdmzVFm1ihOUPvJoueN140zy33c0FEG+cvZDcGdDhq+Qfj8WFS7ml6U1b1K9u68ttpB
	 Dasw2Hyw2ybfDyBO/TcZ/enzD0HG/yN/RIhcQlzzQUJXFoGCySvUb/6Ilg6IMBQJYrP39
	 NpUpGby55c41LhvzjgRlPPxgojprQf9dIvdnZGRHSdss1JrQOgv5nMmgJYU4titcd6/v7
	 L/ystrFfVNxxI760S4h4nSIuJPedoflT24D9G2vbe8QNBZDCOPZ1ccmtyZgJGCPCjNxzV
	 xr0tM973GTbyVKhz76jhHbqRUcRbrmdWWaV6bYQLu67u8JEPB0geaACBEr6LYow62mw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794060363;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=ztBUZS8A2QLBcele2HV+r5WD0EFJ0/27sstl0v/PrNc=;
	b=EllJPliVOY+kvfyURLjyYM5T6Du14U8xI5CLjYgmrzDQH+jrWupULNvLCnjWPVdKLivU
	 H/HRLA0/zat9J8eeacI5uDwhkanzk6aXbYBpn86y43/K+o3FnoqNQwkOHtLMWWg8MwI59
	 kXAhqtbgQ63oOonl44oxbaJf9ciJfgq//+iIBRFYVdqzM0oh0fyVu+1Ql4jarolMl6tT2
	 NJe1k2MW3TudSfgKCOB9FMSVW6dgdBStg0ok+cgk3XGFyuruKExu4s4WW8vNhXZl6GpWm
	 ju42eWaFeXfNadUhNHbLqOW0BBOh+2ypFOY0BUSRuDg/KuO7axMDClNsV2v0+vxks8A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=SpKvpUUz;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 892ED606A32E;
	Sat,  7 Nov 2026 14:06:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=SpKvpUUz
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2CD9B1F0089F;
	Sat,  7 Nov 2026 14:06:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794060363;
	bh=ztBUZS8A2QLBcele2HV+r5WD0EFJ0/27sstl0v/PrNc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=SpKvpUUzJJck9J12Fkb9/vOy1Yaj8hwt1j6bYdN5p1ZqTNzpsIx4l6EOOyl2c4Pk1
	 6/4BqyYvz0x6hp9oxrmUoOe52nsK2UTw3NL94eQyZchEqmSN3lfJG6hMc43skCOchv
	 pklGaxKNachBfeqRUO25z8azmgFFeJOYjW4kwRtA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	Honglei Huang <honghuan@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 004/869] drm/amdgpu: drop retry loop in amdgpu_hmm_range_get_pages
Date: Sat,  7 Nov 2026 08:44:46 -0500
Message-ID: <20261107134852.202517425@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134852.069646174@linuxfoundation.org>
References: <20261107134852.069646174@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
[ sashal: Adjusted the declaration context: this tree allocates hmm_range with kzalloc() as a plain pointer rather than embedding it, so only the timeout declaration was dropped. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_hmm.c | 9 +--------
 1 file changed, 1 insertion(+), 8 deletions(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_hmm.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_hmm.c
index db2bb5cb671d3..fa3676c5babcd 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_hmm.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_hmm.c
@@ -173,7 +173,6 @@ int amdgpu_hmm_range_get_pages(struct mmu_interval_notifier *notifier,
 	const u64 max_bytes = SZ_2G;
 
 	struct hmm_range *hmm_range;
-	unsigned long timeout;
 	unsigned long *pfns;
 	unsigned long end;
 	int r;
@@ -204,15 +203,9 @@ int amdgpu_hmm_range_get_pages(struct mmu_interval_notifier *notifier,
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



