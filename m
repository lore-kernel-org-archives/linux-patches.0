Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795618830;
	b=g/fsEkP5lIvak4rHqcJ1e1fJRvIZygLg6wVNwO2kN0bt8Wrk2YrkmAqgG90dZEZ1Lmax
	 bVo7/5ZkfNh4dMa6hx5dhgEhTivZXbAfimqYvkrZA4LRBray3dn56lPYiwn30Yl9sXT/E
	 D8kHWa8kcKYRb9bCK5uVUhWMvQNYRscNsfWpROW95zc7LVrrWyYrWHintOVlA4sWNN+UV
	 fJ9n3jbIL0mAC66i+3wD4zIqqtAAHF1SeM1Z+DiYP6hoVcNWeWr0n785yeGNxdY+PkjKV
	 7GJb9RJolREAvVH8o02M0i+6UGxcEGkALqoJhGCqxnvIop/nMCl7y0LzRRIugxZ4uog==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795618830;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=pWCZDazaYpyQlr+0Gyw9dvX/6mmM/mzEvY4p94CmLLw=;
	b=1LPRF1wf/JVNHpEu/x8VNCIlrPZ4jdl4kq9j44WndPdz7TIiMWOsY4oSPgWMxjM4mZi6
	 7ZlDS6cXx0SS0JifNjrPeTEsBYqe1kkr1Y9mYFq+z8hVdokyGdCEGohe1vXCI7+6BsdxH
	 w1bWkzkFOW2st4a60gXFwmIFw4Iy5ZdJ8y/85EI4cSGh+6cPZPr19vNN0Fx2C4TLkgc6r
	 5vpIjLQHNNnHzPFal+gJztxE5TnEJoUT6SU/g5bAvwwIhUMggQpbKZDanqpmYtYcsFnov
	 FXs1ObqhmVOuB5lxkKVWYed2m9DKqmNUQfPIJ6lXbOpXC54Igeqy4iLPPuQegnL0zeA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=hSc0hJbK;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 68263606A323;
	Wed, 25 Nov 2026 15:00:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=hSc0hJbK
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 70D7D1F000C0;
	Wed, 25 Nov 2026 15:00:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795618830;
	bh=pWCZDazaYpyQlr+0Gyw9dvX/6mmM/mzEvY4p94CmLLw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hSc0hJbKBhtIA4HlXtgAdIdwPIGEfIWyCThgLKpRJrX5sHlzQwo+kJnF0ZHQZJPYX
	 a5AIxd7AbHoUoKaGNGXh/JPVxp/zxdN8QjtqiOgc1LwXFAsJk787kSakaF4cyHzo2t
	 PsjgenTutS4374fSaj0T6PIIVMtES2uXWvgcPVXU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Matthew Brost <matthew.brost@intel.com>,
	=?UTF-8?q?Thomas=20Hellstr=C3=B6m?= <thomas.hellstrom@linux.intel.com>,
	Himal Prasad Ghimiray <himal.prasad.ghimiray@intel.com>,
	Arvind Yadav <arvind.yadav@intel.com>,
	Tejas Upadhyay <tejas.upadhyay@intel.com>,
	Dave Airlie <airlied@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0400/1005] drm/xe: Rebind BOs evicted before the first LR queue
Date: Wed, 25 Nov 2026 15:28:58 +0100
Message-ID: <20261125143831.114649382@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143821.729802100@linuxfoundation.org>
References: <20261125143821.729802100@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Arvind Yadav <arvind.yadav@intel.com>

[ Upstream commit b52dcc698250e08eabdc4554a6fdb4d6f909133f ]

A VM bind can evict BOs before the first LR exec queue is added.
There is no preempt fence to trigger at that point.

When the queue is added later, its new preempt fence is not triggered.
The exec IOCTL does not validate or rebind BOs in preempt fence mode,
and the rebind worker skips that work because no preempt fence is
waiting. The first exec can then use stale mappings.

Trigger the new preempt fence in xe_vm_add_compute_exec_queue() when
the VM has evicted BOs or pending rebinds. This keeps the queue
suspended until the rebind worker validates the BOs and restores
their mappings.

Fixes: dd08ebf6c352 ("drm/xe: Introduce a new DRM driver for Intel GPUs")
Cc: Matthew Brost <matthew.brost@intel.com>
Cc: Thomas Hellström <thomas.hellstrom@linux.intel.com>
Cc: Himal Prasad Ghimiray <himal.prasad.ghimiray@intel.com>
Reviewed-by: Matthew Brost <matthew.brost@intel.com>
Signed-off-by: Arvind Yadav <arvind.yadav@intel.com>
Link: https://patch.msgid.link/20261015162639.3528278-1-arvind.yadav@intel.com
Signed-off-by: Tejas Upadhyay <tejas.upadhyay@intel.com>
(cherry picked from commit 928ee5d4fb1f211aa361524801c15b54603fae52)
Signed-off-by: Matthew Brost <matthew.brost@intel.com>
Signed-off-by: Dave Airlie <airlied@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/xe/xe_vm.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/xe/xe_vm.c b/drivers/gpu/drm/xe/xe_vm.c
index 99e42bd29e790..90820f5fff283 100644
--- a/drivers/gpu/drm/xe/xe_vm.c
+++ b/drivers/gpu/drm/xe/xe_vm.c
@@ -269,8 +269,15 @@ int xe_vm_add_compute_exec_queue(struct xe_vm *vm, struct xe_exec_queue *q)
 	 * Check to see if a preemption on VM is in flight or userptr
 	 * invalidation, if so trigger this preempt fence to sync state with
 	 * other preempt fences on the VM.
+	 *
+	 * Also trigger it if eviction or rebinding is pending. BOs evicted
+	 * before the first exec queue was added had no preempt fence to
+	 * trigger. Suspend this queue until the rebind worker restores
+	 * the mappings.
 	 */
-	wait = __xe_vm_userptr_needs_repin(vm) || preempt_fences_waiting(vm);
+	wait = __xe_vm_userptr_needs_repin(vm) || preempt_fences_waiting(vm) ||
+		!list_empty(&vm->gpuvm.evict.list) ||
+		!list_empty(&vm->rebind_list);
 	if (wait)
 		dma_fence_enable_signaling(pfence);
 
-- 
2.53.0



