Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B5A01A28C;
	Mon, 14 Oct 2024 14:36:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728916615; cv=none; b=MlbvG4bvaP9PBlpZQhlnOKbFfxjakgwrPfOTdrYINPUe0901/t2QtMCp3R60rFJRiRrOF4jyZk448SW3hjISW4tpgzXemJoKtky3jVwJcq/Bgh/NMTU5ny8q2C6WxecD+1gj7HNZ0w2YeUTYGVAc961L92sQInwk+3Goh2GzFkA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728916615; c=relaxed/simple;
	bh=xxj7SXo92QZNPCT4BRuuTpIZWZiDi87tOqRfsHSdzeE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Xsr7GaLsnz5HAmt8pZwYgHvCRX4BlVC2GUzbJgpKh+lxj5PZXT3hxlIllBnlEyne6mv0E3JWBTBa/0Uj0WDiy8/AJg+1roIlRSwJrhfRE9XrX93k/W9Y5SZHyw0jxniyIitvamyLVCPioujZPZ3xZXDw8rtQCVjlzT4k/LPf/LM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2COeo4cZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2COeo4cZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E8914C4CEC3;
	Mon, 14 Oct 2024 14:36:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728916615;
	bh=xxj7SXo92QZNPCT4BRuuTpIZWZiDi87tOqRfsHSdzeE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2COeo4cZ5F1Pw92cvbUbjj9ESIwE2bKonpxR21WsvaQ41w94xfIUXfMTrp72FROWU
	 /huRHHC3Am7ur9GYF8gjOD+Wpqjx5N6BD3gfOLd0JgbJwcGLhViMWTzCz7gxjpNTHF
	 +Vx74FfuJGkvXMHY8bRy9I+mNAZu9E2kjdMaFdyg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 017/213] bus: mhi: ep: Rename read_from_host() and write_to_host() APIs
Date: Mon, 14 Oct 2024 16:18:43 +0200
Message-ID: <20241014141043.658411036@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241014141042.954319779@linuxfoundation.org>
References: <20241014141042.954319779@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>

[ Upstream commit 927105244f8bc48e6841826a5644c6a961e03b5d ]

In the preparation for adding async API support, let's rename the existing
APIs to read_sync() and write_sync() to make it explicit that these APIs
are used for synchronous read/write.

Signed-off-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Stable-dep-of: c7d0b2db5bc5 ("bus: mhi: ep: Do not allocate memory for MHI objects from DMA zone")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/bus/mhi/ep/main.c                    | 4 ++--
 drivers/bus/mhi/ep/ring.c                    | 8 ++++----
 drivers/pci/endpoint/functions/pci-epf-mhi.c | 8 ++++----
 include/linux/mhi_ep.h                       | 8 ++++----
 4 files changed, 14 insertions(+), 14 deletions(-)

