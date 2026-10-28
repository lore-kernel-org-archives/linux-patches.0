Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793216905;
	b=4IxKsq9Pl31Ekllrsh4yOnT3VscaYBGSDu4MTsaQtCMRcL1PKk1PW3aX+sYF//wz0vtA
	 o0dMScLgENztaDHSopozmDgCdIfxxYdDMIAb+pQmr+Tq+cVJvdFZA4Nefv1jjUt4DNaHZ
	 aTl7wUHZwHO1qxxCT+LDCS36OE1ZthqsGVmjyFZfFSJoPAQz6h2l5RKqnaZd9qzZBDR60
	 IKFpvgO+btU8ydFh/vVQkG0t+a3fGMreUNfauCXA3DfcAOrdd4AWev7teNLvhZsPWRNn9
	 gvO/4qxXtJhnKJTh2/A1SKiWYtnF+/87BROjqKM4jynbdFkfsUEOs32CFGvV0JgRCVw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793216905;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=fLw/i/xfIXITnxJRXoUTqSiBhGyBgBJZiXsDWcskrj8=;
	b=JpA1/VuRPnqyv7DKPKcDhwzapNnGqVn9PjLnqPz/fgOnOg7DVTyV64nQ8RMxX6G6Gnrp
	 bUqcXo/P5KAp2wFD2RSyvmKgagrDD4oZAE1R5siEewPompfMhI2+7NQh8bQN5aL2mtIt+
	 wyMpQzICqjSFNOdcPISzHc2zPiEy9ofDGvGkTXmS0qZBMuOkBFPsbAaVbUO2PBPvcy5D9
	 foWSpHDhCUoS0HGGBTVKiWwcpDYSSBd8JYPB/tII+I30zZ2bEctrwZ4Z+WA77BngX8kfg
	 8G/qGghQML4h5UynteFvaNsjM+CoMUEOSPgjT65vL6aXe+PQLdM7D0Xod/Re/6MD2Wg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=u7MCtALU;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 52B85606A31A;
	Wed, 28 Oct 2026 19:48:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=u7MCtALU
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A7ECC1F01825;
	Wed, 28 Oct 2026 19:48:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793216905;
	bh=fLw/i/xfIXITnxJRXoUTqSiBhGyBgBJZiXsDWcskrj8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=u7MCtALUHe1fVTM5UCxD+vG9RkaVssQGuT65WHd28dDlhtZS0g2MNmsyrXUMLfml2
	 dwbPT6VEON8aWBt+rIcWC2w/14aoRh7dtUb0a+pq/GGs9QDySVEn+caLQkoPMbdcMU
	 A+PlQohgqL8oKbBt5A1MTLMjY2ns6nwDAkYqrqBA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+55c2a5c871441261ed14@syzkaller.appspotmail.com,
	Tao Cui <cuitao@kylinos.cn>,
	Kalpan Jani <kalpan.jani@mpiricsoftware.com>,
	"Matthieu Baerts (NGI0)" <matttbe@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1693/1887] mptcp: pm: kernel: drop pending ADD_ADDR when removing ID0
Date: Wed, 28 Oct 2026 18:03:09 +0100
Message-ID: <20261028170537.981996303@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
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

From: Kalpan Jani <kalpan.jani@mpiricsoftware.com>

[ Upstream commit 2ac7d6e620764f1fc79eb4edd3610a7a661981ca ]

The in-kernel MPTCP path manager can leave a stale ADD_ADDR announcement
entry alive when removing the id 0 endpoint. This happens because the id 0
removal path does not tear down pending announcements, unlike the non-zero
id path.

When the PM later reselects id 0 after adding another signal endpoint, it
finds the stale anno_list entry and hits WARN_ON_ONCE(mptcp_pm_is_kernel())
in mptcp_pm_announced_alloc().

Root cause: asymmetry between removal paths.
- Non-zero id path: mptcp_nl_remove_subflow_and_signal_addr() calls
  mptcp_pm_remove_announced() to clean up.
- Id 0 path: mptcp_nl_remove_id_zero_address() skips cleanup entirely.

Fix by making the id 0 path symmetric: call mptcp_pm_announced_remove()
and decrement add_addr_signaled before queuing the RM_ADDR.

Subtle detail: signal endpoints are stored in anno_list with port 0, but
msk_local carries the connection's local port. In other words, entries
linked to ID0 paths should have port == 0. A follow-up patch will ensure
that. mptcp_pm_announced_remove() uses use_port=true for comparison. So
clear the port before the lookup.

Fixes: 740d798e8767 ("mptcp: remove id 0 address")
Cc: stable@vger.kernel.org
Reported-by: syzbot+55c2a5c871441261ed14@syzkaller.appspotmail.com
Closes: https://github.com/multipath-tcp/mptcp_net-next/issues/620
Suggested-by: Tao Cui <cuitao@kylinos.cn>
Signed-off-by: Kalpan Jani <kalpan.jani@mpiricsoftware.com>
Reviewed-by: Matthieu Baerts (NGI0) <matttbe@kernel.org>
Signed-off-by: Matthieu Baerts (NGI0) <matttbe@kernel.org>
Link: https://patch.msgid.link/20260908-net-mptcp-misc-fixes-7-3-rc1-v2-4-df1de70348b6@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/mptcp/pm_netlink.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/net/mptcp/pm_netlink.c b/net/mptcp/pm_netlink.c
index 532f75d29124d..05fb4d43187ad 100644
--- a/net/mptcp/pm_netlink.c
+++ b/net/mptcp/pm_netlink.c
@@ -1721,6 +1721,8 @@ static int mptcp_nl_remove_id_zero_address(struct net *net,
 	while ((msk = mptcp_token_iter_next(net, &s_slot, &s_num)) != NULL) {
 		struct sock *sk = (struct sock *)msk;
 		struct mptcp_addr_info msk_local;
+		struct mptcp_addr_info anno_addr;
+		bool announced;
 
 		if (list_empty(&msk->conn_list) || mptcp_pm_is_userspace(msk))
 			goto next;
@@ -1730,7 +1732,13 @@ static int mptcp_nl_remove_id_zero_address(struct net *net,
 			goto next;
 
 		lock_sock(sk);
+		/* Drop a possibly pending ADD_ADDR for this address. */
+		anno_addr = msk_local;
+		anno_addr.port = 0;
+		announced = remove_anno_list_by_saddr(msk, &anno_addr);
 		spin_lock_bh(&msk->pm.lock);
+		if (announced)
+			msk->pm.add_addr_signaled--;
 		mptcp_pm_remove_addr(msk, &list);
 		mptcp_pm_nl_rm_subflow_received(msk, &list);
 		__mark_subflow_endp_available(msk, 0);
-- 
2.53.0



