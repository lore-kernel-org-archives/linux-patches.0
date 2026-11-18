Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795033077;
	b=pgeUHX8XU2Y4ytzPKOWV0fy0dJm+0X8mY9jd1YugH/HFZqu3jbZlxIovOOeXNyqAFRZS
	 fsRhDwubCrJNB289cRwWybv5t+XayWpk94bB28JUSpftnwFmxxGHyYlfad/CrErm44bvY
	 ipHCqd5K4kCSrm1y9JOMC60eWdSgmPsXEnUzQqB0YjTVoOJzmPTVQVJCKXqNrbiLtZReP
	 M2De7hPHqAJFk6Ll/URmNCDmXDPcCYdnKvmxM54MlTzriXzeA4nS7UAkSW9u8+ArzkYqe
	 6vKdmTsNp7EpHZl2ubCs4KF8tT/AOxHl0Het4KbH4D3CbK0uidE8MLdXeuu3TYjyWhA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795033077;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=MHXoDhcKApm769FeYGts+CTT5p5AZZDGarUvWefVIPE=;
	b=dYrAsDa5zVXw82sm9VAx3+HWGzIF7wknBZpV6f8t8/fojdaZ+gKJiaYdPNAllWrNXPmN
	 +1MXWXmN6nLzZx7KUGDaCeEOomcIthP+ucMZ3qsWI7UL4VuPvuhYF93FAAN8Y33j7rplP
	 /Tl6xFxHQ70SjAfc0OhdC/TFh+i2r5Je7DMzHLW6wpXXMVOcNBJRj3F5TnSa8Bgez39PA
	 awzesMIo2KF+wLHlH+iLEYQYC5Mw3JvglzDbjYJZbAsI8WwkFsXKdWawgaDcwBQyT737a
	 ADxUWEsry7P/03FeQnL+5tdmKfRhn3t+kqSjxXhSKsfDI8xDL0Yh7WWE96wL9J+IEcw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=pCFdTh+y;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D51B7606A320;
	Wed, 18 Nov 2026 20:17:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=pCFdTh+y
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3654A1F000C4;
	Wed, 18 Nov 2026 20:17:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795033077;
	bh=MHXoDhcKApm769FeYGts+CTT5p5AZZDGarUvWefVIPE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=pCFdTh+y2N7CGh4qC0XkfPopVlwKspxEupwyZdDAxXaoVuCdLauXxMGf+kSSBtxC7
	 IK5SZ9PkTrnm7D2TswClbCqnRWFpsY+TqHZGYx7j24AwjPPzqS+eYn6vs2SQqhTkI5
	 wIFGjki0NTx/bn16tGjFeggoXU7Nw+SJIVgyJ+xk=
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
Subject: [PATCH 6.12 1638/1756] nvmet: dont clear sq->ctrl for a Connect with sqsize 0
Date: Wed, 18 Nov 2026 16:02:45 +0100
Message-ID: <20261118150114.981159362@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
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
index 66d0dbf7ac733..9fcd4158c2663 100644
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



