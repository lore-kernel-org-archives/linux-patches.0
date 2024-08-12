Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA8451494B8;
	Mon, 12 Aug 2024 16:34:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723480470; cv=none; b=hg9oQtnhXAL8byMvEdhLDUcwVLiaaqu23cOb1v8qgq7Sa8JIwf0cPPKbrVBJaMIK0txhStSG3Bdhac/Mt4t1pNO4OwKzHiZ1s1FJw4S5QeysgbUAGhlWXnYwQBXGL4YTaylh4lDm869fwgpXv2J0j9JMykHq2Oga60VF50770oY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723480470; c=relaxed/simple;
	bh=nFfmkbIO3qwvUGoh9Qu0GWI9mkF+d6Bp46uYvNYgHtM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TrgCYvCKzSQfloAqby0/0W+6Ac98P9LHlQhms1AMoRk/2x3gAVVLGO9XanDlXEX4in2M9xfo7XfPgS9F6PwLDOECGBLpCILfUmSv7eOReDAM63Fa0S768m9I506vW99tKNI/Nn4BIf7N1l12Oy3g/PzFdAQidE5mV1DrHDqHBHo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yR7jneLz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yR7jneLz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 48138C32782;
	Mon, 12 Aug 2024 16:34:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723480469;
	bh=nFfmkbIO3qwvUGoh9Qu0GWI9mkF+d6Bp46uYvNYgHtM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yR7jneLzva/7qi2OZLVGoObotlQVduHe3suBLQpTmyWBF6qxy8fvhRChpuHZy8oGH
	 BbcpbEkD+Ry1qqs46ap87eje6Ek18FG8mS6WXiQZwkvkgccehwRKRQrnmFXKNk4CYs
	 XZyBUqcjFCjXenXKcHZBRI4MQw6pjtDR3nwajMIg=
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
Subject: [PATCH 6.10 205/263] tracefs: Fix inode allocation
Date: Mon, 12 Aug 2024 18:03:26 +0200
Message-ID: <20240812160154.396753504@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240812160146.517184156@linuxfoundation.org>
References: <20240812160146.517184156@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

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
 fs/tracefs/inode.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/tracefs/inode.c
+++ b/fs/tracefs/inode.c
@@ -42,7 +42,7 @@ static struct inode *tracefs_alloc_inode
 	struct tracefs_inode *ti;
 	unsigned long flags;
 
-	ti = kmem_cache_alloc(tracefs_inode_cachep, GFP_KERNEL);
+	ti = alloc_inode_sb(sb, tracefs_inode_cachep, GFP_KERNEL);
 	if (!ti)
 		return NULL;
 


