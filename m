Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794062337;
	b=4AmydGmQMKvp0NrgK+T3AhL1HC6oTn5xOu0HT196JxzjT/Rer+hWrTCraBBcn50LyJYR
	 tkf2LE/lbNNnLEz6MosCJtvzi2BaEo3+yqSCTMEKqF6S6CppfPCQo4Zd3fhEJRnQKl43g
	 EjjcNWp+A5fTVYsO0ReVT8mAok2x8cvINWI+Z4ZwDke4n92ZIUQhV5pbCsNjKJGIXe1+G
	 zvDitkJUKBd5MRjhXt5dvQEZyENnwbF81HYNa7Spt4Ivm7ACQBxzXfghFeW7NHURmbvxg
	 +EI8rwcujE/e3Ghh0pP39nDfZl/aEEPMSItzm8vHr2TbIjk3FfaVLoX7XrO53Ai0BCQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794062337;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=DBpSV1rWo41+d3XELdJzeZoLGuROv8mXIH8/SXqc1/s=;
	b=bX7x52NzUG4FsCk6QvmmW5QTTqfjlDuHjyLgh57i4nG3ImRqEpbfZs6CFsPthHxlHOZp
	 rWoXSvz4KmUkgAg5/zBHiRMd6yPB9pLWJwfRsar2KtrCcr9dzg/eotk1zseLV4DzWAdfn
	 FJZFWcuoNEc8SuiM/+5bxSZkRVqn0FeO9P5HgzbyZM8fGGQsK/nm2fPM3bh1uBrgSLgQE
	 c19vwu6UEJbq6onMvHXTfGbGNR4MI2jcJTwkecmIZBkLihCkEuk88rhOoHjrUIYs6CDbs
	 CEHODvPTe3BO1/NAfkULXbNHvE8NwJXZdyY95w+XEvZ4hwfv2Bz8JkcVpR7MUDi1rDQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=xcJuKVOi;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 74719606D807;
	Sat,  7 Nov 2026 14:38:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=xcJuKVOi
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 202381F008A2;
	Sat,  7 Nov 2026 14:38:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794062337;
	bh=DBpSV1rWo41+d3XELdJzeZoLGuROv8mXIH8/SXqc1/s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=xcJuKVOiGofhkAkquj8smLm5fR9MqZklVPm24L9l/gYR1kISPjpcGqwx1AXK7UMfi
	 LJYYIkcq2zLIXs674JyspVR1Ymb8F49nR8R2OeOfxBoLP59IayLh9croujTY55QU6f
	 a2FHyZPNp/v6WxULyWGdehEcIPZL9+aCiaAeXe20=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christoph Hellwig <hch@lst.de>,
	Yehyeong Lee <yhlee@isslab.korea.ac.kr>,
	Keith Busch <kbusch@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1266/1536] nvme-rdma: dont complete a request after a bogus remote invalidation
Date: Sat,  7 Nov 2026 08:54:42 -0500
Message-ID: <20261107135033.330527997@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134957.653319350@linuxfoundation.org>
References: <20261107134957.653319350@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index afa71191cd112..15c7efb0503f0 100644
--- a/drivers/nvme/host/rdma.c
+++ b/drivers/nvme/host/rdma.c
@@ -1714,6 +1714,7 @@ static void nvme_rdma_process_nvme_rsp(struct nvme_rdma_queue *queue,
 				"Bogus remote invalidation for rkey %#x\n",
 				req->mr ? req->mr->rkey : 0);
 			nvme_rdma_error_recovery(queue->ctrl);
+			return;
 		}
 	} else if (req->mr) {
 		int ret;
-- 
2.53.0



