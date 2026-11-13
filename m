Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794590674;
	b=j/VcN0z4abDGd56iRjpIABIcqHEnv3HGQgmp58dxp8xyRyZNm+Iz7k2oACvBUf/9neAC
	 7tXZEBDK8lQMDwgeDJYG8fcZX4u/mxx8zUuKidtxft82LfMoW8cqPpi9kAQYxl8QAtvGU
	 B3XRLCFkPLa1oeqsudSF4sut8s7fvJhFgDeFHLhmkg27xgWNYJ9V+PAkzw1duCim8nZIR
	 I1y/FzT2IcGjD0EczQhJAXOZ2pUeCpzb/BipW5M5gVmRbCb9l/kdYEe8lN9y/bfAuv/BQ
	 bYoEvE/tLa9/eaF6PVlEkQ+sPazw/MwrfUCNNozdxqoJGUfoaIOEKCBrShz1WRyBAVg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794590674;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=DskPNIRZ2ciIgNFu1atw5tCEm9BjI6JeU6DzkiEP+QE=;
	b=dTfq91sTj1QIgVNvj6q33QD4CKiHAY8WHHo/gjkBzY14TkeHOa0TKXYPspu9PoppY8XE
	 MYbBt9G5caZKqsOdWht2o+n7W7hKU84oyiAZ3u7Ih6JoZgge/oqNrZPUKTHd7qpPs4FkT
	 lrhnKy13612XrX6Pa+ccSN5SQZC+oB7lDPOTF29zYhPMPwjzEoqK16k3uGWyX+fI4QJC9
	 5NjqjfllNc6ijossm4UN7A1blpRQSjC9X9WKVsF4UqRlkyp3shG0LjOhU7tbgUx2ixEeg
	 ClvV2yeswyTK6q0aS+Vnk9xcF2Ol+dn8lBLNA5+xB3ah6zplgVXjpLuQRE42jYEe0Cw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=QfNazaLe;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 33167606B223;
	Fri, 13 Nov 2026 17:24:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=QfNazaLe
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D41A21F000C4;
	Fri, 13 Nov 2026 17:24:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794590674;
	bh=DskPNIRZ2ciIgNFu1atw5tCEm9BjI6JeU6DzkiEP+QE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=QfNazaLeHwIsqDcZuwcVp6RM94n9MhcAe3avixWMI/JTlZPvG/3eOHlZ05GrADAYN
	 GQweMdHxFQdaE0tYjp6K5Ilo5lZBoXLyQbqKc+/WGZs01lKksoejEM4HuBXAIUogNX
	 oOfFWWaaEqvFR+97ChMW9RHWQgJ9a+ezrtSvZgZg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yuto Ohnuki <ytohnuki@amazon.com>,
	Stefan Hajnoczi <stefanha@redhat.com>,
	Miklos Szeredi <mszeredi@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 588/686] virtiofs: add FUSE protocol validation
Date: Fri, 13 Nov 2026 10:52:01 -0500
Message-ID: <20261113153841.739867657@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153820.902362109@linuxfoundation.org>
References: <20261113153820.902362109@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index e475f7f9e83d4..33962e1ad8c12 100644
--- a/fs/fuse/virtio_fs.c
+++ b/fs/fuse/virtio_fs.c
@@ -755,6 +755,27 @@ static void copy_args_from_argbuf(struct fuse_args *args, struct fuse_req *req)
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
@@ -764,10 +785,6 @@ static void virtio_fs_request_complete(struct fuse_req *req,
 	unsigned int len, i, thislen;
 	struct folio *folio;
 
-	/*
-	 * TODO verify that server properly follows FUSE protocol
-	 * (oh.uniq, oh.len)
-	 */
 	args = req->args;
 	copy_args_from_argbuf(args, req);
 
@@ -821,6 +838,10 @@ static void virtio_fs_requests_done_work(struct work_struct *work)
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



