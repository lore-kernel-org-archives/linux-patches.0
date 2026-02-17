Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0614729A1;
	Tue, 17 Feb 2026 20:46:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771361176; cv=none; b=YA9jfCHtGRGh60dJzcOYoYaWAj2uF6wvLCUoIsDDJCvuGThu0shr49EMyJzZQ+kROG6TWAGfwUXgCJORfpv1N/k1iHX5Wt2LBpWQTUxolcyCvvuewU8DbbQ6PLGo+iQ/DfQg6/OZ7HQXSpchqto9jfYJgD/ExgA0eVN9TDA9SaY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771361176; c=relaxed/simple;
	bh=A3ZHYKtVQn9DjpGg6xTh/5ywzP4KkrL3bZql063lzLQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=S+61Wr2A3fAEeja3HCfMY3li5fprAC1K/dNCebyXCqEjP5w3zhWL4wlfxKdoHke6JXkPbJa7X1IMY6ETGgwe200Jjpgl3pOtBJFAjTghK1b0Vion1HpXIj9aPhM5fkKGQzl/kZn3g+hUk2q69O5PkBva08LjwGKiQGmoZphtIww=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Eowtp5+B; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Eowtp5+B"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 71317C4CEF7;
	Tue, 17 Feb 2026 20:46:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1771361175;
	bh=A3ZHYKtVQn9DjpGg6xTh/5ywzP4KkrL3bZql063lzLQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Eowtp5+BG1zRYWoUXvuuqY9gOfGyyGbceY3jMagUx52oMZXJJJpeGqyy7sm9Ds69N
	 0u0aBIE7jXib6kYfOMG6w4MYo60Ukto9ZtfyR5cLZMSCPR2zc4z411o1qNL+b8FLmY
	 zMn6tj83bh5ZZjMhwNMMomlowt52NH4UMzDFOPyQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Quinn Tran <qutran@marvell.com>,
	Nilesh Javali <njavali@marvell.com>,
	Himanshu Madhani <himanshu.madhani@oracle.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 23/64] scsi: qla2xxx: Remove dead code (GNN ID)
Date: Tue, 17 Feb 2026 21:31:19 +0100
Message-ID: <20260217200008.389444915@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260217200007.505931165@linuxfoundation.org>
References: <20260217200007.505931165@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Quinn Tran <qutran@marvell.com>

[ Upstream commit 87f6dafd50fb6d7214c32596a11b983138b09123 ]

Remove stale/unused code (GNN ID).

Signed-off-by: Quinn Tran <qutran@marvell.com>
Signed-off-by: Nilesh Javali <njavali@marvell.com>
Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Stable-dep-of: 7adbd2b78090 ("scsi: qla2xxx: Free sp in error path to fix system crash")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/scsi/qla2xxx/qla_def.h  |    3 -
 drivers/scsi/qla2xxx/qla_gbl.h  |    3 -
 drivers/scsi/qla2xxx/qla_gs.c   |  110 ----------------------------------------
 drivers/scsi/qla2xxx/qla_init.c |    7 --
 drivers/scsi/qla2xxx/qla_os.c   |    3 -
 5 files changed, 1 insertion(+), 125 deletions(-)

