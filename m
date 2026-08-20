Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4137C47DD73;
	Thu, 20 Aug 2026 17:46:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787248008; cv=none; b=rEaAFqMkDNBUqnWAsWLoQBHyqx9izqOHzBtCXHu0hZffzGOd65hF2K/HH3yrWuIBBEh6vpohGmt2oLhIlOqwh4/asRlH9Eu/EAKaN2eKAFkF3Q0PPf3YJk86898GqKJ+dx8484lzVBwe5RaL4qxOJz+SPAP8bieRgthBrqNh7Ls=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787248008; c=relaxed/simple;
	bh=/3kHcma9blV3D9SIGaOh5xwwwJDPJC3CZS7Cn8kg0ew=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=daM1WWTj8baFEdsvDDwpeUzZJVEj6xmI4ScVArHQkzD2neMx9snYsq0LFuoUqTbO0zWVw7iZWTIDeg46qau4x5gigo0PuJ1PsQbZgApkNJbRPAZPwpwY+J72fmvMzX0GGvWOKIzgAbJQRIkfePkn+4DNZz2WEJ7fZ3mr/FXI8ZI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nsUm/nYr; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nsUm/nYr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9D4B41F000E9;
	Thu, 20 Aug 2026 17:46:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787248007;
	bh=P9wEmeUzPBAZ1Rh0wD+FEcYsyiaxko8XWw5xdLb9fPg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=nsUm/nYraLtWHXUv87B4ne+3llt+fXuP7XHhgjUo62bxYVlO9zPyz6xAyrR8HmmWK
	 IrSn4C6QwIFU5CujcrAtMJcZlRnYAfRHPOj/ECQBfjDISRqygKvt8VUrBMfXqzJnT/
	 WK3NVDpsPPBD4Kvz+G6W70AnpZMv6UC8wFffridY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Eugenio=20P=C3=A9rez?= <eperezma@redhat.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 079/303] vduse: remove unused vaddr parameter of vduse_domain_free_coherent
Date: Thu, 20 Aug 2026 16:53:35 +0200
Message-ID: <20260820145255.536050324@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260820145253.200766705@linuxfoundation.org>
References: <20260820145253.200766705@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -64,8 +64,7 @@ void *vduse_domain_alloc_coherent(struct
 				  gfp_t flag, unsigned long attrs);
 
 void vduse_domain_free_coherent(struct vduse_iova_domain *domain, size_t size,
-				void *vaddr, dma_addr_t dma_addr,
-				unsigned long attrs);
+				dma_addr_t dma_addr, unsigned long attrs);
 
 void vduse_domain_reset_bounce_map(struct vduse_iova_domain *domain);
 
--- a/drivers/vdpa/vdpa_user/vduse_dev.c
+++ b/drivers/vdpa/vdpa_user/vduse_dev.c
@@ -836,7 +836,7 @@ static void vduse_dev_free_coherent(stru
 	struct vduse_dev *vdev = dev_to_vduse(dev);
 	struct vduse_iova_domain *domain = vdev->domain;
 
-	vduse_domain_free_coherent(domain, size, vaddr, dma_addr, attrs);
+	vduse_domain_free_coherent(domain, size, dma_addr, attrs);
 }
 
 static size_t vduse_dev_max_mapping_size(struct device *dev)


