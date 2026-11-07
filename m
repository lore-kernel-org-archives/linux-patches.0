Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794065018;
	b=z9fDq/MsUz2a7i6cNKSEI8O9UtSjp2M3SYEOYnHiFGb9ATJKZV08QDjIS3TRLukOzxkT
	 O81yE3U/z1NsRIccZ9SWxipwUJ9vUyjGhHApt9o+xHlOJwQuE8TsqYttE4v+yUXeO0PME
	 LwOkzoZCzC/RuMXaM/46rm7q2Kt0txDrLJZxni38tE/k+kIDjqBwONhBmD++FZOe2M5zL
	 4En7nG0g48y0hZoSGAjLQYGxBKdeUvKMdTn8PKGsJqOsBVrJ79+8spqWM4Mhg9Oqn9yfS
	 9y9xxzEO+Wa6H74o4hBFhTNO+9wJNfAfB8byeVGjyCSjkyetDuovAYPk0J8gLf452Gw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794065018;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=wT+LNDiSXd+FomdcBCaj73PDPjpHm25iXg6js2yJtVs=;
	b=SQNaaTceeo+I6pTpnUKBiFUJG8sfLSO1KOJjgvEQ0/Zhg1rU8BqewVL+1ftzuf85lKFA
	 pCRHzHHf/ZL4MmLKONtjr7ebEAwQcX+8oEkpvKlAwNySO3GVrGABeLPrGSlgfhdNlqC6/
	 1pttj5PMkqflvmnXnyRLPSWgjujbB3VzlU3xklHzIU7/0rEXbyO4EP+PlfcoNdpI+uJQn
	 /p1ntA5fCq3uyMEMwJuRmaH9mYeH6tOwqrzcWRqJgaCIJyF/XoMy5tK59CRAqFcXD1eDr
	 E+kwwIpFFae3dfVT/XTbTzCiO+IBluD9edF5hx8H2oBInx+LWdDtiVA++bDsrefZ0bg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=lHRu9THy;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C889A606A336;
	Sat,  7 Nov 2026 15:23:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=lHRu9THy
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 77F571F008A1;
	Sat,  7 Nov 2026 15:23:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794065017;
	bh=wT+LNDiSXd+FomdcBCaj73PDPjpHm25iXg6js2yJtVs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=lHRu9THyZ+SEqQG5t/2AsjcphlDi89gg9HWFtJz/X14tWTn4xTOuZvjfsK1qLIgYh
	 ECd6rUxacMW8f+y3aynyvei1qs+PmlgzzASYIGlYDDXBOIBshaSKaNX43UxLYw43uX
	 idXcDWHtFSEoLJg+zQlVlVTRrjCpfkhwlzHHHSSw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sung Byeongchan <tjdqudcks0424@naver.com>,
	Miklos Szeredi <mszeredi@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0839/1257] virtiofs: validate fixed-output response length
Date: Sat,  7 Nov 2026 08:52:15 -0500
Message-ID: <20261107135002.499670146@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134939.434104957@linuxfoundation.org>
References: <20261107134939.434104957@linuxfoundation.org>
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
index 8519dfa09ccf6..0150c5cfc311b 100644
--- a/fs/fuse/virtio_fs.c
+++ b/fs/fuse/virtio_fs.c
@@ -727,6 +727,10 @@ static void copy_args_from_argbuf(struct fuse_args *args, struct fuse_req *req)
 	unsigned int num_out;
 	unsigned int i;
 
+	/* fuse_request_end() returns this error; there are no args to copy. */
+	if (req->out.h.error)
+		goto out;
+
 	remaining = req->out.h.len - sizeof(req->out.h);
 	num_in = args->in_numargs - args->in_pages;
 	num_out = args->out_numargs - args->out_pages;
@@ -752,6 +756,7 @@ static void copy_args_from_argbuf(struct fuse_args *args, struct fuse_req *req)
 	if (args->out_argvar)
 		args->out_args[args->out_numargs - 1].size = remaining;
 
+out:
 	kfree(req->argbuf);
 	req->argbuf = NULL;
 }
@@ -759,7 +764,9 @@ static void copy_args_from_argbuf(struct fuse_args *args, struct fuse_req *req)
 /* Verify that the server properly follows the FUSE protocol */
 static bool virtio_fs_verify_response(struct fuse_req *req, unsigned int len)
 {
+	struct fuse_args *args = req->args;
 	struct fuse_out_header *oh = &req->out.h;
+	unsigned int expected;
 
 	if (len < sizeof(*oh)) {
 		pr_warn("virtio-fs: response too short (%u)\n", len);
@@ -774,6 +781,29 @@ static bool virtio_fs_verify_response(struct fuse_req *req, unsigned int len)
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



