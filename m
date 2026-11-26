Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795704302;
	b=2aMaTLzLWYCdx+Q3I21yE2Q5YGsmeUdFDxInevEtT5A/YXZyfhpTZOVIyPSbMJ3+v0GZ
	 vm/WBbGrpqxDrcKG1/KiC5dqCZVgMkCn9VA22F7TLTB/4BL6o30/9OmIzsb1x0iu7sWSI
	 fZspjlkA6qxdY01RRiom263Uhc2PSi9yONW3Mz9O5XYqV2EcaNkHyqAusVn9kv+s+ET02
	 eQMYcyup7OW8r52+6U9YujnmxxG96fhusAq9H2QL8c0p6gp8c7CnJ2WKbhIF5EnCJ/YPj
	 qmvUbAgJ7hUcKgRBbM4THF5dQv4p82pHQ+0JAyfcfFKVFk9HEVs5rtWTU4xZMAqlxvw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795704302;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=COMrjZc/u8dvxxXM7lGYALJ4Dp/VtXrYy4ID4ekrl/c=;
	b=lZcNTpnOXbLybeDM/2X8a3QrZOzZPCu3kOj7kpXvOU38QNuZvLGXrHLKHzSjCyqlKpw6
	 6X+gRctdsG0EXRJyoFeEKxt/IQFlH6SCmamEemjEf9f4r7t2CI9gULVBu95NdYiEr/Myj
	 1U/mzGpPXEbgtpAhmZoIFqPcfM/6CbWK9KqTp88Nv0SURnwfioKYDFbQE1Urj3r4dgoCG
	 MXldYdwc+JdDQjJ6/2DBHVLtTJ198134U9HKpuVoeqNgdTdkrw3KbWZTiQubeuUG0+kch
	 T0NJH/IGWP0LdBxaaKa64SnpkH11nC9cQmUPrIegXl+UOn5ZHIilP1kgrZ5q0G/7HXQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=aTEqxH2j;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC8D1606A32D;
	Thu, 26 Nov 2026 14:45:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=aTEqxH2j
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4321A1F000C4;
	Thu, 26 Nov 2026 14:45:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795704302;
	bh=COMrjZc/u8dvxxXM7lGYALJ4Dp/VtXrYy4ID4ekrl/c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=aTEqxH2jd1RRWRhMCdqudtLhUIdZ0ECg3JNsnvlapZWhbrsTQ+UtNPVHevSnhhihL
	 xrp8Q7djd5EkrIG0+aPPQi8dd+ICtHmeP0UcQyIc9NSZ6jC1fsJw7hgrVqHB5lwBUW
	 f/FTOGIlVkEm0uN38SeLVL4DNanjtL9UVouOTrzI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhou Minqiang <zhouminqiang2@huawei.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 075/265] PM: runtime: Fix check_flush_dependency warning from pm_runtime_remove
Date: Thu, 26 Nov 2026 15:36:45 +0100
Message-ID: <20261126143610.309908975@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261126143605.076581697@linuxfoundation.org>
References: <20261126143605.076581697@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zhou Minqiang <zhouminqiang2@huawei.com>

[ Upstream commit 1f65b45f0f16e1c80a68a5757c9556f78bb39f19 ]

When a WQ_MEM_RECLAIM workqueue (e.g. iscsi_ctrl) triggers device removal
via device_del -> pm_runtime_remove, the unconditional flush_work inside
pm_runtime_remove can trigger a check_flush_dependency warning:

  CPU1: pm_wq worker                 CPU2: iscsi_ctrl wq
  --------                           --------

  pm_runtime_work(starget)           pm_runtime_remove(starget)
    spin_lock_irq(&starget->lock)      __pm_runtime_disable(starget, false)
    request_pending = false              spin_lock_irq(&starget->lock)
                                         (blocked, CPU1 holds the lock)

    rpm_suspend(starget, RPM_NOWAIT)
      status = RPM_SUSPENDING
      rpm_callback(cb, starget)
        spin_unlock_irq(&starget->lock)
                                         (acquires lock)
                                         disable_depth 0→1
                                         __pm_runtime_barrier():
                                           request_pending == false
                                             → skip cancel_work_sync
                                           status == RPM_SUSPENDING
                                             → enter wait_queue, sleep
                                           spin_unlock_irq(&starget->lock)
        cb(starget) → 0
        spin_lock_irq(&starget->lock)
      status = RPM_SUSPENDED
      wake_up_all(&wait_queue)
                                           (woken up, waiting for lock)
      spin_unlock(&starget->lock)          spin_lock_irq(&starget->lock)
                                             status == RPM_SUSPENDED
      spin_lock(&parent->lock)                → exit wait_queue
      rpm_idle(parent, RPM_ASYNC)        barrier returns
      spin_unlock(&parent->lock)       flush_work(&starget->work)
      spin_lock(&starget->lock)          __flush_work(from_cancel=false)
      spin_unlock_irq(&starget->lock)      check_flush_dependency()
                                            ← WARNING!

Replace flush_work with cancel_work_sync in pm_runtime_remove.
cancel_work_sync internally calls __flush_work with from_cancel=true,
which causes check_flush_dependency to return early before the warning.
This preserves the use-after-free fix from commit 29ab76827761
("PM: runtime: Fix a race condition related to device removal")
without the warning.

Fixes: 29ab76827761 ("PM: runtime: Fix a race condition related to device removal")
Signed-off-by: Zhou Minqiang <zhouminqiang2@huawei.com>
Link: https://patch.msgid.link/20261104115641.2682786-1-zhouminqiang2@huawei.com
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/base/power/runtime.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/base/power/runtime.c b/drivers/base/power/runtime.c
index ec14c3089e329..32d72f555710e 100644
--- a/drivers/base/power/runtime.c
+++ b/drivers/base/power/runtime.c
@@ -1776,7 +1776,7 @@ void pm_runtime_reinit(struct device *dev)
 void pm_runtime_remove(struct device *dev)
 {
 	__pm_runtime_disable(dev, false);
-	flush_work(&dev->power.work);
+	cancel_work_sync(&dev->power.work);
 	pm_runtime_reinit(dev);
 }
 
-- 
2.53.0



