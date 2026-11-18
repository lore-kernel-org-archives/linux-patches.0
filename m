Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795019453;
	b=ItaAKFaxzj/e18MjJIjcJHHb3CXnIDv0e3M2expk5gEPHTmzHWtmN4EdqWh4mi/pk8sC
	 f4TK1rGufF2QN3K5D9Krp9aXl6qps84Pznv3DRKIPX2TxaVW7EY+XQqszB8KkAYuZNva1
	 iiioI83A5HIwTfCIu2avlDVlx4yc2DEzHxAMRbj6hffwFdxh4GG0G4AhFnRLHJWFO8TLN
	 kFW/d+M+osqLnvrmiytRVRyXY/o/fkL1So9t90sfn/9m2Z2uqO3RogQaQ+lmiLr1pDQto
	 iL5c1O4tFT2U2hJHCSWFRwlOXE5+LqdQBcBjR7/f5M9X0V8L9ptDrRWc2pYbXaWEqAw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795019453;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=o9ObCrfzBrbNf3LTgyxYeDCm/N6TiFeBqjZHzftKPaE=;
	b=s4LSKsdPrzW1hM5iHNnz0dQndmX2on6LvEoWJorHH6zYtLqIp0YLgCYzeaLNMVwT3a2X
	 37fpd3UMkw+lisn0goYMN9eZEgFoLK5Ngzl2Lm7GSho+DlmY6YsQ6zwo73wjmuXwCq5qd
	 NkcDflh4R5yVYTbZYhfa5GlQLVKJs8/HMo9z3GQm+DoQgFEiipiEGOEII9pgGwYZ+h9w4
	 V+pXSbDgV+J8nnucICAy5i7YAN8ojLE4sSLly5BtpL+9BxX4eSF4E7nqmKTbrdL56KxWt
	 jSuE5l3sPOUdypleQ6ZvVYtFNRxcDWMDBu5hcLaFyJ6ft/7M0CGAI4DFo/6WSu4aL1w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=wcjRD6rC;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3614B606A7D2;
	Wed, 18 Nov 2026 16:30:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=wcjRD6rC
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8B28C1F000C4;
	Wed, 18 Nov 2026 16:30:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795019453;
	bh=o9ObCrfzBrbNf3LTgyxYeDCm/N6TiFeBqjZHzftKPaE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=wcjRD6rCz1btp9MGbDq2kTrSzajmuGWVFe+wCwXR48ay9KxMpBWpz7DxNp4W9lOIP
	 JA2IxM7L5bgz7tQJX8S4AiB4fc7SsDASokmZiTUrVtvZOcYkzLehYIoOaAoTY5n0TL
	 VueduS0ndFEohbWPl04WEdjDtOhHGuhtT4WzxCA8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jacob Moroni <jmoroni@google.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1600/2651] RDMA/core: Clear driver_udata before destroying objects in rdma_core
Date: Wed, 18 Nov 2026 15:47:20 +0100
Message-ID: <20261118150345.461972023@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jacob Moroni <jmoroni@google.com>

[ Upstream commit d37e98844afea39a9614cac0de837701263c90f7 ]

When uobject creation fails while copying user output data (i.e.,
after the HW object has been created), it calls
rdma_alloc_abort_uobject() with hw_obj_valid=true which then
invokes the object's destroy callback, but passes the
uverbs_attr_bundle from the original creation command.

The issue is that drivers are expected to validate the udata
and return an error if there's unexpected content, and data from
the wrong command counts as "unexpected content", so this ends
up causing the driver's destroy call to fail.

A similar issue exists in the rereg_mr path when a new MR
is created and the old one is destroyed.

Fix this by clearing driver_udata before invoking the driver's
destroy method.

Fixes: 6e0954b11c05 ("RDMA/uverbs: Allow drivers to create a new HW object during rereg_mr")
Fixes: 0ac8903cbbe6 ("RDMA/core: Allow the ioctl layer to abort a fully created uobject")
Signed-off-by: Jacob Moroni <jmoroni@google.com>
Link: https://patch.msgid.link/20261006152908.888059-1-jmoroni@google.com
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/core/ib_core_uverbs.c | 12 ------------
 drivers/infiniband/core/rdma_core.c      |  2 ++
 drivers/infiniband/core/rdma_core.h      | 17 +++++++++++------
 drivers/infiniband/core/verbs.c          |  3 +--
 4 files changed, 14 insertions(+), 20 deletions(-)

