Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795034719;
	b=ufu+jRegNvROjYgl6aZpD+YCITRVWjVKKY7mba7BSn2h945X5MonWZGAUVf0u6OIhw9L
	 KW/ZZTJ4snB/80e7lVmPeZG3Gk6AvjZAimefkr3Jz+AFZxJCnfFoy7qVgJTbwdV/MJflf
	 5NHZ2h12QYNy6jAPIRvUV7L6UJS6FlCHbCqrdxsFgTQVuL2/b0Zr8VJBRN8A7B1Bpn/Q3
	 OgvC8DTEHIahNIiQYsH0imFA5G/9nln5K1XxvUIqE4fRYhVq97TVVJR5uLp/cDp2a5WIe
	 XaB+XhVP0pMBXKKVvLd1RX56Oufm2fw0pTycLKbUbk8hFy3vazUOJWvik8uv42Wp9hA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795034719;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=O01+Cd9Cy8IQK0k3m/Ha0l6MLRMHCghAnwLv9Ww797Y=;
	b=f3jAhF0Ei3I1e92Mlu+03xZxvugOdi+7f3COzMi6cKnxHchPr7LejYynx93HG81EMqCG
	 77F9wo7CAu0sxnxfzvOzyGuGv7gpavhKeW1G9rg2A4EXr3iMJD0AcS4GhW9k5ZD/2FlBW
	 Cb8zHdKgUxh2G4SnNPQwQF1h2ue+uNvkWfq1BDevMIl+sAsaG6HVwvpY3jk/gL80XCGeG
	 EjM2hjdk9toRcplkJ4qCk6IHm4wClA4JX6nncqpG4by8NXlB6dt/fXauIIjqHIK1nklGd
	 JnOzN5HOBGJsupAHWZaTmrmzb05hUzb1nnrlL3IR//n54PFYMMASkipu/UfBRtNQk8g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=xXT45LsK;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 48A08606A31C;
	Wed, 18 Nov 2026 20:45:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=xXT45LsK
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A3A271F000C4;
	Wed, 18 Nov 2026 20:45:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795034719;
	bh=O01+Cd9Cy8IQK0k3m/Ha0l6MLRMHCghAnwLv9Ww797Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=xXT45LsKTjiT2T/0vKBrRHw56zcpn8rhA+eAh5kZJ/5BxN3jXZhPyN8f1gAXITK10
	 364YaLLjVBWCGn2OyDUTEjNZcubrpzogxuP0wGfwqtH8qWP9gajVlvF5flesvsAKd5
	 EByBjnXApHHZVRpm79qwYK+JZL6wT4ihYbw80KVY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Jonghyuk Kim(MalHyuk)" <malhyuk97@gmail.com>,
	Rob Clark <robin.clark@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0468/3318] drm/msm: RCU-free the scheduler-containing ring and VM objects
Date: Wed, 18 Nov 2026 15:18:10 +0100
Message-ID: <20261118150330.913353181@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jonghyuk Kim(MalHyuk) <malhyuk97@gmail.com>

[ Upstream commit 01c8d1f385f788f1bbbbb7687c4386d614281218 ]

Both struct msm_ringbuffer and struct msm_gem_vm embed a struct
drm_gpu_scheduler.  msm_ringbuffer_destroy() and the VM free callback
msm_gem_vm_free() call drm_sched_fini() on the embedded scheduler and then
free the containing object with plain kfree().

drm_sched_fence_get_timeline_name() returns fence->sched->name, and the
scheduler fence keeps a .release callback so it is not ops-detached on
signalling.  A finished fence exported to userspace (the submit out-fence, or
a VM_BIND fence, via sync_file / drm_syncobj) keeps pointing at the embedded
scheduler after the ring/VM is freed, so a later get_timeline_name() --
reachable unprivileged through SYNC_IOC_FILE_INFO -- dereferences freed slab
memory (KASAN slab-use-after-free read).

Per the dma-fence lifetime contract the exporter must keep the data backing a
signalled fence alive for an RCU grace period.  Free the scheduler-containing
objects with kfree_rcu() instead of kfree().

Fixes: 1d8a5ca436ee ("drm/msm: Conversion to drm scheduler")
Fixes: 92395af63a99 ("drm/msm: Add VM_BIND submitqueue")
Cc: stable@vger.kernel.org
Signed-off-by: Jonghyuk Kim(MalHyuk) <malhyuk97@gmail.com>
Patchwork: https://patchwork.freedesktop.org/patch/750234/
Message-ID: <20260902012720.880783-1-malhyuk97@gmail.com>
Signed-off-by: Rob Clark <robin.clark@oss.qualcomm.com>
[ sashal: Dropped the VM-side hunks (no VM structures exist in this tree) and changed the context line ring->gpu->vm to ring->gpu->aspace, keeping only the ring kfree_rcu() change. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/msm/msm_ringbuffer.c | 2 +-
 drivers/gpu/drm/msm/msm_ringbuffer.h | 1 +
 2 files changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/msm/msm_ringbuffer.c b/drivers/gpu/drm/msm/msm_ringbuffer.c
index ba9d51f47ffb6..6b15dfce62cea 100644
--- a/drivers/gpu/drm/msm/msm_ringbuffer.c
+++ b/drivers/gpu/drm/msm/msm_ringbuffer.c
@@ -132,5 +132,5 @@ void msm_ringbuffer_destroy(struct msm_ringbuffer *ring)
 
 	msm_gem_kernel_put(ring->bo, ring->gpu->aspace);
 
-	kfree(ring);
+	kfree_rcu(ring, rcu);
 }
diff --git a/drivers/gpu/drm/msm/msm_ringbuffer.h b/drivers/gpu/drm/msm/msm_ringbuffer.h
index eafaa7cef3242..01c257f6e77c3 100644
--- a/drivers/gpu/drm/msm/msm_ringbuffer.h
+++ b/drivers/gpu/drm/msm/msm_ringbuffer.h
@@ -49,6 +49,7 @@ struct msm_ringbuffer {
 	/*
 	 * The job scheduler for this ring.
 	 */
+	struct rcu_head rcu;
 	struct drm_gpu_scheduler sched;
 	bool sched_initialized;
 
-- 
2.53.0



