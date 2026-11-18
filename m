Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795044308;
	b=bzUyTs4b2HLG06ApwMX+IAf1cseKRbY+uoRd4NEevG7aNGErv+f5IVPVHskRlYUIqWUX
	 RvGtqTiFJjRdADfONJsb2mezbjqzmS3zBV+jh4R/qQB84Zzy0tzkyJ93VKf7LCwy46ZKV
	 SdonXbqmpp5fP2UxnM4waasSDoSIOpJAW7llmg7mPGBxQ0jLMihVSDj7JIcROBm1QifHu
	 e6uKDnzFFBC5Isa+0dpOYj+NKrO0OWgCTZLcYs7QzWuaRtwJwMLCtV6X3khcfC7N+FynN
	 Qmw9AOQ669Sb/ugz5ZOPbIEnSYdp9Yunw+a2CAtdHIRscMIjMYCo/QnGVyLrrj/LYRg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795044308;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=JxUsmlMUiRqjJrNlrgrJehUcZsRepTv9Cc2+KGjAVTw=;
	b=wRxBYM++0RXKPLk0iDMP1uJWRTxm7fYGhFyyeaXEr7jJyT+qrUH4/AOgGVHU/hZnbFKT
	 w2455WLiZtxvgweCEEA55xk6H+UtA2t67pigsbURrHa2tekYvVA3zlrEK1BFUnI+lQAwa
	 X12ORF4qWlr/uaW6Bsgoc/fDhL2JMeHKomjd+occFWZIw6qdgEOUQ7gNpMgKcFsTPomhY
	 SqhUcjSfiadKSAVVGITnjJ7qJ7k3LbiYXQJeCJuX15jWgLUPco0kxy9/q46g93bSXH/n/
	 qr9OJz/zRHtjwpSrMYG4MkhYzf9a0G1nh7XYP3aq7mHo5LLXVfumV+Sx9iZUGa96kxg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=wfoYPrvZ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CDF01606A31C;
	Wed, 18 Nov 2026 23:25:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=wfoYPrvZ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 301A51F000C4;
	Wed, 18 Nov 2026 23:25:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795044308;
	bh=JxUsmlMUiRqjJrNlrgrJehUcZsRepTv9Cc2+KGjAVTw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=wfoYPrvZ/BX30lZritJ81sgwrsyb6LxuY7BkcQtBDjKb+WInU+fB49yU6YwHI0gEM
	 wbBddJTYKAV0nh1TiaGT36+FCNgdK3cy52QGpDVBSZE42tbuiHBu5ycqzEGT8Q2FI/
	 UbkpMv9GikCPEmO+C3lKRm43R+MRxVkv2/G/ds88=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chengfeng Ye <nicoyip.dev@gmail.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0470/2857] Bluetooth: hci_core: Serialize SCO and ISO scheduling with teardown
Date: Wed, 18 Nov 2026 15:25:04 +0100
Message-ID: <20261118150218.370876637@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

From: Chengfeng Ye <nicoyip.dev@gmail.com>

[ Upstream commit 848a7a91c7f03675d3bd8db6f7721cbf9cb50e21 ]

hci_low_sent() selects a connection under RCU but drops the read lock
before calculating its quota and returning it to the scheduler. The
connection is then used without lifetime protection by hci_sched_iso()
and hci_sched_sco().

After the TX worker drops the RCU read lock, hci_abort_conn_sync() on
hdev->req_workqueue can remove the connection from the hash, complete
synchronize_rcu(), purge its queues and release it. The TX worker on
hdev->workqueue can then access the freed connection in hci_quote_sent()
or while dequeuing packets and updating conn->sent.

KASAN reported:

  BUG: KASAN: slab-use-after-free in hci_low_sent+0x730/0x840
  Workqueue: hci0 hci_tx_work
  Call Trace:
   hci_low_sent+0x730/0x840
   hci_sched_iso+0x25e/0x4d0
   hci_tx_work+0x239/0xcb0

  Allocated by task 93:
   __hci_conn_add+0x16f/0x1b40
   hci_bind_bis+0x782/0x17b0
   hci_connect_bis+0xa0/0x510
   iso_sock_connect+0x589/0x1050

  Freed by task 88:
   kfree+0x131/0x3c0
   device_release+0xc8/0x240
   kobject_put+0x14d/0x280
   hci_conn_del+0x55a/0xe80
   hci_disconnect_sync+0x156/0x180
   hci_abort_conn_sync+0x3e7/0x940
   hci_cmd_sync_work+0x13c/0x290

Hold hci_dev_lock() across connection selection and transmission in both
SCO and ISO scheduling, serializing them with connection teardown. This
also prevents queuing completion timestamps after the connection queues
have been purged. Extending RCU across transmission would be unsafe
because the transmit path can sleep. Keep the ISO timeout check outside
the mutex since hci_link_tx_to() takes it itself.

