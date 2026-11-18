Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795058111;
	b=mK+Vd6ym+Ae3GXoA0voeZUsW/tnWmUT00nq1Yi7T4c8H0PBKOA36ZYIZyePhCu2zoI7u
	 qGyMysIzO8kmdQ9QZfLl88Ze9wEKU6n0yHtbu2Fq9GX11+pnlKOtQPNksaoYDtQUXqvJk
	 XOmIpdlqG8vDd+yBhyz4uoEQRCJfgkPjn83DScWBtCclMPFrl2eDKna9vkMN8xi6bWPyO
	 +r0Q9vLl+Hd4/tjCM8VhYskV/Yu1bbrNAYhCdXrDcd/DGeIGbRktt/XHXygYvnRtbEIPp
	 OAI/29uVLMNeorCIikLnUhDtQJ+jIXxlTy85QN1D4U9FNQslvAFQgV8Nee4sx9O/eHw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795058111;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=m34i0kduLPyfJa+iCacgm66OfV06RB8TN8rf0J9S5n0=;
	b=RL3p4iJr7i+UndpZ3VUt2kGaw9nqJfeBkQtvJ5fC7zd91bbYDfeS1m2hyyUidg5HOUHu
	 suvs2wxqlAwJkmzqbERCyH9hM2b0Hf2k28n3u7vVXmjhvei5ae+wCh9w/AReyV2HchzgR
	 Q0K3g5XbQXbOSMBLbVe27sfkoqgO/xG3ZtlfWgBtENx6qrLWDNVGamIbZgXxr7hL14L81
	 ucCwUf13NCS4rQLduUuUYsg4ZvSLGZJK1eGSX0g0t0iWLs3ARFAejJrjJSBYxx+US5sSq
	 DIc+A7dLGC3Y5T3zP2F4CJnThYx944ew076p8RLoqa9fc0E64q9Hv80BqO/a8X1aZNQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=dZs7I3yr;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D433606A325;
	Thu, 19 Nov 2026 03:15:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=dZs7I3yr
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A4C9E1F000C5;
	Thu, 19 Nov 2026 03:15:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795058111;
	bh=m34i0kduLPyfJa+iCacgm66OfV06RB8TN8rf0J9S5n0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dZs7I3yr2cJCi5tcvCVVNWDz5tTHaqqhXdfVmalmADn/QKGiNoocXGxv/olRkqni/
	 EsB1Au9QcbFlY4KiK71jUFAJ2nfIyd1uatY0852z5Gp+S8csXoR4kRvb16t0afT+VW
	 eXju3rf9MpZvu7lzE60fQQ/b1opD1woAjpplR1fg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daehyeon Ko <4ncienth@gmail.com>,
	"Christian Brauner (Amutable)" <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 0352/1848] ipc/mqueue: release notification resources during inode eviction
Date: Wed, 18 Nov 2026 15:39:50 +0100
Message-ID: <20261118145927.477305412@linuxfoundation.org>
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

From: Daehyeon Ko <4ncienth@gmail.com>

[ Upstream commit eb85469f0dd69ca145d63117450e14c31f67f698 ]

mqueue_flush_file() removes an mq_notify() registration only when the
closing task belongs to the thread group stored in notify_owner.

A task in a separate thread group created with CLONE_FILES can register
SIGEV_THREAD notification and exit without closing the shared file table.
If another thread group then unlinks and last-closes the queue, ->flush()
skips the registration and inode eviction loses the only pointers to its
resources.

The orphaned registration permanently retains the notification skb, its
netlink socket, a pid reference and a user namespace reference. An
unprivileged process can repeat the sequence with new queues and sockets.

No inode users remain during eviction. Remove any stale registration there
after dropping info->lock, since netlink_sendskb() may release the final
socket reference.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Cc: stable@vger.kernel.org
Signed-off-by: Daehyeon Ko <4ncienth@gmail.com>
Link: https://patch.msgid.link/20260824042359.925145-1-4ncienth@gmail.com
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 ipc/mqueue.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/ipc/mqueue.c b/ipc/mqueue.c
index 86969de170843..eee77f0a952ac 100644
--- a/ipc/mqueue.c
+++ b/ipc/mqueue.c
@@ -528,6 +528,13 @@ static void mqueue_evict_inode(struct inode *inode)
 		list_add_tail(&msg->m_list, &tmp_msg);
 	kfree(info->node_cache);
 	spin_unlock(&info->lock);
+	/*
+	 * A shared file table can let the notification owner exit without
+	 * running ->flush(). No users of the inode remain during eviction, so
+	 * tear down any stale notification after dropping info->lock because
+	 * netlink_sendskb() may release the final socket reference.
+	 */
+	remove_notification(info);
 
 	list_for_each_entry_safe(msg, nmsg, &tmp_msg, m_list) {
 		list_del(&msg->m_list);
-- 
2.53.0



