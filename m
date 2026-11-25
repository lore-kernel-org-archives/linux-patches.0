Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795625269;
	b=L8RH9Lb93BzYlvWiYH5lHcdgmCxR15WgKK+fSpMhfqshQZKXzgemin+lNPREJBkS2tqc
	 pZoqyuUkZ3cr4Z23f+X74l/XaB60aNe3Z7Wb724RS0DOR+TZmi5foXVAHPA1u6YTCc2oQ
	 cxbdS1wW5JvDeoDAyv9UbBv1fIAyRFmD/VNTqsXEB1p48YGigmeRdbKoMyTrDTSsQbkQN
	 AN3FgXSV7kg1OMmwmBlVcccGWQq/z3pvjoJcpwSNN5wo20TzDUjJ0LE9K1G3OK5I0Zo2n
	 gB1BBWWX+aoQr2yKc+asR//trq0ro2wkw7O0NCslMO1AmFTk8Y8ulfHM22l24cfvrKw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795625269;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=XcPhUvRHiLOiZVkQShXGU++EvtgQ1soDd3G6biZdhe8=;
	b=5epnBfT0o0ULT1RUQEj9New2/aRSmNNtAahf6pn82IyyxEcoPV4VHeU09FXugHzPg1+d
	 Lo3pl81m6UIVq3R/EEw+PNDpMmaIjFRuu7MNjFXw+4sTY+1g50nwWhd5z45C4x8Y2rvs1
	 ugK2NRWuvtfL8/mf+KG5i7OjjQeTEVifS+edHNHjIRHsm2WOC0ksrfqdnLeLbBhtX/MbG
	 YRkzNvnr1Yvb4Ws89FepxhvZ9u1PqL+p9UdiiYIzDmBn+DKB9iBpAsvAh8F9W7vcQEtEG
	 rzrfl7R6jvS4l2dXUKXxL1XqaVlq580qKCDqJbt82o8mbSkwpKt2qHS+oOk34MZn4nw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=JMh5DYr9;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 73CE5606A327;
	Wed, 25 Nov 2026 16:47:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=JMh5DYr9
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 573041F000D1;
	Wed, 25 Nov 2026 16:47:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795625268;
	bh=XcPhUvRHiLOiZVkQShXGU++EvtgQ1soDd3G6biZdhe8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=JMh5DYr9JMxMnmgAxFLm0jLYEMRjr0SLRVndyq1YEVYlxw2KDHB9LduKCOGDmn2/j
	 7PRHOzMZVHp34XmJqMGQ5gP5gP2zra8BXAIw2kZeiB0EBbTAOwScCbAzC9l46Zu/N2
	 cd9EYrex21adQ4s2LB6/9FDGW7wlAI77I/p2FpP4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qing Ming <a0yami@mailbox.org>,
	Alexander Aring <aahringo@redhat.com>,
	David Teigland <teigland@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 459/816] dlm: validate node weights before building member array
Date: Wed, 25 Nov 2026 15:33:27 +0100
Message-ID: <20261125143859.817739885@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143849.205329330@linuxfoundation.org>
References: <20261125143849.205329330@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Qing Ming <a0yami@mailbox.org>

[ Upstream commit 7f662eb1807ed732ac7d5e119753c8185f241bb8 ]

DLM node weights are parsed as signed integers and copied into the member
list. make_member_array() uses their sum as the allocation count, but only
positive weights contribute entries to the array. A negative weight can
therefore reduce the allocation without reducing the number of writes.

The issue was found through static analysis of the configfs input and
member array construction. With two recovery members weighted -31 and 32,
the sum is 1, so recovery allocates one int and then writes the positive
member's node ID 32 times. A reproducer using dlm_controld and dlm_tool
triggered the same report on a KASAN kernel:

  BUG: KASAN: slab-out-of-bounds in dlm_recover_members [dlm]
  Write of size 4 by task dlm_recoverd

  Call Trace:
   dlm_recover_members
   dlm_recoverd
   kthread
   ret_from_fork

