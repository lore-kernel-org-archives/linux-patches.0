Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB68F1862BD;
	Mon, 12 Aug 2024 16:21:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723479689; cv=none; b=nq6AFSkT6M3GL/9+JEBtPBGAm9/OilGk/u67Fv8W9EUtfwox5sTNQG8gIyQh+OQmu9DTHv9FIyjufn7wZbQCjN6xd9pf3bfEx4OWvGoid7R+DjuInL0rFXtZ8QmCVN4w0FJ9DHoT4p+lRBaT1R8HsxODxF+WBYYniUYzTCwKJAw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723479689; c=relaxed/simple;
	bh=yZy4EGs46Pt0QAWE/KzLq+I7p05CnxHe72oIAns7y3w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sm2qb/9SG6AwmVKfIiqb2VfNZ7RKutsa/17Gi3z6q2xvFmmD9qJUR5nJcnrXpElxDOGIReihi3H9iOsfr12MQq5UwK6BIKcKGuXnlIQozPEgMrEZzDNzOC9/81KJn6gX1fqLiTOR9un9wZqUJ+2TlLnZ3RxIC6ackd4pfr3/tFc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Pzi7BiGW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Pzi7BiGW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4B435C4AF0C;
	Mon, 12 Aug 2024 16:21:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723479689;
	bh=yZy4EGs46Pt0QAWE/KzLq+I7p05CnxHe72oIAns7y3w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Pzi7BiGWSObUI4QC7nLbGZpufLPxEQ4egbqNpLbD/K2UzkTen4jOS7fnnKXgBIIHQ
	 ThruX9vlzuB/ZBxDIsBa/SzBBu4CqFbmXyUcb9LOWMZ6zeKGAWPnI7Kr30JwNAAO7C
	 M0GKAa0/52LUAf8Mv0/H1ATSzCBqbIf+qEt/n73w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ajay Kaher <ajay.kaher@broadcom.com>,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	Al Viro <viro@zeniv.linux.org.uk>,
	Mathias Krause <minipli@grsecurity.net>,
	"Steven Rostedt (Google)" <rostedt@goodmis.org>
Subject: [PATCH 6.6 132/189] tracefs: Fix inode allocation
Date: Mon, 12 Aug 2024 18:03:08 +0200
Message-ID: <20240812160137.224881770@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240812160132.135168257@linuxfoundation.org>
References: <20240812160132.135168257@linuxfoundation.org>
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

From: Mathias Krause <minipli@grsecurity.net>

commit 0df2ac59bebfac221463ef57ed3554899b41d75f upstream.

The leading comment above alloc_inode_sb() is pretty explicit about it:

  /*
   * This must be used for allocating filesystems specific inodes to set
   * up the inode reclaim context correctly.
   */

Switch tracefs over to alloc_inode_sb() to make sure inodes are properly
linked.

Cc: Ajay Kaher <ajay.kaher@broadcom.com>
Cc: Masami Hiramatsu <mhiramat@kernel.org>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/20240807115143.45927-2-minipli@grsecurity.net
Fixes: ba37ff75e04b ("eventfs: Implement tracefs_inode_cache")
Signed-off-by: Mathias Krause <minipli@grsecurity.net>
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/tracefs/inode.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/tracefs/inode.c b/fs/tracefs/inode.c
index 1028ab6d9a74..21a7e51fc3c1 100644
--- a/fs/tracefs/inode.c
+++ b/fs/tracefs/inode.c
@@ -42,7 +42,7 @@ static struct inode *tracefs_alloc_inode(struct super_block *sb)
 	struct tracefs_inode *ti;
 	unsigned long flags;
 
-	ti = kmem_cache_alloc(tracefs_inode_cachep, GFP_KERNEL);
+	ti = alloc_inode_sb(sb, tracefs_inode_cachep, GFP_KERNEL);
 	if (!ti)
 		return NULL;
 
-- 
2.46.0



