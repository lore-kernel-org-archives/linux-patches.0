Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794591312;
	b=RVoxuM/MXRYG1T8uVe54F4jajdgcUij1WrZT2rGFfbejOTNCcgLFsk5GphE1OwNyOY7U
	 h+3UuLXGaGu0BdQrg5KRIvv5wk66+9oAF9IaOxpLwYnLPYeCrdVvlzw6bmWFKd3NGyrge
	 8aLE7FzgGCi9VqCZZtOjvgKRDWV3RcbSOnaLFB6gbhx7cDanXdjCuG27MJXOYXCgGF3Wc
	 emoqtEP3cjZvk3qJyaBnQ/Df7nNPDt0MofB6lOliv6kFMuy+e3y69gtBYhneMw9OI7ufD
	 ZIXKyQ07SErRKnnLwF/qeVVNCmK0y4FHynwfl9zhADkj1G4X8bAE7VmG6JVoxnp52qA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794591312;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=uDBH4/oyl3W++/w5Q6gfBfAin816jSyTKfCB9QmYRE0=;
	b=ofAShuWTv43/jw/ccY+rSQnM9SMr2A5+JNnBGNy8JbE6LogrAYuUurLuSAa6WfhUvmH0
	 /GYOo5w8lSYKnK9tyEQCmHo+vqH8lCJKtCYDj7g+XxwJuwpKrKeNEIrp7E5uvCOJHZ9fG
	 ZMDT3+XrPnDrI532TS3aJciXjYrmmWBk8LlAEu/8k2Qnf2kSp0laZs+TrNzDfBrSt/WMp
	 Zkn1J9ukWia1f/NHUVUnX7UtLfDMzXZ6E+X+d1UKbZ/i+DRnBM5QkiTj8wW2fW3Nda04A
	 XexpPtwo9bpyORaM9waEyxoK8QG4ucrbt4LuICOxVHm7l4Fce4IXQBDvl+M9cgxp+AQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=hd68oIus;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 367B6606B213;
	Fri, 13 Nov 2026 17:35:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=hd68oIus
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D6E0D1F000C4;
	Fri, 13 Nov 2026 17:35:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794591312;
	bh=uDBH4/oyl3W++/w5Q6gfBfAin816jSyTKfCB9QmYRE0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hd68oIus25zufiocueVCeWa2tqdX3CQmkzr69hCkKGe88V1QImX42jQAapXPoT677
	 c18helM5lf+KQ31Rm/02LvznGyirTXwkT4nWIiC/jMdBtywjF4NpDmhBoYOv7+SiOb
	 g1+/QCrZjqj5tLd0LQdFOUukv3+KvXgTckqWvWBc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christoph Hellwig <hch@lst.de>,
	Qiliang Yuan <odys.yuan@gmail.com>,
	"Paul E. McKenney" <paulmck@kernel.org>,
	Keith Busch <kbusch@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 385/670] srcu: Add list_splice_init_srcu()
Date: Fri, 13 Nov 2026 10:49:09 -0500
Message-ID: <20261113153824.814409543@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153811.177190860@linuxfoundation.org>
References: <20261113153811.177190860@linuxfoundation.org>
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
index 835bbb2d1f88a..4958b16d187e2 100644
--- a/include/linux/srcu.h
+++ b/include/linux/srcu.h
@@ -18,6 +18,7 @@
 
 #include <linux/mutex.h>
 #include <linux/rcupdate.h>
+#include <linux/rculist.h>
 #include <linux/workqueue.h>
 #include <linux/rcu_segcblist.h>
 
@@ -58,6 +59,41 @@ int __srcu_read_lock(struct srcu_struct *ssp) __acquires(ssp);
 void __srcu_read_unlock(struct srcu_struct *ssp, int idx) __releases(ssp);
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



