Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795047032;
	b=4bfTwUsZpW/US6TuT/Fzc5PwBeeYRMwJxVlScxjqUIcY9O6iQrNeamIpt6LrXeG28gHw
	 2ru41pBmKnYnXHHSuTk4wW2dSBsr1sfl6L/vtREQ/MCEIdl5a0ZAwf/4DwNAb3lUcqv7y
	 8TXysef2UAQkBN0UK3CQfBunlsF3ABHTfxOxPZvRAJg+jY+Q1yHQINOvf5WgyLRAUBupz
	 WqA2eOjiwdzTZOzsWc0goBfIltR2rLgJ1YS0Ge7iZv6gwNGkBmbdF2o1/NZ1oYGFAxVfV
	 9Midf093Z6YPIxYVnvwdra4ZKfjah1dmwTo8WL9OBYtpsJW8NGojKyiMo/792/woZ9A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795047032;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=etPAikTryzg/jc6ldeVlxDOTDpp6FJCv/LKZmklttOo=;
	b=TpQYAAaa5k+9VOcvHVuJRPw3fd1WHWfpsQch8m3kfzQalumVbD7lERagp06lWVkqo5Ba
	 f0kalnWNk1zrWnKa2eWi4ftx1UHt0N5s/Vk9ECQOIcGlzfIKBXhf+IjSpoWhrxjyQa26H
	 7Kryy0RODp0K7Y6rxGTDlLsUp0fj5aVpuG6JR9uu2WeIYlJsmweq0RcOsVA/FeRU100ot
	 W/ftsyUC79lIqBLHOPcQCmeJnjp0gUhiExH4FCUGifs5V6p9cWiav85qN2AvgN3TK86D/
	 CQqnNfH+1JbgbeaTypU69ReDUen4F/10I60HDNHmR+cgD/+FKhbpofv34OMH0F3M3Cw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=yqrhiSno;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 18C9A606A330;
	Thu, 19 Nov 2026 00:10:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=yqrhiSno
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 646CF1F000C6;
	Thu, 19 Nov 2026 00:10:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795047032;
	bh=etPAikTryzg/jc6ldeVlxDOTDpp6FJCv/LKZmklttOo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=yqrhiSno7y524GxWD+XiY37IVmWojBXf8HzdX3uCLHg5vM1GhZZ6Fyw5RKjpHS0QJ
	 0HGtlGqhmD3begRUS/gEz5Ee2ATraWnak98jMknUomJ8a25vhOjbHjTyrYeSr7sXLi
	 1lYYjI8+fp6BzthVE/FA039VeKOWE3USzebyEJ1g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yuto Ohnuki <ytohnuki@amazon.com>,
	Stefan Hajnoczi <stefanha@redhat.com>,
	Miklos Szeredi <mszeredi@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1466/2857] virtiofs: add FUSE protocol validation
Date: Wed, 18 Nov 2026 15:41:40 +0100
Message-ID: <20261118150254.094390020@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 9e4f2ba0ef9d2..ab410ebe7c304 100644
--- a/fs/fuse/virtio_fs.c
+++ b/fs/fuse/virtio_fs.c
@@ -564,6 +564,27 @@ static void copy_args_from_argbuf(struct fuse_args *args, struct fuse_req *req)
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
@@ -574,10 +595,6 @@ static void virtio_fs_request_complete(struct fuse_req *req,
 	unsigned int len, i, thislen;
 	struct page *page;
 
-	/*
-	 * TODO verify that server properly follows FUSE protocol
-	 * (oh.uniq, oh.len)
-	 */
 	args = req->args;
 	copy_args_from_argbuf(args, req);
 
@@ -633,6 +650,10 @@ static void virtio_fs_requests_done_work(struct work_struct *work)
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



