Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793213679;
	b=H9xwpgEynK2E2ZKaQmP+bH6GS/Jj7mE3TGF1KGNpNIUVFFQQgRfgPVHwo32TPhYvRqSJ
	 V1sHlLjjUIB6g3xSEOAttHmRAOzlTf10+DZG9M5sNGFYr/l1ga/F6k/3VOPlkSQ2X/tU1
	 cjVqVZo4dm3mZ629cDLOzq7jhXs1nFWErv66Q18/p+EHAvHL/Vz2Y9tgcZL0AjF+7kXx/
	 mccCf0H88H7XFxJWLmj2vjF8/DrVLJc0jDt8Q4cUpn4GENay+US6fgRtvet6nofetF1tw
	 nSS2xuNLn1NuPG/WY/91Q7faLxETM2UEnJgZE8oscoqR7miJ4EMYoMj6rSv+rUpX0PA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793213679;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=3LQiqMhLZWd//hlc62SXhxTaV6+ouJHAU1kL1zaaJg0=;
	b=FkpVGBS3m9hrOi1Hoij9b0huZ25ntUaFpGx38w8KArnWUVy1vDhv+0S3fgD2V3UC7fsX
	 jfALAPGm/J7fFA/+30jz7LVYxJf107zRj5lUC4OmXyMfjVKWVPJYSDsGwVBz3+Ozuf+Rb
	 COOInSFAXL+OWe7i5PuesEqJ0bk7ow30JtMU97alH4X8AS7Jzi8GtEkbN6Xp/NDUq6YCk
	 NySGdbGTpjeY7pFBDEsMkW/ZI43LgeIe/nW4/yg9lW1qu+ZXHoJ8M5YIvEIZR2wolh+Py
	 EjeDwFkX5A5i0Roz14Lbqt3Vm4185BIgV4XNcWNy4CIqBuRXb/SMVLhLEJUa1swawgA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=2UT7zL0R;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C1C360A2626;
	Wed, 28 Oct 2026 18:54:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=2UT7zL0R
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CB6C31F031E1;
	Wed, 28 Oct 2026 18:54:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793213679;
	bh=3LQiqMhLZWd//hlc62SXhxTaV6+ouJHAU1kL1zaaJg0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=2UT7zL0R4LzSmHKQbgTehsqbHtY1CBnxTVHJFUIqC9d/oL01PkX6KCKmrRN7lbmDb
	 iprUa60sbciBhP3/AF/LOFoqOx2vLp817nY63Krjg6c9JthVCcQKPa2ofYh3MeZUHc
	 DMXd8cP+db5X4nXTiHH9nwt1NI9eRdEHFKz9njQk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0592/1887] Bluetooth: af_bluetooth: Fix deadlock
Date: Wed, 28 Oct 2026 17:44:48 +0100
Message-ID: <20261028170512.892335614@linuxfoundation.org>
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

From: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>

[ Upstream commit f7b94bdc1ec107c92262716b073b3e816d4784fb ]

Attemting to do sock_lock on .recvmsg may cause a deadlock as shown
bellow, so instead of using sock_sock this uses sk_receive_queue.lock
on bt_sock_ioctl to avoid the UAF:

INFO: task kworker/u9:1:121 blocked for more than 30 seconds.
      Not tainted 6.7.6-lemon #183
Workqueue: hci0 hci_rx_work
Call Trace:
 <TASK>
 __schedule+0x37d/0xa00
 schedule+0x32/0xe0
 __lock_sock+0x68/0xa0
 ? __pfx_autoremove_wake_function+0x10/0x10
 lock_sock_nested+0x43/0x50
 l2cap_sock_recv_cb+0x21/0xa0
 l2cap_recv_frame+0x55b/0x30a0
 ? psi_task_switch+0xeb/0x270
 ? finish_task_switch.isra.0+0x93/0x2a0
 hci_rx_work+0x33a/0x3f0
 process_one_work+0x13a/0x2f0
 worker_thread+0x2f0/0x410
 ? __pfx_worker_thread+0x10/0x10
 kthread+0xe0/0x110
 ? __pfx_kthread+0x10/0x10
 ret_from_fork+0x2c/0x50
 ? __pfx_kthread+0x10/0x10
 ret_from_fork_asm+0x1b/0x30
 </TASK>

Fixes: 2e07e8348ea4 ("Bluetooth: af_bluetooth: Fix Use-After-Free in bt_sock_recvmsg")
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/bluetooth/af_bluetooth.c | 10 +++-------
 1 file changed, 3 insertions(+), 7 deletions(-)

diff --git a/net/bluetooth/af_bluetooth.c b/net/bluetooth/af_bluetooth.c
index 2e37841e4835f..212ac760f3d91 100644
--- a/net/bluetooth/af_bluetooth.c
+++ b/net/bluetooth/af_bluetooth.c
@@ -363,14 +363,11 @@ int bt_sock_recvmsg(struct socket *sock, struct msghdr *msg, size_t len,
 	if (flags & MSG_OOB)
 		return -EOPNOTSUPP;
 
-	lock_sock(sk);
-
 	skb = skb_recv_datagram(sk, flags, &err);
 	if (!skb) {
 		if (sk->sk_shutdown & RCV_SHUTDOWN)
 			err = 0;
 
-		release_sock(sk);
 		return err;
 	}
 
@@ -396,8 +393,6 @@ int bt_sock_recvmsg(struct socket *sock, struct msghdr *msg, size_t len,
 
 	skb_free_datagram(sk, skb);
 
-	release_sock(sk);
-
 	if (flags & MSG_TRUNC)
 		copied = skblen;
 
@@ -630,10 +625,11 @@ int bt_sock_ioctl(struct socket *sock, unsigned int cmd, unsigned long arg)
 		if (sk->sk_state == BT_LISTEN)
 			return -EINVAL;
 
-		lock_sock(sk);
+		spin_lock(&sk->sk_receive_queue.lock);
 		skb = skb_peek(&sk->sk_receive_queue);
 		amount = skb ? skb->len : 0;
-		release_sock(sk);
+		spin_unlock(&sk->sk_receive_queue.lock);
+
 		err = put_user(amount, (int __user *)arg);
 		break;
 
-- 
2.53.0



