Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795056930;
	b=gF710xCZgfF8YrjZfbAZJSpc9GY87q7jjIlBwF5d2Z+GNgPQmUtF2HEalIkvJyaePYZA
	 o9epq21OLSEXYQBsMCAXePJFOJ312VGaggh8ZtOS2T/PPXHM7E5SY1JfzpoumCONx6v9Y
	 6uWxZiAVBrwINvmaaOLsBoKqUae3bba+bCIC+A7Zspq4kb/NufkOU770VVVLlMB2nubR+
	 1FwJEE55fY0MyjxID9x/POvKtq5+d36Q4SKmaP5yj1mmIc8cJti58RfQ7kOF75yI/GaRx
	 ZatccGHHJdYO7SzoGvX0ZcWD8L24qdRgahyX0I1NAa6zb/X3CLBa/lZfy66dzSwFvCw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795056930;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=zEXOvJHuoamxcxnAre8ccGGVwTmrXTP4HpWfFq5hPGk=;
	b=luJfFyVjGr6EDgl1ldAuTbgAusNPAruUzaIy67B3ioqPWv9u8unxxVTX7MMtfUzTYRNG
	 1YjI29Oa9xrJXEf0VmaFGpWRLqD7e1lh4cQgFWzJ05zB+KqgN95xP0swvUuZxIl1TEJCe
	 FErt/hqnmol81TNlPyvXC6b8+V5sSuDn0Ir/o+9oWTpzBs1WhQohAfx+OWcuCdvrNewxe
	 FZc0gBKlCwJP9qIV0Yj3dGW7aJwRo8vv/nwiW0nM7yAz5El/qRn4ylgs+BCQ30uwT6bBb
	 ScSxRSMbuaQBzS+74/+WSxKTq9KhU21Q2F8lxsL+8i8BTDpcIMKtYgHuG4mu7p9WrOw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=vin1uq4g;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 788BB606A31C;
	Thu, 19 Nov 2026 02:55:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=vin1uq4g
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DB38D1F000C4;
	Thu, 19 Nov 2026 02:55:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795056930;
	bh=zEXOvJHuoamxcxnAre8ccGGVwTmrXTP4HpWfFq5hPGk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=vin1uq4g1iWORBPMTe42fuOgL1cwf8Pnw4ghnsmLAsp8OXeG9n8iABXVrZjB/rO/Z
	 kVDmLWaEsgS/pYMFD6pN4TWFgbke9Z8Wl9NLzmKQkxUc1gKMhmGzBH+DGbI/av6wvP
	 zqY+H1E+/5VcmNTsla55icF/9AdAtJKQiF9i97gY=
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
Subject: [PATCH 5.15 2161/2214] nvmet: dont clear sq->ctrl for a Connect with sqsize 0
Date: Wed, 18 Nov 2026 16:03:57 +0100
Message-ID: <20261118150136.891761574@linuxfoundation.org>
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
index cfc3e979aed25..200521d589576 100644
--- a/drivers/nvme/target/fabrics-cmd.c
+++ b/drivers/nvme/target/fabrics-cmd.c
@@ -116,8 +116,7 @@ static u16 nvmet_install_queue(struct nvmet_ctrl *ctrl, struct nvmet_req *req)
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



