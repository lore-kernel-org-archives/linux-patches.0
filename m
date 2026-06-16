Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E96034FF79;
	Tue, 16 Jun 2026 18:32:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781634742; cv=none; b=iWBmw9OPnNOQXx1Sv6Dnt4zLJgpsvsTTqifPKswlfONF8XmdNx9BA1wyWbzs0xw05uAlZkTbM3yYrwcv761lY1o75DEgF244T5865tsW7I9dJw9IGduV+tSDqCR/6Z+JfDGueTkSSjmjipP38o4PFnSVDFFV0kNsUR0OC4wg0cI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781634742; c=relaxed/simple;
	bh=zEp4Vi8GYM3IC5uSy6HozzG6wyUWloGOTIFWx5vYVqw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pxvDZx389uuH7v9uyAqBPvvnzWHnusTpmJlz9ORL1n80jgoAd9Ve19qLUnUfYRoaRpTQHUCWI/cp3YtU3e78POdsypPxh3upPU+tiClwjLPHDF2Z8eOToqVo4I8rXcla8RNUXpiucCX+wHKK1Tc8HM05l5kF/9tdfMXUWKFYYcA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ktdKWLq3; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ktdKWLq3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E9EE61F000E9;
	Tue, 16 Jun 2026 18:32:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781634740;
	bh=8u01nJXvxOmJLppazeOvg4sG/iFXY9nXN8+5MZbnjCU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ktdKWLq3a4fJb7B8rx9jywxGTRsJsFKIoIztQ6o8sbH3JLh/eqY9LFY/H8bf7/g6B
	 fPD1Gf+HU48tTi+ENOYUbQJ7vlFeAt2aB/GnZeK3IODJO2FGml4Ks9Dadfkync0fyX
	 X6+04JHCYLBCqwzRQBRWvUR89uM9/ItdNBhOQ8GM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alan Stern <stern@rowland.harvard.edu>,
	Dan Williams <dan.j.williams@intel.com>,
	Hannes Reinecke <hare@suse.com>,
	Adrian Hunter <adrian.hunter@intel.com>,
	Martin Kepplinger <martin.kepplinger@puri.sm>,
	Bart Van Assche <bvanassche@acm.org>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 295/411] scsi: core: pm: Rely on the device driver core for async power management
Date: Tue, 16 Jun 2026 20:28:53 +0530
Message-ID: <20260616145116.832924351@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145100.376842714@linuxfoundation.org>
References: <20260616145100.376842714@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Bart Van Assche <bvanassche@acm.org>

[ Upstream commit a19a93e4c6a98c9c0f2f5a6db76846f10d7d1f85 ]

Instead of implementing asynchronous resume support in the SCSI core, rely
on the device driver core for resuming SCSI devices asynchronously.
Instead of only supporting asynchronous resumes, also support asynchronous
suspends.

Link: https://lore.kernel.org/r/20211006215453.3318929-2-bvanassche@acm.org
Cc: Alan Stern <stern@rowland.harvard.edu>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Hannes Reinecke <hare@suse.com>
Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: Martin Kepplinger <martin.kepplinger@puri.sm>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Stable-dep-of: 1e111c4b3a72 ("scsi: sd: fix missing put_disk() when device_add(&disk_dev) fails")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/scsi/hosts.c      |    1 +
 drivers/scsi/scsi.c       |    8 --------
 drivers/scsi/scsi_pm.c    |   44 ++------------------------------------------
 drivers/scsi/scsi_priv.h  |    4 +---
 drivers/scsi/scsi_scan.c  |   17 +++++++++++++++++
 drivers/scsi/scsi_sysfs.c |    1 +
 drivers/scsi/sd.c         |    1 -
 7 files changed, 22 insertions(+), 54 deletions(-)

