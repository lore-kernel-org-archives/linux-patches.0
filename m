Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794064820;
	b=VpVc2rlU+JOnzIqfVE3ISTJot4iPNd4afyEa9hmhpRgAOAbJbgV84iOPLaqH+HWNArHx
	 91eWzOnVj88oquQ05shv85vMNI6iEysWUq1pYVW1oQVsBBiZJ1mJlyMjZR0tKWpsCrbar
	 VSx6iLi4Ekqdaro6ZfNa1cR0qqkJ6wQ9OV6DKmxsvDexez+QgqU7WzoSHAhe5qcnSZlw/
	 f7Vnh68y9cIX55r8XRqQ0+Hatzs0K4SDqemrybAqVahj7TY5/psp9NrqF5PwR4ciqY1oh
	 szBHb1QZMrYweqy2xIb6ZKSUdUXfcd51WE9mIHsMoj8W940LHKUNPz9xpvmdrwd9OoA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794064820;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=g9cDC7ThrAFvvgOmwSVv/b6ukb7FGxZQkRn7UQvq3fM=;
	b=YFeuFmrDpVGUOYZxdvkOUSCKdn/dOJLjIS4SIBBYqgCe9eReURTjeUA+IVQtR7AdsEAA
	 Z53f1E1BJFCdEl4+3ljAB9XbEEUzYgzEw3EbtoJ3GjVCA+7gsN9DR8Ubf6I0I/ubKCa49
	 gDqkXTwyKFlSSHlDFmTi4AiZOoHxouf6RzKrCKmIjOEs3UqBuUTO2iQ8Sl8smgdOHodd8
	 +TigIrRGg3eq/gfzKY0D5bgVXSnWdW/DrHpEOt1iaaqI3jUePghG+pME6UqwKjxUkHuz8
	 P3HFm+HyZOSiEiAEuOWdZYnWgo0/2mjLgw+iARAVsNvrLRdKcScFLQ49u2nlvzQh17g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=dKsouVo0;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AFE8C606B88F;
	Sat,  7 Nov 2026 15:20:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=dKsouVo0
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2B5111F0089F;
	Sat,  7 Nov 2026 15:20:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794064819;
	bh=g9cDC7ThrAFvvgOmwSVv/b6ukb7FGxZQkRn7UQvq3fM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dKsouVo0iTarivDCUBLwy02drAvDbCQvaRS88FRULIJ3X1lQEx86e164Xf0kwmhMB
	 mt9XC07sJ1vp8AFqjVRWjdYyR6LVtkTsFmE3uYujANCw2RO0tKg++e2Cuj7dYICXRp
	 z6hSpRhUieVWxME9oakvV9XS7w9+0kI3UPqPTEIg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christoph Hellwig <hch@lst.de>,
	Yehyeong Lee <yhlee@isslab.korea.ac.kr>,
	Keith Busch <kbusch@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0707/1257] nvme-rdma: dont complete a request after a bogus remote invalidation
Date: Sat,  7 Nov 2026 08:50:03 -0500
Message-ID: <20261107134958.781526971@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134939.434104957@linuxfoundation.org>
References: <20261107134939.434104957@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

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
index 9cb811a2ce1f7..5b9b540693b51 100644
--- a/drivers/nvme/host/rdma.c
+++ b/drivers/nvme/host/rdma.c
@@ -1748,6 +1748,7 @@ static void nvme_rdma_process_nvme_rsp(struct nvme_rdma_queue *queue,
 				"Bogus remote invalidation for rkey %#x\n",
 				req->mr ? req->mr->rkey : 0);
 			nvme_rdma_error_recovery(queue->ctrl);
+			return;
 		}
 	} else if (req->mr) {
 		int ret;
-- 
2.53.0



