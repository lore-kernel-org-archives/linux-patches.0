Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 88D5A3DB983;
	Sat, 12 Sep 2026 12:28:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789216087; cv=none; b=c7oAINYmlzkx69gJV7ko21GQuOSOhlZtGWw/vCBXAO8d3W8BTNvXObI71KBkTsSmYD/CvEKOHPe8dQYBGptVq9FOBYoROvxCH6xkAfE8tzHJAnUtJRN0IxZPpX4rkGyc7+GlqqydPSZbnabRXr7/ikq+1lXvNvCVs7Z/cJwbnYg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789216087; c=relaxed/simple;
	bh=Iher/Y5042acL9e8p918cDqP+i2+gi3MU8aK1bf77Ow=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rKlDKW1UDcncp4xBAUFFmvCkLrQNrG9L9/7/dISJ/BbOjpQBfUJqNw7i6cDnW4S0JYSeIr8P1QERai8REYIU3TFygp7dzL8ECCOYTrgOeqSolE1wJsgu+JGGUj3MHLA51bxG5DfFdEXvXTPVuqagAU2nJeZALknDKm4K3UyCJrI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jH3jAphF; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jH3jAphF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 41E221F000FF;
	Sat, 12 Sep 2026 12:28:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789216086;
	bh=HFRGCP2YYzG+FEcpSQ9NHh89T+SfJLsIt2iLYEp0mqk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jH3jAphF6SKa807yIf3gVU3MfSVobtxk8SEUC9rZCRWn1XMFiRFiSIdfyWC5BzcFq
	 aSrgG90/gSvUMYhfwMJ4simsWhriZgLy5BWiGD3/adIFHMgfZ2FEqtcO1LIKaxYkCp
	 m/vhCF4OQOlx7Yx5kIKcCmCYfyAfBAFb3hNmHmo8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Boshi Yu <boshiyu@linux.alibaba.com>,
	Cheng Xu <chengyou@linux.alibaba.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0666/1376] RDMA/erdma: Probe the erdma RoCEv2 device
Date: Sat, 12 Sep 2026 08:51:32 +0200
Message-ID: <20260912065622.386516072@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.535295758@linuxfoundation.org>
References: <20260912065607.535295758@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Boshi Yu <boshiyu@linux.alibaba.com>

[ Upstream commit a883e71345a0101ff33be23a8d13f112ec4defb5 ]

Currently, the erdma driver supports both the iWARP and RoCEv2 protocols.
The erdma driver reads the ERDMA_REGS_DEV_PROTO_REG register to identify
the protocol used by the erdma device. Since each protocol requires
different ib_device_ops, we introduce the erdma_device_ops_iwarp and
erdma_device_ops_rocev2 for iWARP and RoCEv2 protocols, respectively.

Signed-off-by: Boshi Yu <boshiyu@linux.alibaba.com>
Link: https://patch.msgid.link/20241211020930.68833-2-boshiyu@linux.alibaba.com
Reviewed-by: Cheng Xu <chengyou@linux.alibaba.com>
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Stable-dep-of: 652befcba956 ("RDMA/erdma: complete object teardown when the destroy command fails")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/erdma/Kconfig       |  2 +-
 drivers/infiniband/hw/erdma/erdma.h       |  3 +-
 drivers/infiniband/hw/erdma/erdma_hw.h    |  7 +++++
 drivers/infiniband/hw/erdma/erdma_main.c  | 34 +++++++++++++++++------
 drivers/infiniband/hw/erdma/erdma_verbs.c | 16 ++++++++++-
 drivers/infiniband/hw/erdma/erdma_verbs.h | 12 ++++++++
 6 files changed, 62 insertions(+), 12 deletions(-)

diff --git a/drivers/infiniband/hw/erdma/Kconfig b/drivers/infiniband/hw/erdma/Kconfig
index 169038e3ceb12..267fc1f3c42af 100644
--- a/drivers/infiniband/hw/erdma/Kconfig
+++ b/drivers/infiniband/hw/erdma/Kconfig
@@ -5,7 +5,7 @@ config INFINIBAND_ERDMA
 	depends on INFINIBAND_ADDR_TRANS
 	depends on INFINIBAND_USER_ACCESS
 	help
-	  This is a RDMA/iWarp driver for Alibaba Elastic RDMA Adapter(ERDMA),
+	  This is a RDMA driver for Alibaba Elastic RDMA Adapter(ERDMA),
 	  which supports RDMA features in Alibaba cloud environment.
 
 	  To compile this driver as module, choose M here. The module will be
