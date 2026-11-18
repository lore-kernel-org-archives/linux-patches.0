Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795020692;
	b=TYmm/Lznfhx1341CeWa7A+5UjOu2DEsdOZ56jGGLqNzYcCFljdj+1voXgOCR1yDjdBKm
	 T7w9OH/VDole/1grqRw5cOGH/mRVoB/vIbjur49xFc3O+S8MpotprJuUbCB79NX3Hmmsa
	 DPguY2h6dAEnRypXMe6hlLmzqzutI0AOqstKf6scNQdrWike/XBfGBq1QO5FadV+dD/WW
	 dDvud85p9W6iThdjRBdB0ybWut10Dtp58rK5MzJH2It0NnHLdHh7cJRqJeH713Mf9R4G+
	 amLKh/3FbBiflD+l8HC5IETpaVeIdO2LBeKdvqJVZ2z/PpfD3IQj/buq2VWukAVWFZQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795020692;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=colL7mI/FsPW4CYGkUFI/liibQVWIq9IBNVRzIF6Ggk=;
	b=nJME9ueFTPt1a31yGBTs/q/5wnlX4YZjhLYddvP0wqQfktUVhoA/h9CuBfgAv5wLH7as
	 JUrZOoxReyYxk3rWwpngRPck7CTnVXrIAn7yRMn+BP7D+iMUgJddT2oKOC0rNXfLy4KW9
	 lrSOlqcvP+vOH7XaEPLOZcLU3/YnM+e1iOuuUJq2SQPStvJ4XeB3RhkTnIANjRXE0a8fE
	 6N7kF42/b8bd0vBpej5Mt/G8Rz1WAjxggOvWQIxCpZXGk2hQsL/jHu7hQyFEKbyU4rAzA
	 diaQhjzQ0oUVBWqiKlwJNoE8SYZKBxq7AUE6Tfuy1/fvMpBRMwxMAKAPolX0t69p3fg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=tygHcpAc;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8BC4460A262C;
	Wed, 18 Nov 2026 16:51:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=tygHcpAc
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A69EA1F000CA;
	Wed, 18 Nov 2026 16:51:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795020692;
	bh=colL7mI/FsPW4CYGkUFI/liibQVWIq9IBNVRzIF6Ggk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=tygHcpAc9ybDvJ1JEe6Z90Ymf23UpbcadOww9ZmCSLVj9/GTpQ9RWE8Y6uItRDa09
	 y38+mimPag/rxJMnW9520BLyzRvOkCLVHh0qnuR5v2k6W6UeN90Kt98neQEdOrlXGn
	 ZhJUplEhMx6cqqAf2OhH3ZMPbkGG2jlUnj2s2N80=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Boris Brezillon <boris.brezillon@collabora.com>,
	Liviu Dudau <liviu.dudau@arm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 2041/2651] drm/panthor: Fully disable the AS even if its going to be re-assigned
Date: Wed, 18 Nov 2026 15:54:41 +0100
Message-ID: <20261118150359.572398527@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Boris Brezillon <boris.brezillon@collabora.com>

[ Upstream commit a431d4ec5d938893060f69a018a2c47651c282d9 ]

We're trying to be smart by skipping the UPDATE(UNMAPPED) step, but
it remains to be proven it adds any noticeable overhead. Moreover, it's
breaking the assumption that, once the VM is unbound, no access can
happen on it.

For instance, say the panthor_mmu_as_enable() call in panthor_vm_active()
fails after we've called panthor_vm_release_as_locked(), we're now in a
state where the HW still points to the old page table, but SW slot points
to the new VM, which is not truly HW-bound.

If, after the as_slots lock is released, the evicted VM itself is
released, the HW might have access to memory that has been returned
to the system until the reset we scheduled (because of the faulty
AS_COMMAND) is effective.

Let's make this bullet-proof by doing a full bound -> unbound -> bound
cycle on AS slot recycling.

Fixes: 32e593d74c39 ("drm/panthor: Make sure caches are flushed/invalidated when an AS is recycled")
Signed-off-by: Boris Brezillon <boris.brezillon@collabora.com>
Reviewed-by: Liviu Dudau <liviu.dudau@arm.com>
Signed-off-by: Liviu Dudau <liviu.dudau@arm.com>
Link: https://patch.msgid.link/20260924-panthor-mmu-fixes-v1-2-e25f9b106466@collabora.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/panthor/panthor_mmu.c | 21 +++++++--------------
 1 file changed, 7 insertions(+), 14 deletions(-)