diff --git a/drivers/bus/mhi/ep/main.c b/drivers/bus/mhi/ep/main.c
index 934cdbca08e44..1ec9552d2b519 100644
--- a/drivers/bus/mhi/ep/main.c
+++ b/drivers/bus/mhi/ep/main.c
@@ -361,7 +361,7 @@ static int mhi_ep_read_channel(struct mhi_ep_cntrl *mhi_cntrl,
 		buf_info.size = tr_len;
 
 		dev_dbg(dev, "Reading %zd bytes from channel (%u)\n", tr_len, ring->ch_id);
-		ret = mhi_cntrl->read_from_host(mhi_cntrl, &buf_info);
+		ret = mhi_cntrl->read_sync(mhi_cntrl, &buf_info);
 		if (ret < 0) {
 			dev_err(&mhi_chan->mhi_dev->dev, "Error reading from channel\n");
 			return ret;
@@ -523,7 +523,7 @@ int mhi_ep_queue_skb(struct mhi_ep_device *mhi_dev, struct sk_buff *skb)
 		buf_info.size = tr_len;
 
 		dev_dbg(dev, "Writing %zd bytes to channel (%u)\n", tr_len, ring->ch_id);
-		ret = mhi_cntrl->write_to_host(mhi_cntrl, &buf_info);
+		ret = mhi_cntrl->write_sync(mhi_cntrl, &buf_info);
 		if (ret < 0) {
 			dev_err(dev, "Error writing to the channel\n");
 			goto err_exit;
diff --git a/drivers/bus/mhi/ep/ring.c b/drivers/bus/mhi/ep/ring.c
index c673d7200b3e1..ba9f696d1aa80 100644
--- a/drivers/bus/mhi/ep/ring.c
+++ b/drivers/bus/mhi/ep/ring.c
@@ -48,7 +48,7 @@ static int __mhi_ep_cache_ring(struct mhi_ep_ring *ring, size_t end)
 		buf_info.host_addr = ring->rbase + (start * sizeof(struct mhi_ring_element));
 		buf_info.dev_addr = &ring->ring_cache[start];
 
-		ret = mhi_cntrl->read_from_host(mhi_cntrl, &buf_info);
+		ret = mhi_cntrl->read_sync(mhi_cntrl, &buf_info);
 		if (ret < 0)
 			return ret;
 	} else {
@@ -56,7 +56,7 @@ static int __mhi_ep_cache_ring(struct mhi_ep_ring *ring, size_t end)
 		buf_info.host_addr = ring->rbase + (start * sizeof(struct mhi_ring_element));
 		buf_info.dev_addr = &ring->ring_cache[start];
 
-		ret = mhi_cntrl->read_from_host(mhi_cntrl, &buf_info);
+		ret = mhi_cntrl->read_sync(mhi_cntrl, &buf_info);
 		if (ret < 0)
 			return ret;
 
@@ -65,7 +65,7 @@ static int __mhi_ep_cache_ring(struct mhi_ep_ring *ring, size_t end)
 			buf_info.dev_addr = &ring->ring_cache[0];
 			buf_info.size = end * sizeof(struct mhi_ring_element);
 
-			ret = mhi_cntrl->read_from_host(mhi_cntrl, &buf_info);
+			ret = mhi_cntrl->read_sync(mhi_cntrl, &buf_info);
 			if (ret < 0)
 				return ret;
 		}
@@ -143,7 +143,7 @@ int mhi_ep_ring_add_element(struct mhi_ep_ring *ring, struct mhi_ring_element *e
 	buf_info.dev_addr = el;
 	buf_info.size = sizeof(*el);
 
-	return mhi_cntrl->write_to_host(mhi_cntrl, &buf_info);
+	return mhi_cntrl->write_sync(mhi_cntrl, &buf_info);
 }
 
 void mhi_ep_ring_init(struct mhi_ep_ring *ring, enum mhi_ep_ring_type type, u32 id)
diff --git a/drivers/pci/endpoint/functions/pci-epf-mhi.c b/drivers/pci/endpoint/functions/pci-epf-mhi.c
index 6dc918a8a0235..34e7191f95086 100644
--- a/drivers/pci/endpoint/functions/pci-epf-mhi.c
+++ b/drivers/pci/endpoint/functions/pci-epf-mhi.c
@@ -536,11 +536,11 @@ static int pci_epf_mhi_link_up(struct pci_epf *epf)
 	mhi_cntrl->alloc_map = pci_epf_mhi_alloc_map;
 	mhi_cntrl->unmap_free = pci_epf_mhi_unmap_free;
 	if (info->flags & MHI_EPF_USE_DMA) {
-		mhi_cntrl->read_from_host = pci_epf_mhi_edma_read;
-		mhi_cntrl->write_to_host = pci_epf_mhi_edma_write;
+		mhi_cntrl->read_sync = pci_epf_mhi_edma_read;
+		mhi_cntrl->write_sync = pci_epf_mhi_edma_write;
 	} else {
-		mhi_cntrl->read_from_host = pci_epf_mhi_iatu_read;
-		mhi_cntrl->write_to_host = pci_epf_mhi_iatu_write;
+		mhi_cntrl->read_sync = pci_epf_mhi_iatu_read;
+		mhi_cntrl->write_sync = pci_epf_mhi_iatu_write;
 	}
 
 	/* Register the MHI EP controller */
diff --git a/include/linux/mhi_ep.h b/include/linux/mhi_ep.h
index 96f3a133540db..b96b543bf2f65 100644
--- a/include/linux/mhi_ep.h
+++ b/include/linux/mhi_ep.h
@@ -94,8 +94,8 @@ struct mhi_ep_buf_info {
  * @raise_irq: CB function for raising IRQ to the host
  * @alloc_map: CB function for allocating memory in endpoint for storing host context and mapping it
  * @unmap_free: CB function to unmap and free the allocated memory in endpoint for storing host context
- * @read_from_host: CB function for reading from host memory from endpoint
- * @write_to_host: CB function for writing to host memory from endpoint
+ * @read_sync: CB function for reading from host memory synchronously
+ * @write_sync: CB function for writing to host memory synchronously
  * @mhi_state: MHI Endpoint state
  * @max_chan: Maximum channels supported by the endpoint controller
  * @mru: MRU (Maximum Receive Unit) value of the endpoint controller
@@ -149,8 +149,8 @@ struct mhi_ep_cntrl {
 			 void __iomem **virt, size_t size);
 	void (*unmap_free)(struct mhi_ep_cntrl *mhi_cntrl, u64 pci_addr, phys_addr_t phys,
 			   void __iomem *virt, size_t size);
-	int (*read_from_host)(struct mhi_ep_cntrl *mhi_cntrl, struct mhi_ep_buf_info *buf_info);
-	int (*write_to_host)(struct mhi_ep_cntrl *mhi_cntrl, struct mhi_ep_buf_info *buf_info);
+	int (*read_sync)(struct mhi_ep_cntrl *mhi_cntrl, struct mhi_ep_buf_info *buf_info);
+	int (*write_sync)(struct mhi_ep_cntrl *mhi_cntrl, struct mhi_ep_buf_info *buf_info);
 
 	enum mhi_state mhi_state;
 
-- 
2.43.0



