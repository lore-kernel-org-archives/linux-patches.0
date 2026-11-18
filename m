Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795062260;
	b=MsCIQXVLDzRaz5Y+B7tplUWMSKABJ1o4j5bUsm+A/NqGmLLZDrDg+ZhxsAdZL8o4svLF
	 A9hST2+fHRKLveXx9kO2iVqyCL+k6fXzdUDyMLdBveY9TQpMaFdyL5xukDwEKLCPEbLh4
	 fY5EF3JbBy2c6Vp3MDQH2/avpeP4wYWrDH8h+G5sEUHXAQPDbcv2zumMJF7Nf2C6e7PCJ
	 Gl/cC3OzSXDlAm7DzvUDkvqDgO6T3hswLPnZ0VFXOofTKbyyi+BCEd56lVRI8SvFAEhHE
	 j6sqJdvY+AiBIKMYchlrmOgwcqMtSSUrq8m18HBp3OhtbbOZXdQdDwqNqin5+BWszKg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795062260;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=UrWzWtlLL8alzYXy3xOsx9o3wBLwkdc3GwPoqE+HcLg=;
	b=zIsigeH+VgySWM2fMBuR42NcUbiKh8IWKHi+I+3ko53yGbPHmp0m1GdtfQLFgKXNLdKV
	 vtCExUq0Hu4FPNRzk6vms0gtg9APhiX8TIeo5FN78J0obJ8Eh5qGe0hr8OOCTib8j8Wqg
	 fr1be9A4nTbHJaHENNgN1YFRoc6yEIlxhnAtZQAah50U6dD8CziSYde7wVKfnCAqzTOt7
	 /ZCrONtguF/eZVIOzgbuCw3SHntCoZmXSUWcpLtwAPCq5UT5v/rEAzDrBRX86h+G1M013
	 h8+bdybXkRYTJ5x095x8ZeKDTaKuRZ4/UhCaMV2RgaHB7mEd8/SXlGw4rUWgaNA+w9g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=LNQGvTkT;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D5993606A32A;
	Thu, 19 Nov 2026 04:24:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=LNQGvTkT
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3C2ED1F000C4;
	Thu, 19 Nov 2026 04:24:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795062260;
	bh=UrWzWtlLL8alzYXy3xOsx9o3wBLwkdc3GwPoqE+HcLg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=LNQGvTkTJVpzAnVhbcQLSKwiJGIxNkm51+4awhl9I8eJLUbCLDszxgLgt/TRwVi5X
	 swiOsQjzhtNsuN8nlpfkYyiBQd/eJWA9cYJhog1bVwtOYcSTRAcKLe9rO82n4GoDO6
	 6YytgybSNjb59j/DOdmxZ9KH01A1bX935jovT4zg=
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
Subject: [PATCH 5.10 1820/1848] watch_queue: keep info_id separate from rcu_head
Date: Wed, 18 Nov 2026 16:04:18 +0100
Message-ID: <20261118150035.790046536@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 978c29b1fa427..585b2d6e67085 100644
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



