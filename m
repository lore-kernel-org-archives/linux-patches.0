Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 47C571F95A
	for <patches@lists.linux.dev>; Tue,  1 Aug 2023 09:23:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BE200C433C8;
	Tue,  1 Aug 2023 09:23:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1690881813;
	bh=/XohWmRWXOJb+7eGB9byUsFu5IlT113Weh7gENHMSAw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Nsiev/pJtAPYzZq/p/kHsitiwMumu1jo/NHZEoZbBoUZmgiqesP8qnZrMCwbSUh4C
	 YJspEjKPFwumFZ6EZ4RIRAVVISH3gXY7VMbjbe98vHev/AGLsg1Av2ahC7QSb3xHX/
	 wOG+gtTEfnKlwBZL80UNS0aCGHjeEK5HF0OjPNQY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gaosheng Cui <cuigaosheng1@huawei.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 038/155] scsi: qla2xxx: Remove unused declarations for qla2xxx
Date: Tue,  1 Aug 2023 11:19:10 +0200
Message-ID: <20230801091911.531521542@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230801091910.165050260@linuxfoundation.org>
References: <20230801091910.165050260@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Gaosheng Cui <cuigaosheng1@huawei.com>

[ Upstream commit 1b80addaae099dc33e683d971aba90eeeaf887a3 ]

