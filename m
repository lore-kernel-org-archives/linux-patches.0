Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795618928;
	b=Ihw7m78IT457yzPw0hxdxWu1qcGuQNTpyKO1zmWu9HOYHnYze5UoNJQVtyjmrqBbHRDO
	 +bNxTofUAKCYWt4Nm5i0d+EfUC8Y2W4te6PnJ4rw5pYSSS/IC4MQpT7TRoZnRvw9En1px
	 ygc3ILNHWsX5J6kDipu3vhKSBz+uWa6+UvdxAf2qv9wjj35YVQA+ARw9qR4Js2hTRlkZV
	 FU9aUQ2CF2oUneTqu4xkRpVu5fcecVGUKjF/i6d/DM6zR52bS3qo9r0TPTtnmUNqiHjZz
	 0kHakaRhSk006ptq5ZOBsqYiJMWr5XrBjXb7jbXzY6RxJeGAc/R+9mXZzw/HegPA9TQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795618928;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=kKT5BvqgEkX1DlwXb2O8ksTDDahqxXKo9nXJ4Z2k82I=;
	b=wW3dY0IUDqYvw4qif1y7+M1Wnjs5D50ymKyIT8LtQF/lNS5JvlWuUidR1yeQovHmmb6B
	 41OPWDLKZCFz9O63MCKFWwRtrrHhQYWVTGn/WjElrQwKMoz5BD2M5YNw89wod16xmBBSg
	 W44hWXwGl7rxmywQQQgTFYK9kGZGe8HlySAG9NsMUU8iOxmJTWjhEYyf7SzrjKwXFVmig
	 Y39WFZ1SzCw3ApKJNbuSpfiCNgXVQOm2XFK12qfSsvDvbqy3PdiYVzNQYdDR/qZ3O8y/+
	 DOMAfTqmBlJDnA7vL2zhxMFRPJbsM7deHqdL+HulkSjqTFY73lH+BV7aA0blE7FszkQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=fyv5XcY3;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 30B64606A329;
	Wed, 25 Nov 2026 15:02:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=fyv5XcY3
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7AAA61F000D1;
	Wed, 25 Nov 2026 15:02:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795618928;
	bh=kKT5BvqgEkX1DlwXb2O8ksTDDahqxXKo9nXJ4Z2k82I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=fyv5XcY36Bh+3VnhxkfZmuy+u2s3Fnz0ePegNsAh6CHHh/SHuoeiwp9Oqm6xlUgkE
	 ZCZXhZoDDoGBzRRpucCyDXT61CliPmHofZn3QXOijsITSwYq1i+QHY/kL1UcD3oqhr
	 ACjJo6LXkYsnTxF/n8z82NerAWeXVvyyLvr/PWFg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Avi Weiss <thnkslprpt@gmail.com>,
	Anna Schumaker <anna.schumaker@hammerspace.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0433/1005] sunrpc: instantiate rpc_pipefs dentry before publishing it
Date: Wed, 25 Nov 2026 15:29:31 +0100
Message-ID: <20261125143831.894588751@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143821.729802100@linuxfoundation.org>
References: <20261125143821.729802100@linuxfoundation.org>
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

From: Avi Weiss <thnkslprpt@gmail.com>

[ Upstream commit 0cd6e563938a5b2f88ce0008eda32f9617c9d81f ]

rpc_mkpipe_dentry() publishes pipe->dentry before
d_make_persistent() attaches its inode. A concurrent
rpc_queue_upcall() or rpc_timeout_upcall_queue() can
conceivably dereference the dentry while d_inode() is NULL.

Attach the inode before publishing the dentry, restoring the
ordering used before the rpc_pipefs conversion refactor.

Fixes: 946e2256775e ("convert rpc_pipefs")
Signed-off-by: Avi Weiss <thnkslprpt@gmail.com>
Signed-off-by: Anna Schumaker <anna.schumaker@hammerspace.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/sunrpc/rpc_pipe.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/sunrpc/rpc_pipe.c b/net/sunrpc/rpc_pipe.c
index 68b4e040a77d9..f14cae2952804 100644
--- a/net/sunrpc/rpc_pipe.c
+++ b/net/sunrpc/rpc_pipe.c
@@ -666,8 +666,8 @@ int rpc_mkpipe_dentry(struct dentry *parent, const char *name,
 	rpci->private = private;
 	rpci->pipe = pipe;
 	rpc_inode_setowner(inode, private);
-	pipe->dentry = dentry; // borrowed
 	d_make_persistent(dentry, inode);
+	pipe->dentry = dentry; // borrowed
 	fsnotify_create(dir, dentry);
 	simple_done_creating(dentry);
 	return 0;
-- 
2.53.0



