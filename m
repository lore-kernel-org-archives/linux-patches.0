Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795048071;
	b=FXOs7xxZDqEGvc1hRFh0McdqmnIr0rYEiW8a03wbbDxqJGZ64CgRoOxurmipvoh7/6sX
	 GPgN7dg5xLPKe0kelGMlx/nGgGlBJGVuDB2wx1OqGvBRPyHQlgvnWv1MKiIilF3/ryVCo
	 JprxtgtuBF2Ocl4Pwdv1U25S+od/5W7qNQP5IY9qYDO6rsaewhAR4V2Da3zE+cVHbDKuX
	 UuV0pNQkoxjme7fucT2Zuuf7iv3O3zI7Skyut8nVl1bNFjb35BOSUPkFXvG+efPGVhOnW
	 FxsRI0oz6yXyuOQYNqRssW4hukF2EvCse6R3XXxI/xKkjEucBIcB4RA+sel8gfLGKMA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795048071;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=X6/coZFCcnrSJj8q0g5KbJMm3/GH9rYR4JC4OLYQ8Dw=;
	b=xesdqmXj0iIu7C0rxkNIHjNPp/6U7YRa3/JumCugcQdvUSoSnm8VzcjJv6SnHF4yORlS
	 cJ9ZJEVZ6VQqP7YsyGCUFR7+7qVGEOtr3kxSnjvohAYErJ1bacr2BQobm3nIYDFjpCc3v
	 axPD85PfowpXHLSOIjMQkUW2mv4O4I9qxLpTNmGTf5Hu3OHeZbuOzPJ8dwK1DooKMuD9z
	 +g6+Ne6rviSveQokMlZ3VZpecJ58J983vT9cxVQVyViZLNeqvPZv03wFoVd4I5KKEsFmp
	 wV8ffFhBrHc8su34i5pfakTYvjFHUogs3sdgyrgV9B/OifaXy2SO+tn1TdX3QoFnqnQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=qN0as4nw;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E0306606A31C;
	Thu, 19 Nov 2026 00:27:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=qN0as4nw
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 39E501F000C4;
	Thu, 19 Nov 2026 00:27:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795048070;
	bh=X6/coZFCcnrSJj8q0g5KbJMm3/GH9rYR4JC4OLYQ8Dw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=qN0as4nwwhc2tFhqL7QQgZ2Pi00quQB1+rSkKc17nLj53WZePXyqLnxo2mP6Uj+3/
	 ME1DCwGmfyR066Iq/QXfzW0IXRSqm1hgOXc/mDtPG8PiP5eVvPF3WuehmRBBpwAPaN
	 dtjJs3RXPlQBtiMt3wOIc9xe8GnhXRpirvd8TUy4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ranjan Kumar <ranjan.kumar@broadcom.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1857/2857] scsi: mpi3mr: Event processing debug improvement
Date: Wed, 18 Nov 2026 15:48:11 +0100
Message-ID: <20261118150308.106630266@linuxfoundation.org>
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

[ Upstream commit 04f79c113ae77732e7e6674bd814e76c7a3453cf ]

Improve event process debugging. Implement more verbose event logging
throughout the driver.

Signed-off-by: Ranjan Kumar <ranjan.kumar@broadcom.com>
Link: https://lore.kernel.org/r/20250423092139.110206-1-ranjan.kumar@broadcom.com
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Stable-dep-of: 77554f01187d ("scsi: mpi3mr: Fix out-of-bounds read of event data")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/mpi3mr/mpi3mr_os.c | 67 ++++++++++++++++++++++++---------
 1 file changed, 50 insertions(+), 17 deletions(-)

diff --git a/drivers/scsi/mpi3mr/mpi3mr_os.c b/drivers/scsi/mpi3mr/mpi3mr_os.c
index 51e390c44784e..600f771ae1403 100644
--- a/drivers/scsi/mpi3mr/mpi3mr_os.c
+++ b/drivers/scsi/mpi3mr/mpi3mr_os.c
@@ -948,6 +948,10 @@ static int mpi3mr_report_tgtdev_to_host(struct mpi3mr_ioc *mrioc,
 				goto out;
 			}
 		}
