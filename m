Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795059609;
	b=krUl4oeQSzuJQZu0fbRS8Zq8nIczi+KK3CkuIjDCodEtos14pZFf+RkWRU4DBPAfZeaT
	 hKuac8MYFskb+NbjhpMfY5DmQZSV6uQS3REfVZ1qLTysk41GCObZ2rvfUOMOpsbQapGni
	 ji1x7duLiJ2hn9fQ7EKsR9ftjAe9tdiVX97RhYIasu6AyzeZXjIgwxp2r8JykZVXsdToR
	 22ad70fWQw4rJJgmzxQdtBMnOs5wZDbsSPhdAZLWK0PknWa6ce8G2u+K3lh5aAiPbvuwp
	 uN3chf3df+OSRZloz8p655XAsVauIJiVMfb7fktGyGfpbuw9m9nkR02LQlbyf+6371g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795059609;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=i5ETd1BphY18Xwdl4UoxDfAGEo1JLm7zGbaHq/fJb2s=;
	b=FVm4k/+NG+fa0fvEu2kICzG2T4y8Y/jlY5mSit00JYKrntHG5dWWIUEZMCL09i2YdfXS
	 lNTQKPW/D8KSkDzWh0X4mxJOYTrDMrRFdTvJQCV4TkmWBfhznP50JbFlOXfQ3HWqSxwqH
	 N3zXxuA3SEYvqMoso56arDCWGvX/pcFjyEM3jEVmESk0CXoaneGwhhAU6nSr9WOm89MzR
	 qepIEPVjrN2kcV88VlwPmRiPW1w+czlCLNUUO3j1iRdNa/FFD2tYU5eiYwweqRdLu8pcd
	 IoWJ2MmSXq1+K1TVw4KuPCFfjlfQsa1Ed4oaYlFE2IurIcrXE94uD4skVh2MaaZCnag==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=qOR8fFJ+;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 07ACE606A338;
	Thu, 19 Nov 2026 03:40:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=qOR8fFJ+
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5A0C71F000C4;
	Thu, 19 Nov 2026 03:40:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795059608;
	bh=i5ETd1BphY18Xwdl4UoxDfAGEo1JLm7zGbaHq/fJb2s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=qOR8fFJ+lTpouyVT+/hrb8ZioiMYWRhG6tI8u60Ah1HXN2JgYFZHL2QzM0MKSmtca
	 rMHDgFGHnBfS7eWX4ITZ8uzaRlKfcLwzT6AcPm4Y8cHpeaaip2EjZP83f6/TmhG2N7
	 iPh4gwDhZovDj+2GuNMBVnpwnR3yaKcTo9/hruyc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sung Byeongchan <tjdqudcks0424@naver.com>,
	Miklos Szeredi <mszeredi@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 0903/1848] virtiofs: validate fixed-output response length
Date: Wed, 18 Nov 2026 15:49:01 +0100
Message-ID: <20261118145954.585541611@linuxfoundation.org>
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

From: Sung Byeongchan <tjdqudcks0424@naver.com>

[ Upstream commit 5364d081125a34e90851fbb46ecc93f79339ce78 ]

A short successful virtiofs response can leave the fixed-output portion of
the request argument buffer unwritten.  The completion path nevertheless
copies the full declared output to the request destination, allowing stale
allocator contents to reach callers such as fuse_statfs().

Require successful fixed-output responses to contain their complete
declared output.  Continue to permit a shorter final argument only for
out_argvar requests.  Reject positive and internal restart error values
and require valid error replies to be header-only.  The error already
stored in the FUSE output header is returned by fuse_request_end(), so do
not copy output arguments from an error reply.

This was found by source review with AI assistance.  A header-only
successful FUSE_STATFS reply returned stale fields in nine of nine calls
across three boots.  The fixed kernel rejected the short response and
preserved complete replies, valid negative-error replies, and
variable-output replies.

Fixes: a62a8ef9d97d ("virtio-fs: add virtiofs filesystem")
Cc: stable@vger.kernel.org
Assisted-by: LLM
Signed-off-by: Sung Byeongchan <tjdqudcks0424@naver.com>
Signed-off-by: Miklos Szeredi <mszeredi@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/fuse/virtio_fs.c | 30 ++++++++++++++++++++++++++++++
 1 file changed, 30 insertions(+)

diff --git a/fs/fuse/virtio_fs.c b/fs/fuse/virtio_fs.c
index 96e6ebb0a4ee2..1f58c4adc2ae2 100644
--- a/fs/fuse/virtio_fs.c
+++ b/fs/fuse/virtio_fs.c
@@ -527,6 +527,10 @@ static void copy_args_from_argbuf(struct fuse_args *args, struct fuse_req *req)
 	unsigned int num_out;
 	unsigned int i;
 
+	/* fuse_request_end() returns this error; there are no args to copy. */
+	if (req->out.h.error)
+		goto out;
+
 	remaining = req->out.h.len - sizeof(req->out.h);
 	num_in = args->in_numargs - args->in_pages;
 	num_out = args->out_numargs - args->out_pages;
@@ -552,6 +556,7 @@ static void copy_args_from_argbuf(struct fuse_args *args, struct fuse_req *req)
 	if (args->out_argvar)
 		args->out_args[args->out_numargs - 1].size = remaining;
 
+out:
 	kfree(req->argbuf);
 	req->argbuf = NULL;
 }
@@ -559,7 +564,9 @@ static void copy_args_from_argbuf(struct fuse_args *args, struct fuse_req *req)
 /* Verify that the server properly follows the FUSE protocol */
 static bool virtio_fs_verify_response(struct fuse_req *req, unsigned int len)
 {
+	struct fuse_args *args = req->args;
 	struct fuse_out_header *oh = &req->out.h;
+	unsigned int expected;
 
 	if (len < sizeof(*oh)) {
 		pr_warn("virtio-fs: response too short (%u)\n", len);
@@ -574,6 +581,29 @@ static bool virtio_fs_verify_response(struct fuse_req *req, unsigned int len)
 			oh->unique, req->in.h.unique);
 		return false;
 	}
+	if (oh->error <= -ERESTARTSYS || oh->error > 0) {
+		pr_warn("virtio-fs: invalid error value (%d)\n", oh->error);
+		return false;
+	}
+
+	if (oh->error) {
+		if (len != sizeof(*oh)) {
+			pr_warn("virtio-fs: error response too long (%u)\n", len);
+			return false;
+		}
+		return true;
+	}
+
+	expected = sizeof(*oh) +
+		   fuse_len_args(args->out_numargs, args->out_args);
+	if (len > expected ||
+	    (len < expected &&
+	     (!args->out_argvar ||
+	      expected - len > args->out_args[args->out_numargs - 1].size))) {
+		pr_warn("virtio-fs: invalid response length (%u, expected %u)\n",
+			len, expected);
+		return false;
+	}
 	return true;
 }
 
-- 
2.53.0



