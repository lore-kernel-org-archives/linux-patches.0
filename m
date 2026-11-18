Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795038372;
	b=hJaM92FCVjEEPhm0/0A9Vf0WkehnDpn//bPa5SMMhKTXb1Q5eXqhaqTsKLJR3919iWc9
	 2Q0F3idyWusmlOJdySeQdjNXNotMLhZi+mKmSqYIMoO60Wbyd8V+f1sUPc7jLjo6RAcC4
	 Kvdfm/AoUsgCNVva2f4cBV9KYT6kQ3PhVLqqe6fU611gtgglLfBhRgaqNLcseXOcmxwDg
	 NXLgrhnODfkEmNhW1qE/xdNQud0RKK2FQmpL7bW0puKk0M0Uy2a/oaZ43M9v848dqYfRP
	 oeG4qCVIkvzZL7hQNriQzXiU3ykzLY8M11QErbnB9OY6QVmof7GuMwjzPlxKDJoc0MQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795038372;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=1bqF3cGruafbHebInX6xp9XJhxrIV6U+U25xgTKVonA=;
	b=brMIAtjEyo2NE5rUMhCpnrhMjfbOObMvXT5lEl7DK03pccoZzjcfxzWbtZUlyk5GaBJ6
	 7IGs4Iu5gxeTG5EjtDd21rlxo2H9AaoizWZpzuiqjsv0v1rt8djEKY4AZMebEqBaq/Bpw
	 oX5u2UcFN0v0LO7vqCWyS7bLggfuLQj7ysg4dwRPi7WaBrabeRY4WUjZAQAfyjNzAqIUs
	 uTBYJbQgfXXkcrm+kI454PGplu95PYUYyuYrBFlIqfwv0XFXjrFJ98BBeBzO6iPOeFYJE
	 u0iYilXeNkbENLAmRQk+vh6k4CH5E1bKPQMlo3Q1DznIEjoEvUEOtPCCFZGjDoOIgxw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=caTn2FNA;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD91A606A32C;
	Wed, 18 Nov 2026 21:46:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=caTn2FNA
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3CBA61F000C9;
	Wed, 18 Nov 2026 21:46:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795038372;
	bh=1bqF3cGruafbHebInX6xp9XJhxrIV6U+U25xgTKVonA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=caTn2FNA5eX5xJOV6WT48EddYINbuYqbKy1gTOy1m6hMBTm3cIsq+/sVy0W/vWV3Z
	 D/GCVCh0NkJ8/PvCRjMb2ODKrjS+4Bmp932VrXwwvz/DA/e8ovqi/u0pZKBNHRi8pf
	 qifWrMq5u/p6lnMzmzGxCQ+zrnkDrlYrp5kZR0T8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yuto Ohnuki <ytohnuki@amazon.com>,
	Stefan Hajnoczi <stefanha@redhat.com>,
	Miklos Szeredi <mszeredi@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1721/3318] virtiofs: add FUSE protocol validation
Date: Wed, 18 Nov 2026 15:39:03 +0100
Message-ID: <20261118150413.495204996@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index b1028a4dbb991..7b1e9291c3ef4 100644
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



