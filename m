Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 45F6F1A0BD6;
	Wed, 20 Nov 2024 13:00:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732107614; cv=none; b=eMcWQFiWD2Lv+QkpXK2p5WF4HIgDmhUiY7JoS//Jp+2RRUS/ZH+benjpx0s8WRjAndyPdoe6b+7J45NUxTmY1GL5UWQkHUDzbwpQ1BkiC5ZErrfZXxtcwcqbqLJuLabYjO2y45f26+IZWzbQ72ibnS+CYoS42F/5VTcPmK2aL/c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732107614; c=relaxed/simple;
	bh=VZGrDq2+p3uT+bNtOzGOhEXTiPWRrA+MCjDmJFL6OEk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lFiQgW4DjdTPNk7uNhfXmvMJhWKaKGi/UFGJ0izVL8ATQk9w9eXmyiujoRoZa+mDTJSYYlrsBWZOjuf+j8zZRHNHRcIWlvmmEGwSMxXlgKnT0cUmE7efEgPLOi7GQAe2OH2fTeV+po3h1j5jsf6y4xsL0XKC20nhw+PwBgraIYU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=i8jyeSEg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="i8jyeSEg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1DCC1C4CECD;
	Wed, 20 Nov 2024 13:00:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1732107614;
	bh=VZGrDq2+p3uT+bNtOzGOhEXTiPWRrA+MCjDmJFL6OEk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=i8jyeSEg2+MigmhD229t6DLCEQeDP+Qn8doh5Ty+lnwV08JFsmSgu0U0gZ/iZGuHE
	 taVmz+sG6Z6VG/Aq9xxBaMNYLcvSGwUxTCAo1c9FhB+uGhczeASzQMSs/29h2kvnSb
	 mP3UXcMRxB7O9eWzzAySAletXROr436MKchT9p2k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Matthieu Baerts <matttbe@kernel.org>,
	Geliang Tang <geliang.tang@suse.com>,
	Mat Martineau <martineau@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.6 66/82] mptcp: define more local variables sk
Date: Wed, 20 Nov 2024 13:57:16 +0100
Message-ID: <20241120125631.098909193@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241120125629.623666563@linuxfoundation.org>
References: <20241120125629.623666563@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Geliang Tang <geliang.tang@suse.com>

commit 14cb0e0bf39bd10429ba14e9e2f905f1144226fc upstream.

'(struct sock *)msk' is used several times in mptcp_nl_cmd_announce(),
mptcp_nl_cmd_remove() or mptcp_userspace_pm_set_flags() in pm_userspace.c,
it's worth adding a local variable sk to point it.

Reviewed-by: Matthieu Baerts <matttbe@kernel.org>
Signed-off-by: Geliang Tang <geliang.tang@suse.com>
Signed-off-by: Mat Martineau <martineau@kernel.org>
Link: https://lore.kernel.org/r/20231025-send-net-next-20231025-v1-8-db8f25f798eb@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Stable-dep-of: 06afe09091ee ("mptcp: add userspace_pm_lookup_addr_by_id helper")
Signed-off-by: Matthieu Baerts (NGI0) <matttbe@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/mptcp/pm_userspace.c |   31 ++++++++++++++++++++-----------
 1 file changed, 20 insertions(+), 11 deletions(-)

