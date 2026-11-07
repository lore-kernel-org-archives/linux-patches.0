Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794063824;
	b=qUTBv/9AnbPrz10A3mREsmkQLgA8bM4v9u0B4/NZ+HtdcV5grKTzHxn1XAb88ttC1X+A
	 n8BXeO1Kv9sWXr3xuN7vsNOq3fJGDS4tUO7vhBGIYrg77weOTuNqo84h6GSt6Gn+A4Q0q
	 XHQyibQdHF2q/ADqBFwitj8VXFRsmEg/G77kbhJw2bmXEpxtBiJcYeZs8Ke0wMuvYv5SR
	 2QRDeofs7VtcjiScGMom7xfKSAq/LDkVMxr4gh4+mHgBrI7APzGZoR7STm3Q4pIlN6G4C
	 1XMgkcb9RckffzxN4ODB07SvWrF/nZcERp6q3FjbqLQeAjadAaJwKmTAGyVkoStlEng==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794063824;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=n2ssaBCVqMDy+OHs+X/koEcu44YGZSgaGV+bbUozERQ=;
	b=CV41QXYFWQov4k4IDKAiFtL4LyETSo6qxglXoFs4n+80XPq3gWa2dy9ycEWtEcVlu3TE
	 I76oVN3teJEp6MvjkOY9HHLvgKY5oOnT3x8jUQ7UWH37j0cFirYuqEKFmOOBPdCacfDDk
	 SOOnZ00tGjwSJlVhfGt2G1KDH2FUbWouHuj8GPGmhylq8gRQqRyLdJ5AqIllNsAjT7uW6
	 7hiIfEjmPaACPOg0ClHQsNb9vpIJPRKNd1w7SsYvTpjBwR6cXttbAq7T/z5hP8dq2SRnQ
	 H1qNggUd/klzoXHYKZbldC4xEE6W9i1gdk5fjRT2UBWImBzspeO93zFmw/Nj18iFUiA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=AWtYfMpt;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9ACC2606A326;
	Sat,  7 Nov 2026 15:03:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=AWtYfMpt
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 496121F0089F;
	Sat,  7 Nov 2026 15:03:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794063824;
	bh=n2ssaBCVqMDy+OHs+X/koEcu44YGZSgaGV+bbUozERQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=AWtYfMptjvqxHBcRI7BYSiZAa4dbrU8q/6vNSXJkjlID9S/f/OJslK63bGCxUizPU
	 IDB3lyx3QqO/GvRQ0R0Y7ahyu4bOrJwJuYn+V7/4L9hHSsjeJRYJr5sSZgNDuU7ZDh
	 Gsfi6uplSvebvSJKX7IO8DHnLRHXdRD+xdSFj3+0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daehyeon Ko <4ncienth@gmail.com>,
	"Christian Brauner (Amutable)" <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0039/1257] ipc/mqueue: release notification resources during inode eviction
Date: Sat,  7 Nov 2026 08:38:55 -0500
Message-ID: <20261107134940.487451969@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134939.434104957@linuxfoundation.org>
References: <20261107134939.434104957@linuxfoundation.org>
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
index d1dd36a651b0d..d1a1965c98118 100644
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



