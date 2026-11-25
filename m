Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795618157;
	b=GRLH2WMS88WhCfI1E2mLP0YlCxS0HqlG6OSkp4wHUOFIA0SnMPDedsCVodBQijbEXWNX
	 OVJkKLIJnZtJ7lpEg4YHNwWo1imF/YrWVwKnrjT61jTQaSGetLTdwpkSDpWMeDLsbdB3Y
	 R7m8MXwbkH2asZIKbRMfhankIx9SeDC8xesJKUX95pTn6K+yqYX5iHMG8LzVOScfIQh7X
	 6cSduM154nx8xqzb6KLztXXpzSNTEz3cF+owssa0Qy05MRA7AsTQ3ts0FIPtspv7kKoDt
	 aG5FhOqiVyKLzjzkD0AwgaPAGSDGNhEINQEIAXJoWBOxEUZeXqEKUr1OV9Gmr64Qq6A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795618157;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=hWQgU+4qCgnoWNqnh8zMZ5/1rivNZCZ4qtzc/6kb8hk=;
	b=SklUJVUG8gu2xApsKjj4jYbzw/tPx7ny4mY+SUuMC3rIuBFyBn/cnCnncGl9nuNVdu07
	 RXpmIWXYw9DLMFJkudK81LuUQWKUEigEffb0X9Qc4tH7fFp5RcdIFGQ/W/fNcj4qJb3et
	 nu+QlHJFy3BkGHz0FpSB+cPadi18CbjIj4MyjL5IBuJdsAuaRy8chkOmfko492cBJdL1Y
	 J4ebfanNNmKebSdv2tw7YgIPJF4xHMSkQBCKLokrvX/dxLxmN3sIdd14f5nXt2fySUVtb
	 WFQN69C5NMFpoIaOhjp1ex7p/HQOcdB5UTRCSLHc4UUlOqVf9Xyp5zHyQxhK606rhBQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=b9a5o0bp;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 33924606A335;
	Wed, 25 Nov 2026 14:49:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=b9a5o0bp
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3CDFC1F000D8;
	Wed, 25 Nov 2026 14:49:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795618156;
	bh=hWQgU+4qCgnoWNqnh8zMZ5/1rivNZCZ4qtzc/6kb8hk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=b9a5o0bpcz3OgFny6yiEd6Z0PyIJJGfLIaob5pdHwmj52rwjV3FP1CF0lNcERNtah
	 y9qbwTvK7597S7C+YV+WebitlOt2a/saAUU+/aw/6gvL4hevzVgrfN5kPMZizHZrDn
	 ccLQ4TrYvd9V+EtwXSVAh3UoKWTSbVsPzLT5GNlM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+2344fb8002f3ef5b1712@syzkaller.appspotmail.com,
	Akhil Arul <akhilarul324@gmail.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0191/1005] Bluetooth: hci_core: Fix queuing rx_work while workqueue is drained
Date: Wed, 25 Nov 2026 15:25:29 +0100
Message-ID: <20261125143826.214005982@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143821.729802100@linuxfoundation.org>
References: <20261125143821.729802100@linuxfoundation.org>
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

From: Akhil Arul <akhilarul324@gmail.com>

[ Upstream commit 19b4e5701712f74d005cc66a36374559e8dfd281 ]

hci_recv_frame() drops a frame unless HCI_UP or HCI_INIT is set, but the
check is not synchronized with hci_dev_close_sync().  A driver can pass
the check, then close clears HCI_UP, flushes rx_work and starts
drain_workqueue(), and the late queue_work() of rx_work hits the
draining workqueue:

  workqueue: cannot queue hci_rx_work on wq hci0
  WARNING: kernel/workqueue.c:2352 at __queue_work+0x2c0/0x780
  Call Trace:
   queue_work_on+0xb2/0xc0
   hci_recv_frame+0x18f/0x330
   vhci_write+0x174/0x240
   vfs_write+0x271/0x680
   ksys_write+0x7c/0x110

