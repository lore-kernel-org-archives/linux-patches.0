Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C0C721AC8BB;
	Thu, 15 Aug 2024 14:03:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723730595; cv=none; b=kb2uBfiRP23lANktPelDBZuweyAi7iZ7IzL7DMEQtJiIUl1TRB7OLo4pi5DxtDhQujZrZLhxSmpMrAljwhTo2fQ9BBSOIZ8hcGT2iMoobSpvSuaSj5tdv95X5MKq0s9TfG3iWJBHYCu0Pt27GE2S4hsUmQW0gBloEvSIQ1wcgbE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723730595; c=relaxed/simple;
	bh=+Y6zODpny3+SSn0zxJm3jdqPTbuYGHAeiAAIOLSyXGQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Z8N6LkQdw6oEl4ztJN2y8MBy2E9kNevRHZ+xeWYIx3DqLFVyXQt0/IWd0E67XvUjqhD0Q+Cxi7Of9gHv2wDlfdnRJ8l0K2NJ8u0bvvFecXzKT0eDT9VM+1vePCghLM1RbhC3H3w55OO9uPfPN2VBBhUvePSaBamQTbbpt5ZHJbY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nKM7w12g; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nKM7w12g"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3402AC32786;
	Thu, 15 Aug 2024 14:03:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723730595;
	bh=+Y6zODpny3+SSn0zxJm3jdqPTbuYGHAeiAAIOLSyXGQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nKM7w12gzUaP8hr249idt7I01qQ9hp8KvEfx9qyKPWaBWWEVLF++CG7CbuEUCIAOj
	 tFdxcoVyMG4gEyIrCdjywnEoweH2VVVqVquKrOhEtqcCGIkd6S6hAycmL1iCU+1Eyv
	 6z3U9twPYrDC8zQPdYcirQTd0VBHCUsMgbhDvG3c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Geliang Tang <geliang.tang@suse.com>,
	Matthieu Baerts <matthieu.baerts@tessares.net>,
	Larysa Zaremba <larysa.zaremba@intel.com>,
	Jakub Kicinski <kuba@kernel.org>,
	"Matthieu Baerts (NGI0)" <matttbe@kernel.org>
Subject: [PATCH 5.15 457/484] mptcp: export local_address
Date: Thu, 15 Aug 2024 15:25:15 +0200
Message-ID: <20240815131959.119673321@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240815131941.255804951@linuxfoundation.org>
References: <20240815131941.255804951@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Geliang Tang <geliang.tang@suse.com>

commit dc886bce753cc2cf3c88ec5c7a6880a4e17d65ba upstream.

Rename local_address() with "mptcp_" prefix and export it in protocol.h.

This function will be re-used in the common PM code (pm.c) in the
following commit.

Signed-off-by: Geliang Tang <geliang.tang@suse.com>
Reviewed-by: Matthieu Baerts <matthieu.baerts@tessares.net>
Signed-off-by: Matthieu Baerts <matthieu.baerts@tessares.net>
Reviewed-by: Larysa Zaremba <larysa.zaremba@intel.com>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Stable-dep-of: 6834097fc38c ("mptcp: pm: fix backup support in signal endpoints")
[ Conflicts in pm_netlink.c and protocol.h, because the context has
  changed in commit 4638de5aefe5 ("mptcp: handle local addrs announced
  by userspace PMs") which is not in this version. This commit is
  unrelated to this modification. ]
Signed-off-by: Matthieu Baerts (NGI0) <matttbe@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/mptcp/pm_netlink.c |   15 +++++++--------
 net/mptcp/protocol.h   |    1 +
 2 files changed, 8 insertions(+), 8 deletions(-)

--- a/net/mptcp/pm_netlink.c
+++ b/net/mptcp/pm_netlink.c
@@ -97,8 +97,7 @@ static bool address_zero(const struct mp
 	return addresses_equal(addr, &zero, true);
 }
 
-static void local_address(const struct sock_common *skc,
-			  struct mptcp_addr_info *addr)
+void mptcp_local_address(const struct sock_common *skc, struct mptcp_addr_info *addr)
 {
 	addr->family = skc->skc_family;
 	addr->port = htons(skc->skc_num);
@@ -133,7 +132,7 @@ static bool lookup_subflow_by_saddr(cons
 	list_for_each_entry(subflow, list, node) {
 		skc = (struct sock_common *)mptcp_subflow_tcp_sock(subflow);
 
-		local_address(skc, &cur);
+		mptcp_local_address(skc, &cur);
 		if (addresses_equal(&cur, saddr, saddr->port))
 			return true;
 	}
@@ -286,7 +285,7 @@ bool mptcp_pm_sport_in_anno_list(struct
 	struct mptcp_addr_info saddr;
 	bool ret = false;
 
-	local_address((struct sock_common *)sk, &saddr);
+	mptcp_local_address((struct sock_common *)sk, &saddr);
 
 	spin_lock_bh(&msk->pm.lock);
 	list_for_each_entry(entry, &msk->pm.anno_list, list) {
@@ -693,7 +692,7 @@ int mptcp_pm_nl_mp_prio_send_ack(struct
 		struct sock *sk = (struct sock *)msk;
 		struct mptcp_addr_info local;
 
-		local_address((struct sock_common *)ssk, &local);
+		mptcp_local_address((struct sock_common *)ssk, &local);
 		if (!addresses_equal(&local, addr, addr->port))
 			continue;
 
@@ -976,8 +975,8 @@ int mptcp_pm_nl_get_local_id(struct mptc
 	/* The 0 ID mapping is defined by the first subflow, copied into the msk
 	 * addr
 	 */
-	local_address((struct sock_common *)msk, &msk_local);
-	local_address((struct sock_common *)skc, &skc_local);
+	mptcp_local_address((struct sock_common *)msk, &msk_local);
+	mptcp_local_address((struct sock_common *)skc, &skc_local);
 	if (addresses_equal(&msk_local, &skc_local, false))
 		return 0;
 
@@ -1388,7 +1387,7 @@ static int mptcp_nl_remove_id_zero_addre
 		if (list_empty(&msk->conn_list))
 			goto next;
 
-		local_address((struct sock_common *)msk, &msk_local);
+		mptcp_local_address((struct sock_common *)msk, &msk_local);
 		if (!addresses_equal(&msk_local, addr, addr->port))
 			goto next;
 
--- a/net/mptcp/protocol.h
+++ b/net/mptcp/protocol.h
@@ -583,6 +583,7 @@ void mptcp_subflow_send_ack(struct sock
 void mptcp_subflow_reset(struct sock *ssk);
 void mptcp_sock_graft(struct sock *sk, struct socket *parent);
 struct socket *__mptcp_nmpc_socket(const struct mptcp_sock *msk);
+void mptcp_local_address(const struct sock_common *skc, struct mptcp_addr_info *addr);
 
 /* called with sk socket lock held */
 int __mptcp_subflow_connect(struct sock *sk, const struct mptcp_addr_info *loc,


