Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E7DD23859EE;
	Thu, 30 Jul 2026 16:16:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785428196; cv=none; b=XFCuX8Gn2kHlJ70Iwp022ZwDKUemsA11Reo4Nb0nBgJ4kloSzx06gnGef53fR5gOWwfycI1wchoKs6ft24vNjAepYO1Pe6+7R5T58iwXrX7nxFAp82m/50No+eWPuhSO/A0KBUo35B2nnx2O8mT8YHpF6BwrllE3wcpxwv2QBlU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785428196; c=relaxed/simple;
	bh=99rs1HLEDJwjIsH2w1acB0uWoAIPrz9RxJ36MgTjYTI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EpSxVGC0zDZdixkUnuGxpzfhGlFYT8xFUuwbHeBLwtusXf18cC4rLmOv99qRg6Tm75HlKk30xJH5qhD51pOQQ42Nb3KOqa/4iYP9YGUZtYzgsBSRZA6ORahCjRFUFONpUT9o+ddap2An4nHXOWbhm+Sgq8RxAfQvzPynuNju9G0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bs0L7e3K; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bs0L7e3K"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 139961F00A3A;
	Thu, 30 Jul 2026 16:16:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785428190;
	bh=VxIC2O5PI+ZaL14WiiKPVgZ/tvBb7Qse89JeZMa6MnY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bs0L7e3KwSuSoFpJC5WrYDHQo2g9B/YUtb+Pd8s+FWXKASKzFy6ZJ75BqW44AkuSG
	 sqBrrug9CnDekfDAH86tyYR95kPsyaKlzO4KiJEEo/DpBXoeXlQ/lbdd7Za0+xa74E
	 LVOHjmJo9899Euao0j6Qs4kZ6s/S04p2YIgbrViU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
	Mika Westerberg <mika.westerberg@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 435/484] thunderbolt: Remove usage of the deprecated ida_simple_xx() API
Date: Thu, 30 Jul 2026 16:15:32 +0200
Message-ID: <20260730141432.930648351@linuxfoundation.org>
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
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -321,7 +321,7 @@ static void tb_domain_release(struct dev
 
 	tb_ctl_free(tb->ctl);
 	destroy_workqueue(tb->wq);
-	ida_simple_remove(&tb_domain_ida, tb->index);
+	ida_free(&tb_domain_ida, tb->index);
 	mutex_destroy(&tb->lock);
 	kfree(tb);
 }
@@ -389,7 +389,7 @@ struct tb *tb_domain_alloc(struct tb_nhi
 	tb->nhi = nhi;
 	mutex_init(&tb->lock);
 
-	tb->index = ida_simple_get(&tb_domain_ida, 0, 0, GFP_KERNEL);
+	tb->index = ida_alloc(&tb_domain_ida, GFP_KERNEL);
 	if (tb->index < 0)
 		goto err_free;
 
@@ -413,7 +413,7 @@ struct tb *tb_domain_alloc(struct tb_nhi
 err_destroy_wq:
 	destroy_workqueue(tb->wq);
 err_remove_ida:
-	ida_simple_remove(&tb_domain_ida, tb->index);
+	ida_free(&tb_domain_ida, tb->index);
 err_free:
 	kfree(tb);
 
--- a/drivers/thunderbolt/nhi.c
+++ b/drivers/thunderbolt/nhi.c
@@ -465,7 +465,7 @@ static int ring_request_msix(struct tb_r
 	if (!nhi->pdev->msix_enabled)
 		return 0;
 
-	ret = ida_simple_get(&nhi->msix_ida, 0, MSIX_MAX_VECS, GFP_KERNEL);
+	ret = ida_alloc_max(&nhi->msix_ida, MSIX_MAX_VECS - 1, GFP_KERNEL);
 	if (ret < 0)
 		return ret;
 
@@ -485,7 +485,7 @@ static int ring_request_msix(struct tb_r
 	return 0;
 
 err_ida_remove:
-	ida_simple_remove(&nhi->msix_ida, ring->vector);
+	ida_free(&nhi->msix_ida, ring->vector);
 
 	return ret;
 }
@@ -496,7 +496,7 @@ static void ring_release_msix(struct tb_
 		return;
 
 	free_irq(ring->irq, ring);
-	ida_simple_remove(&ring->nhi->msix_ida, ring->vector);
+	ida_free(&ring->nhi->msix_ida, ring->vector);
 	ring->vector = 0;
 	ring->irq = 0;
 }
--- a/drivers/thunderbolt/nvm.c
+++ b/drivers/thunderbolt/nvm.c
@@ -330,7 +330,7 @@ struct tb_nvm *tb_nvm_alloc(struct devic
 	if (!nvm)
 		return ERR_PTR(-ENOMEM);
 
-	ret = ida_simple_get(&nvm_ida, 0, 0, GFP_KERNEL);
+	ret = ida_alloc(&nvm_ida, GFP_KERNEL);
 	if (ret < 0) {
 		kfree(nvm);
 		return ERR_PTR(ret);
@@ -528,7 +528,7 @@ void tb_nvm_free(struct tb_nvm *nvm)
 		nvmem_unregister(nvm->non_active);
 		nvmem_unregister(nvm->active);
 		vfree(nvm->buf);
-		ida_simple_remove(&nvm_ida, nvm->id);
+		ida_free(&nvm_ida, nvm->id);
 	}
 	kfree(nvm);
 }
--- a/drivers/thunderbolt/switch.c
+++ b/drivers/thunderbolt/switch.c
@@ -777,7 +777,7 @@ static int tb_port_alloc_hopid(struct tb
 	if (max_hopid < 0 || max_hopid > port_max_hopid)
 		max_hopid = port_max_hopid;
 
-	return ida_simple_get(ida, min_hopid, max_hopid + 1, GFP_KERNEL);
+	return ida_alloc_range(ida, min_hopid, max_hopid, GFP_KERNEL);
 }
 
 /**
@@ -815,7 +815,7 @@ int tb_port_alloc_out_hopid(struct tb_po
  */
 void tb_port_release_in_hopid(struct tb_port *port, int hopid)
 {
-	ida_simple_remove(&port->in_hopids, hopid);
+	ida_free(&port->in_hopids, hopid);
 }
 
 /**
@@ -825,7 +825,7 @@ void tb_port_release_in_hopid(struct tb_
  */
 void tb_port_release_out_hopid(struct tb_port *port, int hopid)
 {
-	ida_simple_remove(&port->out_hopids, hopid);
+	ida_free(&port->out_hopids, hopid);
 }
 
 static inline bool tb_switch_is_reachable(const struct tb_switch *parent,
--- a/drivers/thunderbolt/xdomain.c
+++ b/drivers/thunderbolt/xdomain.c
@@ -1005,7 +1005,7 @@ static void tb_service_release(struct de
 	struct tb_xdomain *xd = tb_service_parent(svc);
 
 	tb_service_debugfs_remove(svc);
-	ida_simple_remove(&xd->service_ids, svc->id);
+	ida_free(&xd->service_ids, svc->id);
 	kfree(svc->key);
 	kfree(svc);
 }
@@ -1107,7 +1107,7 @@ static void enumerate_services(struct tb
 			break;
 		}
 
-		id = ida_simple_get(&xd->service_ids, 0, 0, GFP_KERNEL);
+		id = ida_alloc(&xd->service_ids, GFP_KERNEL);
 		if (id < 0) {
 			kfree(svc->key);
 			kfree(svc);


