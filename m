Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793216563;
	b=2J80SDp8a2YSSgXS6CgIzokrcF4VZ9jOdORqjMMTnoOrRbl2IaFL8KfdKA+1h9aNvocT
	 RX6EekT2+wi8SLl04SOMMdEtC09rNVFH9MWvVtIJUhYsoGfTLCIVY8LBLkGLoffEyVVPt
	 heHhhUsJPjCJRueW8/IpWXgGa7fps5zY7BeDQhOiYZ1ODJ06PO/n616BDfs3hTQv9bepM
	 Ol/iMS90XEQaN4Bl/1eTmM7SEZVOUPWgCfwW8kMgYDaJVnMuI0tGNzKGGBqphPZQzfLAp
	 /1FR4ohS24eXW+bCltd5HTbi7NN9EuZ3Cbn2r+WzR2A2fQQiV9ErI4zzT5al90uH6Nw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793216563;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=zQswbcZqPk68i2cM5WMH0EzKzWFTGGPy9Ksz0eMHXb4=;
	b=nFp0QdRWZX3gM7WXDNDV4P7P6TFE8ItljaxTmZ1UusZzopIqYWtBI+SMy12M4FehJpq/
	 kirH5bkqlBrOG/4c+QfKy1QXdFP1VcTy1Wk5LRDvOIiHRpLZVqICLrULtOW1i41miW0C2
	 cMwFg8bPjQKX3GSwseCWdBK438U/49MLfGivSPokPlcSiKLeQhfFOFho8UDObVE5sRpGG
	 q1gYGuyPXDUPNFm41ypUUVL/7TaylQt4IKH3N7cNX3rbYVq0RT5vpwNTEVrCjT474ECOJ
	 b2j1OEN7VID7QT7idp62l7RMEvTuML/23z7URK9c86anr744rFnk/c0uzGIv+r8HfNw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Qde0A7so;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D18A606A31C;
	Wed, 28 Oct 2026 19:42:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Qde0A7so
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9E2D91F01825;
	Wed, 28 Oct 2026 19:42:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793216563;
	bh=zQswbcZqPk68i2cM5WMH0EzKzWFTGGPy9Ksz0eMHXb4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Qde0A7so44ERmnTSYLGAHIfukgda5xg3UIaerKJ4ZzOJIqC2MAP1wLKf7AzLacl5T
	 r6Nf+IgVaGhzba8r2YW+Nn55W5sOF7eyzNbeXagq+0tJgapmB5PddR0dhdJUzLu6lg
	 HArN9fLhSix33cNvwsslBEHL0ypndZCuQluwqw8Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Joshua Peisach <jpeisach@ubuntu.com>,
	Janne Grunau <j@jannau.net>,
	Nick Chan <towinchenmi@gmail.com>,
	Sven Peter <sven@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1556/1887] nvme-apple: Destroy the admin queue on removal
Date: Wed, 28 Oct 2026 18:00:52 +0100
Message-ID: <20261028170534.873909975@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
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

From: Sven Peter <sven@kernel.org>

[ Upstream commit 87d5b9864c8118d26f54de4b66d2bddf2c659272 ]

The admin queue is allocated with blk_mq_alloc_queue() but never
destroyed. nvme_free_ctrl() only drops the last reference and
blk_mq_exit_queue() and blk_sync_queue() never run: the hctx is never
moved to q->unused_hctx_list and the timeout timer and work stay armed on
a queue that is about to be freed which will eventually oops inside
blk_mq_timeout_work().

This can only be triggered when the controller fails to come up and is
then immediately torn down again which is why no one ever ran into this
before.

Let's just copy what the pcie driver does: unquiesce and destroy the admin
queue before nvme_uninit_ctrl().

