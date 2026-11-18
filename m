Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795044156;
	b=NvwRxNA+3+WZzeC0M+9OlvintnZ3fMbKLSkr0c4er+BIwxWQ+gwe4RfqpP7GwQsqNAyp
	 edh2wraHv0vICrE8q9KOG1Vn4rEMbHHSx7I0rMsELuc//xE6WHaoRinQu0RxxnLIRATpI
	 cgnd3NrRjjG7rH6urpk/+YXcyrKacY1HMAxcjgc8kanYHzatMxWiSsFY7GDTf5PcAuXQD
	 T22uHMOJHhUZfEh2nQOz08vy5msj0ohfUkyWXLW7Unf2A51X1kh5EfmA2v4AUiMx2HVpJ
	 B8eAocUl0ArSW1A1NFVYUDNM+84S4gQS6mTAZH+KmX2EpavKNnKKde3Ew2hJlvpAuPg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795044156;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ra/QwUUkl2UnSdXhO8oh8QWqDgRv7dvqMUDVhfbaaqU=;
	b=lnZ0JLldiaToeHlzwT49h+xyVFm93oi2HCCHOI1mMx8CsBfTrs391lYxMt1y62gpZsva
	 003Nn9PT0RbqpJHOafimSY6kZkLKIUw5mWDPvoyxHYGYkI69DXvZ9y1u4wIJVmqflr01r
	 ssdsDYATSac4vfe4YW31GSf92bRW+tiftzJVnJ0r9eCXFQPszxFCSlpyap1VtSYH6DBoR
	 13SCDUAlnZZpF4sUV1MDgzata9ydJjBwmVKncbL/AhOEZtvzlMx6CbDL1Ch7lDlGU6GRF
	 pQ3yyIwz/46j3zGiceGcwHu+pvKABsvgLBgdGssFyGEyDNf/GVI+z3nf3WU/1RDW5EA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=X9ghyMGi;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1EC39606A31C;
	Wed, 18 Nov 2026 23:22:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=X9ghyMGi
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6B02B1F000C4;
	Wed, 18 Nov 2026 23:22:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795044156;
	bh=ra/QwUUkl2UnSdXhO8oh8QWqDgRv7dvqMUDVhfbaaqU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=X9ghyMGimDClG719XTwKQoGdTNXgaILSXVjpHqzeftG0yFu33MEYmNuWinY0rG8Oa
	 UY3XumDdKb54EjhQSXx9X0EmdeIRFN5J+13r8xJdW/yHtIpTe5zrN13wA2pPlUPojd
	 izbMiwo7Yfo630BSRBqk45SESrtTXSJeyGISDqWg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Jonghyuk Kim(MalHyuk)" <malhyuk97@gmail.com>,
	Rob Clark <robin.clark@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0418/2857] drm/msm: RCU-free the scheduler-containing ring and VM objects
Date: Wed, 18 Nov 2026 15:24:12 +0100
Message-ID: <20261118150216.432511403@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
[ sashal: Dropped the VM half since this tree has no msm_gem_vm, and ring context changed ring->gpu->vm to ring->gpu->aspace. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/msm/msm_ringbuffer.c | 2 +-
 drivers/gpu/drm/msm/msm_ringbuffer.h | 1 +
 2 files changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/msm/msm_ringbuffer.c b/drivers/gpu/drm/msm/msm_ringbuffer.c
index af9ba8bba445e..f80d482779b02 100644
--- a/drivers/gpu/drm/msm/msm_ringbuffer.c
+++ b/drivers/gpu/drm/msm/msm_ringbuffer.c
@@ -130,5 +130,5 @@ void msm_ringbuffer_destroy(struct msm_ringbuffer *ring)
 
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



