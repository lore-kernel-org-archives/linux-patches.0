Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795622534;
	b=jvfF8J2CTzmcEV3FtRmLEpXNdry1NALpdjRk1UZr94mjwY/gu1zjgqgk1by4Iko3ZXkZ
	 yFfyuYNB/C4SL9rGJUU0o/a1QXh5Yv+DXK+e7WCk2/he2LyqUHBsFATZUop78FONAQsW5
	 vnF5AHj7Wt4m7vrZ19ANljGOLzX0CVIWqkW/k2lnEMxWJq/HXvf6HwVLnUL0QCxrGasu1
	 lkAnr3hhdEhMtRXNMplyNyM9EjPKLJLXklmK5DVN77HQ9Ku9PkLBSOzYl75IFJTWlRsBG
	 E8tV0DaTloffZbtTokVyfcufTFAbAovP4Kkr/sjgclzC4XNdXhSC4hnHTjOSUCZjjIQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795622534;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=v9oVA0mrVglkoK9tLh+oxUKr7vCTEcvNtj8k4L3qC6A=;
	b=qqmAYELjNwzwpKpyK1y1sgtkJcrkA2gTn0pzlldVPp1AUdF3fMfQqqP082kr7MuaB2Mz
	 a2SeX9fWk7zZ3zI0LSfSlPd4WNHQCeJVsFkx5bRTzanzk6Ng0a+MOq+SpJgooT8praXzO
	 FvrnLA9utCBI8PjJR3f34725+kc4fsyXDL/uGJiXvJuZ7Fm4WvaSOE2PXPNmWPRVq5JKn
	 Veqzkn1CKUVvUmdYTPAk6YLdMg2rsUnqXr1yehn1W4p04S+lDrEhXjYBL7wcWdpAOAhuM
	 GTkg2GQQJ+DKRf4XeLU1sEMkQy93+2weVs3nUUhIKOqVgKrRE6z8WEvK6HHYUQiLBUA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=f1gZ93TR;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 55FC0606A323;
	Wed, 25 Nov 2026 16:02:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=f1gZ93TR
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4C3331F000C4;
	Wed, 25 Nov 2026 16:02:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795622533;
	bh=v9oVA0mrVglkoK9tLh+oxUKr7vCTEcvNtj8k4L3qC6A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=f1gZ93TR9EkK8PN1GLpzL4s51IQJ139SlTumIScPT+ufN1cKLli8UXVgldqrJgBtP
	 6MJHhkNvK6k9AKGzYr/84+oCe8GEfmcWBA9eE/XQ+1czUQNuDm6p4ltVkrTv27P3sZ
	 7IRVbvhX3od0YcfBvnSH6VLm/Dz750t/bdJSa8vc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qing Ming <a0yami@mailbox.org>,
	Alexander Aring <aahringo@redhat.com>,
	David Teigland <teigland@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 568/990] dlm: validate node weights before building member array
Date: Wed, 25 Nov 2026 15:32:15 +0100
Message-ID: <20261125143835.401174280@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143822.072087159@linuxfoundation.org>
References: <20261125143822.072087159@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
[ sashal: Kept the branch's kmalloc_array() allocation in make_member_array() where upstream context uses kmalloc_objs(), and dropped the early ls_total_weight assignment. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/dlm/config.c |  9 ++++++++-
 fs/dlm/member.c | 17 +++++++++++------
 2 files changed, 19 insertions(+), 7 deletions(-)

diff --git a/fs/dlm/config.c b/fs/dlm/config.c
index 0db5ce43425ca..8ea193017ee98 100644
--- a/fs/dlm/config.c
+++ b/fs/dlm/config.c
@@ -857,10 +857,17 @@ static ssize_t node_weight_show(struct config_item *item, char *buf)
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
index c0f557a80a754..c33782235d1b1 100644
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
@@ -621,7 +623,10 @@ int dlm_recover_members(struct dlm_ls *ls, struct dlm_recover *rv, int *neg_out)
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



