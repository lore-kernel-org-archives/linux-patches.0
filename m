Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E14D38E8B9;
	Sat, 12 Sep 2026 19:51:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789242673; cv=none; b=bJke0/N1nDujDocw17kBFKVxYM0uZsiNH2S4vzE1FCWI0Edf0BMsXU2NiIAVFbOV+/xWxsEQN9omDsf9TzRC2F6e5rYvbhZIeHdXGfefyRCDMirZtgJex3o9O81Pz9ZJxfPwyVKgpF6VQy8jRuMJioIb9O4OEyfexy5BR/9u7hk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789242673; c=relaxed/simple;
	bh=EqBjg678/VfURXHyENjkT3MLrIEERnevS+9nMgsA3+8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DfEzNyhahSLk2OuN2iNhnV89a+6+oScwcbJYC6G6wPjMQLu2JulCrPLlPZWiL8Dm3+Kp2r3h5WLfhyWLkr7GJ5CSy89YsPigLRrN6ikXMKLJeIqbRyMRVyxM2J75QKPrY3Z/tEFJysA9O+Cgf19cFOjhlzYyCF5qCSZUlyeauWs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qyq6PsyU; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qyq6PsyU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2A0061F000FF;
	Sat, 12 Sep 2026 19:51:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789242671;
	bh=a2xsLR16AdBQNDtXXMbHzIKa+gW/oVorlMIMfl2HibM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=qyq6PsyUgF1rPVom8nTJKlFVlXnMso1n4N/GbTs8AXP8T+Xxv008tMMq/hywSaseV
	 ZpEgH9+cv6J/js+k99pl9D8nQxq+RJP7RUlY99K1AAJae+Ozei1gOanhh7YKU+l0Nq
	 pui+N7ctkOsPZyfAVS1j7NmYTA9Kx+u4Fchv/x50=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Himanshu Madhani <himanshu.madhani@oracle.com>,
	Mike Christie <michael.christie@oracle.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 487/798] scsi: target: Remove TARGET_SCF_LOOKUP_LUN_FROM_TAG
Date: Sat, 12 Sep 2026 09:01:55 +0200
Message-ID: <20260912065528.304824191@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065516.948645775@linuxfoundation.org>
References: <20260912065516.948645775@linuxfoundation.org>
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

From: Mike Christie <michael.christie@oracle.com>

[ Upstream commit 27b0efd15d5247ada0c2ed9cbc77fd3fb3b1f26d ]

TARGET_SCF_LOOKUP_LUN_FROM_TAG is no longer used so remove it.

Link: https://lore.kernel.org/r/1604257174-4524-5-git-send-email-michael.christie@oracle.com
Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>
Signed-off-by: Mike Christie <michael.christie@oracle.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Stable-dep-of: ef63cc441703 ("RDMA/srpt: Pass the mapped task attribute to target_init_cmd()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/target/target_core_transport.c | 33 --------------------------
 include/target/target_core_base.h      |  1 -
 2 files changed, 34 deletions(-)

diff --git a/drivers/target/target_core_transport.c b/drivers/target/target_core_transport.c
index ddcfd5c17d96e..2fd2a513c6b96 100644
--- a/drivers/target/target_core_transport.c
+++ b/drivers/target/target_core_transport.c
@@ -1771,29 +1771,6 @@ static void target_complete_tmr_failure(struct work_struct *work)
 	transport_cmd_check_stop_to_fabric(se_cmd);
 }
 
-static bool target_lookup_lun_from_tag(struct se_session *se_sess, u64 tag,
-				       u64 *unpacked_lun)
-{
-	struct se_cmd *se_cmd;
-	unsigned long flags;
-	bool ret = false;
-
-	spin_lock_irqsave(&se_sess->sess_cmd_lock, flags);
-	list_for_each_entry(se_cmd, &se_sess->sess_cmd_list, se_cmd_list) {
-		if (se_cmd->se_cmd_flags & SCF_SCSI_TMR_CDB)
-			continue;
-
-		if (se_cmd->tag == tag) {
-			*unpacked_lun = se_cmd->orig_fe_lun;
-			ret = true;
-			break;
-		}
-	}
-	spin_unlock_irqrestore(&se_sess->sess_cmd_lock, flags);
-
-	return ret;
-}
-
 /**
  * target_submit_tmr - lookup unpacked lun and submit uninitialized se_cmd
  *                     for TMR CDBs
@@ -1841,16 +1818,6 @@ int target_submit_tmr(struct se_cmd *se_cmd, struct se_session *se_sess,
 		core_tmr_release_req(se_cmd->se_tmr_req);
 		return ret;
 	}
-	/*
-	 * If this is ABORT_TASK with no explicit fabric provided LUN,
-	 * go ahead and search active session tags for a match to figure
-	 * out unpacked_lun for the original se_cmd.
-	 */
-	if (tm_type == TMR_ABORT_TASK && (flags & TARGET_SCF_LOOKUP_LUN_FROM_TAG)) {
-		if (!target_lookup_lun_from_tag(se_sess, tag,
-						&se_cmd->orig_fe_lun))
-			goto failure;
-	}
 
 	ret = transport_lookup_tmr_lun(se_cmd);
 	if (ret)
diff --git a/include/target/target_core_base.h b/include/target/target_core_base.h
index e681c712fcca2..83b685dab2675 100644
--- a/include/target/target_core_base.h
+++ b/include/target/target_core_base.h
@@ -195,7 +195,6 @@ enum target_sc_flags_table {
 	TARGET_SCF_ACK_KREF		= 0x02,
 	TARGET_SCF_UNKNOWN_SIZE		= 0x04,
 	TARGET_SCF_USE_CPUID		= 0x08,
-	TARGET_SCF_LOOKUP_LUN_FROM_TAG	= 0x10,
 };
 
 /* fabric independent task management function values */
-- 
2.53.0



