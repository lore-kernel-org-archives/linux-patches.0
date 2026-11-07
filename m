Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794061956;
	b=gJALSiFzPG90jqQ0tCl7hqqyi1doK5dOGmce/2JjQSym5JVAlcGA71myBm+GXL9z8okn
	 7HQ5bb69aNq4Jft4RgS8G7IOlgvMZLpSEG09CS1FD+8GxyLseY1xRVYnbwaTmN2rvLwPh
	 2LOijTzd7Snm+lNIYQTDvH2J27kwW/7nhan0Y7g16nYw5Gbwd6aRkt5xdWJuVr7BZ/OeR
	 rsVeI/FAPrLiIww7Itj9hJq2Hy9yYPyy24BFKPhCGYQhsC/UD7EXUmrWMqX20I7VlMEMl
	 QbdN+pQ/soXT0TsAGdENvzw4f+nZbbmU0dpVeb8EmspwP/BBuG8sEJCDRzTSmWiJ2QQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794061956;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=AfAcIIbi676QvgyDmXaZiuUrJ8XSnPb2VsTFGkCp38Q=;
	b=KuYoVVz+NbGWj5zHBkgb7wARIVu1x8mVA2AKTHv1qMLqlKVVqZh7YdczbbL281V63/f1
	 SZHM3lCpeFC8jFezr8ZfkdKIkRnMM2qjtRsR8+96ZSYOxkR53vuhjC2+n9WUkypLKBOG0
	 YNRj1tvekhVD5BX42/kNLU/tLldRlP9/C96hLg2bh21sFC84lrPvfeKbPy0TOPJzP5Q2Y
	 PimTA+VvqLBMLjURs5PoqwTkQcn5RdzhdAwPTjyj8mkWBNRLx1q+kULpa6iDcC0CWmBsp
	 PHX59U7w9Zzf+fjY/mpbyYYCrurqhy9yzqYzcLrVDj6Y7BJxGI0cWyFDtcWtMwFREyA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=tdZe1pKN;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 89379606A32E;
	Sat,  7 Nov 2026 14:32:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=tdZe1pKN
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 36BE61F0089F;
	Sat,  7 Nov 2026 14:32:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794061956;
	bh=AfAcIIbi676QvgyDmXaZiuUrJ8XSnPb2VsTFGkCp38Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=tdZe1pKN6h4FkUGb492Cbjn8yoZ6oNkCnSFyFzUZ2DubL8BOv7hfEVbmWevZQRKYR
	 4LlcIuMK3SuqAC5K38/mYL93AZrEwGD2zVVU/8nubI9qX86rF8ae7gmIDwuNFVRX6z
	 2Vkr7CBrk9AZkUqfB4hTWy9tVu/Zu0WJbH6ZlCT4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daehyeon Ko <4ncienth@gmail.com>,
	"Christian Brauner (Amutable)" <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0905/1536] ipc/mqueue: release notification resources during inode eviction
Date: Sat,  7 Nov 2026 08:48:41 -0500
Message-ID: <20261107135023.054358717@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134957.653319350@linuxfoundation.org>
References: <20261107134957.653319350@linuxfoundation.org>
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
index 34fa0bd8bb11a..f2eb331b36511 100644
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



