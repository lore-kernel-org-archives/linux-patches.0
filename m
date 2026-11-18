Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795054874;
	b=GxR52OeDBQn4w/ty3qGNBNLpofySR79IJW58kAP5geEk4UWIwJ7S8ET8nBKM0a6JFVdh
	 pEedSCks8zeRUeD1BIyrQxcY+KcMQYFYswkNjs+0pZ5svM4SNO2seS8UajkVRTtxfcc/M
	 me9/gjumniqTvpI2NzDPg0emR/LlyP4H1ztuXFitsN4I/WEsmExv4MOCd17L5TJy3DsYV
	 XXt/IpmHquUw0sZuWKh//wjMWGOLjqpt1vET4vDsKqJy0VlTRpwjfvCcmjLesW9f1bFY3
	 9mDd/Z8wBxudSDEae5/kTwQwjs/4HgP4DGD2SSpK4BD3mO2k57g1iQOJqvSQ14tP2WA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795054874;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Ao00P0YOstmhpYI2z0+lWFdnQLmkoQehDnUfEBX0bZM=;
	b=eJ5zlj5Ta1KoN8RiSJc7mH6TqRtWv93OvC3yzVNPOA70HPqP7h5KfLQEJZWyThTljrOm
	 SnNDy65DkEJi2k9xWCmPqeFN/E5sgUkkom5LtNFQUycDFoWwYwswStwEnjeL0B5FfJJNn
	 8TUWCJHh4lwFeCKlF9yWQW/XlATpexU7zVQ2NuEfRQraEKdDmFfL14dpCS6Qxn3D8lBqR
	 14BNoa9uMI77opDOV5MWtLkXSnlqrhRCnGfqHryZPzuSNCwifxsGqEXI9EmEIrvkhLCCx
	 HXhHmcsKEHQElvGoUnqL/9kVzoX3jUIiFoIWnrDLxo1UMc+D0p6JfRZh2JH3g8f3SYA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=kfu8eU8q;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E1B72606A320;
	Thu, 19 Nov 2026 02:21:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=kfu8eU8q
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3EF031F000C4;
	Thu, 19 Nov 2026 02:21:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795054873;
	bh=Ao00P0YOstmhpYI2z0+lWFdnQLmkoQehDnUfEBX0bZM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=kfu8eU8qykAgGbFzUJwGqmOB85imaJeAR+tqtUAjCUJV0oU1HY9Lo6/HTxNLOq5fP
	 7NyMAfN7ot7R+MGBmOt7wqE1nzc6vDMJtXMHGxg19WABxpLnBGwHVNTqWjXXjH//CF
	 ZZcvmJFDaeryd0V0FI/9Ys4cFYBu0sv81z+mI5NM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sreekanth Reddy <sreekanth.reddy@broadcom.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 1431/2214] scsi: mpi3mr: Display IOC firmware package version
Date: Wed, 18 Nov 2026 15:51:47 +0100
Message-ID: <20261118150108.441303501@linuxfoundation.org>
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

[ Upstream commit 2ac794baaec97c70faf17b56fba4adefd6b7ba3a ]

Display IOC firmware package version by reading component image upload
data.

Link: https://lore.kernel.org/r/20211220141159.16117-11-sreekanth.reddy@broadcom.com
Signed-off-by: Sreekanth Reddy <sreekanth.reddy@broadcom.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Stable-dep-of: bcf0a5bed59a ("scsi: mpi3mr: Fix out-of-bounds reply frame access")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/mpi3mr/mpi3mr_fw.c | 89 +++++++++++++++++++++++++++++++++
 1 file changed, 89 insertions(+)

diff --git a/drivers/scsi/mpi3mr/mpi3mr_fw.c b/drivers/scsi/mpi3mr/mpi3mr_fw.c
index 98ef0d6d98982..0bb7cc727214b 100644
--- a/drivers/scsi/mpi3mr/mpi3mr_fw.c
+++ b/drivers/scsi/mpi3mr/mpi3mr_fw.c
@@ -1985,6 +1985,89 @@ static int mpi3mr_sync_timestamp(struct mpi3mr_ioc *mrioc)
 	return retval;
 }
 
