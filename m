Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A1C763AE6E
	for <patches@lists.linux.dev>; Wed,  7 Jun 2023 20:31:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 23AFDC433D2;
	Wed,  7 Jun 2023 20:31:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1686169863;
	bh=Xv/CykolLP4zraQW4RmEZ8TaFwChsfvq9WNkj5Ye4G8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LZYcb1MHvOKh4MXByudNFyzZu1FFj/modjPlwPVQGwoILl3ppiDuSxDQMfrkjWiBD
	 cd8xkE+L2e/KMfverP2CWNXIkrRznRAb5ALY26IyZ7ASlmc2pCHzlY3R6WkzCbqMQZ
	 tLaXfHt/Y7Ck5fnA9B8P0uDzYOOAx5ne7GIkbIO4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ben Noordhuis <info@bnoordhuis.nl>,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 6.3 243/286] io_uring: undeprecate epoll_ctl support
Date: Wed,  7 Jun 2023 22:15:42 +0200
Message-ID: <20230607200931.223409783@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230607200922.978677727@linuxfoundation.org>
References: <20230607200922.978677727@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Ben Noordhuis <info@bnoordhuis.nl>

commit 4ea0bf4b98d66a7a790abb285539f395596bae92 upstream.

Libuv recently started using it so there is at least one consumer now.

Cc: stable@vger.kernel.org
Fixes: 61a2732af4b0 ("io_uring: deprecate epoll_ctl support")
Link: https://github.com/libuv/libuv/pull/3979
Signed-off-by: Ben Noordhuis <info@bnoordhuis.nl>
Link: https://lore.kernel.org/r/20230506095502.13401-1-info@bnoordhuis.nl
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 io_uring/epoll.c |    4 ----
 1 file changed, 4 deletions(-)

--- a/io_uring/epoll.c
+++ b/io_uring/epoll.c
@@ -25,10 +25,6 @@ int io_epoll_ctl_prep(struct io_kiocb *r
 {
 	struct io_epoll *epoll = io_kiocb_to_cmd(req, struct io_epoll);
 
-	pr_warn_once("%s: epoll_ctl support in io_uring is deprecated and will "
-		     "be removed in a future Linux kernel version.\n",
-		     current->comm);
-
 	if (sqe->buf_index || sqe->splice_fd_in)
 		return -EINVAL;
 


