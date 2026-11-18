Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795019520;
	b=MGzX3wj9IEjy3xbnCb59BJi8fvIgsUO1x1sv+JtaHfAh/uOSAmo7p3dvQIRhzmSk5bP+
	 gTJw8WHsOvpREYRnbcCjnz0VctpppqCubTGqR+yq0g1YQ9o1tXogpnGZZdgwsDqP8s4hP
	 /QBF7jdOEGfIzLWddbEvCZ80eLLrBHXWSIncmoDcrDfu5FXnmPos19jgtyIkS7tSFhdOz
	 8zDBQV50a10uHfefCXyrqcC5Y/17ozxtjKuwMFB/Z4paD//kSUAPPvkiuYE9XtQ6PSBE3
	 Fm5RoxUW5c5EBY72Gcerp65sgzhJLc1W9jHXY5zCzmGo0YlJalrI593Cmk65gCj8QUA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795019520;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Qsr5aWZP4fwilHG4EhztbHCLbBpvxDDmOjXyN++Z1ko=;
	b=0HCqEHAT2/oL9HTVXAqGQb0OHUUA2/LTKsUWPuwnhmz7q6qrtsKJgw+tS1Y8RK78V/p3
	 /rQza6jwvgi97xU263eH8dJ91P06Rag57T69/IDCPcOELCDmafpp3yCfkL0GKoXlwELwA
	 ITEW6RN7EyKwABxx0Ui5Eeatul+J6czOROAc0lVkb65gk3B5vPojVYW1dRxsy7EYt/NNT
	 LM4cIuN6TJDhWOnwdiTsIFT454wuTdm+H00CC5HVfgo8xn2yC9+qI2SMcZuqHilAciXdm
	 glMZOn/prOQs3KrzUXCiBOSyo+LqFq7CbMHZKP/eip1C0sGXfg5d6JbXbdFkQ745sIQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=H1pJc4JG;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 199AA606A33A;
	Wed, 18 Nov 2026 16:32:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=H1pJc4JG
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6AF801F000C6;
	Wed, 18 Nov 2026 16:31:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795019520;
	bh=Qsr5aWZP4fwilHG4EhztbHCLbBpvxDDmOjXyN++Z1ko=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=H1pJc4JGhcqODtJwghs/tZN3qYehhheaLKSRsd3N90Cy2xImmTT2FHqLY0xzylQ/H
	 gWItyPBxJF6voatTZoZgKrgxxw6x2w2q7Lbo55FBmFwS8UDodILjZ2vWUmS14d4mi9
	 wXVb5HjFoycjla4oBGZ6n4BMEKj+HXS7N1wHc6eo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kaifeng Wang <kaifengw@google.com>,
	Stanislav Fomichev <sdf@fomichev.me>,
	Bobby Eshleman <bobbyeshleman@meta.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1626/2651] net: devmem: check uid and netns in net_devmem_get_binding()
Date: Wed, 18 Nov 2026 15:47:46 +0100
Message-ID: <20261118150346.396262824@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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

From: Kaifeng Wang <kaifengw@google.com>

[ Upstream commit 3a82195416fd71fdd6cb4ff80f611ec28073be16 ]

NETDEV_CMD_BIND_TX is unprivileged, and dmabuf binding IDs are allocated
from a single global xarray. Currently net_devmem_get_binding() looks up
the binding by ID without checking whether the sending socket belongs to
the same user or network namespace that created the binding.

Record the creating netlink socket's network namespace and UID on the
binding, and verify both in net_devmem_get_binding() before checking the
route destination device. Return -EINVAL on mismatch so callers cannot
distinguish non-existent IDs from bindings owned by other users.

Fixes: bd61848900bf ("net: devmem: Implement TX path")
Signed-off-by: Kaifeng Wang <kaifengw@google.com>
Acked-by: Stanislav Fomichev <sdf@fomichev.me>
Reviewed-by: Bobby Eshleman <bobbyeshleman@meta.com>
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/core/devmem.c      | 7 ++++++-
 net/core/devmem.h      | 5 +++++
 net/core/netdev-genl.c | 5 +++--
 3 files changed, 14 insertions(+), 3 deletions(-)

