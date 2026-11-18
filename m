Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795058788;
	b=wsEBlv0jMiTE0688V8iDujNnLN0ZIGJNB93FtaMBwnUUJ7vJobiOfP9eaSm0Xzp25QHW
	 OxtX7DprIY1kbuR0MhvbteBsF3MpzNEm+e1jpb/YETwyh3vM11VtoQNSMogDAf5/gAutS
	 mwgprZQy5wkJddvmut6iCj14wRYs4qVKAGotJIR2mjSkhgV2gqdpJ04bF8+k81QEZw2/9
	 2rAnA9I2r4oQeOHxyaeX4HgiZA276N5Xs6oJvImk26SwlHEzxhTcUismhCo6l0MXgZZZr
	 PBoSWqyDHZPR4V3JOQGcByhtQmbQDExrOdtS0/I5uAtj4EFW+XsH0F4FurQcOog1CYg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795058788;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=1cmqN4x+fHa1vtGdfYcf7fKbgu3c3AXYVgqlan2vkTA=;
	b=No41P9WG+UnRqhj4nRwnumr7An8EwZYjxMubtAAvK9m57WlCQ9R4E+A4txaK1TvrgJGu
	 AT2GPysxdZquBZ0i2i4JWEgvPXQkvQtdE/hnj33WuvtSX3clqmXEJA5/WOeAH0KE5Nt8U
	 JuZV7+KPGRNiz5FSbDlD7ZmgQOLU/QjcPulFyztOuvHKztNfj9zqxriDVlCoxNRb+mb3o
	 EMpUKvsxyhr6UPJkywoLH13rl+6evLmPUYh8AxxeYLtaBaeMXQFpNVynQnurQ+lXXVtVS
	 M35QXHADOnudmGx6joMM1f1xIUudoFevhjYkpMeg9mviAhGp5S86ZkTNCPYXO1arstQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=gf2gK6Qi;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF77E606A32C;
	Thu, 19 Nov 2026 03:26:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=gf2gK6Qi
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1D25E1F000C4;
	Thu, 19 Nov 2026 03:26:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795058788;
	bh=1cmqN4x+fHa1vtGdfYcf7fKbgu3c3AXYVgqlan2vkTA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gf2gK6QiHeAVhfFpJ2/Dqgh7jFCpvyh0lECEux2WOoqfFq0Kwl6VJJpK9QSPHOdOe
	 RJRYm9vrMkcrwKe+zFAeCF2BWemZ1c7/fhOTM77VZAiBvmN5DJjg4ubS+1s+VymQD6
	 AgOCX9clFJsGQxQlQp6N141mtNWpO7BBkulsGI1w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chuck Lever <cel@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 0610/1848] NFSD: Set nn->cld_net before registering the cld pipe
Date: Wed, 18 Nov 2026 15:44:08 +0100
Message-ID: <20261118145940.854860193@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chuck Lever <cel@kernel.org>

[ Upstream commit 14996e662f3b734427e2d645cacffc27b779f7d1 ]

rpc_mkpipe_dentry() instantiates the pipe's dentry before it returns,
so the cld pipe can be opened as soon as nfsd4_cld_register_net() has
run. __nfsd4_init_cld_pipe() does not store the new cld_net in
nn->cld_net until after that call. cld_pipe_downcall() reaches the
cld_net only through that pointer and takes cn_lock without checking
it, so a write() that lands in the window oopses.

Store nn->cld_net once @cn is fully initialized and before the pipe is
registered, and clear it again when registration fails.

Fixes: f3f8014862d8 ("nfsd: add the infrastructure to handle the cld upcall")
Cc: stable@vger.kernel.org
Link: https://patch.msgid.link/20260901-alemi-v2-6-e163f94a3a6e@kernel.org
Signed-off-by: Chuck Lever <cel@kernel.org>
[ sashal: omitted CONFIG_NFSD_LEGACY_CLIENT_TRACKING guards around cn_has_legacy initialization ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfsd/nfs4recover.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/fs/nfsd/nfs4recover.c b/fs/nfsd/nfs4recover.c
index 742e93f15c8f5..54815ce3da035 100644
--- a/fs/nfsd/nfs4recover.c
+++ b/fs/nfsd/nfs4recover.c
@@ -1014,6 +1014,13 @@ __nfsd4_init_cld_pipe(struct net *net)
 	}
 	spin_lock_init(&cn->cn_lock);
 	INIT_LIST_HEAD(&cn->cn_list);
+	cn->cn_has_legacy = false;
+
+	/*
+	 * The pipe's methods reach @cn through nn->cld_net, so set
+	 * it before the pipe can be opened.
+	 */
+	nn->cld_net = cn;
 
 	dentry = nfsd4_cld_register_net(net, cn->cn_pipe);
 	if (IS_ERR(dentry)) {
@@ -1022,11 +1029,10 @@ __nfsd4_init_cld_pipe(struct net *net)
 	}
 
 	cn->cn_pipe->dentry = dentry;
-	cn->cn_has_legacy = false;
-	nn->cld_net = cn;
 	return 0;
 
 err_destroy_data:
+	nn->cld_net = NULL;
 	rpc_destroy_pipe_data(cn->cn_pipe);
 err:
 	kfree(cn);
-- 
2.53.0



