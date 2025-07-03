Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD92F2EA149;
	Thu,  3 Jul 2025 15:06:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751555182; cv=none; b=otnJA+ZpRCBymWBm9TVz7/qrM0iK7dSqGPdeNIlcYyzHZjHnfJRT7sLB7/g3EYjFDPYKBXuPqRAaJxbQZRapdiEjCoPMXCUFt2gMSotYvgj2aPZVI8HLL+UBH7x+e7k4IR97PtJRj88+n6qqdNY5ThVsIEIc597EnKOkRIj9hDY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751555182; c=relaxed/simple;
	bh=jJOEmXi1yKCco773zo5rx0FHQa9aF0RosEuZSx/wtTU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LXo3nCeFcPjE8pFhspS+7hI2HupH5VTb6GbDsvUByGcSP3BRmD1kFXpNcqR4+fq+evlUsfAq0VEDP8k2tapHPMcz18JWXwaY12GWspdFNUxXR/Xwnuz8sVVOHdkZJFcsLef0brcND8AvExW7k4SNdxxVY6f3RDyk3LJnKq26P8s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sTQs2w5S; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sTQs2w5S"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0D0AAC4CEE3;
	Thu,  3 Jul 2025 15:06:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751555181;
	bh=jJOEmXi1yKCco773zo5rx0FHQa9aF0RosEuZSx/wtTU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sTQs2w5SVShfc27g8AaBWeMKWgRXIZdi5gc/QgiyS5edHmmPRA3HMtB0iX5THeMF7
	 UR9g3yu9zTb3Sw698SbrAH+M641UMw3CF0aDs5mgwLLGXP2D/Wv66btbwPXgX3hTr/
	 sYjzxfa3YF9jqIR/fgkf7CVQBaEFVmzolSDCDC6c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sesidhar Baddela <sebaddel@cisco.com>,
	Arulprabhu Ponnusamy <arulponn@cisco.com>,
	Gian Carlo Boffa <gcboffa@cisco.com>,
	Arun Easi <aeasi@cisco.com>,
	Karan Tilak Kumar <kartilak@cisco.com>,
	John Meneghini <jmeneghi@redhat.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 6.15 201/263] scsi: fnic: Turn off FDMI ACTIVE flags on link down
Date: Thu,  3 Jul 2025 16:42:01 +0200
Message-ID: <20250703144012.427852211@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250703144004.276210867@linuxfoundation.org>
References: <20250703144004.276210867@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Karan Tilak Kumar <kartilak@cisco.com>

commit 74f46a0524f8d2f01dc7ca95bb5fc463a8603e72 upstream.

When the link goes down and comes up, FDMI requests are not sent out
anymore.

Fix bug by turning off FNIC_FDMI_ACTIVE when the link goes down.

Fixes: 09c1e6ab4ab2 ("scsi: fnic: Add and integrate support for FDMI")
Reviewed-by: Sesidhar Baddela <sebaddel@cisco.com>
Reviewed-by: Arulprabhu Ponnusamy <arulponn@cisco.com>
Reviewed-by: Gian Carlo Boffa <gcboffa@cisco.com>
Reviewed-by: Arun Easi <aeasi@cisco.com>
Tested-by: Karan Tilak Kumar <kartilak@cisco.com>
Cc: stable@vger.kernel.org
Signed-off-by: Karan Tilak Kumar <kartilak@cisco.com>
Link: https://lore.kernel.org/r/20250618003431.6314-2-kartilak@cisco.com
Reviewed-by: John Meneghini <jmeneghi@redhat.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/scsi/fnic/fdls_disc.c |    9 ++++++---
 drivers/scsi/fnic/fnic.h      |    2 +-
 2 files changed, 7 insertions(+), 4 deletions(-)

--- a/drivers/scsi/fnic/fdls_disc.c
+++ b/drivers/scsi/fnic/fdls_disc.c
@@ -5027,9 +5027,12 @@ void fnic_fdls_link_down(struct fnic_ipo
 		fdls_delete_tport(iport, tport);
 	}
 
-	if ((fnic_fdmi_support == 1) && (iport->fabric.fdmi_pending > 0)) {
-		timer_delete_sync(&iport->fabric.fdmi_timer);
-		iport->fabric.fdmi_pending = 0;
+	if (fnic_fdmi_support == 1) {
+		if (iport->fabric.fdmi_pending > 0) {
+			timer_delete_sync(&iport->fabric.fdmi_timer);
+			iport->fabric.fdmi_pending = 0;
+		}
+		iport->flags &= ~FNIC_FDMI_ACTIVE;
 	}
 
 	FNIC_FCS_DBG(KERN_INFO, fnic->host, fnic->fnic_num,
--- a/drivers/scsi/fnic/fnic.h
+++ b/drivers/scsi/fnic/fnic.h
@@ -30,7 +30,7 @@
 
 #define DRV_NAME		"fnic"
 #define DRV_DESCRIPTION		"Cisco FCoE HBA Driver"
-#define DRV_VERSION		"1.8.0.1"
+#define DRV_VERSION		"1.8.0.2"
 #define PFX			DRV_NAME ": "
 #define DFX                     DRV_NAME "%d: "
 