qla2x00_get_fw_version_str() has been removed since commit abbd8870b9cb
("[SCSI] qla2xxx: Factor-out ISP specific functions to method-based call
tables.").

qla2x00_release_nvram_protection() has been removed since commit
459c537807bd ("[SCSI] qla2xxx: Add ISP24xx flash-manipulation routines.").

qla82xx_rdmem() and qla82xx_wrmem() have been removed since commit
3711333dfbee ("[SCSI] qla2xxx: Updates for ISP82xx.").

qla25xx_rd_req_reg(), qla24xx_rd_req_reg(), qla25xx_wrt_rsp_reg(),
qla24xx_wrt_rsp_reg(), qla25xx_wrt_req_reg() and qla24xx_wrt_req_reg() have
been removed since commit 08029990b25b ("[SCSI] qla2xxx: Refactor
request/response-queue register handling.").

qla2x00_async_login_done() has been removed since commit 726b85487067
("qla2xxx: Add framework for async fabric discovery").

qlt_24xx_process_response_error() has been removed since commit
c5419e2618b9 ("scsi: qla2xxx: Combine Active command arrays.").

Remove the declarations for them from header file.

Link: https://lore.kernel.org/r/20220913023722.547249-2-cuigaosheng1@huawei.com
Signed-off-by: Gaosheng Cui <cuigaosheng1@huawei.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Stable-dep-of: 6a87679626b5 ("scsi: qla2xxx: Fix task management cmd fail due to unavailable resource")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/qla2xxx/qla_gbl.h    | 12 ------------
 drivers/scsi/qla2xxx/qla_target.h |  2 --
 2 files changed, 14 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_gbl.h b/drivers/scsi/qla2xxx/qla_gbl.h
index f82e4a348330a..4ed0777cd2a6f 100644
--- a/drivers/scsi/qla2xxx/qla_gbl.h
+++ b/drivers/scsi/qla2xxx/qla_gbl.h
@@ -70,8 +70,6 @@ extern int qla2x00_async_prlo(struct scsi_qla_host *, fc_port_t *);
 extern int qla2x00_async_adisc(struct scsi_qla_host *, fc_port_t *,
     uint16_t *);
 extern int qla2x00_async_tm_cmd(fc_port_t *, uint32_t, uint32_t, uint32_t);
-extern void qla2x00_async_login_done(struct scsi_qla_host *, fc_port_t *,
-    uint16_t *);
 struct qla_work_evt *qla2x00_alloc_work(struct scsi_qla_host *,
     enum qla_work_type);
 extern int qla24xx_async_gnl(struct scsi_qla_host *, fc_port_t *);
@@ -278,7 +276,6 @@ extern int qla24xx_vport_create_req_sanity_check(struct fc_vport *);
 extern scsi_qla_host_t *qla24xx_create_vhost(struct fc_vport *);
 
 extern void qla2x00_sp_free_dma(srb_t *sp);
-extern char *qla2x00_get_fw_version_str(struct scsi_qla_host *, char *);
 
 extern void qla2x00_mark_device_lost(scsi_qla_host_t *, fc_port_t *, int);
 extern void qla2x00_mark_all_devices_lost(scsi_qla_host_t *);
@@ -611,7 +608,6 @@ void __qla_consume_iocb(struct scsi_qla_host *vha, void **pkt, struct rsp_que **
 /*
  * Global Function Prototypes in qla_sup.c source file.
  */
-extern void qla2x00_release_nvram_protection(scsi_qla_host_t *);
 extern int qla24xx_read_flash_data(scsi_qla_host_t *, uint32_t *,
     uint32_t, uint32_t);
 extern uint8_t *qla2x00_read_nvram_data(scsi_qla_host_t *, void *, uint32_t,
@@ -781,12 +777,6 @@ extern void qla2x00_init_response_q_entries(struct rsp_que *);
 extern int qla25xx_delete_req_que(struct scsi_qla_host *, struct req_que *);
 extern int qla25xx_delete_rsp_que(struct scsi_qla_host *, struct rsp_que *);
 extern int qla25xx_delete_queues(struct scsi_qla_host *);
-extern uint16_t qla24xx_rd_req_reg(struct qla_hw_data *, uint16_t);
-extern uint16_t qla25xx_rd_req_reg(struct qla_hw_data *, uint16_t);
-extern void qla24xx_wrt_req_reg(struct qla_hw_data *, uint16_t, uint16_t);
-extern void qla25xx_wrt_req_reg(struct qla_hw_data *, uint16_t, uint16_t);
-extern void qla25xx_wrt_rsp_reg(struct qla_hw_data *, uint16_t, uint16_t);
-extern void qla24xx_wrt_rsp_reg(struct qla_hw_data *, uint16_t, uint16_t);
 
 /* qlafx00 related functions */
 extern int qlafx00_pci_config(struct scsi_qla_host *);
@@ -871,8 +861,6 @@ extern void qla82xx_init_flags(struct qla_hw_data *);
 extern void qla82xx_set_drv_active(scsi_qla_host_t *);
 extern int qla82xx_wr_32(struct qla_hw_data *, ulong, u32);
 extern int qla82xx_rd_32(struct qla_hw_data *, ulong);
-extern int qla82xx_rdmem(struct qla_hw_data *, u64, void *, int);
-extern int qla82xx_wrmem(struct qla_hw_data *, u64, void *, int);
 
 /* ISP 8021 IDC */
 extern void qla82xx_clear_drv_active(struct qla_hw_data *);
diff --git a/drivers/scsi/qla2xxx/qla_target.h b/drivers/scsi/qla2xxx/qla_target.h
index 156b950ca7e72..aa83434448377 100644
--- a/drivers/scsi/qla2xxx/qla_target.h
+++ b/drivers/scsi/qla2xxx/qla_target.h
@@ -1080,8 +1080,6 @@ extern void qlt_81xx_config_nvram_stage2(struct scsi_qla_host *,
 	struct init_cb_81xx *);
 extern void qlt_81xx_config_nvram_stage1(struct scsi_qla_host *,
 	struct nvram_81xx *);
-extern int qlt_24xx_process_response_error(struct scsi_qla_host *,
-	struct sts_entry_24xx *);
 extern void qlt_modify_vp_config(struct scsi_qla_host *,
 	struct vp_config_entry_24xx *);
 extern void qlt_probe_one_stage1(struct scsi_qla_host *, struct qla_hw_data *);
-- 
2.39.2



