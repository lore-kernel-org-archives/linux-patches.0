Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795624704;
	b=Lk7KhQ/BcixOrMOvtGWmdW3Mn3NuSePRtJGW8gVqt3YFJdVAxNQBngpHlFZd7Rp69r1y
	 cNEpADyt0c40YLJXdYzJM/iG3Gx5SoakuYk4+yORzGzLUaeX2rl52Ezym1wTixfkR/hs0
	 alBeQQQ2h3msABAze2ggEzuRrjfyR8fpWveVHHVRtX/g4CGyqULvkxAw1jPgVUbeaxE1p
	 1DhOszRaucaDjgPWeMRCTgeeWqLqOMmuQzHDr6Xcg1AslC1TMzi+Fj7TbxRzVHVDuOdBX
	 m1RM68VzWpEt8OUb2e9fyYAUQU4vsKU57WIuwtBoRqocMJu44JrqtOa+0fbLYs5It1Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795624704;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=I3HFMTeZDC/dxfdIjgtrwB5aCpS6Rv/YKdTQXhevIXw=;
	b=4idnFFXBAaVlbJDgyb2q4iX9hHArwt12YaxnZZnTtGMN+R8yEeq0NCPFk0lsjCnOIvJK
	 38YCF9GV8MkNky7DkJdHtfYLyTmjaxWrBPZFZ/oSZHKiG1xZ1sWu4WqpFZTY0ecwJTPez
	 7U3pHhWaIYy3pvr7bFr9InfLjKRkFaLkyR9WvK889Tl15+lu2u295YcPL0vd1CzieJNXb
	 9JQUiW4OFywVrApTpagwy13ntzTJWCsEf8Vd7SWccEnrt318SUIjmJpDolhAEXXRWjrFV
	 ++3xsiCrBlPJr6FnV8/ttoAhwlAFzku2xtCe1c33RfPDTiX4VDlwRapBBCehb5TVnPQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=p9A11gG0;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E0BA606A33A;
	Wed, 25 Nov 2026 16:38:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=p9A11gG0
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8671A1F000C4;
	Wed, 25 Nov 2026 16:38:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795624704;
	bh=I3HFMTeZDC/dxfdIjgtrwB5aCpS6Rv/YKdTQXhevIXw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=p9A11gG0qWC5khwTjxmq/fCPVLl/8TQFS+fcOHYXLIuXWgqIYYlGPhJyvSjpsnFfi
	 NyttNVB8sNx3AM4C3ADx0HO78A0vBQx6d9LyB9UcxMTvQT6jCw4u858ZDEBQbT54nU
	 59yQoPtfflsIv7wchyInI+ac1EzVloZ7YmHqaZdQ=
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
Subject: [PATCH 6.12 281/816] drm/xe: Rebind BOs evicted before the first LR queue
Date: Wed, 25 Nov 2026 15:30:29 +0100
Message-ID: <20261125143855.712778417@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143849.205329330@linuxfoundation.org>
References: <20261125143849.205329330@linuxfoundation.org>
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
index 310178a5652a3..7fb407d9e9caf 100644
--- a/drivers/gpu/drm/xe/xe_vm.c
+++ b/drivers/gpu/drm/xe/xe_vm.c
@@ -273,8 +273,15 @@ int xe_vm_add_compute_exec_queue(struct xe_vm *vm, struct xe_exec_queue *q)
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
 		dma_fence_enable_sw_signaling(pfence);
 
-- 
2.53.0



