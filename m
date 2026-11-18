Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795050381;
	b=hNgO3On9sIcpvQB2Dm9gogjLyLeF1BU4DWW8/QUD4B6eyCDvjLbaTZh0Rzu6yc3/Eg3A
	 5YZdY7CdiX6lrsxxajmAzqlT14h3UvxUgMasnHdxPBYpZHJYdPtdRSv22rFbkPcNGCnVX
	 fO9/leOTYIxym7SNVTfHYdS5GHbeciXB8OoUfwmVvy1emWsj073B8T8MD7OLhliQ35nRE
	 iPQ1M5ne12Dq2LvEIib2KNZiifnmPEFQ88iSpuvDybRXYR5s75YMv1GV1dCt8rppcx6Es
	 UE3d9/fEvb2Va8VWNiMU5WZKXb1OaC8eUyMhT+58VjOGGQnLhIAzKlgAdyvQ8zas3ZA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795050381;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=EfAqOZBv+GGHtiuy0oHRKuf15IoFpLua62dSdRTtpuA=;
	b=aU7aspxabBpV8Lc93R2+B9oop0j1P2tM6co8xf8k3Eo6FSptkaY5+3Ub0jwpt8n1URf6
	 2jZgClw/SdhWFtM5dNJCjZ8MAAOXWsJfYp+JwFjQSl/plnX5lPF4jbhF9MwfZvjQIw3X0
	 yUfAMsVIPJf0bipPoF8Z29xunfotEJ4w3iiJhsqOqbhUi9CrMAxy4ZM36GQn0sLT/XrnV
	 VfIML0TEV5cYu040OCUkBIraEFo1ux25VlHXW+5+5ml1IkWyx8qekQmwBNZ+8ORc7E8gv
	 MceG0dTxJ+Hmg8ToqyGWSDhJ1diTrRXeJoGAUxfLr2Gddp9BZCuDnSKGhK2zJQYteyg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=KI7lQS8e;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F2FA9606A325;
	Thu, 19 Nov 2026 01:06:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=KI7lQS8e
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1FB0E1F000C4;
	Thu, 19 Nov 2026 01:06:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795050380;
	bh=EfAqOZBv+GGHtiuy0oHRKuf15IoFpLua62dSdRTtpuA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=KI7lQS8eVOvnyz6sQuZDfXJ+qaL1t5Y6D+WZ0vNcET1Oguh5ziOdluLinRdHhASeq
	 qBuNQL49P/+PoNfoS8YtiM9t4UdCdYxfeL3AZZiOXjfhyGBQMDDewROTk2pIoKDOUu
	 p8QEllh0owLE2o5ZYPpsc9wCvro7EbuXtWWnJJ80=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hannes Reinecke <hare@kernel.org>,
	Maurizio Lombardi <mlombard@redhat.com>,
	Daniel Wagner <wagi@kernel.org>,
	Keith Busch <kbusch@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 2687/2857] nvme-fabrics: clear the poll map if no poll queues are mapped
Date: Wed, 18 Nov 2026 16:02:01 +0100
Message-ID: <20261118150338.318638628@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Daniel Wagner <wagi@kernel.org>

[ Upstream commit 36ede1aa85d5d74c39ed375a906f6eadb15cee5b ]

blk_mq_alloc_tag_set sets the nr_queues of every map to nr_hw_queues.
When nr_poll_queues is set but no queues are left for polling,
nvmf_map_queues skips the poll map and leaves it this way, with all CPUs
mapped to hctx 0.  The queue then claims poll support, polled I/O ends
up on hctx 0, which isn't a poll queue, and hctx 0 is marked as a poll
hctx, so even the Connect command of the first I/O queue is marked as
polled.

Clear the poll map when no poll queues are mapped, so polled I/O is
rejected with -EOPNOTSUPP.

Fixes: 1a9460cef571 ("nvme-tcp: support simple polling")
Fixes: 5651cd3c4336 ("nvme-rdma: fix queue mapping when queue count is limited")
Reviewed-by: Hannes Reinecke <hare@kernel.org>
Tested-by: Maurizio Lombardi <mlombard@redhat.com>
Signed-off-by: Daniel Wagner <wagi@kernel.org>
Signed-off-by: Keith Busch <kbusch@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/host/fabrics.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/nvme/host/fabrics.c b/drivers/nvme/host/fabrics.c
index 32d0dbd6ae464..99a659fc74ee0 100644
--- a/drivers/nvme/host/fabrics.c
+++ b/drivers/nvme/host/fabrics.c
@@ -1036,6 +1036,13 @@ void nvmf_map_queues(struct blk_mq_tag_set *set, struct nvme_ctrl *ctrl,
 			io_queues[HCTX_TYPE_DEFAULT] +
 			io_queues[HCTX_TYPE_READ];
 		blk_mq_map_queues(&set->map[HCTX_TYPE_POLL]);
+	} else {
+		/*
+		 * blk_mq_alloc_tag_set sets nr_queues of all maps to
+		 * nr_hw_queues.  Clear the poll map, otherwise the queue claims
+		 * poll support and polled I/O ends up on hctx 0.
+		 */
+		set->map[HCTX_TYPE_POLL].nr_queues = 0;
 	}
 
 	dev_info(ctrl->device,
-- 
2.53.0



