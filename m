Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793212863;
	b=FR7YkMOBehz7fOWj60c0aSr+cQAaXAB9vJiM3mbbnKusjVvKd1ctCzC6k52zlEc6yk3w
	 q8Vkqw61Pss2qAkC6Yj5DEJg6V85yxhQLJC1hO91l8oyakirEZK6SbCWjlNW0GXmJg3c+
	 MMXkdsXSUOtHL0gD2+zCfot1xbdnBLcYj1/k3F0cO7AUXnPKwwKxD05ixY0kS2B4lBM4M
	 sCPXK3++tq4ag5B1oegTrwLUcz8vWU110qVkXeIPJfBZ2D8wsMWtkdnEJTa61YmJWKb6e
	 AlBmq2IVHmDKSa4gFfPu4Xhr0vZT8QLPmeBl0+FcG2rJDGHRNktwZfZT0L1iOOHLCWw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793212863;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=RYrGVuTG4rn0gytcAfc4/9DDUWmVG4skNRhqoi4BF8Q=;
	b=5rtNAzzbwNPBiec2az3nL5JuVyIEJ2kpkltPFOOb3i4De3MYb4vxcr6CbCjh7OYPC+Gu
	 gfBoQF5fdDqo8E7qej5nMf1mo9LS+eu9EZ/AjEj/s94gLmXRiPaWeYkYR6E3AHBflaCOL
	 3rweA5kpOERSQ5Uvla2yGoO7iaU37riWTkToE46zWpJeB/GGJVdNsJsaMnLNOjxrfCTuj
	 L0PMnxzz8/jYgwWzwjWE9ZG4H4/I44vFwJiVlX3g422D7QswknVIvObbjxbnJo4QFCt0a
	 owaChc/ebJXEPI23F88NgGZID+afZ3pXotsprwHzEiZjY+togJK0cRdiG6WGNjROa8w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=hZDDO2sh;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE07D606A31C;
	Wed, 28 Oct 2026 18:41:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=hZDDO2sh
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 465E31F01825;
	Wed, 28 Oct 2026 18:41:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793212862;
	bh=RYrGVuTG4rn0gytcAfc4/9DDUWmVG4skNRhqoi4BF8Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hZDDO2shEbpXcSaGz3SjAEG/5JzvN8APejmyDMQlaN7MQDem2wP883XxZ2giAS9zK
	 kIYkcOOvTqIw8AHBP74lQloOrk880fixBpdKAwAktHXCctJNXGP6IFf/AD1vlRGsTP
	 G9+fEbSGfthPIN13t8nSaJB5BY9a5/ouuyI61SBM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chengfeng Ye <nicoyip.dev@gmail.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Subject: [PATCH 6.1 0304/1887] Bluetooth: hci_core: Serialize ACL scheduling with channel deletion
Date: Wed, 28 Oct 2026 17:40:00 +0100
Message-ID: <20261028170506.148125576@linuxfoundation.org>
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

From: Chengfeng Ye <nicoyip.dev@gmail.com>

commit f4845ab191a4f686a5da481fbba90ed73bb693b0 upstream.

hci_chan_sent() selects a channel under RCU but drops the read lock before
accessing chan->conn and returning the channel. The ACL and LE schedulers
then use its packet queue and update its transmit counters without any
protection against channel deletion.

After TX selects a channel and releases RCU, a disconnect command timeout
on the separate request workqueue can run hci_conn_failed() and
l2cap_conn_del(). hci_chan_del() can then unlink the channel, complete
synchronize_rcu(), purge its queue and free it before TX resumes. This
causes use-after-free both in hci_chan_sent() and in its callers.

KASAN reported:

  BUG: KASAN: slab-use-after-free in hci_chan_sent+0x892/0x9b0
  Workqueue: hci0 hci_tx_work
  Call Trace:
   hci_chan_sent+0x892/0x9b0
   hci_tx_work+0x5e6/0xb70
  Allocated by task 91:
   hci_chan_create+0xe3/0x350
   l2cap_conn_add.part.0+0x12/0xa30
   l2cap_chan_connect+0x110d/0x1b60
   l2cap_sock_connect+0x310/0x530
  Freed by task 99:
   hci_chan_del+0x11f/0x170
   l2cap_conn_del+0x4f1/0x800
   l2cap_connect_cfm+0x88c/0xd30
   hci_conn_failed+0x150/0x250
   hci_abort_conn_sync+0x3e3/0x800
   hci_cmd_sync_run+0x7e/0xc0
   hci_abort_conn+0x105/0x1f0
   disconnect_sync+0x157/0x290
   hci_cmd_sync_work+0x13c/0x290

Hold the existing device mutex across channel selection and transmission
in both schedulers to serialize them with channel teardown. Keep timeout
handling outside the critical sections because hci_link_tx_to() acquires
the same mutex. This also permits the transmit path to sleep, unlike
extending the RCU read-side critical section across packet submission.

Fixes: 3eff45eaf817 ("Bluetooth: convert tx_task to workqueue")
Cc: stable@vger.kernel.org
Assisted-by: LLM
Signed-off-by: Chengfeng Ye <nicoyip.dev@gmail.com>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/bluetooth/hci_core.c |    8 ++++++++
 1 file changed, 8 insertions(+)

--- a/net/bluetooth/hci_core.c
+++ b/net/bluetooth/hci_core.c
@@ -3604,6 +3604,8 @@ static void hci_sched_acl_pkt(struct hci
 
 	__check_timeout(hdev, cnt, ACL_LINK);
 
+	hci_dev_lock(hdev);
+
 	while (hdev->acl_cnt &&
 	       (chan = hci_chan_sent(hdev, ACL_LINK, &quote))) {
 		u32 priority = (skb_peek(&chan->data_q))->priority;
@@ -3635,6 +3637,8 @@ static void hci_sched_acl_pkt(struct hci
 
 	if (cnt != hdev->acl_cnt)
 		hci_prio_recalculate(hdev, ACL_LINK);
+
+	hci_dev_unlock(hdev);
 }
 
 static void hci_sched_acl(struct hci_dev *hdev)
@@ -3663,6 +3667,8 @@ static void hci_sched_le(struct hci_dev
 
 	__check_timeout(hdev, *cnt, LE_LINK);
 
+	hci_dev_lock(hdev);
+
 	tmp = *cnt;
 	while (*cnt && (chan = hci_chan_sent(hdev, LE_LINK, &quote))) {
 		u32 priority = (skb_peek(&chan->data_q))->priority;
@@ -3691,6 +3697,8 @@ static void hci_sched_le(struct hci_dev
 
 	if (*cnt != tmp)
 		hci_prio_recalculate(hdev, LE_LINK);
+
+	hci_dev_unlock(hdev);
 }
 
 /* Schedule CIS */


