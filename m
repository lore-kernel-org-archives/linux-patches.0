Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8FCCD51DAFC;
	Wed, 30 Sep 2026 17:44:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790790271; cv=none; b=H3T3ivEJnffhuvXSJBheTgfcUTpaDHl2fnaJoem/VbwUhMlvj0eeFoTZqszsw0TAHgvxu0sMc1aaXcLk9GpLDVySqPbG62fO+GKVEE5rGX/B5/B96ihOapjF7Esab12+x2x9ArFfO/Ms3e7EnYbm1NNUQlmmdLqUnm5tP7N7qDo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790790271; c=relaxed/simple;
	bh=uZ2TWGjlVhRdm12WZ8hpImmTYfiP5wSe0u1bpaMjfM0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LO7SlT7TebxKPbqETAGj568PBq8RoLklhKuir0rhenZVv4hYr3/mGq/hjDfwcTxjBIulEzKLjQDqZiDXTP4fzWdb+c66tRO75MrpWXV/SZwZYGcRX3XbXlIj4K8Y2B+dro0S4dcZZfDhmwpqsza8mSHZ2WwLPm4OS/0Q2NyWDB0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BvMXrJrS; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BvMXrJrS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EC1571F0089C;
	Wed, 30 Sep 2026 17:44:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790790270;
	bh=eAu2fK5ISe4jS+35DDJaHbLOTMN/nLzHakqqixQ7AHU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=BvMXrJrSMHPy2zF6YDcBB2D/PHjyFSGLhal5gv1fvQ3uMBVFoiDRG+kEnpT62GjOf
	 nC1p5+ShiSjPCBcMNsSEnWtbBSfIeE4DMwpyCSoOV4K6PVZMYANiX0eNVuq8LtRmod
	 1oLeDXKMFH0s0Gkkj7AzvWQcstJvlgO4MmIE7RmE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mat Martineau <martineau@kernel.org>,
	"Matthieu Baerts (NGI0)" <matttbe@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 769/877] mptcp: pm: rename add_entry structure to add_addr
Date: Wed, 30 Sep 2026 17:28:00 +0200
Message-ID: <20260930152431.303197936@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152414.738996857@linuxfoundation.org>
References: <20260930152414.738996857@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: "Matthieu Baerts (NGI0)" <matttbe@kernel.org>

[ Upstream commit 350d76dd6e79468ac85767f2d236299a135572df ]

Using only the 'add' prefix is confusing: does it refer to a generic
added entry or address, or specifically to ADD_ADDRs. Using add_addr
removes this confusion.

Reviewed-by: Mat Martineau <martineau@kernel.org>
Signed-off-by: Matthieu Baerts (NGI0) <matttbe@kernel.org>
Link: https://patch.msgid.link/20260605-net-next-mptcp-add-addr6-port-ts-v2-10-758e7ca73f4d@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>

Stable backport adaptation for 2ac7d6e620764f1fc79eb4edd3610a7a661981ca:

The stable tree retains the ADD_ADDR announcement structure and helpers
in pm_kernel.c, renamed from pm_netlink.c by the preceding dependency.
Apply the structure-tag rename to those existing definitions and users
instead of importing the upstream helper block into pm.c.

Update both return-type declarations in protocol.h: the announcement
lookup is still externally visible on this branch. Preserve the stable
function bodies, timer APIs, allocation APIs and linkage; no functions
are added. The target's ID0 removal hunks apply unchanged to pm_kernel.c.

[ sashal: Reduced backport -- upstream 350d76dd6e794 touches 2 file(s), this
  backport carries 2. Not backported here:
  net/mptcp/pm.c
  This note is generated from the file lists only; see the resolution record
  for the reasoning. ]

Stable-dep-of: 2ac7d6e62076 ("mptcp: pm: kernel: drop pending ADD_ADDR when removing ID0")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/mptcp/pm_kernel.c |   20 ++++++++++----------
 net/mptcp/protocol.h  |    4 ++--
 2 files changed, 12 insertions(+), 12 deletions(-)

--- a/net/mptcp/pm_kernel.c
+++ b/net/mptcp/pm_kernel.c
@@ -18,7 +18,7 @@
 
 static int pm_nl_pernet_id;
 