--- a/net/mptcp/pm_userspace.c
+++ b/net/mptcp/pm_userspace.c
@@ -183,6 +183,7 @@ int mptcp_nl_cmd_announce(struct sk_buff
 	struct mptcp_pm_addr_entry addr_val;
 	struct mptcp_sock *msk;
 	int err = -EINVAL;
+	struct sock *sk;
 	u32 token_val;
 
 	if (!addr || !token) {
@@ -198,6 +199,8 @@ int mptcp_nl_cmd_announce(struct sk_buff
 		return err;
 	}
 
+	sk = (struct sock *)msk;
+
 	if (!mptcp_pm_is_userspace(msk)) {
 		GENL_SET_ERR_MSG(info, "invalid request; userspace PM not selected");
 		goto announce_err;
@@ -221,7 +224,7 @@ int mptcp_nl_cmd_announce(struct sk_buff
 		goto announce_err;
 	}
 
-	lock_sock((struct sock *)msk);
+	lock_sock(sk);
 	spin_lock_bh(&msk->pm.lock);
 
 	if (mptcp_pm_alloc_anno_list(msk, &addr_val.addr)) {
@@ -231,11 +234,11 @@ int mptcp_nl_cmd_announce(struct sk_buff
 	}
 
 	spin_unlock_bh(&msk->pm.lock);
-	release_sock((struct sock *)msk);
+	release_sock(sk);
 
 	err = 0;
  announce_err:
-	sock_put((struct sock *)msk);
+	sock_put(sk);
 	return err;
 }
 
@@ -282,6 +285,7 @@ int mptcp_nl_cmd_remove(struct sk_buff *
 	struct mptcp_sock *msk;
 	LIST_HEAD(free_list);
 	int err = -EINVAL;
+	struct sock *sk;
 	u32 token_val;
 	u8 id_val;
 
@@ -299,6 +303,8 @@ int mptcp_nl_cmd_remove(struct sk_buff *
 		return err;
 	}
 
+	sk = (struct sock *)msk;
+
 	if (!mptcp_pm_is_userspace(msk)) {
 		GENL_SET_ERR_MSG(info, "invalid request; userspace PM not selected");
 		goto remove_err;
@@ -309,7 +315,7 @@ int mptcp_nl_cmd_remove(struct sk_buff *
 		goto remove_err;
 	}
 
-	lock_sock((struct sock *)msk);
+	lock_sock(sk);
 
 	list_for_each_entry(entry, &msk->pm.userspace_pm_local_addr_list, list) {
 		if (entry->addr.id == id_val) {
@@ -320,7 +326,7 @@ int mptcp_nl_cmd_remove(struct sk_buff *
 
 	if (!match) {
 		GENL_SET_ERR_MSG(info, "address with specified id not found");
-		release_sock((struct sock *)msk);
+		release_sock(sk);
 		goto remove_err;
 	}
 
@@ -328,15 +334,15 @@ int mptcp_nl_cmd_remove(struct sk_buff *
 
 	mptcp_pm_remove_addrs(msk, &free_list);
 
-	release_sock((struct sock *)msk);
+	release_sock(sk);
 
 	list_for_each_entry_safe(match, entry, &free_list, list) {
-		sock_kfree_s((struct sock *)msk, match, sizeof(*match));
+		sock_kfree_s(sk, match, sizeof(*match));
 	}
 
 	err = 0;
  remove_err:
-	sock_put((struct sock *)msk);
+	sock_put(sk);
 	return err;
 }
 
@@ -558,6 +564,7 @@ int mptcp_userspace_pm_set_flags(struct
 {
 	struct mptcp_sock *msk;
 	int ret = -EINVAL;
+	struct sock *sk;
 	u32 token_val;
 
 	token_val = nla_get_u32(token);
@@ -566,6 +573,8 @@ int mptcp_userspace_pm_set_flags(struct
 	if (!msk)
 		return ret;
 
+	sk = (struct sock *)msk;
+
 	if (!mptcp_pm_is_userspace(msk))
 		goto set_flags_err;
 
@@ -573,11 +582,11 @@ int mptcp_userspace_pm_set_flags(struct
 	    rem->addr.family == AF_UNSPEC)
 		goto set_flags_err;
 
-	lock_sock((struct sock *)msk);
+	lock_sock(sk);
 	ret = mptcp_pm_nl_mp_prio_send_ack(msk, &loc->addr, &rem->addr, bkup);
-	release_sock((struct sock *)msk);
+	release_sock(sk);
 
 set_flags_err:
-	sock_put((struct sock *)msk);
+	sock_put(sk);
 	return ret;
 }


