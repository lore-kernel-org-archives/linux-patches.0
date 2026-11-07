Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794061399;
	b=1Rb8IBIlJ8mDuCX6ExV4XCvvUmt+VT1N42HJuPDBQXAP1dsubfWh38EQClYtEU+CDzxj
	 wpOAnkBDnZKL2tTcc9AveAtHTARyscwfROfKGTmsnc0+Vv41cI/G/2gr0YVtVLwJ5wpuO
	 7zv5+a8GsuA8xhy9xSs1kK6PZmgMnIQGwjrXIpKwcKTuzJsTkwPOxAaz6jraJ+xAoJyLT
	 YE6vi++xWfHAcP8TpD2fkYkDYy31x2aqr1Dw8XZ4blgMdRhEm1/80Fipb81E6zdiKq4el
	 3lFOxy9T9dcKnqnS4crJjxEluKhb3Q9caYD9f2WUGnoXdz7oz/EcJc6Y6HTx5fjTTVQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794061399;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=KxuC32uzeBuiBtCTRCZen4A5PQCUhyw8yZDbgICJcts=;
	b=pJE4lnG2EvNZvkbuknL1J80otM+WBoRWST0Kp5lyUkOnAAFj3k+JyHCqYRNjQi6pXVYc
	 3LnmJfPkL6CguKEEQoTvY9qULgh8CTBgoru6u4jtRx5tyEAzsNN86g6cczm2OesRiUQz3
	 rO72dbuNljO3K+LAIRtum4bOZMcthsbJWiferky+Y2rWZtQXpUtcRitTf5lB10pE17Bs8
	 UtzNDQ1nycj9zgYI84hyrIZgw4SG5JmoEXe8lxf8WB6wYHjlFOqUqfBqtLDRyCc08yRk3
	 yiUPIkzJBVkUCDmBmP8F4uTzyKGMYBISoZNfi4xpR4jd5nXjZrlOtuHtkb3o9p8ZSyA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=yO3yhCTJ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CEEC2606D80A;
	Sat,  7 Nov 2026 14:23:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=yO3yhCTJ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7CC461F0089F;
	Sat,  7 Nov 2026 14:23:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794061398;
	bh=KxuC32uzeBuiBtCTRCZen4A5PQCUhyw8yZDbgICJcts=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=yO3yhCTJu7pRFbwOq5LMd4HRWo0Kgyla9DyTc5gBOFtpt9M6TNzymElinGRQQujvp
	 S+I6cZ9eVezor08v+YbvPlbyGJlS7tT4IjyRGLw/6Qy6mdhS4a0O1WFqD+wAi9EnHp
	 WbYHeeznR7myz2b6JXTs3nckvGnRrf9ki/AknHhc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Jonghyuk Kim(MalHyuk)" <malhyuk97@gmail.com>,
	Rob Clark <robin.clark@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0517/1536] drm/msm: RCU-free the scheduler-containing ring and VM objects
Date: Sat,  7 Nov 2026 08:42:13 -0500
Message-ID: <20261107135011.951579878@linuxfoundation.org>
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
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

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
[ sashal: Dropped the VM half (the msm_gem_vm rcu field and its kfree_rcu) since that struct doesn't exist here, and kept only the ring rcu_head and kfree_rcu() change. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/msm/msm_ringbuffer.c | 2 +-
 drivers/gpu/drm/msm/msm_ringbuffer.h | 1 +
 2 files changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/msm/msm_ringbuffer.c b/drivers/gpu/drm/msm/msm_ringbuffer.c
index 917768a17a0b9..3a95077027773 100644
--- a/drivers/gpu/drm/msm/msm_ringbuffer.c
+++ b/drivers/gpu/drm/msm/msm_ringbuffer.c
@@ -134,5 +134,5 @@ void msm_ringbuffer_destroy(struct msm_ringbuffer *ring)
 
 	msm_gem_kernel_put(ring->bo, ring->gpu->aspace);
 
-	kfree(ring);
+	kfree_rcu(ring, rcu);
 }
diff --git a/drivers/gpu/drm/msm/msm_ringbuffer.h b/drivers/gpu/drm/msm/msm_ringbuffer.h
index 72e4de1aafa2c..c7d0e328ae5af 100644
--- a/drivers/gpu/drm/msm/msm_ringbuffer.h
+++ b/drivers/gpu/drm/msm/msm_ringbuffer.h
@@ -51,6 +51,7 @@ struct msm_ringbuffer {
 	/*
 	 * The job scheduler for this ring.
 	 */
+	struct rcu_head rcu;
 	struct drm_gpu_scheduler sched;
 	bool sched_initialized;
 
-- 
2.53.0



