Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795039186;
	b=QDZdkXPw8NIpbo/k7AgBsHxrJOB/K3m/YUBSXrqFgy01Md1oEV0pUsSvvBH1eoyO5hpa
	 5a2dQCpsN9W01jiyyIGtstl8wvnTJLmFLTWASIuZAdgWQydjRx7kqQXcZ6TCrdHNeS6+s
	 CtDDtWY/IhWkCVQk03sK+k6cXWsUATG9CamtKr59O3LZZ22rEoIgtEgIxa4ZjUFQPbaWw
	 1/ELvdbMLp2NpppZNJk7mL3J259ZmHTN2zBdXBPIRtED+x/5MvYZCj6tqPaz1SoV7mUvl
	 E+utEGgxZZymfWiZqt+eThhf4UW1OGZJVd/4o8dyPHgNYoq+U1mXkiDPfKY1fJ/kqAA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795039186;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=DWB36nss7CRiqIrebWicyho9F2vZG6BI+MHjJ3aE7iE=;
	b=3MhfgGlfUQDTNJ4V3io8A1KGUoW6ctN/7MPkRc96z/5qhcirKeXcmDeozSWX00QbPrpX
	 zsBDG/YDOhzi/IwvlG/9euN+W/JjH3p2f9qBBtkNUZ8MOuRHRe/ykLHNJOfaxUSSB0f3+
	 2gz6PO0qBAbgxZlgduvIZAz1cb2hfYZgRngtJJ6ROSHhbTPjWoLudLOxOJs71uUPjhPxI
	 lEGy2RyGL5rQTlhuv8cEbmZ9l2Hf1BPSH/qNSN4+HjseMGSqFT30OSEw0JRWbU4HFDPGv
	 Jn6GVyHJuEZhXQ9jp/c0QZp0AScGq3esvuucBks1Gu9D/Mv14/WLp+ADWTms5KKeIug==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=jv9x+1xp;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4BD84606A31C;
	Wed, 18 Nov 2026 21:59:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=jv9x+1xp
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9DE551F000C4;
	Wed, 18 Nov 2026 21:59:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795039186;
	bh=DWB36nss7CRiqIrebWicyho9F2vZG6BI+MHjJ3aE7iE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jv9x+1xpqOZfhYEmD/EHOmPULfyT0HHBd0i7dD4QU3Z/nphcBmJmwvZF1Eeem40Mt
	 MjcFpxtMISyL1K24/P+RvVoB3taqWwIzhgQ15do+gqo+m7gqeiayyrv+CBbffHNsGC
	 /fAdlIKb72j6LvIjIzeEW2619cQH2Pnlz9rkTmWU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christoph Hellwig <hch@lst.de>,
	Qiliang Yuan <odys.yuan@gmail.com>,
	"Paul E. McKenney" <paulmck@kernel.org>,
	Keith Busch <kbusch@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1968/3318] srcu: Add list_splice_init_srcu()
Date: Wed, 18 Nov 2026 15:43:10 +0100
Message-ID: <20261118150421.125633671@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
[ sashal: Adjusted helper placement to follow existing SRCU declarations because synchronize_srcu_atomic() is absent. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/srcu.h | 36 ++++++++++++++++++++++++++++++++++++
 1 file changed, 36 insertions(+)

diff --git a/include/linux/srcu.h b/include/linux/srcu.h
index f664cba7a80c2..7b5be712a79f5 100644
--- a/include/linux/srcu.h
+++ b/include/linux/srcu.h
@@ -18,6 +18,7 @@
 
 #include <linux/mutex.h>
 #include <linux/rcupdate.h>
+#include <linux/rculist.h>
 #include <linux/workqueue.h>
 #include <linux/rcu_segcblist.h>
 
@@ -61,6 +62,41 @@ unsigned long get_state_synchronize_srcu(struct srcu_struct *ssp);
 unsigned long start_poll_synchronize_srcu(struct srcu_struct *ssp);
 bool poll_state_synchronize_srcu(struct srcu_struct *ssp, unsigned long cookie);
 
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
 // Maximum number of unsigned long values corresponding to
 // not-yet-completed SRCU grace periods.
 #define NUM_ACTIVE_SRCU_POLL_OLDSTATE 2
-- 
2.53.0