With this the following WARN followed by a panic no longer happens:

  WARNING: block/blk-mq.c:4390 at blk_mq_release+0x194/0x238, CPU#4: kworker/u34:4/119
  CPU: 4 UID: 0 PID: 119 Comm: kworker/u34:4 Not tainted 7.2.0-rc1-dirty #248 PREEMPT
  Hardware name: Apple Mac mini (M1, 2020) (DT)
  Workqueue: nvme-wq apple_nvme_remove_dead_ctrl_work
  pstate: 61400005 (nZCv daif +PAN -UAO -TCO +DIT -SSBS BTYPE=--)
  pc : blk_mq_release+0x194/0x238
  lr : blk_mq_release+0x58/0x238
  sp : ffffc000833a3b50
  x29: ffffc000833a3b50 x28: ffff80001d0450f8 x27: ffff800020c95200
  x26: 0000000000000088 x25: 0000000000000000 x24: ffff800020f36805
  x23: 0000000000000000 x22: ffffc00081a86878 x21: ffff800020be9c60
  x20: 0000000000000000 x19: ffff800022501698 x18: 000000000000000a
  x17: 7365757165722066 x16: 666f7265776f7020 x15: 0000000000000000
  x14: 0000000000000028 x13: 0000000000004def x12: 0000000000000003
  x11: 0000000000000000 x10: 0000000000000000 x9 : ffffc000805b4fc8
  x8 : ffffc00081915820 x7 : ffffc00081c4f3c8 x6 : 0000000000000001
  x5 : 0000000000000004 x4 : ffff800022498d80 x3 : ffffc000833a3b14
  x2 : 0000000000000000 x1 : 0000000000000000 x0 : ffff800022501698
  Call trace:
   blk_mq_release+0x194/0x238 (P)
   blk_put_queue+0x8c/0xf0
   nvme_free_ctrl+0x4c/0x260
   device_release+0x44/0x128
   kobject_put+0xa0/0x120
   put_device+0x1c/0x40
   nvme_uninit_ctrl+0x48/0x60
   apple_nvme_remove+0x54/0xb0
   platform_remove+0x28/0x40
   device_remove+0x54/0x98
   device_release_driver_internal+
   device_release_driver+0x20/0x38
   apple_nvme_remove_dead_ctrl_wor
   process_one_work+0x1f4/0x770
   worker_thread+0x1b8/0x360
   kthread+0x140/0x160
   ret_from_fork+0x10/0x20
  irq event stamp: 448
  hardirqs last  enabled at (447):in_unlock_irqrestore+0x74/0x80
  hardirqs last disabled at (448): [<ffffc000811cf5c0>] el1_brk64+0x20/0x60
  softirqs last  enabled at (0): [ess+0xb28/0x2698
  softirqs last disabled at (0): [<0000000000000000>] 0x0
  ---[ end trace 0000000000000000
  Unable to handle kernel NULL pointer dereference at virtual address 0000000000000000
  Mem abort info:
    ESR = 0x0000000096000005
    EC = 0x25: DABT (current EL),
    SET = 0, FnV = 0
    EA = 0, S1PTW = 0
    FSC = 0x05: level 1 translation fault
  Data abort info:
    ISV = 0, ISS = 0x00000005, ISS2 = 0x00000000
    CM = 0, WnR = 0, TnD = 0, TagA
    GCS = 0, Overlay = 0, DirtyBit = 0, Xs = 0
  [0000000000000000] user address
  Internal error: Oops: 0000000096000005 [#1]  SMP
  CPU: 7 UID: 0 PID: 54 Comm: kwor          7.2.0-rc1-dirty #248PREEMPT
  Tainted: [W]=WARN
  Hardware name: Apple Mac mini (M1, 2020) (DT)
  Workqueue: kblockd blk_mq_timeou
  pstate: 01400005 (nzcv daif +PAN -UAO -TCO +DIT -SSBS BTYPE=--)
  pc : percpu_ref_tryget_many.cons
  lr : percpu_ref_tryget_many.constprop.0+0xc0/0x168
  sp : ffffc000829cbce0
  x29: ffffc000829cbce0 x28: ffff800020be9f48 x27: ffff800013e503c0
  x26: 0000000000000108 x25: 000009c05
  x23: 0000000000000000 x22: ffffc000819f5000 x21: ffff800020be9f48
  x20: ffff8001deda4808 x19: ffff8000a
  x17: 00000000580e1fac x16: ffffc00082bbbb7c x15: 0000000000000000
  x14: 0000000000000028 x13: 000000001
  x11: 0000000000000000 x10: 0000000000000000 x9 : ffffc000829cbc20
  x8 : ffffc00081915820 x7 : ffffc0001
  x5 : ffff80001ca77d08 x4 : 0000000000000000 x3 : ffff80001ca77cb8
  x2 : 0000000000000000 x1 : 000000007
  Call trace:
   percpu_ref_tryget_many.constpro
   blk_mq_timeout_work+0x48/0x298
   process_one_work+0x1f4/0x770
   worker_thread+0x1b8/0x360
   kthread+0x140/0x160
   ret_from_fork+0x10/0x20
  Code: 91282000 97ed44b2 17ffffd2
  ---[ end trace 0000000000000000 ]---

Fixes: 5bd2927aceba ("nvme-apple: Add initial Apple SoC NVMe driver")
Tested-by: Joshua Peisach <jpeisach@ubuntu.com>
Tested-by: Janne Grunau <j@jannau.net>
Tested-by: Nick Chan <towinchenmi@gmail.com>
Signed-off-by: Sven Peter <sven@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/host/apple.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/drivers/nvme/host/apple.c b/drivers/nvme/host/apple.c
index 4822248a624ad..2d8904505b5ac 100644
--- a/drivers/nvme/host/apple.c
+++ b/drivers/nvme/host/apple.c
@@ -1566,6 +1566,15 @@ static int apple_nvme_remove(struct platform_device *pdev)
 	nvme_stop_ctrl(&anv->ctrl);
 	nvme_remove_namespaces(&anv->ctrl);
 	apple_nvme_disable(anv, true);
+	if (anv->ctrl.admin_q && !blk_queue_dying(anv->ctrl.admin_q)) {
+		/*
+		 * If the controller was reset during removal, it's possible
+		 * user requests may be waiting on a stopped queue. Start the
+		 * queue to flush these to completion.
+		 */
+		nvme_start_admin_queue(&anv->ctrl);
+		blk_mq_destroy_queue(anv->ctrl.admin_q);
+	}
 	nvme_uninit_ctrl(&anv->ctrl);
 
 	if (apple_rtkit_is_running(anv->rtk))
-- 
2.53.0



