Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795053963;
	b=iQA1N7bok8NJrTF80gyxgMYvyrJ8FaaM8aMJhpcB1nLyY9Nn9/XA71r0GJcS74+mY+ob
	 uivveZTrxPBATV4DER6YYD59o2h4SHsez+6F6p1ekSYHmUl9j9H0A2wwfy0vV3CXlcbzm
	 5dbc2TUnli/ICpPN1Sd3ZkHeudRREN8EfPLQBP7IXmyQnwqD5pVc+hxzEA4CIGi5Vj2qe
	 2A3su7yKb6MOliBqrIVJ59Fb/KcjR+ExnZtoUghsK5m91OXH8PHsNbUsPwfD/raSnZMBE
	 12Ups59u4IMpZB/YTPCC/nqzDLc82/sdEvWtaudExnjtbS8wkyWh1Dccusa0i7TSAnw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795053963;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=3yzentFdZ90LSKxAZL9iNbhHgXdL1CX6B9m3Yfn03GU=;
	b=UQS2sYulz+jFr6E696+EAEj+XrbratZ+Mj/6HP/R285L7+zHRvvNVeouHZSt+UFI3pRb
	 WOzaDZjLraLVL20NNiWOmV3TdhES6Eq5ZySRqL2xGNLYF8Wmmk8Pm1rQgEe41E02NpDgn
	 DUFo+n+aZ1rHixQILfE1/I3MtOk4Ou6SaZ+kXpqtILyydAJCI3vlTe9qfRi1O80iTmkrm
	 6dSks6NBjlGx47fZeLAF0b1AF4ut1O7w6ZTXXD29vGwNsGes0qYY+Y6AXDF4u92WdlxgJ
	 cE6sYqcvs0CfKO3/OeCmrWZ6R/O1QUdS1vxakO/4mp1QlE5nXxzSoO3D5S5E5MQ2Ymg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=zAewNXhE;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 30651606A31C;
	Thu, 19 Nov 2026 02:06:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=zAewNXhE
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 77C6A1F000C4;
	Thu, 19 Nov 2026 02:06:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795053963;
	bh=3yzentFdZ90LSKxAZL9iNbhHgXdL1CX6B9m3Yfn03GU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=zAewNXhEzusmRNUjGKxKtVQSQEymRExB5kQGeniWf9cRQTN/X+OMwQVEozWASg100
	 q1eHj6t6N0rrsCQB8uF7Pn+n3EOfNAoZuav7XvIALmvYkA3+2ROGsabYAzstuuR8c/
	 VAVGcshebpMIpTHKxyyC9/pm7M1ntYYPrRh4Hi1I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yuto Ohnuki <ytohnuki@amazon.com>,
	Stefan Hajnoczi <stefanha@redhat.com>,
	Miklos Szeredi <mszeredi@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 1069/2214] virtiofs: add FUSE protocol validation
Date: Wed, 18 Nov 2026 15:45:45 +0100
Message-ID: <20261118150055.043485369@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yuto Ohnuki <ytohnuki@amazon.com>

[ Upstream commit 68b69fa0edb241a946cd4c850110990f30705164 ]

Add virtio_fs_verify_response() to validate that the server properly
follows the FUSE protocol by checking:

- Response length is at least sizeof(struct fuse_out_header).
- oh.len matches the actual response length.
- oh.unique matches the request's unique identifier.

On validation failure, set error to -EIO and normalize oh.len to prevent
underflow in copy_args_from_argbuf().

Addresses the TODO comment in virtio_fs_request_complete().

Signed-off-by: Yuto Ohnuki <ytohnuki@amazon.com>
Reviewed-by: Stefan Hajnoczi <stefanha@redhat.com>
Signed-off-by: Miklos Szeredi <mszeredi@redhat.com>
Stable-dep-of: 5364d081125a ("virtiofs: validate fixed-output response length")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/fuse/virtio_fs.c | 29 +++++++++++++++++++++++++----
 1 file changed, 25 insertions(+), 4 deletions(-)

diff --git a/fs/fuse/virtio_fs.c b/fs/fuse/virtio_fs.c
index ba8d5f5dbeb01..c375a5f001056 100644
--- a/fs/fuse/virtio_fs.c
+++ b/fs/fuse/virtio_fs.c
@@ -551,6 +551,27 @@ static void copy_args_from_argbuf(struct fuse_args *args, struct fuse_req *req)
 	req->argbuf = NULL;
 }
 
+/* Verify that the server properly follows the FUSE protocol */
+static bool virtio_fs_verify_response(struct fuse_req *req, unsigned int len)
+{
+	struct fuse_out_header *oh = &req->out.h;
+
+	if (len < sizeof(*oh)) {
+		pr_warn("virtio-fs: response too short (%u)\n", len);
+		return false;
+	}
+	if (oh->len != len) {
+		pr_warn("virtio-fs: oh.len mismatch (%u != %u)\n", oh->len, len);
+		return false;
+	}
+	if (oh->unique != req->in.h.unique) {
+		pr_warn("virtio-fs: oh.unique mismatch (%llu != %llu)\n",
+			oh->unique, req->in.h.unique);
+		return false;
+	}
+	return true;
+}
+
 /* Work function for request completion */
 static void virtio_fs_request_complete(struct fuse_req *req,
 				       struct virtio_fs_vq *fsvq)
@@ -561,10 +582,6 @@ static void virtio_fs_request_complete(struct fuse_req *req,
 	unsigned int len, i, thislen;
 	struct page *page;
 
-	/*
-	 * TODO verify that server properly follows FUSE protocol
-	 * (oh.uniq, oh.len)
-	 */
 	args = req->args;
 	copy_args_from_argbuf(args, req);
 
@@ -620,6 +637,10 @@ static void virtio_fs_requests_done_work(struct work_struct *work)
 		virtqueue_disable_cb(vq);
 
 		while ((req = virtqueue_get_buf(vq, &len)) != NULL) {
+			if (!virtio_fs_verify_response(req, len)) {
+				req->out.h.error = -EIO;
+				req->out.h.len = sizeof(struct fuse_out_header);
+			}
 			spin_lock(&fpq->lock);
 			list_move_tail(&req->list, &reqs);
 			spin_unlock(&fpq->lock);
-- 
2.53.0



