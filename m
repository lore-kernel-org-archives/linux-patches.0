Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3ECB28F57
	for <patches@lists.linux.dev>; Sun, 16 Jul 2023 20:56:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B999AC433C8;
	Sun, 16 Jul 2023 20:56:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1689541019;
	bh=lBJxmKi3M6nvU1LUxxAqkdHH33EIOvczTyU84IPHYcM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qOO+co1URGcIkNKgdZDyuD34J4E3OhFN1BWLknh2gTDDuDoMn8zvAK/w7Srqkb/kL
	 sMLqHvcsfukmXDwv8jPB9yTjTD4hM+L+SPbRXjrxMNm8yTUY/HqxCl70NcwWhWvz9+
	 H40oxGmq7RAgTBJQNwl6/I2l1NbPsZli7oidEMdg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yu Kuai <yukuai3@huawei.com>,
	Christoph Hellwig <hch@lst.de>,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 6.1 570/591] blktrace: use inline function for blk_trace_remove() while blktrace is disabled
Date: Sun, 16 Jul 2023 21:51:49 +0200
Message-ID: <20230716194938.603522563@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230716194923.861634455@linuxfoundation.org>
References: <20230716194923.861634455@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Yu Kuai <yukuai3@huawei.com>

commit cbe7cff4a76bc749dd70264ca5cf924e2adf9296 upstream.

If config is disabled, call blk_trace_remove() directly will trigger
build warning, hence use inline function instead, prepare to fix
blktrace debugfs entries leakage.

Signed-off-by: Yu Kuai <yukuai3@huawei.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Link: https://lore.kernel.org/r/20230610022003.2557284-2-yukuai1@huaweicloud.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/blktrace_api.h |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

--- a/include/linux/blktrace_api.h
+++ b/include/linux/blktrace_api.h
@@ -85,10 +85,14 @@ extern int blk_trace_remove(struct reque
 # define blk_add_driver_data(rq, data, len)		do {} while (0)
 # define blk_trace_setup(q, name, dev, bdev, arg)	(-ENOTTY)
 # define blk_trace_startstop(q, start)			(-ENOTTY)
-# define blk_trace_remove(q)				(-ENOTTY)
 # define blk_add_trace_msg(q, fmt, ...)			do { } while (0)
 # define blk_add_cgroup_trace_msg(q, cg, fmt, ...)	do { } while (0)
 # define blk_trace_note_message_enabled(q)		(false)
+
+static inline int blk_trace_remove(struct request_queue *q)
+{
+	return -ENOTTY;
+}
 #endif /* CONFIG_BLK_DEV_IO_TRACE */
 
 #ifdef CONFIG_COMPAT


