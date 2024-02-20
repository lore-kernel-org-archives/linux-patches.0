Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 24B50446C9;
	Tue, 20 Feb 2024 21:37:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708465060; cv=none; b=cTItrkVaGD3L/OW5wrpd7TEu0IkeFjJ+C8G8RYNE93fA6Qzc2wWiBCnMaRp6K1jwpk90Gm1feaMb0CQBZ4sOogcnnVzq7rkVs55nRMBcrdtbQA+RRzdtrXxiK1MvJBpPnRHsGdRh7n3uoZFGzVA4JjeAlzGvRPNWrSvmBgZ5DRI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708465060; c=relaxed/simple;
	bh=wQ6hApG7mGsgMm1Q2CBXd3lVkKireL4sxt7KuCxREWQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=M5nnJLaQChVlwrbsZswPUF05pCk9kzZIl9LGt6HDvXFHhwQc6CZnAAZ4qJN4DKitQUJrV9d4o4/8krr23HH5Coh5KeNagpkvmmDFT5VRCDUsNB/tLqvWIp7WNL0Klsvju54lAq3CNGad68VrCzRPuupQe4kcfSPJXDAXzgvkF8g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=f0suJJ3V; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="f0suJJ3V"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 887AAC433F1;
	Tue, 20 Feb 2024 21:37:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708465060;
	bh=wQ6hApG7mGsgMm1Q2CBXd3lVkKireL4sxt7KuCxREWQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=f0suJJ3VemtKgX9CyRAGs/F3E1VnofAIAJ9wBA/02O00YnhkdKKd6jfQbBcUaMXfx
	 cCwUq6My2Clq2McZLgzYXDfueMNRKq/KFf8OTe/xgfR8f59hM208aGI833NMRUhgXv
	 TmYadi9QjUfIwRkiS0i2RP0wio+Wtby7zfL+qg6U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	Christian Brauner <brauner@kernel.org>,
	Al Viro <viro@ZenIV.linux.org.uk>,
	Ajay Kaher <ajay.kaher@broadcom.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	"Steven Rostedt (Google)" <rostedt@goodmis.org>
Subject: [PATCH 6.7 193/309] eventfs: Remove unused d_parent pointer field
Date: Tue, 20 Feb 2024 21:55:52 +0100
Message-ID: <20240220205639.204087859@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240220205633.096363225@linuxfoundation.org>
References: <20240220205633.096363225@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Linus Torvalds <torvalds@linux-foundation.org>

commit 408600be78cdb8c650a97ecc7ff411cb216811b5 upstream.

It's never used

Link: https://lore.kernel.org/linux-trace-kernel/202401291043.e62e89dc-oliver.sang@intel.com/
Link: https://lore.kernel.org/linux-trace-kernel/20240131185512.961772428@goodmis.org

Cc: stable@vger.kernel.org
Cc: Masami Hiramatsu <mhiramat@kernel.org>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Christian Brauner <brauner@kernel.org>
Cc: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Ajay Kaher <ajay.kaher@broadcom.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Fixes: c1504e510238 ("eventfs: Implement eventfs dir creation functions")
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/tracefs/event_inode.c |    4 +---
 fs/tracefs/internal.h    |    2 --
 2 files changed, 1 insertion(+), 5 deletions(-)

--- a/fs/tracefs/event_inode.c
+++ b/fs/tracefs/event_inode.c
@@ -680,10 +680,8 @@ struct eventfs_inode *eventfs_create_dir
 	INIT_LIST_HEAD(&ei->list);
 
 	mutex_lock(&eventfs_mutex);
-	if (!parent->is_freed) {
+	if (!parent->is_freed)
 		list_add_tail(&ei->list, &parent->children);
-		ei->d_parent = parent->dentry;
-	}
 	mutex_unlock(&eventfs_mutex);
 
 	/* Was the parent freed? */
--- a/fs/tracefs/internal.h
+++ b/fs/tracefs/internal.h
@@ -36,7 +36,6 @@ struct eventfs_attr {
  * @name:	the name of the directory to create
  * @children:	link list into the child eventfs_inode
  * @dentry:     the dentry of the directory
- * @d_parent:   pointer to the parent's dentry
  * @d_children: The array of dentries to represent the files when created
  * @entry_attrs: Saved mode and ownership of the @d_children
  * @attr:	Saved mode and ownership of eventfs_inode itself
@@ -51,7 +50,6 @@ struct eventfs_inode {
 	const char			*name;
 	struct list_head		children;
 	struct dentry			*dentry; /* Check is_freed to access */
-	struct dentry			*d_parent;
 	struct dentry			**d_children;
 	struct eventfs_attr		*entry_attrs;
 	struct eventfs_attr		attr;


