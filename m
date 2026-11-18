Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795044868;
	b=hy921JpGmyuGZEiZ7scPmmPNe/4Qudlru05xlfXbKCa6p3hqnhIcSAUv9NMusWCSx2/X
	 e2XXhdVoeOUY2VecdFlwx0tBz2bSZ9U+mT27VnHilUKOJYdvCrnVn1/Utfz4A5i7/ki83
	 xplTRpP9WDCVw8sJeX7epHD4pmjK6lug+E8WyIPJidIBGLWL/UDKaRnjh5egXGNRhvbJ7
	 GdqffENu2b+wVefRgLM42Eeh7TRmabt6KcaZZ+plZamP+TTd0yTlR7zkXBlUHtvLBnBFJ
	 G5Afv+1H+xhLv0bX/Qd8PvOjn+pyYdnUXsqvXQCxVWlIY+BuAmts6qkpTsKspKopewA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795044868;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=/mgaVHokyRslNWglrXC662pbrWOn5VjGWUQQb1G1XOY=;
	b=S9z7tT8BG4lVFPPAHKSZLc1yor5MSfy6KelLGMXIHrHJTrG5P7aDoXwxJRmybEn1xJ3V
	 v/B786iJn1x1EHycASitwWfsYr0H+1pkK0k37kRNfaYTLhcdmO5L1iKXN/vlWhN+Py998
	 aCjLLrziSxrOxxCxqrGtpUfMrpHKOalki9nb5K5LUA0wPZL9kzsvL7RG67208fIsx6+4b
	 u+WwRDGLCZUMi28XuSm49N8972BDGHz5OYza7KYFbYa6EvDFFGW21nDx52pxzUc3Rms1f
	 y3fOlfFajYyHp+j5JT5RVP0Q6Ki86dLPevymbyE1hcoN6398wDtYaNEHsvYQM2dEBxg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="ON/mz4VP";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A3D3606A9D5;
	Wed, 18 Nov 2026 23:34:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ON/mz4VP
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 94D131F000C4;
	Wed, 18 Nov 2026 23:34:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795044868;
	bh=/mgaVHokyRslNWglrXC662pbrWOn5VjGWUQQb1G1XOY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ON/mz4VP8hnuBa7PKs6P2qsmO+rNudL08V774XZ4UlTO8Oa634Zvt6XphetGdNhfv
	 8i/aSt9C6H++eJj5ztM2Xg7EB6MelrPd4T1ZJjkJZdxaK4qOMIHcvt20Mj8OTAgMTu
	 MZMZ4I2nlu+rj5m2NNOFmPikAbOHEqbXghkQktpY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daehyeon Ko <4ncienth@gmail.com>,
	"Christian Brauner (Amutable)" <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0718/2857] ipc/mqueue: release notification resources during inode eviction
Date: Wed, 18 Nov 2026 15:29:12 +0100
Message-ID: <20261118150227.399060612@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index d09aa1c1e3e65..d18e024153434 100644
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



