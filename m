Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795039519;
	b=3to0hI34cPAEHNS+0dJJp+8H3/YsnfO/gAxiHGviM7S66SsyFE9qrEXOcXHtsoog/z+Q
	 D72C1q/pN26TMgUJvp2UuBsQnCd2lFDxOPY/FhvwHAsn+KuYMkXhaexC1LTHdX+rBK1vP
	 MmXHIdldXgY47Kl3kSY6pGoh80J658V2uNUx55ysvk7d7zIK7JWtzgyDsC5DTrgGIszzL
	 H6zEPc9nFOgnS9dThWgjAV9rH+mp4RQVji3Rq47k5NB8L40DCqs1/G0a6D+KUBkK17Lmo
	 Z4NS6zNF4ofDB2mlgCOnopoN5OhE3o0uJDmLYjUbQ3KpYFC5nPO0X0A0eBCRtQjDL9Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795039519;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=LEBEndkVUjmRmS8XADKh3UGZpfwv0NQmxUHTJjKKWuE=;
	b=3dyLMs1zx1S5dcnSTFmB8f/HJJOnzOcHobJpz+801g5V6f+WTIZgZRnnh77aVN2qPu37
	 St89IM3Tt4Rjm17x4WSZejCgJnqbIz5tgYWX2oOtPn/buqE3GeibnK/zcWkgSEFgS/MGb
	 ZOMZ70OOKvonzW+d9ztI+KU4wNnVW2cJK7oaDUG9TKqQ/WNeIl1uj7j7jOrZMhm9Nhct3
	 CZsTEmOtiXMuXbMKRO96rdv9GfkBvBS5L6KN6KOEiKriNyd/kfMauo1yQBKeozxPyFu/V
	 bfQvBVf99DuthNd1iDDH6rCjh8+aCEZzFGwxPjQfNEmV5VE19Nme6CoWs8cLPGtsX9g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=BjTNPyky;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DFA42606A320;
	Wed, 18 Nov 2026 22:05:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=BjTNPyky
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 42CE91F000C4;
	Wed, 18 Nov 2026 22:05:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795039518;
	bh=LEBEndkVUjmRmS8XADKh3UGZpfwv0NQmxUHTJjKKWuE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=BjTNPykyLeFh7nJT1pb3m7Pc+gtL0GujC9oSvSWX1We6diXu0FTCcwrE6z1lS+MVA
	 y1/7mnd1HtSpfazV7KZEMxJerb7QABevcIg4szoiZOPWEDteju2ldWLkVlAFuqBou6
	 wwGnwRdPb8XPuPZ73+VMB7Gro3wAswxWleIPHKpk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ranjan Kumar <ranjan.kumar@broadcom.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 2128/3318] scsi: mpi3mr: Event processing debug improvement
Date: Wed, 18 Nov 2026 15:45:50 +0100
Message-ID: <20261118150425.899184222@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 2c6efc9f26746..2656c6a3de8bb 100644
--- a/drivers/scsi/mpi3mr/mpi3mr_os.c
+++ b/drivers/scsi/mpi3mr/mpi3mr_os.c
@@ -956,6 +956,10 @@ static int mpi3mr_report_tgtdev_to_host(struct mpi3mr_ioc *mrioc,
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
@@ -1311,9 +1315,9 @@ static void mpi3mr_devstatuschg_evt_bh(struct mpi3mr_ioc *mrioc,
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
@@ -1332,8 +1336,13 @@ static void mpi3mr_devstatuschg_evt_bh(struct mpi3mr_ioc *mrioc,
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
@@ -1373,12 +1382,17 @@ static void mpi3mr_devinfochg_evt_bh(struct mpi3mr_ioc *mrioc,
 
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
@@ -1922,8 +1936,11 @@ static void mpi3mr_fwevt_bh(struct mpi3mr_ioc *mrioc,
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
@@ -1935,6 +1952,9 @@ static void mpi3mr_fwevt_bh(struct mpi3mr_ioc *mrioc,
 	if (!fwevt->process_evt)
 		goto evt_ack;
 
+	dprint_event_bh(mrioc, "processing event(0x%02x) in the bottom half handler\n",
+	    fwevt->event_id);
+
 	switch (fwevt->event_id) {
 	case MPI3_EVENT_DEVICE_ADDED:
 	{
@@ -2691,6 +2711,9 @@ static void mpi3mr_devstatuschg_evt_th(struct mpi3mr_ioc *mrioc,
 		goto out;
 
 	dev_handle = le16_to_cpu(evtdata->dev_handle);
+	dprint_event_th(mrioc,
+	    "device status change event top half with rc(0x%02x) for handle(0x%04x)\n",
+	    evtdata->reason_code, dev_handle);
 
 	switch (evtdata->reason_code) {
 	case MPI3_EVENT_DEV_STAT_RC_INT_DEVICE_RESET_STRT:
@@ -2714,8 +2737,12 @@ static void mpi3mr_devstatuschg_evt_th(struct mpi3mr_ioc *mrioc,
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
@@ -2791,13 +2818,13 @@ static void mpi3mr_energypackchg_evt_th(struct mpi3mr_ioc *mrioc,
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
@@ -2901,9 +2928,11 @@ void mpi3mr_os_handle_events(struct mpi3mr_ioc *mrioc,
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
@@ -2961,11 +2990,15 @@ void mpi3mr_os_handle_events(struct mpi3mr_ioc *mrioc,
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