+		dprint_event_bh(mrioc,
+		    "exposed target device with handle(0x%04x), perst_id(%d)\n",
+		    tgtdev->dev_handle, perst_id);
+		goto out;
 	} else
 		mpi3mr_report_tgtdev_to_sas_transport(mrioc, tgtdev);
 out:
@@ -1272,9 +1276,9 @@ static void mpi3mr_devstatuschg_evt_bh(struct mpi3mr_ioc *mrioc,
 	    (struct mpi3_event_data_device_status_change *)fwevt->event_data;
 
 	dev_handle = le16_to_cpu(evtdata->dev_handle);
-	ioc_info(mrioc,
-	    "%s :device status change: handle(0x%04x): reason code(0x%x)\n",
-	    __func__, dev_handle, evtdata->reason_code);
+	dprint_event_bh(mrioc,
+	    "processing device status change event bottom half for handle(0x%04x), rc(0x%02x)\n",
+	    dev_handle, evtdata->reason_code);
 	switch (evtdata->reason_code) {
 	case MPI3_EVENT_DEV_STAT_RC_HIDDEN:
 		delete = 1;
@@ -1293,8 +1297,13 @@ static void mpi3mr_devstatuschg_evt_bh(struct mpi3mr_ioc *mrioc,
 	}
 
 	tgtdev = mpi3mr_get_tgtdev_by_handle(mrioc, dev_handle);
-	if (!tgtdev)
+	if (!tgtdev) {
+		dprint_event_bh(mrioc,
+		    "processing device status change event bottom half,\n"
+		    "cannot identify target device for handle(0x%04x), rc(0x%02x)\n",
+		    dev_handle, evtdata->reason_code);
 		goto out;
+	}
 	if (uhide) {
 		tgtdev->is_hidden = 0;
 		if (!tgtdev->host_exposed)
@@ -1334,12 +1343,17 @@ static void mpi3mr_devinfochg_evt_bh(struct mpi3mr_ioc *mrioc,
 
 	perst_id = le16_to_cpu(dev_pg0->persistent_id);
 	dev_handle = le16_to_cpu(dev_pg0->dev_handle);
-	ioc_info(mrioc,
-	    "%s :Device info change: handle(0x%04x): persist_id(0x%x)\n",
-	    __func__, dev_handle, perst_id);
+	dprint_event_bh(mrioc,
+	    "processing device info change event bottom half for handle(0x%04x), perst_id(%d)\n",
+	    dev_handle, perst_id);
 	tgtdev = mpi3mr_get_tgtdev_by_handle(mrioc, dev_handle);
-	if (!tgtdev)
+	if (!tgtdev) {
+		dprint_event_bh(mrioc,
+		    "cannot identify target device for  device info\n"
+		    "change event handle(0x%04x), perst_id(%d)\n",
+		    dev_handle, perst_id);
 		goto out;
+	}
 	mpi3mr_update_tgtdev(mrioc, tgtdev, dev_pg0, false);
 	if (!tgtdev->is_hidden && !tgtdev->host_exposed)
 		mpi3mr_report_tgtdev_to_host(mrioc, perst_id);
@@ -1883,8 +1897,11 @@ static void mpi3mr_fwevt_bh(struct mpi3mr_ioc *mrioc,
 	mpi3mr_fwevt_del_from_list(mrioc, fwevt);
 	mrioc->current_event = fwevt;
 
-	if (mrioc->stop_drv_processing)
+	if (mrioc->stop_drv_processing) {
+		dprint_event_bh(mrioc, "ignoring event(0x%02x) in the bottom half handler\n"
+				"due to stop_drv_processing\n", fwevt->event_id);
 		goto out;
+	}
 
 	if (mrioc->unrecoverable) {
 		dprint_event_bh(mrioc,
@@ -1896,6 +1913,9 @@ static void mpi3mr_fwevt_bh(struct mpi3mr_ioc *mrioc,
 	if (!fwevt->process_evt)
 		goto evt_ack;
 
+	dprint_event_bh(mrioc, "processing event(0x%02x) in the bottom half handler\n",
+	    fwevt->event_id);
+
 	switch (fwevt->event_id) {
 	case MPI3_EVENT_DEVICE_ADDED:
 	{
@@ -2652,6 +2672,9 @@ static void mpi3mr_devstatuschg_evt_th(struct mpi3mr_ioc *mrioc,
 		goto out;
 
 	dev_handle = le16_to_cpu(evtdata->dev_handle);
+	dprint_event_th(mrioc,
+	    "device status change event top half with rc(0x%02x) for handle(0x%04x)\n",
+	    evtdata->reason_code, dev_handle);
 
 	switch (evtdata->reason_code) {
 	case MPI3_EVENT_DEV_STAT_RC_INT_DEVICE_RESET_STRT:
@@ -2675,8 +2698,12 @@ static void mpi3mr_devstatuschg_evt_th(struct mpi3mr_ioc *mrioc,
 	}
 
 	tgtdev = mpi3mr_get_tgtdev_by_handle(mrioc, dev_handle);
-	if (!tgtdev)
+	if (!tgtdev) {
+		dprint_event_th(mrioc,
+		    "processing device status change event could not identify device for handle(0x%04x)\n",
+		    dev_handle);
 		goto out;
+	}
 	if (hide)
 		tgtdev->is_hidden = hide;
 	if (tgtdev->starget && tgtdev->starget->hostdata) {
@@ -2752,13 +2779,13 @@ static void mpi3mr_energypackchg_evt_th(struct mpi3mr_ioc *mrioc,
 	u16 shutdown_timeout = le16_to_cpu(evtdata->shutdown_timeout);
 
 	if (shutdown_timeout <= 0) {
-		ioc_warn(mrioc,
+		dprint_event_th(mrioc,
 		    "%s :Invalid Shutdown Timeout received = %d\n",
 		    __func__, shutdown_timeout);
 		return;
 	}
 
-	ioc_info(mrioc,
+	dprint_event_th(mrioc,
 	    "%s :Previous Shutdown Timeout Value = %d New Shutdown Timeout Value = %d\n",
 	    __func__, mrioc->facts.shutdown_timeout, shutdown_timeout);
 	mrioc->facts.shutdown_timeout = shutdown_timeout;
@@ -2862,9 +2889,11 @@ void mpi3mr_os_handle_events(struct mpi3mr_ioc *mrioc,
 		struct mpi3_device_page0 *dev_pg0 =
 		    (struct mpi3_device_page0 *)event_reply->event_data;
 		if (mpi3mr_create_tgtdev(mrioc, dev_pg0))
-			ioc_err(mrioc,
-			    "%s :Failed to add device in the device add event\n",
-			    __func__);
+			dprint_event_th(mrioc,
+				"failed to process device added event for handle(0x%04x),\n"
+				"perst_id(%d) in the event top half handler\n",
+				le16_to_cpu(dev_pg0->dev_handle),
+				le16_to_cpu(dev_pg0->persistent_id));
 		else
 			process_evt_bh = 1;
 		break;
@@ -2922,11 +2951,15 @@ void mpi3mr_os_handle_events(struct mpi3mr_ioc *mrioc,
 		break;
 	}
 	if (process_evt_bh || ack_req) {
+		dprint_event_th(mrioc,
+			"scheduling bottom half handler for event(0x%02x),ack_required=%d\n",
+			evt_type, ack_req);
 		sz = event_reply->event_data_length * 4;
 		fwevt = mpi3mr_alloc_fwevt(sz);
 		if (!fwevt) {
-			ioc_info(mrioc, "%s :failure at %s:%d/%s()!\n",
-			    __func__, __FILE__, __LINE__, __func__);
+			dprint_event_th(mrioc,
+				"failed to schedule bottom half handler for\n"
+				"event(0x%02x), ack_required=%d\n", evt_type, ack_req);
 			return;
 		}
 
-- 
2.53.0