diff --git a/drivers/infiniband/core/ib_core_uverbs.c b/drivers/infiniband/core/ib_core_uverbs.c
index 2bdb6972fe1a6..74d9c006bad5a 100644
--- a/drivers/infiniband/core/ib_core_uverbs.c
+++ b/drivers/infiniband/core/ib_core_uverbs.c
@@ -527,18 +527,6 @@ int uverbs_destroy_def_handler(struct uverbs_attr_bundle *attrs)
 }
 EXPORT_SYMBOL(uverbs_destroy_def_handler);
 
-/*
- * When calling a destroy function during an error unwind we need to pass in
- * the udata that is sanitized of all user arguments. Ie from the driver
- * perspective it looks like no udata was passed.
- */
-struct ib_udata *uverbs_get_cleared_udata(struct uverbs_attr_bundle *attrs)
-{
-	attrs->driver_udata = (struct ib_udata){};
-	return &attrs->driver_udata;
-}
-EXPORT_SYMBOL_NS_GPL(uverbs_get_cleared_udata, "rdma_core");
-
 /**
  * _uverbs_alloc() - Quickly allocate memory for use with a bundle
  * @bundle: The bundle
diff --git a/drivers/infiniband/core/rdma_core.c b/drivers/infiniband/core/rdma_core.c
index a7cbe643e33c6..b32e5445601bb 100644
--- a/drivers/infiniband/core/rdma_core.c
+++ b/drivers/infiniband/core/rdma_core.c
@@ -734,6 +734,7 @@ void rdma_assign_uobject(struct ib_uobject *to_uobj, struct ib_uobject *new_uobj
 	 * If this fails then the uobject is still completely valid (though with
 	 * a new ID) and we leak it until context close.
 	 */
+	uverbs_get_cleared_udata(attrs);
 	uverbs_destroy_uobject(to_uobj, RDMA_REMOVE_DESTROY, attrs);
 }
 EXPORT_SYMBOL_NS_GPL(rdma_assign_uobject, "rdma_core");
@@ -750,6 +751,7 @@ void rdma_alloc_abort_uobject(struct ib_uobject *uobj,
 	int ret;
 
 	if (hw_obj_valid) {
+		uverbs_get_cleared_udata(attrs);
 		ret = uobj->uapi_object->type_class->destroy_hw(
 			uobj, RDMA_REMOVE_ABORT, attrs);
 		/*
diff --git a/drivers/infiniband/core/rdma_core.h b/drivers/infiniband/core/rdma_core.h
index 2b91e85272874..9de14e625dd3a 100644
--- a/drivers/infiniband/core/rdma_core.h
+++ b/drivers/infiniband/core/rdma_core.h
@@ -71,14 +71,19 @@ int uverbs_output_written(const struct uverbs_attr_bundle *bundle, size_t idx);
 
 void setup_ufile_idr_uobject(struct ib_uverbs_file *ufile);
 
-#if IS_ENABLED(CONFIG_INFINIBAND_USER_ACCESS)
-struct ib_udata *uverbs_get_cleared_udata(struct uverbs_attr_bundle *attrs);
-#else
-static inline struct ib_udata *uverbs_get_cleared_udata(struct uverbs_attr_bundle *attrs)
+/*
+ * When calling a destroy function during an error unwind we need to pass in
+ * the udata that is sanitized of all user arguments. Ie from the driver
+ * perspective it looks like no udata was passed.
+ */
+static inline struct ib_udata *
+uverbs_get_cleared_udata(struct uverbs_attr_bundle *attrs)
 {
-	return NULL;
+	if (!attrs)
+		return NULL;
+	attrs->driver_udata = (struct ib_udata){};
+	return &attrs->driver_udata;
 }
-#endif
 
 /*
  * This is the runtime description of the uverbs API, used by the syscall
diff --git a/drivers/infiniband/core/verbs.c b/drivers/infiniband/core/verbs.c
index c43e25d372667..308c7fdf486ef 100644
--- a/drivers/infiniband/core/verbs.c
+++ b/drivers/infiniband/core/verbs.c
@@ -1331,8 +1331,7 @@ static struct ib_qp *create_qp(struct ib_device *dev, struct ib_pd *pd,
 	return qp;
 
 err_security:
-	qp->device->ops.destroy_qp(
-		qp, uattrs ? uverbs_get_cleared_udata(uattrs) : NULL);
+	qp->device->ops.destroy_qp(qp, uverbs_get_cleared_udata(uattrs));
 err_create:
 	rdma_restrack_put(&qp->res);
 	xa_destroy(&qp->comp_cntrs);
-- 
2.53.0



