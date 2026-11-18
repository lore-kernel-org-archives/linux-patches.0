Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795033276;
	b=Gs3SECCx28P3Y6TE6f4Rp+KUY2GIkh7AWyUkYIAjJmOMsaVHREjzfujDBdaIFpBhKStt
	 D3KJZ+HDg6UNtgwSp8XlICUHNtoj8Dldql8DBUYuiroJeOpVoCRI+dPqsYBsTqFQi02G6
	 /JXfUe7q31Jz6GnpHrI22eufrtVkEMnXDLMHa66JnFFNXBOb+nUWVniVr+rhuKBU0q+PU
	 WzNVb44iZwd0NDtsXWxiWfq5TxB0y+YBpn11ArbyAFrT25WI0tVetb71ZfAFQIt9M22gc
	 FN+izXmxBsun1HAUPuDT4+wTzLI7E1htz/1ShyELEtiFnD95m4g4mTCtjwKRl5uK6jA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795033276;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=2ab9vX+XqFwRvYeWqZAIyvRQXGXppqqCIkz6EEFgdPU=;
	b=qnTBzfN/xglnlTK6zN+HBbgoaf9oprtgCOz2HkW46oGDlt3HAz31UXpdc7p00BjR3UVL
	 nezm6fMDnrAbkiXYYzD6/wZ8MgPnIp4gFBR4iyAvZkyOY5vVQfl+OWdwiMnzrcBamG3MM
	 5tM10raw467cLUBnZwHLzdaQlLV6Mn3z7FHLTrYZmLQ6CRgeQyL6DKDydiEySEZmRNmrV
	 P2dFxlRmH/LiDTE/xtCdFE4fqSRML3Tzn1Dlt7K2r/JyknQ3pSd+olUJhoq3WID8f9/UR
	 u4UcYk4rTG1KyahRJDoeaSxSGjBnlcwLmi2XbNvihuVHTzHe/i7cPESUT3ZG6ynH0Eg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=OyPYgdvf;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 54AFC60A260A;
	Wed, 18 Nov 2026 20:21:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=OyPYgdvf
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B43C71F000C6;
	Wed, 18 Nov 2026 20:21:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795033276;
	bh=2ab9vX+XqFwRvYeWqZAIyvRQXGXppqqCIkz6EEFgdPU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=OyPYgdvfpc6VparWVIuKV6kfMbQLWTTUYoVZhDmBfpz+m9fhZ3vUdvzqTi9IcLkFT
	 p+icdGPZPJGr6CYfTOjdTTa8eA9eDmrAhkUCxSLkSxjPvdyqKkdzcLyw4Wo9yqsdyW
	 jQViPMXEiFMu1e/WNzJP8MHYDKfa6ZR38d+sahxs=
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
Subject: [PATCH 6.12 1711/1756] watch_queue: keep info_id separate from rcu_head
Date: Wed, 18 Nov 2026 16:03:58 +0100
Message-ID: <20261118150117.735864430@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 8f809cc60c036..8914bd27d751c 100644
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



