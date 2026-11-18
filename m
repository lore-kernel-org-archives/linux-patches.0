Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795021389;
	b=OQaDjWrFhf/AMarjasEWwx21BqFPAft5h86cgOMO4w8pNb0JlsGSN+Rp8CfgTP9spfdy
	 Wwsdc0i/ibO87Y3TlvBXBJETrOaJk28np4fZsNAyBWJqtpa1tk7F3eO8wDeLBsfh2hBt8
	 Q1Yc70d1w+p5DOpnsrZ2wsfgoal5ad1Mp+AoVukmbNcGS63OEoNFSCQIwG0ZR5rx/7ZlQ
	 06rreqJby/rg9BRTwg8fWAQNRu4ogbDMGWNmfFfnjM1a/kiRnxl5RLJDpayYno/QJigqe
	 jPphMiRmhJGGbtr65BQOZdlh8Lqm5AoIizDZ4uLdYvYrKpcw2UzS1x1be/j9v8l0Z7Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795021389;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Bo9E8xLavtM3cIMdzXAPIBt+7rx8b1SoAb771u5wFwU=;
	b=z1oHwnCBf2Mdf7yu53ZgvbYaCYjZzD10o8rMIFL2OmKCW4u5nb4AigHr1UrYKNaXboee
	 UhMBSNNHAVmVZJk0iWIhFO5jY85PHoUsxEa7S3aMvTKNtS/mjfnw+2ge3GIlOvvCohHmQ
	 eualAVf2bt5CtGLE+0QiWQCnhwHM8EYoJjNI8w1O5gT7AmrFdAUey0wpgv4pJluqeHE7Y
	 xS4MRlM/gawpiW/CHyqBVXXjK6YXaQtnZJDBFwpdzxNzzGOztn1ADyFk84tcp9efyQeFy
	 gwW+yudGRwTiW18fLQ6vutc2akU5Hpk7zyDyMcSprd6OvjqGdBgETKZ6n74QDXRmhXg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=u9kPcSlk;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 87E0460A2605;
	Wed, 18 Nov 2026 17:03:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=u9kPcSlk
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DFF461F000C4;
	Wed, 18 Nov 2026 17:03:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795021389;
	bh=Bo9E8xLavtM3cIMdzXAPIBt+7rx8b1SoAb771u5wFwU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=u9kPcSlkGbEUXrw5lw3ieHgW7eFr4fyaK+h98pTsunpYyGaM8Sm4oJMpm3lV1DI0v
	 RPaoOrCvtMs5CGH3HNmCmaXifYuYA80E6B1VdKI2OfEm12nY713Fy37Et7+KIcuqX0
	 e1zHNGLuZZOCnqKYK5v2m87silAaHnWm4sGPr3+Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mingming Cao <mmc@linux.ibm.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 2273/2651] ibmveth: release the pool kobjects when probe fails
Date: Wed, 18 Nov 2026 15:58:33 +0100
Message-ID: <20261118150407.171839060@linuxfoundation.org>
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
index 919b5831d875c..42aa9f7bd49de 100644
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



