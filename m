Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 83F362D73A6;
	Sat, 17 Oct 2026 16:54:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792256060; cv=none; b=ZZb2Td6Hd6/jIB0hjoh1DAER0aHlxxFmKIqskMiQzF4TAlf98xYeIDbZjc8zfr0m1lprei2l5zQJqhqwXYPwuiG/aU7ptUSwWa2a7pjyiLaYQTK4FLR0d7DUybOrJaSTl93WzE2WpMltIdBbbAZlBIGec9QnByjI9QTlWYnYNUM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792256060; c=relaxed/simple;
	bh=c7CU/wTKekoDZvl38aB9Webjvnlpg2yy1a+7cxx3xBM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Joy1vVkEFkvzYdLXWU1BBiM/OeenLtLPHVXo/ZEuSI4hL9S2fla1CDPaoRj9niDymR5Bm2jTWSVKp0uTtvauNIBQgV1hUxOhpVpkqov4UQGrXWkHuqKsZw+B+844SZTwXoYD7Zxhes0bvGNOzwBr6eAT9Oc4Q2j/aI1bvoXgklw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jfP/HBcM; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jfP/HBcM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D08241F000C4;
	Sat, 17 Oct 2026 16:54:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792256059;
	bh=2CKEQgjFaWTxFkxq/4DAzcpYu2fqSqjuDcVBvGOHeZI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jfP/HBcMeE21aw/cD7vd3wctCXAAgcLi9P4pNs9UCrTzmA9UbBWzPCAWojqDN5HCp
	 f/9TLDxalJIcCqLnQmSbtgNYpmG7X9qVfl9XhnZROtW1Pm0WTMZUcH14PspzfGdkL4
	 ej3L9PKnUguiBa0cOLcoioTmY5myltcOWCpqMr1c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Geliang Tang <tanggeliang@kylinos.cn>,
	"Matthieu Baerts (NGI0)" <matttbe@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0109/1674] mptcp: pm: drop match in userspace_pm_append_new_local_addr
Date: Sat, 17 Oct 2026 17:39:41 +0200
Message-ID: <20261017160433.950675973@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Geliang Tang <tanggeliang@kylinos.cn>

[ Upstream commit 640e3d69d0bc70d7d3de34800a1640793262bd08 ]

The variable 'match' in mptcp_userspace_pm_append_new_local_addr() is a
redundant one, and this patch drops it.

No need to define 'match' as 'struct mptcp_pm_addr_entry *' type. In this
function, it's only used to check whether it's NULL. It can be defined as
a Boolean one.

Also other variables 'addr_match' and 'id_match' make 'match' a redundant
one, which can be replaced by directly checking 'addr_match && id_match'.

Signed-off-by: Geliang Tang <tanggeliang@kylinos.cn>
Reviewed-by: Matthieu Baerts (NGI0) <matttbe@kernel.org>
Signed-off-by: Matthieu Baerts (NGI0) <matttbe@kernel.org>
Link: https://patch.msgid.link/20250221-net-next-mptcp-pm-misc-cleanup-3-v1-5-2b70ab1cee79@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Stable-dep-of: f9f0068e8813 ("mptcp: pm: userspace: fix address ID overflow")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/mptcp/pm_userspace.c | 11 +++--------
 1 file changed, 3 insertions(+), 8 deletions(-)

diff --git a/net/mptcp/pm_userspace.c b/net/mptcp/pm_userspace.c
index 12dd30d63c717..bfcef17fe9dda 100644
--- a/net/mptcp/pm_userspace.c
+++ b/net/mptcp/pm_userspace.c
@@ -40,7 +40,6 @@ static int mptcp_userspace_pm_append_new_local_addr(struct mptcp_sock *msk,
 						    bool needs_id)
 {
 	DECLARE_BITMAP(id_bitmap, MPTCP_PM_MAX_ADDR_ID + 1);
-	struct mptcp_pm_addr_entry *match = NULL;
 	struct sock *sk = (struct sock *)msk;
 	struct mptcp_pm_addr_entry *e;
 	bool addr_match = false;
@@ -59,16 +58,12 @@ static int mptcp_userspace_pm_append_new_local_addr(struct mptcp_sock *msk,
 		if (addr_match && entry->addr.id == 0 && needs_id)
 			entry->addr.id = e->addr.id;
 		id_match = (e->addr.id == entry->addr.id);
-		if (addr_match && id_match) {
-			match = e;
+		if (addr_match || id_match)
 			break;
-		} else if (addr_match || id_match) {
-			break;
-		}
 		__set_bit(e->addr.id, id_bitmap);
 	}
 
-	if (!match && !addr_match && !id_match) {
+	if (!addr_match && !id_match) {
 		/* Memory for the entry is allocated from the
 		 * sock option buffer.
 		 */
@@ -86,7 +81,7 @@ static int mptcp_userspace_pm_append_new_local_addr(struct mptcp_sock *msk,
 		list_add_tail_rcu(&e->list, &msk->pm.userspace_pm_local_addr_list);
 		msk->pm.local_addr_used++;
 		ret = e->addr.id;
-	} else if (match) {
+	} else if (addr_match && id_match) {
 		ret = entry->addr.id;
 	}
 
-- 
2.53.0



