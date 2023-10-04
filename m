Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ADF6818E2A
	for <patches@lists.linux.dev>; Wed,  4 Oct 2023 18:09:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=linuxfoundation.org
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2EFE9C433C8;
	Wed,  4 Oct 2023 18:09:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1696442955;
	bh=IRofGcQLhywcNGP1TyhfFty64M6KwyUFRifPZjmLgOs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=m4Ur+VuNwZtddrkaPAY09fuaHM1vJGCv7dKACbQQFdm7fhd+1nfjgycXl7KbpoNNX
	 mUe4fmnSN8tZONtxkuwMRoeNM4YvS6cMfEF7H6Bm8nHq039x/7ypj28YfxK8S9bnZO
	 gbMPv3t6RokxE1fqMksxI4qaJMHbF/GJD2s0URfU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thomas Leonard <talex5@gmail.com>,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 5.15 169/183] io_uring/fs: remove sqe->rw_flags checking from LINKAT
Date: Wed,  4 Oct 2023 19:56:40 +0200
Message-ID: <20231004175211.118225963@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231004175203.943277832@linuxfoundation.org>
References: <20231004175203.943277832@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
 io_uring/io_uring.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -4038,7 +4038,7 @@ static int io_linkat_prep(struct io_kioc
 
 	if (unlikely(req->ctx->flags & IORING_SETUP_IOPOLL))
 		return -EINVAL;
-	if (sqe->ioprio || sqe->rw_flags || sqe->buf_index || sqe->splice_fd_in)
+	if (sqe->ioprio || sqe->buf_index || sqe->splice_fd_in)
 		return -EINVAL;
 	if (unlikely(req->flags & REQ_F_FIXED_FILE))
 		return -EBADF;


