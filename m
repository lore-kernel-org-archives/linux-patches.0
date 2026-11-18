Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795057008;
	b=cWxiXOsnfs3hO9bgHTKgTuscpQVM4n6jKX6An3os6jj8DTG/ows0tQCW5WXH9iRQbxmb
	 gkA3CeFSC1g8tvmpae19dlPEjVNy740MUFaoe331oFDIwpT9fHXwxzYHgBHFbvI0XvTJV
	 62abPMTDLG2rT/qyZW9mx+lmDWtPDjKrZtnKBkrXY8uIn84tbChr1k4SVY/Ouajf0M1Be
	 IUejLW7yslaA9wBxJ9y0vWwUa4XnXFsCu5ArWHHD6w4sIcVV+yo6zde3VqVjJcAOYm2aX
	 0lJCp0QcqTh+AuXQyPMGLNVFRp0MyQNwkmxKqAtCeFEAK3wJJirLopWNGwnm4Do0X0Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795057008;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=riiBg2LigYUpTpcVwDRdAGcWBshoGVYFWiDAEdVJ+QI=;
	b=4VxKIiT5ccVSkRvWhZx4mH1u5Bv4hSu9h+a0nDYnI7HHMcDzwjHL/GEIDp6pJVD2lms0
	 dZlUzdrdVONzQZSHS1MOX/bA5pqD90615Tgvfpuht+zGII721CSGWsx51F5l8NATVm4M7
	 ROBduyUoInviZe+1tGp7mXJTvuoCjmKJe+fkXBapj97Vpsjo7q1SfjV59PEJGaOki1Au1
	 CQeee3aoHoID7kaSwJIy9QAcq5zdHBLWJoJ25gKyrH60kj7SXY5Xd8rNLtesjx8NrSzjM
	 XHcTpG8/zg/mYJ61/LItDbkXW4ihyUMlm8SFR6rJVnZONyWG+9uzXn50kBod+o5PWYw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=tAXg7yfO;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 692D3606A330;
	Thu, 19 Nov 2026 02:56:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=tAXg7yfO
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C66761F000C6;
	Thu, 19 Nov 2026 02:56:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795057008;
	bh=riiBg2LigYUpTpcVwDRdAGcWBshoGVYFWiDAEdVJ+QI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=tAXg7yfORaH7Kb2uYqFKYCF4gMACEDWcm2pvv3N2R/iGhMML9FtzInkE7XsfnmWO7
	 1HC3kp3Fl9EAzlsH1hA+7zUPe2V4Ny8VZ7pddLbSTgEUli2LLYadFSWuTWSwOXx4/J
	 lOx83g21KMRv90B/cfJ3Dh9q5IkWgQbHdWfOqzzE=
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
Subject: [PATCH 5.15 2191/2214] watch_queue: keep info_id separate from rcu_head
Date: Wed, 18 Nov 2026 16:04:27 +0100
Message-ID: <20261118150137.976624491@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 3b9a40ae8bdba..d39a1b384097c 100644
--- a/include/linux/watch_queue.h
+++ b/include/linux/watch_queue.h
@@ -53,10 +53,7 @@ struct watch_queue {
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
@@ -65,6 +62,7 @@ struct watch {
 	void			*private;	/* Private data for the watched object */
 	u64			id;		/* Internal identifier */
 	struct kref		usage;		/* Object usage count */
+	u32			info_id;	/* ID to be OR'd in to info field */
 };
 
 /*
diff --git a/kernel/watch_queue.c b/kernel/watch_queue.c
index b14dbef344996..245d48c2191b0 100644
--- a/kernel/watch_queue.c
+++ b/kernel/watch_queue.c
@@ -217,7 +217,7 @@ void __post_watch_notification(struct watch_list *wlist,
 		if (watch->id != id)
 			continue;
 		n->info &= ~WATCH_INFO_ID;
-		n->info |= watch->info_id;
+		n->info |= watch->info_id & WATCH_INFO_ID;
 
 		wqueue = rcu_dereference(watch->queue);
 		wf = rcu_dereference(wqueue->filter);
-- 
2.53.0



