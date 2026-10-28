Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793214082;
	b=mpGmhxQcaepmr6eslJUnExINKNxASheNvHSZ603UffMG3a9UHVReSsH3jXy+xcllSrzL
	 HwJk8a094kcNjhTNqh1JmPI/gFQQHsxQ9jktd1B4Q1OAkskE3PNLtEykseQxQ4U3zA6pj
	 4Vbn+Vu0wg5QiOP2h9OxMVzpgWcLNFQMB9aX5rRxH6mSa0EupB3ipxF+HeTFLu+WF5I3+
	 a15fLSPmz/GBruGWpbbc2aRtNTtoqOT4OAY6j5Hyw5fVu+dpXKR/clvJPo26CQTC+B9nd
	 1/Bl3Pp/4rAuO2EUgwvXokHRhTCCQKGr8KsoyZCCJIadGPynN4sGIedFPwSY9VlyAlw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793214082;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=bGWeQYuUMKbXUhaznK9SNXb79QJDCKei/mUBd9sqLAc=;
	b=Edf9DpU6NIR7WexHmuv4xrjIFfJ0s0wyPpZc9+4meAXFUC+Ve36ILa+Q02mS1ZsK+0+L
	 IYqlQ3bDGexypJ5Y63NRRziMoSNpLdmKwogdoev6qIYyKQjPtJOuC9l/wxUeENq72xJcL
	 RIYq1/HjqyCHcTp80KEXY7z4vAwpdz+nybpw10yJNBDjaF9rjdPAHkAohS1EvBwaZJkKG
	 FqWF5hDx01D4iqvKenq7iaR1l5S44/rFWwgxVez8M73Op6MF/9T6d4oFp7zYd90J9P9Ig
	 uaBQCKOat8ImpOCpsheZAS3R5BWp0YLs28tu9o5ApBMm2CJ+xQCD5+MyIwnvSluvzvg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=KaSZEaiz;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A584606A31C;
	Wed, 28 Oct 2026 19:01:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=KaSZEaiz
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A9D0F1F01825;
	Wed, 28 Oct 2026 19:01:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793214082;
	bh=bGWeQYuUMKbXUhaznK9SNXb79QJDCKei/mUBd9sqLAc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=KaSZEaizZq0miIjMhQ4/ssNt8dXvEBCjpBXb/jS20lQLgQsxAWjW4PdywBbCURzjg
	 gzRzsVtdlCxOmQ70/KRs5ptx6iTw2e8/1Ze+GRRhEgPedbe4lDNzA5Nts/poJeiuJ/
	 LEERNK0OBHXkfNQohB7RsOBvwaIB61UOVXW3lg9E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guixin Liu <kanie@linux.alibaba.com>,
	Bart Van Assche <bvanassche@acm.org>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0734/1887] scsi: mpi3mr: Fix possible crash when setting up bsg fails
Date: Wed, 28 Oct 2026 17:47:10 +0100
Message-ID: <20261028170516.152058997@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
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

From: Guixin Liu <kanie@linux.alibaba.com>

[ Upstream commit 295006f6e8c17212d3098811166e29627d19e05c ]

If bsg_setup_queue() fails, the bsg_queue is assigned a non-NULL value.
Consequently, in mpi3mr_bsg_exit(), the condition "if(!mrioc->bsg_queue)"
will not be satisfied, preventing execution from entering
bsg_remove_queue(), which could lead to the following crash:

BUG: kernel NULL pointer dereference, address: 000000000000041c
Call Trace:
  <TASK>
  mpi3mr_bsg_exit+0x1f/0x50 [mpi3mr]
  mpi3mr_remove+0x6f/0x340 [mpi3mr]
  pci_device_remove+0x3f/0xb0
  device_release_driver_internal+0x19d/0x220
  unbind_store+0xa4/0xb0
  kernfs_fop_write_iter+0x11f/0x200
  vfs_write+0x1fc/0x3e0
  ksys_write+0x67/0xe0
  do_syscall_64+0x38/0x80
  entry_SYSCALL_64_after_hwframe+0x78/0xe2

Fixes: 4268fa751365 ("scsi: mpi3mr: Add bsg device support")
Signed-off-by: Guixin Liu <kanie@linux.alibaba.com>
Link: https://lore.kernel.org/r/20250107022032.24006-1-kanie@linux.alibaba.com
Reviewed-by: Bart Van Assche <bvanassche@acm.org>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/mpi3mr/mpi3mr_app.c | 11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/mpi3mr/mpi3mr_app.c b/drivers/scsi/mpi3mr/mpi3mr_app.c
index c77803bd9b009..28f19209c58db 100644
--- a/drivers/scsi/mpi3mr/mpi3mr_app.c
+++ b/drivers/scsi/mpi3mr/mpi3mr_app.c
@@ -1531,6 +1531,7 @@ void mpi3mr_bsg_init(struct mpi3mr_ioc *mrioc)
 {
 	struct device *bsg_dev = &mrioc->bsg_dev;
 	struct device *parent = &mrioc->shost->shost_gendev;
+	struct request_queue *q;
 
 	device_initialize(bsg_dev);
 
@@ -1546,9 +1547,9 @@ void mpi3mr_bsg_init(struct mpi3mr_ioc *mrioc)
 		return;
 	}
 
-	mrioc->bsg_queue = bsg_setup_queue(bsg_dev, dev_name(bsg_dev),
+	q = bsg_setup_queue(bsg_dev, dev_name(bsg_dev),
 			mpi3mr_bsg_request, NULL, 0);
-	if (IS_ERR(mrioc->bsg_queue)) {
+	if (IS_ERR(q)) {
 		ioc_err(mrioc, "%s: bsg registration failed\n",
 		    dev_name(bsg_dev));
 		device_del(bsg_dev);
@@ -1556,8 +1557,10 @@ void mpi3mr_bsg_init(struct mpi3mr_ioc *mrioc)
 		return;
 	}
 
-	blk_queue_max_segments(mrioc->bsg_queue, MPI3MR_MAX_APP_XFER_SEGMENTS);
-	blk_queue_max_hw_sectors(mrioc->bsg_queue, MPI3MR_MAX_APP_XFER_SECTORS);
+	mrioc->bsg_queue = q;
+
+	blk_queue_max_segments(q, MPI3MR_MAX_APP_XFER_SEGMENTS);
+	blk_queue_max_hw_sectors(q, MPI3MR_MAX_APP_XFER_SECTORS);
 
 	return;
 }
-- 
2.53.0



