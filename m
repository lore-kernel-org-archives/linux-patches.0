Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795043779;
	b=yOmNprRdwuiJwSlyiiHd1SVnzo4evXXJkHVsf/AixV081bDsSiEm1sfC3mN7sBk6SbWt
	 OoiG2NUW2CGsZRXQbjARbRMe+26pHBnLjEiWznNPm8El5IBS/X3sfpQkHzpB3ej4TRBI+
	 VmGrGFiVxrLePE3WW6h7JZHecQw3MC7bczwgJHOAVkQTbFAGW3cXbJCLvT7/Q7bYY+1G/
	 elYCsqXz1Jl1KKmTDRazemHhsZ1E7RqFq9yy5E6CnfqlEwTd5XmYlAeto42ToBHhYeBN1
	 v89KSVRaF3DKjfJa4rFgXbVNAarsZMJzHmJxnikw3uyZSfwBViXzq6CqtDU5ui7uSDg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795043779;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Zbtc7T5pLYBRi/GdP86pM3U8jCbiw2xSkOfex/cWV8o=;
	b=SBqv+KUlG4gkF5vf0+f5y60xQTlnOeHjmpY/74Axq7dZzX+8xOe0km6u5p8KYsaht3WD
	 xWKK4oArXYW0k8dIVz6XRXFSCdo7PXEc59QFMx7b7nUoBA1inho5YoegQW5yMDCNnNjJc
	 U50+5wRcHYFh2fcoR/wlOwT7rKSAyxM3CjVjJt4tAjkLMRNKEHqJxEYCJ5WbZpnVh9mJO
	 8hyGEudTCUM/jKJOrQMkX3qKM8uld04/QhAIkhFdZjbTFQK2+jB6fz5v5GqfTPs4pa0cL
	 aA4ofZdq6GAiQUTbYA4aFyvI+mA4sLpz0b9eaY9dmuAxvT5RqwrNJuSjLOINf02SEQQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=kbCxndPG;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AEC16606A32A;
	Wed, 18 Nov 2026 23:16:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=kbCxndPG
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0719A1F000C4;
	Wed, 18 Nov 2026 23:16:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795043779;
	bh=Zbtc7T5pLYBRi/GdP86pM3U8jCbiw2xSkOfex/cWV8o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=kbCxndPGScuPKNTicjmf9URJMZURQcBRKD7RAJN9mDMwf7ASIwoURGoUawVHtrsgE
	 u/MmHGspRGZtqoyJ0qQ8ebvKcCeeeDRN9nYXtAx3k+B68GGJiZlOEdbgQ4HYiaycST
	 cBqIjNj1x/viA3cbgP9g+d2aEpGnoWgz1D9M1NrY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Max Kellermann <max.kellermann@ionos.com>,
	Zhang Yi <yi.zhang@huawei.com>,
	Jan Kara <jack@suse.cz>,
	Theodore Tso <tytso@mit.edu>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0333/2857] jbd2: bound shrinker scans by examined checkpoint buffers
Date: Wed, 18 Nov 2026 15:22:47 +0100
Message-ID: <20261118150213.428884926@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

From: Max Kellermann <max.kellermann@ionos.com>

[ Upstream commit 15cb16496446b94e67f7abcb049b8e2c75cd3d02 ]

The jbd2 shrinker currently accounts only checkpoint buffers that it
successfully releases against nr_to_scan.  Busy buffers therefore do not
consume the scan budget.

If a checkpoint transaction contains mostly busy buffers, the shrinker
can scan its entire checkpoint list while holding journal->j_list_lock.
Large checkpoint lists can result in excessive lock hold times and leave
other CPUs spinning on j_list_lock, causing soft lockups or RCU stalls.

Pass nr_to_scan into journal_shrink_one_cp_list() and decrement it for
every buffer examined, including busy buffers.  Pass NULL from checkpoint
cleanup paths so their existing full-list behavior is preserved.

This restores the scan-budget semantics that existed before
journal_shrink_one_cp_list() was changed to always scan a complete
checkpoint list.

