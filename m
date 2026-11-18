Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795042588;
	b=geUncI1sGTpj7cTTPgOgnavYhS7WlYLNW6alnB0tdp9Q2tzszPT0JKCmNwzoli+mcbv+
	 VDV71+Ss7TTE18G7X4DtJpmr/nyNms4fJ5dw2jFfGebM3FltHYnXnEStMc5K9Lano1seS
	 +tIqT4wplyJVwMRacLBQHbKOIezkqGdkfKTOMBxvtCaAKWuUnjJlKwNuSpXeZTXDcgaDo
	 yQN86qEoNDvumO9ujok9XwNAEBFDCZskKBM1AVPUBJvo6MzIaPUO7yH+/z2Dj0qa8A6Pp
	 /CBAUzJYrztA0DOdRqL1gxRmO28ZYOIFTFQYmVTIB6Nrk9flwdOKyVd8vyyLGvqe0zw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795042588;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=+cKXZkD2yasWutNPeL57SIwgFuCC4JTavlRmxISWMuo=;
	b=HWKNVA5QlNbTiC1PNaGQtlMwCA9t2G0EFOETTPhOsbXE3TIQmAUCDbJPGxO9uLovvDnx
	 ySvZjCRr38aNLQt9tD0+DjPYTzyFjBvQ9fEQdKakltNCpf7FnYMK8nXBRJybOn/Ki8Tox
	 MaqFQKgVX88HXR3jxqmDJgWSc8HIR3FOuMbcHxnQO+ieVbbJOTZR/FkgJUePKCW4TVSg/
	 Fq6NXu7qpYyjPQljfhsTS6W01PCqWWeluqgJ/abCOTqm+vDaKwYQNzezfcAPPyJ6Z5gJA
	 f53pf13nPjX9okseFu9ZYA8Lge8a4QgWM6W+yBrmfJRIDJcmw3MqEG19bZPAFWm4Ntg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=2PZ9OmaE;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 497C8606A325;
	Wed, 18 Nov 2026 22:56:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=2PZ9OmaE
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9C00A1F000C4;
	Wed, 18 Nov 2026 22:56:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795042588;
	bh=+cKXZkD2yasWutNPeL57SIwgFuCC4JTavlRmxISWMuo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=2PZ9OmaEfBqjeuSoV6WEjdR0cYrHYZ/G7oHeq8fVgSKMc8n16tdOA2fheF7TYq3w7
	 RQSQm+j5g+3jExii0PEVZG/YxOPwti1vOzGZ3qSeQACW5VPDtoGydcKFkONH6kmrsR
	 3jaEShJBekbdrN9wkhVQU2j8GMmnmX4m+Wi+cp3c=
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
Subject: [PATCH 6.6 3224/3318] nvmet: dont clear sq->ctrl for a Connect with sqsize 0
Date: Wed, 18 Nov 2026 16:04:06 +0100
Message-ID: <20261118150456.442435474@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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



