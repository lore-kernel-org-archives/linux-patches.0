Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795049663;
	b=OzgKlH3vQot5ejuyO0otiF8kp4nsoZy8UFfHPiv8q3bptVeFlMZGPjCrrCv7YMcR3sts
	 OoL6hohsTWdpic8WUdkgvwRoyHwFfjowGmdNRqqzM9/kQQPJsoE6wVE30lBx4TgGQKj6v
	 OAsHBnr7k/i6FPSYKS4k8qLgZRPRqVF/RqWpcuXnyaWMHZU3qfsgHwXZJrxgSEnF1adK7
	 y19WqxN1AXv7SPm3RogekCbiagOP9SaijFA8FX3XBeUwuM/SiTj6Y9sR9tZGjivkz6Vji
	 sW8ypqpGRxFM1LcOg2LFeN0YrQwgMJNYVaYFkL/fM7QCffmHqdKlEoHNQxQqbiiVPVg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795049663;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ui1uGhm8CyLu9hQRl11kRLAJbG/Fol4FV6VxYO1+y0U=;
	b=Vee2xj7CCuRtlXEUUtNXdgVTxduSnwF4C/CFmZ6v0YRXOnrxNx94a34/PFc0Y9lDC2+G
	 h4hdkwt60Co5vW5iGIlGL9hCsrJIgNxPwPuD+uzU2gpxj9QfUaQFPS3HmJLIVahE4C9av
	 fCI5Mk3UsdboKq6Ry6Edqj1DF8WK710xO1VVO2AHIRuXCD435Pw0S6Z/U9aLt8Z1hXnU1
	 dayZ0k0ldTFIwOICdbeg+d6uMdKoJBsTQneywizXBDsoSNUhUXh1AS4P2OU+XaNf5L8zh
	 vpZAjH2WPpFpuAvIbxXh55tQ5oSMup7aNKle0mOObMBqLYe0nnyE62zZ67L3nHp1PLQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="a/uTNix2";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 74510606A31C;
	Thu, 19 Nov 2026 00:54:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=a/uTNix2
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D13FC1F000C5;
	Thu, 19 Nov 2026 00:54:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795049663;
	bh=ui1uGhm8CyLu9hQRl11kRLAJbG/Fol4FV6VxYO1+y0U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=a/uTNix2hq82c2DhUztZo3iB0QSbO/HgkqJVbGB9OJZsbNn4uG+K4EJrlJw1K9mU0
	 gVZUz9M7lPf8o0M15DQ4OJzm4Cet3QzKrCIVYxeViN+H9tfWoujUPqoUFm01qiz+ND
	 SivzcN/RSH98Kykwp3M6TodyR+gId4xs503dExR4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+da94a51633758d13bd63@syzkaller.appspotmail.com,
	Daniel Wagner <dwagner@suse.de>,
	Christoph Hellwig <hch@lst.de>,
	Palla Raghunath <raghunathpalla.0209@gmail.com>,
	Keith Busch <kbusch@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 2432/2857] nvmet-fc: dont drop the last assoc reference in nvmet_fc_delete_ctrl()
Date: Wed, 18 Nov 2026 15:57:46 +0100
Message-ID: <20261118150329.135503612@linuxfoundation.org>
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

From: Palla Raghunath <raghunathpalla.0209@gmail.com>

[ Upstream commit 165301b5e2fd765fa05ea1044bbca8ba79820197 ]

syzbot hit a recursive locking report on subsys->lock when a subsystem
is unlinked from an FC port.

nvmet_port_del_ctrls() holds subsys->lock while it calls ->delete_ctrl()
for each controller. nvmet_fc_delete_ctrl() grabs a reference on the
association, queues del_work and then drops the reference. If del_work
gets to run to completion before that put, ours is the last reference.
Freeing the assoc tears down the queues, the last nvmet_cq_put() drops
the last ctrl reference, and nvmet_ctrl_free() goes for subsys->lock
again:

  WARNING: possible recursive locking detected
  ...
   nvmet_ctrl_free+0xa6/0x8e0 drivers/nvme/target/core.c:1766
   nvmet_cq_put+0x158/0x200 drivers/nvme/target/core.c:848
   nvmet_fc_target_assoc_free+0x418/0x2220 drivers/nvme/target/fc.c:1173
   nvmet_fc_delete_ctrl+0x717/0x7e0 drivers/nvme/target/fc.c:1581
   nvmet_port_del_ctrls+0xfb/0x150 drivers/nvme/target/core.c:311
   nvmet_port_subsys_drop_link+0x1e8/0x310 drivers/nvme/target/configfs.c:1119

It's a real hang, not only a lockdep warning. I reproduced it with
fcloop by putting an msleep() before the put: rm on the configfs link
gets stuck in D state for good.

I don't think we need that reference at all. del_work does
list_del_rcu() and synchronize_rcu() before it drops the initial
reference, so an assoc we find on assoc_list can't go away before
rcu_read_unlock(). nvmet_fc_schedule_delete_assoc() doesn't sleep, so
just call it inside the RCU section and get rid of the get/put. If the
assoc is already being deleted, terminating is set and the call is a
no-op, which matches what happened before when the get failed.

With the same msleep() in place the patched kernel unlinks cleanly and
the assoc is freed from the workqueue.

Fixes: 4049dc96b8de ("nvmet-fc: defer cleanup using RCU properly")
Reported-by: syzbot+da94a51633758d13bd63@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=da94a51633758d13bd63
Reviewed-by: Daniel Wagner <dwagner@suse.de>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Palla Raghunath <raghunathpalla.0209@gmail.com>
Signed-off-by: Keith Busch <kbusch@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/target/fc.c | 15 +++++++++------
 1 file changed, 9 insertions(+), 6 deletions(-)

diff --git a/drivers/nvme/target/fc.c b/drivers/nvme/target/fc.c
index 224287ca9039c..4539e25963afc 100644
--- a/drivers/nvme/target/fc.c
+++ b/drivers/nvme/target/fc.c
@@ -1575,8 +1575,14 @@ nvmet_fc_delete_ctrl(struct nvmet_ctrl *ctrl)
 		list_for_each_entry_rcu(assoc, &tgtport->assoc_list, a_list) {
 			queue = assoc->queues[0];
 			if (queue && queue->nvme_sq.ctrl == ctrl) {
-				if (nvmet_fc_tgt_a_get(assoc))
-					found_ctrl = true;
+				/*
+				 * No assoc reference here: we're called with
+				 * subsys->lock held, and if del_work beat us,
+				 * our put would free the ctrl under that lock.
+				 * RCU keeps the assoc alive until unlock.
+				 */
+				nvmet_fc_schedule_delete_assoc(assoc);
+				found_ctrl = true;
 				break;
 			}
 		}
@@ -1584,11 +1590,8 @@ nvmet_fc_delete_ctrl(struct nvmet_ctrl *ctrl)
 
 		nvmet_fc_tgtport_put(tgtport);
 
-		if (found_ctrl) {
-			nvmet_fc_schedule_delete_assoc(assoc);
-			nvmet_fc_tgt_a_put(assoc);
+		if (found_ctrl)
 			return;
-		}
 
 		spin_lock_irqsave(&nvmet_fc_tgtlock, flags);
 	}
-- 
2.53.0



