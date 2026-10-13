Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 616E14F30E3;
	Tue, 13 Oct 2026 12:21:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791894063; cv=none; b=RPxxGs+GZIIIaUZozcksVF/TNdHDXWihXMVcAUufBOU3ylxhMY7WR49Xci+erVzr5vO/CTUEi5PfaQ1ixrPh9OyvOYAQLo7c0i2XTEcTog1ZQXVjtufEVMUbhqHmHHvQZ30SBPvaQDkW8AT6BO9SDWbTW3w/n1Yfd9Z2LRxoSvQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791894063; c=relaxed/simple;
	bh=2VPfALVTLWA9fdFX8O8a/UQKfJ48hihIgjQ9eZr9NrM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dUayCD+xFd41E/hjmulR3vftjgYTseF0iPvb8WvkqI1Xjh/Rn17AvBGAm7PxViCJe6Bqu38fjDKq5UaftgPugwcKmfIPQFiVbj9JYdL8mWF3odiF8ChlM0cTtVq8nbWlDl/L0BexYFFsRHXvQZSkeDtGN+GK669cKEQhJJQnnlY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qO9/UC60; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qO9/UC60"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7966B1F000FF;
	Tue, 13 Oct 2026 12:21:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791894062;
	bh=0izPyrmWvdHWZw8XHzjJwS5vq0lFabmBhHfGT22Tnb0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=qO9/UC60VSa4/8jeOr1WEjzCFMuk+4E7wjTMP0XfSMnyD62f4/IslxF7iplptydpq
	 Vd6giJN5FBESSwHYUVhVqMQGol4YYd/FhIIGdXd7Qpc+h4eNt9IPA7HL/u2tas2+fb
	 nEffV+rMOJDV4LXnUq1lGA41nBZ+lf72rYLGkOcQ=
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
Subject: [PATCH 6.18 432/621] scsi: sd: Move the sd_remove() function definition
Date: Tue, 13 Oct 2026 13:37:07 +0200
Message-ID: <20261013112931.087200463@linuxfoundation.org>
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
index 66fb3dd18f4b9..a9fcccb16d9e5 100644
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



