Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E0EE638A70B;
	Thu, 20 Aug 2026 16:29:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787243376; cv=none; b=kHs/qucsDIRHbTNfdVbth+6ILrmCNPmf64lc0Kfry1LmS5FBGAKikQzfXvraqnOseJgEDgbfprLKWR09sJKXXUPUg2CsyfD3vvJeDpjDrIGkZ7w+TkNXO9PYL4nIPOoQULqur8EiOVeKcJ1hH9ai3y48i6h1b0UMW0+LgPuGmkQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787243376; c=relaxed/simple;
	bh=Bvhl/YDltDESw8hgwTF0dkt41c8XBwA+qj3OIhaxx1k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=rkfAYM74lJlPqqjzhShIEUkJZR1+4liWrBzzlzx5DvkLI/2lRFnztnf1xnr8s3PNrrbcc1aeTjexrE7YjhoSQ5vWwWNpoeAWZEIDLTqiXs9ifNb/ryRlWqXS1Pls69a9po8yfYlQu8hWMSFK+eXux70BbmOQ/a0WGAYTt2+kSyI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vLBXm1/B; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vLBXm1/B"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 46A431F000E9;
	Thu, 20 Aug 2026 16:29:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787243374;
	bh=6eLy8+wfSDaecudgxdhAHp/5HkAn6frGUWOWhQwecT0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=vLBXm1/BMAyaXfOYjgOJND39W9bLMmcZWKd80a+VEpJLCp31b4nY3L3MLvy+de9oz
	 At1nQ5YQ+CKW5OxV5W6P+piap0+OnSFS9ijUtW56VdWpAYToVNJJQdZX3QD3NbqkYw
	 TPLWWocvEadjvPMIcvWDkzR/LsnDVpx2oeunD/rU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Eugenio=20P=C3=A9rez?= <eperezma@redhat.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 071/272] vduse: remove unused vaddr parameter of vduse_domain_free_coherent
Date: Thu, 20 Aug 2026 16:54:15 +0200
Message-ID: <20260820145233.413087277@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260820145231.229664293@linuxfoundation.org>
References: <20260820145231.229664293@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
@@ -416,8 +416,7 @@ err:
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
@@ -61,8 +61,7 @@ void *vduse_domain_alloc_coherent(struct
 				  gfp_t flag, unsigned long attrs);
 
 void vduse_domain_free_coherent(struct vduse_iova_domain *domain, size_t size,
-				void *vaddr, dma_addr_t dma_addr,
-				unsigned long attrs);
+				dma_addr_t dma_addr, unsigned long attrs);
 
 void vduse_domain_reset_bounce_map(struct vduse_iova_domain *domain);
 
--- a/drivers/vdpa/vdpa_user/vduse_dev.c
+++ b/drivers/vdpa/vdpa_user/vduse_dev.c
@@ -816,7 +816,7 @@ static void vduse_dev_free_coherent(stru
 	struct vduse_dev *vdev = dev_to_vduse(dev);
 	struct vduse_iova_domain *domain = vdev->domain;
 
-	vduse_domain_free_coherent(domain, size, vaddr, dma_addr, attrs);
+	vduse_domain_free_coherent(domain, size, dma_addr, attrs);
 }
 
 static size_t vduse_dev_max_mapping_size(struct device *dev)


