Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795048045;
	b=qQbzbkwemGeAwXdo4UHCGdZCIsXQhyLEIBtHybKGV44FJjXJI8/X69X6ZQa/8/J++bQ6
	 XOYj8GTNGSEvH1H06AKn+X5zItUYCVFt8QPqo/QXlRsadjaHw3y/Pyal3+E5fOben4hzj
	 s8Fy7F4uJDSd6kCGRr1vGsWyHDT3gW3hlqKmy6fa/bxFM6M0gJHK4O4zG7iFADOQXwT5m
	 CeM1C8hxQ2iozjL6zm7jhnIy3sgMCGg8UEUmjIa6asL6RwAtRgvXtVeoXHe/4uYPKRBeg
	 CTitXT52iTymOxSkWFFf1r53Lvii+NsfbEurzblHOsh+3rI4o0KCGxKLvEemy57/VMA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795048045;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=dg5ZvU1yGiGSGvXhvSEmKrOupdODHwQP0GqfeRamP7I=;
	b=VFFbmABkTM1JYMJwDQCayThE5lvqj4Q9tw0x/KwHTdTR4Sm7tVhJObuxmb8NZuXk99yO
	 rUT+27QKs04+R1a7kDHqWnj/Nm9AuDZ4OVE9jkvynNYBzbHMAd8iQzvSyKZF6V/oHdaXi
	 5PFauLJBM1+jzzebMvGdknt8jXO8NbaPtS69Tit5Nf30c05sE9n8tVSzC9qcQ+DbeUw8B
	 1QJNHa20DLrSQT2Ahn1JOpHJegOEu2JsGDk3ZQJLMKr8/nO9soSV0yxwLbNTgsu+jbQbR
	 CcJ0PGmwlSuQDDITZUtQO+/0887LP+9zpD51KLb91ndHKiN4lHLayezZ0jDHCJ3CvuQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=vGp4+QyX;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AAF96606A325;
	Thu, 19 Nov 2026 00:27:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=vGp4+QyX
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 065181F000C4;
	Thu, 19 Nov 2026 00:27:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795048045;
	bh=dg5ZvU1yGiGSGvXhvSEmKrOupdODHwQP0GqfeRamP7I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=vGp4+QyXFeLQPM4hlwxe+/sqN+Qkb0A39v0RCqc0jHAKajjhVBiN0X+Xc7TlGhe26
	 KHANyDeWFvbukjP139sHy/fG8LOXB5TsgOcKLRyo4rXigIUXI7EETmC3dleXdl6Pe/
	 81smP5qvW3FORGTN66rJrmT0thMF7THDzG4WtDQI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ranjan Kumar <ranjan.kumar@broadcom.com>,
	Sreekanth Reddy <sreekanth.reddy@broadcom.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1853/2857] scsi: mpi3mr: Successive VD delete and add causes FW fault
Date: Wed, 18 Nov 2026 15:48:07 +0100
Message-ID: <20261118150307.961210939@linuxfoundation.org>
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

From: Ranjan Kumar <ranjan.kumar@broadcom.com>

[ Upstream commit 3f1254ed01d0860d72eead408b4fb0f38858219e ]

Upon Virtual disk removal, firmware sends device status change event
(Virtual disk remove event) and expects the driver to start device remove
handshake (by sending target reset and IOU control command to firmware).
However, the driver does not initiate the device remove handshake which
leads to the firmware fault.

Signed-off-by: Ranjan Kumar <ranjan.kumar@broadcom.com>
Signed-off-by: Sreekanth Reddy <sreekanth.reddy@broadcom.com>
Link: https://lore.kernel.org/r/20230316110209.60145-2-ranjan.kumar@broadcom.com
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Stable-dep-of: 5dade59551d3 ("scsi: mpi3mr: Fix out-of-bounds bitmap access during device removal")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/mpi3mr/mpi3mr.h    |  8 +++++-
 drivers/scsi/mpi3mr/mpi3mr_os.c | 48 +++++++++++++++++++++++----------
 2 files changed, 41 insertions(+), 15 deletions(-)

diff --git a/drivers/scsi/mpi3mr/mpi3mr.h b/drivers/scsi/mpi3mr/mpi3mr.h
index 422cb50b3577e..bd7dbb1490b8e 100644
--- a/drivers/scsi/mpi3mr/mpi3mr.h
+++ b/drivers/scsi/mpi3mr/mpi3mr.h
@@ -651,7 +651,11 @@ union _form_spec_inf {
 	struct tgt_dev_vd vd_inf;
 };
 
