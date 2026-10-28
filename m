Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793214372;
	b=luz0nNFKhQXB5rbCqwaSHMTn/L1lawScLx+J4h/q9kmiGblyxfpC605Ll4e7iWa7yQaU
	 Wd2HoFwQPnFjuoV736RFia5trw15iRxz4k02pIbsYw7gaUBkTcB2MU7zkTLbtVIbX11EK
	 HGaD5+vs7WxMJsYXd2gocXwUdEGlRenj6DR1hjAWu56ymvBPuuJjnKaIZzZWWDINEA/H1
	 51NOrvqVF8MBnEwPdK7kXdArqURcsW1K+IgEHtkM7EY9jX1qJK5GXN9k2DklyfH5sfvv4
	 zspuLz5BAN1yZ8JkwPKtrKK2NBvcH6J/+eU5E+dGjwxVbvUmPLOvA0IfZzY6dzTMoXQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793214372;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=3PNekLhptwcHi7pY10pw8wftCeOMb4bNb5FAJNueako=;
	b=wyQE+TdfgszpMUuNXl2IFs3XWF0Ij3/1cKEpu0cm/u79y3DyHPbSKNMtlWsRq/wQSPv1
	 6q/r6Fdv6EhTqc5EyyllR7j3XOTcO9F+04jAF5mpnVxX5cVYQGplD/i9zW85TBmEPaozS
	 jOc3Ub997gqRDbSb/0IDuwZOOdxj1LF9BOC63M8WN0qtZ3mGOue394/au/3Ok0WIREdzg
	 y8Zos9BJWkaA79/y7asZAV/p1bgvoFBwR/2y4N960PyBOYLqW1+ycJMDkc7kEW4yVqsOf
	 QbfJUJ6YBrUfkA/yp9yc3eEN7Xka/25YiY3Je+B75/DTOvffseLd5CZJH2QO/996puw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=eoYAoalA;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC1F460A261F;
	Wed, 28 Oct 2026 19:06:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=eoYAoalA
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BDF5E1F01829;
	Wed, 28 Oct 2026 19:06:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793214371;
	bh=3PNekLhptwcHi7pY10pw8wftCeOMb4bNb5FAJNueako=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=eoYAoalAcv+R/9QiU6BxDaqzkRdLqyi+15P0jEn9wnB1mn8pqMZZtZSNADUL99wXg
	 ngd3wFyFs8Z/DHCRj0v70HOqhbkWTdqmSPdSTRLzm9kGP8wNVljd9RfPTqF9ARov9Z
	 xHpmkH1//OJmzS/tSOVKEAYwM25dc9SPtMQ7xVmE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stefan Raspl <raspl@linux.ibm.com>,
	Jan Karcher <jaka@linux.ibm.com>,
	Wenjia Zhang <wenjia@linux.ibm.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0835/1887] s390/ism: Introduce struct ism_dmb
Date: Wed, 28 Oct 2026 17:48:51 +0100
Message-ID: <20261028170518.428145442@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Stefan Raspl <raspl@linux.ibm.com>

[ Upstream commit 1baedb13f1d50ae8c7852134fdf934b4463e9baa ]

Conceptually, a DMB is a structure that belongs to ISM devices. However,
SMC currently 'owns' this structure. So future exploiters of ISM devices
would be forced to include SMC headers to work - which is just weird.
Therefore, we switch ISM to struct ism_dmb, introduce a new public header
with the definition (will be populated with further API calls later on),
and, add a thin wrapper to please SMC. Since structs smcd_dmb and ism_dmb
are identical, we can simply convert between the two for now.

