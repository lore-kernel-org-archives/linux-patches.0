Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793208173;
	b=x1bHU+6+VVLX1SoNOe923QZU84a+12cHyQG/ZrF8VoMosolip7RkDguya86jzBXBaoOV
	 hxBDGA+ewI71Xe9odhKfv8VPubzsOCLK5hQ6RoloqiqRIjeLr9nfsZlRkk8bjklsv4SDs
	 OaIsvJA8lcIPkI0I0uY/4Rv7l3d9+Z8nYJDq/JOUhWZ5PQiwrSmx76hoasS8B/AQTisrB
	 LMmXQ2vfkEDYxlK85sqQlrC6StrnWkZB5JOiLzVMpUEyaFSxANKIZC0kxyFF4oIbUV1B5
	 53yNNeis5givquTqdavtErL6RlkLwR9Q34Yr53S6iqUOiTWHROKoRB9NcddpNPrGsiQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793208173;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=3Ofo80YkLAOKeBNGvV+U71v3nxQKWyHotpQL/+KXBFo=;
	b=hfXz9d/YN7pizB8jpmWqJj5dwaO4KM2wCkDxeyJPFgRSZIWm+JAqbhNAlq/+6tLYOLp5
	 ZFYo3hJKDQObyBruwxudpPvHAeYu3WVKfpfKh3i2dMz7Fvveu3qXEyU/KU3o23A5xfsW4
	 XJvOz97e+JLtlgPn2J0/uGGuEtfVa2eZiB9j2Kbs+HD/l+whIfhrHH5BsviUHZ3VSu891
	 7plHNrA+gvDoZLGfRPCSefwe45Xt+rxVKlKbrGb3XlqQK9ZHY2kUBnLB6+LPED1fYpcGa
	 loXx++ap59BTXP7ecLUiifufEYD5NpNhJFQBgI9iFfg7MI1nSzLtAx8/OsAGMxlxXbg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="tnj8/XbU";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2ACC0606A31C;
	Wed, 28 Oct 2026 17:22:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=tnj8/XbU
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7C77E1F01825;
	Wed, 28 Oct 2026 17:22:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793208172;
	bh=3Ofo80YkLAOKeBNGvV+U71v3nxQKWyHotpQL/+KXBFo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=tnj8/XbU6JDWJk6y8PE4IzBDr7Hel0VErc8eyfa51+ERKLVDoRa0GpQNlS3T0Epg/
	 BtrXJdt52y5nZJ3O0M1t9SY1SeWh4IFqpdXdI0paGdk0ro/7r5CxTQ5vgaDlG8tuU4
	 l1RGNwCOt4W/sMD9hCXX6f6dKMc5yi771Cr4znE0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-dev@google.com>,
	Nilesh Javali <njavali@marvell.com>,
	"Martin K. Petersen (Oracle)" <mkp@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 026/516] scsi: qla2xxx: Validate BSG request_len before reading vendor_cmd[]
Date: Wed, 28 Oct 2026 17:52:58 +0100
Message-ID: <20261028170004.147120815@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170003.522232767@linuxfoundation.org>
References: <20261028170003.522232767@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nilesh Javali <njavali@marvell.com>

[ Upstream commit 4cf38dd9465736141263ebb63375868311a0ec81 ]

The FC BSG transport allocates job->request via memdup_user() using the
exact user-supplied request_len. For FC_BSG_HST_VENDOR,
fc_bsg_host_dispatch() only guarantees request_len covers msgcode and
vendor_id; it does not account for the vendor_cmd[] flexible array.

qla2xxx then reads the command selector vendor_cmd[0] and, in several
sub-handlers, vendor_cmd[1]/[2] or structures overlaid on the vendor
command area without verifying request_len. A caller holding
CAP_SYS_RAWIO can submit a short request whose vendor_id matches the
host, triggering out-of-bounds heap reads (KASAN-detectable, and able to
mis-select a command or panic).

Add a central guard in qla2x00_process_vendor_specific() so the selector
is always in bounds, restrict the early vendor_cmd[0] read in
qla24xx_bsg_request() to sufficiently long vendor messages, and add
request_len checks to the sub-handlers that read further:
qla24xx_proc_fcp_prio_cfg_cmd(), qla2x00_process_loopback(),
qla84xx_reset(), qla84xx_updatefw(), qla2x00_read_optrom(),
qla2x00_update_optrom(), qlafx00_mgmt_cmd() and
qla28xx_validate_flash_image().

