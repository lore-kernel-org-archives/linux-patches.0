Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 14BFE24633C;
	Tue, 29 Apr 2025 17:00:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745946003; cv=none; b=YZnchuh05tWxd3y8a47XL9WTYaKv0xLk1QYhuCu+f61aWeBYzyxVamMB0ZgUrif7ykFGqMdREUtp2JSvLeSGs6a7xo4M5v7FOfO24zH/YwY+4bXulPyFhBw7nN2uhbQGCybGTKyX9FCRchAyhPH25bneRERARYfguwXLq3V61YM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745946003; c=relaxed/simple;
	bh=9IgnmS+IBhystQv9in3k+rfp0OjQw0M2CA2O27U56Ak=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LqBhplwpu3iYV/jvcusfCy1vae8zw23yL50hO/2Gl3J7PpMq2QqexL5+mw9vjcp07PGI9/m497zvIpOYFA390H3P8ekRLBDhvxS6JaoI1+En9hPUDFo3GbD7n7ZCq2ej8f1y0AbhxpCiSxFK6i0TWqVyP/tSpAWgm4akfaA8hjs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=f73KEXV5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="f73KEXV5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 90E2AC4CEE3;
	Tue, 29 Apr 2025 17:00:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745946003;
	bh=9IgnmS+IBhystQv9in3k+rfp0OjQw0M2CA2O27U56Ak=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=f73KEXV5anAJzfpbfRSbNo/m9mIM/TnRKaOnUCtTs8FcTVJjnvmBsUpCzt7hu3T+J
	 0YxRyQGoeWMuXE1Z5c8DMEcmFPjacmRKUWWgkWFZr9W3VxO98LMXwzCouDw5gOwPdm
	 xAeCXaS62weYop5V6kKbin7Qz6vWmc5koVcBhR4c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Caleb Sander Mateos <csander@purestorage.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 091/311] ublk: remove unused cmd argument to ublk_dispatch_req()
Date: Tue, 29 Apr 2025 18:38:48 +0200
Message-ID: <20250429161124.776390230@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161121.011111832@linuxfoundation.org>
References: <20250429161121.011111832@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Caleb Sander Mateos <csander@purestorage.com>

[ Upstream commit dfbce8b798fb848a42706e2e544b78b3db22aaae ]

ublk_dispatch_req() never uses its struct io_uring_cmd *cmd argument.
Drop it so callers don't have to pass a value.

Signed-off-by: Caleb Sander Mateos <csander@purestorage.com>
Link: https://lore.kernel.org/r/20250328180411.2696494-2-csander@purestorage.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Stable-dep-of: d6aa0c178bf8 ("ublk: call ublk_dispatch_req() for handling UBLK_U_IO_NEED_GET_DATA")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/block/ublk_drv.c | 7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

diff --git a/drivers/block/ublk_drv.c b/drivers/block/ublk_drv.c
index e1388a9b1e2d1..437297022dcfa 100644
--- a/drivers/block/ublk_drv.c
+++ b/drivers/block/ublk_drv.c
@@ -1174,7 +1174,6 @@ static inline void __ublk_abort_rq(struct ublk_queue *ubq,
 }
 
 static void ublk_dispatch_req(struct ublk_queue *ubq,
-			      struct io_uring_cmd *cmd,
 			      struct request *req,
 			      unsigned int issue_flags)
 {
@@ -1262,7 +1261,7 @@ static void ublk_rq_task_work_cb(struct io_uring_cmd *cmd,
 	struct request *req = blk_mq_tag_to_rq(
 		ubq->dev->tag_set.tags[ubq->q_id], tag);
 
-	ublk_dispatch_req(ubq, cmd, req, issue_flags);
+	ublk_dispatch_req(ubq, req, issue_flags);
 }
 
 static void ublk_queue_cmd(struct ublk_queue *ubq, struct request *rq)
@@ -1281,11 +1280,9 @@ static void ublk_cmd_list_tw_cb(struct io_uring_cmd *cmd,
 	struct request *next;
 
 	while (rq) {
-		struct ublk_io *io = &ubq->ios[rq->tag];
-
 		next = rq->rq_next;
 		rq->rq_next = NULL;
-		ublk_dispatch_req(ubq, io->cmd, rq, issue_flags);
+		ublk_dispatch_req(ubq, rq, issue_flags);
 		rq = next;
 	}
 }
-- 
2.39.5



