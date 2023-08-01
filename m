Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8403F1F95A
	for <patches@lists.linux.dev>; Tue,  1 Aug 2023 09:23:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 049A8C433C7;
	Tue,  1 Aug 2023 09:23:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1690881824;
	bh=Vz5hG1JxxNlikl/2NGUElIdhXWsnSa9iup05i25o6r8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PWoAeI/zeEkNjJWHKCgK/0tYXgncoKO+mytaBlRdrx+VAeGQ/nRi8eJSjcUU61Hqt
	 D6B9NTWOdpYk2nmpDAi9TbvTMp0oUbOPjWviqOgXvBswsjH//XBvc5WQju38vLMi/p
	 zZioWHnvJ01BFYnmJ/mfehc7wBcz3AtcWHlOR7hM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Arun Easi <aeasi@marvell.com>,
	Nilesh Javali <njavali@marvell.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 042/155] scsi: qla2xxx: Add debug prints in the device remove path
Date: Tue,  1 Aug 2023 11:19:14 +0200
Message-ID: <20230801091911.686278325@linuxfoundation.org>
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

From: Arun Easi <aeasi@marvell.com>

[ Upstream commit f12d2d130efc49464ef0666789bfeb9073162743 ]

Add a debug print in the devloss callback.

Link: https://lore.kernel.org/r/20220616053508.27186-9-njavali@marvell.com
Signed-off-by: Arun Easi <aeasi@marvell.com>
Signed-off-by: Nilesh Javali <njavali@marvell.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Stable-dep-of: 9ae615c5bfd3 ("scsi: qla2xxx: Fix hang in task management")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/qla2xxx/qla_attr.c | 3 +++
 drivers/scsi/qla2xxx/qla_def.h  | 6 ++++++
 2 files changed, 9 insertions(+)

diff --git a/drivers/scsi/qla2xxx/qla_attr.c b/drivers/scsi/qla2xxx/qla_attr.c
index de57d45ffc5cb..4a5df867057bc 100644
--- a/drivers/scsi/qla2xxx/qla_attr.c
+++ b/drivers/scsi/qla2xxx/qla_attr.c
@@ -2705,6 +2705,9 @@ qla2x00_dev_loss_tmo_callbk(struct fc_rport *rport)
 	if (!fcport)
 		return;
 
+	ql_dbg(ql_dbg_async, fcport->vha, 0x5101,
+	       DBG_FCPORT_PRFMT(fcport, "dev_loss_tmo expiry, rport_state=%d",
+				rport->port_state));
 
 	/*
 	 * Now that the rport has been deleted, set the fcport state to
diff --git a/drivers/scsi/qla2xxx/qla_def.h b/drivers/scsi/qla2xxx/qla_def.h
index bbeb116c16cc3..2a2bca2fb57ee 100644
--- a/drivers/scsi/qla2xxx/qla_def.h
+++ b/drivers/scsi/qla2xxx/qla_def.h
@@ -5475,4 +5475,10 @@ struct ql_vnd_tgt_stats_resp {
 #define IS_SESSION_DELETED(_fcport) (_fcport->disc_state == DSC_DELETE_PEND || \
 				      _fcport->disc_state == DSC_DELETED)
 
+#define DBG_FCPORT_PRFMT(_fp, _fmt, _args...) \
+	"%s: %8phC: " _fmt " (state=%d disc_state=%d scan_state=%d loopid=0x%x deleted=%d flags=0x%x)\n", \
+	__func__, _fp->port_name, ##_args, atomic_read(&_fp->state), \
+	_fp->disc_state, _fp->scan_state, _fp->loop_id, _fp->deleted, \
+	_fp->flags
+
 #endif
-- 
2.39.2



