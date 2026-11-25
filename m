Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795624473;
	b=jlL2Mqqkm8ASUoNnV1XX3E+wyGjbPCcWvx5jpZa1Av/utJ5KzIRh78+e8evxaViaOHVq
	 sE5z8+IFqGOmhX/cndIi5ZYEurwWhDFsXu4SCQe61CljmR1NcBd3pRC3d3Q4Cr+qEssqJ
	 F0mebl/yNB4KQZ0HENYEAe95XRKvZKuS94g9OGFxEO6SX6A2mYVOeKlSVA7J9jiqbra7q
	 8u18KpxDV4fa3VyOSd9wdlVwmNLsHzDobqOYPzyh6YKac9E7AY6U9H4ZKXrU/v6AJJnAy
	 2bVfNvZioUN9qTq0CESzMolcpjdyai3LWZyTDo2raSrk3E0RDoIXBJOosuxjHWfVLRw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795624473;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=1/CfZcSObHI9D3g3DfFwo+vACfPRLKxuvQcBqUbiJ9c=;
	b=WSBvJiwUj/NHsXn//A9MZOMYGxWTzjaQJVy7VQNX4+68ca1eFnTf4GEjvxhm1v//vSfn
	 QE0hW7pP82ctFRVqCWBpNVTE+mtW0VgNEjxDADbUfjsACLvICnA55C2D7Q7z2IWMG+XF2
	 R/I68IoM8RB94dX/0MLBpKjsYxfamGLt+LeBv5Um/nHxynquntNydLFXTJHPkGFsb3EDV
	 umGq6n5JfMfY9KwJ25jInANwvFr7SkLQGGdRGPte/EL+e3VblX2yflGsX04EhO52DoRP2
	 Llxg/ab6IavlX/+U+4uytXFJCmZSW6ucMT24bAEQuC/1taSI1NKsBEdLhZeQF3OUtIA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=vKFYRHGo;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A495606A33A;
	Wed, 25 Nov 2026 16:34:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=vKFYRHGo
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4300E1F000CA;
	Wed, 25 Nov 2026 16:34:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795624472;
	bh=1/CfZcSObHI9D3g3DfFwo+vACfPRLKxuvQcBqUbiJ9c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=vKFYRHGolnXUSLJ7YhkHuCMfex0Ntmfv+rwBYaXNA8xels8k53z7731B/Uk6ZZPUi
	 gI8KfHTVKf83UI0lwvJ8XGKdJt9OVu1CoLDBbqvWM8gN49fi3tHHVFpA7pcrgww842
	 /CM9JDl46TT9z/NIkv3cC05deSCb4Au2i005kk1U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhou Minqiang <zhouminqiang2@huawei.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 204/816] PM: runtime: Fix check_flush_dependency warning from pm_runtime_remove
Date: Wed, 25 Nov 2026 15:29:12 +0100
Message-ID: <20261125143853.918387327@linuxfoundation.org>
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
index 291941c22d959..68a871a517bd9 100644
--- a/drivers/base/power/runtime.c
+++ b/drivers/base/power/runtime.c
@@ -1887,7 +1887,7 @@ void pm_runtime_reinit(struct device *dev)
 void pm_runtime_remove(struct device *dev)
 {
 	__pm_runtime_disable(dev, false);
-	flush_work(&dev->power.work);
+	cancel_work_sync(&dev->power.work);
 	pm_runtime_reinit(dev);
 }
 
-- 
2.53.0



