Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9708235BDBA;
	Tue, 16 Dec 2025 12:30:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765888204; cv=none; b=SGZ4hg5NXJ1ML2b34fx2B+BSFSoqrUb+R+ooue1TMjY43N/XlDJI5Sl2LO54iBYs+tyWV5isa+H8euOGQ1Vqw3K+teFeTDO6AH947AICKAlyNnuodevdklxZzR6GpD5ey4H9T0/jhBRe6U+3vsSXaj8aRV6RdooWyjABbOsY7hs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765888204; c=relaxed/simple;
	bh=RfEo0Fnq4bWFzt+VFghsZ9ukPatCY38CE+sE4+UHxGw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FwYlK4ufTHCs/kFsTkSQrhIxai6JOk9M7s+kj+LXOOdxhGwc9Pj5qsJMFRZ1Wqsya+8086LHOqJ6PcDz9PxKTeb84OYOJxJdXuzarEobW2y2lRtXoSCPMG+vb0OEBd+O7lkTetD6V+GUPkUi2pmcmXXLYMswgrCPsIDAYpNfDEg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wPtuhc8R; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wPtuhc8R"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 00195C4CEF5;
	Tue, 16 Dec 2025 12:30:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765888204;
	bh=RfEo0Fnq4bWFzt+VFghsZ9ukPatCY38CE+sE4+UHxGw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wPtuhc8RBflaByQFtGFo5cLh6tGqJXVGhdL3ZI9VxjLWYyY6tCzG5GkpA1ppE5Jcl
	 FVf85SPRFGOliLV0YaipYqOxB7G2uJGqvs7Z8EZ4voDPZEh69IqhtRJrKmi/6EhcUj
	 xB7ebLcoI1ubbmVTQ2/q+Kde1cLmgRWFVFLbBH0U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jason Wang <jasowang@redhat.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 464/614] virtio: standardize Returns documentation style
Date: Tue, 16 Dec 2025 12:13:51 +0100
Message-ID: <20251216111418.181070398@linuxfoundation.org>
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

From: Michael S. Tsirkin <mst@redhat.com>

[ Upstream commit 5e88a5a97d113619b674ebfdd1d2065f2edd10eb ]

Remove colons after "Returns" in virtio_map_ops function
documentation - both to avoid triggering an htmldoc warning
and for consistency with virtio_config_ops.

This affects map_page, alloc, need_sync, and max_mapping_size.

Fixes: bee8c7c24b73 ("virtio: introduce map ops in virtio core")
Message-Id: <c262893fa21f4b1265147ef864574a9bd173348f.1763026134.git.mst@redhat.com>
Acked-by: Jason Wang <jasowang@redhat.com>
Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/virtio_config.h | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/include/linux/virtio_config.h b/include/linux/virtio_config.h
index 6660132258d40..e231147ff92db 100644
--- a/include/linux/virtio_config.h
+++ b/include/linux/virtio_config.h
@@ -150,7 +150,7 @@ struct virtio_config_ops {
  *      size: the buffer size
  *      dir: mapping direction
  *      attrs: mapping attributes
- *      Returns: the mapped address
+ *      Returns the mapped address
  * @unmap_page: unmap a buffer from the device
  *      map: device specific mapping map
  *      map_handle: the mapped address
@@ -172,7 +172,7 @@ struct virtio_config_ops {
  *      size: the size of the buffer
  *      map_handle: the mapping address to sync
  *      gfp: allocation flag (GFP_XXX)
- *      Returns: virtual address of the allocated buffer
+ *      Returns virtual address of the allocated buffer
  * @free: free a coherent buffer mapping
  *      map: metadata for performing mapping
  *      size: the size of the buffer
@@ -182,13 +182,13 @@ struct virtio_config_ops {
  * @need_sync: if the buffer needs synchronization
  *      map: metadata for performing mapping
  *      map_handle: the mapped address
- *      Returns: whether the buffer needs synchronization
+ *      Returns whether the buffer needs synchronization
  * @mapping_error: if the mapping address is error
  *      map: metadata for performing mapping
  *      map_handle: the mapped address
  * @max_mapping_size: get the maximum buffer size that can be mapped
  *      map: metadata for performing mapping
- *      Returns: the maximum buffer size that can be mapped
+ *      Returns the maximum buffer size that can be mapped
  */
 struct virtio_map_ops {
 	dma_addr_t (*map_page)(union virtio_map map, struct page *page,
-- 
2.51.0



