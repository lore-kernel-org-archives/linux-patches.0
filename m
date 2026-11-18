Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795050775;
	b=XMXAKYcUe0t7yq0NIBQxEeGYqPgW0iUIhTYj3vHdASO1kxnFXUjn3CK3alR6v2yRPA82
	 2VNHGSfqK2iXTrJJt3ewT2ytg7rnfhsUpdWKo1Yww+n/jZV+cD0p8/G4QC31XvGWS4dcV
	 PN1uFu/xzEXboOeQrqjqyUKBRBW7Q1Rv8AG/xmfs5fak1FDBopx5zpb69RAupIZe46vKl
	 COOTTN7Xn0a/2oZB2NdyApiyS5HhbJIlLu2Rgoxj+mqPVTEZ3CjMcdDTO2Nk3w/bhLSgP
	 Lkc6FuxpIwwPJLSHeHAzEZKKGLLaqpFMapKlbwldF0nPrN6owR1gsHflRf4GBMWGBQw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795050775;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=toR6wZ7TWFRZAZwCmPGU1YpvmcdWCDHUizjdP+u2FPI=;
	b=auLyzFdnF+jrwnnN1jFJZdjx1SjNPal3S783HwWvqoPFt9rbHK8/4zfAE4Yn1ZVKL163
	 d56XyN/VUb75XsOdZPAWIrvBcy432EdOaLTG03JjU31pBRCAdSfMdjrNxHHDPlvOdxKv7
	 WphA6uCvAtZ0k3mrdVOT/Segjm1RJMuNeXLK6TlgU5jCqZoVKaNSqHpr1YkUs4jjtbFg6
	 0kq7z7PCQd0XjYP1xpzPSzK+1fX2hKJnjZmHp863piJ9iUlzkyXCTyGGqWxHCS9q2GKwW
	 /8mD1TP+bVifm3O7WuBqCAdlFjpwr4JylWYKGiVeoEcVKSK6z3/nHu+U00d7PE604Lg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=bMQiZ75j;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E789606A320;
	Thu, 19 Nov 2026 01:12:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=bMQiZ75j
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A5C631F000C4;
	Thu, 19 Nov 2026 01:12:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795050775;
	bh=toR6wZ7TWFRZAZwCmPGU1YpvmcdWCDHUizjdP+u2FPI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bMQiZ75j2fTwkeN/o8/9Xe78alkm2IEniHepqL/BgMGe5N7ggFQ8PJ1IyemUmb39F
	 1Un8gwru4NvbaFxHE0N8hySUhjIore2DXvGOS3vGwgQOQq6R0psKHApBXSUzmnOtd4
	 JFwZATG4HYh2RNxwRSJTBKfFHmi9jUvDgREdbclc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tong Liu <lyutoon@gmail.com>,
	Qi Tang <tpluszz77@gmail.com>,
	Zhiyu Zhang <zhiyuzhang999@gmail.com>,
	Bradley Morgan <brads@mainlining.org>,
	"Christian Brauner (Amutable)" <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 2827/2857] watch_queue: keep info_id separate from rcu_head
Date: Wed, 18 Nov 2026 16:04:21 +0100
Message-ID: <20261118150343.375348588@linuxfoundation.org>
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

From: Zhiyu Zhang <zhiyuzhang999@gmail.com>

[ Upstream commit 53d72818f9e2aeb03a6053544ee6efa4eb2a3988 ]

struct watch overlays info_id with rcu_head. A notification poster reads
info_id under rcu_read_lock(), but a concurrent final put can enqueue the
watch with call_rcu(). Enqueueing the callback writes rcu_head before the
grace period has elapsed, so it can corrupt info_id while the object
remains legally visible to the reader.

__post_watch_notification() then merges that value into the notification
info word without masking it. Pointer bits can corrupt WATCH_INFO_LENGTH
and make post_one_notification() copy beyond the posting task's stack
record.

Give info_id storage separate from rcu_head so RCU enqueueing cannot modify
it. Place it after the kref, which uses existing tail padding on x86-64.
Mask info_id with WATCH_INFO_ID at the point of use as an additional
invariant check.

An unprivileged shell and keyctl reproducer was run for 30 seconds in QEMU.
The vulnerable baseline produced malformed notification lengths, while this
change completed with 288631 key notifications and no malformed record.

Fixes: c73be61cede5 ("pipe: Add general notification queue support")
Reported-by: Tong Liu <lyutoon@gmail.com>
Reported-by: Qi Tang <tpluszz77@gmail.com>
Reported-by: Zhiyu Zhang <zhiyuzhang999@gmail.com>
Closes: https://lore.kernel.org/lkml/CALf2hKveij_sHgANY9Aktm1dPa4wfKjKNkHyp9yPbjORWFXagA@mail.gmail.com/
Link: https://lore.kernel.org/netdev/CALf2hKvp0NPVLwr=a3+jUHtPohxbra8gox+aYAfWathJnn-J+Q@mail.gmail.com/
Signed-off-by: Zhiyu Zhang <zhiyuzhang999@gmail.com>
Link: https://patch.msgid.link/20261029054136.1174216-1-zhiyuzhang999@gmail.com
Reviewed-by: Bradley Morgan <brads@mainlining.org>
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/watch_queue.h | 6 ++----
 kernel/watch_queue.c        | 2 +-
 2 files changed, 3 insertions(+), 5 deletions(-)

diff --git a/include/linux/watch_queue.h b/include/linux/watch_queue.h
index 45cd42f55d492..b1fb40f0494d7 100644
--- a/include/linux/watch_queue.h
+++ b/include/linux/watch_queue.h
@@ -52,10 +52,7 @@ struct watch_queue {
  * Representation of a watch on an object.
  */
 struct watch {
-	union {
-		struct rcu_head	rcu;
-		u32		info_id;	/* ID to be OR'd in to info field */
-	};
+	struct rcu_head		rcu;
 	struct watch_queue __rcu *queue;	/* Queue to post events to */
 	struct hlist_node	queue_node;	/* Link in queue->watches */
 	struct watch_list __rcu	*watch_list;
@@ -64,6 +61,7 @@ struct watch {
 	void			*private;	/* Private data for the watched object */
 	u64			id;		/* Internal identifier */
 	struct kref		usage;		/* Object usage count */
+	u32			info_id;	/* ID to be OR'd in to info field */
 };
 
 /*
diff --git a/kernel/watch_queue.c b/kernel/watch_queue.c
index 506776c113794..b7f366e037835 100644
--- a/kernel/watch_queue.c
+++ b/kernel/watch_queue.c
@@ -214,7 +214,7 @@ void __post_watch_notification(struct watch_list *wlist,
 		if (watch->id != id)
 			continue;
 		n->info &= ~WATCH_INFO_ID;
-		n->info |= watch->info_id;
+		n->info |= watch->info_id & WATCH_INFO_ID;
 
 		wqueue = rcu_dereference(watch->queue);
 		wf = rcu_dereference(wqueue->filter);
-- 
2.53.0



