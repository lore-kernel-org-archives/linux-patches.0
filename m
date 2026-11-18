Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795027564;
	b=gpoxXJUhmQi9DvNW2u0cJKcIpccScU9Djm4m+lQiV6sA/+Z+GcoslPgaQVpumxpRzT7L
	 /JWrI3TIyH8lDy4+3FiD1e4Nf8VgrUV1YxfiVJo6Wpqd39gCopmzqLbZTwUHG6aiRv6B0
	 MF1MP9rA/nqPlS9Wg0YRWf7rWUL5gZVGvz16pyyuXVreQg9Vce+7e6QtXmzeSM9+ljPrz
	 0xEnyAFyhn5Qil0Wa8de2hXkpma+F1+tCLqXFgZqYU6p9YJMLKQl+IUt3LuHjKBcFmtYO
	 XW1BaIyqifpkfJ/hQlodzLkJ8ry+8OHScA+DhzMWuEPV+09Lv2m6+yXNh/tNPG5f8Cg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795027564;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=KLU9kQ7FZYp23RUZFH3RsrytaLRxm7REIpaRnm8WEaM=;
	b=dn4ny7c5wJsY+gd5CQldra4v5pgicBS5enxIcpgYjumgWl1AlYqd5bDfUyKAO4qrhQXx
	 xXBD3rdi6DS/PKYyYEm2wWyWgoNLuSqnYFKswMuNpQWNZyHzhXpQaoybEb78AZWCrGTJ+
	 p4BsnLOqYViUnQ2VO+gAabHYNXXRFXBz6Dbq9ytAz7PWkKrPsPVx4EQylOcyefDCnZe2y
	 pUH99NyxbVvQV3rnwnPoeQiCJvV2MNM9xw5Hgw51TxZepmvnepw/r+qm6V3ZGLrBelZsF
	 RovEFWuXWtuC1V155Cjj6ArG7xoeLdj+FrmXCZfCHyv4Ha4aESjUjsKfUxKP3MDO0AA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="LnPWY/qf";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C8413606A32C;
	Wed, 18 Nov 2026 18:46:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=LnPWY/qf
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5617F1F000C6;
	Wed, 18 Nov 2026 18:46:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795027564;
	bh=KLU9kQ7FZYp23RUZFH3RsrytaLRxm7REIpaRnm8WEaM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=LnPWY/qfM+XpSUnTd2dyViAYDXsQok13GW3LNzg2J6zbiOno9VbVy6VNI/MOmR79Y
	 kXkrNRQAkc/nYdsQ7SdIxpSvd7xuvLA4RepujV5vupwbBXALHjvTKRfG2xfJ+9VSDo
	 J5P4HYjxFmGKjh3/CKmaJSe3t6+XLVn8YLo8RSMs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mingming Cao <mmc@linux.ibm.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1835/2151] ibmveth: release the pool kobjects when probe fails
Date: Wed, 18 Nov 2026 15:59:30 +0100
Message-ID: <20261118150228.646132307@linuxfoundation.org>
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

From: Mingming Cao <mmc@linux.ibm.com>

[ Upstream commit fd052c6823b31eb45f824660567ab3f2da2d5195 ]

If register_netdev() fails in ibmveth_probe(), for example with -EINTR
when the binding task is killed, probe frees the netdev but leaves the
pool%d kobjects embedded in it registered in sysfs. Reading
/sys/devices/vio/<unit>/pool0/num is then a use-after-free, and the
next probe cannot add pool0.

Put the kobjects before freeing the netdev, as ibmveth_remove() does,
on this path and on the netif_set_real_num_tx_queues() one.

The kobjects also have no release(). With CONFIG_DEBUG_KOBJECT_RELEASE,
kobject_put() defers their cleanup, including removing the sysfs files,
to a work item, so free_netdev() can free them first, here and in
remove(). Add a release() that signals a per-pool completion, and wait
for it in both places before free_netdev(). Without that config,
release() runs from kobject_put() and the wait returns at once.

Found in review of the ibmveth multi-queue RX series and confirmed by
code inspection; the release() part was raised by the Sashiko review of
the first version. Tested on a POWER10 LPAR with register_netdev()
forced to fail with -EINTR by a test-only module parameter (not part of
this patch): no pool%d directories remain and the device binds again. No
kernel selftests cover ibmveth.

Fixes: 860f242eb534 ("[PATCH] ibmveth change buffer pools dynamically")
Signed-off-by: Mingming Cao <mmc@linux.ibm.com>
Link: https://patch.msgid.link/20261013182926.30417-6-mmc@linux.ibm.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/ibm/ibmveth.c | 52 +++++++++++++++++++++++++-----
 drivers/net/ethernet/ibm/ibmveth.h |  3 ++
 2 files changed, 47 insertions(+), 8 deletions(-)

diff --git a/drivers/net/ethernet/ibm/ibmveth.c b/drivers/net/ethernet/ibm/ibmveth.c
index e985d3ededdb8..2d6f61bfb4953 100644
--- a/drivers/net/ethernet/ibm/ibmveth.c
+++ b/drivers/net/ethernet/ibm/ibmveth.c
@@ -1890,6 +1890,40 @@ static const struct net_device_ops ibmveth_netdev_ops = {
 	.ndo_features_check	= ibmveth_features_check,
 };
 
