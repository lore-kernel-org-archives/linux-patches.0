Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795035733;
	b=GJpqE+7myzokk5bHs6mNZqguFil+NVBdVe4Php25LlvZ40M/wpKYC7/zvvqBjA9RRNFN
	 WGdrgxlgJD9+qgv6kOG3UUspAWzdbCfTPHz10YWojDmRKlTy8ugxnxzIoUpWuf0HSzqHu
	 ajh0nykOmuQt0VhwnR+NdzmcT9VkdzxgjiKcYqU5//EfrUqr1uO9s7Sca6S5OfOq4EOhD
	 qRvHYGzmk6z4DuvyUBlrsPDx/6cWZSUDUR0dL6wE4x+qsLwBd0LX1DHjV4H0vAy7mrpLj
	 gjGgiBKlsVezGt6nYZlDeWdTwy+3M4pkBnQnxxeVr0IB3KD+UZK4iQDrtFsDlrEzbxg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795035733;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=L9ePJgqebV0qH6Pj27UmVf1Qp3ff2QKLVeeM/8ej4e4=;
	b=zfXbZT0t6h7l4BTQnBbAzwUvC3K6BBLmXEBmDLRTW8XSMEZa9t2nkIPkoZJEcJfGB8R/
	 9vaiZ8ftcEtD0+HFNbzKat/XXhzut704ueoiv+O2yKkXHDIclM/vMrD+aUI+yYuo0dRlK
	 CjP+0mrgFnCSTi6WZq2jbz72xDdNNyLjbyVj5nOpoEPLiGmgs7zjpSRzrKy4HXHyVRKfp
	 mtTfdgqFtJekNi/ZNw34ePoFcJeNiYD0SePUbYqkgjhF/zC4XXcIYB4xAlBmNH4UbKERc
	 GkyEWR9TCrXieoy4n1/DqIBVDLgzmXXvZpORSRZplmxUmjg9f++jp48f43i6x+2mMkg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=JhUggz81;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D7DED606A320;
	Wed, 18 Nov 2026 21:02:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=JhUggz81
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EC1A61F000C4;
	Wed, 18 Nov 2026 21:02:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795035733;
	bh=L9ePJgqebV0qH6Pj27UmVf1Qp3ff2QKLVeeM/8ej4e4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=JhUggz819lewAZaL++Eo1JmOf+y5Leu0CTjQYX9evh7qVS38YpbLAfSc8vIVy+a7b
	 8xtPny7Q1wfJf9bmpRG2jo/myVIWWeo6Q61iOMe0mqMx1SY5jMfZY92mH84TBnoInw
	 c2bKHp3T/mREpD9k2xTxBj0loAIM7YVGAAIpdKkM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daehyeon Ko <4ncienth@gmail.com>,
	"Christian Brauner (Amutable)" <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0808/3318] ipc/mqueue: release notification resources during inode eviction
Date: Wed, 18 Nov 2026 15:23:50 +0100
Message-ID: <20261118150343.225716278@linuxfoundation.org>
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
index ba8215ed663a4..bb8ae1445f2fd 100644
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



