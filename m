Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795059605;
	b=lpvM4y6pGxsC7i4fgPYpvfUwqIgZWqgOvF7OhuKRsr0B0x7V6ViHz5q7h1Z+Cj7jYBDE
	 fRVv5EU4tcThKz7FN37hKCIsuSlw1Jh2LyKra1fH9XbH4UwqBLWXRPE8rjVEuYJPoiOjC
	 4xXIQeAXKisFhO9EBocp1AQbpfszinRgVIDsTS2cdhdHIkX907tDfnn9+xJPwspM2xp99
	 FHksmDkd4DNMaBY7CXW9zrokAAUyuj6PZ6nXCl+jU2MaO92vJqYawwhA8kpr/Vybxu8TC
	 C69SrBD0rheEIN9bb58o2MCWXxcJmiXnVRqGTVTueyb3oMjlCGFLYRzjIxCClUoWEOw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795059605;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=vAPAUxo3GXmvs+ccxvWtoKNu7KIK62sfVVNXlU8zs+Y=;
	b=jE+KO+d0eogi8wufP0Gy3uuEM2M8QaL/u9e6KM82Qxfi5VarQGHSwgO1ky8/GH1bz/ug
	 6OG3wCM6dxpcH3n3vZCrHKOh07MvyOmDDy1HE5Z2PeWQoUyCy+Y+s1crM1SvgcIro2/HQ
	 3Thjg1k5biNP0rc5zAULltSqxBCovRg96hH6qbr6UNz7saI4aCDtygMko38dnrvMtBrhM
	 dVzhIUdKIBoctYBqSAfR+Nqr7PlMMgXL2yUIQxES/ot9Trx4dp6KjCAk3BfRsooT2CWXW
	 +KZD4UG8nvjQJP0hN+UV25RjuthYWFfF9jjezP3xTaAreb3OM/IiQJcFRj1RqovQaTQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=c2A5JfMA;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C22B1606A33B;
	Thu, 19 Nov 2026 03:40:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=c2A5JfMA
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0E74A1F000C4;
	Thu, 19 Nov 2026 03:40:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795059605;
	bh=vAPAUxo3GXmvs+ccxvWtoKNu7KIK62sfVVNXlU8zs+Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=c2A5JfMAeRN7IREVtElXVJv6NOtIbWDJ243UbbOgByUCd7jemkNb3LU8FTE1Ec85e
	 2WvE1oywYFGoTC3JJ2Ctj4DnMqVwhB5ZYW3JXcv7d1yb+KCnlV4c2/UsRivqZcgbXr
	 EyTPxSOb4Muxd7tH8RQb1RDM9joS+uiZfscSBK44=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yuto Ohnuki <ytohnuki@amazon.com>,
	Stefan Hajnoczi <stefanha@redhat.com>,
	Miklos Szeredi <mszeredi@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 0902/1848] virtiofs: add FUSE protocol validation
Date: Wed, 18 Nov 2026 15:49:00 +0100
Message-ID: <20261118145954.524662257@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index d405cdf36247c..96e6ebb0a4ee2 100644
--- a/fs/fuse/virtio_fs.c
+++ b/fs/fuse/virtio_fs.c
@@ -556,6 +556,27 @@ static void copy_args_from_argbuf(struct fuse_args *args, struct fuse_req *req)
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
@@ -566,10 +587,6 @@ static void virtio_fs_request_complete(struct fuse_req *req,
 	unsigned int len, i, thislen;
 	struct page *page;
 
-	/*
-	 * TODO verify that server properly follows FUSE protocol
-	 * (oh.uniq, oh.len)
-	 */
 	args = req->args;
 	copy_args_from_argbuf(args, req);
 
@@ -625,6 +642,10 @@ static void virtio_fs_requests_done_work(struct work_struct *work)
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



