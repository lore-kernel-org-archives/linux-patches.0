Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E07845947ED;
	Wed,  9 Sep 2026 14:40:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788964831; cv=none; b=HfxgSo01Lnbt9LSbsde4W6SVjcMSGOSKSz/Pg5rfPsCwQKQKypiBHhmnW0bfcuf+LhWmqxCijVekD3dFnLgN98yCVVUdYMpLeF+It8OaL4WyvN+BSqlIBkvsrJwnTzmO2XkKS+sSYEgC6Zk4qMyLg9jsyReUt6eDqTbUczB6fYk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788964831; c=relaxed/simple;
	bh=ue6hqsurkuotiqpL4vNykiPkYPH38HNdGOYu9jGtkzk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XniA6x1PxCBIVnvREGDBgouNHRhsotHKEY5gnEjQpMKEAVJ5QKGfnJCpEoO5LzUQiiqMwxHwxLdnuxY3TG8eUD6Ifr6Eo7X8slKBtMApEN/TYH+jh37TyfPFiXCNS3cV5VgRzGgCYpD3VULv6taAL6ITEQkR4fzOsiGI71u1cFk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BXYhkGhV; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BXYhkGhV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 49E881F00A3A;
	Wed,  9 Sep 2026 14:40:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788964829;
	bh=HZ4CcS0Pm/TT8eUf4GvDyDNLU+odWagfVq5iHcaHGRc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=BXYhkGhVQH1ZmbvlIgVQ1mOP4bn6cKLYP446ydb9BVKBYsN9+koyXHrFYBOPsta4j
	 zy9KFBP5e1Qk0s9mrQ7qk/Vr6pyNQs2h/f6iN1EZgel+3HW/TqaBmmbgyZFnz+oJ1S
	 B2x0dVrumEBhqJxX4BB1v/aNxBZg1QjVo/pZS/DA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bernd Schubert <bernd@bsbernd.com>,
	Jeff Layton <jlayton@kernel.org>,
	Baokun Li <libaokun@linux.alibaba.com>,
	Joanne Koong <joannelkoong@gmail.com>,
	Miklos Szeredi <mszeredi@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 519/583] fuse-uring: use named constants for io-uring iovec indices
Date: Wed,  9 Sep 2026 15:43:24 +0200
Message-ID: <20260909134255.697978634@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260909134237.773280130@linuxfoundation.org>
References: <20260909134237.773280130@linuxfoundation.org>
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

From: Joanne Koong <joannelkoong@gmail.com>

[ Upstream commit 8bbb2ad1f687633a991839bd3efae04ccfb29e19 ]

Replace magic indices 0 and 1 for the iovec array with named constants
FUSE_URING_IOV_HEADERS and FUSE_URING_IOV_PAYLOAD. This makes the usages
self-documenting and prepares for buffer ring support which will also
reference these iovec slots by index.

Reviewed-by: Bernd Schubert <bernd@bsbernd.com>
Reviewed-by: Jeff Layton <jlayton@kernel.org>
Reviewed-by: Baokun Li <libaokun@linux.alibaba.com>
Signed-off-by: Joanne Koong <joannelkoong@gmail.com>
Signed-off-by: Miklos Szeredi <mszeredi@redhat.com>
Stable-dep-of: fd10f40af314 ("fuse: copy request headers via a stack buffer for io-uring")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/fuse/dev_uring.c |   24 +++++++++++++-----------
 1 file changed, 13 insertions(+), 11 deletions(-)

--- a/fs/fuse/dev_uring.c
+++ b/fs/fuse/dev_uring.c
@@ -18,7 +18,8 @@ MODULE_PARM_DESC(enable_uring,
 		 "Enable userspace communication through io-uring");
 
 #define FUSE_URING_IOV_SEGS 2 /* header and payload */
-
+#define FUSE_URING_IOV_HEADERS 0
+#define FUSE_URING_IOV_PAYLOAD 1
 
 bool fuse_uring_enabled(void)
 {
@@ -1105,8 +1106,8 @@ static int fuse_uring_do_register(struct
 }
 
 /*
- * sqe->addr is a ptr to an iovec array, iov[0] has the headers, iov[1]
- * the payload
+ * sqe->addr is a ptr to an iovec array, iov[FUSE_URING_IOV_HEADERS] has the
+ * headers, iov[FUSE_URING_IOV_PAYLOAD] the payload
  */
 static int fuse_uring_get_iovec_from_sqe(const struct io_uring_sqe *sqe,
 					 struct iovec iov[FUSE_URING_IOV_SEGS])
@@ -1136,8 +1137,8 @@ fuse_uring_create_ring_ent(struct io_uri
 {
 	struct fuse_ring *ring = queue->ring;
 	struct fuse_ring_ent *ent;
-	size_t payload_size;
 	struct iovec iov[FUSE_URING_IOV_SEGS];
+	struct iovec *headers, *payload;
 	int err;
 
 	err = fuse_uring_get_iovec_from_sqe(cmd->sqe, iov);
@@ -1148,15 +1149,16 @@ fuse_uring_create_ring_ent(struct io_uri
 	}
 
 	err = -EINVAL;
-	if (iov[0].iov_len < sizeof(struct fuse_uring_req_header)) {
-		pr_info_ratelimited("Invalid header len %zu\n", iov[0].iov_len);
+	headers = &iov[FUSE_URING_IOV_HEADERS];
+	if (headers->iov_len < sizeof(struct fuse_uring_req_header)) {
+		pr_info_ratelimited("Invalid header len %zu\n", headers->iov_len);
 		return ERR_PTR(err);
 	}
 
-	payload_size = iov[1].iov_len;
-	if (payload_size < ring->max_payload_sz) {
+	payload = &iov[FUSE_URING_IOV_PAYLOAD];
+	if (payload->iov_len < ring->max_payload_sz) {
 		pr_info_ratelimited("Invalid req payload len %zu\n",
-				    payload_size);
+				    payload->iov_len);
 		return ERR_PTR(err);
 	}
 
@@ -1168,8 +1170,8 @@ fuse_uring_create_ring_ent(struct io_uri
 	INIT_LIST_HEAD(&ent->list);
 
 	ent->queue = queue;
-	ent->headers = iov[0].iov_base;
-	ent->payload = iov[1].iov_base;
+	ent->headers = headers->iov_base;
+	ent->payload = payload->iov_base;
 
 	atomic_inc(&ring->queue_refs);
 	return ent;