+/**
+ * mpi3mr_print_pkg_ver - display controller fw package version
+ * @mrioc: Adapter reference
+ *
+ * Retrieve firmware package version from the component image
+ * header of the controller flash and display it.
+ *
+ * Return: 0 on success and non-zero on failure.
+ */
+static int mpi3mr_print_pkg_ver(struct mpi3mr_ioc *mrioc)
+{
+	struct mpi3_ci_upload_request ci_upload;
+	int retval = -1;
+	void *data = NULL;
+	dma_addr_t data_dma;
+	struct mpi3_ci_manifest_mpi *manifest;
+	u32 data_len = sizeof(struct mpi3_ci_manifest_mpi);
+	u8 sgl_flags = MPI3MR_SGEFLAGS_SYSTEM_SIMPLE_END_OF_LIST;
+
+	data = dma_alloc_coherent(&mrioc->pdev->dev, data_len, &data_dma,
+	    GFP_KERNEL);
+	if (!data)
+		return -ENOMEM;
+
+	memset(&ci_upload, 0, sizeof(ci_upload));
+	mutex_lock(&mrioc->init_cmds.mutex);
+	if (mrioc->init_cmds.state & MPI3MR_CMD_PENDING) {
+		ioc_err(mrioc, "sending get package version failed due to command in use\n");
+		mutex_unlock(&mrioc->init_cmds.mutex);
+		goto out;
+	}
+	mrioc->init_cmds.state = MPI3MR_CMD_PENDING;
+	mrioc->init_cmds.is_waiting = 1;
+	mrioc->init_cmds.callback = NULL;
+	ci_upload.host_tag = cpu_to_le16(MPI3MR_HOSTTAG_INITCMDS);
+	ci_upload.function = MPI3_FUNCTION_CI_UPLOAD;
+	ci_upload.msg_flags = MPI3_CI_UPLOAD_MSGFLAGS_LOCATION_PRIMARY;
+	ci_upload.signature1 = cpu_to_le32(MPI3_IMAGE_HEADER_SIGNATURE1_MANIFEST);
+	ci_upload.image_offset = cpu_to_le32(MPI3_IMAGE_HEADER_SIZE);
+	ci_upload.segment_size = cpu_to_le32(data_len);
+
+	mpi3mr_add_sg_single(&ci_upload.sgl, sgl_flags, data_len,
+	    data_dma);
+	init_completion(&mrioc->init_cmds.done);
+	retval = mpi3mr_admin_request_post(mrioc, &ci_upload,
+	    sizeof(ci_upload), 1);
+	if (retval) {
+		ioc_err(mrioc, "posting get package version failed\n");
+		goto out_unlock;
+	}
+	wait_for_completion_timeout(&mrioc->init_cmds.done,
+	    (MPI3MR_INTADMCMD_TIMEOUT * HZ));
+	if (!(mrioc->init_cmds.state & MPI3MR_CMD_COMPLETE)) {
+		ioc_err(mrioc, "get package version timed out\n");
+		retval = -1;
+		goto out_unlock;
+	}
+	if ((mrioc->init_cmds.ioc_status & MPI3_IOCSTATUS_STATUS_MASK)
+	    == MPI3_IOCSTATUS_SUCCESS) {
+		manifest = (struct mpi3_ci_manifest_mpi *) data;
+		if (manifest->manifest_type == MPI3_CI_MANIFEST_TYPE_MPI) {
+			ioc_info(mrioc,
+			    "firmware package version(%d.%d.%d.%d.%05d-%05d)\n",
+			    manifest->package_version.gen_major,
+			    manifest->package_version.gen_minor,
+			    manifest->package_version.phase_major,
+			    manifest->package_version.phase_minor,
+			    manifest->package_version.customer_id,
+			    manifest->package_version.build_num);
+		}
+	}
+	retval = 0;
+out_unlock:
+	mrioc->init_cmds.state = MPI3MR_CMD_NOTUSED;
+	mutex_unlock(&mrioc->init_cmds.mutex);
+
+out:
+	if (data)
+		dma_free_coherent(&mrioc->pdev->dev, data_len, data,
+		    data_dma);
+	return retval;
+}
+
 /**
  * mpi3mr_watchdog_work - watchdog thread to monitor faults
  * @work: work struct
@@ -3391,6 +3474,12 @@ int mpi3mr_init_ioc(struct mpi3mr_ioc *mrioc, u8 init_type)
 	writel(mrioc->sbq_host_index,
 	    &mrioc->sysif_regs->sense_buffer_free_host_index);
 
+	retval = mpi3mr_print_pkg_ver(mrioc);
+	if (retval) {
+		ioc_err(mrioc, "failed to get package version\n");
+		goto out_failed;
+	}
+
 	if (init_type != MPI3MR_IT_RESET) {
 		retval = mpi3mr_setup_isr(mrioc, 0);
 		if (retval) {
-- 
2.53.0



