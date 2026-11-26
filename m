Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795705252;
	b=x1GbNyxbnc4PdRlEvk/7uKjy0hHLYpzrIq+AnguPqrGdacdeIynO8EjVDwW0L8WPGJib
	 7Tjbl4bq8CExurwoqmPilYm3LRebif077qKoiLMcw/5C446Gv90IhOfF1xRxKmU/XNGhy
	 mw1XcV5DxQtxjVf7sGce1pHgvCtYLqNFNlico4HBU+/Uvb6RT+cCD8b1LqQTMJa90ZwpQ
	 cs1zRblg6njU31Aios+ed2pfRL57/ZFUW6riXyNSvRhA7bQBe1D4VBGJkhBZGTzNtr8iG
	 vvpkiGkM/DSDFpZ8sVeEZM2iL+73Te4wLx1sQpuE7yW3Zdd4mCOHNaz58WLZaLof4NA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795705252;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=kiwIbtDNxZM2fVlfLnwCYO/97OJvUdqCQS9qg7SQNFw=;
	b=nqX28/qi4CqVOltq3U8nVyyYsE/vl+d/kk4PlIyqrvqZLznxsndU0c+CWyYcLsES9eK+
	 a+m4yvWLwpXQFx+JuqX59MwD2pAOCKsQJBXHT5nliWJaVzC+OX4BbzT9/SXuPd+OUIi9r
	 jFzotDL1NzYfSwyRC6o+81PdI7LgqXWmrPHaBWrDfGbVE0CmvZT8oIUh8pfmdxoXuqxxH
	 PBKebTPHIYG5ICknoYPq/qv1SmWSlAtH15gAc59UkX2fDsW4XPkn4siyz9ChGXMg7JxPC
	 Z10MhXpHPjaj/P00DnT8PsQciLoKyhdGWmgJXjMlTtyrfSfeSm6GIQJebFT0IbcMSXg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=tl6sV8Lu;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B8E93606A33B;
	Thu, 26 Nov 2026 15:00:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=tl6sV8Lu
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C17291F000D0;
	Thu, 26 Nov 2026 15:00:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795705252;
	bh=kiwIbtDNxZM2fVlfLnwCYO/97OJvUdqCQS9qg7SQNFw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=tl6sV8Lunia7v53pBl+SfrzXlVrstGZxTHQQSWKF3TSIOJtV/29IuL5C4ru1y5kXb
	 1wGmWkeK+lZEUF5xgRjIX6tUze7tDKb8UwzUX0TY5qrmXIzUyu77rEKOLhkd0dCVTl
	 PHp8sdkvD3bMDV7WD8D7dQyjInffyOkdGQGUjYfk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Avi Weiss <thnkslprpt@gmail.com>,
	Jeff Layton <jlayton@kernel.org>,
	NeilBrown <neil@brown.name>,
	Anna Schumaker <anna.schumaker@hammerspace.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 137/319] SUNRPC: wake poll waiters when an empty pipe is unlinked
Date: Thu, 26 Nov 2026 15:38:25 +0100
Message-ID: <20261126144009.838174731@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261126144006.732901931@linuxfoundation.org>
References: <20261126144006.732901931@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 35588f0afa864..248fa843efc8d 100644
--- a/net/sunrpc/rpc_pipe.c
+++ b/net/sunrpc/rpc_pipe.c
@@ -190,6 +190,7 @@ rpc_close_pipes(struct inode *inode)
 	cancel_delayed_work_sync(&pipe->queue_timeout);
 	rpc_inode_setowner(inode, NULL);
 	RPC_I(inode)->pipe = NULL;
+	wake_up(&RPC_I(inode)->waitq);
 	inode_unlock(inode);
 }
 
-- 
2.53.0



