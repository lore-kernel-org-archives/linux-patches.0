Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794063392;
	b=JTQicwSkIB7n3pktSNybgWGTm7Cv/b0Cp6GolZN8Eut/MQWUK0P/PP7YMRh6wnVWRPdp
	 XsHAQ+5Sw9wlCI0IvR2Y+UTtN85F1oQvD2sqRBq/JyYilFxpt4kRRICtS6ft3jp7bt7lM
	 0owYBtX9A4aqT2uCKUNaKHEUEoQyhkNiBUAWtpRF0q5vr4qMQsxU9MYSw4pGo4N4gML60
	 +0EO1iDyOz2KcP0kkQQnWJi+OZNTBOftlrogHmswh+yaqbI3RX22x3m5iboRWIj/QP/Ym
	 0z4a3wvnHs0h7BTmy+j0INM/CNi+QvCVY4SSFo0hsKmMUnDsx71Ipu1LV2IeubcxkOg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794063392;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=oHOt4gRpwLOXAELqUZlZqALazdvR/I2IZMkVYxNRFHI=;
	b=cNSeTj0YzgbvZBaMd2eroEo3I9+fm4AdXarglT4Fe+MMp3FBqtZXskmGSYazP9J2Q7Vq
	 o0POrK7T6lNh+ErKXpJkzJiE6GPKaYasSFe94vwd9tX+jMujWpBUvxOSdbZCBiGUh9WG/
	 N1eojHyBPmVbXaivWFrexmnHa4aOzyRURTuiQJI7I4916vajXDnOauKWxw5Wal6kO05xx
	 3UWIo14sbjzM2JlZ9jr0AyoKa3Qz5kZOLNkQfbPSAYVOaTiXUks5V3379EPWvmsTR8ED5
	 tNOEbvW8csGZb8+NSnkuUuu6c0KhGwAxs7yrJyJFNOjnYutK7OMwok1P9WJwf1WU7OQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=a1DfKi6G;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CFA14606D804;
	Sat,  7 Nov 2026 14:56:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=a1DfKi6G
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7B7FE1F0089F;
	Sat,  7 Nov 2026 14:56:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794063391;
	bh=oHOt4gRpwLOXAELqUZlZqALazdvR/I2IZMkVYxNRFHI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=a1DfKi6Ghov7Ml78Uu2iOXFQ5JLmRyp9ixKyyN1yt2goiu445QYikJQ4VLU6OaQwN
	 dtUI9qvswTPXy31ZXjIXky1P5L1G61ycNXb7i7kbb1kqhwSeNg1xoTg7zV2+JlU/KK
	 OkFyoVo27f1gclfxNs9qV1daXQuSJFmkNiT+5+X0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christoph Hellwig <hch@lst.de>,
	Yehyeong Lee <yhlee@isslab.korea.ac.kr>,
	Keith Busch <kbusch@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 515/869] nvme-rdma: dont complete a request after a bogus remote invalidation
Date: Sat,  7 Nov 2026 08:53:17 -0500
Message-ID: <20261107134911.014526969@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134852.069646174@linuxfoundation.org>
References: <20261107134852.069646174@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yehyeong Lee <yhlee@isslab.korea.ac.kr>

[ Upstream commit 909307cea08aff4e486cdb7491de5c76a2c31341 ]

When a remote invalidation names an rkey that is not the one we handed out
for this request, nvme_rdma_process_nvme_rsp() logs and schedules error
recovery, then falls through to nvme_rdma_end_request().  The request is
completed with req->mr never invalidated, and nvme_rdma_unmap_data() hands
it back with ib_mr_pool_put(), which only puts it on a list.  The rkey
stays valid and still maps the pages the completed read filled, so a
controller that sent the bogus invalidation can write into those pages
after pread() has returned.

Return instead, the way the local invalidation path below already does,
and leave the request for error recovery to cancel.

Fixes: 3ef0279bb0031 ("nvme-rdma: Check remotely invalidated rkey matches our expected rkey")
Cc: stable@vger.kernel.org
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Yehyeong Lee <yhlee@isslab.korea.ac.kr>
Signed-off-by: Keith Busch <kbusch@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/host/rdma.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/nvme/host/rdma.c b/drivers/nvme/host/rdma.c
index 19a9dd7caed8d..dbaf503b7de9c 100644
--- a/drivers/nvme/host/rdma.c
+++ b/drivers/nvme/host/rdma.c
@@ -1713,6 +1713,7 @@ static void nvme_rdma_process_nvme_rsp(struct nvme_rdma_queue *queue,
 				"Bogus remote invalidation for rkey %#x\n",
 				req->mr ? req->mr->rkey : 0);
 			nvme_rdma_error_recovery(queue->ctrl);
+			return;
 		}
 	} else if (req->mr) {
 		int ret;
-- 
2.53.0



