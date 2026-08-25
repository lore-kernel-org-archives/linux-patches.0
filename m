Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E8EB2ED154;
	Tue, 25 Aug 2026 13:40:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787665254; cv=none; b=kNbQizSlm+pfF3K57T1axcGj26ce5yxY9O3n+f/8PNKv/cNYJTtfpnWhMMrZEVQGx+KUUndZEMGk8xeuvlM2Qnjcz4C9DRqcrv7GDdMsYiC/Hj23rc8fvvSIN1l/Jl40CCTzmtl9eV8FmBjCcHUzF7Wje/TWkp2BFTAQCocz52A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787665254; c=relaxed/simple;
	bh=Z77tF7GrkRvs33AEJnXipM3leMA6I+DnXLXZQCkXy6s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gfTKO4DTFv0PlDnNJsq+uDGHw1DwSiqc99pCcBw74wD0AGj+fWn3eGrcFmhlBcwNf/H066510g2F2DTKfNslthnrqgWuQxhq6jnDWBxOFaxEahn2ZBnFLxHol8h8gcPK2bORu5JI2xR1ghk0lGiKsLsMuFTfyZNhI4aTw7iwOLo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tRUukmfU; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tRUukmfU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A749A1F00A3A;
	Tue, 25 Aug 2026 13:40:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787665253;
	bh=XTSlBQgqmHYWx7eSpfb/eAfEd/1Lg/5GJ58b8IWstpY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=tRUukmfUaGgYOw8mTGI+KL+iPPqjnL+LSed9xDBU5bzIDAAUGgp+5fb+fLaIEkQxL
	 Ul4HCGyJgubOohwaZ8qeKCpnJc1Eb06VoVcSwd2nKugyo2ko9R921lcZ4T9HPWtz4q
	 zafo7Q3Z/hDc9PP0yZMlTeBC2ro+oyBn36figOvI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mat Martineau <martineau@kernel.org>,
	"Matthieu Baerts (NGI0)" <matttbe@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 58/94] mptcp: pm: rename add_entry structure to add_addr
Date: Tue, 25 Aug 2026 15:25:54 +0200
Message-ID: <20260825132544.170748505@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260825132541.887883084@linuxfoundation.org>
References: <20260825132541.887883084@linuxfoundation.org>
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

From: "Matthieu Baerts (NGI0)" <matttbe@kernel.org>

[ Upstream commit 350d76dd6e79468ac85767f2d236299a135572df ]

Using only the 'add' prefix is confusing: does it refer to a generic
added entry or address, or specifically to ADD_ADDRs. Using add_addr
removes this confusion.

Reviewed-by: Mat Martineau <martineau@kernel.org>
Signed-off-by: Matthieu Baerts (NGI0) <matttbe@kernel.org>
Link: https://patch.msgid.link/20260605-net-next-mptcp-add-addr6-port-ts-v2-10-758e7ca73f4d@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Stable-dep-of: efc33b5102ff ("mptcp: pm: fix memory leak from alloc-during-teardown race")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/mptcp/pm.c       |   22 +++++++++++-----------
 net/mptcp/protocol.h |    2 +-
 2 files changed, 12 insertions(+), 12 deletions(-)

--- a/net/mptcp/pm.c
+++ b/net/mptcp/pm.c
@@ -12,7 +12,7 @@
 
 #define ADD_ADDR_RETRANS_MAX	3
 
-struct mptcp_pm_add_entry {
+struct mptcp_pm_add_addr {
 	struct list_head	list;
 	struct mptcp_addr_info	addr;
 	u8			retrans_times;
@@ -133,11 +133,11 @@ bool mptcp_pm_has_subflow_saddr(const st
 	return false;
 }
 
-static struct mptcp_pm_add_entry *
+static struct mptcp_pm_add_addr *
 mptcp_lookup_anno_list_by_saddr(const struct mptcp_sock *msk,
 				const struct mptcp_addr_info *addr)
 {
-	struct mptcp_pm_add_entry *entry;
+	struct mptcp_pm_add_addr *entry;
 
 	lockdep_assert_held(&msk->pm.lock);
 
@@ -152,7 +152,7 @@ mptcp_lookup_anno_list_by_saddr(const st
 bool mptcp_remove_anno_list_by_saddr(struct mptcp_sock *msk,
 				     const struct mptcp_addr_info *addr)
 {
-	struct mptcp_pm_add_entry *entry;
+	struct mptcp_pm_add_addr *entry;
 	bool ret;
 
 	entry = mptcp_pm_del_add_timer(msk, addr, false);
@@ -164,7 +164,7 @@ bool mptcp_remove_anno_list_by_saddr(str
 
 bool mptcp_pm_sport_in_anno_list(struct mptcp_sock *msk, const struct sock *sk)
 {
-	struct mptcp_pm_add_entry *entry;
+	struct mptcp_pm_add_addr *entry;
 	struct mptcp_addr_info saddr;
 	bool ret = false;
 
@@ -340,8 +340,8 @@ static unsigned int mptcp_adjust_add_add
 
 static void mptcp_pm_add_timer(struct timer_list *timer)
 {
-	struct mptcp_pm_add_entry *entry = timer_container_of(entry, timer,
-							      add_timer);
+	struct mptcp_pm_add_addr *entry = timer_container_of(entry, timer,
+							     add_timer);
 	struct mptcp_sock *msk = entry->sock;
 	struct sock *sk = (struct sock *)msk;
 	unsigned int timeout = 0;
@@ -399,12 +399,12 @@ out:
 	sock_put(sk);
 }
 
-struct mptcp_pm_add_entry *
+struct mptcp_pm_add_addr *
 mptcp_pm_del_add_timer(struct mptcp_sock *msk,
 		       const struct mptcp_addr_info *addr, bool check_id)
 {
-	struct mptcp_pm_add_entry *entry;
 	struct sock *sk = (struct sock *)msk;
+	struct mptcp_pm_add_addr *entry;
 	bool stop_timer = false;
 
 	rcu_read_lock();
@@ -436,7 +436,7 @@ mptcp_pm_del_add_timer(struct mptcp_sock
 bool mptcp_pm_alloc_anno_list(struct mptcp_sock *msk,
 			      const struct mptcp_addr_info *addr)
 {
-	struct mptcp_pm_add_entry *add_entry = NULL;
+	struct mptcp_pm_add_addr *add_entry = NULL;
 	struct sock *sk = (struct sock *)msk;
 	unsigned int timeout;
 
@@ -473,7 +473,7 @@ reset_timer:
 
 static void mptcp_pm_free_anno_list(struct mptcp_sock *msk)
 {
-	struct mptcp_pm_add_entry *entry, *tmp;
+	struct mptcp_pm_add_addr *entry, *tmp;
 	struct sock *sk = (struct sock *)msk;
 	LIST_HEAD(free_list);
 
--- a/net/mptcp/protocol.h
+++ b/net/mptcp/protocol.h
@@ -1084,7 +1084,7 @@ int mptcp_pm_mp_prio_send_ack(struct mpt
 bool mptcp_pm_alloc_anno_list(struct mptcp_sock *msk,
 			      const struct mptcp_addr_info *addr);
 bool mptcp_pm_sport_in_anno_list(struct mptcp_sock *msk, const struct sock *sk);
-struct mptcp_pm_add_entry *
+struct mptcp_pm_add_addr *
 mptcp_pm_del_add_timer(struct mptcp_sock *msk,
 		       const struct mptcp_addr_info *addr, bool check_id);
 bool mptcp_pm_has_subflow_saddr(const struct mptcp_sock *msk,


