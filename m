Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795052098;
	b=PmaBLBNRl6Rq9chR0tDEboVfvQ+/J+TNj7DGjNAxyBrxPVm7EZa8Vo/H8PVSuS5VkqEa
	 6C62Tx3plSpRlBDbkPBKcSnv48QgYzk4Und7hYiElq7cLQeI5ZV+3kP5IFm3HhqHJk6/5
	 CfjosIiHy5CRjkOs+Gb2PW9EFfmqT61tGlRgrwecsUh+bePez1omlF+cNOFOJo+W8U/Iw
	 pNgk/QXbR7ta78eKFi+ybIPHfjMAhDeMYLzl8sSyX51Wm2wdJ7P425d0+BspZ28W68DD0
	 AIJhZ9rBihXSSnY4YXFU2jymIul3TT5sqG8Kah0FWCekj/d6uEDnGEzJmk5LhLINAxg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795052098;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Lqhuuvww3jiZss0eYHmR1i7rHrskJW8T6fGne4Ye4tU=;
	b=Y3m3zdePvoTsitNcNLlwdA2TX/WOwfbNexxkQy7GJ+UxhOIxQ+J0VMr9Tq5wHIPovz4k
	 /4hjv3lG5xwnLVXilXapAfcDERMbKrhDRCrxNgKbvEM0aLwykSXxfCNbHXhhtgCY1cAri
	 /B00tEiNsdD2RzBAcFqgpC/Rj2oj7KkHNZDzpJ7p/x4yNHZZShAxn5BOx1Wv6AszX8KGs
	 PSKzjVmyyf3D30/F4So3X9YrM04QzlLHMuR7ouHZQvoejiP7clzkRD0oqVGaGnzVd3cud
	 JCM0WVc5rWs1EzXor+NSYYaxjZ6RKzxn0snRAqsu/6DWeZ4us50YyVKs2JLJx8gA1mA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=YDBH63Fx;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 50E00606A31C;
	Thu, 19 Nov 2026 01:34:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=YDBH63Fx
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5DBCF1F000C4;
	Thu, 19 Nov 2026 01:34:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795052097;
	bh=Lqhuuvww3jiZss0eYHmR1i7rHrskJW8T6fGne4Ye4tU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=YDBH63Fxryj/F+Xsis3jK1A6y9zz1a/QqtSUZ6PpCqpZVF8VvH67Ijf/sq7NRDRcL
	 1CZhaeahjmfL3WRr5BNZ9oI1MTY7FkSDLZYDXuf0h7NQ1/Bnlcc8WQogIdxZ6K8P/K
	 uyBg5uYZG7y6o3mlr2542KXyDFDCY0ERpvba2HyE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daehyeon Ko <4ncienth@gmail.com>,
	"Christian Brauner (Amutable)" <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 0443/2214] ipc/mqueue: release notification resources during inode eviction
Date: Wed, 18 Nov 2026 15:35:19 +0100
Message-ID: <20261118150028.806119389@linuxfoundation.org>
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
index 089c34d0732cf..90286f0a69db5 100644
--- a/ipc/mqueue.c
+++ b/ipc/mqueue.c
@@ -530,6 +530,13 @@ static void mqueue_evict_inode(struct inode *inode)
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



