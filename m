Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C7037387B16;
	Tue, 16 Dec 2025 12:31:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765888298; cv=none; b=YhzZxxkx3aaLOwlp+lRUZSfwU/p2pnO//Bmid1yTSsBAlTXTsX+36tu0bdf6hGa0Ze8tvJzB1496uS9aDad1Yza+S0UlxVnkOcnSG+L7nXD6c+KSns5wbZ5G1C79L3ZtGD32xGzAwc5ex2KOqvd3vbwFhLH5+5+XCOi/zhXuQN8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765888298; c=relaxed/simple;
	bh=GEhiyKGoqqWlRIoI+pCJ45291Ge7Z9l+ploTEfhZTfc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=E++ESMnao/WpqC+oR6s+LyLhg2p6/A1oyf/BNRJqtBrHjk7FnG95K20A/kkuxdYGOJD6NfHumCmuo3oQroCKopWe+/ipphDlpGsXjBkxO0C8OZ2x9XqAa225vyma3nQSZ0yUf8WbhuhliLNo9cMROaU7i72/WKqGX8K0NYXE/54=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YIopsrVI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YIopsrVI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D8E9EC4CEF1;
	Tue, 16 Dec 2025 12:31:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765888298;
	bh=GEhiyKGoqqWlRIoI+pCJ45291Ge7Z9l+ploTEfhZTfc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YIopsrVIO7p0+utry7Mls94yElNpps0n1T+2Sh8lRfMBQp0bZ8ZQO1osU0jmwjOPH
	 mYChgNQx7rfr1GhmqAddH2QwD9DePW0b4xqlM6mjduK9WiRyEw08znscxuK9D+nmf1
	 hHV63kqVOOdvrws6VlV5JLGGJYtWqYl02UtwKdnc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kriish Sharma <kriish.sharma2006@gmail.com>,
	Chaitanya Kulkarni <kch@nvidia.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 459/614] virtio: fix kernel-doc for mapping/free_coherent functions
Date: Tue, 16 Dec 2025 12:13:46 +0100
Message-ID: <20251216111418.000376505@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251216111401.280873349@linuxfoundation.org>
References: <20251216111401.280873349@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kriish Sharma <kriish.sharma2006@gmail.com>

[ Upstream commit f8113000855a8cc2c6d8e19b97a390f1c082285d ]

Documentation build reported:

  WARNING: ./drivers/virtio/virtio_ring.c:3174 function parameter 'vaddr' not described in 'virtqueue_map_free_coherent'
  WARNING: ./drivers/virtio/virtio_ring.c:3308 expecting prototype for virtqueue_mapping_error(). Prototype was for virtqueue_map_mapping_error() instead

The kernel-doc block for virtqueue_map_free_coherent() omitted the @vaddr parameter, and
the kernel-doc header for virtqueue_map_mapping_error() used the wrong function name
(virtqueue_mapping_error) instead of the actual function name.

This change updates:

  - the function name in the comment to virtqueue_map_mapping_error()
  - adds the missing @vaddr description in the comment for virtqueue_map_free_coherent()

Fixes: b41cb3bcf67f ("virtio: rename dma helpers")
Signed-off-by: Kriish Sharma <kriish.sharma2006@gmail.com>
Reviewed-by: Chaitanya Kulkarni <kch@nvidia.com>
Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Message-Id: <20251110202920.2250244-1-kriish.sharma2006@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/virtio/virtio_ring.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/virtio/virtio_ring.c b/drivers/virtio/virtio_ring.c
index 7b6205253b46b..ddab689596717 100644
--- a/drivers/virtio/virtio_ring.c
+++ b/drivers/virtio/virtio_ring.c
@@ -3166,6 +3166,7 @@ EXPORT_SYMBOL_GPL(virtqueue_map_alloc_coherent);
  * @vdev: the virtio device we are talking to
  * @map: metadata for performing mapping
  * @size: the size of the buffer
+ * @vaddr: the virtual address that needs to be freed
  * @map_handle: the mapped address that needs to be freed
  *
  */
@@ -3190,7 +3191,7 @@ EXPORT_SYMBOL_GPL(virtqueue_map_free_coherent);
  * @dir: mapping direction
  * @attrs: mapping attributes
  *
- * Returns mapped address. Caller should check that by virtqueue_mapping_error().
+ * Returns mapped address. Caller should check that by virtqueue_map_mapping_error().
  */
 dma_addr_t virtqueue_map_page_attrs(const struct virtqueue *_vq,
 				    struct page *page,
@@ -3249,7 +3250,7 @@ EXPORT_SYMBOL_GPL(virtqueue_unmap_page_attrs);
  * The caller calls this to do dma mapping in advance. The DMA address can be
  * passed to this _vq when it is in pre-mapped mode.
  *
- * return mapped address. Caller should check that by virtqueue_mapping_error().
+ * return mapped address. Caller should check that by virtqueue_map_mapping_error().
  */
 dma_addr_t virtqueue_map_single_attrs(const struct virtqueue *_vq, void *ptr,
 				      size_t size,
@@ -3299,7 +3300,7 @@ void virtqueue_unmap_single_attrs(const struct virtqueue *_vq,
 EXPORT_SYMBOL_GPL(virtqueue_unmap_single_attrs);
 
 /**
- * virtqueue_mapping_error - check dma address
+ * virtqueue_map_mapping_error - check dma address
  * @_vq: the struct virtqueue we're talking about.
  * @addr: DMA address
  *
-- 
2.51.0



