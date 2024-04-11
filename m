Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA1351474B0;
	Thu, 11 Apr 2024 10:48:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712832519; cv=none; b=QHWFsILWqH1nL2jgEjc4k9B+CCkeADPlPjUkU1ytyjZ1aBfyp7ceaVv5XtKR3uER/tP0jtj+WqXmlef+uXZAjTrBwAvjnBEir9qWnssHfCoAwg3MA69GjbaKUISoyF7JbafbPuHuJ3J6rqkA5Blvz7iBcwNxd7jjFdzuLJ//dEE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712832519; c=relaxed/simple;
	bh=uDuSZP8ckE0HwmMDzMCjrSGp0jTj+zzfk92sspC6zdI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jI7GTZDH+Z1h7AJ0ws3ApawT69Fb1di0qWjt6SVympK4aYBoTLhKEems7EtAd66f7UB3qKCHhREeTc9i5jy/t5Uh+5SZk4swLSTus1DpO6aGtu7O5GkgmuaMVgFVPmoXUttaeH4b23y/zpc+9UfohE3K1CvVKS5lm8d+mZbuAkE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MVAGABWz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MVAGABWz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3ED2AC433C7;
	Thu, 11 Apr 2024 10:48:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712832519;
	bh=uDuSZP8ckE0HwmMDzMCjrSGp0jTj+zzfk92sspC6zdI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MVAGABWzWzFM29YuQK/rdOo7kdVzptG7VMDMIE5zF0ZtZk/sfy7O/XJdXGvzzbe0K
	 fvLuvWIxL/Jxlku5Btk6dYd3qnnC3c3hNtIGZHBvVyEcUsKYHv4upFlNR48JgcWbrW
	 4enVFSA/KaTUeN+OdQ5xUulTIN+An6C5SsmJoM9s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tasos Sahanidis <tasos@tasossah.com>,
	"Ewan D. Milne" <emilne@redhat.com>,
	Bart Van Assche <bvanassche@acm.org>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	James Bottomley <jejb@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>,
	John David Anglin <dave.anglin@bell.net>,
	Cyril Brulebois <kibi@debian.org>
Subject: [PATCH 6.1 74/83] Revert "scsi: sd: usb_storage: uas: Access media prior to querying device properties"
Date: Thu, 11 Apr 2024 11:57:46 +0200
Message-ID: <20240411095414.915492760@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240411095412.671665933@linuxfoundation.org>
References: <20240411095412.671665933@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

This reverts commit b73dd5f9997279715cd450ee8ca599aaff2eabb9 which is
commit 321da3dc1f3c92a12e3c5da934090d2992a8814c upstream.

It is known to cause problems and has asked to be dropped.

Link: https://lore.kernel.org/r/yq1frvvpymp.fsf@ca-mkp.ca.oracle.com
Cc: Tasos Sahanidis <tasos@tasossah.com>
Cc: Ewan D. Milne <emilne@redhat.com>
Cc: Bart Van Assche <bvanassche@acm.org>
Cc: Tasos Sahanidis <tasos@tasossah.com>
Cc: Martin K. Petersen <martin.petersen@oracle.com>
Cc: James Bottomley <jejb@linux.ibm.com>
Cc: Sasha Levin <sashal@kernel.org>
Reported-by: John David Anglin <dave.anglin@bell.net>
Reported-by: Cyril Brulebois <kibi@debian.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/scsi/sd.c              |   26 +-------------------------
 drivers/usb/storage/scsiglue.c |    7 -------
 drivers/usb/storage/uas.c      |    7 -------
 include/scsi/scsi_device.h     |    1 -
 4 files changed, 1 insertion(+), 40 deletions(-)

--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -3286,24 +3286,6 @@ static bool sd_validate_opt_xfer_size(st
 	return true;
 }
 
-static void sd_read_block_zero(struct scsi_disk *sdkp)
-{
-	unsigned int buf_len = sdkp->device->sector_size;
-	char *buffer, cmd[10] = { };
-
-	buffer = kmalloc(buf_len, GFP_KERNEL);
-	if (!buffer)
-		return;
-
-	cmd[0] = READ_10;
-	put_unaligned_be32(0, &cmd[2]); /* Logical block address 0 */
-	put_unaligned_be16(1, &cmd[7]);	/* Transfer 1 logical block */
-
-	scsi_execute_cmd(sdkp->device, cmd, REQ_OP_DRV_IN, buffer, buf_len,
-			 SD_TIMEOUT, sdkp->max_retries, NULL);
-	kfree(buffer);
-}
-
 /**
  *	sd_revalidate_disk - called the first time a new disk is seen,
  *	performs disk spin up, read_capacity, etc.
@@ -3343,13 +3325,7 @@ static int sd_revalidate_disk(struct gen
 	 */
 	if (sdkp->media_present) {
 		sd_read_capacity(sdkp, buffer);
-		/*
-		 * Some USB/UAS devices return generic values for mode pages
-		 * until the media has been accessed. Trigger a READ operation
-		 * to force the device to populate mode pages.
-		 */
-		if (sdp->read_before_ms)
-			sd_read_block_zero(sdkp);
+
 		/*
 		 * set the default to rotational.  All non-rotational devices
 		 * support the block characteristics VPD page, which will
--- a/drivers/usb/storage/scsiglue.c
+++ b/drivers/usb/storage/scsiglue.c
@@ -180,13 +180,6 @@ static int slave_configure(struct scsi_d
 		sdev->use_192_bytes_for_3f = 1;
 
 		/*
-		 * Some devices report generic values until the media has been
-		 * accessed. Force a READ(10) prior to querying device
-		 * characteristics.
-		 */
-		sdev->read_before_ms = 1;
-
-		/*
 		 * Some devices don't like MODE SENSE with page=0x3f,
 		 * which is the command used for checking if a device
 		 * is write-protected.  Now that we tell the sd driver
--- a/drivers/usb/storage/uas.c
+++ b/drivers/usb/storage/uas.c
@@ -877,13 +877,6 @@ static int uas_slave_configure(struct sc
 		sdev->guess_capacity = 1;
 
 	/*
-	 * Some devices report generic values until the media has been
-	 * accessed. Force a READ(10) prior to querying device
-	 * characteristics.
-	 */
-	sdev->read_before_ms = 1;
-
-	/*
 	 * Some devices don't like MODE SENSE with page=0x3f,
 	 * which is the command used for checking if a device
 	 * is write-protected.  Now that we tell the sd driver
--- a/include/scsi/scsi_device.h
+++ b/include/scsi/scsi_device.h
@@ -204,7 +204,6 @@ struct scsi_device {
 	unsigned use_10_for_rw:1; /* first try 10-byte read / write */
 	unsigned use_10_for_ms:1; /* first try 10-byte mode sense/select */
 	unsigned set_dbd_for_ms:1; /* Set "DBD" field in mode sense */
-	unsigned read_before_ms:1;	/* perform a READ before MODE SENSE */
 	unsigned no_report_opcodes:1;	/* no REPORT SUPPORTED OPERATION CODES */
 	unsigned no_write_same:1;	/* no WRITE SAME command */
 	unsigned use_16_for_rw:1; /* Use read/write(16) over read/write(10) */