--- a/drivers/scsi/hosts.c
+++ b/drivers/scsi/hosts.c
@@ -487,6 +487,7 @@ struct Scsi_Host *scsi_host_alloc(struct
 	dev_set_name(&shost->shost_gendev, "host%d", shost->host_no);
 	shost->shost_gendev.bus = &scsi_bus_type;
 	shost->shost_gendev.type = &scsi_host_type;
+	scsi_enable_async_suspend(&shost->shost_gendev);
 
 	device_initialize(&shost->shost_dev);
 	shost->shost_dev.parent = &shost->shost_gendev;
--- a/drivers/scsi/scsi.c
+++ b/drivers/scsi/scsi.c
@@ -86,14 +86,6 @@ unsigned int scsi_logging_level;
 EXPORT_SYMBOL(scsi_logging_level);
 #endif
 
-/*
- * Domain for asynchronous system resume operations.  It is marked 'exclusive'
- * to avoid being included in the async_synchronize_full() that is invoked by
- * dpm_resume().
- */
-ASYNC_DOMAIN_EXCLUSIVE(scsi_sd_pm_domain);
-EXPORT_SYMBOL(scsi_sd_pm_domain);
-
 #ifdef CONFIG_SCSI_LOGGING
 void scsi_log_send(struct scsi_cmnd *cmd)
 {
--- a/drivers/scsi/scsi_pm.c
+++ b/drivers/scsi/scsi_pm.c
@@ -56,9 +56,6 @@ static int scsi_dev_type_suspend(struct
 	const struct dev_pm_ops *pm = dev->driver ? dev->driver->pm : NULL;
 	int err;
 
-	/* flush pending in-flight resume operations, suspend is synchronous */
-	async_synchronize_full_domain(&scsi_sd_pm_domain);
-
 	err = scsi_device_quiesce(to_scsi_device(dev));
 	if (err == 0) {
 		err = cb(dev, pm);
@@ -123,48 +120,11 @@ scsi_bus_suspend_common(struct device *d
 	return err;
 }
 
-static void async_sdev_resume(void *dev, async_cookie_t cookie)
-{
-	scsi_dev_type_resume(dev, do_scsi_resume);
-}
-
-static void async_sdev_thaw(void *dev, async_cookie_t cookie)
-{
-	scsi_dev_type_resume(dev, do_scsi_thaw);
-}
-
-static void async_sdev_restore(void *dev, async_cookie_t cookie)
-{
-	scsi_dev_type_resume(dev, do_scsi_restore);
-}
-
 static int scsi_bus_resume_common(struct device *dev,
 		int (*cb)(struct device *, const struct dev_pm_ops *))
 {
-	async_func_t fn;
-
-	if (!scsi_is_sdev_device(dev))
-		fn = NULL;
-	else if (cb == do_scsi_resume)
-		fn = async_sdev_resume;
-	else if (cb == do_scsi_thaw)
-		fn = async_sdev_thaw;
-	else if (cb == do_scsi_restore)
-		fn = async_sdev_restore;
-	else
-		fn = NULL;
-
-	if (fn) {
-		async_schedule_domain(fn, dev, &scsi_sd_pm_domain);
-
-		/*
-		 * If a user has disabled async probing a likely reason
-		 * is due to a storage enclosure that does not inject
-		 * staggered spin-ups.  For safety, make resume
-		 * synchronous as well in that case.
-		 */
-		if (strncmp(scsi_scan_type, "async", 5) != 0)
-			async_synchronize_full_domain(&scsi_sd_pm_domain);
+	if (scsi_is_sdev_device(dev)) {
+		scsi_dev_type_resume(dev, cb);
 	} else {
 		pm_runtime_disable(dev);
 		pm_runtime_set_active(dev);
--- a/drivers/scsi/scsi_priv.h
+++ b/drivers/scsi/scsi_priv.h
@@ -117,7 +117,7 @@ extern void scsi_exit_procfs(void);
 #endif /* CONFIG_PROC_FS */
 
 /* scsi_scan.c */
-extern char scsi_scan_type[];
+void scsi_enable_async_suspend(struct device *dev);
 extern int scsi_complete_async_scans(void);
 extern int scsi_scan_host_selected(struct Scsi_Host *, unsigned int,
 				   unsigned int, u64, enum scsi_scan_mode);
@@ -171,8 +171,6 @@ static inline int scsi_autopm_get_host(s
 static inline void scsi_autopm_put_host(struct Scsi_Host *h) {}
 #endif /* CONFIG_PM */
 
-extern struct async_domain scsi_sd_pm_domain;
-
 /* scsi_dh.c */
 #ifdef CONFIG_SCSI_DH
 void scsi_dh_add_device(struct scsi_device *sdev);
--- a/drivers/scsi/scsi_scan.c
+++ b/drivers/scsi/scsi_scan.c
@@ -123,6 +123,22 @@ struct async_scan_data {
 };
 
 /**
+ * scsi_enable_async_suspend - Enable async suspend and resume
+ */
+void scsi_enable_async_suspend(struct device *dev)
+{
+	/*
+	 * If a user has disabled async probing a likely reason is due to a
+	 * storage enclosure that does not inject staggered spin-ups. For
+	 * safety, make resume synchronous as well in that case.
+	 */
+	if (strncmp(scsi_scan_type, "async", 5) != 0)
+		return;
+	/* Enable asynchronous suspend and resume. */
+	device_enable_async_suspend(dev);
+}
+
+/**
  * scsi_complete_async_scans - Wait for asynchronous scans to complete
  *
  * When this function returns, any host which started scanning before
@@ -499,6 +515,7 @@ static struct scsi_target *scsi_alloc_ta
 	dev_set_name(dev, "target%d:%d:%d", shost->host_no, channel, id);
 	dev->bus = &scsi_bus_type;
 	dev->type = &scsi_target_type;
+	scsi_enable_async_suspend(dev);
 	starget->id = id;
 	starget->channel = channel;
 	starget->can_queue = 0;
--- a/drivers/scsi/scsi_sysfs.c
+++ b/drivers/scsi/scsi_sysfs.c
@@ -1643,6 +1643,7 @@ void scsi_sysfs_device_initialize(struct
 	device_initialize(&sdev->sdev_gendev);
 	sdev->sdev_gendev.bus = &scsi_bus_type;
 	sdev->sdev_gendev.type = &scsi_dev_type;
+	scsi_enable_async_suspend(&sdev->sdev_gendev);
 	dev_set_name(&sdev->sdev_gendev, "%d:%d:%d:%llu",
 		     sdev->host->host_no, sdev->channel, sdev->id, sdev->lun);
 
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -3505,7 +3505,6 @@ static int sd_remove(struct device *dev)
 	sdkp = dev_get_drvdata(dev);
 	scsi_autopm_get_device(sdkp->device);
 
-	async_synchronize_full_domain(&scsi_sd_pm_domain);
 	device_del(&sdkp->dev);
 	del_gendisk(sdkp->disk);
 	sd_shutdown(dev);


