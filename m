Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795705112;
	b=39sh+pNgmsOKDGGVzNKU6prEsRgKiAmkBtTyciFisEX/w/VsX21j4ov6YJX/Y/Bw0Iny
	 hGOupt81fT+gPq0IAZX5JyA58/gC0vV0Cyclp8um7Su5hPz5R4SzifwWrR5M2JLZb7Ai0
	 j9M6DwUz4WRKXLb9SMjVtK54ovl9WhYiNyHhsMwVsyW8pujQfB64oVhFqkbjbQUuxnIjS
	 YE1m2EAh67RcWqergvCB2W7A1BUorRF5RoQ48x/pBedDAkjivG4o86Tywvy1/1lS9TdEd
	 WzrmZy6vg3wgU0YZxgnZ/2XnGBRnEZBf9BwLdD/GdY6Ot7bOKL5jOe08X0/N0FW+SUg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795705112;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=BTQ2QH3HCpoR5hzhXWwsrl3a+qTJlIXVwBCMABijjvI=;
	b=VRDV8OmGHPdSFoJgGYKe7VicyryrYSj9vAS+tnakLqXeDeemT4PJSpPJpgqcYVfwqCIY
	 S9g7I0PTvEeGRb6C49YiV65E67auW+B2+91hBowR/iQ/M9NITS/+d4enLajxZtUjZZmM/
	 0bpMTdpov7RNiu3tH2oixdVSHliGkjf2u8hqzbnpTd+asakk0aHdFl71crywq+2ST6fxI
	 DvtJnEATF96Ix7RyH2uCoDvtKAHnIVF/sr/7RJIhskq4sQZpXpfvhEc3X1ldMEeZpPXSL
	 d82EDmH+2y74deckqK8vZ2af+lfBmP9y93sZ+m8p/y/2JTHlBuVoEfoFkSXk0mP/2AQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=sd2ORYVv;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D2BC606A31C;
	Thu, 26 Nov 2026 14:58:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=sd2ORYVv
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E08581F000C0;
	Thu, 26 Nov 2026 14:58:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795705112;
	bh=BTQ2QH3HCpoR5hzhXWwsrl3a+qTJlIXVwBCMABijjvI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=sd2ORYVvsNbHwpvuKr9uIzVYZgjk5WolbXRI3k0mhVERQi5AQrXD8bFNOK9dh+Iqu
	 /BbPYYQq5+0Fi4z1T0Za9wzORhR03qwAAS2bGi4ZGmRkhUIGmxQEpif1DQjze8cGlv
	 Ee3TTBdulMvHWGp/YwwAvrq5gWyyxICbJuF9Wju8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhou Minqiang <zhouminqiang2@huawei.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 088/319] PM: runtime: Fix check_flush_dependency warning from pm_runtime_remove
Date: Thu, 26 Nov 2026 15:37:36 +0100
Message-ID: <20261126144008.731020928@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261126144006.732901931@linuxfoundation.org>
References: <20261126144006.732901931@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index f94d9223ab151..f14ffdff8717e 100644
--- a/drivers/base/power/runtime.c
+++ b/drivers/base/power/runtime.c
@@ -1774,7 +1774,7 @@ void pm_runtime_reinit(struct device *dev)
 void pm_runtime_remove(struct device *dev)
 {
 	__pm_runtime_disable(dev, false);
-	flush_work(&dev->power.work);
+	cancel_work_sync(&dev->power.work);
 	pm_runtime_reinit(dev);
 }
 
-- 
2.53.0



