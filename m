Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795015944;
	b=GnttBN7UPv+9VCiWz/LdPI+EbYRviPreaHDgXPqfp4o2iD/S95psysbN45XcGaer/Pku
	 a8QC0hm0KNzUKhVOQKzsc7yblhiaZ1tJSPuSH2rvbqVZ8ShGWbEl+qS2VZa4mCX3c7aTW
	 pqxv2cEj/Biffjhn9kFRIyecODHmCBfQr/fAyq67/5yCD21WlAVoVwSOUe+3+lomJRaeF
	 Bwu++kat7lOu+TpO+S42LdDOtarlEbiJovoOLYYjtg/r0BLvFwnXF6SrzAWNIgpZb/UtK
	 xOd2FsGioaR/A/78fJ5bb1GM/VciJEvdWQlj4fLc76CUHELfPmFbOfoB0Qs6PxCd20w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795015944;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=4K+JE78XPbapK/5aVxdA840fFqfYiq9btGx53yrW0nY=;
	b=mg7F+DzAfeMrkOLo0fAWjylcjThKgW2wy3v6cYrIfitM0Ei5faRUw0Qpu/3gv3NC6sAr
	 Qoy+iPa2ifTj0Go9FKUu3Mj99cbK6+DsDTW5g2+wgKHqkwKTDT8W4wZwrOhHMl4HyFoz1
	 PTzDo5JivDMMW2d+Zi6aOzxB+EmT2fM3ltnHDhNfPJ1XwuR+C1pRTONbwaBG2QvP6HUm0
	 QqhotS1neN0CG7WkLpyIbqwWnBM+h819oQq6sW2hZi2rn9usLXNNuOIZF4kITgP4fHJTn
	 F8nHQyl2StVqHVbhZImJSpLmK7Oi3zgIG//SSflLUJCxoW5QgOtKI2OeaB8cJ3ZPNfQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=T03znDPa;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 321AC606A32C;
	Wed, 18 Nov 2026 15:32:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=T03znDPa
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 810511F000C4;
	Wed, 18 Nov 2026 15:32:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795015944;
	bh=4K+JE78XPbapK/5aVxdA840fFqfYiq9btGx53yrW0nY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=T03znDPaGPSCNfGmT5ahMFkdCxVqTqDFXpaxK2UuBqNIrXyMYEm+9JwfUBBqfQ6L+
	 URGtSppfd16cl+aa3OU+xpcOTNFDkjKaWhVrbEkReiqqQEwuKQ4vXv/4+crhWTyzNW
	 xyX0ZlmvaU0YXMoHO7fbMzy+2LRgjOqC/S2aZmy4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Junxian Huang <huangjunxian6@hisilicon.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0354/2651] RDMA/hns: Fix GID capacity loss in 64K system
Date: Wed, 18 Nov 2026 15:26:34 +0100
Message-ID: <20261118150300.584729264@linuxfoundation.org>
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
index 103cc26197692..7dd24f022a06d 100644
--- a/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
+++ b/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
@@ -4356,18 +4356,39 @@ static int get_op_for_set_hem(struct hns_roce_dev *hr_dev, u32 type,
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



