Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795054885;
	b=s4lwEZY4eEgY28GnIXuDXxCSJ592OlQwwp3Rx++NI9enuR8lTwHbMv2/wA+aSCF0G2+h
	 XO8Jow1SUlIKuWyv3reg7DWEV9w5ri6YXoCOFpy2XYGiwka7ndYDtt31pqHif/BPV1g6L
	 v2Xb6pZnF/frcwFUUNd/Rb8t1jpnrH3IkdKNKtjpxWb+StuH4GDppVpHP1+NCZmbybjin
	 ldfZKPaHmW+9IHliGkfJb0A1R87k2JraYZB+whf0TDCbV8NHCSZilteIA+0cxewLL+aPJ
	 VQR6YMlLa0qztsCRofMdDV+Gjc/v5lkveFSoFGqweVyHNFkO/W9cvPjMxLPEsWwK5xw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795054885;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Vc1m20u/pR2BVIEyrpnKQHBTNC+uYrlp3uM66Q8gWvk=;
	b=q1DEhXVEv2G+bhAFWqG8FItzMOv8wlqPuQyTxuKyXvA9D2pAhzm3GtqPQm56rpkUfjdk
	 Yya2wk0eFPFywA7YO5PirxfY8qZVvRqdLz6Mgx9mhyFrXv5z0E+NznoiYJYv7dEtkp2kd
	 Qyr8OLc6/xyYSa7z1We5QEeZ+at/zSuxbq65obIM/t/AozCGBnxf/GMXikgS7baBxEJgM
	 m48D+KHLtA7Skf5WnIc/+TetKdwDR2Td6hUnJyDxl8lCwaojJ7oRJ5TpC2VfQXbU8T2AC
	 kJJS+VpoGlRQq7v5XIshk++Oovc5Q7tokffeZECaDTUnoiqRmamZjFcCoHRwERTsyiA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=lnJMaynX;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F14C1606A31C;
	Thu, 19 Nov 2026 02:21:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=lnJMaynX
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4E4351F000C4;
	Thu, 19 Nov 2026 02:21:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795054884;
	bh=Vc1m20u/pR2BVIEyrpnKQHBTNC+uYrlp3uM66Q8gWvk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=lnJMaynXpEnD6oQ/0eTCCyNgZ/DVubDgNoV+OkqvTJz2TqIe25eBSk6fb57eW8yFu
	 3SNq9bjRXJEVTfGdxADwPI/I7gLSrukw5ZL/SGd6s5M/6k+b6tWUh4dxoc7kWWcwuN
	 qC3/rsIm4roYYx285zUzWmu6+9zoaNm6smUouctM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sreekanth Reddy <sreekanth.reddy@broadcom.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 1435/2214] scsi: mpi3mr: Add IOC reinit function
Date: Wed, 18 Nov 2026 15:51:51 +0100
Message-ID: <20261118150108.579821625@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sreekanth Reddy <sreekanth.reddy@broadcom.com>

[ Upstream commit c0b00a931e5e5fc143ed5563389ef72e40de9814 ]

Add IOC reinitialization function.

Link: https://lore.kernel.org/r/20211220141159.16117-16-sreekanth.reddy@broadcom.com
Signed-off-by: Sreekanth Reddy <sreekanth.reddy@broadcom.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Stable-dep-of: bcf0a5bed59a ("scsi: mpi3mr: Fix out-of-bounds reply frame access")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/mpi3mr/mpi3mr_fw.c | 116 +++++++++++++++++++++++++++++++-
 1 file changed, 115 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/mpi3mr/mpi3mr_fw.c b/drivers/scsi/mpi3mr/mpi3mr_fw.c
index 7da0029a9ae1a..3b978fe2484a6 100644
--- a/drivers/scsi/mpi3mr/mpi3mr_fw.c
+++ b/drivers/scsi/mpi3mr/mpi3mr_fw.c
@@ -3579,10 +3579,124 @@ int mpi3mr_init_ioc(struct mpi3mr_ioc *mrioc)
 	return retval;
 }
 
