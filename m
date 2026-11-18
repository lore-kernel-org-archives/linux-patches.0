Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795022705;
	b=Jyi/XSwKCja4s1iLmgxSjtN1tGoiD4x3Ou3IkzipUljQT5HzrIFlCGm6tjxxnMtbneQv
	 Kzsi01o305kzKQtr9ZULW5yucwq+l0KtDx9pgftvyt/KEf8kRF8q6sHIiu5sEB15ZB1Ie
	 KhDjcnrybhu0VlMcoppd/7PVFNjs/YaR/Xf4mrfhKsei4BU+ewRY5mPeL547lBzgG3W0e
	 0OykMgWg6n9EEfu7AwX1HaLBN8xzBa+FhDOG0Cur/sxuh7NCJzbVItdinNVdZB0XEMWoB
	 cOML2xd6bjxAEE7uuRb0qtMcCS5p+BFvkwOdsdi4p9nL5qVX/kTI/H7R7SqOfLuQg5g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795022705;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=keVp62F2P8QWhhwqAZzFvFbVyXuiZMHz7oAC2UpsW8c=;
	b=kc4doCtIoRIqXRwTpliDhlaZccgiH3xkS1bOQ4SaIi1QILxNhXhLXLzfwU2Le60mNzms
	 rRKq9VpiV3QkHY6hwEELq+u1OuRa+dX89uoj1FMzjORuNOOOxCH1mQ2aIJiva8AuofcUX
	 OP8eXZsXlGxstD7yqQlDviNyfhqJ3jv1osye4t7vQHF3EE0uXNQ4m8QPoQNJjke1gGsHZ
	 XqssqHT/TweV0CQ6C4KbJ8YKjbVxfE0bmVUt4oiWk7oN5kvgiot08KTITQRr3VT3Hm7Y1
	 Iv9de5njshZFnYKBABxQ+1O+mC/9bcRD52YCczFgqCJoANe08xu8eSgu3aw/r6NE4CQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=K925cAhJ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3EE80606A331;
	Wed, 18 Nov 2026 17:25:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=K925cAhJ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 86E221F000C4;
	Wed, 18 Nov 2026 17:25:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795022705;
	bh=keVp62F2P8QWhhwqAZzFvFbVyXuiZMHz7oAC2UpsW8c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=K925cAhJpvandw2EllcS4mKj0o9zQVo9IGeiNmBBFhGP+xDdZM3wRBFFYs5zBhGku
	 NOxLwxZa+4pmE/pfFboklF0UMpphdcPIK7hOlRZNZ3Dx6yVLsicNnfE9AjTN9k9+T8
	 uMaJjqqo/p9A0oubxkKgsrCwuwRm6+N/IrQ8B0UU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bernard Pidoux <bernard.f6bvp@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0109/2151] rose: change the loopback nodes under the neighbour list lock too
Date: Wed, 18 Nov 2026 15:30:44 +0100
Message-ID: <20261118150125.767941979@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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

From: Bernard Pidoux <bernard.f6bvp@gmail.com>

Since commit fe2c802ab62a ("rose: improving AX25 routing frames via ROSE
network"), rose_route_frame() looks up the node list through
rose_get_neigh() with route_frame set, under rose_neigh_list_lock only:
it cannot take rose_node_list_lock there. Every other writer of
rose_node_list holds both locks for that reason, but
rose_add_loopback_node() and rose_del_loopback_node(), run when a rose
device is opened, closed or given a new address, take
rose_node_list_lock alone. A frame routed at that moment can walk a node
that is being freed.

Take rose_neigh_list_lock inside rose_node_list_lock in both, in the
same order as rose_add_node() and rose_del_node().

Fixes: fe2c802ab62a ("rose: improving AX25 routing frames via ROSE network")
Signed-off-by: Bernard Pidoux <bernard.f6bvp@gmail.com>
Assisted-by: Claude:claude-opus-5-5
(cherry picked from commit 0ab5a3287997c348ca74443999abb9e6004beece)
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/rose/rose_route.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/net/rose/rose_route.c b/net/rose/rose_route.c
index 7044496bb214e..30dfbe1f14311 100644
--- a/net/rose/rose_route.c
+++ b/net/rose/rose_route.c
@@ -463,6 +463,7 @@ int rose_add_loopback_node(const rose_address *address)
 	int err = 0;
 
 	spin_lock_bh(&rose_node_list_lock);
+	spin_lock_bh(&rose_neigh_list_lock);
 
 	rose_node = rose_node_list;
 	while (rose_node != NULL) {
@@ -495,6 +496,7 @@ int rose_add_loopback_node(const rose_address *address)
 	rose_neigh_hold(rose_loopback_neigh);
 
 out:
+	spin_unlock_bh(&rose_neigh_list_lock);
 	spin_unlock_bh(&rose_node_list_lock);
 
 	return err;
@@ -508,6 +510,7 @@ void rose_del_loopback_node(const rose_address *address)
 	struct rose_node *rose_node;
 
 	spin_lock_bh(&rose_node_list_lock);
+	spin_lock_bh(&rose_neigh_list_lock);
 
 	rose_node = rose_node_list;
 	while (rose_node != NULL) {
@@ -527,6 +530,7 @@ void rose_del_loopback_node(const rose_address *address)
 	rose_neigh_put(rose_loopback_neigh);
 
 out:
+	spin_unlock_bh(&rose_neigh_list_lock);
 	spin_unlock_bh(&rose_node_list_lock);
 }
 
-- 
2.53.0



