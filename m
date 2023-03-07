Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 752BEBA45
	for <patches@lists.linux.dev>; Tue,  7 Mar 2023 18:01:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E59F5C433D2;
	Tue,  7 Mar 2023 18:01:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678212082;
	bh=xcGvdYIi3xBUtI7d3Mwlb1YERsxmBuvYnxyI5IQxoOI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2SLMtjB3TB1QFQ4p6Oz5YI7K2E00at10YW8jxuZbPr3hZ0c8QXSBOIwetCP2Wlmwf
	 2xe2mMrgPjlJT/yO1P84rYbsVmb8XIQfyakOPgH/6qSAkr5QXytqh4gTObx7NlJCdZ
	 QZ1N3WBX7plF6EueMKd37xCeMdCXkk0SomleXZs8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	ZiyangZhang <ZiyangZhang@linux.alibaba.com>,
	Ming Lei <ming.lei@redhat.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 071/885] ublk_drv: remove nr_aborted_queues from ublk_device
Date: Tue,  7 Mar 2023 17:50:05 +0100
Message-Id: <20230307170004.857573703@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307170001.594919529@linuxfoundation.org>
References: <20230307170001.594919529@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Ming Lei <ming.lei@redhat.com>

[ Upstream commit ed878d1c1c641c4a6bd366658fc8e6bc842b80d1 ]

No one uses 'nr_aborted_queues' any more, so remove it.

Reviewed-by: ZiyangZhang <ZiyangZhang@linux.alibaba.com>
Signed-off-by: Ming Lei <ming.lei@redhat.com>
Link: https://lore.kernel.org/r/20230106041711.914434-2-ming.lei@redhat.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Stable-dep-of: 73a166d97492 ("ublk_drv: don't probe partitions if the ubq daemon isn't trusted")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/block/ublk_drv.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/block/ublk_drv.c b/drivers/block/ublk_drv.c
index 6368b56eacf11..f44b9467720c9 100644
--- a/drivers/block/ublk_drv.c
+++ b/drivers/block/ublk_drv.c
@@ -159,7 +159,6 @@ struct ublk_device {
 
 	struct completion	completion;
 	unsigned int		nr_queues_ready;
-	atomic_t		nr_aborted_queues;
 
 	/*
 	 * Our ubq->daemon may be killed without any notification, so
-- 
2.39.2



