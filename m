Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EEAD32571CB;
	Mon, 24 Feb 2025 14:57:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740409045; cv=none; b=oNJnVDQVSYIgbTIRu3oXEwnyAi/1GCKj1vBrQ7PyUwNqJ+K/PRsRemwyKd2kUr3p5TonFxoVx/ys+4r2U+/xjMMAYSnzE3lYFf+EDo10WT43xFi6/o8nOz/Q+7v2xdiKet6YAUt+GJ49tSiuat+0K75ZNMMQZWIMxcfHjD2ojbg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740409045; c=relaxed/simple;
	bh=WYerxr7xZjYs1ojcRj7adGJT8FgaJL/6Jr39q5YV1B8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=R21Oz4rDa+AG71M+boHrVryfeier/JULPAUM5Vi9vURsSUYmiQgVmyK3wkRYq05RyoVfIqQV7IYpcCABP79jIdL3ncIrbqprI+t6UrXZE1yviTG+dNRlN06HMC+B9jSrvWJRO0e3B6qksOjwf9OJkNrbGDoiBox2Kk8LT0h3XZo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OrNYJl9R; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OrNYJl9R"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E0726C4CED6;
	Mon, 24 Feb 2025 14:57:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1740409044;
	bh=WYerxr7xZjYs1ojcRj7adGJT8FgaJL/6Jr39q5YV1B8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OrNYJl9Rbkkt/mfrKOC/6TXqAMxPRT0kD2mxqHfakTjL9sIbyZ1T4GMzXjzbwMo0L
	 5wr2cZt2YUmw3prOp3Dbt6XzDjV9oEUaGItCNjf9oojl9GomIZSeH4D4DbrRDKvPUO
	 NjMrDF9tzi0DPcjpFyiyUfoh5Z1qgy4MPXGWj8Ds=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Damien Le Moal <dlemoal@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Sagi Grimberg <sagi@grimberg.me>,
	Keith Busch <kbusch@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 080/138] nvme: tcp: Fix compilation warning with W=1
Date: Mon, 24 Feb 2025 15:35:10 +0100
Message-ID: <20250224142607.624274841@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250224142604.442289573@linuxfoundation.org>
References: <20250224142604.442289573@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Damien Le Moal <dlemoal@kernel.org>

[ Upstream commit cd513e0434c3e736c549bc99bf7982658b25114d ]

When compiling with W=1, a warning result for the function
nvme_tcp_set_queue_io_cpu():

host/tcp.c:1578: warning: Function parameter or struct member 'queue'
not described in 'nvme_tcp_set_queue_io_cpu'
host/tcp.c:1578: warning: expecting prototype for Track the number of
queues assigned to each cpu using a global per(). Prototype was for
nvme_tcp_set_queue_io_cpu() instead

Avoid this warning by using the regular comment format for the function
nvme_tcp_set_queue_io_cpu() instead of the kdoc comment format.

Fixes: 32193789878c ("nvme-tcp: Fix I/O queue cpu spreading for multiple controllers")
Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Sagi Grimberg <sagi@grimberg.me>
Signed-off-by: Keith Busch <kbusch@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/host/tcp.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/nvme/host/tcp.c b/drivers/nvme/host/tcp.c
index 841238f38fdda..4162893d49395 100644
--- a/drivers/nvme/host/tcp.c
+++ b/drivers/nvme/host/tcp.c
@@ -1565,7 +1565,7 @@ static bool nvme_tcp_poll_queue(struct nvme_tcp_queue *queue)
 			  ctrl->io_queues[HCTX_TYPE_POLL];
 }
 
-/**
+/*
  * Track the number of queues assigned to each cpu using a global per-cpu
  * counter and select the least used cpu from the mq_map. Our goal is to spread
  * different controllers I/O threads across different cpu cores.
-- 
2.39.5