--- a/drivers/scsi/qla2xxx/qla_def.h
+++ b/drivers/scsi/qla2xxx/qla_def.h
@@ -2499,7 +2499,6 @@ struct ct_sns_desc {
 
 enum discovery_state {
 	DSC_DELETED,
-	DSC_GNN_ID,
 	DSC_GNL,
 	DSC_LOGIN_PEND,
 	DSC_LOGIN_FAILED,
@@ -2712,7 +2711,6 @@ extern const char *const port_state_str[
 
 static const char *const port_dstate_str[] = {
 	[DSC_DELETED]		= "DELETED",
-	[DSC_GNN_ID]		= "GNN_ID",
 	[DSC_GNL]		= "GNL",
 	[DSC_LOGIN_PEND]	= "LOGIN_PEND",
 	[DSC_LOGIN_FAILED]	= "LOGIN_FAILED",
@@ -3508,7 +3506,6 @@ enum qla_work_type {
 	QLA_EVT_GPNFT,
 	QLA_EVT_GPNFT_DONE,
 	QLA_EVT_GNNFT_DONE,
-	QLA_EVT_GNNID,
 	QLA_EVT_GFPNID,
 	QLA_EVT_SP_RETRY,
 	QLA_EVT_IIDMA,
--- a/drivers/scsi/qla2xxx/qla_gbl.h
+++ b/drivers/scsi/qla2xxx/qla_gbl.h
@@ -739,9 +739,6 @@ int qla24xx_async_gffid(scsi_qla_host_t
 int qla24xx_async_gpnft(scsi_qla_host_t *, u8, srb_t *);
 void qla24xx_async_gpnft_done(scsi_qla_host_t *, srb_t *);
 void qla24xx_async_gnnft_done(scsi_qla_host_t *, srb_t *);
-int qla24xx_async_gnnid(scsi_qla_host_t *, fc_port_t *);
-void qla24xx_handle_gnnid_event(scsi_qla_host_t *, struct event_arg *);
-int qla24xx_post_gnnid_work(struct scsi_qla_host *, fc_port_t *);
 int qla24xx_post_gfpnid_work(struct scsi_qla_host *, fc_port_t *);
 int qla24xx_async_gfpnid(scsi_qla_host_t *, fc_port_t *);
 void qla24xx_handle_gfpnid_event(scsi_qla_host_t *, struct event_arg *);
--- a/drivers/scsi/qla2xxx/qla_gs.c
+++ b/drivers/scsi/qla2xxx/qla_gs.c
@@ -4216,116 +4216,6 @@ void qla_scan_work_fn(struct work_struct
 	spin_unlock_irqrestore(&vha->work_lock, flags);
 }
 
-/* GNN_ID */
-void qla24xx_handle_gnnid_event(scsi_qla_host_t *vha, struct event_arg *ea)
-{
-	qla24xx_post_gnl_work(vha, ea->fcport);
-}
-
-static void qla2x00_async_gnnid_sp_done(srb_t *sp, int res)
-{
-	struct scsi_qla_host *vha = sp->vha;
-	fc_port_t *fcport = sp->fcport;
-	u8 *node_name = fcport->ct_desc.ct_sns->p.rsp.rsp.gnn_id.node_name;
-	struct event_arg ea;
-	u64 wwnn;
-
-	fcport->flags &= ~FCF_ASYNC_SENT;
-	wwnn = wwn_to_u64(node_name);
-	if (wwnn)
-		memcpy(fcport->node_name, node_name, WWN_SIZE);
-
-	memset(&ea, 0, sizeof(ea));
-	ea.fcport = fcport;
-	ea.sp = sp;
-	ea.rc = res;
-
-	ql_dbg(ql_dbg_disc, vha, 0x204f,
-	    "Async done-%s res %x, WWPN %8phC %8phC\n",
-	    sp->name, res, fcport->port_name, fcport->node_name);
-
-	qla24xx_handle_gnnid_event(vha, &ea);
-
-	/* ref: INIT */
-	kref_put(&sp->cmd_kref, qla2x00_sp_release);
-}
-
-int qla24xx_async_gnnid(scsi_qla_host_t *vha, fc_port_t *fcport)
-{
-	int rval = QLA_FUNCTION_FAILED;
-	struct ct_sns_req       *ct_req;
-	srb_t *sp;
-
-	if (!vha->flags.online || (fcport->flags & FCF_ASYNC_SENT))
-		return rval;
-
-	qla2x00_set_fcport_disc_state(fcport, DSC_GNN_ID);
-	/* ref: INIT */
-	sp = qla2x00_get_sp(vha, fcport, GFP_ATOMIC);
-	if (!sp)
-		goto done;
-
-	fcport->flags |= FCF_ASYNC_SENT;
-	sp->type = SRB_CT_PTHRU_CMD;
-	sp->name = "gnnid";
-	sp->gen1 = fcport->rscn_gen;
-	sp->gen2 = fcport->login_gen;
-	qla2x00_init_async_sp(sp, qla2x00_get_async_timeout(vha) + 2,
-			      qla2x00_async_gnnid_sp_done);
-
-	/* CT_IU preamble  */
-	ct_req = qla2x00_prep_ct_req(fcport->ct_desc.ct_sns, GNN_ID_CMD,
-	    GNN_ID_RSP_SIZE);
-
-	/* GNN_ID req */
-	ct_req->req.port_id.port_id = port_id_to_be_id(fcport->d_id);
-
-
-	/* req & rsp use the same buffer */
-	sp->u.iocb_cmd.u.ctarg.req = fcport->ct_desc.ct_sns;
-	sp->u.iocb_cmd.u.ctarg.req_dma = fcport->ct_desc.ct_sns_dma;
-	sp->u.iocb_cmd.u.ctarg.rsp = fcport->ct_desc.ct_sns;
-	sp->u.iocb_cmd.u.ctarg.rsp_dma = fcport->ct_desc.ct_sns_dma;
-	sp->u.iocb_cmd.u.ctarg.req_size = GNN_ID_REQ_SIZE;
-	sp->u.iocb_cmd.u.ctarg.rsp_size = GNN_ID_RSP_SIZE;
-	sp->u.iocb_cmd.u.ctarg.nport_handle = NPH_SNS;
-
-	ql_dbg(ql_dbg_disc, vha, 0xffff,
-	    "Async-%s - %8phC hdl=%x loopid=%x portid %06x.\n",
-	    sp->name, fcport->port_name,
-	    sp->handle, fcport->loop_id, fcport->d_id.b24);
-
-	rval = qla2x00_start_sp(sp);
-	if (rval != QLA_SUCCESS)
-		goto done_free_sp;
-	return rval;
-
-done_free_sp:
-	/* ref: INIT */
-	kref_put(&sp->cmd_kref, qla2x00_sp_release);
-	fcport->flags &= ~FCF_ASYNC_SENT;
-done:
-	return rval;
-}
-
-int qla24xx_post_gnnid_work(struct scsi_qla_host *vha, fc_port_t *fcport)
-{
-	struct qla_work_evt *e;
-	int ls;
-
-	ls = atomic_read(&vha->loop_state);
-	if (((ls != LOOP_READY) && (ls != LOOP_UP)) ||
-		test_bit(UNLOADING, &vha->dpc_flags))
-		return 0;
-
-	e = qla2x00_alloc_work(vha, QLA_EVT_GNNID);
-	if (!e)
-		return QLA_FUNCTION_FAILED;
-
-	e->u.fcport.fcport = fcport;
-	return qla2x00_post_work(vha, e);
-}
-
 /* GPFN_ID */
 void qla24xx_handle_gfpnid_event(scsi_qla_host_t *vha, struct event_arg *ea)
 {
--- a/drivers/scsi/qla2xxx/qla_init.c
+++ b/drivers/scsi/qla2xxx/qla_init.c
@@ -1723,12 +1723,7 @@ int qla24xx_fcport_handle_login(struct s
 			}
 			break;
 		default:
-			if (wwn == 0)    {
-				ql_dbg(ql_dbg_disc, vha, 0xffff,
-				    "%s %d %8phC post GNNID\n",
-				    __func__, __LINE__, fcport->port_name);
-				qla24xx_post_gnnid_work(vha, fcport);
-			} else if (fcport->loop_id == FC_NO_LOOP_ID) {
+			if (fcport->loop_id == FC_NO_LOOP_ID) {
 				ql_dbg(ql_dbg_disc, vha, 0x20bd,
 				    "%s %d %8phC post gnl\n",
 				    __func__, __LINE__, fcport->port_name);
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -5532,9 +5532,6 @@ qla2x00_do_work(struct scsi_qla_host *vh
 		case QLA_EVT_GNNFT_DONE:
 			qla24xx_async_gnnft_done(vha, e->u.iosb.sp);
 			break;
-		case QLA_EVT_GNNID:
-			qla24xx_async_gnnid(vha, e->u.fcport.fcport);
-			break;
 		case QLA_EVT_GFPNID:
 			qla24xx_async_gfpnid(vha, e->u.fcport.fcport);
 			break;


