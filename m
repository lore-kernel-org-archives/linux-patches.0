Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793217349;
	b=fTYWQXzCw61+c+IMZhp4zX1BEorAi2ugmwV4b13HxL5xi5AZBq5AmZkVjALx/MjA9HrN
	 k3Y92qYg8raXSzglsmuCJA2b7YSNXDsInvnOCyfcRDFk25eV5cR7HclZ8852uWt6c1feX
	 9up2z6WYTtI9XL5cliZJlmeL0E0s+n5LdIDzwaJt23599oVdG9vFSaHo2izcylYM7Di7u
	 PxGUGyFCp3Rh93DVpKtdO/M5G6JOtogZwMCZP8kanlS/G3lMqkVTg4xwJGA9lqHspl9EB
	 3rsPbblwUdvc97fL314BqZoQwenJsTzkcTmogLPjqzhlf527W9O/qeIt2+eK/XD1Whg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793217349;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=PnIumiAxUQ3XRlRRkMT/wm5jN0YrAeJ0VkX1XOo1UG8=;
	b=PMktxIJD4G6eF5Wc7J4FtTM0SimE02rwwkhaIAjiDHujaW5k0T1jzEG1gOiyz/ZGSFTl
	 FQ/Pmm90YkerkHc4cFKXJE4+x/f6L7a6lgZl8zuKnvpaSzeTk35pPjcJvldK9WBZZd4JL
	 9D1657EWtl9bjoPLbNxgo3HRsiZ2CKV7u0JDzBD8klWsEe4n2BgrG9UpZeMfcFGTaUPLs
	 9OzHhrKZ2qWqMaEFXVst+ezR6WGmXzJpP+Wx63f3rtd0zm0+T8koqD3ww5OxsMNTRsvRL
	 4Dae0mhbzPUdlWUAmiuGMMMkQV5j4RW9+fs4A38HSweoQ9XhMrcmAEADlETIlxQlfQw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=VO4TZxFt;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 42DBD606A31D;
	Wed, 28 Oct 2026 19:55:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=VO4TZxFt
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8A6561F01825;
	Wed, 28 Oct 2026 19:55:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793217349;
	bh=PnIumiAxUQ3XRlRRkMT/wm5jN0YrAeJ0VkX1XOo1UG8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=VO4TZxFtqsIdCXufdu5cBs8zYjsBwZs4s55tvccK3d+C4qAcAP6TNm+Lf1UDGeEwZ
	 ds+KCS+9D4oZFu9W9mSkB6pn1VMrw5JkBb7IY+lQCNtcOqk5tcyf4N4rgW2tXNn9RI
	 VDQKX/2pvp9N/FFyrw6hqywEK2dWB+lAD+u7gBbE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+b6919040d9958e2fc1ae@syzkaller.appspotmail.com,
	ThangNN99 <ngocthang2710.1999@gmail.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1871/1887] Bluetooth: hci_core: Fix queuing tx_work after workqueue is drained
Date: Wed, 28 Oct 2026 18:06:07 +0100
Message-ID: <20261028170542.030444773@linuxfoundation.org>
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

From: ThangNN99 <ngocthang2710.1999@gmail.com>

[ Upstream commit 6610c6fe4b8936c232048e6049bf77c70a6f759c ]

hci_send_acl(), hci_send_sco() and hci_send_iso() queue hdev->tx_work
unconditionally. They can run from the L2CAP/SCO/ISO socket send path
while hci_dev_close_sync() is draining hdev->workqueue (HCIDEVDOWN
racing with a socket write). Since that queue_work() is not chained
work from the tx_work worker itself, __queue_work() sees the queue
marked __WQ_DRAINING, warns "cannot queue %ps on wq %s", and drops
the work:

  WARNING: CPU: 1 PID: 5985 at kernel/workqueue.c:2352 __queue_work
  Call Trace:
   queue_work_on
   l2cap_chan_send
   l2cap_sock_sendmsg
   ...

hci_dev_close_sync() already sets HCI_CMD_DRAIN_WORKQUEUE before
draining, but only hci_cmd_work() and handle_cmd_cnt_and_timer()
check it before queuing. Route the tx_work producers through the
same guard via a shared hci_sched_tx() helper.

Fixes: 525daaea459f ("Bluetooth: hci_sync: Set HCI_CMD_DRAIN_WORKQUEUE during device close")
Reported-by: syzbot+b6919040d9958e2fc1ae@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=b6919040d9958e2fc1ae
Signed-off-by: ThangNN99 <ngocthang2710.1999@gmail.com>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/bluetooth/hci_core.c | 17 ++++++++++++++---
 1 file changed, 14 insertions(+), 3 deletions(-)

diff --git a/net/bluetooth/hci_core.c b/net/bluetooth/hci_core.c
index aebb48bae2a48..c07e7c2ad76ae 100644
--- a/net/bluetooth/hci_core.c
+++ b/net/bluetooth/hci_core.c
@@ -3222,6 +3222,17 @@ static void hci_queue_acl(struct hci_chan *chan, struct sk_buff_head *queue,
 	bt_dev_dbg(hdev, "chan %p queued %d", chan, skb_queue_len(queue));
 }
 
+/* Queue hdev->tx_work, unless hdev->workqueue is being drained by
+ * hci_dev_close_sync(), which would otherwise WARN and drop the work.
+ */
+static void hci_sched_tx(struct hci_dev *hdev)
+{
+	rcu_read_lock();
+	if (!hci_dev_test_flag(hdev, HCI_CMD_DRAIN_WORKQUEUE))
+		queue_work(hdev->workqueue, &hdev->tx_work);
+	rcu_read_unlock();
+}
+
 void hci_send_acl(struct hci_chan *chan, struct sk_buff *skb, __u16 flags)
 {
 	struct hci_dev *hdev = chan->conn->hdev;
@@ -3230,7 +3241,7 @@ void hci_send_acl(struct hci_chan *chan, struct sk_buff *skb, __u16 flags)
 
 	hci_queue_acl(chan, &chan->data_q, skb, flags);
 
-	queue_work(hdev->workqueue, &hdev->tx_work);
+	hci_sched_tx(hdev);
 }
 
 /* Send SCO data */
@@ -3255,7 +3266,7 @@ void hci_send_sco(struct hci_conn *conn, struct sk_buff *skb)
 	bt_dev_dbg(hdev, "hcon %p queued %d", conn,
 		   skb_queue_len(&conn->data_q));
 
-	queue_work(hdev->workqueue, &hdev->tx_work);
+	hci_sched_tx(hdev);
 }
 
 /* Send ISO data */
@@ -3330,7 +3341,7 @@ void hci_send_iso(struct hci_conn *conn, struct sk_buff *skb)
 
 	hci_queue_iso(conn, &conn->data_q, skb);
 
-	queue_work(hdev->workqueue, &hdev->tx_work);
+	hci_sched_tx(hdev);
 }
 
 /* ---- HCI TX task (outgoing data) ---- */
-- 
2.53.0



