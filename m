Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB5294534A9;
	Thu, 30 Jul 2026 16:14:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785428063; cv=none; b=HlNUdAVo4WZ+Tm+ZA8ouNaPMce/M1I8EduwLMQkAPBflTlVFYX3Kv+uyZRy4Dsy+k2TtLgrP4OJHadbP0VoXEkD2WGHPA/EquZF6UFMEUUNk2n5DGoHYX1uAJUd6hPZPEUmJ/ayk9VHz3kTf4SihzLB2l4J2fANFb0w6YPrTBXE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785428063; c=relaxed/simple;
	bh=jqaoJfCFrOPkcRXr4cqHMArUTsouCdZXBeF0Tg53h8M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=VsHawfg0QkLVktwdJGsikrdoldjNufEsQqns8X4aY/0aeMstqJHL2tBY6mq8lthAWHPspJTFZ0LBYyLjncKLOMxNnm+oyeYYkzyCiw1gz5EhIwTQH3Onm2nnNOo31LIRuSffgAXpA87Vx5UKs9NyhGdyJ7pUlSS/83aTZxy+St8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=t+5nPtG5; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="t+5nPtG5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B4C471F00A3A;
	Thu, 30 Jul 2026 16:14:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785428062;
	bh=SAoRM/0grBgiYIo5VsqxN6ghdRmQ9jdQfnn9SqYVclQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=t+5nPtG5h/NoezmKHzwNjav1Eh1pQg+/cqM+HdUzsrxEq42qyVp8k5zebahg2ZFoq
	 DUOh8lYpW6g4E/R4ggHNXuaOGH7hsMZ7qgleGawsX1zYg+2LLdt+M2G22yLmriz99c
	 esqR+ppBVGToK3bhALfN7emDWshAY8qeZd4wNUhc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Eugenio=20P=C3=A9rez?= <eperezma@redhat.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 390/484] vduse: remove unused vaddr parameter of vduse_domain_free_coherent
Date: Thu, 30 Jul 2026 16:14:47 +0200
Message-ID: <20260730141431.946593964@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141423.392222816@linuxfoundation.org>
References: <20260730141423.392222816@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -514,8 +514,7 @@ err:
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
@@ -63,8 +63,7 @@ void *vduse_domain_alloc_coherent(struct
 				  gfp_t flag, unsigned long attrs);
 
 void vduse_domain_free_coherent(struct vduse_iova_domain *domain, size_t size,
-				void *vaddr, dma_addr_t dma_addr,
-				unsigned long attrs);
+				dma_addr_t dma_addr, unsigned long attrs);
 
 void vduse_domain_reset_bounce_map(struct vduse_iova_domain *domain);
 
--- a/drivers/vdpa/vdpa_user/vduse_dev.c
+++ b/drivers/vdpa/vdpa_user/vduse_dev.c
@@ -872,7 +872,7 @@ static void vduse_dev_free_coherent(stru
 	struct vduse_dev *vdev = dev_to_vduse(dev);
 	struct vduse_iova_domain *domain = vdev->domain;
 
-	vduse_domain_free_coherent(domain, size, vaddr, dma_addr, attrs);
+	vduse_domain_free_coherent(domain, size, dma_addr, attrs);
 }
 
 static size_t vduse_dev_max_mapping_size(struct device *dev)


