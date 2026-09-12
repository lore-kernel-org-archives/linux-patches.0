Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C4E0B41A4E7;
	Sat, 12 Sep 2026 10:51:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789210289; cv=none; b=gOz0ebcD9uYFZTFQqEDQ4lAu2f6zQZ6IYAJ/sgxNI6c2kznLvN13oHCqci8t8zlZmlEY6DQtsebzEQ8EF3PuXZxLTYtI6BjceCwqkH2CMk0gBhAvDEONWE2e9S1dlHbFvHLE/2Ns/i2Vg7WExt4hzlqgt239tCVCFxZU8MLO3B8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789210289; c=relaxed/simple;
	bh=9gC79QyCvN/U8QxCqtS10aMPM8Fkzst7A5eNFeu7lUM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Y0SDAK6L5moxEy9Nu6TcD1XR89iZR6LoWRYiB06khFDUkgquELGg4ZqK9w0tUuNugbpHNLGrpMNnJ8woOG737BsTkVVNIC+yw7nt+W14YC+f/CjtrSznIGoakUW5Ad5THSwNJyNGPCD9o3bKYTX9ejFJDGehvFdcqeIzdsxahaA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fhlpZ5sR; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fhlpZ5sR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 832C11F00893;
	Sat, 12 Sep 2026 10:51:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789210287;
	bh=4nCpCtt93ZRAaTaQfiSN4VEGX8pQouDrny01neqhUhs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=fhlpZ5sRjtigiUPVIGW7Ob8zTguOMLpDoZykDGIZeOSToLu3GxoAmD8SUVdPZnjms
	 bYg/TaazTZEPbO5wJHseIoM4rrwgQeGZaUxMfn4DS7yLTCd1SiNyCMvFc+gS78zLCv
	 6senbpM0myqBklhbcq8n246O/l9fz3sWTeJ45lUo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Damien Le Moal <dlemoal@kernel.org>,
	Himanshu Madhani <himanshu.madhani@oracle.com>,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>,
	Bart Van Assche <bvanassche@acm.org>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0994/1518] scsi: sd: Move the sd_remove() function definition
Date: Sat, 12 Sep 2026 08:52:43 +0200
Message-ID: <20260912065645.942916330@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065623.398859879@linuxfoundation.org>
References: <20260912065623.398859879@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Bart Van Assche <bvanassche@acm.org>

[ Upstream commit 4f39a4870a59971797be86fed72423b83b6b4e00 ]

Move the sd_remove() function definition such that the sd_shutdown()
forward declaration can be removed.

Reviewed-by: Damien Le Moal <dlemoal@kernel.org>
Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>
Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
Link: https://patch.msgid.link/20260114175054.4118163-2-bvanassche@acm.org
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Stable-dep-of: bb31844d88b7 ("scsi: sd: Fix special_vec mempool leak when scsi_alloc_sgtables() fails")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/sd.c | 53 +++++++++++++++++++++++------------------------
 1 file changed, 26 insertions(+), 27 deletions(-)

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index 1dd6fbc5e1674..8ecf5a4781741 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -108,7 +108,6 @@ static void sd_config_write_same(struct scsi_disk *sdkp,
 		struct queue_limits *lim);
 static void  sd_revalidate_disk(struct gendisk *);
 static void sd_unlock_native_capacity(struct gendisk *disk);
-static void sd_shutdown(struct scsi_device *);
 static void scsi_disk_release(struct device *cdev);
 
 static DEFINE_IDA(sd_index_ida);
@@ -4047,32 +4046,6 @@ static int sd_probe(struct scsi_device *sdp)
 	return error;
 }
 
-/**
- *	sd_remove - called whenever a scsi disk (previously recognized by
- *	sd_probe) is detached from the system. It is called (potentially
- *	multiple times) during sd module unload.
- *	@sdp: pointer to device object
- *
- *	Note: this function is invoked from the scsi mid-level.
- *	This function potentially frees up a device name (e.g. /dev/sdc)
- *	that could be re-used by a subsequent sd_probe().
- *	This function is not called when the built-in sd driver is "exit-ed".
- **/
-static void sd_remove(struct scsi_device *sdp)
-{
-	struct device *dev = &sdp->sdev_gendev;
-	struct scsi_disk *sdkp = dev_get_drvdata(dev);
-
-	scsi_autopm_get_device(sdkp->device);
-
-	device_del(&sdkp->disk_dev);
-	del_gendisk(sdkp->disk);
-	if (!sdkp->suspended)
-		sd_shutdown(sdp);
-
-	put_disk(sdkp->disk);
-}
-
 static void scsi_disk_release(struct device *dev)
 {
 	struct scsi_disk *sdkp = to_scsi_disk(dev);
@@ -4184,6 +4157,32 @@ static void sd_shutdown(struct scsi_device *sdp)
 	}
 }
 
+/**
+ *	sd_remove - called whenever a scsi disk (previously recognized by
+ *	sd_probe) is detached from the system. It is called (potentially
+ *	multiple times) during sd module unload.
+ *	@sdp: pointer to device object
+ *
+ *	Note: this function is invoked from the scsi mid-level.
+ *	This function potentially frees up a device name (e.g. /dev/sdc)
+ *	that could be re-used by a subsequent sd_probe().
+ *	This function is not called when the built-in sd driver is "exit-ed".
+ **/
+static void sd_remove(struct scsi_device *sdp)
+{
+	struct device *dev = &sdp->sdev_gendev;
+	struct scsi_disk *sdkp = dev_get_drvdata(dev);
+
+	scsi_autopm_get_device(sdkp->device);
+
+	device_del(&sdkp->disk_dev);
+	del_gendisk(sdkp->disk);
+	if (!sdkp->suspended)
+		sd_shutdown(sdp);
+
+	put_disk(sdkp->disk);
+}
+
 static inline bool sd_do_start_stop(struct scsi_device *sdev, bool runtime)
 {
 	return (sdev->manage_system_start_stop && !runtime) ||
-- 
2.53.0