Signed-off-by: Stefan Raspl <raspl@linux.ibm.com>
Signed-off-by: Jan Karcher <jaka@linux.ibm.com>
Signed-off-by: Wenjia Zhang <wenjia@linux.ibm.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Stable-dep-of: 897e8601b9cf ("s390/ism: fix concurrency management in ism_cmd()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/s390/net/ism.h     |  1 +
 drivers/s390/net/ism_drv.c | 22 ++++++++++++++++------
 include/linux/ism.h        | 23 +++++++++++++++++++++++
 3 files changed, 40 insertions(+), 6 deletions(-)
 create mode 100644 include/linux/ism.h

diff --git a/drivers/s390/net/ism.h b/drivers/s390/net/ism.h
index 38fe90c2597d1..90af513701836 100644
--- a/drivers/s390/net/ism.h
+++ b/drivers/s390/net/ism.h
@@ -5,6 +5,7 @@
 #include <linux/spinlock.h>
 #include <linux/types.h>
 #include <linux/pci.h>
+#include <linux/ism.h>
 #include <net/smc.h>
 #include <asm/pci_insn.h>
 
diff --git a/drivers/s390/net/ism_drv.c b/drivers/s390/net/ism_drv.c
index d34bb6ec1490f..cae64eccead9b 100644
--- a/drivers/s390/net/ism_drv.c
+++ b/drivers/s390/net/ism_drv.c
@@ -215,14 +215,14 @@ static int ism_query_rgid(struct smcd_dev *smcd, u64 rgid, u32 vid_valid,
 	return ism_cmd(ism, &cmd);
 }
 
-static void ism_free_dmb(struct ism_dev *ism, struct smcd_dmb *dmb)
+static void ism_free_dmb(struct ism_dev *ism, struct ism_dmb *dmb)
 {
 	clear_bit(dmb->sba_idx, ism->sba_bitmap);
 	dma_free_coherent(&ism->pdev->dev, dmb->dmb_len,
 			  dmb->cpu_addr, dmb->dma_addr);
 }
 
-static int ism_alloc_dmb(struct ism_dev *ism, struct smcd_dmb *dmb)
+static int ism_alloc_dmb(struct ism_dev *ism, struct ism_dmb *dmb)
 {
 	unsigned long bit;
 
@@ -250,7 +250,7 @@ static int ism_alloc_dmb(struct ism_dev *ism, struct smcd_dmb *dmb)
 	return dmb->cpu_addr ? 0 : -ENOMEM;
 }
 
-static int ism_register_dmb(struct smcd_dev *smcd, struct smcd_dmb *dmb)
+static int ism_register_dmb(struct smcd_dev *smcd, struct ism_dmb *dmb)
 {
 	struct ism_dev *ism = smcd->priv;
 	union ism_reg_dmb cmd;
@@ -281,7 +281,12 @@ static int ism_register_dmb(struct smcd_dev *smcd, struct smcd_dmb *dmb)
 	return ret;
 }
 
-static int ism_unregister_dmb(struct smcd_dev *smcd, struct smcd_dmb *dmb)
+static int smcd_register_dmb(struct smcd_dev *smcd, struct smcd_dmb *dmb)
+{
+	return ism_register_dmb(smcd, (struct ism_dmb *)dmb);
+}
+
+static int ism_unregister_dmb(struct smcd_dev *smcd, struct ism_dmb *dmb)
 {
 	struct ism_dev *ism = smcd->priv;
 	union ism_unreg_dmb cmd;
@@ -302,6 +307,11 @@ static int ism_unregister_dmb(struct smcd_dev *smcd, struct smcd_dmb *dmb)
 	return ret;
 }
 
+static int smcd_unregister_dmb(struct smcd_dev *smcd, struct smcd_dmb *dmb)
+{
+	return ism_unregister_dmb(smcd, (struct ism_dmb *)dmb);
+}
+
 static int ism_add_vlan_id(struct smcd_dev *smcd, u64 vlan_id)
 {
 	struct ism_dev *ism = smcd->priv;
@@ -474,8 +484,8 @@ static irqreturn_t ism_handle_irq(int irq, void *data)
 
 static const struct smcd_ops ism_ops = {
 	.query_remote_gid = ism_query_rgid,
-	.register_dmb = ism_register_dmb,
-	.unregister_dmb = ism_unregister_dmb,
+	.register_dmb = smcd_register_dmb,
+	.unregister_dmb = smcd_unregister_dmb,
 	.add_vlan_id = ism_add_vlan_id,
 	.del_vlan_id = ism_del_vlan_id,
 	.set_vlan_required = ism_set_vlan_required,
diff --git a/include/linux/ism.h b/include/linux/ism.h
new file mode 100644
index 0000000000000..69bfbf0faaa10
--- /dev/null
+++ b/include/linux/ism.h
@@ -0,0 +1,23 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/*
+ *  Internal Shared Memory
+ *
+ *  Definitions for the ISM module
+ *
+ *  Copyright IBM Corp. 2022
+ */
+#ifndef _ISM_H
+#define _ISM_H
+
+struct ism_dmb {
+	u64 dmb_tok;
+	u64 rgid;
+	u32 dmb_len;
+	u32 sba_idx;
+	u32 vlan_valid;
+	u32 vlan_id;
+	void *cpu_addr;
+	dma_addr_t dma_addr;
+};
+
+#endif	/* _ISM_H */
-- 
2.53.0



