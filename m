Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795052669;
	b=0+mvUMO46pn42sW6n88P69QMDXim0HisqjQWprzzhzB8TDQT599+k4JxDYhs9/WVK0+7
	 l/WHmKvpOnDxIJZYBnGY+mAu/T8tP9qaY9grJEF78xmd3w2+r8pXDzlLS2vV9H4AQcAfW
	 JRf0tPqfSYnnSX9o1yFC7OsI26bDGIQNwFOGZOi+XbyQbg4SOG047sj2+nhGHHzIVPAzr
	 Uk1eRXQzxS7CmJZG5QyLC+h4cb/GAXXEIozUZ8c0oL3sqqpGOBrLmMA7Ci4pq/qMSyO+H
	 8Q5L2aFuu1B7dtMwRHBFflfrtIwLx14VVI4mRFgaBTvtXNpHjr1+OhQxxW2Es/GlKrw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795052669;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=/q4wO6tWU5evgvgbWmZXTOgdXtIIhG55BZJ+BrtHHwE=;
	b=FkVVfRwcQBh82PDIHTRDS1o4R0xHDLBFdbkTo+3YAmxT5JcqZP+gHmwpomquTwsgGq1J
	 b4GmmvW6QI/AKvFrg37VUvRlzzWRRQj3koMWz4eUpIyaXgOReUErM/neDjycNJM/0VWyu
	 vvwE4eQyI4hgFTiXS+u+Q2Tmae7aT9Z5RZSFfsN4afpnzdAwfM/mEQlQLVtDIjus9sstE
	 dGxdG1cYL+giZ6cXeMK+wdkbMzi9P03CODnshlIQk+td7lBYu8rc+Ortkcfuxlyk3xlt0
	 4Ipl92nfi537rnwqgeMRzAEym5tmrLNec0lMEgLatdjXj9OcHhNDsvip2nh5Q4wmL5A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=TCDgGzfW;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0997060A2602;
	Thu, 19 Nov 2026 01:44:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=TCDgGzfW
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5AD111F000C4;
	Thu, 19 Nov 2026 01:44:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795052668;
	bh=/q4wO6tWU5evgvgbWmZXTOgdXtIIhG55BZJ+BrtHHwE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=TCDgGzfWGHF0anVJ0+DfQV7DlbsTlVKnoolSUI2vEQi/ghRq0tbA1j8gD0G6bebeS
	 cEEAQtpsISo67Okyhry/YsPLamnkg0CW1eiL+kvbMkss5fmnZ2Vl9/ST7yGAlXjnGR
	 gSyDHrPdtaL2HgLuvQtnGby9iGmQHXa++x3MkJbc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christoph Hellwig <hch@lst.de>,
	Yehyeong Lee <yhlee@isslab.korea.ac.kr>,
	Keith Busch <kbusch@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 0629/2214] nvme-rdma: dont complete a request after a bogus remote invalidation
Date: Wed, 18 Nov 2026 15:38:25 +0100
Message-ID: <20261118150036.526109190@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 40932e82c428e..283c5ab7699cb 100644
--- a/drivers/nvme/host/rdma.c
+++ b/drivers/nvme/host/rdma.c
@@ -1765,6 +1765,7 @@ static void nvme_rdma_process_nvme_rsp(struct nvme_rdma_queue *queue,
 				"Bogus remote invalidation for rkey %#x\n",
 				req->mr ? req->mr->rkey : 0);
 			nvme_rdma_error_recovery(queue->ctrl);
+			return;
 		}
 	} else if (req->mr) {
 		int ret;
-- 
2.53.0



