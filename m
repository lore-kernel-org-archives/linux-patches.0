Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795618925;
	b=JmaOUD/RqQG0j8giTQ8Lg9Tky9Zw5VhJ8yopocU4F7PHYTfnCeqNYi/OQJknbu3jsDBJ
	 3JATdcrTG8ptdFBTsX6DrT2Pdxor6o5yMURo/QDI/bKHCgyzgDAjs0Sqq6BGoIadwweLU
	 OMicop1mf9mdeFqGgdQqO989Evpt8q2R86+J9R5Z0GtK0UfSwdx2Xy1G0QcGOt0bED8uv
	 bqosdBtuANFgtB4hUrAiO3dZ4QGfhZ7Kw5IKvU34wi5W3Cl9xgmUjQy4XgU9PND0GGSBs
	 wDnDuJ3OLn4XBYjyn7F3TWAtA1m1I74RooFw56v69t4PEC7o/3NqfgWGRAH3heFgMgw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795618925;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=aXVxcRuFQPqL+fKIheq+ASECyNg4vPKK4lyT2elu82Y=;
	b=d1mg6oLkxYB+povVnvngHz1w1IhykqbUH797+szQeagKai+edpRW7y+ap07gCutme2/O
	 soI+vCNjaFHIuYqvRnj5wADa9XIqT8x+0Y83Xl7tgMC8ZODK8P3LMX0EKKtRvhkqV58ds
	 Fo323u21ElEFBty4U7K8IHcUdF7ibaEEi61bwTwywCcWbARuR0FzttaPMtuJ8hvtJPTTX
	 Zkh4Rvq+Xpx2ph73TmDcLtKp4Z957h1/jNQC87SZdOlKix66US7LCpKVOQeRiVtwtZ17b
	 k4irvHlMJgGHN54pLXO/WpiCpRtl+vsop39tm5B7Y6Nd0wJfwr8tTB67Q11gttKLGEg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=N4NQxsQv;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D02E606A31E;
	Wed, 25 Nov 2026 15:02:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=N4NQxsQv
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 331431F000CA;
	Wed, 25 Nov 2026 15:02:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795618924;
	bh=aXVxcRuFQPqL+fKIheq+ASECyNg4vPKK4lyT2elu82Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=N4NQxsQv2JDAjxmW3TtJoEWtVN+SvPzXAgZanaxhUyVjPvoCv/xmm0KiVQNiMH68F
	 yCtyx9cbMlcUlF0QPhchpOp1Ixfi/vWO82xgpbylmu6tPntbmTomrOOk7AORHFEjHj
	 rs3pbL7rIrrMkIF6sPJhPLYR6atzjFEcP6WnEGrM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Avi Weiss <thnkslprpt@gmail.com>,
	Jeff Layton <jlayton@kernel.org>,
	NeilBrown <neil@brown.name>,
	Anna Schumaker <anna.schumaker@hammerspace.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0432/1005] SUNRPC: wake poll waiters when an empty pipe is unlinked
Date: Wed, 25 Nov 2026 15:29:30 +0100
Message-ID: <20261125143831.871723724@linuxfoundation.org>
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
index 9d349cfbc4831..68b4e040a77d9 100644
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



