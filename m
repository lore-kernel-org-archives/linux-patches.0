Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795039626;
	b=ciBDVla5UpubOvvoNGTHSfePg4tjJ5pNNb+SWEEZZ2iM70XYYSjHgxEZajYRgAYnvfUi
	 FsG2lHflKuhmgXtgGMMnFIuXXuCN48lTfgHLwPVRPNub09EJmiWNEYdRWz8IQWPo/+eA9
	 5SYzAsLT2PtbUaj1NAap6qv8ZnYY96pDM1vk5z7UKQ3eW4FruGt4qv7yoT8z275Dt6xzP
	 XemHmekTQ6t4Dactr2nz9UqawfVpp2Ro6uuZDCmITf3GljgL9KpG2ikvD+7gwENkVqWlL
	 L0QDaudWXsJFBRmdvGAoSzyncReAGod/JPk8iSwdGlOr3TuqopqaN5I9YA3YDu3fZRQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795039626;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=5CrWsaE//F1lT+QyFDZKP11/kyrtx2Nf/xwnaSW7T9w=;
	b=c2x95XsNr/HCHJGEd4L/GDTyr+JI5Un6bsjB9yxbXms/6YLDaomayp8UJLX2nGPrY2bj
	 04o1GEEqLJF4Bvfcr390TsuJ3jKjuEEPTww9bQ/0Njpt1NMkvAFyS+0SrWhCLy39CUHEu
	 YKwT6FlNBk3cXN3SI2CQRfSWSTtlXuAy9IdvLZZNFYqlT2qS4iVGFrr6TNZ2T+9Akb3mF
	 JCZvOTC/NaDbtXb1WCDZr7MxPEeU3otvvNBkTtISEienl5VCh6OtOqfKP4ONoVL4Y3au/
	 9zYYtq0KA2yWopaTzxyVyDlac0gC2OCtr8ywiGHCIw7MJKzmMSIUnKhXo7ga0q9frLw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=CmYaUL+w;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D9C0C606A320;
	Wed, 18 Nov 2026 22:07:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=CmYaUL+w
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 388EA1F000C4;
	Wed, 18 Nov 2026 22:07:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795039626;
	bh=5CrWsaE//F1lT+QyFDZKP11/kyrtx2Nf/xwnaSW7T9w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=CmYaUL+wALhnejyIAlFZah16yEiSbCXZO8wEqx+GhqGu7XqeR0kHhFXZeTy6CkCEI
	 78wqdGpnzJUAa515KX4WdRsIeCXIBU7Uc0MLzw3mIwFhRehnS7MjxBhhyjqcom1hG5
	 mQGMmnCLWBrnwBZzILJ3aSGg1MKACWEGFFw2Yz90=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Junxian Huang <huangjunxian6@hisilicon.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 2141/3318] RDMA/hns: Fix GID capacity loss in 64K system
Date: Wed, 18 Nov 2026 15:46:03 +0100
Message-ID: <20261118150426.287975391@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index ef702fd9854b7..2b8afc6fbe87a 100644
--- a/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
+++ b/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
@@ -4049,18 +4049,39 @@ static int get_op_for_set_hem(struct hns_roce_dev *hr_dev, u32 type,
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



