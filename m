Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 937D74418D7;
	Thu, 30 Jul 2026 15:24:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785425061; cv=none; b=iG2JVs0hv5SOvJBr4TFxpbOCx7wIsBgywlnWW3X8HnjxQRMg15fHXUVeSuSWwuhSIUyPAQADm1c0kGJVDq/oTBJpUpcch7KsNO+2UeFqAhg0YRZgGLdeSwolpOmv3CJw0c0+bS8OzkKzGhd09xu1iBk6nbqGAPm6yLmNofJYdME=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785425061; c=relaxed/simple;
	bh=GJldRAuoet4FRWc/8YWuirtyncIxLQiYVbVu8zoRf88=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=JelCfTc+6qYtZkS9TGC8dpE3MhnFwuhCCJh3Bn8jGuToFUB7PpDCC6vI58sFQsj5ZyiSvwXSRo7UsRuN5X0aarJPPbONeziVQxGTOBg6hkrO0uAKodlwSPhsQ7Bba6h3kRoXoI2QYfbdtocG58e6OyJsha6nYAPc73i1kDH1jMI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QerbZP8L; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QerbZP8L"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AE6D61F00A3A;
	Thu, 30 Jul 2026 15:24:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785425060;
	bh=AGqUiHgcjjp/tYbMRuS0z/c/CKTlk3P13sBDlP8Ooew=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=QerbZP8LwM6XK1zHHBXJEmkpYodEZF4rr7h4ncdEAdCqCCakKG+TCw9Cbd5Q3cyop
	 zecyw66HC74SWutKX1O/upPdd85I9gf4LUCCSbVKWryQHR5nYQpRrjAvfNvmxLh0Hc
	 BzVy6Qgue7FyvSvzkEIhDY1aZzow2D2oEm8wZGJs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Eugenio=20P=C3=A9rez?= <eperezma@redhat.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 613/675] vduse: remove unused vaddr parameter of vduse_domain_free_coherent
Date: Thu, 30 Jul 2026 16:15:43 +0200
Message-ID: <20260730141458.145754486@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141445.110192266@linuxfoundation.org>
References: <20260730141445.110192266@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eugenio Pérez <eperezma@redhat.com>

[ Upstream commit 766e1749c0ef6a09651be9b8a8283d508c322b58 ]

We will modify the function in next patches so let's clean it first.

Signed-off-by: Eugenio Pérez <eperezma@redhat.com>
Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Message-Id: <20260119143306.1818855-9-eperezma@redhat.com>
Stable-dep-of: 9c1523803445 ("VDUSE: avoid leaking information to userspace")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/vdpa/vdpa_user/iova_domain.c |    3 +--
 drivers/vdpa/vdpa_user/iova_domain.h |    3 +--
 drivers/vdpa/vdpa_user/vduse_dev.c   |    2 +-
 3 files changed, 3 insertions(+), 5 deletions(-)

--- a/drivers/vdpa/vdpa_user/iova_domain.c
+++ b/drivers/vdpa/vdpa_user/iova_domain.c
@@ -521,8 +521,7 @@ err:
 }
 
 void vduse_domain_free_coherent(struct vduse_iova_domain *domain, size_t size,
-				void *vaddr, dma_addr_t dma_addr,
-				unsigned long attrs)
+				dma_addr_t dma_addr, unsigned long attrs)
 {
 	struct iova_domain *iovad = &domain->consistent_iovad;
 	struct vhost_iotlb_map *map;
--- a/drivers/vdpa/vdpa_user/iova_domain.h
+++ b/drivers/vdpa/vdpa_user/iova_domain.h
@@ -71,8 +71,7 @@ dma_addr_t vduse_domain_alloc_coherent(s
 				       size_t size, void *orig);
 
 void vduse_domain_free_coherent(struct vduse_iova_domain *domain, size_t size,
-				void *vaddr, dma_addr_t dma_addr,
-				unsigned long attrs);
+				dma_addr_t dma_addr, unsigned long attrs);
 
 void vduse_domain_reset_bounce_map(struct vduse_iova_domain *domain);
 
--- a/drivers/vdpa/vdpa_user/vduse_dev.c
+++ b/drivers/vdpa/vdpa_user/vduse_dev.c
@@ -960,7 +960,7 @@ static void vduse_dev_free_coherent(unio
 	vdev = token.group->dev;
 	domain = vdev->domain;
 
-	vduse_domain_free_coherent(domain, size, vaddr, dma_addr, attrs);
+	vduse_domain_free_coherent(domain, size, dma_addr, attrs);
 }
 
 static bool vduse_dev_need_sync(union virtio_map token, dma_addr_t dma_addr)


