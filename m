Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 57E0514F9DA;
	Tue, 20 Feb 2024 21:24:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708464292; cv=none; b=G5L8u+jZ2dOx8sMzjiwv1t2LkyIyGl4O9md6to9kD3/OdJJ3Jdc/bJTOFly6j+B7TkDeqekliotv02RQ2ZgwNKanN1WJeU2uMh+9Rjm1cNnYgthfps+VsMx+CQEMrmXVezE7iT8mD9JkT2yUIRaQESdjMP5ByIQXUF6lzu/Z5yY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708464292; c=relaxed/simple;
	bh=JrhxLuRwM5/GWRHF5JOp0tf8BllDagVmc+eMX78YSqw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TWSS1++R0Tj5yWVckoDP1IM1AZPD7p8+zzkRpMGGVp8M/YZ0ChIQQpIg134rMLyIwLxglapKSjwNTgRruDWE5Wftqi0ueYymAgL4KLEHuTwNCk4nD9tWquZOyTs+EIgMPae2crU6050Tavw1RR2eQHXOtXlzd8oCMiByz0JLwXI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=U3ZSHD8H; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="U3ZSHD8H"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B7B61C433C7;
	Tue, 20 Feb 2024 21:24:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708464292;
	bh=JrhxLuRwM5/GWRHF5JOp0tf8BllDagVmc+eMX78YSqw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=U3ZSHD8HlHy3JOHDW4eOfT2QM7BcO4KnLGPpWmJ0+JrMSvUGc4kbo7ik94DtuT7qH
	 GXBqOyOqc229pi0GmH5NSs0hsaje5JtD5MzzlcNDsj1OyT8UkxKDAz1ZoD8Jnk+OEr
	 vKSxIIX/+tEkrvoPD+sdlYRHmVR/4UuLcirEDG3Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	Christian Brauner <brauner@kernel.org>,
	Al Viro <viro@ZenIV.linux.org.uk>,
	Ajay Kaher <ajay.kaher@broadcom.com>,
	"Steven Rostedt (Google)" <rostedt@goodmis.org>
Subject: [PATCH 6.6 312/331] eventfs: Restructure eventfs_inode structure to be more condensed
Date: Tue, 20 Feb 2024 21:57:08 +0100
Message-ID: <20240220205647.997228454@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240220205637.572693592@linuxfoundation.org>
References: <20240220205637.572693592@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: "Steven Rostedt (Google)" <rostedt@goodmis.org>

commit 264424dfdd5cbd92bc5b5ddf93944929fc877fac upstream.

Some of the eventfs_inode structure has holes in it. Rework the structure
to be a bit more condensed, and also remove the no longer used llist
field.

Link: https://lore.kernel.org/linux-trace-kernel/20240201161617.002321438@goodmis.org

Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Masami Hiramatsu <mhiramat@kernel.org>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Christian Brauner <brauner@kernel.org>
Cc: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Ajay Kaher <ajay.kaher@broadcom.com>
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/tracefs/internal.h |   27 ++++++++++++---------------
 1 file changed, 12 insertions(+), 15 deletions(-)

--- a/fs/tracefs/internal.h
+++ b/fs/tracefs/internal.h
@@ -32,40 +32,37 @@ struct eventfs_attr {
 /*
  * struct eventfs_inode - hold the properties of the eventfs directories.
  * @list:	link list into the parent directory
+ * @rcu:	Union with @list for freeing
+ * @children:	link list into the child eventfs_inode
  * @entries:	the array of entries representing the files in the directory
  * @name:	the name of the directory to create
- * @children:	link list into the child eventfs_inode
  * @events_dir: the dentry of the events directory
  * @entry_attrs: Saved mode and ownership of the @d_children
- * @attr:	Saved mode and ownership of eventfs_inode itself
  * @data:	The private data to pass to the callbacks
+ * @attr:	Saved mode and ownership of eventfs_inode itself
  * @is_freed:	Flag set if the eventfs is on its way to be freed
  *                Note if is_freed is set, then dentry is corrupted.
+ * @is_events:	Flag set for only the top level "events" directory
  * @nr_entries: The number of items in @entries
+ * @ino:	The saved inode number
  */
 struct eventfs_inode {
-	struct kref			kref;
-	struct list_head		list;
+	union {
+		struct list_head	list;
+		struct rcu_head		rcu;
+	};
+	struct list_head		children;
 	const struct eventfs_entry	*entries;
 	const char			*name;
-	struct list_head		children;
 	struct dentry			*events_dir;
 	struct eventfs_attr		*entry_attrs;
-	struct eventfs_attr		attr;
 	void				*data;
+	struct eventfs_attr		attr;
+	struct kref			kref;
 	unsigned int			is_freed:1;
 	unsigned int			is_events:1;
 	unsigned int			nr_entries:30;
 	unsigned int			ino;
-	/*
-	 * Union - used for deletion
-	 * @llist:	for calling dput() if needed after RCU
-	 * @rcu:	eventfs_inode to delete in RCU
-	 */
-	union {
-		struct llist_node	llist;
-		struct rcu_head		rcu;
-	};
 };
 
 static inline struct tracefs_inode *get_tracefs(const struct inode *inode)


