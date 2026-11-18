Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795015919;
	b=UCM6Xng+ebOAlRUL94e0ZbwOIPJgFedTAmSupU7ps9F6/spdzJFXtBUgoveP8vaQBVMA
	 EtWsYE38n51EFxoRplI6tYB5fn8l7cm06JOMs8GkOnQchNn95yc4XTvEXYgX/GSs0B3JE
	 rCZ+ld0PzdLdfvLnEdGCQCaSe/Wr2a6Q4YO9CLjyzaivwDa9AOWKgc3QmRdVQlk3TMCZT
	 8zafIr1qq28nd4tsqVb2RB2LL4lZwNmDIj/xUHWz5JkMxpSzWWhLGjtbZsyhPcTJLy7cg
	 qkD8fQDyhSINALqEHk5uLmGKazvrg0ooG5YPr6Ww4ZekC9wguwmhJA0y+lD6OrehrPQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795015919;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=iNHELLbTkAPkIKHBzxrPaV2XVURdHGf+RebajLHhMMU=;
	b=etXtymiNDrf6Zrpp3LoZA917VPH4bDqjzA10dwTUV1YmJpc8X3eW1wbeeRhc6mBpugui
	 y9kBbljuc2KiY2BhYlx1sNEe8xp3v7WlvEs39YEZmXhiBik1Z5Bm5PcADtk0B6iHRNCXI
	 tXNwLZR5UiV5gjr1O0C7/wwhabHRI5Mx0t+/9KE0RT6gD38IG6NUQo9by7AWrEXXpN4RX
	 Sla7FzVDr4F56+l6H7iyutN5Tpn4NaSXNk0w2R0PZlnCXZXFkG6NTQ5SCLPIza/XOt3vW
	 SFltVJWXU+oj3CGy8fOYU+o/cYh0gz6SVQLUQHoGroKDir/uWYdqtMVCHeT+/tqdfsw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=qzyFfI1x;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 336C2606A325;
	Wed, 18 Nov 2026 15:31:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=qzyFfI1x
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 84B4E1F000C7;
	Wed, 18 Nov 2026 15:31:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795015919;
	bh=iNHELLbTkAPkIKHBzxrPaV2XVURdHGf+RebajLHhMMU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=qzyFfI1xyYg+OiKrO9pQTCTYgXM3ksDpyu88nBVUUC3qk/Zn4ErWA5XtlVYgyFGVw
	 CGqbECTBvURKIaYZMH4RC1a1QZPARMXfIgTo8AD9XR1Y6d8RzL/qSnwyzN9tt5u/d6
	 fk+QE1wAndz+eaZ06RZ81sWC4onOqQjKS227TIWc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chandrakanth Patil <chandrakanth.patil@broadcom.com>,
	"Martin K. Petersen (Oracle)" <mkp@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0337/2651] scsi: mpi3mr: Fix out-of-bounds bitmap access during device removal
Date: Wed, 18 Nov 2026 15:26:17 +0100
Message-ID: <20261118150259.984192093@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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

From: Chandrakanth Patil <chandrakanth.patil@broadcom.com>

[ Upstream commit 5dade59551d344d0308256edfef6bc3fb4202eb3 ]

Device handles reported by the controller are used to index the remove
pending bitmap and to build a task management request without being
compared against the maximum handle the controller reported.

Check the handle before using it.

Fixes: 13ef29ea4aa0 ("scsi: mpi3mr: Add support for device add/remove event handling")
Signed-off-by: Chandrakanth Patil <chandrakanth.patil@broadcom.com>
Link: https://patch.msgid.link/20260825210411.301535-9-chandrakanth.patil@broadcom.com
Signed-off-by: Martin K. Petersen (Oracle) <mkp@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/mpi3mr/mpi3mr_os.c | 17 ++++++++++++++++-
 1 file changed, 16 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/mpi3mr/mpi3mr_os.c b/drivers/scsi/mpi3mr/mpi3mr_os.c
index 0f73804487188..f146c1b7bf8d5 100644
--- a/drivers/scsi/mpi3mr/mpi3mr_os.c
+++ b/drivers/scsi/mpi3mr/mpi3mr_os.c
@@ -2426,7 +2426,8 @@ static void mpi3mr_dev_rmhs_complete_iou(struct mpi3mr_ioc *mrioc,
 		ioc_info(mrioc,
 		    "%s :dev removal handshake completed successfully: handle(0x%04x)\n",
 		    __func__, drv_cmd->dev_handle);
-		clear_bit(drv_cmd->dev_handle, mrioc->removepend_bitmap);
+		if (drv_cmd->dev_handle < mrioc->facts.max_devhandle)
+			clear_bit(drv_cmd->dev_handle, mrioc->removepend_bitmap);
 	}
 
 	if (!list_empty(&mrioc->delayed_rmhs_list)) {
@@ -2540,6 +2541,20 @@ static void mpi3mr_dev_rmhs_send_tm(struct mpi3mr_ioc *mrioc, u16 handle,
 	struct mpi3mr_tgt_dev *tgtdev = NULL;
 	unsigned long flags;
 
+	if (handle >= mrioc->facts.max_devhandle) {
+		ioc_err(mrioc, "dev_remove_hs: handle(0x%04x) >= max_devhandle(0x%04x)\n",
+			handle, mrioc->facts.max_devhandle);
+		if (drv_cmd) {
+			cmd_idx = drv_cmd->host_tag - MPI3MR_HOSTTAG_DEVRMCMD_MIN;
+			drv_cmd->state = MPI3MR_CMD_NOTUSED;
+			drv_cmd->callback = NULL;
+			drv_cmd->dev_handle = MPI3MR_INVALID_DEV_HANDLE;
+			drv_cmd->retry_count = 0;
+			clear_bit(cmd_idx, mrioc->devrem_bitmap);
+		}
+		return;
+	}
+
 	spin_lock_irqsave(&mrioc->tgtdev_lock, flags);
 	tgtdev = __mpi3mr_get_tgtdev_by_handle(mrioc, handle);
 	if (tgtdev && (iou_rc == MPI3_CTRL_OP_REMOVE_DEVICE))
-- 
2.53.0