-struct mptcp_pm_add_entry {
+struct mptcp_pm_add_addr {
 	struct list_head	list;
 	struct mptcp_addr_info	addr;
 	u8			retrans_times;
@@ -253,11 +253,11 @@ bool mptcp_pm_nl_check_work_pending(stru
 	return true;
 }
 
-struct mptcp_pm_add_entry *
+struct mptcp_pm_add_addr *
 mptcp_lookup_anno_list_by_saddr(const struct mptcp_sock *msk,
 				const struct mptcp_addr_info *addr)
 {
-	struct mptcp_pm_add_entry *entry;
+	struct mptcp_pm_add_addr *entry;
 
 	lockdep_assert_held(&msk->pm.lock);
 
@@ -271,7 +271,7 @@ mptcp_lookup_anno_list_by_saddr(const st
 
 bool mptcp_pm_sport_in_anno_list(struct mptcp_sock *msk, const struct sock *sk)
 {
-	struct mptcp_pm_add_entry *entry;
+	struct mptcp_pm_add_addr *entry;
 	struct mptcp_addr_info saddr;
 	bool ret = false;
 
@@ -292,7 +292,7 @@ out:
 
 static void mptcp_pm_add_timer(struct timer_list *timer)
 {
-	struct mptcp_pm_add_entry *entry = from_timer(entry, timer, add_timer);
+	struct mptcp_pm_add_addr *entry = from_timer(entry, timer, add_timer);
 	struct mptcp_sock *msk = entry->sock;
 	struct sock *sk = (struct sock *)msk;
 	unsigned int timeout = 0;
@@ -353,11 +353,11 @@ out:
 	sock_put(sk);
 }
 
-struct mptcp_pm_add_entry *
+struct mptcp_pm_add_addr *
 mptcp_pm_del_add_timer(struct mptcp_sock *msk,
 		       const struct mptcp_addr_info *addr, bool check_id)
 {
-	struct mptcp_pm_add_entry *entry;
+	struct mptcp_pm_add_addr *entry;
 	struct sock *sk = (struct sock *)msk;
 	bool stop_timer = false;
 
@@ -390,7 +390,7 @@ mptcp_pm_del_add_timer(struct mptcp_sock
 bool mptcp_pm_alloc_anno_list(struct mptcp_sock *msk,
 			      const struct mptcp_addr_info *addr)
 {
-	struct mptcp_pm_add_entry *add_entry = NULL;
+	struct mptcp_pm_add_addr *add_entry = NULL;
 	struct sock *sk = (struct sock *)msk;
 	struct net *net = sock_net(sk);
 	unsigned int timeout;
@@ -431,7 +431,7 @@ reset_timer:
 
 void mptcp_pm_free_anno_list(struct mptcp_sock *msk)
 {
-	struct mptcp_pm_add_entry *entry, *tmp;
+	struct mptcp_pm_add_addr *entry, *tmp;
 	struct sock *sk = (struct sock *)msk;
 	LIST_HEAD(free_list);
 
@@ -1575,7 +1575,7 @@ out_free:
 static bool mptcp_pm_announced_remove(struct mptcp_sock *msk,
 				      const struct mptcp_addr_info *addr)
 {
-	struct mptcp_pm_add_entry *entry;
+	struct mptcp_pm_add_addr *entry;
 
 	entry = mptcp_pm_del_add_timer(msk, addr, false);
 	if (entry) {
--- a/net/mptcp/protocol.h
+++ b/net/mptcp/protocol.h
@@ -1049,10 +1049,10 @@ bool mptcp_pm_alloc_anno_list(struct mpt
 			      const struct mptcp_addr_info *addr);
 void mptcp_pm_free_anno_list(struct mptcp_sock *msk);
 bool mptcp_pm_sport_in_anno_list(struct mptcp_sock *msk, const struct sock *sk);
-struct mptcp_pm_add_entry *
+struct mptcp_pm_add_addr *
 mptcp_pm_del_add_timer(struct mptcp_sock *msk,
 		       const struct mptcp_addr_info *addr, bool check_id);
-struct mptcp_pm_add_entry *
+struct mptcp_pm_add_addr *
 mptcp_lookup_anno_list_by_saddr(const struct mptcp_sock *msk,
 				const struct mptcp_addr_info *addr);
 int mptcp_pm_set_flags(struct sk_buff *skb, struct genl_info *info);