Reject negative weights at the configfs input boundary. Also detect
overflow when adding non-negative weights to the signed allocation count,
and propagate array construction errors to the recovery path.

Fixes: e7fd41792fc0 ("[DLM] The core of the DLM for GFS2/CLVM")
Signed-off-by: Qing Ming <a0yami@mailbox.org>
Assisted-by: Codex:gpt-5
Acked-by: Alexander Aring <aahringo@redhat.com>
Signed-off-by: Alexander Aring <aahringo@redhat.com>
Signed-off-by: David Teigland <teigland@redhat.com>
[ sashal: Replaced kmalloc_objs() with kmalloc_array() in make_member_array() since the older tree lacks the newer allocator helper, and dropped the early ls_total_weight assignment. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/dlm/config.c |  9 ++++++++-
 fs/dlm/member.c | 17 +++++++++++------
 2 files changed, 19 insertions(+), 7 deletions(-)

diff --git a/fs/dlm/config.c b/fs/dlm/config.c
index a523df1a1a735..e2228096f2a18 100644
--- a/fs/dlm/config.c
+++ b/fs/dlm/config.c
@@ -823,10 +823,17 @@ static ssize_t node_weight_show(struct config_item *item, char *buf)
 static ssize_t node_weight_store(struct config_item *item, const char *buf,
 				 size_t len)
 {
-	int rc = kstrtoint(buf, 0, &config_item_to_node(item)->weight);
+	struct dlm_node *node = config_item_to_node(item);
+	int weight;
+	int rc;
 
+	rc = kstrtoint(buf, 0, &weight);
 	if (rc)
 		return rc;
+	if (weight < 0)
+		return -EINVAL;
+
+	node->weight = weight;
 	return len;
 }
 
diff --git a/fs/dlm/member.c b/fs/dlm/member.c
index c9661906568a1..3a3cc358af37f 100644
--- a/fs/dlm/member.c
+++ b/fs/dlm/member.c
@@ -406,7 +406,7 @@ void dlm_clear_members_gone(struct dlm_ls *ls)
 	clear_memb_list(&ls->ls_nodes_gone, NULL);
 }
 
-static void make_member_array(struct dlm_ls *ls)
+static int make_member_array(struct dlm_ls *ls)
 {
 	struct dlm_member *memb;
 	int i, w, x = 0, total = 0, all_zero = 0, *array;
@@ -415,8 +415,8 @@ static void make_member_array(struct dlm_ls *ls)
 	ls->ls_node_array = NULL;
 
 	list_for_each_entry(memb, &ls->ls_nodes, list) {
-		if (memb->weight)
-			total += memb->weight;
+		if (check_add_overflow(total, memb->weight, &total))
+			return -EOVERFLOW;
 	}
 
 	/* all nodes revert to weight of 1 if all have weight 0 */
@@ -426,10 +426,9 @@ static void make_member_array(struct dlm_ls *ls)
 		all_zero = 1;
 	}
 
-	ls->ls_total_weight = total;
 	array = kmalloc_array(total, sizeof(*array), GFP_NOFS);
 	if (!array)
-		return;
+		return -ENOMEM;
 
 	list_for_each_entry(memb, &ls->ls_nodes, list) {
 		if (!all_zero && !memb->weight)
@@ -446,7 +445,10 @@ static void make_member_array(struct dlm_ls *ls)
 			array[x++] = memb->nodeid;
 	}
 
+	ls->ls_total_weight = total;
 	ls->ls_node_array = array;
+
+	return 0;
 }
 
 /* send a status request to all members just to establish comms connections */
@@ -606,7 +608,10 @@ int dlm_recover_members(struct dlm_ls *ls, struct dlm_recover *rv, int *neg_out)
 	}
 	ls->ls_low_nodeid = low;
 
-	make_member_array(ls);
+	error = make_member_array(ls);
+	if (error)
+		return error;
+
 	*neg_out = neg;
 
 	error = ping_members(ls, rv->seq);
-- 
2.53.0



