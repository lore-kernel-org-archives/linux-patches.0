Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C0DD253D9CA;
	Wed, 23 Sep 2026 14:54:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790175274; cv=none; b=Nd8fExvThwwCHWjb1F+prLZiiq6yXn8Ri4J984r/+r15Hh08n95w4C+ND1S1zVyVgbySDkWloLXBz2JlzhFgebh877ue/bVecwCuncvgQk+Em0IxRpnZDsH4P9b4F9zNJBqppX8rc4NjfHFctcESn/vqmtBYWC+emhEvde8RcNE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790175274; c=relaxed/simple;
	bh=sky1ekr0rItWpnJVsBqjtdv5lKx5aHIUHCSaaXF/mfI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=K22gVWjurNGpLFYAo3E/RYiNXRMeUAixs0TrStfNxjuLwxpjgpmkIdkw+l3osudcYmUclBYhhhEJbblTrTRfqJ6/WvQ6XiEqRTrZrBzfCQ5ssAemXw4kwv/3e4ruOyH6XaDto/t2RSPnkcSJrYKHjEkTH25tdDg3IoRdnKMiHJQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=g/pZgw4l; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="g/pZgw4l"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2D6021F000FF;
	Wed, 23 Sep 2026 14:54:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790175272;
	bh=dbPRMPOeZA9OgycuJbtjreDGd5oZ7yDjiX6o2Ou02Ng=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=g/pZgw4lRL4meUKcmSQijs5e25kqTvlvOp7v9AB3hQ1LDh4vKqdFWr/LcO/EqICQ4
	 tVBexIJ09xsoNc3nWAtm5mBgLiP9qkHW0KosX7XgzToKyV77RRGNR0Y/ksPTW9Pf9A
	 aZtwXPs0mBoUg6dpuqUUkYJDbkCUaQVAHLrgeNfw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Karan Tilak Kumar <kartilak@cisco.com>,
	Sesidhar Baddela <sebaddel@cisco.com>,
	Arulprabhu Ponnusamy <arulponn@cisco.com>,
	Gian Carlo Boffa <gcboffa@cisco.com>,
	Arun Easi <aeasi@cisco.com>,
	Hannes Reinecke <hare@kernel.org>,
	Lee Duncan <lduncan@suse.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 375/398] scsi: fnic: Rename fnic_scsi_fcpio_reset()
Date: Wed, 23 Sep 2026 16:07:29 +0200
Message-ID: <20260923140653.170609195@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260923140643.441954610@linuxfoundation.org>
References: <20260923140643.441954610@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Karan Tilak Kumar <kartilak@cisco.com>

[ Upstream commit 31eda39bfd468a0fbabc0179e913c0755377e3b5 ]

The function has no dependency on SCSI/FCP, so rename it to
fnic_fcpio_reset() and move it to fnic_fcs.c

Tested-by: Karan Tilak Kumar <kartilak@cisco.com>
Reviewed-by: Sesidhar Baddela <sebaddel@cisco.com>
Reviewed-by: Arulprabhu Ponnusamy <arulponn@cisco.com>
Reviewed-by: Gian Carlo Boffa <gcboffa@cisco.com>
Reviewed-by: Arun Easi <aeasi@cisco.com>
Reviewed-by: Hannes Reinecke <hare@kernel.org>
Reviewed-by: Lee Duncan <lduncan@suse.com>
Signed-off-by: Karan Tilak Kumar <kartilak@cisco.com>
Co-developed-by: Hannes Reinecke <hare@kernel.org>
Link: https://patch.msgid.link/20260217223943.7938-3-kartilak@cisco.com
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Stable-dep-of: 0cb1fd924126 ("scsi: fnic: Fix missed link-up when critical IRQ targets offline CPU")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/scsi/fnic/fdls_disc.c |    4 +--
 drivers/scsi/fnic/fip.c       |    2 -
 drivers/scsi/fnic/fnic.h      |    1 
 drivers/scsi/fnic/fnic_fcs.c  |   50 ++++++++++++++++++++++++++++++++++++++
 drivers/scsi/fnic/fnic_fdls.h |    2 -
 drivers/scsi/fnic/fnic_scsi.c |   54 ------------------------------------------
 6 files changed, 55 insertions(+), 58 deletions(-)

