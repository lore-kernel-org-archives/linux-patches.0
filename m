Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A524D4195DA;
	Sat, 12 Sep 2026 12:28:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789216096; cv=none; b=K96MVCowp85rF8JWneZkLl+vPluv87Vm1gl6d9irCVtmhdELZSbkex6xs633+/0sONm+4kLd8xgR6fQjPY2Idaq2kzCsqGvBS/dC0OMYlTuoE3CqC1hXCbFxo8DWeSuDsnrGk9SHMIHzXMK2y3WKHsXhgM0HqTYoFjX26GhbuNo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789216096; c=relaxed/simple;
	bh=pVzVIdzkg/yZyC3jaW+rlEEkRZB1bfdtPBqXIPvr47k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YtF6sBtxQ9zhyG0gvlYn/NS3A3HQBChUvwertmgMUg3BpVdO7dmqc8LN+cygDwPBhCfBbqbEhTQEt62lWA/eCPrTqtykRbE0C12STBo2llqVxgGl21+pi7aRq5EJ/UYj2W4m6VsghYxBwNmgSsOi+arFgn03DNnev7187JarrNY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ssQx9Ulq; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ssQx9Ulq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C2A6A1F000FF;
	Sat, 12 Sep 2026 12:28:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789216095;
	bh=S5W8FPkoEeQX/0UYQkrSzf+W9GpGJjKqu/fTtzJfs/A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ssQx9UlqSfo5kgpUkh0CRhpXK3HawuQ1ED6JShTdieY1VwD/pRABbRMtN7wTPvtKV
	 aowQBYLrqsfOa5rbhXr18vcouJHMgAEp+ctdhL2ps2ta8WWxNxVrneBxH3/5/tqPaZ
	 w7Xgwr9c+wcUxkTY1sgTwQumswiGbLpL7Fumzbjk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Boshi Yu <boshiyu@linux.alibaba.com>,
	Cheng Xu <chengyou@linux.alibaba.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0668/1376] RDMA/erdma: Add the erdma_query_pkey() interface
Date: Sat, 12 Sep 2026 08:51:34 +0200
Message-ID: <20260912065622.433696658@linuxfoundation.org>
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

[ Upstream commit 14bcf7354a0ed2004da85b4b03afe44effd5e445 ]

The erdma_query_pkey() interface queries the PKey at the specified
index. Currently, erdma supports only one partition and returns the
default PKey for each query. Besides, the correct length of the PKey
table can be obtained by calling the erdma_query_port() and
erdma_get_port_immutable() interfaces.

Signed-off-by: Boshi Yu <boshiyu@linux.alibaba.com>
Link: https://patch.msgid.link/20241211020930.68833-4-boshiyu@linux.alibaba.com
Reviewed-by: Cheng Xu <chengyou@linux.alibaba.com>
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Stable-dep-of: 652befcba956 ("RDMA/erdma: complete object teardown when the destroy command fails")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/erdma/erdma_hw.h    |  2 ++
 drivers/infiniband/hw/erdma/erdma_main.c  |  1 +
 drivers/infiniband/hw/erdma/erdma_verbs.c | 14 ++++++++++++++
 drivers/infiniband/hw/erdma/erdma_verbs.h |  1 +
 4 files changed, 18 insertions(+)

diff --git a/drivers/infiniband/hw/erdma/erdma_hw.h b/drivers/infiniband/hw/erdma/erdma_hw.h
index 7e03c5f97501a..f7f9dcac3ab01 100644
--- a/drivers/infiniband/hw/erdma/erdma_hw.h
+++ b/drivers/infiniband/hw/erdma/erdma_hw.h
@@ -23,6 +23,8 @@
 
 /* RoCEv2 related */
 #define ERDMA_ROCEV2_GID_SIZE 16
