Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BBC52443A83;
	Thu, 30 Jul 2026 15:50:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785426639; cv=none; b=E8Z8xtqMG7t77xBLbSs5bpLNdt40AWTzO2MbWTiNbgXQuraxOBya43iiYRmSGp8sGjMztYzApfyNjO4QUcz/9nrTRZh8Yyer0uq2Ns+oEwrjXrv6PyA9WBnMGXkeBage7vfPrj1/dJo8/bo1gLdgywfjLwyWDGoVWSNII1RLTls=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785426639; c=relaxed/simple;
	bh=nsAtbCFTHwwjLCwVKTapJqqRnk52LOL5NgIV2LAZ9ig=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=YQ+Dqc//eM9npg62VxsNJjtmiTlaO9/naiWQWqpj2rug8jrE9Vlh2UIirvv1biCfrs/YCgRTnNwmf9S7PO833pdTuhswdCsY7wx1cWk48cegQGHQV9mqk6QI81Murh0OzFrzy4itxzW6vHX17l2c+NR9LCpYr0C6NQw74mDkqPM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nh1n1Vxm; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nh1n1Vxm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 237391F000E9;
	Thu, 30 Jul 2026 15:50:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785426638;
	bh=hz/8oZixLNrAVhQ+GKNGPiVOzBFS/2wsrmK7371znF4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=nh1n1VxmCeFqsTT4a3c+NbRhso0XoNhcnMgithEETwNIk9nkeUl3uPQA9EboLjXj0
	 jGiHqbVCHwJ73bzw1nWnG+n5Yl2euPb0nMidvH73R6hieWxyf+Hu6W2SvnIyqJ9H1o
	 Jx+C7dK9+QLIu35KTE1cuqdX3r5pxJZgJ3m+gOb4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Eugenio=20P=C3=A9rez?= <eperezma@redhat.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 490/602] vduse: remove unused vaddr parameter of vduse_domain_free_coherent
Date: Thu, 30 Jul 2026 16:14:42 +0200
Message-ID: <20260730141446.265312737@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141435.976815864@linuxfoundation.org>
References: <20260730141435.976815864@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
@@ -528,8 +528,7 @@ err:
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
@@ -72,8 +72,7 @@ void *vduse_domain_alloc_coherent(struct
 				  gfp_t flag, unsigned long attrs);
 
 void vduse_domain_free_coherent(struct vduse_iova_domain *domain, size_t size,
-				void *vaddr, dma_addr_t dma_addr,
-				unsigned long attrs);
+				dma_addr_t dma_addr, unsigned long attrs);
 
 void vduse_domain_reset_bounce_map(struct vduse_iova_domain *domain);
 
--- a/drivers/vdpa/vdpa_user/vduse_dev.c
+++ b/drivers/vdpa/vdpa_user/vduse_dev.c
@@ -904,7 +904,7 @@ static void vduse_dev_free_coherent(stru
 	struct vduse_dev *vdev = dev_to_vduse(dev);
 	struct vduse_iova_domain *domain = vdev->domain;
 
-	vduse_domain_free_coherent(domain, size, vaddr, dma_addr, attrs);
+	vduse_domain_free_coherent(domain, size, dma_addr, attrs);
 }
 
 static size_t vduse_dev_max_mapping_size(struct device *dev)


