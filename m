Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795023384;
	b=XlPI205mU9DcrAZ2g/sBzoLw/Z3qFc3Ajx71L6bG3BPJf1C7A07ej1N44iEkUM5cxVRw
	 N2zH/F2QF8X+7t0nfm+l/N35cVBAy5dTayWfx+ASMKz8Tjx/ABslz14M22pJbezCshuai
	 +WGx8NZsAlA28aZJ36x6L7F7FRJH2D9tPcgzunINJwHHlXSQQZkBH9HjZGQQXnQf+eEhM
	 aHHWHeuHkjP9IiaUXFKEq/lipel6UF2o9xL0ewaRlUo5Xov5shBOpOxp8j6kRv9cb9PbF
	 kEhAqezwE+0mseAWBs6JYVUCKstXr5w3KdTrPfWZD3zkXPJbZlXKbiBsnNzFQRS6DCA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795023384;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=OzTZGk/4OIcaKx83JNSQlh9qbM9wGoi0Vw/v65+ck4U=;
	b=mYW0PUE9JeycNHqLnE583dkXTu+putpFGMq5qF+/qESbTMJEtbShFn5KivnZcPq7gRD1
	 lEtKum7aD9cRQnz4xyGLW1wA/gv1YE0PIF9FZMKuUUSEEZW4kTdU6VXwJ5VYIaJdR56YW
	 OQPNMh+B1IL1lthRjjWmu22sqDBP+p/ul7V1EbCtzaRl8TVIxPOaXaLXqrIF8Xluf00zL
	 z+IK2qD0u97vNt/osyi/9ZBfJT7dV6HkRA0OwSA0BnJbqmh8m/Yss681FOdq2yNHfE7E/
	 m5YL6HCvX6FSnNEW4IL6nNhaA36YE+8Zj27+goADWfL08kVFYJNkEBewxGedc+/Ym0Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=nJFur2gb;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 890EC606CA50;
	Wed, 18 Nov 2026 17:36:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=nJFur2gb
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D9D161F000CA;
	Wed, 18 Nov 2026 17:36:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795023384;
	bh=OzTZGk/4OIcaKx83JNSQlh9qbM9wGoi0Vw/v65+ck4U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=nJFur2gbUNRdbcOR9VAtafXXnX9s7Cr4Ot8uXzSwlsXf8d7Lg/tIkDWlSP0pRQkFk
	 d6NwKpBxXS9AionEbWuWyYHGyhRlAlt+eNj1EYmz5wPM+jCTzWqZzimckmifHwYb30
	 3o91pFU9PJ9ccybcnrMovUkFKjLJ9ZGINwyxaYuQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Junxian Huang <huangjunxian6@hisilicon.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0351/2151] RDMA/hns: Fix GID capacity loss in 64K system
Date: Wed, 18 Nov 2026 15:34:46 +0100
Message-ID: <20261118150134.887521349@linuxfoundation.org>
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

From: Junxian Huang <huangjunxian6@hisilicon.com>

[ Upstream commit 95761b8736c938759032e8d4eb42074d39d13007 ]

Our HW always handles GMV BT pages with a fixed 4K size, but the driver
calculates the needed GMV BT pages number with PAGE_SIZE, which is 64K
in 64K system. Only the first 4K (GMV index 0-127) can be reached by HW,
causing GID capacity loss and memory waste.

Split a single 64K BT page into multiple 4K pages and register them to
HW per 4K block so that HW can correctly reach all GMV entries.

Fixes: 32053e584e4a ("RDMA/hns: Add support for filling GMV table")
Signed-off-by: Junxian Huang <huangjunxian6@hisilicon.com>
Link: https://patch.msgid.link/20260907084901.2420703-4-huangjunxian6@hisilicon.com
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/hns/hns_roce_hw_v2.c | 37 +++++++++++++++++-----
 1 file changed, 29 insertions(+), 8 deletions(-)

diff --git a/drivers/infiniband/hw/hns/hns_roce_hw_v2.c b/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
index 92a15be234068..fd7bebf79e5e8 100644
--- a/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
+++ b/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
@@ -4113,18 +4113,39 @@ static int get_op_for_set_hem(struct hns_roce_dev *hr_dev, u32 type,
 static int config_gmv_ba_to_hw(struct hns_roce_dev *hr_dev, unsigned long obj,
 			       dma_addr_t base_addr)
 {
+	u32 obj_num_per_bt = HNS_HW_PAGE_SIZE / hr_dev->caps.gmv_entry_sz;
+	u32 chunk_size = 1 << (hr_dev->caps.gmv_buf_pg_sz + PAGE_SHIFT);
+	u32 bt_num_per_chunk = chunk_size / HNS_HW_PAGE_SIZE;
+	u32 first = obj / obj_num_per_bt;
+	u32 last = min(first + bt_num_per_chunk, hr_dev->caps.gmv_bt_num);
 	struct hns_roce_cmq_desc desc;
-	struct hns_roce_cmq_req *req = (struct hns_roce_cmq_req *)desc.data;
-	u32 idx = obj / (HNS_HW_PAGE_SIZE / hr_dev->caps.gmv_entry_sz);
-	u64 addr = to_hr_hw_page_addr(base_addr);
+	struct hns_roce_cmq_req *req;
+	u64 addr;
+	int ret;
+	u32 i;
 
-	hns_roce_cmq_setup_basic_desc(&desc, HNS_ROCE_OPC_CFG_GMV_BT, false);
+	/* The GMV BT entry of hardware covers a fixed 4K region, so a buffer
+	 * chunk larger than 4K must be registered to hardware with one BT
+	 * entry per 4K block, otherwise the GMV entries beyond the first
+	 * 4K of the chunk are unreachable.
+	 */
+	for (i = first; i < last; i++) {
+		hns_roce_cmq_setup_basic_desc(&desc, HNS_ROCE_OPC_CFG_GMV_BT,
+					      false);
+		req = (struct hns_roce_cmq_req *)desc.data;
 
-	hr_reg_write(req, CFG_GMV_BT_BA_L, lower_32_bits(addr));
-	hr_reg_write(req, CFG_GMV_BT_BA_H, upper_32_bits(addr));
-	hr_reg_write(req, CFG_GMV_BT_IDX, idx);
+		addr = to_hr_hw_page_addr(base_addr +
+					  (u64)(i - first) * HNS_HW_PAGE_SIZE);
+		hr_reg_write(req, CFG_GMV_BT_BA_L, lower_32_bits(addr));
+		hr_reg_write(req, CFG_GMV_BT_BA_H, upper_32_bits(addr));
+		hr_reg_write(req, CFG_GMV_BT_IDX, i);
 
-	return hns_roce_cmq_send(hr_dev, &desc, 1);
+		ret = hns_roce_cmq_send(hr_dev, &desc, 1);
+		if (ret)
+			return ret;
+	}
+
+	return 0;
 }
 
 static int set_hem_to_hw(struct hns_roce_dev *hr_dev, int obj,
-- 
2.53.0