Fixes: 01e0e15c8b3b ("scsi: don't use fc_bsg_job::request and fc_bsg_job::reply directly")
Cc: stable@vger.kernel.org
Reported-by: Sashiko <sashiko-dev@google.com>
Signed-off-by: Nilesh Javali <njavali@marvell.com>
Link: https://patch.msgid.link/20260730155838.2119230-31-njavali@marvell.com
Signed-off-by: Martin K. Petersen (Oracle) <mkp@kernel.org>
[ adapted validation to the older qla2xxx handler layout. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/qla2xxx/qla_bsg.c | 39 ++++++++++++++++++++++++++++++++++
 1 file changed, 39 insertions(+)

diff --git a/drivers/scsi/qla2xxx/qla_bsg.c b/drivers/scsi/qla2xxx/qla_bsg.c
index 19ed2d86ad2d2..5a00db769f308 100644
--- a/drivers/scsi/qla2xxx/qla_bsg.c
+++ b/drivers/scsi/qla2xxx/qla_bsg.c
@@ -140,6 +140,12 @@ qla24xx_proc_fcp_prio_cfg_cmd(struct bsg_job *bsg_job)
 		goto exit_fcp_prio_cfg;
 	}
 
+	if (bsg_job->request_len <
+	    sizeof(struct fc_bsg_request) + 2 * sizeof(uint32_t)) {
+		ret = -EINVAL;
+		goto exit_fcp_prio_cfg;
+	}
+
 	/* Get the sub command */
 	oper = bsg_request->rqst_data.h_vendor.vendor_cmd[1];
 
@@ -733,6 +739,10 @@ qla2x00_process_loopback(struct bsg_job *bsg_job)
 		return -EIO;
 	}
 
+	if (bsg_job->request_len <
+	    sizeof(struct fc_bsg_request) + 3 * sizeof(uint32_t))
+		return -EINVAL;
+
 	memset(&elreq, 0, sizeof(elreq));
 
 	elreq.req_sg_cnt = dma_map_sg(&ha->pdev->dev,
@@ -965,6 +975,10 @@ qla84xx_reset(struct bsg_job *bsg_job)
 		return -EINVAL;
 	}
 
+	if (bsg_job->request_len <
+	    sizeof(struct fc_bsg_request) + 2 * sizeof(uint32_t))
+		return -EINVAL;
+
 	flag = bsg_request->rqst_data.h_vendor.vendor_cmd[1];
 
 	rval = qla84xx_reset_chip(vha, flag == A84_ISSUE_RESET_DIAG_FW);
@@ -1009,6 +1023,10 @@ qla84xx_updatefw(struct bsg_job *bsg_job)
 		return -EINVAL;
 	}
 
+	if (bsg_job->request_len <
+	    sizeof(struct fc_bsg_request) + 2 * sizeof(uint32_t))
+		return -EINVAL;
+
 	sg_cnt = dma_map_sg(&ha->pdev->dev, bsg_job->request_payload.sg_list,
 		bsg_job->request_payload.sg_cnt, DMA_TO_DEVICE);
 	if (!sg_cnt) {
@@ -1459,6 +1477,10 @@ qla2x00_read_optrom(struct bsg_job *bsg_job)
 	struct qla_hw_data *ha = vha->hw;
 	int rval = 0;
 
+	if (bsg_job->request_len <
+	    sizeof(struct fc_bsg_request) + 2 * sizeof(uint32_t))
+		return -EINVAL;
+
 	if (ha->flags.nic_core_reset_hdlr_active)
 		return -EBUSY;
 
@@ -1496,6 +1518,10 @@ qla2x00_update_optrom(struct bsg_job *bsg_job)
 	struct qla_hw_data *ha = vha->hw;
 	int rval = 0;
 
+	if (bsg_job->request_len <
+	    sizeof(struct fc_bsg_request) + 2 * sizeof(uint32_t))
+		return -EINVAL;
+
 	mutex_lock(&ha->optrom_mutex);
 	rval = qla2x00_optrom_setup(bsg_job, vha, 1);
 	if (rval) {
@@ -1987,6 +2013,11 @@ qlafx00_mgmt_cmd(struct bsg_job *bsg_job)
 	struct fc_port *fcport;
 	char  *type = "FC_BSG_HST_FX_MGMT";
 
+	if (bsg_job->request_len <
+	    sizeof(struct fc_bsg_request) + sizeof(uint32_t) +
+	    sizeof(struct qla_mt_iocb_rqst_fx00))
+		return -EINVAL;
+
 	/* Copy the IOCB specific information */
 	piocb_rqst = (struct qla_mt_iocb_rqst_fx00 *)
 	    &bsg_request->rqst_data.h_vendor.vendor_cmd[1];
@@ -2463,6 +2494,14 @@ static int
 qla2x00_process_vendor_specific(struct bsg_job *bsg_job)
 {
 	struct fc_bsg_request *bsg_request = bsg_job->request;
+	scsi_qla_host_t *vha = shost_priv(fc_bsg_to_shost(bsg_job));
+
+	if (bsg_job->request_len <
+	    sizeof(struct fc_bsg_request) + sizeof(uint32_t)) {
+		ql_log(ql_log_warn, vha, 0x7000,
+		       "BSG request too small for vendor cmd.\n");
+		return -EINVAL;
+	}
 
 	switch (bsg_request->rqst_data.h_vendor.vendor_cmd[0]) {
 	case QL_VND_LOOPBACK:
-- 
2.53.0



