Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795618420;
	b=rGbZxZRa/A9JCY8NBI2LCHbyaTOlzqTnCxQi0vbvsJcjesgNUsQk32dHrd2a+5pipqrL
	 6wC6ibEpT64IGeLQAAwSpGhisexy3e6l9ilkSlUudgMNXupDMDz/R8qYwOBbZbrU0eK71
	 aal+Rce595pAqt9afyWlN69d+EJPbBj/OsBrbPrAqMxiKm3fmgQzgF99wjECbbiIH8mRb
	 jTo/59MqL5mKjMmHE7gtkhByCYtryubiFGQ4ZY6gxJHXP3D+rdFaB72A+I7ICMfMlUD7S
	 iLdcOAihw15GSz6dU+1ByoXOs574IJzwGBCVWZamRYonH3dgA2b+Fqf5IgHuL862Y9A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795618420;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=GZQD9riHhsJyYmzjCRGe6NSTDDHfiSJXoXW3NV5lNlI=;
	b=r+oGCMEnr5v8++8/wM/6/vkk/SRjbxVR28fuxKFfW5uymDFi/ZSYgENBe9I0EWROdmUp
	 YUjvLQB4zCWdA3O9zVGgqABaBazIq2M0qkttl5D1bZc5A9OI0GnsWh68bHvkm9mM/I4Vi
	 1E8nbGYHrdC2RX1b3pGPjvPM/38jDiTXyUcZ6iOlrmKVWJbcwIbmWbslAu17EF5yL8F7l
	 9/zsuTZWsJag/zruLoAW9JUXlMIaGO5aQ7xo59OSMsOHZPaZUBu77Fn5JHuT84Ab1hS6K
	 IG8/UjA2sme1eaUcGOMkqe8M9v+4m01JN+JogXzkG3T2vW8r33D1VmSY5lUdM1jk4Lw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=RsadOExv;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 42144606A31E;
	Wed, 25 Nov 2026 14:53:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=RsadOExv
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ED5061F000C0;
	Wed, 25 Nov 2026 14:53:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795618419;
	bh=GZQD9riHhsJyYmzjCRGe6NSTDDHfiSJXoXW3NV5lNlI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=RsadOExvrN7/Uf6KFzk6hSUkfLjUzjUT8L2dtgzyTbHLceQpnlwgzlFaGlsL5AM67
	 IGyZX4lWp2sguknFyK6LUWlCW1fbfAZgpm/Haz+ONlMBIEecqyoSijineNs5mltVBg
	 7ry4WoYolDrn2o4DWYAAqgAUM/WA2P1eVFB12H+o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhou Minqiang <zhouminqiang2@huawei.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0275/1005] PM: runtime: Fix check_flush_dependency warning from pm_runtime_remove
Date: Wed, 25 Nov 2026 15:26:53 +0100
Message-ID: <20261125143828.180078901@linuxfoundation.org>
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
index f18d99c8d052b..7a62cb2b3f7ce 100644
--- a/drivers/base/power/runtime.c
+++ b/drivers/base/power/runtime.c
@@ -1899,7 +1899,7 @@ void pm_runtime_reinit(struct device *dev)
 void pm_runtime_remove(struct device *dev)
 {
 	__pm_runtime_disable(dev, false);
-	flush_work(&dev->power.work);
+	cancel_work_sync(&dev->power.work);
 	pm_runtime_reinit(dev);
 }
 
-- 
2.53.0



