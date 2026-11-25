Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795618365;
	b=I3QoJxasKPXLX156Q7XtKxUnTfVPsCGo7vo4QhePWR4lO+vo52OKpWIaFQU+L8DIr0nj
	 wxq1bIfqPDhA89Xvt9XrbFQXRA4q2yzClRZH/rVFIPyQffRTTrjdWILYRlMMTpfHb5PkY
	 GDBCXfr7pK2Ewwyrm0REYj5P4I2+a6P28lL3Qg2W8PxYcz58rFGlUAyaeYDfA9unA9r/S
	 LhjAv6h2ovwHRXzYjRSMUTo3/3xGw6AbqHGqpfbOn3fY5qHksvB5to3lXKDtj/Nq8Toi+
	 O0ub+cMTcLNNZMchS+0zjv0YeMrzGfmzb4eoF3/lxonlnit/KHBuExFOEchbcDszoSg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795618365;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=moXi14TtVt3vR+lZfIT+yr/nGqx7nlgIUBUndTWM3B4=;
	b=KN4+j9k+Olmry6jgxoRfpOfJ6hS4mXFvekX2TSDI3+bqYIiphl95zDqus6uvagfavAHw
	 I2iCg6vqOrEyzRkNcdYaIDeULQXiJWQ0+UsBIovkZL1EuusdXFl41g1NwJXZpeXGcTIKQ
	 SeCgaKvEgOXMHAls6ODKk/N9M9h+hQD6n3awLvo5oIZyC18BwuWNAcinSTvRopA/mp1J+
	 Of3RNR537Iwq2sGpljyefKXas4DMTSyddXI2CRekDSYODJxV74C41IzWbbxjEjp5w6v+i
	 Aba4SETddiwhfu3jCVi5daw31AccfllCaV6NTIvD9K/WvZuS+FQSbHA0+uwsfDslPXA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=mjaGMxYa;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E7924606A32E;
	Wed, 25 Nov 2026 14:52:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=mjaGMxYa
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1EE011F000C0;
	Wed, 25 Nov 2026 14:52:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795618364;
	bh=moXi14TtVt3vR+lZfIT+yr/nGqx7nlgIUBUndTWM3B4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mjaGMxYawl8VTnt6/NMlnjcCk6gdMIdYihUt86zPp9Nk5mcS+qTfv79D5cW8zWYW6
	 uI2HZ85BG2FIxmEa73GePfyyBMAz7/542YC67GefFk6WAeqpnDnLZzOIc/WD0rRdce
	 ASWOQybXhFER2dnOa5wWm8n8JgouTuF9t/ztzTfE=
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
Subject: [PATCH 7.3 0255/1005] nvme-loop: delete the controller if a reset fails
Date: Wed, 25 Nov 2026 15:26:33 +0100
Message-ID: <20261125143827.713301417@linuxfoundation.org>
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
Content-Transfer-Encoding: 8bit

7.3-stable review patch.  If anyone has any objections, please let me know.

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
index e579a307798b9..80b67608eb155 100644
--- a/drivers/nvme/target/loop.c
+++ b/drivers/nvme/target/loop.c
@@ -420,6 +420,8 @@ static void nvme_loop_shutdown_ctrl(struct nvme_loop_ctrl *ctrl)
 static void nvme_loop_delete_ctrl_host(struct nvme_ctrl *ctrl)
 {
 	nvme_loop_shutdown_ctrl(to_loop_ctrl(ctrl));
+	/* Left quiesced if a failed reset has left no admin queue behind */
+	nvme_unquiesce_admin_queue(ctrl);
 	nvme_remove_admin_tag_set(ctrl);
 }
 
@@ -483,9 +485,8 @@ static void nvme_loop_reset_ctrl_work(struct work_struct *work)
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



