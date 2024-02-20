Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 25D1214A4D2;
	Tue, 20 Feb 2024 21:26:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708464369; cv=none; b=F0OkPZ2uz2prDYeZ6ky/LKFAND9XzBs4ZayB7d1C1PJ5c8C5QE1BSzKYOZ3KWOlTqoS7v7qOJbJjdb+6y9JKWVAoVBzzYqtmHz9uey1eAS4VTBU/8wElS3VUUmrf0xcOxLKcZyIjAnJXEZCj6IvLZkG+xXdbMcTQaGML/bvXaLs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708464369; c=relaxed/simple;
	bh=DlXAXiJPUneGD92sY5C7JFeIOLnNir2vqGfT5J06Zbw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QUtT7fkkux4+Da9QRNL3hvjIZtQhQ8S6NsmqqRixP2DM0hLUG32LOBtdaGqOO4KoEG0bOcEsfvfgzIzSiIWvoJl3uMTdCVCEoAOEfU2yBXt1nVGHSDoA98/Jz3r2mD8StCyFYdsuIL6SfQG7y6TDm+71OftGuu/qFiAOt6wVI/c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eXRVpXWs; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eXRVpXWs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A17FCC43390;
	Tue, 20 Feb 2024 21:26:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708464369;
	bh=DlXAXiJPUneGD92sY5C7JFeIOLnNir2vqGfT5J06Zbw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=eXRVpXWsB3mkOqwGvdoQZJxmEQqOSl3Y3rFCwTHA00qRJDk9nySFITXueO4Kj2g91
	 p3rwAaUPrFDafdzFUCvkLC+cOcP173j/+Gu/jljwkHfVXg4DsSwDPYpSSysj4MZxiY
	 pQggs7tnfFe2ETfUpVpMEt8lWFeMqr+2udZPx2bA=
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
Subject: [PATCH 6.6 308/331] eventfs: Remove unused d_parent pointer field
Date: Tue, 20 Feb 2024 21:57:04 +0100
Message-ID: <20240220205647.847705994@linuxfoundation.org>
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


