Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795032704;
	b=L/r/NbBewltFUQGnvyoycK+3WLTW0CuFDxkxiR7cbfMx5xcrJILlQfGgw143BnhSNHxm
	 qFSONLtgTorYJOfk9/CpcNwGPlKkuxbBKoHqc+oi7/YXNXA5jmBgEGDIx3nAZuizjTYM8
	 L+swQOfk39fY/iP2FuOMaJQNjUJYiPmboDQDqRbduUXHHvkLJrX2T8SlTMzdL+BTiLwle
	 tP2gsqZp2pxPNGZOOq/uUrLo/16XWB0vbWutT9CWDCbtoGQQss7u7OgbJDUa+q7Q/44Gv
	 a2pdiAI0MMEkZHTG/ugPhPwwNU4lRlreFXm3zcpJVimztlvOu+B08sWMppL8G/ltuGw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795032704;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=tiFu1Xu38ljEhbW5nFkw0Slq80KN55Y8lKbRdUJ7Cto=;
	b=Yeom8zpKZvtKEptXQUUqVvVA4VFGwB+wizeWh2U/FCf6rCYaE+WR4OFCjNK3n+Ec0vdk
	 mvuqLxpoU2GHty8yheD4N1HxxlajF3uWYlqv1KFm8i6huua8kP+OkqT6HDb+kY1tPgqVD
	 jsRnKotaC5B6uCB73C1r49ddYGtp2iKVkqke5w4oss1Y9oCR2kr71QavqOLhFHGUOFcPC
	 dRDtN1Nb6TR8RxEdWbSUA6gn6AT/DuEm5CcPVeQOe5MNVkGc4bCe/KpqtVHEEVqPKyjrY
	 9QmLesA9muI6/Ilw6kHxle+qM7y43MkIApqE7XF4E3txvmqOcbZSnkLpPaMlWVpfVug==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=OZtQ4Ngn;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 076DF606A330;
	Wed, 18 Nov 2026 20:11:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=OZtQ4Ngn
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 56EA11F000C4;
	Wed, 18 Nov 2026 20:11:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795032703;
	bh=tiFu1Xu38ljEhbW5nFkw0Slq80KN55Y8lKbRdUJ7Cto=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=OZtQ4Ngn2ob8RUrcnNqf5Rud788xG4+gdIjHcZIj8KtgqdoZEUxCzr0WhimkUir0b
	 UYw2ezyxEG6ZlHXSTtlw+wZMZh+tb2rcRPypZXrztthO3I7gdTAfjvcqCes6onL6Sc
	 LL5kxcWfX8PeVLkxUfY8RqGKPrChBAYkbv5D6Q0s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hannes Reinecke <hare@kernel.org>,
	Maurizio Lombardi <mlombard@redhat.com>,
	Daniel Wagner <wagi@kernel.org>,
	Keith Busch <kbusch@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1504/1756] nvme-fabrics: reset io_queues before computing the queue mapping
Date: Wed, 18 Nov 2026 16:00:31 +0100
Message-ID: <20261118150108.793981585@linuxfoundation.org>
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

From: Daniel Wagner <wagi@kernel.org>

[ Upstream commit 9588769af5fc8ac12290d48ce1014a78916681fc ]

nvmf_set_io_queues only sets the io_queues entries of the queue types it
hands out, but the array is reused on every reconnect.  When the
controller grants fewer queues on a reconnect, stale entries survive and
nvmf_map_queues maps CPUs to hardware contexts that don't exist anymore,
which crashes blk_mq_map_swqueue with a NULL pointer dereference.  E.g.
with nr_io_queues=8, nr_write_queues=8 and nr_poll_queues=8, 24 queues
are mapped 8/8/8 (default/read/poll).  If the controller grants only 16
queues on the reconnect, the poll map still starts at hardware context
16.

Clear the array before computing the new mapping.

Fixes: 6486199378a5 ("nvme-tcp: fix queue mapping when queue count is limited")
Fixes: 5651cd3c4336 ("nvme-rdma: fix queue mapping when queue count is limited")
Reviewed-by: Hannes Reinecke <hare@kernel.org>
Tested-by: Maurizio Lombardi <mlombard@redhat.com>
Signed-off-by: Daniel Wagner <wagi@kernel.org>
Signed-off-by: Keith Busch <kbusch@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/host/fabrics.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/nvme/host/fabrics.c b/drivers/nvme/host/fabrics.c
index 78bba4b3cc933..5e8f2edd5ace3 100644
--- a/drivers/nvme/host/fabrics.c
+++ b/drivers/nvme/host/fabrics.c
@@ -1097,6 +1097,8 @@ static int nvmf_parse_options(struct nvmf_ctrl_options *opts,
 void nvmf_set_io_queues(struct nvmf_ctrl_options *opts, u32 nr_io_queues,
 			u32 io_queues[HCTX_MAX_TYPES])
 {
+	memset(io_queues, 0, sizeof(*io_queues) * HCTX_MAX_TYPES);
+
 	if (opts->nr_write_queues && opts->nr_io_queues < nr_io_queues) {
 		/*
 		 * separate read/write queues
-- 
2.53.0



