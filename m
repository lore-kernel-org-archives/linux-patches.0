Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2590C1C291
	for <patches@lists.linux.dev>; Wed,  4 Oct 2023 18:34:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nkKTSgZY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 93D02C433C7;
	Wed,  4 Oct 2023 18:34:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1696444490;
	bh=I0wf1u+VDpu1NHdo4aZGIx71fTcTzkie8TXmW5N4BwE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nkKTSgZYTaSNzRItG5sAjnlmkSMwumJAk6/3xexQvt30/NHO5B/TNEMV3xPso238R
	 wGt2ThQ+VULLsUglrHSHM3e+GG2/tvPkdtWv1kiH+QE3bCmbkuhVxbfe6mvBI8Aj+N
	 9JmBFdqa/xY7bLQ7l6zxAsi0k0tesLILj3KuxZz8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thomas Leonard <talex5@gmail.com>,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 6.5 268/321] io_uring/fs: remove sqe->rw_flags checking from LINKAT
Date: Wed,  4 Oct 2023 19:56:53 +0200
Message-ID: <20231004175241.696860128@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231004175229.211487444@linuxfoundation.org>
References: <20231004175229.211487444@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jens Axboe <axboe@kernel.dk>

commit a52d4f657568d6458e873f74a9602e022afe666f upstream.

This is unionized with the actual link flags, so they can of course be
set and they will be evaluated further down. If not we fail any LINKAT
that has to set option flags.

Fixes: cf30da90bc3a ("io_uring: add support for IORING_OP_LINKAT")
Cc: stable@vger.kernel.org
Reported-by: Thomas Leonard <talex5@gmail.com>
Link: https://github.com/axboe/liburing/issues/955
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 io_uring/fs.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/io_uring/fs.c
+++ b/io_uring/fs.c
@@ -243,7 +243,7 @@ int io_linkat_prep(struct io_kiocb *req,
 	struct io_link *lnk = io_kiocb_to_cmd(req, struct io_link);
 	const char __user *oldf, *newf;
 
-	if (sqe->rw_flags || sqe->buf_index || sqe->splice_fd_in)
+	if (sqe->buf_index || sqe->splice_fd_in)
 		return -EINVAL;
 	if (unlikely(req->flags & REQ_F_FIXED_FILE))
 		return -EBADF;