-
+enum mpi3mr_dev_state {
+	MPI3MR_DEV_CREATED = 1,
+	MPI3MR_DEV_REMOVE_HS_STARTED = 2,
+	MPI3MR_DEV_DELETED = 3,
+};
 
 /**
  * struct mpi3mr_tgt_dev - target device data structure
@@ -675,6 +679,7 @@ union _form_spec_inf {
  * @enclosure_logical_id: Enclosure logical identifier
  * @dev_spec: Device type specific information
  * @ref_count: Reference count
+ * @state: device state
  */
 struct mpi3mr_tgt_dev {
 	struct list_head list;
@@ -696,6 +701,7 @@ struct mpi3mr_tgt_dev {
 	u64 enclosure_logical_id;
 	union _form_spec_inf dev_spec;
 	struct kref ref_count;
+	enum mpi3mr_dev_state state;
 };
 
 /**
diff --git a/drivers/scsi/mpi3mr/mpi3mr_os.c b/drivers/scsi/mpi3mr/mpi3mr_os.c
index 30c2b9053efe9..8b2ecc7383b13 100644
--- a/drivers/scsi/mpi3mr/mpi3mr_os.c
+++ b/drivers/scsi/mpi3mr/mpi3mr_os.c
@@ -659,6 +659,7 @@ static void mpi3mr_tgtdev_add_to_list(struct mpi3mr_ioc *mrioc,
 	mpi3mr_tgtdev_get(tgtdev);
 	INIT_LIST_HEAD(&tgtdev->list);
 	list_add_tail(&tgtdev->list, &mrioc->tgtdev_list);
+	tgtdev->state = MPI3MR_DEV_CREATED;
 	spin_unlock_irqrestore(&mrioc->tgtdev_lock, flags);
 }
 
@@ -666,20 +667,25 @@ static void mpi3mr_tgtdev_add_to_list(struct mpi3mr_ioc *mrioc,
  * mpi3mr_tgtdev_del_from_list -Delete tgtdevice from the list
  * @mrioc: Adapter instance reference
  * @tgtdev: Target device
+ * @must_delete: Must delete the target device from the list irrespective
+ * of the device state.
  *
  * Remove the target device from the target device list
  *
  * Return: Nothing.
  */
 static void mpi3mr_tgtdev_del_from_list(struct mpi3mr_ioc *mrioc,
-	struct mpi3mr_tgt_dev *tgtdev)
+	struct mpi3mr_tgt_dev *tgtdev, bool must_delete)
 {
 	unsigned long flags;
 
 	spin_lock_irqsave(&mrioc->tgtdev_lock, flags);
-	if (!list_empty(&tgtdev->list)) {
-		list_del_init(&tgtdev->list);
-		mpi3mr_tgtdev_put(tgtdev);
+	if ((tgtdev->state == MPI3MR_DEV_REMOVE_HS_STARTED) || (must_delete == true)) {
+		if (!list_empty(&tgtdev->list)) {
+			list_del_init(&tgtdev->list);
+			tgtdev->state = MPI3MR_DEV_DELETED;
+			mpi3mr_tgtdev_put(tgtdev);
+		}
 	}
 	spin_unlock_irqrestore(&mrioc->tgtdev_lock, flags);
 }
@@ -1043,7 +1049,7 @@ void mpi3mr_rfresh_tgtdevs(struct mpi3mr_ioc *mrioc)
 			    tgtdev->perst_id);
 			if (tgtdev->host_exposed)
 				mpi3mr_remove_tgtdev_from_host(mrioc, tgtdev);
-			mpi3mr_tgtdev_del_from_list(mrioc, tgtdev);
+			mpi3mr_tgtdev_del_from_list(mrioc, tgtdev, true);
 			mpi3mr_tgtdev_put(tgtdev);
 		}
 	}
@@ -1294,12 +1300,12 @@ static void mpi3mr_devstatuschg_evt_bh(struct mpi3mr_ioc *mrioc,
 		if (!tgtdev->host_exposed)
 			mpi3mr_report_tgtdev_to_host(mrioc, tgtdev->perst_id);
 	}
