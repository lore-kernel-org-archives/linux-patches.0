Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 234E94F30E3;
	Tue, 13 Oct 2026 12:20:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791894054; cv=none; b=akszsK0wxmVodQSw3J196jfTr4k7Xua+B4aiVIi7qApusVc5NOcJ6L73DK93G+IRI54MD6tp1qImNjlU5sQDsvZbK2DaHQ3C83VwQXWcYfOX6PwBvGJ1g2jg2c38SojD4MOaM28ITqu1gBu1OtGwsfWiCAxybgC34ol/HCXNbdg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791894054; c=relaxed/simple;
	bh=kqVs+kEyU3Q0uV4BsQaRWO2XqmOkAM11EgoiqIoYgfc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=kDGpBbElSKLd0wYw5AD9A6xqNE4STtC0cMaVhlldwO/JlXPJ1m7e7ZD1PanG0A2EYKg+y5VF2VUM4TXOMJP0g3/rBdLnosn6USGg7YYfSQd3S19uDhNPQognH+BrqiPcD4VPXJUiPWDV4OfTxD3b5E8n7n58ibNklgcoOVJ456A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VEAJr31r; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VEAJr31r"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6F3011F000FF;
	Tue, 13 Oct 2026 12:20:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791894053;
	bh=/n53NNXIngsQ2deDnEkLdFVkrdIMgbM+63iKa4o9aTs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=VEAJr31rg9PaetzHdOcnPDeB/2ZpVPQ7qDN2mYtMOpUHsKtnLcGnYne22C4e92GRo
	 L+Wo4rRu+41gSBqquFkzDbtrZmOJXJIzoBrGRDsCdHvtK2cie6rYEbKLQ2GYYY64qV
	 cVD32RGNTZ99a666cAHBEcS8Q9GX7LjxabM4vRCc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peter Wang <peter.wang@mediatek.com>,
	=?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= <u.kleine-koenig@baylibre.com>,
	Bart Van Assche <bvanassche@acm.org>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 429/621] scsi: core: Pass a struct scsi_driver to scsi_{,un}register_driver()
Date: Tue, 13 Oct 2026 13:37:04 +0200
Message-ID: <20261013112931.016293732@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261013112920.855194808@linuxfoundation.org>
References: <20261013112920.855194808@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Uwe Kleine-König <u.kleine-koenig@baylibre.com>

[ Upstream commit 7d42bcea57ae139e2ed754425cc5fc44e260c890 ]

This aligns with what other subsystems do, reduces boilerplate a bit for
device drivers and is less error prone.

Reviewed-by: Peter Wang <peter.wang@mediatek.com>
Signed-off-by: Uwe Kleine-König <u.kleine-koenig@baylibre.com>
Reviewed-by: Bart Van Assche <bvanassche@acm.org>
Link: https://patch.msgid.link/ac17fdea58e384cb514c639306d48ce0005820b0.1766133330.git.u.kleine-koenig@baylibre.com
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Stable-dep-of: bb31844d88b7 ("scsi: sd: Fix special_vec mempool leak when scsi_alloc_sgtables() fails")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/ch.c          | 4 ++--
 drivers/scsi/scsi_sysfs.c  | 4 +++-
 drivers/scsi/sd.c          | 4 ++--
 drivers/scsi/ses.c         | 4 ++--
 drivers/scsi/sr.c          | 4 ++--
 drivers/scsi/st.c          | 4 ++--
 drivers/ufs/core/ufshcd.c  | 4 ++--
 include/scsi/scsi_driver.h | 4 ++--
 8 files changed, 17 insertions(+), 15 deletions(-)

diff --git a/drivers/scsi/ch.c b/drivers/scsi/ch.c
index fa07a6f54003e..f2b63e4b9b99e 100644
--- a/drivers/scsi/ch.c
+++ b/drivers/scsi/ch.c
@@ -1014,7 +1014,7 @@ static int __init init_ch_module(void)
 		       SCSI_CHANGER_MAJOR);
 		goto fail1;
 	}
-	rc = scsi_register_driver(&ch_template.gendrv);
+	rc = scsi_register_driver(&ch_template);
 	if (rc < 0)
 		goto fail2;
 	return 0;
@@ -1028,7 +1028,7 @@ static int __init init_ch_module(void)
 
 static void __exit exit_ch_module(void)
 {
-	scsi_unregister_driver(&ch_template.gendrv);
+	scsi_unregister_driver(&ch_template);
 	unregister_chrdev(SCSI_CHANGER_MAJOR, "ch");
 	class_unregister(&ch_sysfs_class);
 	idr_destroy(&ch_index_idr);
diff --git a/drivers/scsi/scsi_sysfs.c b/drivers/scsi/scsi_sysfs.c
index 15ba493d21386..f2d62f71c8af7 100644
--- a/drivers/scsi/scsi_sysfs.c
+++ b/drivers/scsi/scsi_sysfs.c
@@ -1609,8 +1609,10 @@ void scsi_remove_target(struct device *dev)
 }
 EXPORT_SYMBOL(scsi_remove_target);
 
