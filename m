Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795025257;
	b=CxWtj0ZEaJsjx9+Y+0Rz//S47W467wZjhsUlnZeQ7EQV59BRjTdr7ti0z5D6qpldn6pH
	 nw1RFz8F0xLID4v9P+KzFmASx8g2x3FDQ/t1c3wrvJ/WwC9jikWJ1n4D4D1m60aEg40oj
	 ezUTyE/AC7UeEdkmiB1Fm50GatFU9pnupQaRgx0V3fM+DEbIW0werJfeT+HfqKNWZ9/Cg
	 ZrSp4VAOY1C2dYrjSyf+L3whNdGtGZMA+alfUHa3hMXBGD4Gv86clIFhc7nn5irKXkrJl
	 e7xEctl8s7JF6r2AyZ75Y79VkB+GHzHKWtD8PvgdS4vnHwGOOrZeusDYF49I5cKEh8g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795025257;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=M/y0+3qYRUKYQRFzj78H878N41Vz+9eKToCmXdD3w5M=;
	b=kU3686fasSKvo4lNpvc0CJ4d0LEavoFCp+/fZFcJskQteDx9PzPI03l0kPSnlKMc8nN2
	 5Ou9u7ihSjGsgLcY4ZOVAT0+iMneilCvNLTWHA94xpie1tWetjZN4TwWzROG9exBcLVL5
	 UNGXzVAM/myWhRzWppg0ueVikCGqV5qk0Y7TvvxDyYUWdeX8JPfb54S7KUOT5dRNqZRh+
	 bQPxnvrSMQeKnpYRth7TCm5l6XdVFS4OYPzDqXCLFjslpMq0vgPzRI2rjEegFKAzmBS/j
	 sHNpWQcKXHOdHhf6enrP0ONxnk4CifdBCmHrbAJrkqE/Kc74PjpuE/c5zu2njwOnEtg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="PEij/rA0";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 105FE606A325;
	Wed, 18 Nov 2026 18:07:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=PEij/rA0
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 310CB1F000C4;
	Wed, 18 Nov 2026 18:07:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795025256;
	bh=M/y0+3qYRUKYQRFzj78H878N41Vz+9eKToCmXdD3w5M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=PEij/rA0jAZ7vhpqZ4xbzkDIcAFKW+xuVcjyMpzFm2WlFqo9y3w6kHbYNWZrb09Jy
	 C7wNQDxDzQgikvd1Z4z0bQpUAYeDGJKuZp72aEkaNZvtkkdwCcjwmV5gpO4o3ljShy
	 y2Bl8CT9bLHgI7P6XPEOVdWzl1eu2jSFyrzVxNug=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hannes Reinecke <hare@suse.de>,
	John Garry <john.garry@huawei.com>,
	Bart Van Assche <bvanassche@acm.org>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1013/2151] scsi: core: Introduce .queue_reserved_command()
Date: Wed, 18 Nov 2026 15:45:48 +0100
Message-ID: <20261118150159.320750864@linuxfoundation.org>
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

From: John Garry <john.garry@huawei.com>

[ Upstream commit 11ea1de3fc4ba94127034cb01df63a666c4c9836 ]

Reserved commands will be used by SCSI LLDs for submitting internal
commands. Since the SCSI host, target and device limits do not apply to
the reserved command use cases, bypass the SCSI host limit checks for
reserved commands. Introduce the .queue_reserved_command() callback for
reserved commands. Additionally, do not activate the SCSI error handler
if a reserved command fails such that reserved commands can be submitted
from inside the SCSI error handler.

