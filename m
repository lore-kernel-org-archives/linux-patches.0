Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794585896;
	b=2NdZyBYTt8Zk9x/XyvfxmTthH5tJfTa94RjozfkKZuJpHhGfN4eeNUXHI69QUwKdPeuI
	 v+WRL8UFSXD1uEBeVdodcwULN/SfaqsV0wsiaIwKXJdP8lIg+TZGS0iJUAnD0Fu/ldF/A
	 hqGJKMbmvi+g60LQpVdCSPw6revfu6/7kFJlKyvNVGC0SHsWzn5crHfNg35tmBB4r45yA
	 qYZ2o3Qs+c0PNqx+mVGaTPRIh0WlYIOsapiN9jpl7x3AfLF64EN1ON/QpRpFz++UTzNhc
	 c9A6AAi6pYZq8wKpo97wO9m6W/N5MsTcZphjbV3n1LMwU7tMRiQjubRTOWei77Gu7Bw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794585896;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=PvXC/BJRuZUlPPDdTRjhntTTCdKrfSZzA6e7BEQ22kg=;
	b=nS4BL+AOE/jratzJYMGDqDnVvcoLXUdL2fiYE61CN6GUOcTzdn0LnJsuRPHm/BHN1Xvv
	 NwUUDfJYFEvCDRixnG8NM84UFuipHj6m8ByW8hD+hArf3AcNEfOEnVnijeSpxb3g4q1HW
	 iXrWdAKhHCJPCgXYfZ+IhoU7bcDbD4Qezip2oWAPZQIPJZFDpTfcYN9QJA/8MKW2i1ET/
	 GjQuFMp35t+4qLyMYJwhDBuMU4FJAcyHD4fKiBylxVN+Hjiblm9jk4Yu5RBhKHjhe0SGv
	 Y2ZK7ufGjdTrOxoygz2imnBepI+kTgZ23kl4HLRVGJsiG53YipThLrExHHzHlGq8RGQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=sDhIMlRv;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 401AD606EABB;
	Fri, 13 Nov 2026 16:04:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=sDhIMlRv
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CD7DC1F000C4;
	Fri, 13 Nov 2026 16:04:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794585896;
	bh=PvXC/BJRuZUlPPDdTRjhntTTCdKrfSZzA6e7BEQ22kg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=sDhIMlRvpIXsDbenEasQ5mRlONEOTy+QgmLN8WFpvZ52M9b8Eb/hcFOvAhjFpVP3O
	 QMLGNKZNnougYl/P+FvBGcTCVTkq5iVmmUJxr7gXrZWR+rsZStUxCKm+3NDdYr4dxg
	 zKg1UW9IDZvplakJ7jbfcPsU0BYy+nx2kWe32sG0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christoph Hellwig <hch@lst.de>,
	Qiliang Yuan <odys.yuan@gmail.com>,
	"Paul E. McKenney" <paulmck@kernel.org>,
	Keith Busch <kbusch@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 419/507] srcu: Add list_splice_init_srcu()
Date: Fri, 13 Nov 2026 10:52:03 -0500
Message-ID: <20261113153810.930006720@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153753.358973689@linuxfoundation.org>
References: <20261113153753.358973689@linuxfoundation.org>
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

From: Qiliang Yuan <odys.yuan@gmail.com>

[ Upstream commit d06917d0ba226206dbd606330d73a8eb1e3029c1 ]

list_splice_init_rcu() makes a list look empty to new readers, waits for
the current ones with the given sync function, and only then links the
entries into the new list. The sync function takes no argument, so it
can wait for RCU readers but not for the readers of an srcu_struct.

Passing synchronize_rcu() for a list read under SRCU still builds, but
leaves SRCU readers on the entries while the last one's next pointer is
moved onto the new list head. nvme_remove_namespaces() does this today.

Add list_splice_init_srcu(), which waits for the readers of the given
srcu_struct instead.

Cc: stable@vger.kernel.org
Suggested-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Qiliang Yuan <odys.yuan@gmail.com>
Reviewed-by: Paul E. McKenney <paulmck@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Keith Busch <kbusch@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/srcu.h | 36 ++++++++++++++++++++++++++++++++++++
 1 file changed, 36 insertions(+)

diff --git a/include/linux/srcu.h b/include/linux/srcu.h
index 7d9bc06df98d0..1c221861ba43f 100644
--- a/include/linux/srcu.h
+++ b/include/linux/srcu.h
@@ -18,6 +18,7 @@
 
 #include <linux/mutex.h>
 #include <linux/rcupdate.h>
+#include <linux/rculist.h>
 #include <linux/workqueue.h>
 #include <linux/rcu_segcblist.h>
 
@@ -103,6 +104,41 @@ void call_srcu(struct srcu_struct *ssp, struct rcu_head *head,
 void cleanup_srcu_struct(struct srcu_struct *ssp);
 void synchronize_srcu(struct srcu_struct *ssp);
 
+/**
+ * list_splice_init_srcu - splice an SRCU-protected list into an existing list
+ * @list:	the SRCU-protected list to splice
+ * @head:	the place in the existing list to splice the first list into
+ * @ssp:	the srcu_struct that readers of @list use
+ *
+ * Like list_splice_init_rcu(), but wait for the SRCU readers of @list
+ * instead of RCU ones, so that none of them can follow a next pointer
+ * onto @head.
+ *
+ * Note that this function blocks, and that the caller must prevent any
+ * other updates to @list.
+ */
+static inline void list_splice_init_srcu(struct list_head *list,
+					 struct list_head *head,
+					 struct srcu_struct *ssp)
+{
+	struct list_head *first = list->next;
+	struct list_head *last = list->prev;
+	struct list_head *next = head->next;
+
+	if (list_empty(list))
+		return;
+
+	INIT_LIST_HEAD_RCU(list);
+	synchronize_srcu(ssp);
+	ASSERT_EXCLUSIVE_ACCESS(*first);
+	ASSERT_EXCLUSIVE_ACCESS(*last);
+
+	last->next = next;
+	rcu_assign_pointer(list_next_rcu(head), first);
+	first->prev = head;
+	next->prev = last;
+}
+
 #define SRCU_GET_STATE_COMPLETED 0x1
 
 /**
-- 
2.53.0



