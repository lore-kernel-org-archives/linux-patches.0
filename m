Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794064610;
	b=JdogNFJROmyQeZBsh/Jkmmqcs5YAikiLaZm8y/2Tzyi8KAt0zsIjZH0SGZ1uwewuWVXl
	 KyW++MxZ3vQsWFsklEicoqHYPuNudA+MDkv4Je0XxwtwElP7Kmejk0jk9h1p3vl5PzVb3
	 99ifLYB+6EGwk9I5GR79RyCkZguvZeMml3hS6JwGV6HYCEq9KkFeYB0Z0f4HLDrfPp8+F
	 1l6LKXxkrDZfpWDUDnrZxoJZpsZEZc0peqVMQoyCZ+gQZFXjq8Uix+f877T5VSRT3Iyo3
	 RtK8n5IV35SY832YN4KP8yXqFveZ7vehkKCCC8dnpDhlwkF24Be6zuEdoucbY2p+tqA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794064610;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=jalbNmZ+GCa+Pzl39MlUQDg+dYDvlik+BG4r20ww36A=;
	b=Z3MCn4WCeO+TFuq1cXauWQ55fyHHRWxVng5kXzjMOS0zoYwoX2u0u1hfzOpTcn6ctJkp
	 19jIZQj9CS/P56c/WuBOidGEyHngeD63kg7tUEQySk5QixEKSqnLB0usXA6pri/LUAfBu
	 zNE7lrPNdkvH2nVYZrcgCtBMXpv7uqUQZYCm0L7A4v8xhSGc1T+muvEo1ALy2PAs0J/pJ
	 JpyybOoFKPUwASlS0kRs4aft9g9Acf4iTMSdocK+E1QkH1x+KfsmM+4iI6XRT/Hn4oy3s
	 As/QgS7Y1e+xcOikl5qUNtUtb8XZN6aPykDAab7gJjiMgzXcUp/dMQDkRM2ULVnIsTg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=MT7BB4Q3;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C7CC0606EE88;
	Sat,  7 Nov 2026 15:16:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=MT7BB4Q3
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 759EC1F0089F;
	Sat,  7 Nov 2026 15:16:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794064609;
	bh=jalbNmZ+GCa+Pzl39MlUQDg+dYDvlik+BG4r20ww36A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=MT7BB4Q3tOtFMm2VZR9367QlJcrq6vFXCxSjNo1oM1LPjTfhnKH5+PU9iMglMA02K
	 9YuPY/oMu0zIpvVSTCR5R0h73led1yEjRdLioRs+iXMGJf83mNItz3nOj++ar4dJaX
	 b3PZUQvGczo/z+/iyxZf8QrzOOyvKUXZM990rVFk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Adam Harshbarger <handyhandyman.adam@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Nickolai Zeldovich <nickolai@csail.mit.edu>,
	I Hsin Cheng <richard120310@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0620/1257] lib/plist: fix plist_requeue() corrupting order in the last bucket
Date: Sat,  7 Nov 2026 08:48:36 -0500
Message-ID: <20261107134956.423417140@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134939.434104957@linuxfoundation.org>
References: <20261107134939.434104957@linuxfoundation.org>
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

From: Adam Harshbarger <handyhandyman.adam@gmail.com>

[ Upstream commit 43c91b1522435429a63d175f5a953e6f727a4f88 ]

plist_requeue() is meant to move a node to the end of its own priority
run.  When the node heads the *last* priority bucket it is instead placed
at the head of the whole list, leaving the plist unsorted:

  built:      A(prio 0) B(prio 1) C(prio 1)
  requeue(B): B(prio 1) A(prio 0) C(prio 1)
  expected:   A(prio 0) C(prio 1) B(prio 1)

prio_list is a *headless* circular ring of the nodes that lead each
priority bucket.  The shortcut added by commit 95d4b3450ebe ("lib/plist.c:
add shortcut for plist_requeue()") takes

	iter = list_entry(iter->prio_list.next, struct plist_node,
			  prio_list);
	node_next = &iter->node_list;

which from the last bucket wraps round to the *first* bucket, so node_next
ends up pointing at the head of the list rather than at its end.  The
plist_for_each_continue() loop immediately below it computes the correct
answer (&head->node_list) for that case.

With any bucket after it the shortcut is correct, which is why this went
unnoticed: the benchmark in that commit measured elapsed time and never
checked the resulting order.

Keep the shortcut -- it is a real win -- but exclude the case where iter's
bucket is the last one, which is exactly when its ring successor is the
first bucket again.

Reachable from mm/swapfile.c, which rotates swap_avail_heads[] with
plist_requeue().  It takes three or more swap devices: at least two
distinct priorities, so that a later bucket exists for the ring to wrap
round from, and two or more devices sharing the lowest priority, so that
plist_requeue() does not return early.  One device per priority returns
early at the node->prio != iter->prio test.  A single priority is also
safe, but for a different reason worth stating: with one bucket no node is
ever linked onto prio_list at all -- plist_add() skips it for the first
node and for every node whose predecessor shares its priority -- so
list_empty(&iter->prio_list) holds and the shortcut is never entered.

Tested by driving three implementations -- the pre-95d4b3450ebe code,
current mainline, and this patch -- through 1,084,492 identical random
add/del/requeue operations over 24 nodes and 1..5 distinct priorities,
comparing the resulting node_list node for node after every operation:

  variant             differs from pre-95d4b3450ebe  left list unsorted
  pre-95d4b3450ebe    -- (reference)                                  0
  mainline                                  289,297             276,660
  this patch                                      0                   0

Link: https://lore.kernel.org/20260903222456.1881786-1-handyhandyman.adam@gmail.com
Fixes: 95d4b3450ebe ("lib/plist.c: add shortcut for plist_requeue()")
Signed-off-by: Adam Harshbarger <handyhandyman.adam@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: Nickolai Zeldovich <nickolai@csail.mit.edu>
Assisted-by: Claude:claude-opus-5
Cc: I Hsin Cheng <richard120310@gmail.com>
Cc: <stable@vger.kernel.org> # v6.15+
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 lib/plist.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/lib/plist.c b/lib/plist.c
index a5bef38add431..b0273533c04d2 100644
--- a/lib/plist.c
+++ b/lib/plist.c
@@ -174,8 +174,15 @@ void plist_requeue(struct plist_node *node, struct plist_head *head)
 	/*
 	 * After plist_del(), iter is the replacement of the node.  If the node
 	 * was on prio_list, take shortcut to find node_next instead of looping.
+	 *
+	 * prio_list is a headless ring, so from the LAST bucket ->next wraps
+	 * round to the first one; in that case node_next is the list head.
 	 */
 	if (!list_empty(&iter->prio_list)) {
+		struct plist_node *first = plist_first(head);
+
+		if (iter->prio_list.next == &first->prio_list)
+			goto queue;
 		iter = list_entry(iter->prio_list.next, struct plist_node,
 				  prio_list);
 		node_next = &iter->node_list;
-- 
2.53.0



