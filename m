Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795020221;
	b=swlZJ4X1Q6eY1moAk589hAUsQYdY4ng9AMpV0dh6GqrQFxL9/H+RGDPA5ZAOO30stuSj
	 tF8GiL+p+apq1Vu3j8GltoqYfumv9KOyJ+qJ+m9BRjqWQYezK8W+fiCKe8oOfNCCGtwBu
	 D7VoyMYCoYf8md/mGtzxdSCYbpN/BxD5nuqvZYHWNxdt8Hm0oCmzh8sm02tM2z3KlSm/e
	 0dB5zrC7hKcaI5oLocCfelZoYnzcvDSRL2+AemPFSE01sHMDn4F+tvsDphqNJjlYzZ0fE
	 OknJp1Z9KujTsN9X2WjSSVV6MyoX242gHfIt3n15clU/PJLxVS1SJIHn6BRqDnZ4cYw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795020221;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=UUCmqI/uInJLKjZKdLa/UxgShfWjZYLiW7ceE+RqTe8=;
	b=Vk/aVyqUTKBHWgSAScdCBYFQG/DGm17dEvY2v6Bx07G0QIIkH56hN5fQM/Re4oWyxcSN
	 uN6giiqtnYYTAX4r+idUl43+BqzMSGR6g1SWgFwbvX/Ju+R22y678PXxoKwqMswE9FtSH
	 Bz94CkeVegA7doIaBiy6yV3QZSQJZJGEYmIEX/tH2D91TVYsYJKjeWa95E3cV5LPEFJCX
	 AM0DwczVptfWBhN5taqgsCK81qWT0AwOvhQN6nMvBL+dqlvoyFjZuDWXMdNL9B9Nd/HQJ
	 5qKM8tkQC3PxswjdOiTHlukqYWnl8cRvjViDwJtMBGzW9YQXXfrG2ck5DFoUFyj+dIA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=19GZsgOr;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB74860A2600;
	Wed, 18 Nov 2026 16:43:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=19GZsgOr
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 29CD21F000C7;
	Wed, 18 Nov 2026 16:43:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795020221;
	bh=UUCmqI/uInJLKjZKdLa/UxgShfWjZYLiW7ceE+RqTe8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=19GZsgOrp+rdgrk1c0gL/Ss3X2BuguMFD5At0l4WhSls940VQBuuanV6MiEZc7dHh
	 +mBD0GUUdCTNNmX3e7Qszt8dn7rrpPX5dYR49Z23sBQmQ3ErCdFiZtU8JFAtuPqG9a
	 8vzcBntuC3xY77EOt3s3Ebd6RdtQOiZXH1I++l5A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eulgyu Kim <eulgyukim@snu.ac.kr>,
	Jaeyoung Chung <jjy600901@snu.ac.kr>,
	Pauli Virtanen <pav@iki.fi>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1872/2651] Bluetooth: L2CAP: fix race condition in l2cap_sock_shutdown()
Date: Wed, 18 Nov 2026 15:51:52 +0100
Message-ID: <20261118150354.353843320@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pauli Virtanen <pav@iki.fi>

[ Upstream commit 79ff49a72c06abdf76872dccc687e2a83c4f407f ]

l2cap_sock_shutdown() has the race condition

    [Task 1]                      [Task 2]
    l2cap_sock_shutdown           l2cap_sock_connect
      l2cap_chan_lock               l2cap_chan_connect
      conn = ... /* == NULL*/
      l2cap_chan_unlock ------------> l2cap_chan_lock
      if (conn) /* false */
                                      __l2cap_chan_add(conn, chan)
      l2cap_chan_lock <-------------- l2cap_chan_unlock
      l2cap_chan_close /* chan->conn->lock not held! */

conn->lock protects conn->chan_l and is not properly held here.

Use the l2cap_chan_close_unlocked() helper that ensures conn->lock is
held for l2cap_chan_close().

Fixes: ab4eedb790ca ("Bluetooth: L2CAP: Fix corrupted list in hci_chan_del")
Reported-by: Eulgyu Kim <eulgyukim@snu.ac.kr>
Reported-by: Jaeyoung Chung <jjy600901@snu.ac.kr>
Link: https://lore.kernel.org/linux-bluetooth/20260824153908.2327306-1-jjy600901@snu.ac.kr/
Link: https://syzkaller.appspot.com/bug?extid=0e4ebcc970728e056324
Signed-off-by: Pauli Virtanen <pav@iki.fi>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/bluetooth/l2cap_sock.c | 19 +------------------
 1 file changed, 1 insertion(+), 18 deletions(-)

diff --git a/net/bluetooth/l2cap_sock.c b/net/bluetooth/l2cap_sock.c
index 1eab4478abf4a..fed7c0967da28 100644
--- a/net/bluetooth/l2cap_sock.c
+++ b/net/bluetooth/l2cap_sock.c
@@ -1412,7 +1412,6 @@ static int l2cap_sock_shutdown(struct socket *sock, int how)
 {
 	struct sock *sk = sock->sk;
 	struct l2cap_chan *chan;
-	struct l2cap_conn *conn;
 	int err = 0;
 
 	BT_DBG("sock %p, sk %p, how %d", sock, sk, how);
@@ -1469,23 +1468,7 @@ static int l2cap_sock_shutdown(struct socket *sock, int how)
 	sk->sk_shutdown |= SEND_SHUTDOWN;
 	release_sock(sk);
 
-	l2cap_chan_lock(chan);
-	/* prevent conn structure from being freed */
-	conn = l2cap_conn_hold_unless_zero(chan->conn);
-	l2cap_chan_unlock(chan);
-
-	if (conn)
-		/* mutex lock must be taken before l2cap_chan_lock() */
-		mutex_lock(&conn->lock);
-
-	l2cap_chan_lock(chan);
-	l2cap_chan_close(chan, 0);
-	l2cap_chan_unlock(chan);
-
-	if (conn) {
-		mutex_unlock(&conn->lock);
-		l2cap_conn_put(conn);
-	}
+	l2cap_chan_close_unlocked(chan, 0);
 
 	lock_sock(sk);
 
-- 
2.53.0



