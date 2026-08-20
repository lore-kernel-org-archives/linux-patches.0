Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DCA9740F754;
	Thu, 20 Aug 2026 16:44:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787244264; cv=none; b=rIC28BZRfhzBqvaxrTiFEjZvwp6k8zGo+5c5lwgvL8ycxTcHbxh8bmwMVp0Fm0nvoF4uTtHZfI9Ys47yARD/luy8ZQPJAJt2pqdbszmfbCMUDx20UhuFJZwFmKo28WvKnucFIBtpAgboRNC0TzF7B5mPLLksZXoJ6aOWJHdGItU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787244264; c=relaxed/simple;
	bh=PdajstaPjIvPrhAxnyKm/VRBGxnl7hXEenGKLh7j7aU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oS2ShJF0qnQz+qv+IveZinFkKJIzjLPZEyZkU+wks4BGT82R7QFJ7ExDcTxrcwmeqR6tqRnwRNnCfKUj8FTsUO0zUbffo+5GGmBfqnuKSRVkt2mO7C/frtC/OTANCMqHkGt7jPKieAVnet37LlmxCa/shy7QPUsWcFaP58uJFIM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aWDSprGS; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aWDSprGS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3E20A1F000E9;
	Thu, 20 Aug 2026 16:44:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787244262;
	bh=voLqyKTi3wityaIhKRI+vt1VeOaSJHp433Wgt/sHtkk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=aWDSprGSXyh2/jBd4CX/CUZ8+ZVvp+om0z3yOiXSPtXf0H3SHEPm4St6eUJQPjt/L
	 28zZ6ayAb9wLgTq3vphuVabN3Rg8t8X9AqKzq78ozvonPgNtvJEvidaZPmuH8Az1Rk
	 jVz/79pdnBCdlxGGgLO2RBZZu5yPNdejdXiLPTjA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mike Christie <michael.christie@oracle.com>,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>,
	Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 109/235] scsi: target: core: pr: Initialize arrays at declaration time
Date: Thu, 20 Aug 2026 16:55:45 +0200
Message-ID: <20260820145219.756359904@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260820145216.426568665@linuxfoundation.org>
References: <20260820145216.426568665@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>

[ Upstream commit 4db6dfe62c5f76ce9eef28967c2e2000efde10d5 ]

Avoids calling memset().

Link: https://lore.kernel.org/r/20210228055645.22253-21-chaitanya.kulkarni@wdc.com
Link: https://lore.kernel.org/r/20210228055645.22253-22-chaitanya.kulkarni@wdc.com
Link: https://lore.kernel.org/r/20210228055645.22253-23-chaitanya.kulkarni@wdc.com
Reviewed-by: Mike Christie <michael.christie@oracle.com>
Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
Signed-off-by: Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Stable-dep-of: d04a179085c2 ("scsi: target: Bound PR-OUT TransportID parsing to the received buffer")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/target/target_core_pr.c |   36 +++++++++++++-----------------------
 1 file changed, 13 insertions(+), 23 deletions(-)

