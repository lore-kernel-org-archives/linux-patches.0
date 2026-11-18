Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795050640;
	b=hMOfSUXverDZnHtFFOLO3d0ChMJWUCW/U4r2XXCdeEcTBM+I/aMmZOzIHklXth2heCFR
	 HIhmyc3/eBeu/YmjRpfXrMY13Atj/TQpFPJVrBEnMMOJapf4reMcUw1DGNnU32pyddb7M
	 Vl2z8A8nonOIUIsX4OgH36QdlTQ2YLYwO6I6/ncXoir1UY1CK5hjMU2BguAeU7x+aZGm3
	 H1kerJ0j/Ecgs4fTdo0X2UcdsxIlYI2I2JMapZmVWcIX5yJQi44WcHwWrRUlEw5bU6v8J
	 MBVODhieY76Qm64qM2HO2HwimlPM3XHy7F+oPJtyy+YjuYip/3z88CU9k+Lq3JaE1SQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795050640;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=4UdT0jr242gB5DgHhJimVB6mmmsyHfzrGRGPyJ7Mf1c=;
	b=YqHyFNk2ZvAJtXHMqJdaTLzrg+I+R8jIlXuM+aHZZV+7DlrrT+bc4Tjab57x2/qpHMJc
	 DXJXp5kfbRSjzasxVYs2OjTbh3sAHhVkRai2aZykoMnQuP2sTRBYWDROcuC0F9z7bo76D
	 1sYu2GYNZBRMuwtaDIbfs3ez+9SkhI0uY2vjtZpCIUm2AtRo2m5zrZHNITbvufzAxEcfo
	 LLVN63BXhZK2uhIgMHHT2zUG5kiK4Wvxjf3RJOsd+xv495fiAk8U/L+Ns6Wp684s0uj4+
	 DG325nSF9hZq7z7hQPgAJmvKDNBmH00JTkSTp1JIDvUMBQN21QW5t3l5QMlspIISoog==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=h21EpKsW;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D75AE606A320;
	Thu, 19 Nov 2026 01:10:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=h21EpKsW
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3AC301F000C4;
	Thu, 19 Nov 2026 01:10:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795050640;
	bh=4UdT0jr242gB5DgHhJimVB6mmmsyHfzrGRGPyJ7Mf1c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=h21EpKsWJ+eU4GpnjYv+2U46vICT0IiXBsqHjS0N8LFU/SDc5oamjk4cn9M05ASrt
	 JQQr8FMrqfd63h+vJaLNbzlGvDyH8Eg9/2wjmhl3eHRyb7d/s0VH7IrHbHcbJFF0Kg
	 1pX4stG9b1qcFxjLBZsIm2fBdQzpCwPvJoghceRI=
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
Subject: [PATCH 6.1 2780/2857] nvmet: dont clear sq->ctrl for a Connect with sqsize 0
Date: Wed, 18 Nov 2026 16:03:34 +0100
Message-ID: <20261118150341.701876456@linuxfoundation.org>
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
index 7807cee08790b..2c6a1c0bc7a67 100644
--- a/drivers/nvme/target/fabrics-cmd.c
+++ b/drivers/nvme/target/fabrics-cmd.c
@@ -179,8 +179,7 @@ static u16 nvmet_install_queue(struct nvmet_ctrl *ctrl, struct nvmet_req *req)
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



