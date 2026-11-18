Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795028370;
	b=JEgPp7WJAne7MJy4FFKAuLZgIi/OW6IUwafOAntjpczeaB5zx+4JMG/vo9sydnilSNQ0
	 0QjVHFP3wzxEbGwmPMMRGnVwGB8rSEUt2VRlyY2DuNWRkVu+fxZA9BqvNMwX9Bb7TnBHj
	 fZ+A46VRWDaIgzQCbuS+n++bwA/CrvQLMw9FdD2JalLYezkE+qwRrjMoivLvL9YqFmx4P
	 C3Um2/gJYO6I7VG8jhq42TIWeA5F8yKIfvC5fgzVPOKOEXspiz60Uo9wKkpQhs6Hz/apx
	 K1TfUlRSvHx8K97KYaFEy8uyaaMlaxU2dEgEZ4REL3WvjzfQyxOpoFeLTALCIcjZovg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795028370;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Llclz/6pf+EQqW2bmst+X1O+HmJuFs7tQPdwQ9+L+AU=;
	b=S1DXYrIZ9biXiL0E3DVy3SzcQYKgZ35h5RRx3qFz/+cD3bgoJxcQ2TNuEw9FuG8CywpR
	 WXfNl5FR6gTATnY032kGXouQhpMxpeYY0WSSnjcDslOECHK66x0Trel79nH/7tCvFNHui
	 2efWPD9d0AOdnRWS66/R8teMSP4INFWhpDs6f/adu3iAnPe15z7ME3VmQiQngWNMzlU8n
	 kLp/QF6TbBwHtCCSSrkrEj68FmmgjNDCkbV+tm3p+EM+3EY0G2186VlYfQHbyzYiQoz3u
	 R7WVPTkcgF4woGVxfyzJioQD8qZO+QyzbzhzWrxE7nGxRSgmHyRgrmo24qn5IGWJ7oA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="xDOem8/x";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 31E9B606A32F;
	Wed, 18 Nov 2026 18:59:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=xDOem8/x
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 89C6D1F000C4;
	Wed, 18 Nov 2026 18:59:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795028370;
	bh=Llclz/6pf+EQqW2bmst+X1O+HmJuFs7tQPdwQ9+L+AU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=xDOem8/xjCiAxpMZpPMGB4l4JsfiTNV7mN3fn7WYz6xyP7eWENEVrJBi0YM8A5XPr
	 jft5BSKXj2OWzE89vEfQOlQ/SCqIBtdSZ/JDftO+AvLNH6uug09fezjabHCViVP+cc
	 v9eUiPU5GppNoWCOMuZ1R5RXWprIkzll3gtsNIYg=
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
Subject: [PATCH 6.18 2120/2151] watch_queue: keep info_id separate from rcu_head
Date: Wed, 18 Nov 2026 16:04:15 +0100
Message-ID: <20261118150238.918703868@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index 429c7b6afeada..b87e1babb5f03 100644
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
index bc8d6b641ed43..0c413613ffe2c 100644
--- a/kernel/watch_queue.c
+++ b/kernel/watch_queue.c
@@ -212,7 +212,7 @@ void __post_watch_notification(struct watch_list *wlist,
 		if (watch->id != id)
 			continue;
 		n->info &= ~WATCH_INFO_ID;
-		n->info |= watch->info_id;
+		n->info |= watch->info_id & WATCH_INFO_ID;
 
 		wqueue = rcu_dereference(watch->queue);
 		wf = rcu_dereference(wqueue->filter);
-- 
2.53.0



