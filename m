Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795045486;
	b=NGB0esVM5nz7WFxdBPRhn0qrcYr33QWWIa6DwP7UugLxtZXpbwDGRka6A8cviW2n3oQw
	 ypNLYLksUh6FyAHEC4ISPa4XIcnqg1BISplUF3EtcaStO7hyAT5TfWNh88WccKUPlERNB
	 u74WTDFc7boPlXvaDUVuhnYHAgPgj3VXBByFlOssEfFsMnxsXXJvZODFPxQpBrKqmhJf+
	 KV8ymdOmioo1KyuyDHIDh/NYHTIcJ2gEslt0kLbafy/VK6c09B6MCONV6yiDdCCJc4uRi
	 MUv/rV89g97h1DC7dz4gzoPBNk1DDxnN2pxco2L1Qbol/jqdV+9l4QdzhDZRceod8oQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795045486;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=mXk9bPCR2dSWjcqqYipDRO/8z84DUYz1n2z9q1ux1Uk=;
	b=z7nsQltve6JenH41/yVFGmIFPxT/UwQDX3TraBfB3erqewiIV5MF/19tHyjkuikZCXWZ
	 YRyJ2aglKQkZfYCUgHhm2mWru4M6avSqbZaQjkVpMFv24xB1yOJG42UdYdp7ZvmwstKhZ
	 tYITV9yZc33tHIN96a5ZqS96UtU7shGU/mrsTU4Tj/YyMU11J0NrpSVg613Eh5TdMIO8y
	 8p0mM1Al0CvmjCXl4ZRgRBibPkZeoldt/ZgT7cLhX7+ByTv9zHpwb6CnsEsgiE2ecTfVC
	 1Fe/FagY63r+efTZBbWy5Fsmmn0aJzB3SSuvIYhQIVieqIJ/uHBVaTWyxgQW+k4LEDw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=tnEfQa4g;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B1608606A336;
	Wed, 18 Nov 2026 23:44:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=tnEfQa4g
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C300E1F000C7;
	Wed, 18 Nov 2026 23:44:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795045486;
	bh=mXk9bPCR2dSWjcqqYipDRO/8z84DUYz1n2z9q1ux1Uk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=tnEfQa4gBjGMfI5t44drVcUdV6XD8+eHDWgjD1DLllqjMWSe9aLstNgItD4iReP+z
	 q5D69Nb1vC0ntiprBx2Vf3HyERkflysvYhXQ6g0kMbJq20fFk7hyhbExy02/HdDk/Q
	 ODvVYupTB/X7+QhDWcU7SozqyjHAr8OWN0r83rEY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christoph Hellwig <hch@lst.de>,
	Yehyeong Lee <yhlee@isslab.korea.ac.kr>,
	Keith Busch <kbusch@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0938/2857] nvme-rdma: dont complete a request after a bogus remote invalidation
Date: Wed, 18 Nov 2026 15:32:52 +0100
Message-ID: <20261118150235.378227087@linuxfoundation.org>
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
index 77a4727d503d6..4524315edd027 100644
--- a/drivers/nvme/host/rdma.c
+++ b/drivers/nvme/host/rdma.c
@@ -1734,6 +1734,7 @@ static void nvme_rdma_process_nvme_rsp(struct nvme_rdma_queue *queue,
 				"Bogus remote invalidation for rkey %#x\n",
 				req->mr ? req->mr->rkey : 0);
 			nvme_rdma_error_recovery(queue->ctrl);
+			return;
 		}
 	} else if (req->mr) {
 		int ret;
-- 
2.53.0



