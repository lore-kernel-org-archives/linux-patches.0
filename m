Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795048079;
	b=C74l6bI7iNsgZpTuoUlSlXQxtmoTWZ4CKyGCd0/NZkvZY8Z4iEu5HI9EK4kgAYUvSN/B
	 GAEOjCmGaLltOHPHNhMkZsDM+6Ofng9YhpUwrseGGZBV/PhZu5qXMo8qbq5sAuF8SN8Dd
	 Ezm1tuoKUy59+gmRA4AfrXgr3Tkc8pASQKbbd/ywvrRU+ySX9nQXRGJa/kFwB5YXsylzP
	 wz5zTq4CvSxWEgTHfAzXcQgCTTAu8RgSCDU5pUafGcRu8v3HM6KvBIqZ57Y7jyIlRetOy
	 AEQmmC740d1a0NwMkTMWIG6mrGRz84VhbjKK0G02F0JCrFDjFSJRMxtOBrjFjMuB8WA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795048079;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=F2JxEIxfxFyki8DwQkzY/LyNG/hxzVp3ThvRj3L5OZA=;
	b=S43yHCpZzjEoAYe1BBPoZfS3yu2/ymsVrmFEKuBbd7HQAF2bLI8znccGpdp1hQwwpeMM
	 fNy7f/4mRJVQxsK7Mm7K3v7IKSsKWKKizI3XNsZKBnSdZ4uGttZeXuidz+4a18cmjxvAS
	 cFJ54L6u/XHQ/KPQQ/3kFQJruz1U2k/vp5+7LXczQTExS69X/RKxsECHLzTl5MsEdCodc
	 wJlfadCkkCYu6VyRyK6hlZf1OwNq/D2S/TXNbbMgJNscNY4omNG+4IOnEsf334JbXdA9C
	 2ZvoxauzQXvcHZ6cvzyRtUEczfJW/kdfFlGy5mydAYrD8DkwTLe3v0nflaERyPveGVw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=QMk9UreQ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F01E606A31C;
	Thu, 19 Nov 2026 00:27:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=QMk9UreQ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9F5AB1F000C4;
	Thu, 19 Nov 2026 00:27:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795048079;
	bh=F2JxEIxfxFyki8DwQkzY/LyNG/hxzVp3ThvRj3L5OZA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=QMk9UreQLRfQeTeAgM0Yo2VUGzRvdbJHnUXvO3a/ncRGe3WRS/RiaNc0P92phtr15
	 hDV36yxkFG05vhzJxFkQB3jZd3I+reaP45ZnGdvSN5IAYymd96ug+to6ddYe7aKFPo
	 XO/pUvIHU3xe1KQ8hwB4+MrZZMCt3g/CmUBKOr+8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Junxian Huang <huangjunxian6@hisilicon.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1868/2857] RDMA/hns: Fix GID capacity loss in 64K system
Date: Wed, 18 Nov 2026 15:48:22 +0100
Message-ID: <20261118150308.494409179@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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
index 538b3261614a1..f57212698a70f 100644
--- a/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
+++ b/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
@@ -4209,18 +4209,39 @@ static int get_op_for_set_hem(struct hns_roce_dev *hr_dev, u32 type,
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



