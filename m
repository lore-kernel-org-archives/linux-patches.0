Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 65E3A47AF75;
	Thu, 20 Aug 2026 16:32:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787243531; cv=none; b=QXyGWUYra5uuSzH++PaWxV2UKoIyAbxj3es5TO2RIwBdjiBFKAeylq4SgGzl+WkgIcyzPanC09H9784PFX1yajiGwDl84RC1lS6jNpMoZZ/iAVw7SbfH48Iqebf6ThF/fiIBqobgMnQfNiz0Fnmom4sNJoj0hLNgqT9VZT3PpUI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787243531; c=relaxed/simple;
	bh=YgHej+i9fNZv0nezVD8gtuGxdk/iJNUbvDPtjk57bFc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XIfN7N4WLZDBmZwPIbxccyE5+9z5JK8/BcFCArfhc1XhQgXSgp+XaZMimOyYcQqiMviPXtmmaN4ywXXPUdIbjkOaF+paNbTCoR3sGXAcLOjWC5j3G6/pATdCV+g7YajHN03uNPUxPOiC9rkvtQPrYony2YNPaVIvamhLM6hXn78=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eLuwx9MG; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eLuwx9MG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C1B781F000E9;
	Thu, 20 Aug 2026 16:32:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787243530;
	bh=uPRQazAq7RV1cNPFbIXJx75nktWgorJqnJBLSOXO5mM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=eLuwx9MGGIJaH6C6PZb3qTJ/4cOrEz8FsoMPzAsUQHViHOPbC5/KXMaA+z7gKlLfQ
	 KZJCpk7VYUhM+sEsPHJRxB4k2FiTa7TXc1b7RC9gdzeBwRKqpXyqtVmGqrsq6xahxH
	 n1dvm19De4b5iKRD43gdNwbHpy4zmUMmZJhT49ak=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
	Mika Westerberg <mika.westerberg@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 127/272] thunderbolt: Remove usage of the deprecated ida_simple_xx() API
Date: Thu, 20 Aug 2026 16:55:11 +0200
Message-ID: <20260820145235.071748206@linuxfoundation.org>
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
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>

[ Upstream commit dec6a613574cd3dea799170b7aaa8fd76e22f176 ]

ida_alloc() and ida_free() should be preferred to the deprecated
ida_simple_get() and ida_simple_remove().

Note that the upper limit of ida_simple_get() is exclusive, but the one of
ida_alloc_range()/ida_alloc_max() is inclusive. So a -1 has been added
when needed.

Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>
Stable-dep-of: 2c5d2d3c3f70 ("thunderbolt: Prevent XDomain delayed work use-after-free on disconnect")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/thunderbolt/domain.c  |    6 +++---
 drivers/thunderbolt/nhi.c     |    6 +++---
 drivers/thunderbolt/nvm.c     |    4 ++--
 drivers/thunderbolt/switch.c  |    6 +++---
 drivers/thunderbolt/xdomain.c |    4 ++--
 5 files changed, 13 insertions(+), 13 deletions(-)

--- a/drivers/thunderbolt/domain.c
+++ b/drivers/thunderbolt/domain.c
@@ -329,7 +329,7 @@ static void tb_domain_release(struct dev
 
 	tb_ctl_free(tb->ctl);
 	destroy_workqueue(tb->wq);
-	ida_simple_remove(&tb_domain_ida, tb->index);
+	ida_free(&tb_domain_ida, tb->index);
 	mutex_destroy(&tb->lock);
 	kfree(tb);
 }