+#define ERDMA_MAX_PKEYS 1
+#define ERDMA_DEFAULT_PKEY 0xFFFF
 
 /* erdma device protocol type */
 enum erdma_proto_type {
diff --git a/drivers/infiniband/hw/erdma/erdma_main.c b/drivers/infiniband/hw/erdma/erdma_main.c
index 77440324b7e73..b9d0ad77436a7 100644
--- a/drivers/infiniband/hw/erdma/erdma_main.c
+++ b/drivers/infiniband/hw/erdma/erdma_main.c
@@ -481,6 +481,7 @@ static const struct ib_device_ops erdma_device_ops_rocev2 = {
 	.get_link_layer = erdma_get_link_layer,
 	.add_gid = erdma_add_gid,
 	.del_gid = erdma_del_gid,
+	.query_pkey = erdma_query_pkey,
 };
 
 static const struct ib_device_ops erdma_device_ops_iwarp = {
diff --git a/drivers/infiniband/hw/erdma/erdma_verbs.c b/drivers/infiniband/hw/erdma/erdma_verbs.c
index 2c22354071470..8de2d11317f7f 100644
--- a/drivers/infiniband/hw/erdma/erdma_verbs.c
+++ b/drivers/infiniband/hw/erdma/erdma_verbs.c
@@ -336,6 +336,9 @@ int erdma_query_device(struct ib_device *ibdev, struct ib_device_attr *attr,
 	attr->max_fast_reg_page_list_len = ERDMA_MAX_FRMR_PA;
 	attr->page_size_cap = ERDMA_PAGE_SIZE_SUPPORT;
 
+	if (erdma_device_rocev2(dev))
+		attr->max_pkeys = ERDMA_MAX_PKEYS;
+
 	if (dev->attrs.cap_flags & ERDMA_DEV_CAP_FLAGS_ATOMIC)
 		attr->atomic_cap = IB_ATOMIC_GLOB;
 
@@ -372,6 +375,7 @@ int erdma_query_port(struct ib_device *ibdev, u32 port,
 	} else {
 		attr->gid_tbl_len = dev->attrs.max_gid;
 		attr->ip_gids = true;
+		attr->pkey_tbl_len = ERDMA_MAX_PKEYS;
 	}
 
 	attr->port_cap_flags = IB_PORT_CM_SUP | IB_PORT_DEVICE_MGMT_SUP;
@@ -411,6 +415,7 @@ int erdma_get_port_immutable(struct ib_device *ibdev, u32 port,
 			RDMA_CORE_PORT_IBA_ROCE_UDP_ENCAP;
 		port_immutable->max_mad_size = IB_MGMT_MAD_SIZE;
 		port_immutable->gid_tbl_len = dev->attrs.max_gid;
+		port_immutable->pkey_tbl_len = ERDMA_MAX_PKEYS;
 	}
 
 	return 0;
@@ -1906,3 +1911,12 @@ int erdma_del_gid(const struct ib_gid_attr *attr, void **context)
 	return erdma_set_gid(to_edev(attr->device), ERDMA_SET_GID_OP_DEL,
 			     attr->index, NULL);
 }
+
+int erdma_query_pkey(struct ib_device *ibdev, u32 port, u16 index, u16 *pkey)
+{
+	if (index >= ERDMA_MAX_PKEYS)
+		return -EINVAL;
+
+	*pkey = ERDMA_DEFAULT_PKEY;
+	return 0;
+}
diff --git a/drivers/infiniband/hw/erdma/erdma_verbs.h b/drivers/infiniband/hw/erdma/erdma_verbs.h
index 23cfeaf79eaab..1ae6ba56f5972 100644
--- a/drivers/infiniband/hw/erdma/erdma_verbs.h
+++ b/drivers/infiniband/hw/erdma/erdma_verbs.h
@@ -394,5 +394,6 @@ enum rdma_link_layer erdma_get_link_layer(struct ib_device *ibdev,
 					  u32 port_num);
 int erdma_add_gid(const struct ib_gid_attr *attr, void **context);
 int erdma_del_gid(const struct ib_gid_attr *attr, void **context);
+int erdma_query_pkey(struct ib_device *ibdev, u32 port, u16 index, u16 *pkey);
 
 #endif
-- 
2.53.0