[ bvanassche: modified patch title and patch description. Renamed
  .reserved_queuecommand() into .queue_reserved_command(). Changed
  the second argument of __blk_mq_end_request() from 0 into error
  code in the completion path if cmd->result != 0. Rewrote the
  scsi_queue_rq() changes. See also
  https://lore.kernel.org/linux-scsi/1666693096-180008-5-git-send-email-john.garry@huawei.com/ ]

Cc: Hannes Reinecke <hare@suse.de>
Signed-off-by: John Garry <john.garry@huawei.com>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
Reviewed-by: Hannes Reinecke <hare@suse.de>
Link: https://patch.msgid.link/20251031204029.2883185-6-bvanassche@acm.org
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Stable-dep-of: 92feb036a2d3 ("scsi: scsi_debug: Avoid 32-bit overflow in WRITE SCATTERED offsets")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/hosts.c     |  6 +++++
 drivers/scsi/scsi_lib.c  | 54 ++++++++++++++++++++++++++++------------
 include/scsi/scsi_host.h |  6 +++++
 3 files changed, 50 insertions(+), 16 deletions(-)

diff --git a/drivers/scsi/hosts.c b/drivers/scsi/hosts.c
index 31c4853462b45..1fc4d5f1135ab 100644
--- a/drivers/scsi/hosts.c
+++ b/drivers/scsi/hosts.c
@@ -231,6 +231,12 @@ int scsi_add_host_with_dma(struct Scsi_Host *shost, struct device *dev,
 		goto fail;
 	}
 
+	if (shost->nr_reserved_cmds && !sht->queue_reserved_command) {
+		shost_printk(KERN_ERR, shost,
+			     "nr_reserved_cmds set but no method to queue\n");
+		goto fail;
+	}
+
 	/* Use min_t(int, ...) in case shost->can_queue exceeds SHRT_MAX */
 	shost->cmd_per_lun = min_t(int, shost->cmd_per_lun,
 				   shost->can_queue);
diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index c6aa6401f16b0..496cbff59c0ab 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -1563,6 +1563,14 @@ static void scsi_complete(struct request *rq)
 	struct scsi_cmnd *cmd = blk_mq_rq_to_pdu(rq);
 	enum scsi_disposition disposition;
 
+	if (blk_mq_is_reserved_rq(rq)) {
+		/* Only pass-through requests are supported in this code path. */
+		WARN_ON_ONCE(!blk_rq_is_passthrough(scsi_cmd_to_rq(cmd)));
+		scsi_mq_uninit_cmd(cmd);
+		__blk_mq_end_request(rq, scsi_result_to_blk_status(cmd->result));
+		return;
+	}
+
 	INIT_LIST_HEAD(&cmd->eh_entry);
 
 	atomic_inc(&cmd->device->iodone_cnt);
@@ -1851,25 +1859,31 @@ static blk_status_t scsi_queue_rq(struct blk_mq_hw_ctx *hctx,
 	WARN_ON_ONCE(cmd->budget_token < 0);
 
 	/*
-	 * If the device is not in running state we will reject some or all
-	 * commands.
+	 * Bypass the SCSI device, SCSI target and SCSI host checks for
+	 * reserved commands.
 	 */
-	if (unlikely(sdev->sdev_state != SDEV_RUNNING)) {
-		ret = scsi_device_state_check(sdev, req);
-		if (ret != BLK_STS_OK)
-			goto out_put_budget;
-	}
+	if (!blk_mq_is_reserved_rq(req)) {
+		/*
+		 * If the device is not in running state we will reject some or
+		 * all commands.
+		 */
+		if (unlikely(sdev->sdev_state != SDEV_RUNNING)) {
+			ret = scsi_device_state_check(sdev, req);
+			if (ret != BLK_STS_OK)
+				goto out_put_budget;
+		}
 
-	ret = BLK_STS_RESOURCE;
-	if (!scsi_target_queue_ready(shost, sdev))
-		goto out_put_budget;
-	if (unlikely(scsi_host_in_recovery(shost))) {
-		if (cmd->flags & SCMD_FAIL_IF_RECOVERING)
-			ret = BLK_STS_OFFLINE;
-		goto out_dec_target_busy;
+		ret = BLK_STS_RESOURCE;
+		if (!scsi_target_queue_ready(shost, sdev))
+			goto out_put_budget;
+		if (unlikely(scsi_host_in_recovery(shost))) {
+			if (cmd->flags & SCMD_FAIL_IF_RECOVERING)
+				ret = BLK_STS_OFFLINE;
+			goto out_dec_target_busy;
+		}
+		if (!scsi_host_queue_ready(q, shost, sdev, cmd))
+			goto out_dec_target_busy;
 	}
-	if (!scsi_host_queue_ready(q, shost, sdev, cmd))
-		goto out_dec_target_busy;
 
 	/*
 	 * Only clear the driver-private command data if the LLD does not supply
@@ -1898,6 +1912,14 @@ static blk_status_t scsi_queue_rq(struct blk_mq_hw_ctx *hctx,
 	cmd->submitter = SUBMITTED_BY_BLOCK_LAYER;
 
 	blk_mq_start_request(req);
+	if (blk_mq_is_reserved_rq(req)) {
+		reason = shost->hostt->queue_reserved_command(shost, cmd);
+		if (reason) {
+			ret = BLK_STS_RESOURCE;
+			goto out_put_budget;
+		}
+		return BLK_STS_OK;
+	}
 	reason = scsi_dispatch_cmd(cmd);
 	if (reason) {
 		scsi_set_blocked(cmd, reason);
diff --git a/include/scsi/scsi_host.h b/include/scsi/scsi_host.h
index 4344f1b7af874..8d489467766c3 100644
--- a/include/scsi/scsi_host.h
+++ b/include/scsi/scsi_host.h
@@ -86,6 +86,12 @@ struct scsi_host_template {
 	 */
 	int (* queuecommand)(struct Scsi_Host *, struct scsi_cmnd *);
 
+	/*
+	 * Queue a reserved command (BLK_MQ_REQ_RESERVED). The .queuecommand()
+	 * documentation also applies to the .queue_reserved_command() callback.
+	 */
+	int (*queue_reserved_command)(struct Scsi_Host *, struct scsi_cmnd *);
+
 	/*
 	 * The commit_rqs function is used to trigger a hardware
 	 * doorbell after some requests have been queued with
-- 
2.53.0



