Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793212865;
	b=Q8ix+Pw3CxQ8C2CoHxvAZhn1hLmKKmhqbjoDUQzi+ERzve/sPG1ZT2+z0hdMIoRdfirz
	 Ta4iH84PbrFh4XAF33/b0QmRczsygWXbR4FdnTtWgF39VgC/8EfQDNFVBbPDoFiMU8kEb
	 MdOKAvRX+jbEV86Hwk1AFCgHzZQt/KekAGW3JMBL+bgxdR1aTZPTgyLwSLxqY2wSjAtRm
	 Xa4aBiuN25745yfs2D+mq7zeS9a6KgwD0KftSZcgkr+0PtFotYL8u4QUfxkC9wQ/mmzcI
	 +1yJRo9i49EboVXLLv57c6qg6NphPA3W3/CuEKtvHyjHs6ZdxYqNteMk65LnWqrredg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793212865;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ZBRhe8pK7eWcRS5ODG3zGv3s+UdXU6PkyZ/Q/vXRYVk=;
	b=Jp1bXRRxHNPDEVdfOn6zg/5TIubXXmVTwWJqqX7FkIEjv4KyAc7HGYDL/xIIfbcu0bfB
	 wU48UsXpvqjkMiSI5CsL8no2FeWbTd2agDb0HzF5sLQc2H77n/d5sRU3ubmDE5O270cwz
	 yDVh4anrtl62m9NlTGdbul33lXNvL+GKTw5rdKubpy7y3uqF0zUtDBeIYJ+oh8BV+Ie/W
	 mbIw4DENleYkBbmYAZenE32dJdEI9KH+icUnhPElOsPi4olFZI1niU486M8W4/u41/Itz
	 8rTDCR7+Cncw56Ad+CuumSXO4MmildLXKagk6gMVJANmE92y2fRl2hPqpX0/MMKyAtQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=c6kFc8X4;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E69C606A320;
	Wed, 28 Oct 2026 18:41:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=c6kFc8X4
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E1F2E1F01825;
	Wed, 28 Oct 2026 18:41:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793212865;
	bh=ZBRhe8pK7eWcRS5ODG3zGv3s+UdXU6PkyZ/Q/vXRYVk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=c6kFc8X45SaovHdE5cLZ1xU1g+xQNXAfJY7ZG1LIqnLTyep2UtJKhhpOxmduWApov
	 HioE1y9O3OHWz1WsqpMNaGqEJ9ITi8XWPZv3h0ara4qlelADUi8wzrKT4ViG1BMfPT
	 4PjwwQNW2AH1Xl9FrGN13FsefHKBiKG2eQoPsMGE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chengfeng Ye <nicoyip.dev@gmail.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Subject: [PATCH 6.1 0305/1887] Bluetooth: hci_core: Serialize fragmented ISO packet queueing
Date: Wed, 28 Oct 2026 17:40:01 +0100
Message-ID: <20261028170506.170564305@linuxfoundation.org>
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

commit 1a572db43c057566771b485598ad2e66cb390821 upstream.

The fragmented path in hci_queue_iso() calls __skb_queue_tail() without
holding conn->data_q.lock. The socket lock serializes senders, but the
transmit worker can concurrently remove packets from this queue using
skb_dequeue().

After an insertion saves the old tail pointer, hci_sched_iso() can dequeue
that packet and pass it to the driver. The driver can free the packet
before the insertion resumes and writes to the old tail's next pointer,
causing a use-after-free. Concurrent updates can also corrupt the queue.

KASAN reported:

  BUG: KASAN: slab-use-after-free in hci_send_iso+0xc7d/0xe10
  Call Trace:
   hci_send_iso+0xc7d/0xe10
   iso_sock_sendmsg+0x710/0x900
   __sys_sendto+0x34a/0x3a0

  Allocated by task 86:
   __alloc_skb+0xdd/0x820
   alloc_skb_with_frags+0x7e/0x770
   sock_alloc_send_pskb+0x67a/0x820
   bt_skb_sendmsg.constprop.0+0xc0/0x6c0
   iso_sock_sendmsg+0x44e/0x900

  Freed by task 90:
   kmem_cache_free+0xcb/0x3d0
   vhci_read+0x33f/0x4d0
   vfs_read+0x177/0xa20

Hold the queue lock across the entire fragment batch, as hci_queue_acl()
does, to serialize insertion against dequeue while preserving fragment
ordering.

Fixes: 26afbd826ee3 ("Bluetooth: Add initial implementation of CIS connections")
Cc: stable@vger.kernel.org
Signed-off-by: Chengfeng Ye <nicoyip.dev@gmail.com>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/bluetooth/hci_core.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/net/bluetooth/hci_core.c
+++ b/net/bluetooth/hci_core.c
@@ -3291,6 +3291,8 @@ static void hci_queue_iso(struct hci_con
 
 		skb_shinfo(skb)->frag_list = NULL;
 
+		spin_lock_bh(&queue->lock);
+
 		__skb_queue_tail(queue, skb);
 
 		do {
@@ -3305,6 +3307,8 @@ static void hci_queue_iso(struct hci_con
 
 			__skb_queue_tail(queue, skb);
 		} while (list);
+
+		spin_unlock_bh(&queue->lock);
 	}
 }
 