Fixes: b98dba273a0e ("jbd2: remove journal_clean_one_cp_list()")
Cc: stable@vger.kernel.org
Signed-off-by: Max Kellermann <max.kellermann@ionos.com>
Reviewed-by: Zhang Yi <yi.zhang@huawei.com>
Reviewed-by: Jan Kara <jack@suse.cz>
Link: https://patch.msgid.link/20260713102229.1598812-3-max.kellermann@ionos.com
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/jbd2/checkpoint.c | 25 +++++++++++++------------
 1 file changed, 13 insertions(+), 12 deletions(-)

diff --git a/fs/jbd2/checkpoint.c b/fs/jbd2/checkpoint.c
index a888357a29964..7f414655a71a3 100644
--- a/fs/jbd2/checkpoint.c
+++ b/fs/jbd2/checkpoint.c
@@ -370,15 +370,16 @@ int jbd2_cleanup_journal_tail(journal_t *journal)
 /*
  * journal_shrink_one_cp_list
  *
- * Find all the written-back checkpoint buffers in the given list
- * and try to release them. If the whole transaction is released, set
- * the 'released' parameter. Return the number of released checkpointed
- * buffers.
+ * Find written-back checkpoint buffers in the given list and try to release
+ * them. If 'nr_to_scan' is set, scan at most that many buffers. If the whole
+ * transaction is released, set the 'released' parameter. Return the number of
+ * released checkpointed buffers.
  *
  * Called with j_list_lock held.
  */
 static unsigned long journal_shrink_one_cp_list(struct journal_head *jh,
 						enum jbd2_shrink_type type,
+						unsigned long *nr_to_scan,
 						bool *released)
 {
 	struct journal_head *last_jh;
@@ -387,13 +388,15 @@ static unsigned long journal_shrink_one_cp_list(struct journal_head *jh,
 	int ret;
 
 	*released = false;
-	if (!jh)
+	if (!jh || (nr_to_scan && !*nr_to_scan))
 		return 0;
 
 	last_jh = jh->b_cpprev;
 	do {
 		jh = next_jh;
 		next_jh = jh->b_cpnext;
+		if (nr_to_scan)
+			(*nr_to_scan)--;
 
 		if (type == JBD2_SHRINK_DESTROY) {
 			ret = __jbd2_journal_remove_checkpoint(jh);
@@ -415,7 +418,7 @@ static unsigned long journal_shrink_one_cp_list(struct journal_head *jh,
 next:
 		if (need_resched())
 			break;
-	} while (jh != last_jh);
+	} while (jh != last_jh && (!nr_to_scan || *nr_to_scan));
 
 	return nr_freed;
 }
@@ -437,7 +440,6 @@ unsigned long jbd2_journal_shrink_checkpoint_list(journal_t *journal,
 	tid_t first_tid = 0, last_tid = 0, next_tid = 0;
 	tid_t tid = 0;
 	unsigned long nr_freed = 0;
-	unsigned long freed;
 	bool first_set = false;
 
 again:
@@ -470,10 +472,9 @@ unsigned long jbd2_journal_shrink_checkpoint_list(journal_t *journal,
 		next_transaction = transaction->t_cpnext;
 		tid = transaction->t_tid;
 
-		freed = journal_shrink_one_cp_list(transaction->t_checkpoint_list,
-						   JBD2_SHRINK_BUSY_SKIP, &released);
-		nr_freed += freed;
-		(*nr_to_scan) -= min(*nr_to_scan, freed);
+		nr_freed += journal_shrink_one_cp_list(transaction->t_checkpoint_list,
+						       JBD2_SHRINK_BUSY_SKIP,
+						       nr_to_scan, &released);
 		if (*nr_to_scan == 0)
 			break;
 		if (need_resched() || spin_needbreak(&journal->j_list_lock))
@@ -529,7 +530,7 @@ void __jbd2_journal_clean_checkpoint_list(journal_t *journal,
 		transaction = next_transaction;
 		next_transaction = transaction->t_cpnext;
 		journal_shrink_one_cp_list(transaction->t_checkpoint_list,
-					   type, &released);
+					   type, NULL, &released);
 		/*
 		 * This function only frees up some memory if possible so we
 		 * dont have an obligation to finish processing. Bail out if
-- 
2.53.0



