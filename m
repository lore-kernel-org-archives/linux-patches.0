Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795621957;
	b=JvSYJqrMkO7ivAeonACyOgFBs+6pNk1UDgQ1EZu2wM1omWF51rexnR5QI4v9HSXe6xQ0
	 SlLWA+ejRnFjafa5ZVczFPpau3NjINp1ve2EnaYq5uD6OD41Wo0VZrWV5QtunVI32zn9k
	 mNV37W4FYW52kb71K91ZHG2v4WivbwPQZvigzeECpidbaSUiriiSvCUy6DHFW2OscjyY6
	 rRdwzZdT0zxoc6Hkhe5uYAQt5ZMe9OYDtp+kZrErM5e9IMasCbsoKmKfEx3f34y61s5jU
	 pwoirGivrEWT+6u7BPefgu1ftxBaCYspmRl9/IDZAuA4rMCuMCZI0kVkkAXinKl92cw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795621957;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=wKZhanop6xCL5OYkOzLterXNf/hfLcBfxSvJkrwWTaU=;
	b=sUIOKn6JH8h1XSwtYHK9OdQsWAKMv9d/zssiEUOR9cAa7vVAECCFU795H+MN+SOoFse0
	 GRKodbDqpZpDoFvLSnc54O2AUr4Ddki3Cyh+F2JF2DL88AyxDJjf4RczV9RNmxFUgrwrr
	 oNNPQfp1qhkg0SJM+XcxYw6yMPBFAe7NmQVDGTrMNlLQm/XMV+JFG9upwDN8RDTVltk3T
	 sm+Wk43TBBYztRuCNzjWNN4UGfVX0IOxKxWJ0R3bJZDpIEVcspEsnoDt0k+2Fw2zbVotr
	 ycKE4frBQUjO8/XR7XHiuYrw8PWqz6+4upJ5FjIXp/VhDpgh3XqUCFezDLrFFwXLbQg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=tlY0zECn;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9090F606A329;
	Wed, 25 Nov 2026 15:52:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=tlY0zECn
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9769D1F000C0;
	Wed, 25 Nov 2026 15:52:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795621957;
	bh=wKZhanop6xCL5OYkOzLterXNf/hfLcBfxSvJkrwWTaU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=tlY0zECnc0pt08Ij5JZuzYAu5rDUycCvvePnzcIqlGWd1NMjDlMfj9mHNjOMfX68f
	 EFPIW1JG8s9AjzIaVCqRpJGujNXF847pK0qKCR/i2tFo8lVrFlK+NWVf8vG0MLpJNo
	 sOxYK3sLILwgKnwenykrsT8Ar0a7WK3eoFk8M7io=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Avi Weiss <thnkslprpt@gmail.com>,
	Jeff Layton <jlayton@kernel.org>,
	NeilBrown <neil@brown.name>,
	Anna Schumaker <anna.schumaker@hammerspace.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 384/990] SUNRPC: wake poll waiters when an empty pipe is unlinked
Date: Wed, 25 Nov 2026 15:29:11 +0100
Message-ID: <20261125143831.087011766@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143822.072087159@linuxfoundation.org>
References: <20261125143822.072087159@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Avi Weiss <thnkslprpt@gmail.com>

[ Upstream commit 702d55edc017632a0c39c1d4bdd579bdbadfd730 ]

When an empty rpc_pipefs pipe is unlinked, rpc_purge_list() returns
without waking the pipe wait queue. An existing epoll waiter can
remain blocked even though rpc_pipe_poll() reports EPOLLHUP and
EPOLLERR for the disconnected pipe.

Wake the wait queue after clearing RPC_I(inode)->pipe so existing
poll waiters are notified regardless of whether messages were purged.

Fixes: 9842ef3557ab ("SUNRPC: rpc_timeout_upcall_queue should not sleep")
Signed-off-by: Avi Weiss <thnkslprpt@gmail.com>
Reviewed-by: Jeff Layton <jlayton@kernel.org>
Reviewed-by: NeilBrown <neil@brown.name>
Signed-off-by: Anna Schumaker <anna.schumaker@hammerspace.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/sunrpc/rpc_pipe.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/sunrpc/rpc_pipe.c b/net/sunrpc/rpc_pipe.c
index 0bd1df2ebb479..3a71426e8b76a 100644
--- a/net/sunrpc/rpc_pipe.c
+++ b/net/sunrpc/rpc_pipe.c
@@ -191,6 +191,7 @@ rpc_close_pipes(struct dentry *dentry)
 	cancel_delayed_work_sync(&pipe->queue_timeout);
 	rpc_inode_setowner(inode, NULL);
 	RPC_I(inode)->pipe = NULL;
+	wake_up(&RPC_I(inode)->waitq);
 	inode_unlock(inode);
 }
 
-- 
2.53.0