@@ -397,7 +397,7 @@ struct tb *tb_domain_alloc(struct tb_nhi
 	tb->nhi = nhi;
 	mutex_init(&tb->lock);
 
-	tb->index = ida_simple_get(&tb_domain_ida, 0, 0, GFP_KERNEL);
+	tb->index = ida_alloc(&tb_domain_ida, GFP_KERNEL);
 	if (tb->index < 0)
 		goto err_free;
 
@@ -421,7 +421,7 @@ struct tb *tb_domain_alloc(struct tb_nhi
 err_destroy_wq:
 	destroy_workqueue(tb->wq);
 err_remove_ida:
-	ida_simple_remove(&tb_domain_ida, tb->index);
+	ida_free(&tb_domain_ida, tb->index);
 err_free:
 	kfree(tb);
 
--- a/drivers/thunderbolt/nhi.c
+++ b/drivers/thunderbolt/nhi.c
@@ -458,7 +458,7 @@ static int ring_request_msix(struct tb_r
 	if (!nhi->pdev->msix_enabled)
 		return 0;
 
-	ret = ida_simple_get(&nhi->msix_ida, 0, MSIX_MAX_VECS, GFP_KERNEL);
+	ret = ida_alloc_max(&nhi->msix_ida, MSIX_MAX_VECS - 1, GFP_KERNEL);
 	if (ret < 0)
 		return ret;
 
@@ -478,7 +478,7 @@ static int ring_request_msix(struct tb_r
 	return 0;
 
 err_ida_remove:
-	ida_simple_remove(&nhi->msix_ida, ring->vector);
+	ida_free(&nhi->msix_ida, ring->vector);
 
 	return ret;
 }
@@ -489,7 +489,7 @@ static void ring_release_msix(struct tb_
 		return;
 
 	free_irq(ring->irq, ring);
-	ida_simple_remove(&ring->nhi->msix_ida, ring->vector);
+	ida_free(&ring->nhi->msix_ida, ring->vector);
 	ring->vector = 0;
 	ring->irq = 0;
 }
--- a/drivers/thunderbolt/nvm.c
+++ b/drivers/thunderbolt/nvm.c
@@ -30,7 +30,7 @@ struct tb_nvm *tb_nvm_alloc(struct devic
 	if (!nvm)
 		return ERR_PTR(-ENOMEM);
 
-	ret = ida_simple_get(&nvm_ida, 0, 0, GFP_KERNEL);
+	ret = ida_alloc(&nvm_ida, GFP_KERNEL);
 	if (ret < 0) {
 		kfree(nvm);
 		return ERR_PTR(ret);
@@ -159,7 +159,7 @@ void tb_nvm_free(struct tb_nvm *nvm)
 		if (nvm->active)
 			nvmem_unregister(nvm->active);
 		vfree(nvm->buf);
-		ida_simple_remove(&nvm_ida, nvm->id);
+		ida_free(&nvm_ida, nvm->id);
 	}
 	kfree(nvm);
 }
--- a/drivers/thunderbolt/switch.c
+++ b/drivers/thunderbolt/switch.c
@@ -806,7 +806,7 @@ static int tb_port_alloc_hopid(struct tb
 	if (max_hopid < 0 || max_hopid > port_max_hopid)
 		max_hopid = port_max_hopid;
 
-	return ida_simple_get(ida, min_hopid, max_hopid + 1, GFP_KERNEL);
+	return ida_alloc_range(ida, min_hopid, max_hopid, GFP_KERNEL);
 }
 
 /**
@@ -844,7 +844,7 @@ int tb_port_alloc_out_hopid(struct tb_po
  */
 void tb_port_release_in_hopid(struct tb_port *port, int hopid)
 {
-	ida_simple_remove(&port->in_hopids, hopid);
+	ida_free(&port->in_hopids, hopid);
 }
 
 /**
@@ -854,7 +854,7 @@ void tb_port_release_in_hopid(struct tb_
  */
 void tb_port_release_out_hopid(struct tb_port *port, int hopid)
 {
-	ida_simple_remove(&port->out_hopids, hopid);
+	ida_free(&port->out_hopids, hopid);
 }
 
 static inline bool tb_switch_is_reachable(const struct tb_switch *parent,
--- a/drivers/thunderbolt/xdomain.c
+++ b/drivers/thunderbolt/xdomain.c
@@ -808,7 +808,7 @@ static void tb_service_release(struct de
 	struct tb_xdomain *xd = tb_service_parent(svc);
 
 	tb_service_debugfs_remove(svc);
-	ida_simple_remove(&xd->service_ids, svc->id);
+	ida_free(&xd->service_ids, svc->id);
 	kfree(svc->key);
 	kfree(svc);
 }
@@ -910,7 +910,7 @@ static void enumerate_services(struct tb
 			break;
 		}
 
-		id = ida_simple_get(&xd->service_ids, 0, 0, GFP_KERNEL);
+		id = ida_alloc(&xd->service_ids, GFP_KERNEL);
 		if (id < 0) {
 			kfree(svc->key);
 			kfree(svc);


