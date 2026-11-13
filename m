Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794590505;
	b=eNm0ErxhWSbkFAl58zJkXUFNESVveD9LwhtB7d4xX/jVQrlELrncEJFMZMrDXl2I4ac8
	 suYdaz6Ve+9uenT1Bm3zlrTyAFmH9wj/FjG1sRqlQdqVo+xR8Oogbo2Cf/66kYLi6eVtK
	 ZGSWq0i6dysbcuoXdfnQEvj5IDyaxHiM1DmHHwhqIOm9O5+cD3hPzE2kny0/BDNRFTS0g
	 MUaHldkFRwMPvErWQlAE+E6nSUz07gdReqMN1lWn4Z2jw/7yb+gzrVl4GOagQ6h+nnK34
	 sCRCMTuBzaZB4ArBhzBgTx1wXVI9CQy/dL2+aXRG7se1Uugrfq86SG4tA4b6cit7hJw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794590505;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=hU2rt7doijvx4Q17xbDJFcvTg2GPZLXTDvcFDMKi+vA=;
	b=abIfWDHmvwRMp/QdIESE2xt+OgDQCtRry4qCUJB3LfDUh0FXJTro6nqRA59wdCk+3AgM
	 EwxpFllObtIecpfJJR3vZA6k8+JiLh6eaPCLbdAmoF5yBZWudtu36sDZLP9HvF5zi6dOe
	 DEYLqXYE6asrzf1YifpT3PKxbWNCxuYQi3OpFAx1Kj/wEFJEmdjZYB5rkijPDXl4OAL+v
	 RYY4faYUUaZ5kA6fQ5RR/UBzj2zUrhyhjbVCDzIe5qric68c5XCnDLHz7vgSnxwPmWF6F
	 UO+OXFrXfow1qzUVFUavqvrfaWFBkKKAnpBFZ3Qrg6Ei1oNRsFNsWCvlqe2/W0OCFPg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=qTq382vr;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4CD22607320D;
	Fri, 13 Nov 2026 17:21:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=qTq382vr
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ADEB01F000C6;
	Fri, 13 Nov 2026 17:21:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794590504;
	bh=hU2rt7doijvx4Q17xbDJFcvTg2GPZLXTDvcFDMKi+vA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=qTq382vrHGOz4iaKANq2WO0NWHKLC3TKAOWm2KcSfZe5G54zLZg1SNPoKtS9LoeHA
	 JSlSjE29vYXkooVOci+KvZQ1jUqYap1+fJGkKkH18Sq/6/4YGvBlc+H/oP2XMjLzdH
	 o3uj7mBCbcFx9sPq95lz+yCKzEo16Zp+DThc7Gpw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christoph Hellwig <hch@lst.de>,
	Qiliang Yuan <odys.yuan@gmail.com>,
	"Paul E. McKenney" <paulmck@kernel.org>,
	Keith Busch <kbusch@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 450/686] srcu: Add list_splice_init_srcu()
Date: Fri, 13 Nov 2026 10:49:43 -0500
Message-ID: <20261113153836.121920849@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153820.902362109@linuxfoundation.org>
References: <20261113153820.902362109@linuxfoundation.org>
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
index ada65b58bc4c5..d4fa064600f64 100644
--- a/include/linux/srcu.h
+++ b/include/linux/srcu.h
@@ -18,6 +18,7 @@
 
 #include <linux/mutex.h>
 #include <linux/rcupdate.h>
+#include <linux/rculist.h>
 #include <linux/workqueue.h>
 #include <linux/rcu_segcblist.h>
 
@@ -68,6 +69,41 @@ void call_srcu(struct srcu_struct *ssp, struct rcu_head *head,
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



