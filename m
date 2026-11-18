Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795028136;
	b=rMsIjbxbgxcsTFxebi6pWm+jLm3xs/0YHVpRV+rkQpM/97cLlh34vfSNrkBB4HSttx9K
	 npIIAueq55WfpgcXY3gArRy378yBSJlo9BIRCPQoVQTrGPzBT8Jl0GOXsHmxOPXgE5Vu2
	 PsRfHAtJinbQlc9QZl30c33JXEmq6RODkmstjaedzEyTZuwoRo7Vp2YwU3IOV7CIWZwBm
	 6vv+pFnhCLT6c0Gs1o53/PEY6Gxbs19x8iGmV7YXm+dKxt+KhWkaJZhaYdhxrDHRupIJ/
	 xMtzQfyctxT0Jw9Fxp4zwnCj6KAD26O/6Gy5CC49ge+0QMwcyS071/btNTaBBxoUTwg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795028136;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ixfRd5zvXgHqMftRWoncI7n3TC80vBYQDXovjwY/2C4=;
	b=zpyn8QdFGIBObP0CxSnSd476awTQsU8NNSWYXD2AONsoX8rUlmNsLI8XBXtk3D0++Ywh
	 5C7R3aDV5Bu9m4/KYAmROnoFoZGPhUVCkF0GpfcaKy6aYQlhQQL6mqt2XLjliRPp6kM/Z
	 SerQNFW+tdqivAjHNB/zkNYCslLvjSl02UT9msCdDSYoDkoT9TqU83vulsF+1od+c9lrn
	 EGeIe00djUKlwid1pTjrmfZ04IFlNWX8spNsZNivzIuXSmjR49pzBrI8VMUhBLJJRQyI+
	 Ki8dl/d31KsV6YhVqkIxd5OnrDAfx3D2PPqJn2XMVBlMMN5C/Kn+hpKpWo2NiJQ8kYw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=bzriNkE1;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CFF09606A320;
	Wed, 18 Nov 2026 18:55:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=bzriNkE1
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3501D1F000C4;
	Wed, 18 Nov 2026 18:55:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795028136;
	bh=ixfRd5zvXgHqMftRWoncI7n3TC80vBYQDXovjwY/2C4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bzriNkE1s9dQSkkMtRrhoWsmGoXzIV8rrv4FdE/bcE0jEDxanQ5Nyfuq1rZz1/Ruu
	 GPk0Vpd6E9fPMNVrk/jnPDJRoxqA8IoyNiIeEnALc0ybGMnYIbY0PF4E1PrOcctm77
	 x0oAkxmC+0Z16mK0VVHZjCrwUi/tmeu/NDkSNp3A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christoph Hellwig <hch@lst.de>,
	Sagi Grimberg <sagi@grimberg.me>,
	Chaitanya Kulkarni <kch@nvidia.com>,
	Chris Mason <mason@kernel.org>,
	Jens Axboe <axboe@kernel.dk>,
	Keith Busch <kbusch@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 2037/2151] nvmet: dont clear sq->ctrl for a Connect with sqsize 0
Date: Wed, 18 Nov 2026 16:02:52 +0100
Message-ID: <20261118150235.935679565@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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

From: Chris Mason <mason@kernel.org>

[ Upstream commit 89480d137bf0d943a82c64f86ae2407a15276b5e ]

nvmet_install_queue() checks sqsize first and jumps to err on zero,
where sq->ctrl is set to NULL. Since commit b71df12605ca the cmpxchg()
that sets sq->ctrl comes after the checks, so err now undoes a bind
that this call never made. Over RDMA a host can send two Connects
together and the second is parsed before the first executes, so a
second Connect with sqsize 0 clears the sq->ctrl the first one set.
The reference it held is never dropped and the controller leaks, with
its cntlid, until reboot. The discovery subsystem lets any host do
that, 20 connections leak around 10 controllers. A pending AER on such
a queue hangs nvmet_sq_destroy() forever, and a queue can keep its
"authenticated" mark across a rebind.

Return the status directly, as the two checks after it do, so err is
only reached after this call's cmpxchg() succeeded.

Fixes: b71df12605ca ("nvmet: avoid duplicate qid in connect cmd")
Cc: Christoph Hellwig <hch@lst.de>
Cc: Sagi Grimberg <sagi@grimberg.me>
Cc: Chaitanya Kulkarni <kch@nvidia.com>
Signed-off-by: Chris Mason <mason@kernel.org>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Keith Busch <kbusch@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/target/fabrics-cmd.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/nvme/target/fabrics-cmd.c b/drivers/nvme/target/fabrics-cmd.c
index 9aedab2603bdd..8930c872b5c09 100644
--- a/drivers/nvme/target/fabrics-cmd.c
+++ b/drivers/nvme/target/fabrics-cmd.c
@@ -186,8 +186,7 @@ static u16 nvmet_install_queue(struct nvmet_ctrl *ctrl, struct nvmet_req *req)
 		pr_warn("queue size zero!\n");
 		req->error_loc = offsetof(struct nvmf_connect_command, sqsize);
 		req->cqe->result.u32 = IPO_IATTR_CONNECT_SQE(sqsize);
-		ret = NVME_SC_CONNECT_INVALID_PARAM | NVME_STATUS_DNR;
-		goto err;
+		return NVME_SC_CONNECT_INVALID_PARAM | NVME_STATUS_DNR;
 	}
 
 	if (ctrl->sqs[qid] != NULL) {
-- 
2.53.0