+/**
+ * ibmveth_pool_kobj_release - Mark a pool kobject finished
+ * @kobj: kobject embedded in the pool
+ *
+ * The pool kobjects live in netdev_priv(), so the last put must wait
+ * for this before free_netdev().
+ */
+static void ibmveth_pool_kobj_release(struct kobject *kobj)
+{
+	struct ibmveth_buff_pool *pool = container_of(kobj,
+						      struct ibmveth_buff_pool,
+						      kobj);
+
+	complete(&pool->released);
+}
+
+/**
+ * ibmveth_put_pool_kobjs - Drop the pool kobjects and wait for release
+ * @adapter: ibmveth adapter
+ *
+ * With CONFIG_DEBUG_KOBJECT_RELEASE the cleanup, including removing the
+ * sysfs files, runs later from a work item in the kobject; wait for it
+ * so free_netdev() cannot free the pools first.
+ */
+static void ibmveth_put_pool_kobjs(struct ibmveth_adapter *adapter)
+{
+	int i;
+
+	for (i = 0; i < IBMVETH_NUM_BUFF_POOLS; i++)
+		kobject_put(&adapter->rx_buff_pool[i].kobj);
+	for (i = 0; i < IBMVETH_NUM_BUFF_POOLS; i++)
+		wait_for_completion(&adapter->rx_buff_pool[i].released);
+}
+
 static int ibmveth_probe(struct vio_dev *dev, const struct vio_device_id *id)
 {
 	int rc, i, mac_len;
@@ -2000,6 +2034,7 @@ static int ibmveth_probe(struct vio_dev *dev, const struct vio_device_id *id)
 		ibmveth_init_buffer_pool(&adapter->rx_buff_pool[i], i,
 					 pool_count[i], pool_size[i],
 					 pool_active[i]);
+		init_completion(&adapter->rx_buff_pool[i].released);
 		error = kobject_init_and_add(kobj, &ktype_veth_pool,
 					     &dev->dev.kobj, "pool%d", i);
 		if (!error)
@@ -2011,8 +2046,7 @@ static int ibmveth_probe(struct vio_dev *dev, const struct vio_device_id *id)
 	if (rc) {
 		netdev_dbg(netdev, "failed to set number of tx queues rc=%d\n",
 			   rc);
-		free_netdev(netdev);
-		return rc;
+		goto err_put_pools;
 	}
 	adapter->tx_ltb_size = PAGE_ALIGN(IBMVETH_MAX_TX_BUF_SIZE);
 	for (i = 0; i < IBMVETH_MAX_QUEUES; i++)
@@ -2027,25 +2061,27 @@ static int ibmveth_probe(struct vio_dev *dev, const struct vio_device_id *id)
 
 	if (rc) {
 		netdev_dbg(netdev, "failed to register netdev rc=%d\n", rc);
-		free_netdev(netdev);
-		return rc;
+		goto err_put_pools;
 	}
 
 	netdev_dbg(netdev, "registered\n");
 
 	return 0;
+
+err_put_pools:
+	ibmveth_put_pool_kobjs(adapter);
+	free_netdev(netdev);
+	return rc;
 }
 
 static void ibmveth_remove(struct vio_dev *dev)
 {
 	struct net_device *netdev = dev_get_drvdata(&dev->dev);
 	struct ibmveth_adapter *adapter = netdev_priv(netdev);
-	int i;
 
 	disable_work_sync(&adapter->work);
 
-	for (i = 0; i < IBMVETH_NUM_BUFF_POOLS; i++)
-		kobject_put(&adapter->rx_buff_pool[i].kobj);
+	ibmveth_put_pool_kobjs(adapter);
 
 	unregister_netdev(netdev);
 
@@ -2221,7 +2257,7 @@ static const struct sysfs_ops veth_pool_ops = {
 };
 
 static struct kobj_type ktype_veth_pool = {
-	.release        = NULL,
+	.release        = ibmveth_pool_kobj_release,
 	.sysfs_ops      = &veth_pool_ops,
 	.default_groups = veth_pool_groups,
 };
diff --git a/drivers/net/ethernet/ibm/ibmveth.h b/drivers/net/ethernet/ibm/ibmveth.h
index 3f2240823f6a3..be0939caa328e 100644
--- a/drivers/net/ethernet/ibm/ibmveth.h
+++ b/drivers/net/ethernet/ibm/ibmveth.h
@@ -14,6 +14,8 @@
 #ifndef _IBMVETH_H
 #define _IBMVETH_H
 
+#include <linux/completion.h>
+
 /* constants for H_MULTICAST_CTRL */
 #define IbmVethMcastReceptionModifyBit     0x80000UL
 #define IbmVethMcastReceptionEnableBit     0x20000UL
@@ -143,6 +145,7 @@ struct ibmveth_buff_pool {
     struct sk_buff **skbuff;
     int active;
     struct kobject kobj;
+	struct completion released;
 };
 
 struct ibmveth_rx_q {
-- 
2.53.0