--- a/drivers/scsi/fnic/fdls_disc.c
+++ b/drivers/scsi/fnic/fdls_disc.c
@@ -4613,7 +4613,7 @@ void fnic_fdls_disc_start(struct fnic_ip
 	if (!iport->usefip) {
 		if (iport->flags & FNIC_FIRST_LINK_UP) {
 			spin_unlock_irqrestore(&fnic->fnic_lock, fnic->lock_flags);
-			fnic_scsi_fcpio_reset(iport->fnic);
+			fnic_fcpio_reset(iport->fnic);
 			spin_lock_irqsave(&fnic->fnic_lock, fnic->lock_flags);
 
 			iport->flags &= ~FNIC_FIRST_LINK_UP;
@@ -5072,7 +5072,7 @@ void fnic_fdls_link_down(struct fnic_ipo
 	iport->fabric.flags = 0;
 
 	spin_unlock_irqrestore(&fnic->fnic_lock, fnic->lock_flags);
-	fnic_scsi_fcpio_reset(iport->fnic);
+	fnic_fcpio_reset(iport->fnic);
 	spin_lock_irqsave(&fnic->fnic_lock, fnic->lock_flags);
 	list_for_each_entry_safe(tport, next, &iport->tport_list, links) {
 		FNIC_FCS_DBG(KERN_INFO, fnic->host, fnic->fnic_num,
--- a/drivers/scsi/fnic/fip.c
+++ b/drivers/scsi/fnic/fip.c
@@ -737,7 +737,7 @@ void fnic_work_on_fip_timer(struct work_
 		if (memcmp(iport->selected_fcf.fcf_mac, zmac, ETH_ALEN) != 0) {
 
 			if (iport->flags & FNIC_FIRST_LINK_UP) {
-				fnic_scsi_fcpio_reset(iport->fnic);
+				fnic_fcpio_reset(iport->fnic);
 				iport->flags &= ~FNIC_FIRST_LINK_UP;
 			}
 
--- a/drivers/scsi/fnic/fnic.h
+++ b/drivers/scsi/fnic/fnic.h
@@ -511,7 +511,6 @@ int fnic_host_reset(struct Scsi_Host *sh
 void fnic_reset(struct Scsi_Host *shost);
 int fnic_issue_fc_host_lip(struct Scsi_Host *shost);
 void fnic_get_host_port_state(struct Scsi_Host *shost);
-void fnic_scsi_fcpio_reset(struct fnic *fnic);
 int fnic_wq_copy_cmpl_handler(struct fnic *fnic, int copy_work_to_do, unsigned int cq_index);
 int fnic_wq_cmpl_handler(struct fnic *fnic, int);
 int fnic_flogi_reg_handler(struct fnic *fnic, u32);
--- a/drivers/scsi/fnic/fnic_fcs.c
+++ b/drivers/scsi/fnic/fnic_fcs.c
@@ -1108,3 +1108,53 @@ void fnic_reset_work_handler(struct work
 	spin_unlock_irqrestore(&reset_fnic_list_lock,
 						   reset_fnic_list_lock_flags);
 }
+
+void fnic_fcpio_reset(struct fnic *fnic)
+{
+	unsigned long flags;
+	enum fnic_state old_state;
+	struct fnic_iport_s *iport = &fnic->iport;
+	DECLARE_COMPLETION_ONSTACK(fw_reset_done);
+	int time_remain;
+
+	/* issue fw reset */
+	spin_lock_irqsave(&fnic->fnic_lock, flags);
+	if (unlikely(fnic->state == FNIC_IN_FC_TRANS_ETH_MODE)) {
+		/* fw reset is in progress, poll for its completion */
+		spin_unlock_irqrestore(&fnic->fnic_lock, flags);
+		FNIC_FCS_DBG(KERN_INFO, fnic->host, fnic->fnic_num,
+			  "fnic is in unexpected state: %d for fw_reset\n",
+			  fnic->state);
+		return;
+	}
+
+	old_state = fnic->state;
+	fnic->state = FNIC_IN_FC_TRANS_ETH_MODE;
+
+	fnic_update_mac_locked(fnic, iport->hwmac);
+	fnic->fw_reset_done = &fw_reset_done;
+	spin_unlock_irqrestore(&fnic->fnic_lock, flags);
+
+	FNIC_FCS_DBG(KERN_INFO, fnic->host, fnic->fnic_num,
+				"Issuing fw reset\n");
+	if (fnic_fw_reset_handler(fnic)) {
+		spin_lock_irqsave(&fnic->fnic_lock, flags);
+		if (fnic->state == FNIC_IN_FC_TRANS_ETH_MODE)
+			fnic->state = old_state;
+		spin_unlock_irqrestore(&fnic->fnic_lock, flags);
+	} else {
+		FNIC_FCS_DBG(KERN_INFO, fnic->host, fnic->fnic_num,
+					  "Waiting for fw completion\n");
+		time_remain = wait_for_completion_timeout(&fw_reset_done,
+						  msecs_to_jiffies(FNIC_FW_RESET_TIMEOUT));
+		FNIC_FCS_DBG(KERN_INFO, fnic->host, fnic->fnic_num,
+					  "Woken up after fw completion timeout\n");
+		if (time_remain == 0) {
+			FNIC_FCS_DBG(KERN_INFO, fnic->host, fnic->fnic_num,
+				  "FW reset completion timed out after %d ms\n",
+				  FNIC_FW_RESET_TIMEOUT);
+		}
+		atomic64_inc(&fnic->fnic_stats.reset_stats.fw_reset_timeouts);
+	}
+	fnic->fw_reset_done = NULL;
+}
--- a/drivers/scsi/fnic/fnic_fdls.h
+++ b/drivers/scsi/fnic/fnic_fdls.h
@@ -410,6 +410,7 @@ void fnic_fdls_add_tport(struct fnic_ipo
 void fnic_fdls_remove_tport(struct fnic_iport_s *iport,
 			    struct fnic_tport_s *tport,
 			    unsigned long flags);
+void fnic_fcpio_reset(struct fnic *fnic);
 
 /* fip.c */
 void fnic_fcoe_send_vlan_req(struct fnic *fnic);
@@ -422,7 +423,6 @@ void fnic_handle_fip_timer(struct timer_
 extern void fdls_fabric_timer_callback(struct timer_list *t);
 
 /* fnic_scsi.c */
-void fnic_scsi_fcpio_reset(struct fnic *fnic);
 extern void fdls_fabric_timer_callback(struct timer_list *t);
 void fnic_rport_exch_reset(struct fnic *fnic, u32 fcid);
 int fnic_fdls_register_portid(struct fnic_iport_s *iport, u32 port_id,
--- a/drivers/scsi/fnic/fnic_scsi.c
+++ b/drivers/scsi/fnic/fnic_scsi.c
@@ -1974,8 +1974,7 @@ void fnic_scsi_unload(struct fnic *fnic)
 	spin_unlock_irqrestore(&fnic->fnic_lock, flags);
 
 	if (fdls_get_state(&fnic->iport.fabric) != FDLS_STATE_INIT)
-		fnic_scsi_fcpio_reset(fnic);
-
+		fnic_fcpio_reset(fnic);
 	spin_lock_irqsave(&fnic->fnic_lock, flags);
 	fnic->in_remove = 1;
 	spin_unlock_irqrestore(&fnic->fnic_lock, flags);
@@ -3039,54 +3038,3 @@ int fnic_eh_host_reset_handler(struct sc
 	ret = fnic_host_reset(shost);
 	return ret;
 }
-
-
-void fnic_scsi_fcpio_reset(struct fnic *fnic)
-{
-	unsigned long flags;
-	enum fnic_state old_state;
-	struct fnic_iport_s *iport = &fnic->iport;
-	DECLARE_COMPLETION_ONSTACK(fw_reset_done);
-	int time_remain;
-
-	/* issue fw reset */
-	spin_lock_irqsave(&fnic->fnic_lock, flags);
-	if (unlikely(fnic->state == FNIC_IN_FC_TRANS_ETH_MODE)) {
-		/* fw reset is in progress, poll for its completion */
-		spin_unlock_irqrestore(&fnic->fnic_lock, flags);
-		FNIC_SCSI_DBG(KERN_INFO, fnic->host, fnic->fnic_num,
-			  "fnic is in unexpected state: %d for fw_reset\n",
-			  fnic->state);
-		return;
-	}
-
-	old_state = fnic->state;
-	fnic->state = FNIC_IN_FC_TRANS_ETH_MODE;
-
-	fnic_update_mac_locked(fnic, iport->hwmac);
-	fnic->fw_reset_done = &fw_reset_done;
-	spin_unlock_irqrestore(&fnic->fnic_lock, flags);
-
-	FNIC_SCSI_DBG(KERN_INFO, fnic->host, fnic->fnic_num,
-				  "Issuing fw reset\n");
-	if (fnic_fw_reset_handler(fnic)) {
-		spin_lock_irqsave(&fnic->fnic_lock, flags);
-		if (fnic->state == FNIC_IN_FC_TRANS_ETH_MODE)
-			fnic->state = old_state;
-		spin_unlock_irqrestore(&fnic->fnic_lock, flags);
-	} else {
-		FNIC_SCSI_DBG(KERN_INFO, fnic->host, fnic->fnic_num,
-					  "Waiting for fw completion\n");
-		time_remain = wait_for_completion_timeout(&fw_reset_done,
-						  msecs_to_jiffies(FNIC_FW_RESET_TIMEOUT));
-		FNIC_SCSI_DBG(KERN_INFO, fnic->host, fnic->fnic_num,
-					  "Woken up after fw completion timeout\n");
-		if (time_remain == 0) {
-			FNIC_SCSI_DBG(KERN_INFO, fnic->host, fnic->fnic_num,
-				  "FW reset completion timed out after %d ms)\n",
-				  FNIC_FW_RESET_TIMEOUT);
-		}
-		atomic64_inc(&fnic->fnic_stats.reset_stats.fw_reset_timeouts);
-	}
-	fnic->fw_reset_done = NULL;
-}