diff --git a/drivers/infiniband/hw/erdma/erdma.h b/drivers/infiniband/hw/erdma/erdma.h
index 3c166359448d0..ad4dc1a4bdc72 100644
--- a/drivers/infiniband/hw/erdma/erdma.h
+++ b/drivers/infiniband/hw/erdma/erdma.h
@@ -16,7 +16,7 @@
 #include "erdma_hw.h"
 
 #define DRV_MODULE_NAME "erdma"
-#define ERDMA_NODE_DESC "Elastic RDMA(iWARP) stack"
+#define ERDMA_NODE_DESC "Elastic RDMA Adapter stack"
 
 struct erdma_eq {
 	void *qbuf;
@@ -215,6 +215,7 @@ struct erdma_dev {
 
 	struct dma_pool *db_pool;
 	struct dma_pool *resp_pool;
+	enum erdma_proto_type proto;
 };
 
 static inline void *get_queue_entry(void *qbuf, u32 idx, u32 depth, u32 shift)
diff --git a/drivers/infiniband/hw/erdma/erdma_hw.h b/drivers/infiniband/hw/erdma/erdma_hw.h
index 05978f3b14759..970b392d4fb4e 100644
--- a/drivers/infiniband/hw/erdma/erdma_hw.h
+++ b/drivers/infiniband/hw/erdma/erdma_hw.h
@@ -21,8 +21,15 @@
 #define ERDMA_NUM_MSIX_VEC 32U
 #define ERDMA_MSIX_VECTOR_CMDQ 0
 
+/* erdma device protocol type */
+enum erdma_proto_type {
+	ERDMA_PROTO_IWARP = 0,
+	ERDMA_PROTO_ROCEV2 = 1,
+};
+
 /* PCIe Bar0 Registers. */
 #define ERDMA_REGS_VERSION_REG 0x0
+#define ERDMA_REGS_DEV_PROTO_REG 0xC
 #define ERDMA_REGS_DEV_CTRL_REG 0x10
 #define ERDMA_REGS_DEV_ST_REG 0x14
 #define ERDMA_REGS_NETDEV_MAC_L_REG 0x18
diff --git a/drivers/infiniband/hw/erdma/erdma_main.c b/drivers/infiniband/hw/erdma/erdma_main.c
index 62f497a710041..cf97bb79e5951 100644
--- a/drivers/infiniband/hw/erdma/erdma_main.c
+++ b/drivers/infiniband/hw/erdma/erdma_main.c
@@ -172,6 +172,8 @@ static int erdma_device_init(struct erdma_dev *dev, struct pci_dev *pdev)
 {
 	int ret;
 
+	dev->proto = erdma_reg_read32(dev, ERDMA_REGS_DEV_PROTO_REG);
+
 	dev->resp_pool = dma_pool_create("erdma_resp_pool", &pdev->dev,
 					 ERDMA_HW_RESP_SIZE, ERDMA_HW_RESP_SIZE,
 					 0);
@@ -474,6 +476,21 @@ static void erdma_res_cb_free(struct erdma_dev *dev)
 		bitmap_free(dev->res_cb[i].bitmap);
 }
 
+static const struct ib_device_ops erdma_device_ops_rocev2 = {
+	.get_link_layer = erdma_get_link_layer,
+};
+
+static const struct ib_device_ops erdma_device_ops_iwarp = {
+	.iw_accept = erdma_accept,
+	.iw_add_ref = erdma_qp_get_ref,
+	.iw_connect = erdma_connect,
+	.iw_create_listen = erdma_create_listen,
+	.iw_destroy_listen = erdma_destroy_listen,
+	.iw_get_qp = erdma_get_ibqp,
+	.iw_reject = erdma_reject,
+	.iw_rem_ref = erdma_qp_put_ref,
+};
+
 static const struct ib_device_ops erdma_device_ops = {
 	.owner = THIS_MODULE,
 	.driver_id = RDMA_DRIVER_ERDMA,
@@ -494,14 +511,6 @@ static const struct ib_device_ops erdma_device_ops = {
 	.get_dma_mr = erdma_get_dma_mr,
 	.get_hw_stats = erdma_get_hw_stats,
 	.get_port_immutable = erdma_get_port_immutable,
-	.iw_accept = erdma_accept,
-	.iw_add_ref = erdma_qp_get_ref,
-	.iw_connect = erdma_connect,
-	.iw_create_listen = erdma_create_listen,
-	.iw_destroy_listen = erdma_destroy_listen,
-	.iw_get_qp = erdma_get_ibqp,
-	.iw_reject = erdma_reject,
-	.iw_rem_ref = erdma_qp_put_ref,
 	.map_mr_sg = erdma_map_mr_sg,
 	.mmap = erdma_mmap,
 	.mmap_free = erdma_mmap_free,
@@ -537,7 +546,14 @@ static int erdma_ib_device_add(struct pci_dev *pdev)
 	if (ret)
 		return ret;
 
-	ibdev->node_type = RDMA_NODE_RNIC;
+	if (erdma_device_iwarp(dev)) {
+		ibdev->node_type = RDMA_NODE_RNIC;
+		ib_set_device_ops(ibdev, &erdma_device_ops_iwarp);
+	} else {
+		ibdev->node_type = RDMA_NODE_IB_CA;
+		ib_set_device_ops(ibdev, &erdma_device_ops_rocev2);
+	}
+
 	memcpy(ibdev->node_desc, ERDMA_NODE_DESC, sizeof(ERDMA_NODE_DESC));
 
 	/*
diff --git a/drivers/infiniband/hw/erdma/erdma_verbs.c b/drivers/infiniband/hw/erdma/erdma_verbs.c
index bf5627e3f237b..b330f33d32808 100644
--- a/drivers/infiniband/hw/erdma/erdma_verbs.c
+++ b/drivers/infiniband/hw/erdma/erdma_verbs.c
@@ -395,8 +395,17 @@ int erdma_query_port(struct ib_device *ibdev, u32 port,
 int erdma_get_port_immutable(struct ib_device *ibdev, u32 port,
 			     struct ib_port_immutable *port_immutable)
 {
+	struct erdma_dev *dev = to_edev(ibdev);
+
+	if (erdma_device_iwarp(dev)) {
+		port_immutable->core_cap_flags = RDMA_CORE_PORT_IWARP;
+	} else {
+		port_immutable->core_cap_flags =
+			RDMA_CORE_PORT_IBA_ROCE_UDP_ENCAP;
+		port_immutable->max_mad_size = IB_MGMT_MAD_SIZE;
+	}
+
 	port_immutable->gid_tbl_len = 1;
-	port_immutable->core_cap_flags = RDMA_CORE_PORT_IWARP;
 
 	return 0;
 }
@@ -1842,3 +1851,8 @@ int erdma_get_hw_stats(struct ib_device *ibdev, struct rdma_hw_stats *stats,
 
 	return stats->num_counters;
 }
+
+enum rdma_link_layer erdma_get_link_layer(struct ib_device *ibdev, u32 port_num)
+{
+	return IB_LINK_LAYER_ETHERNET;
+}
diff --git a/drivers/infiniband/hw/erdma/erdma_verbs.h b/drivers/infiniband/hw/erdma/erdma_verbs.h
index c998acd39a788..90e2b35a0973a 100644
--- a/drivers/infiniband/hw/erdma/erdma_verbs.h
+++ b/drivers/infiniband/hw/erdma/erdma_verbs.h
@@ -291,6 +291,16 @@ int erdma_modify_qp_internal(struct erdma_qp *qp, struct erdma_qp_attrs *attrs,
 void erdma_qp_llp_close(struct erdma_qp *qp);
 void erdma_qp_cm_drop(struct erdma_qp *qp);
 
+static inline bool erdma_device_iwarp(struct erdma_dev *dev)
+{
+	return dev->proto == ERDMA_PROTO_IWARP;
+}
+
+static inline bool erdma_device_rocev2(struct erdma_dev *dev)
+{
+	return dev->proto == ERDMA_PROTO_ROCEV2;
+}
+
 static inline struct erdma_ucontext *to_ectx(struct ib_ucontext *ibctx)
 {
 	return container_of(ibctx, struct erdma_ucontext, ibucontext);
@@ -370,5 +380,7 @@ struct rdma_hw_stats *erdma_alloc_hw_port_stats(struct ib_device *device,
 						u32 port_num);
 int erdma_get_hw_stats(struct ib_device *ibdev, struct rdma_hw_stats *stats,
 		       u32 port, int index);
+enum rdma_link_layer erdma_get_link_layer(struct ib_device *ibdev,
+					  u32 port_num);
 
 #endif
-- 
2.53.0



