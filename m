Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795621448;
	b=a3Avh8qbve6FYtsQotv8yj68lmGF1eZ0w9hFxbejPXamEYnuXnAUGR1oTKKbAjvBWZ1b
	 iCVR8WQQcqxrtjLPvwR5Zr5up1onEah9MIoZ8f52dasdyO8+1S2P+xw8h8KKcVtyjoHOm
	 H20o0GG60XIVncUTdoPje86NzspLBdR8QAWappwWmYbLspFZoj8T9FjiXwdN301aTqs+o
	 BRWsikEBzLgj/fViMcS9KFRmXB3dae6wsmhbWR2bepPh5fjhywZfDMewd8qcBFktbO43h
	 +eT3CPmsRS1FbVzJc8POTxItJLwE2LNohHoGkZ5cDkpAnCpva9Ig0oaCxI+9z6BY7sw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795621448;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=mQ+fUTSnlXgJDajMALdr3MWAv/hu6zbUzc3cdEt/4xQ=;
	b=CYxaDVXu2wOjXCH/Cq/EhQpusNhgzJ0kGmQkcHgZ66/AtQWYmj3607ZeEtcpjzlHtgV0
	 n1j/nbBLqDPBIOWbQbisIRSXzWcm4WTzhJ8AISahThapYbuvuBKB7DLk+oDvmpGIdEFr7
	 UQojHl0O3El/khXW7SoEA7aJzDrUwjidIyaGl2ZJ27U8hHJPoBr//GsLfZrwLFe7BrLqD
	 eYoL65Lv7JZHcgs8ENjHJag7ih/KopfHkqjExOvdGzN2RMdVv3Q9rxW7Gy3StvHF+HCqt
	 2bodQEpfJdA1tXOoBEgPOMhRr2/XUYRBFnBnTlqumVTFwZSt8VlPBRad36PyKNcaHyQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=r1Pu6M3Z;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD007606A329;
	Wed, 25 Nov 2026 15:44:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=r1Pu6M3Z
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E89F91F000CF;
	Wed, 25 Nov 2026 15:44:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795621448;
	bh=mQ+fUTSnlXgJDajMALdr3MWAv/hu6zbUzc3cdEt/4xQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=r1Pu6M3Zk5NmqjNefjms0d000O4iOoPmX8fb6jPNB9FI2aWmmEQlDuDzLbpyAUe1y
	 7VZrAB8hYbdSNuMtlx/LP48wJcg0MA3v/xCl8IYmswQDmslftre8CSm8nBhvIjhNJ9
	 UkFmyM+7sz8cC+2res9+bhPadJTsE8SxnqO72xpY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christoph Hellwig <hch@lst.de>,
	Sagi Grimberg <sagi@grimberg.me>,
	Chaitanya Kulkarni <kch@nvidia.com>,
	Josef Bacik <josef@toxicpanda.com>,
	Jens Axboe <axboe@kernel.dk>,
	Keith Busch <kbusch@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 228/990] nvme-loop: delete the controller if a reset fails
Date: Wed, 25 Nov 2026 15:26:35 +0100
Message-ID: <20261125143827.429847363@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143822.072087159@linuxfoundation.org>
References: <20261125143822.072087159@linuxfoundation.org>
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

From: Josef Bacik <josef@toxicpanda.com>

[ Upstream commit bc2170d365861d29dce20f982093873baad09804 ]

If the reconnect of a reset fails, nvme_loop_reset_ctrl_work() tears the
controller down by hand with nvme_uninit_ctrl(). Since that was split
from nvme_stop_ctrl() it no longer removes the namespaces, which hold
references to the controller. A reset while the target no longer accepts
the host (allow_any_host 0) is enough to get there: a sysfs reset hangs
in kernfs_drain(), an ioctl reset leaves a controller stuck in
CONNECTING with its block devices, the cntlid can't be reused, and
module unload deletes the controller a second time and hits a
use-after-free.

Do what the other fabrics drivers do and call nvme_delete_ctrl(). The
delete path quiesces the admin queue and only unquiesces it if the queue
is live, which it isn't after a failed reset, so unquiesce it
unconditionally before destroying it so a stuck request can't block the
freeze.

Fixes: d09f2b45f346 ("nvme: split nvme_uninit_ctrl into stop and uninit")
Cc: Christoph Hellwig <hch@lst.de>
Cc: Sagi Grimberg <sagi@grimberg.me>
Cc: Chaitanya Kulkarni <kch@nvidia.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Josef Bacik <josef@toxicpanda.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Keith Busch <kbusch@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/target/loop.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/nvme/target/loop.c b/drivers/nvme/target/loop.c
index c096953194a00..ed1c48472e017 100644
--- a/drivers/nvme/target/loop.c
+++ b/drivers/nvme/target/loop.c
@@ -422,6 +422,8 @@ static void nvme_loop_shutdown_ctrl(struct nvme_loop_ctrl *ctrl)
 static void nvme_loop_delete_ctrl_host(struct nvme_ctrl *ctrl)
 {
 	nvme_loop_shutdown_ctrl(to_loop_ctrl(ctrl));
+	/* Left quiesced if a failed reset has left no admin queue behind */
+	nvme_unquiesce_admin_queue(ctrl);
 	nvme_remove_admin_tag_set(ctrl);
 }
 
@@ -485,9 +487,8 @@ static void nvme_loop_reset_ctrl_work(struct work_struct *work)
 	nvme_cancel_admin_tagset(&ctrl->ctrl);
 	nvme_loop_destroy_admin_queue(ctrl);
 out_disable:
-	nvme_remove_admin_tag_set(&ctrl->ctrl);
 	dev_warn(ctrl->ctrl.device, "Removing after reset failure\n");
-	nvme_uninit_ctrl(&ctrl->ctrl);
+	nvme_delete_ctrl(&ctrl->ctrl);
 }
 
 static const struct nvme_ctrl_ops nvme_loop_ctrl_ops = {
-- 
2.53.0