Skipping the queue_work() while HCI_CMD_DRAIN_WORKQUEUE is set, as done
for tx_work, does not work for rx_work: the flag covers the whole close,
and events still have to be received in that window, for the commands
sent by hdev->shutdown() and for the reset done with
HCI_QUIRK_RESET_ON_CLOSE.

Run hci_recv_frame() under rcu_read_lock() and wait with
synchronize_rcu() once HCI_UP has been cleared, so that every caller
which still saw HCI_UP has queued its work before the workqueue is
drained, and later callers drop the frame.

HCI_INIT does not reopen that window.  Apart from the
HCI_QUIRK_RESET_ON_CLOSE reset, which runs after drain_workqueue() has
returned, it is only set by hci_dev_init_sync() during open, and open
and close are serialized by hci_req_sync_lock.  So once the grace period
has ended, nothing can pass the check and queue rx_work until the drain
is over.

Tested in qemu with the syzbot C reproducer, one run per boot: the
warning showed up on 12 of 30 boots before and on none of 42 boots after.
Bringing a vhci controller up and down 50 times behaves the same with
and without this change.

Fixes: 76727c02c1e1 ("Bluetooth: Call drain_workqueue() before resetting state")
Reported-by: syzbot+2344fb8002f3ef5b1712@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=2344fb8002f3ef5b1712
Signed-off-by: Akhil Arul <akhilarul324@gmail.com>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/bluetooth/hci_core.c | 9 +++++++++
 net/bluetooth/hci_sync.c | 5 +++++
 2 files changed, 14 insertions(+)

diff --git a/net/bluetooth/hci_core.c b/net/bluetooth/hci_core.c
index a162877d1144c..edd2304639a1b 100644
--- a/net/bluetooth/hci_core.c
+++ b/net/bluetooth/hci_core.c
@@ -2904,8 +2904,14 @@ int hci_recv_frame(struct hci_dev *hdev, struct sk_buff *skb)
 {
 	u8 dev_pkt_type;
 
+	/* Pairs with synchronize_rcu() in hci_dev_close_sync(), so rx_work is
+	 * not queued once the workqueue is being drained.
+	 */
+	rcu_read_lock();
+
 	if (!hdev || (!test_bit(HCI_UP, &hdev->flags)
 		      && !test_bit(HCI_INIT, &hdev->flags))) {
+		rcu_read_unlock();
 		kfree_skb(skb);
 		return -ENXIO;
 	}
@@ -2939,6 +2945,7 @@ int hci_recv_frame(struct hci_dev *hdev, struct sk_buff *skb)
 	case HCI_DRV_PKT:
 		break;
 	default:
+		rcu_read_unlock();
 		kfree_skb(skb);
 		return -EINVAL;
 	}
@@ -2952,6 +2959,8 @@ int hci_recv_frame(struct hci_dev *hdev, struct sk_buff *skb)
 	skb_queue_tail(&hdev->rx_q, skb);
 	queue_work(hdev->workqueue, &hdev->rx_work);
 
+	rcu_read_unlock();
+
 	return 0;
 }
 EXPORT_SYMBOL(hci_recv_frame);
diff --git a/net/bluetooth/hci_sync.c b/net/bluetooth/hci_sync.c
index b86f67ea5fddc..fa7f1765edeed 100644
--- a/net/bluetooth/hci_sync.c
+++ b/net/bluetooth/hci_sync.c
@@ -5659,6 +5659,11 @@ int hci_dev_close_sync(struct hci_dev *hdev)
 		return err;
 	}
 
+	/* Wait for hci_recv_frame() callers that still saw HCI_UP, so that
+	 * none of them queues rx_work while the workqueue is drained below.
+	 */
+	synchronize_rcu();
+
 	hci_leds_update_powered(hdev, false);
 
 	/* Flush RX and TX works */
-- 
2.53.0



