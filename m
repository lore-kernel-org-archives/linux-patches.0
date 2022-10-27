Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 48DB78486
	for <patches@lists.linux.dev>; Thu, 27 Oct 2022 16:58:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C26C5C433D6;
	Thu, 27 Oct 2022 16:58:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1666889928;
	bh=4cj6OpcY3yRZnynWQ7qU9TPuAQprb3bcLUgeVpUGaHM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=geekdZJFm0cGlO0DOywenZrPY2br1LkGM4QU+RRwR+qK2R/TOd3Ct5uLPiQCZJ+mD
	 QIC3GzKp37kX3QqrpUKljCYm/e4DgHiBGyMH2l+xF3zm3AXHw5EphSsIbCKpRNdjvE
	 kPjSfucDHGuGE4UKF9VJTh+JPJlXcDVgnme1iWz0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 51/94] io_uring/rw: remove leftover debug statement
Date: Thu, 27 Oct 2022 18:54:53 +0200
Message-Id: <20221027165059.229070969@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221027165057.208202132@linuxfoundation.org>
References: <20221027165057.208202132@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Jens Axboe <axboe@kernel.dk>

[ Upstream commit 5c61795ea97c170347c5c4af0c159bd877b8af71 ]

This debug statement was never meant to go into the upstream release,
kill it off before it ends up in a release. It was just part of the
testing for the initial version of the patch.

Fixes: 2ec33a6c3cca ("io_uring/rw: ensure kiocb_end_write() is always called")
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 io_uring/rw.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/io_uring/rw.c b/io_uring/rw.c
index 60c08a944e2f..93d7cb5eb9fe 100644
--- a/io_uring/rw.c
+++ b/io_uring/rw.c
@@ -192,8 +192,6 @@ static void io_req_io_end(struct io_kiocb *req)
 {
 	struct io_rw *rw = io_kiocb_to_cmd(req, struct io_rw);
 
-	WARN_ON(!in_task());
-
 	if (rw->kiocb.ki_flags & IOCB_WRITE) {
 		kiocb_end_write(req);
 		fsnotify_modify(req->file);
-- 
2.35.1



