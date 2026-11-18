Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795028760;
	b=AwU2GKqMFRQTjIFbRxgLciu7sTaFcvCdPUa+/rkbo86Ty2rqetA/Z25FuhoouvL3Rs7O
	 mL7vR10z2Xo1369ec2jXjso9qT5dLx5CgYqYbZpOPOXoUHSXZjN9mXdSFaOUIBLeIewkZ
	 auMJO4q9wL2+imwtQxfjx0luocgz2xL9HzgVc+H58F8hXId/O2Z0z5CWLRpa0sYx3lg1c
	 CWx/JDEB72CuFt45TFsdJMY9q16DutR50C3Uz3mrI5j/FTacDRh6ysqfjQVFU3HD3Y8o4
	 Uf49I3mVoyxvQbPiBze7HOY2PgtGgPTABDOgxnLHBFdMqe1MyREJTlQSg6QA3AHMEQQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795028760;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=qxlo3Yb+L/4RKmViZ+qlEsUm0W/CTcjNHExKU+sJWe4=;
	b=TqdssAGdIxDiAy6U3mQNoGR71qxS1hVakHX9Y1XFbe8I86uXgd72anAfqPk8/LCtk4FD
	 d/q0c/ExNDjYaR7UDHHlI8gM5YD816f9eG3aujbTe2mXaG+4C1zvViQ3Yv6YSM/Zf/kIb
	 ruNhmjM7V3c0L9PMk2+1XC8oAUCrN8wp2Y5/D4SdPwIGgiaTRizwzKvE3fp+SCKBWCBxg
	 t06tTCidxsUtobtQBhSbaFBe0xwQefnDdrj1TYbZe8NazTL/vUQDcYWKe7HV40sXAIL86
	 B5WradbGYQPIeA3GRhG6BXuty/gKSjtVCh06x1mIztFxZJa245bC+O+ZuGhJr6TDAPQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=QjhvxPjj;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 726CE606A333;
	Wed, 18 Nov 2026 19:06:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=QjhvxPjj
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C76461F000C4;
	Wed, 18 Nov 2026 19:05:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795028760;
	bh=qxlo3Yb+L/4RKmViZ+qlEsUm0W/CTcjNHExKU+sJWe4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=QjhvxPjjgAB00wU6Y/IQVny90eppuHav+aPrDvcNEP7xAabwfETz21fzcckKT1xwK
	 G0VumTNY+JwWgXf9wtJTfAHTyy5O8DiA1NkrUdWKbvYkJ9kOQ0qJ3Y+8noONHraePC
	 qGhb3xxN9IzOt6lEbmXxb1jOP6mc2o6NrBcozFWg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bernard Pidoux <bernard.f6bvp@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0108/1756] rose: change the loopback nodes under the neighbour list lock too
Date: Wed, 18 Nov 2026 15:37:15 +0100
Message-ID: <20261118150012.507033388@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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



