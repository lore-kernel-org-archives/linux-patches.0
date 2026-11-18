Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795022104;
	b=lF8N93y8mCKIZJ4qgUm/GlKhu44XEPBjfEhllbVS1z6LDBOdEziz1LDmG26l5uDobBzU
	 38h9qf6168ALIomGHxlIhxO9bqo0CHax2ljyLpc4Lf1Kx/p41rxCeOfiT+6L3SpPIQs2h
	 rG6O985wgzarCi4vAkE4wMyhHP8+dv6++XrSbEfXH9VK+FHN7WXJEtYxMmso1JIaTBzeK
	 RbU49Z/PrHXJbJPwmOvnK1m1/08ti1Om5MaWXe6rE3i7OqICSn0NzWdaUr2rBC4ikvpcB
	 hdVLExoaXqIsgHmoNR/wf8gtFXvbbKg+sqqAM0U/ICYjq/cPjOepkYHcBvMa4llKGfw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795022104;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=5nKFpulICa7BcvDjSg/ylaSH8PgQlECFdRmEFAn7aGc=;
	b=zwPpjFHg0Xxd1DkfUc+4Hj7wCam5mU+fZU7D+dFhA6DlwinOMoWQ8y9nVjXo3YzH4MCn
	 kLxeFOjAfxgWPpQ98TSPVaodw40pr/sURbVLoPi8xI2kn4MEqU+sAERFIVPoUQ5uc1e5p
	 uAI7iRtOMuUy6R2yUoa+jZE3B8/VCS5uSPjdWulYYm4vyftXXQJQfWI8zzDgvFFEyeAEF
	 wy77sLnnJbVffj00q71h72zWGeOARML9Cmi6L1/agUkgKPujHmM+h/z8lLeLlKo8ekEW2
	 wdHTJdwN8AI0Oo+HNTNFoLfBqhhKiJW9WFORLeu9El9sf9AHk2RvnMpuJuVvSLoF9MA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=OTKpWcT+;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8666C606A32A;
	Wed, 18 Nov 2026 17:15:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=OTKpWcT+
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8B0F71F000C7;
	Wed, 18 Nov 2026 17:15:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795022104;
	bh=5nKFpulICa7BcvDjSg/ylaSH8PgQlECFdRmEFAn7aGc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=OTKpWcT+5TMo2HWn87dyhXISTEpwEV8rquoq4t/GvI7nqYCxfe14gosu4w/1RIIGs
	 q5f0Wwr8X7NMVMjVm40P3M6Vi+5q8HCch5Vc0we+PvBWHHvZVS9ddDVDfoHITMLbbx
	 yvuqRTfiw9BBhdmA/135HsA9V0RMD05Kvf4Rc+i4=
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
Subject: [PATCH 7.3 2544/2651] nvmet: dont clear sq->ctrl for a Connect with sqsize 0
Date: Wed, 18 Nov 2026 16:03:04 +0100
Message-ID: <20261118150416.124514030@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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
index b451029ab8f49..fc626c2fd2c92 100644
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



