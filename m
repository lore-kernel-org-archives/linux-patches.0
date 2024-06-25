Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7875F149E16;
	Tue, 25 Jun 2024 09:45:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719308707; cv=none; b=JhMLlo4Me20Qhnqk2UdNLa6hqgYqg491ufwBizM/EkYHxJLYGXpUIp7sGhMI9N7iu/5P9wnYDuRVpQ+9OKcIRW22lcfutuFjLC/rPpvEcH6dwHmzyUXRTlFtVTvP3if8Cfgdk/etm5jDD9kgPN5+QV1dsJiItpgV0sxW73WH8rM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719308707; c=relaxed/simple;
	bh=J+Vm8a0wNISBTPr+yxkgJji+V8n2HxEtLMdrEU2Gk/E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DSYbTuBNgcQTa+BlR8Ua9tb8n9JkotwlCctdNjPUhpjJry2DYkFraYRRD1uMC/RDiZuNynroXbtrMW3nBX8WVjHP8nHjtF//3A2u6qbgRtCWxEduFy2PxUJHmmpjtpTqeadV1YDZeBx0YwIXlCAv0luBSifCSfkEM2YmE56Q1L8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eTkkGM/N; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eTkkGM/N"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A3495C32781;
	Tue, 25 Jun 2024 09:45:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1719308707;
	bh=J+Vm8a0wNISBTPr+yxkgJji+V8n2HxEtLMdrEU2Gk/E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=eTkkGM/NA2HDuMQ+MaBKgZiWICCBLm5PmR6uaM3t+yGKtDdTcug5HlF8DfSpAyHEv
	 Iday/FSXI0CY5emRpp8ENnGxU19XlKPA4VnSfOtWS41wc/yEI8yg3EUfPCJ47XAWPr
	 U0AlhKCP91BCPugJ4necJLXaPOHL4/mrR5gDVHSs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alan Stern <stern@rowland.harvard.edu>,
	Joao Machado <jocrismachado@gmail.com>,
	Andy Shevchenko <andy.shevchenko@gmail.com>,
	Bart Van Assche <bvanassche@acm.org>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Christian Heusel <christian@heusel.eu>
Subject: [PATCH 6.9 213/250] scsi: usb: uas: Do not query the IO Advice Hints Grouping mode page for USB/UAS devices
Date: Tue, 25 Jun 2024 11:32:51 +0200
Message-ID: <20240625085556.230908515@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240625085548.033507125@linuxfoundation.org>
References: <20240625085548.033507125@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Bart Van Assche <bvanassche@acm.org>

commit 57619f3cdeb5ae9f4252833b0ed600e9f81da722 upstream.

Recently it was reported that the following USB storage devices are
unusable with Linux kernel 6.9:

 * Kingston DataTraveler G2
 * Garmin FR35

This is because attempting to read the IO Advice Hints Grouping mode page
causes these devices to reset. Hence do not read the IO Advice Hints
Grouping mode page from USB/UAS storage devices.

Acked-by: Alan Stern <stern@rowland.harvard.edu>
Cc: stable@vger.kernel.org
Fixes: 4f53138fffc2 ("scsi: sd: Translate data lifetime information")
Reported-by: Joao Machado <jocrismachado@gmail.com>
Closes: https://lore.kernel.org/linux-scsi/20240130214911.1863909-1-bvanassche@acm.org/T/#mf4e3410d8f210454d7e4c3d1fb5c0f41e651b85f
Tested-by: Andy Shevchenko <andy.shevchenko@gmail.com>
Bisected-by: Christian Heusel <christian@heusel.eu>
Reported-by: Andy Shevchenko <andy.shevchenko@gmail.com>
Closes: https://lore.kernel.org/linux-scsi/CACLx9VdpUanftfPo2jVAqXdcWe8Y43MsDeZmMPooTzVaVJAh2w@mail.gmail.com/
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
Link: https://lore.kernel.org/r/20240613211828.2077477-3-bvanassche@acm.org
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/storage/scsiglue.c |    6 ++++++
 drivers/usb/storage/uas.c      |    7 +++++++
 2 files changed, 13 insertions(+)

--- a/drivers/usb/storage/scsiglue.c
+++ b/drivers/usb/storage/scsiglue.c
@@ -86,6 +86,12 @@ static int slave_alloc (struct scsi_devi
 	if (us->protocol == USB_PR_BULK && us->max_lun > 0)
 		sdev->sdev_bflags |= BLIST_FORCELUN;
 
+	/*
+	 * Some USB storage devices reset if the IO advice hints grouping mode
+	 * page is queried. Hence skip that mode page.
+	 */
+	sdev->sdev_bflags |= BLIST_SKIP_IO_HINTS;
+
 	return 0;
 }
 
--- a/drivers/usb/storage/uas.c
+++ b/drivers/usb/storage/uas.c
@@ -21,6 +21,7 @@
 #include <scsi/scsi.h>
 #include <scsi/scsi_eh.h>
 #include <scsi/scsi_dbg.h>
+#include <scsi/scsi_devinfo.h>
 #include <scsi/scsi_cmnd.h>
 #include <scsi/scsi_device.h>
 #include <scsi/scsi_host.h>
@@ -820,6 +821,12 @@ static int uas_slave_alloc(struct scsi_d
 	struct uas_dev_info *devinfo =
 		(struct uas_dev_info *)sdev->host->hostdata;
 
+	/*
+	 * Some USB storage devices reset if the IO advice hints grouping mode
+	 * page is queried. Hence skip that mode page.
+	 */
+	sdev->sdev_bflags |= BLIST_SKIP_IO_HINTS;
+
 	sdev->hostdata = devinfo;
 
 	/*


