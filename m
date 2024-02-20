Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 702D91509BC;
	Tue, 20 Feb 2024 21:24:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708464254; cv=none; b=aRVkK7YrewGk2Ginsrhm/fuDidrZqB6gXN1k26E5xsAcYuq5Xs46l5SAgvjYuQxA2VFlbP2r6+UDAZTJHnLhOJtFD78vyeWNF+47kDfSSVIPc17ZVGZPPqQBsi/j7+zZv0TaBHdFwoN631MElkqwYpUTjS/hiFuUDuxTZnimegQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708464254; c=relaxed/simple;
	bh=Ue2tAtCP0lFyNJ9SRg7GabHqZEoJ5FYqBmq2hEc5pZY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=u6dYeGHP/NRd/p0jA9h2mMUnof1/pG+R6VIOudTYMcIUqXhmSx6n+EqnRKc1KXJ7jk7l1EaQZBm0fU0ux8YEllnxPcrAEFo0bkaQhPK6Au7NwyTd0Ce2Vrkb39wpf5frdHO6ugJpdMZ++2iQ+xvliZ2OK9EMZrOylgwHVPnqJhs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Q8lyxU+T; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Q8lyxU+T"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D3470C433C7;
	Tue, 20 Feb 2024 21:24:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708464254;
	bh=Ue2tAtCP0lFyNJ9SRg7GabHqZEoJ5FYqBmq2hEc5pZY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Q8lyxU+TztuQyAtevW4GP6kDRLjgosnWCgAA0agNercuCc/LsWSKnlXI9PUdUbFhC
	 vUUF8K7RNxBZE0OsGDpygfiJHhxPBdt+EiAszCdQ93HZDNWxjA88W8h3h/LhaTZM+N
	 E+hV/JkyAkg2S6/ppynnRlYCFx7ObQMir3DTNxGI=
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
Subject: [PATCH 6.6 299/331] eventfs: Have the inodes all for files and directories all be the same
Date: Tue, 20 Feb 2024 21:56:55 +0100
Message-ID: <20240220205647.482281234@linuxfoundation.org>
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

commit 53c41052ba3121761e6f62a813961164532a214f upstream.

The dentries and inodes are created in the readdir for the sole purpose of
getting a consistent inode number. Linus stated that is unnecessary, and
that all inodes can have the same inode number. For a virtual file system
they are pretty meaningless.

Instead use a single unique inode number for all files and one for all
directories.

Link: https://lore.kernel.org/all/20240116133753.2808d45e@gandalf.local.home/
Link: https://lore.kernel.org/linux-trace-kernel/20240116211353.412180363@goodmis.org

Cc: Masami Hiramatsu <mhiramat@kernel.org>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Christian Brauner <brauner@kernel.org>
Cc: Al  Viro <viro@ZenIV.linux.org.uk>
Cc: Ajay Kaher <ajay.kaher@broadcom.com>
Suggested-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/tracefs/event_inode.c |   10 ++++++++++
 1 file changed, 10 insertions(+)

--- a/fs/tracefs/event_inode.c
+++ b/fs/tracefs/event_inode.c
@@ -32,6 +32,10 @@
  */
 static DEFINE_MUTEX(eventfs_mutex);
 
+/* Choose something "unique" ;-) */
+#define EVENTFS_FILE_INODE_INO		0x12c4e37
+#define EVENTFS_DIR_INODE_INO		0x134b2f5
+
 /*
  * The eventfs_inode (ei) itself is protected by SRCU. It is released from
  * its parent's list and will have is_freed set (under eventfs_mutex).
@@ -352,6 +356,9 @@ static struct dentry *create_file(const
 	inode->i_fop = fop;
 	inode->i_private = data;
 
+	/* All files will have the same inode number */
+	inode->i_ino = EVENTFS_FILE_INODE_INO;
+
 	ti = get_tracefs(inode);
 	ti->flags |= TRACEFS_EVENT_INODE;
 	d_instantiate(dentry, inode);
@@ -388,6 +395,9 @@ static struct dentry *create_dir(struct
 	inode->i_op = &eventfs_root_dir_inode_operations;
 	inode->i_fop = &eventfs_file_operations;
 
+	/* All directories will have the same inode number */
+	inode->i_ino = EVENTFS_DIR_INODE_INO;
+
 	ti = get_tracefs(inode);
 	ti->flags |= TRACEFS_EVENT_INODE;
 