--- a/drivers/target/target_core_pr.c
+++ b/drivers/target/target_core_pr.c
@@ -895,9 +895,8 @@ static void core_scsi3_aptpl_reserve(
 	struct se_node_acl *node_acl,
 	struct t10_pr_registration *pr_reg)
 {
-	char i_buf[PR_REG_ISID_ID_LEN];
+	char i_buf[PR_REG_ISID_ID_LEN] = { };
 
-	memset(i_buf, 0, PR_REG_ISID_ID_LEN);
 	core_pr_dump_initiator_port(pr_reg, i_buf, PR_REG_ISID_ID_LEN);
 
 	spin_lock(&dev->dev_reservation_lock);
@@ -927,12 +926,10 @@ static int __core_scsi3_check_aptpl_regi
 {
 	struct t10_pr_registration *pr_reg, *pr_reg_tmp;
 	struct t10_reservation *pr_tmpl = &dev->t10_pr;
-	unsigned char i_port[PR_APTPL_MAX_IPORT_LEN];
-	unsigned char t_port[PR_APTPL_MAX_TPORT_LEN];
+	unsigned char i_port[PR_APTPL_MAX_IPORT_LEN] = { };
+	unsigned char t_port[PR_APTPL_MAX_TPORT_LEN] = { };
 	u16 tpgt;
 
-	memset(i_port, 0, PR_APTPL_MAX_IPORT_LEN);
-	memset(t_port, 0, PR_APTPL_MAX_TPORT_LEN);
 	/*
 	 * Copy Initiator Port information from struct se_node_acl
 	 */
@@ -1022,9 +1019,8 @@ static void __core_scsi3_dump_registrati
 	enum register_type register_type)
 {
 	struct se_portal_group *se_tpg = nacl->se_tpg;
-	char i_buf[PR_REG_ISID_ID_LEN];
+	char i_buf[PR_REG_ISID_ID_LEN] = { };
 
-	memset(&i_buf[0], 0, PR_REG_ISID_ID_LEN);
 	core_pr_dump_initiator_port(pr_reg, i_buf, PR_REG_ISID_ID_LEN);
 
 	pr_debug("SPC-3 PR [%s] Service Action: REGISTER%s Initiator"
@@ -1203,10 +1199,10 @@ static struct t10_pr_registration *core_
 	struct se_session *sess)
 {
 	struct se_portal_group *tpg = nacl->se_tpg;
-	unsigned char buf[PR_REG_ISID_LEN], *isid_ptr = NULL;
+	unsigned char buf[PR_REG_ISID_LEN] = { };
+	unsigned char *isid_ptr = NULL;
 
 	if (tpg->se_tpg_tfo->sess_get_initiator_sid != NULL) {
-		memset(&buf[0], 0, PR_REG_ISID_LEN);
 		tpg->se_tpg_tfo->sess_get_initiator_sid(sess, &buf[0],
 					PR_REG_ISID_LEN);
 		isid_ptr = &buf[0];
@@ -1284,11 +1280,10 @@ static void __core_scsi3_free_registrati
 	struct t10_reservation *pr_tmpl = &dev->t10_pr;
 	struct se_node_acl *nacl = pr_reg->pr_reg_nacl;
 	struct se_dev_entry *deve;
-	char i_buf[PR_REG_ISID_ID_LEN];
+	char i_buf[PR_REG_ISID_ID_LEN] = { };
 
 	lockdep_assert_held(&pr_tmpl->registration_lock);
 
-	memset(i_buf, 0, PR_REG_ISID_ID_LEN);
 	core_pr_dump_initiator_port(pr_reg, i_buf, PR_REG_ISID_ID_LEN);
 
 	if (!list_empty(&pr_reg->pr_reg_list))
@@ -2060,7 +2055,8 @@ core_scsi3_emulate_pro_register(struct s
 	struct se_portal_group *se_tpg;
 	struct t10_pr_registration *pr_reg, *pr_reg_p, *pr_reg_tmp;
 	struct t10_reservation *pr_tmpl = &dev->t10_pr;
-	unsigned char isid_buf[PR_REG_ISID_LEN], *isid_ptr = NULL;
+	unsigned char isid_buf[PR_REG_ISID_LEN] = { };
+	unsigned char *isid_ptr = NULL;
 	sense_reason_t ret = TCM_NO_SENSE;
 	int pr_holder = 0, type;
 
@@ -2071,7 +2067,6 @@ core_scsi3_emulate_pro_register(struct s
 	se_tpg = se_sess->se_tpg;
 
 	if (se_tpg->se_tpg_tfo->sess_get_initiator_sid) {
-		memset(&isid_buf[0], 0, PR_REG_ISID_LEN);
 		se_tpg->se_tpg_tfo->sess_get_initiator_sid(se_sess, &isid_buf[0],
 				PR_REG_ISID_LEN);
 		isid_ptr = &isid_buf[0];
@@ -2283,11 +2278,9 @@ core_scsi3_pro_reserve(struct se_cmd *cm
 	struct se_lun *se_lun = cmd->se_lun;
 	struct t10_pr_registration *pr_reg, *pr_res_holder;
 	struct t10_reservation *pr_tmpl = &dev->t10_pr;
-	char i_buf[PR_REG_ISID_ID_LEN];
+	char i_buf[PR_REG_ISID_ID_LEN] = { };
 	sense_reason_t ret;
 
-	memset(i_buf, 0, PR_REG_ISID_ID_LEN);
-
 	if (!se_sess || !se_lun) {
 		pr_err("SPC-3 PR: se_sess || struct se_lun is NULL!\n");
 		return TCM_LOGICAL_UNIT_COMMUNICATION_FAILURE;
@@ -2458,12 +2451,11 @@ static void __core_scsi3_complete_pro_re
 	int unreg)
 {
 	const struct target_core_fabric_ops *tfo = se_nacl->se_tpg->se_tpg_tfo;
-	char i_buf[PR_REG_ISID_ID_LEN];
+	char i_buf[PR_REG_ISID_ID_LEN] = { };
 	int pr_res_type = 0, pr_res_scope = 0;
 
 	lockdep_assert_held(&dev->dev_reservation_lock);
 
-	memset(i_buf, 0, PR_REG_ISID_ID_LEN);
 	core_pr_dump_initiator_port(pr_reg, i_buf, PR_REG_ISID_ID_LEN);
 	/*
 	 * Go ahead and release the current PR reservation holder.
@@ -2769,11 +2761,10 @@ static void __core_scsi3_complete_pro_pr
 {
 	struct se_node_acl *nacl = pr_reg->pr_reg_nacl;
 	const struct target_core_fabric_ops *tfo = nacl->se_tpg->se_tpg_tfo;
-	char i_buf[PR_REG_ISID_ID_LEN];
+	char i_buf[PR_REG_ISID_ID_LEN] = { };
 
 	lockdep_assert_held(&dev->dev_reservation_lock);
 
-	memset(i_buf, 0, PR_REG_ISID_ID_LEN);
 	core_pr_dump_initiator_port(pr_reg, i_buf, PR_REG_ISID_ID_LEN);
 	/*
 	 * Do an implicit RELEASE of the existing reservation.
@@ -3159,7 +3150,7 @@ core_scsi3_emulate_pro_register_and_move
 	struct t10_reservation *pr_tmpl = &dev->t10_pr;
 	unsigned char *buf;
 	const unsigned char *initiator_str;
-	char *iport_ptr = NULL, i_buf[PR_REG_ISID_ID_LEN];
+	char *iport_ptr = NULL, i_buf[PR_REG_ISID_ID_LEN] = { };
 	u32 tid_len, tmp_tid_len;
 	int new_reg = 0, type, scope, matching_iname;
 	sense_reason_t ret;
@@ -3171,7 +3162,6 @@ core_scsi3_emulate_pro_register_and_move
 		return TCM_LOGICAL_UNIT_COMMUNICATION_FAILURE;
 	}
 
-	memset(i_buf, 0, PR_REG_ISID_ID_LEN);
 	se_tpg = se_sess->se_tpg;
 	tf_ops = se_tpg->se_tpg_tfo;
 	/*