The preceding channel fix already holds this mutex in the ACL and LE
schedulers, which call the SCO scheduler between packets. Move the SCO
body to __hci_sched_sco(), assert that its caller holds the mutex, and
use it directly from these locked paths. Keep a locking hci_sched_sco()
wrapper for the direct calls from hci_tx_work(). This avoids recursively
acquiring the device mutex while preserving the scheduling order.

Remove the obsolete claim that connection removal disables TX.

Fixes: bf4c63252490 ("Bluetooth: convert conn hash to RCU")
Cc: stable@vger.kernel.org
Assisted-by: LLM
Signed-off-by: Chengfeng Ye <nicoyip.dev@gmail.com>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
[ sashal: Adapted hci_sched_iso() to the older signature without a type argument or __check_timeout(), keeping the existing cnt selection and ISO_LINK call while adding the hdev lock/unlock around the loop. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/bluetooth/hci_core.c | 27 +++++++++++++++++++--------
 1 file changed, 19 insertions(+), 8 deletions(-)

diff --git a/net/bluetooth/hci_core.c b/net/bluetooth/hci_core.c
index 1cf9bbbff239c..199328612f2ac 100644
--- a/net/bluetooth/hci_core.c
+++ b/net/bluetooth/hci_core.c
@@ -3400,9 +3400,6 @@ static struct hci_conn *hci_low_sent(struct hci_dev *hdev, __u8 type,
 	struct hci_conn *conn = NULL, *c;
 	unsigned int num = 0, min = ~0;
 
-	/* We don't have to lock device here. Connections are always
-	 * added and removed with TX task disabled. */
-
 	rcu_read_lock();
 
 	list_for_each_entry_rcu(c, &h->list, list) {
@@ -3589,13 +3586,15 @@ static void __check_timeout(struct hci_dev *hdev, unsigned int cnt, u8 type)
 }
 
 /* Schedule SCO */
-static void hci_sched_sco(struct hci_dev *hdev, __u8 type)
+static void __hci_sched_sco(struct hci_dev *hdev, __u8 type)
 {
 	struct hci_conn *conn;
 	struct sk_buff *skb;
 	int quote, *cnt;
 	unsigned int pkts = hdev->sco_pkts;
 
+	lockdep_assert_held(&hdev->lock);
+
 	bt_dev_dbg(hdev, "type %u", type);
 
 	if (!hci_conn_num(hdev, type) || !pkts)
@@ -3630,6 +3629,13 @@ static void hci_sched_sco(struct hci_dev *hdev, __u8 type)
 		queue_work(hdev->workqueue, &hdev->tx_work);
 }
 
+static void hci_sched_sco(struct hci_dev *hdev, __u8 type)
+{
+	hci_dev_lock(hdev);
+	__hci_sched_sco(hdev, type);
+	hci_dev_unlock(hdev);
+}
+
 static void hci_sched_acl_pkt(struct hci_dev *hdev)
 {
 	unsigned int cnt = hdev->acl_cnt;
@@ -3665,8 +3671,8 @@ static void hci_sched_acl_pkt(struct hci_dev *hdev)
 			chan->conn->sent++;
 
 			/* Send pending SCO packets right away */
-			hci_sched_sco(hdev, SCO_LINK);
-			hci_sched_sco(hdev, ESCO_LINK);
+			__hci_sched_sco(hdev, SCO_LINK);
+			__hci_sched_sco(hdev, ESCO_LINK);
 		}
 	}
 
@@ -3725,8 +3731,8 @@ static void hci_sched_le(struct hci_dev *hdev)
 			chan->conn->sent++;
 
 			/* Send pending SCO packets right away */
-			hci_sched_sco(hdev, SCO_LINK);
-			hci_sched_sco(hdev, ESCO_LINK);
+			__hci_sched_sco(hdev, SCO_LINK);
+			__hci_sched_sco(hdev, ESCO_LINK);
 		}
 	}
 
@@ -3750,6 +3756,9 @@ static void hci_sched_iso(struct hci_dev *hdev)
 
 	cnt = hdev->iso_pkts ? &hdev->iso_cnt :
 		hdev->le_pkts ? &hdev->le_cnt : &hdev->acl_cnt;
+
+	hci_dev_lock(hdev);
+
 	while (*cnt && (conn = hci_low_sent(hdev, ISO_LINK, &quote))) {
 		while (quote-- && (skb = skb_dequeue(&conn->data_q))) {
 			BT_DBG("skb %p len %d", skb, skb->len);
@@ -3761,6 +3770,8 @@ static void hci_sched_iso(struct hci_dev *hdev)
 			(*cnt)--;
 		}
 	}
+
+	hci_dev_unlock(hdev);
 }
 
 static void hci_tx_work(struct work_struct *work)
-- 
2.53.0



