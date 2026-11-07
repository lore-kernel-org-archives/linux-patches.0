Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794063873;
	b=qp9++Csztyq/xrDXaOj6GSLK9UwbkN4ziyHFw83D1o3AZYldjAsihSxGLi2kv8Vj8ouS
	 +5CgybYtzDOZmT1b4fY/xYF45BcNqojCSInAkOuod0kBC9EgeOoyrYBRmuKVC0mbY9QVc
	 nY9NXKXm9T/9DRUEUqMYcXL4iK2hiJuGEDTlC25TsaGVSHTfiQaFV5wQseN9eEP58b4fM
	 Uv45IbElsvI256EME9SlzRkoB3kfgAnkzUAp41uGDYYdeLXAIWosg4y48XASqLTUKFFk9
	 vREKyx64L8I+dEWYChsYp9/kiXhySo+bg+UQsmO9XwK824Kcv27b9Xuh/t+XzYALc4A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794063873;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=wfFxgPYpj8pl7wmhwractfFUTkhcoanPwpLWLweTg4w=;
	b=hiXSOf2VauvLUK9F1cW5NQoDTXeHPjmA17RbIp+CUYKjBzgptLK0uaz+bBJDVF1RZRoS
	 IH2xivFf7uH1XV99EJe4QqiS+4SheO0XcZS5VxQTH9JG2/oxPxOP7nIMiSfIiitHRtDUE
	 tu80DR+WFh8A01q/kby7kRatXelYv0gRI2dsbLY3rfngNvWd96eDuXTD6MV6OBJlL7DYq
	 IYuujDU4qSOubRw/cxlZ7b7mBcZ7iLk6Xn1fpRPEx9pPtoI6RlPUsGDl/Xa9Ubpp7qCgn
	 HYbdJzxL+tmrdkc4gKMkE7F5yK28w5cPuOUaLJ4OPcep7nWV8R6EgjBApKUR5GBsjEQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=e6JzjPsp;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 485D8606B892;
	Sat,  7 Nov 2026 15:04:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=e6JzjPsp
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E735C1F0089F;
	Sat,  7 Nov 2026 15:04:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794063873;
	bh=wfFxgPYpj8pl7wmhwractfFUTkhcoanPwpLWLweTg4w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=e6JzjPsp0wzTybq+qh5Nter7aXFIcJK9lyWteVWgYxqZ84h/xCW70dngnsNzDViFJ
	 1BKIATNvFEOPrOZ6k/VWKkJZY+D4oBfG03EUUjVQ95+jHGw/lTHYjoiUP0Ea8ihDhA
	 yZCIo6+rwT63BvWi/bbwnwb2FU+KBNubzvI9LS5k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Amir Goldstein <amir73il@gmail.com>,
	Jan Kara <jack@suse.cz>,
	"Christian Brauner (Amutable)" <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	Daehyeon Ko <4ncienth@gmail.com>
Subject: [PATCH 7.3 0077/1257] fs: make sure to call fsnotify_inoderemove() only once when inode is dead
Date: Sat,  7 Nov 2026 08:39:33 -0500
Message-ID: <20261107134941.508022063@linuxfoundation.org>
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

From: Amir Goldstein <amir73il@gmail.com>

[ Upstream commit 669bb5af15d41a21359d00a441490f87a88eb52a ]

Daehyeon reported a race wherein fsnotify_removeinode() can be called
when inode still has a live alias.  This can lead to several undesired
outcomes such as crashes in fsnotify code or avoidance of inode mark
notifications.

Check that inode is really "dead", meaning no nlink and no more aliases
before calling fsnotify_inoderemove() for final cleanup of inode marks.
Also do not allow open_by_handle() to add new aliases to a "dead" inode.

Ideally, we'd call fsnotify_inoderemove() once last inode reference is
dropped to make things simpler. Alas fsnotify inode marks currently hold
inode references and thus this doesn't work. Once we teach fsnotify to
avoid holding inode references, these games with dead inodes can go as
well.

Reported-and-tested-by: Daehyeon Ko <4ncienth@gmail.com>
Closes: https://lore.kernel.org/linux-fsdevel/20260827045007.3831259-1-4ncienth@gmail.com/
CC: stable@vger.kernel.org
Signed-off-by: Amir Goldstein <amir73il@gmail.com>
Signed-off-by: Jan Kara <jack@suse.cz>
Link: https://patch.msgid.link/20260902164924.1333135-2-jack@suse.cz
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/dcache.c | 27 ++++++++++++++++++++++++---
 1 file changed, 24 insertions(+), 3 deletions(-)

diff --git a/fs/dcache.c b/fs/dcache.c
index f44c7b39c3b38..2eb23222be549 100644
--- a/fs/dcache.c
+++ b/fs/dcache.c
@@ -450,6 +450,17 @@ static void dentry_free(struct dentry *dentry)
 		call_rcu(&dentry->d_rcu, __d_free);
 }
 
+/*
+ * If inode is unlinked and doesn't have any aliases (i.e., all fds pointing to
+ * it are closed), it is pretty much dead. Except that file handle lookup could
+ * still revive it which causes issues to fsnotify. So once inode reaches this
+ * state we make sure to block creating any new aliases.
+ */
+static bool inode_notify_dead(struct inode *inode)
+{
+	return !inode->i_nlink && hlist_empty(&inode->i_dentry);
+}
+
 /*
  * Release the dentry's inode, using the filesystem
  * d_iput() operation if defined.
@@ -459,6 +470,7 @@ static void dentry_unlink_inode(struct dentry * dentry)
 	__releases(dentry->d_inode->i_lock)
 {
 	struct inode *inode = dentry->d_inode;
+	bool notify_dead;
 
 	raw_write_seqcount_begin(&dentry->d_seq);
 	__d_clear_type_and_inode(dentry);
@@ -469,9 +481,10 @@ static void dentry_unlink_inode(struct dentry * dentry)
 	 */
 	dentry->waiters = NULL;
 	raw_write_seqcount_end(&dentry->d_seq);
+	notify_dead = inode_notify_dead(inode);
 	spin_unlock(&dentry->d_lock);
 	spin_unlock(&inode->i_lock);
-	if (!inode->i_nlink)
+	if (notify_dead)
 		fsnotify_inoderemove(inode);
 	if (dentry->d_op && dentry->d_op->d_iput)
 		dentry->d_op->d_iput(dentry, inode);
@@ -2243,7 +2256,12 @@ static struct dentry *__d_obtain_alias(struct inode *inode, bool disconnected)
 
 	sb = inode->i_sb;
 
-	res = d_find_any_alias(inode); /* existing alias? */
+	spin_lock(&inode->i_lock);
+	if (!inode_notify_dead(inode))
+		res = __d_find_any_alias(inode);	/* existing alias? */
+	else
+		res = ERR_PTR(-ESTALE);
+	spin_unlock(&inode->i_lock);
 	if (res)
 		goto out;
 
@@ -2255,7 +2273,10 @@ static struct dentry *__d_obtain_alias(struct inode *inode, bool disconnected)
 
 	security_d_instantiate(new, inode);
 	spin_lock(&inode->i_lock);
-	res = __d_find_any_alias(inode); /* recheck under lock */
+	if (!inode_notify_dead(inode))
+		res = __d_find_any_alias(inode);	/* recheck under lock */
+	else
+		res = ERR_PTR(-ESTALE);
 	if (likely(!res)) { /* still no alias, attach a disconnected dentry */
 		unsigned add_flags = d_flags_for_inode(inode);
 
-- 
2.53.0