+/**
+ * mpi3mr_reinit_ioc - Re-Initialize the controller
+ * @mrioc: Adapter instance reference
+ * @is_resume: Called from resume or reset path
+ *
+ * This the controller re-initialization routine, executed from
+ * the soft reset handler or resume callback. Creates
+ * operational reply queue pairs, allocate required memory for
+ * reply pool, sense buffer pool, issue IOC init request to the
+ * firmware, unmask the events and issue port enable to discover
+ * SAS/SATA/NVMe devices and RAID volumes.
+ *
+ * Return: 0 on success and non-zero on failure.
+ */
 int mpi3mr_reinit_ioc(struct mpi3mr_ioc *mrioc, u8 is_resume)
 {
+	int retval = 0;
+	u8 retry = 0;
+	struct mpi3_ioc_facts_data facts_data;
 
-	return 0;
+retry_init:
+	dprint_reset(mrioc, "bringing up the controller to ready state\n");
+	retval = mpi3mr_bring_ioc_ready(mrioc);
+	if (retval) {
+		ioc_err(mrioc, "failed to bring to ready state\n");
+		goto out_failed_noretry;
+	}
+
+	if (is_resume) {
+		dprint_reset(mrioc, "setting up single ISR\n");
+		retval = mpi3mr_setup_isr(mrioc, 1);
+		if (retval) {
+			ioc_err(mrioc, "failed to setup ISR\n");
+			goto out_failed_noretry;
+		}
+	} else
+		mpi3mr_ioc_enable_intr(mrioc);
+
+	dprint_reset(mrioc, "getting ioc_facts\n");
+	retval = mpi3mr_issue_iocfacts(mrioc, &facts_data);
+	if (retval) {
+		ioc_err(mrioc, "failed to get ioc_facts\n");
+		goto out_failed;
+	}
+
+	mpi3mr_process_factsdata(mrioc, &facts_data);
+
+	mpi3mr_print_ioc_info(mrioc);
+
+	dprint_reset(mrioc, "sending ioc_init\n");
+	retval = mpi3mr_issue_iocinit(mrioc);
+	if (retval) {
+		ioc_err(mrioc, "failed to send ioc_init\n");
+		goto out_failed;
+	}
+
+	dprint_reset(mrioc, "getting package version\n");
+	retval = mpi3mr_print_pkg_ver(mrioc);
+	if (retval) {
+		ioc_err(mrioc, "failed to get package version\n");
+		goto out_failed;
+	}
+
+	if (is_resume) {
+		dprint_reset(mrioc, "setting up multiple ISR\n");
+		retval = mpi3mr_setup_isr(mrioc, 0);
+		if (retval) {
+			ioc_err(mrioc, "failed to re-setup ISR\n");
+			goto out_failed_noretry;
+		}
+	}
+
+	dprint_reset(mrioc, "creating operational queue pairs\n");
+	retval = mpi3mr_create_op_queues(mrioc);
+	if (retval) {
+		ioc_err(mrioc, "failed to create operational queue pairs\n");
+		goto out_failed;
+	}
+
+	if (mrioc->shost->nr_hw_queues > mrioc->num_op_reply_q) {
+		ioc_err(mrioc,
+		    "cannot create minimum number of operatioanl queues expected:%d created:%d\n",
+		    mrioc->shost->nr_hw_queues, mrioc->num_op_reply_q);
+		goto out_failed_noretry;
+	}
+
+	dprint_reset(mrioc, "enabling events\n");
+	retval = mpi3mr_enable_events(mrioc);
+	if (retval) {
+		ioc_err(mrioc, "failed to enable events\n");
+		goto out_failed;
+	}
+
+	ioc_info(mrioc, "sending port enable\n");
+	retval = mpi3mr_issue_port_enable(mrioc, 0);
+	if (retval) {
+		ioc_err(mrioc, "failed to issue port enable\n");
+		goto out_failed;
+	}
+
+	ioc_info(mrioc, "controller %s completed successfully\n",
+	    (is_resume)?"resume":"re-initialization");
+	return retval;
+out_failed:
+	if (retry < 2) {
+		retry++;
+		ioc_warn(mrioc, "retrying controller %s, retry_count:%d\n",
+		    (is_resume)?"resume":"re-initialization", retry);
+		mpi3mr_memset_buffers(mrioc);
+		goto retry_init;
+	}
+out_failed_noretry:
+	ioc_err(mrioc, "controller %s is failed\n",
+	    (is_resume)?"resume":"re-initialization");
+	mpi3mr_issue_reset(mrioc, MPI3_SYSIF_HOST_DIAG_RESET_ACTION_DIAG_FAULT,
+	    MPI3MR_RESET_FROM_CTLR_CLEANUP);
+	mrioc->unrecoverable = 1;
+	return retval;
 }
 
 /**
-- 
2.53.0