-int __scsi_register_driver(struct device_driver *drv, struct module *owner)
+int __scsi_register_driver(struct scsi_driver *sdrv, struct module *owner)
 {
+	struct device_driver *drv = &sdrv->gendrv;
+
 	drv->bus = &scsi_bus_type;
 	drv->owner = owner;
 
diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index 41ad0e9101b8b..5d746645283d2 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -4375,7 +4375,7 @@ static int __init init_sd(void)
 		goto err_out_class;
 	}
 
-	err = scsi_register_driver(&sd_template.gendrv);
+	err = scsi_register_driver(&sd_template);
 	if (err)
 		goto err_out_driver;
 
@@ -4402,7 +4402,7 @@ static void __exit exit_sd(void)
 
 	SCSI_LOG_HLQUEUE(3, printk("exit_sd: exiting sd driver\n"));
 
-	scsi_unregister_driver(&sd_template.gendrv);
+	scsi_unregister_driver(&sd_template);
 	mempool_destroy(sd_page_pool);
 
 	class_unregister(&sd_disk_class);
diff --git a/drivers/scsi/ses.c b/drivers/scsi/ses.c
index 7e1f085ad350a..23d93cb110a6c 100644
--- a/drivers/scsi/ses.c
+++ b/drivers/scsi/ses.c
@@ -920,7 +920,7 @@ static int __init ses_init(void)
 	if (err)
 		return err;
 
-	err = scsi_register_driver(&ses_template.gendrv);
+	err = scsi_register_driver(&ses_template);
 	if (err)
 		goto out_unreg;
 
@@ -933,7 +933,7 @@ static int __init ses_init(void)
 
 static void __exit ses_exit(void)
 {
-	scsi_unregister_driver(&ses_template.gendrv);
+	scsi_unregister_driver(&ses_template);
 	scsi_unregister_interface(&ses_interface);
 }
 
diff --git a/drivers/scsi/sr.c b/drivers/scsi/sr.c
index 803fc9c132298..3b71fee9cf3c7 100644
--- a/drivers/scsi/sr.c
+++ b/drivers/scsi/sr.c
@@ -994,7 +994,7 @@ static int __init init_sr(void)
 	rc = register_blkdev(SCSI_CDROM_MAJOR, "sr");
 	if (rc)
 		return rc;
-	rc = scsi_register_driver(&sr_template.gendrv);
+	rc = scsi_register_driver(&sr_template);
 	if (rc)
 		unregister_blkdev(SCSI_CDROM_MAJOR, "sr");
 
@@ -1003,7 +1003,7 @@ static int __init init_sr(void)
 
 static void __exit exit_sr(void)
 {
-	scsi_unregister_driver(&sr_template.gendrv);
+	scsi_unregister_driver(&sr_template);
 	unregister_blkdev(SCSI_CDROM_MAJOR, "sr");
 }
 
diff --git a/drivers/scsi/st.c b/drivers/scsi/st.c
index 74a6830b7ed8e..83140b60f3fbe 100644
--- a/drivers/scsi/st.c
+++ b/drivers/scsi/st.c
@@ -4533,7 +4533,7 @@ static int __init init_st(void)
 		goto err_class;
 	}
 
-	err = scsi_register_driver(&st_template.gendrv);
+	err = scsi_register_driver(&st_template);
 	if (err)
 		goto err_chrdev;
 
@@ -4549,7 +4549,7 @@ static int __init init_st(void)
 
 static void __exit exit_st(void)
 {
-	scsi_unregister_driver(&st_template.gendrv);
+	scsi_unregister_driver(&st_template);
 	unregister_chrdev_region(MKDEV(SCSI_TAPE_MAJOR, 0),
 				 ST_MAX_TAPE_ENTRIES);
 	class_unregister(&st_sysfs_class);
diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index f0c7a8d7477c4..0d513d3b32453 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -11091,7 +11091,7 @@ static int __init ufshcd_core_init(void)
 
 	ufs_debugfs_init();
 
-	ret = scsi_register_driver(&ufs_dev_wlun_template.gendrv);
+	ret = scsi_register_driver(&ufs_dev_wlun_template);
 	if (ret)
 		ufs_debugfs_exit();
 	return ret;
@@ -11100,7 +11100,7 @@ static int __init ufshcd_core_init(void)
 static void __exit ufshcd_core_exit(void)
 {
 	ufs_debugfs_exit();
-	scsi_unregister_driver(&ufs_dev_wlun_template.gendrv);
+	scsi_unregister_driver(&ufs_dev_wlun_template);
 }
 
 module_init(ufshcd_core_init);
diff --git a/include/scsi/scsi_driver.h b/include/scsi/scsi_driver.h
index c0e89996bdb3f..40aba9a9349a6 100644
--- a/include/scsi/scsi_driver.h
+++ b/include/scsi/scsi_driver.h
@@ -25,9 +25,9 @@ struct scsi_driver {
 
 #define scsi_register_driver(drv) \
 	__scsi_register_driver(drv, THIS_MODULE)
-int __scsi_register_driver(struct device_driver *, struct module *);
+int __scsi_register_driver(struct scsi_driver *, struct module *);
 #define scsi_unregister_driver(drv) \
-	driver_unregister(drv);
+	driver_unregister(&(drv)->gendrv);
 
 extern int scsi_register_interface(struct class_interface *);
 #define scsi_unregister_interface(intf) \
-- 
2.53.0



