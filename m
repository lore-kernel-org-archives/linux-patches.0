Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795021502;
	b=hSjgQWJHmh9HQVIRjX5wf9CI1eBD1CW+asKkOaroWaAGbAq6ZCjAadlFy2iEOxcm7s5t
	 IvlIAhhZMYWUI4wPk17DEwUW/3D7XRfI6P4f2lnjMB2ytF7kOSNTNejwSzfn6Vo5A5qeP
	 DyMSGlDLlI1wiXfLQtX85LYNW5bKzIo9q9Rf7ozW2ZxylOnHvJxxIFu9WK2Y1QMsbWi1p
	 BMHaFOp54ERgNp5H/6Nb9HjwVv4+4bky0Vnco90SeXDYvUvU1gE3d+dAOtLx1Z48COOtz
	 2/9q72OYg4XZmBlnAs6mTiZcB/qdP8sgc8fZGv4Tb/XXFbAIJ/o82kZc9Iu5lkgJ+WQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795021502;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=iOYg/6oPvw+m/2GSM5ljKboGMOeEyU0GzMfv9SRriS8=;
	b=BBItgw0fk5XcrWll2beMbD/62B9Xyty9wOw1NLRWo1eKFf2PgZpfE7nwzrsMLDiGrymi
	 kC8tFhObMg2a37DdycnnrjhfDrGV8iR3YzVFRLIne9r9RXeIJFUTq0Yxzf93EUpGlyYVW
	 HRHSzqsIx77pu0GaVLv+ss4wAsLNXPAhB6gdkvHxLbjO2a0UNg2m6KFcZK3VY8PjpiaUg
	 +dAo9qyxsmlWw5vt58q5/oCbqd9tprfWdrHk2hDrZJnLOwpTQE0wJWPN7kyl9isQ20yt1
	 z78y8TufUujyawAjc7ccUEzkMiO2x3hlgvdtZwFMnEy+LwStItOIwQje3CaqgCkauDA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=1tzNxYil;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE7D760A262E;
	Wed, 18 Nov 2026 17:05:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=1tzNxYil
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 67CE31F000C4;
	Wed, 18 Nov 2026 17:05:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795021502;
	bh=iOYg/6oPvw+m/2GSM5ljKboGMOeEyU0GzMfv9SRriS8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1tzNxYilF6/78reyU0/v0uohAWT2fcF/+OI2wMlAOEa/rDmx2q0UsSax1ES4usC7O
	 I9z0KoIR+CQJqUwV1fjfTjvI9aIiIgImkqcVLDkbwYpsMVoiAsaVfj/XctwppsSQDT
	 UKQpF/NXF3R4ohAjl93eU6ZxTsci2FWR4jqz94jw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hannes Reinecke <hare@kernel.org>,
	Maurizio Lombardi <mlombard@redhat.com>,
	Daniel Wagner <wagi@kernel.org>,
	Keith Busch <kbusch@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 2331/2651] nvme-fabrics: clear the poll map if no poll queues are mapped
Date: Wed, 18 Nov 2026 15:59:31 +0100
Message-ID: <20261118150409.052227718@linuxfoundation.org>
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

From: Daniel Wagner <wagi@kernel.org>

[ Upstream commit 36ede1aa85d5d74c39ed375a906f6eadb15cee5b ]

blk_mq_alloc_tag_set sets the nr_queues of every map to nr_hw_queues.
When nr_poll_queues is set but no queues are left for polling,
nvmf_map_queues skips the poll map and leaves it this way, with all CPUs
mapped to hctx 0.  The queue then claims poll support, polled I/O ends
up on hctx 0, which isn't a poll queue, and hctx 0 is marked as a poll
hctx, so even the Connect command of the first I/O queue is marked as
polled.

Clear the poll map when no poll queues are mapped, so polled I/O is
rejected with -EOPNOTSUPP.

Fixes: 1a9460cef571 ("nvme-tcp: support simple polling")
Fixes: 5651cd3c4336 ("nvme-rdma: fix queue mapping when queue count is limited")
Reviewed-by: Hannes Reinecke <hare@kernel.org>
Tested-by: Maurizio Lombardi <mlombard@redhat.com>
Signed-off-by: Daniel Wagner <wagi@kernel.org>
Signed-off-by: Keith Busch <kbusch@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/host/fabrics.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/nvme/host/fabrics.c b/drivers/nvme/host/fabrics.c
index 27a8ce51d2b35..3d7ad86c1955f 100644
--- a/drivers/nvme/host/fabrics.c
+++ b/drivers/nvme/host/fabrics.c
@@ -1199,6 +1199,13 @@ void nvmf_map_queues(struct blk_mq_tag_set *set, struct nvme_ctrl *ctrl,
 			io_queues[HCTX_TYPE_DEFAULT] +
 			io_queues[HCTX_TYPE_READ];
 		blk_mq_map_queues(&set->map[HCTX_TYPE_POLL]);
+	} else {
+		/*
+		 * blk_mq_alloc_tag_set sets nr_queues of all maps to
+		 * nr_hw_queues.  Clear the poll map, otherwise the queue claims
+		 * poll support and polled I/O ends up on hctx 0.
+		 */
+		set->map[HCTX_TYPE_POLL].nr_queues = 0;
 	}
 
 	dev_info(ctrl->device,
-- 
2.53.0



