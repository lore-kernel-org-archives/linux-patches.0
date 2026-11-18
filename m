Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795026457;
	b=OMKTofMUhyDezwS9weXZEHZhRrda0P9WZUsFz40+kNDuWKNqrNTsCktqGk3EeM/oad67
	 jPFWMG2ACBPgJixhcsDbhCHDFVTbzG/P0KYVdXE6UVdknN1hMlfi+uJWicnKf+DiiyTez
	 IrTouGH2OHjakgfQFtRMgH9GWDGgT+PVh6DH/LksWn96ftZgqrtNk5IFAS93bBtyy8NMU
	 hI+Siq1nsIWIxM+JGdY1xNmkXQRJGp9OK/Vkp9/T82wqMGNFZWvkBOz6+Si3b04ePSRTt
	 nNEvbvFhB9teFs3jFy7Hgg6vS4bOQ9KN7F3yRAeI4rQNyxWWs6q+89ZAXGJWR7DOfYg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795026457;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=00YNuV56XQIYmRJf29UC0cJZr7mEalCaVp3lON6NLkI=;
	b=XcJlhIuPoXtfG9lfCzXSd7PPvrejVCWSEbO6tG9qAi7vHGI23m+uQBxFrPMVLvcHxkRG
	 UsnDSBxhGDyYAkZ862e60Ikr4+L4mas9i2PUdsQqjsVfVnHVydTV4ISkjNIE7MDxkRLbx
	 PCcmEB2TtyJgChs6slKUcbISGqrKTrtgE3o3so8Grka9RShtWHss6IUgp5LmnkcICMdbr
	 HCxGYK5c6yHOOYDKgZtr31FsPaw7l+xfNCVN4xKSVMB0Dl4gnVGsD73O/iLN9DVjQYjTk
	 ehTgQpHknbiAmK+IEgfbWJv1YFjCzsmwIUtbLQsN/sCd1L/jt26NZrQHOCAqm/9zEpw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=CRoZ58s9;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 17D8A606A332;
	Wed, 18 Nov 2026 18:27:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=CRoZ58s9
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 75C7E1F000C4;
	Wed, 18 Nov 2026 18:27:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795026457;
	bh=00YNuV56XQIYmRJf29UC0cJZr7mEalCaVp3lON6NLkI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=CRoZ58s9x8lpCGf5s7sDlRhFXtLCKjyunyLprPV3wY6ceAwcLQQYj+9b6nCv1QXMI
	 ImZ2YN7QK3NAmC4ln32jQ4Yo4dABqPSrLLSMe8eU6rLFiBf8otPg33wWVhaPTupM1q
	 BSCwOiYEIZg6shEUmUNez/jdPps/OihY/gztvMjc=
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
Subject: [PATCH 6.18 1442/2151] nvmet-fc: dont drop the last assoc reference in nvmet_fc_delete_ctrl()
Date: Wed, 18 Nov 2026 15:52:57 +0100
Message-ID: <20261118150214.465348530@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index 89edffeb10626..bf39e4af43166 100644
--- a/drivers/nvme/target/fc.c
+++ b/drivers/nvme/target/fc.c
@@ -1572,8 +1572,14 @@ nvmet_fc_delete_ctrl(struct nvmet_ctrl *ctrl)
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
@@ -1581,11 +1587,8 @@ nvmet_fc_delete_ctrl(struct nvmet_ctrl *ctrl)
 
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