-	if (tgtdev->starget && tgtdev->starget->hostdata) {
-		if (delete)
-			mpi3mr_remove_tgtdev_from_host(mrioc, tgtdev);
-	}
+
+	if (delete)
+		mpi3mr_remove_tgtdev_from_host(mrioc, tgtdev);
+
 	if (cleanup) {
-		mpi3mr_tgtdev_del_from_list(mrioc, tgtdev);
+		mpi3mr_tgtdev_del_from_list(mrioc, tgtdev, false);
 		mpi3mr_tgtdev_put(tgtdev);
 	}
 
@@ -1617,7 +1623,7 @@ static void mpi3mr_sastopochg_evt_bh(struct mpi3mr_ioc *mrioc,
 		case MPI3_EVENT_SAS_TOPO_PHY_RC_TARG_NOT_RESPONDING:
 			if (tgtdev->host_exposed)
 				mpi3mr_remove_tgtdev_from_host(mrioc, tgtdev);
-			mpi3mr_tgtdev_del_from_list(mrioc, tgtdev);
+			mpi3mr_tgtdev_del_from_list(mrioc, tgtdev, false);
 			mpi3mr_tgtdev_put(tgtdev);
 			break;
 		case MPI3_EVENT_SAS_TOPO_PHY_RC_RESPONDING:
@@ -1775,7 +1781,7 @@ static void mpi3mr_pcietopochg_evt_bh(struct mpi3mr_ioc *mrioc,
 		case MPI3_EVENT_PCIE_TOPO_PS_NOT_RESPONDING:
 			if (tgtdev->host_exposed)
 				mpi3mr_remove_tgtdev_from_host(mrioc, tgtdev);
-			mpi3mr_tgtdev_del_from_list(mrioc, tgtdev);
+			mpi3mr_tgtdev_del_from_list(mrioc, tgtdev, false);
 			mpi3mr_tgtdev_put(tgtdev);
 			break;
 		default:
@@ -2029,12 +2035,18 @@ static int mpi3mr_create_tgtdev(struct mpi3mr_ioc *mrioc,
 	int retval = 0;
 	struct mpi3mr_tgt_dev *tgtdev = NULL;
 	u16 perst_id = 0;
+	unsigned long flags;
 
 	perst_id = le16_to_cpu(dev_pg0->persistent_id);
 	if (perst_id == MPI3_DEVICE0_PERSISTENTID_INVALID)
 		return retval;
 
-	tgtdev = mpi3mr_get_tgtdev_by_perst_id(mrioc, perst_id);
+	spin_lock_irqsave(&mrioc->tgtdev_lock, flags);
+	tgtdev = __mpi3mr_get_tgtdev_by_perst_id(mrioc, perst_id);
+	if (tgtdev)
+		tgtdev->state = MPI3MR_DEV_CREATED;
+	spin_unlock_irqrestore(&mrioc->tgtdev_lock, flags);
+
 	if (tgtdev) {
 		mpi3mr_update_tgtdev(mrioc, tgtdev, dev_pg0, true);
 		mpi3mr_tgtdev_put(tgtdev);
@@ -2232,6 +2244,14 @@ static void mpi3mr_dev_rmhs_send_tm(struct mpi3mr_ioc *mrioc, u16 handle,
 	u8 retrycount = 5;
 	struct mpi3mr_drv_cmd *drv_cmd = cmdparam;
 	struct delayed_dev_rmhs_node *delayed_dev_rmhs = NULL;
+	struct mpi3mr_tgt_dev *tgtdev = NULL;
+	unsigned long flags;
+
+	spin_lock_irqsave(&mrioc->tgtdev_lock, flags);
+	tgtdev = __mpi3mr_get_tgtdev_by_handle(mrioc, handle);
+	if (tgtdev && (iou_rc == MPI3_CTRL_OP_REMOVE_DEVICE))
+		tgtdev->state = MPI3MR_DEV_REMOVE_HS_STARTED;
+	spin_unlock_irqrestore(&mrioc->tgtdev_lock, flags);
 
 	if (drv_cmd)
 		goto issue_cmd;
@@ -5151,7 +5171,7 @@ static void mpi3mr_remove(struct pci_dev *pdev)
 	list_for_each_entry_safe(tgtdev, tgtdev_next, &mrioc->tgtdev_list,
 	    list) {
 		mpi3mr_remove_tgtdev_from_host(mrioc, tgtdev);
-		mpi3mr_tgtdev_del_from_list(mrioc, tgtdev);
+		mpi3mr_tgtdev_del_from_list(mrioc, tgtdev, true);
 		mpi3mr_tgtdev_put(tgtdev);
 	}
 	mpi3mr_stop_watchdog(mrioc);
-- 
2.53.0



