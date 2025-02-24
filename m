Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 669D824889A;
	Mon, 24 Feb 2025 14:49:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740408582; cv=none; b=CnhLR/O5N19NflYFuYHRLMAuu3+ThsvsCTU26AoNnOgWtmcM/jI0+hIv7pY8h7NNh/S1zcAW0DxipDgYYTrsFaLq6lLtpHU1I6HSDKmwLiZibXQqPO4VRiv+O+miPPMYjM0wWWllvSmq9QSkQvzaWEVaai3fI8gd4/l7lazG07o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740408582; c=relaxed/simple;
	bh=vsV73hZ0o2Jo4qYRx1ifFGlZi6CNEDHEIXXLbP+E3VQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Q3+Q/757BuMuQWJQGDXihXhwUvFf3FGRVMtYm1SXxARjXAN0GzHbU0+w/Ml9/LFyzp+zjcXCRf0arZjPPpS6/wohW6ixOZOCej9Gc04drA2R7IkQLGz79mhETV5Kf7qWHsXyG906tdjpelcAb9CCX60cozlEsoUEwvLv4lRrEjo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=esF4bo7K; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="esF4bo7K"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D8301C4CED6;
	Mon, 24 Feb 2025 14:49:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1740408582;
	bh=vsV73hZ0o2Jo4qYRx1ifFGlZi6CNEDHEIXXLbP+E3VQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=esF4bo7KLw6LQTOa0t0kdBgCuZ1revtJtpSGXer3hYPVElkz3KTlWvEQcSwuOPylk
	 HFItf+4aGPeBGT/0ccMBJodnt2EAxR2a4Nm2Al8wNql4o3APQOWvPulS7Mk0zNd8DF
	 KgZ7684fXWrTiJ/xxZZNRMwU+mRJI/d3qaJkBC34=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Damien Le Moal <dlemoal@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Sagi Grimberg <sagi@grimberg.me>,
	Keith Busch <kbusch@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 100/154] nvme: tcp: Fix compilation warning with W=1
Date: Mon, 24 Feb 2025 15:34:59 +0100
Message-ID: <20250224142610.978720206@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250224142607.058226288@linuxfoundation.org>
References: <20250224142607.058226288@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 8305d3c128074..34eb3dabdc8a6 100644
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