diff --git a/drivers/gpu/drm/panthor/panthor_mmu.c b/drivers/gpu/drm/panthor/panthor_mmu.c
index 41ae159aeb7dd..7ed89d484d0f4 100644
--- a/drivers/gpu/drm/panthor/panthor_mmu.c
+++ b/drivers/gpu/drm/panthor/panthor_mmu.c
@@ -620,8 +620,7 @@ static int panthor_mmu_as_enable(struct panthor_device *ptdev, u32 as_nr,
 	return as_send_cmd_and_wait(ptdev, as_nr, AS_COMMAND_UPDATE);
 }
 
-static int panthor_mmu_as_disable(struct panthor_device *ptdev, u32 as_nr,
-				  bool recycle_slot)
+static int panthor_mmu_as_disable(struct panthor_device *ptdev, u32 as_nr)
 {
 	struct panthor_mmu *mmu = ptdev->mmu;
 	struct panthor_vm *vm = ptdev->mmu->as.slots[as_nr].vm;
@@ -645,12 +644,6 @@ static int panthor_mmu_as_disable(struct panthor_device *ptdev, u32 as_nr,
 			return ret;
 	}
 
-	/* If the slot is going to be used immediately, don't bother changing
-	 * the config.
-	 */
-	if (recycle_slot)
-		return 0;
-
 	gpu_write64(mmu->iomem, AS_TRANSTAB(as_nr), 0);
 	gpu_write64(mmu->iomem, AS_MEMATTR(as_nr), 0);
 	gpu_write64(mmu->iomem, AS_TRANSCFG(as_nr), AS_TRANSCFG_ADRMODE_UNMAPPED);
@@ -777,7 +770,7 @@ int panthor_vm_active(struct panthor_vm *vm)
 		drm_WARN_ON(&ptdev->base, refcount_read(&lru_vm->as.active_cnt));
 		as = lru_vm->as.id;
 
-		ret = panthor_mmu_as_disable(ptdev, as, true);
+		ret = panthor_mmu_as_disable(ptdev, as);
 		if (ret)
 			goto out_unlock;
 
@@ -919,7 +912,7 @@ static void panthor_vm_declare_unusable(struct panthor_vm *vm)
 	vm->unusable = true;
 	mutex_lock(&ptdev->mmu->as.slots_lock);
 	if (vm->as.id >= 0 && drm_dev_enter(&ptdev->base, &cookie)) {
-		panthor_mmu_as_disable(ptdev, vm->as.id, false);
+		panthor_mmu_as_disable(ptdev, vm->as.id);
 		drm_dev_exit(cookie);
 	}
 	mutex_unlock(&ptdev->mmu->as.slots_lock);
@@ -1911,7 +1904,7 @@ static void panthor_mmu_irq_handler(struct panthor_device *ptdev, u32 status)
 			ptdev->mmu->as.slots[as].vm->unhandled_fault = true;
 
 		/* Disable the MMU to kill jobs on this AS. */
-		panthor_mmu_as_disable(ptdev, as, false);
+		panthor_mmu_as_disable(ptdev, as);
 		mutex_unlock(&ptdev->mmu->as.slots_lock);
 
 		status &= ~mask;
@@ -1940,7 +1933,7 @@ void panthor_mmu_suspend(struct panthor_device *ptdev)
 
 		if (vm) {
 			drm_WARN_ON(&ptdev->base,
-				    panthor_mmu_as_disable(ptdev, i, false));
+				    panthor_mmu_as_disable(ptdev, i));
 			panthor_vm_release_as_locked(vm);
 		}
 	}
@@ -2065,7 +2058,7 @@ static void panthor_vm_free(struct drm_gpuvm *gpuvm)
 		int cookie;
 
 		if (drm_dev_enter(&ptdev->base, &cookie)) {
-			panthor_mmu_as_disable(ptdev, vm->as.id, false);
+			panthor_mmu_as_disable(ptdev, vm->as.id);
 			drm_dev_exit(cookie);
 		}
 
@@ -3360,7 +3353,7 @@ void panthor_mmu_unplug(struct panthor_device *ptdev)
 
 		if (vm) {
 			drm_WARN_ON(&ptdev->base,
-				    panthor_mmu_as_disable(ptdev, i, false));
+				    panthor_mmu_as_disable(ptdev, i));
 			panthor_vm_release_as_locked(vm);
 		}
 	}
-- 
2.53.0



