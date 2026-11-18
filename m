Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795023342;
	b=bVwfTsdZ5klUOK4Aw6tNK8bwv2DLoaPiJY/QZb3+IA+fuDF5bJCVNzxTWeRI89kwewf8
	 SHagikAeE/YfyVhKh2LYhaX4clvdQVZ7Ere1+RtRBs+0jvIu0ANI0pePxm3xsQ4vKijtA
	 qR2WuwgnKHLlIfUewV7qlUaXFQJAENAgbDsV9qgGUGpYEW0e9w2/uAYqXSZDXCG4cdBxC
	 Y9Nr8SgCfv1BwuMsVl2eZck1jibMwmH9F9dXjGzAwFs0x14WVllQRobP4BYTGaZM66NOB
	 em7mQMTIQ7kWehQfSfqX3pSaFuWBde0OHOZpwv4oP2XRbDn6+PVs4/uKclBG7sg/8zA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795023342;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=P89MwVY004vCqt2gkbE7TM8DLPc8R2fL9//gFXOFks8=;
	b=Z3ylilH5NkVWbRezXtFXptq4rLNq9nJH4RTrQUpSDniMV/gbt3LzoJhGk55TNi86E097
	 4qErmgwdRHyySQMFjggvS01pE4mnh5XyGzDjXKO69Lem1W1UTKQRzToGvWOyg7lvRUIcf
	 En2OxZhiYlfN6t5Ksmxk4P/mGTfVk4PMsN+Zk4HzlqXaMPlCQu+NtuqUuFT4oaR0R+dBB
	 nepEVI7YyDswfHkYW8Ux1yxufwzDNwwHEA/ddYmcsdWAW4/F1XR7ZeeXFBJjwCyp3W8XG
	 T7/SmHuZdrAq7vQHTmd3BR5sFrzgX/bbvr0p5TvqRFcRC2Pd0hthoRdi283poH2ujEQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=rrwiL78m;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 06EAC606A32A;
	Wed, 18 Nov 2026 17:35:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=rrwiL78m
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 548881F000C4;
	Wed, 18 Nov 2026 17:35:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795023341;
	bh=P89MwVY004vCqt2gkbE7TM8DLPc8R2fL9//gFXOFks8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=rrwiL78mkOLXCStWGfxTlJMQdKBf/IyYyE6L/U46+0xM4nvSvKtn18Nf1SIr9jr27
	 gKW1vGpl4gPVtvZFFLzJjFnSsGUxYidwp6LbF1vVp20FqO+3/NEmj2Rz6HEGsAQPK8
	 v6ScunNnpH6jCD8jmZCo9ok11/uz6MrRsMX+2/AI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chandrakanth Patil <chandrakanth.patil@broadcom.com>,
	"Martin K. Petersen (Oracle)" <mkp@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0333/2151] scsi: mpi3mr: Fix out-of-bounds bitmap access during device removal
Date: Wed, 18 Nov 2026 15:34:28 +0100
Message-ID: <20261118150134.124337874@linuxfoundation.org>
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
index d4ca878d08869..848afd656cf2e 100644
--- a/drivers/scsi/mpi3mr/mpi3mr_os.c
+++ b/drivers/scsi/mpi3mr/mpi3mr_os.c
@@ -2313,7 +2313,8 @@ static void mpi3mr_dev_rmhs_complete_iou(struct mpi3mr_ioc *mrioc,
 		ioc_info(mrioc,
 		    "%s :dev removal handshake completed successfully: handle(0x%04x)\n",
 		    __func__, drv_cmd->dev_handle);
-		clear_bit(drv_cmd->dev_handle, mrioc->removepend_bitmap);
+		if (drv_cmd->dev_handle < mrioc->facts.max_devhandle)
+			clear_bit(drv_cmd->dev_handle, mrioc->removepend_bitmap);
 	}
 
 	if (!list_empty(&mrioc->delayed_rmhs_list)) {
@@ -2427,6 +2428,20 @@ static void mpi3mr_dev_rmhs_send_tm(struct mpi3mr_ioc *mrioc, u16 handle,
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