diff --git a/net/core/devmem.c b/net/core/devmem.c
index 7cac0dab8ea87..87f238020c911 100644
--- a/net/core/devmem.c
+++ b/net/core/devmem.c
@@ -161,6 +161,7 @@ net_devmem_bind_dmabuf(struct net_device *dev, void *vdev,
 		       enum dma_data_direction direction,
 		       unsigned int dmabuf_fd, unsigned int niov_shift,
 		       struct netdev_nl_sock *priv,
+		       const struct sock *nl_sk,
 		       struct netlink_ext_ack *extack)
 {
 	struct net_devmem_dmabuf_binding *binding;
@@ -191,6 +192,8 @@ net_devmem_bind_dmabuf(struct net_device *dev, void *vdev,
 
 	binding->dev = dev;
 	binding->vdev = vdev;
+	write_pnet(&binding->net, sock_net(nl_sk));
+	binding->uid = sk_uid(nl_sk);
 	binding->niov_shift = niov_shift;
 	xa_init_flags(&binding->bound_rxqs, XA_FLAGS_ALLOC);
 
@@ -347,7 +350,9 @@ struct net_devmem_dmabuf_binding *net_devmem_get_binding(struct sock *sk,
 	int err = 0;
 
 	binding = net_devmem_lookup_dmabuf(dmabuf_id);
-	if (!binding || !binding->tx_vec) {
+	if (!binding || !binding->tx_vec ||
+	    !net_eq(sock_net(sk), read_pnet(&binding->net)) ||
+	    !uid_eq(sk_uid(sk), binding->uid)) {
 		err = -EINVAL;
 		goto out_err;
 	}
diff --git a/net/core/devmem.h b/net/core/devmem.h
index 6ed16b4b4687e..71c7bd9d6e395 100644
--- a/net/core/devmem.h
+++ b/net/core/devmem.h
@@ -10,6 +10,7 @@
 #ifndef _NET_DEVMEM_H
 #define _NET_DEVMEM_H
 
+#include <net/net_namespace.h>
 #include <net/netmem.h>
 #include <net/netdev_netlink.h>
 
@@ -27,6 +28,8 @@ struct net_devmem_dmabuf_binding {
 	 * dereferenced.
 	 */
 	void *vdev;
+	possible_net_t net;
+	kuid_t uid;
 	/* Protect dev */
 	struct mutex lock;
 
@@ -88,6 +91,7 @@ net_devmem_bind_dmabuf(struct net_device *dev, void *vdev,
 		       enum dma_data_direction direction,
 		       unsigned int dmabuf_fd, unsigned int niov_shift,
 		       struct netdev_nl_sock *priv,
+		       const struct sock *nl_sk,
 		       struct netlink_ext_ack *extack);
 struct net_devmem_dmabuf_binding *net_devmem_lookup_dmabuf(u32 id);
 void net_devmem_unbind_dmabuf(struct net_devmem_dmabuf_binding *binding);
@@ -165,6 +169,7 @@ net_devmem_bind_dmabuf(struct net_device *dev, void *vdev,
 		       unsigned int dmabuf_fd,
 		       unsigned int niov_shift,
 		       struct netdev_nl_sock *priv,
+		       const struct sock *nl_sk,
 		       struct netlink_ext_ack *extack)
 {
 	return ERR_PTR(-EOPNOTSUPP);
diff --git a/net/core/netdev-genl.c b/net/core/netdev-genl.c
index 33b9f4eb9565a..847814e3df3fd 100644
--- a/net/core/netdev-genl.c
+++ b/net/core/netdev-genl.c
@@ -1094,7 +1094,7 @@ int netdev_nl_bind_rx_doit(struct sk_buff *skb, struct genl_info *info)
 
 	binding = net_devmem_bind_dmabuf(netdev, NULL, dma_dev, DMA_FROM_DEVICE,
 					 dmabuf_fd, niov_shift, priv,
-					 info->extack);
+					 NETLINK_CB(skb).sk, info->extack);
 	if (IS_ERR(binding)) {
 		err = PTR_ERR(binding);
 		goto err_rxq_bitmap;
@@ -1243,7 +1243,8 @@ int netdev_nl_bind_tx_doit(struct sk_buff *skb, struct genl_info *info)
 	binding = net_devmem_bind_dmabuf(bind_dev,
 					 bind_dev != netdev ? netdev : NULL,
 					 dma_dev, DMA_TO_DEVICE, dmabuf_fd,
-					 PAGE_SHIFT, priv, info->extack);
+					 PAGE_SHIFT, priv, NETLINK_CB(skb).sk,
+					 info->extack);
 	if (IS_ERR(binding)) {
 		err = PTR_ERR(binding);
 		goto err_unlock_bind_dev;
-- 
2.53.0



