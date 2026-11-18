Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795042411;
	b=o3rCPQCvIC3//58pR8KoK+8sZqYPnCvTjHvOwfasBTaBwiiZ/RQauRvkCNydWbyEQk5R
	 pgVzsolhh+JNwZZGZBZU8ud6QOaJ0FmNGkhGpZjZRoUwT/+3RDeDRp0+B6RUHUcjaeI8e
	 6lD7Tw5azFGSkGcvjWSP6BhZu+SMXDZrtbEx3YlAhg497NPJrV/axXQ94FdvQ2Oi5Vvb7
	 WzarL9+v2f0QMR/4CKUF7usnN8Ftack+/7pTPPVT243ghA+9I6GdUnV7gNYfSdeKeVueK
	 ioPrLIHCtWJrKRpkcGyw1EZLM6tKkyTmq68rCzqgUPyCLfdYACgaxmN4tmgHQsYK3HA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795042411;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=GR344X7LX4/e9YjpE8ohP94NJ2mHpJiFPnWYnUcmNzQ=;
	b=FfdGmf+aILZRL4Y3f5Npk/12TDXEzrIM5r4Xwqe0IAf4upBvj3T8e9doNQ+en8fQ4A+u
	 TvrSF0VHiP640cOsFjh4Vayi5nic88IJ40fcd0BwbgdWrDKAn59sWAsmJ1ztScYCGhDnE
	 7jgIoXNSTGSuZK4V5PY+D2JYQbNNymThFqKrhrwb8s2YiQFMKnwI+yHDznFE4eehlzWvz
	 TbDrgqLg+yDjYVGnB7tkOB/cOHR3rZPAJEtyuc5uF2TGkbUMwqoZ7KJiKfQ0b3pSvjG4y
	 S0LTrrV4h7Z8OJfMxkckyHqCVfeppTESriFXAxH5+mt0qWGMyULi6hy5/vW8fEXxf/A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="Sg/IUM7q";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CFE7C606A32A;
	Wed, 18 Nov 2026 22:53:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Sg/IUM7q
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 307FD1F000C4;
	Wed, 18 Nov 2026 22:53:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795042411;
	bh=GR344X7LX4/e9YjpE8ohP94NJ2mHpJiFPnWYnUcmNzQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Sg/IUM7qz/A0akb56LogMrPlDPM2cU8YGtPVG7KOG8aokpB0kIiP3OpPmfRxVh64G
	 lEvln/kmfyN+TnYRsFH5fHYT70DVsrc2iUIZ2FSVhmG8A5XK+t4UGPL4XsPswHqVXz
	 b93Xa+D3Ry2YHGoTXiTlicb+PdLjt0eMDfRhvPqA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hannes Reinecke <hare@kernel.org>,
	Maurizio Lombardi <mlombard@redhat.com>,
	Daniel Wagner <wagi@kernel.org>,
	Keith Busch <kbusch@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 3120/3318] nvme-fabrics: reset io_queues before computing the queue mapping
Date: Wed, 18 Nov 2026 16:02:22 +0100
Message-ID: <20261118150453.539409380@linuxfoundation.org>
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
index f910db503294a..6641ae68cb917 100644
--- a/drivers/nvme/host/fabrics.c
+++ b/drivers/nvme/host/fabrics.c
@@ -1016,6 +1016,8 @@ static int nvmf_parse_options(struct nvmf_ctrl_options *opts,
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



