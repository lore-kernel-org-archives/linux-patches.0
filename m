Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795027694;
	b=zXs8++IFEC9s5ZecZ1g2X8siPaQK3rbhxcV45q7UhiJJPJI/SlyJYf8UBwaDUJ0Ixfm9
	 bWzidcQP2i04GHqRmD1e2CDQR5mc3NmL0aoGXH8aSA8I4v4aauOFi3Gvmet0SgjYREdiW
	 nPXhxWnHVcrOpmRNseF5B6qfF64V4h6EVRt6SwK5wzD9AVcfemqW+O3sfUKBS8oXBc3/y
	 sULZ9PB9EPqloleKLnFEveBfI+JZTDn8h703BqmlApBU1MB0PojbhcQiNcLqk09FMONkX
	 HoWkHaSVkmCqg4GLZFmNNZ47B8F73V+gPcswU+Xi4kgVRp8HavXbuzzWbqfJ8YBWYkA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795027694;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=evlmjINWQl2fBTP2cl7S57XOl1Rc6wPIj2Qx8IbqiHA=;
	b=QNjjEN6cCVPZfbv9+EZMDavxeqz/b0dR55vTzgEAIQ90Cjjv1DD3vHyKa9o5SVH2nVzU
	 ZrvoMwVAbFzFRwpTRJZvriEphmZQfZuXWL3vjlFdZxc9EuG9v4EZHurr0iTSXLmo6A7Zm
	 68cfmbESPY1cVXQEYFPvHucoGS5Du59rTjlwm9oEsQvn8C4S/7Wf77Cd01tNThLEr39lt
	 +HOEYNGMOOg+jw/PXvHV+sIBvEe1MDDBgwh6K9tKZuqTr8YOu5qDxFIDXdULUUmt2Uhp7
	 bZ6NNqeyrL8BCQwdcMdloWEvuXBXBDJ+1mabOsNY4B8T4eJSppDmwt2yjjvsy7WwQ3w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=hz+RgMdS;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7133D606A32C;
	Wed, 18 Nov 2026 18:48:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=hz+RgMdS
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BF88C1F000C4;
	Wed, 18 Nov 2026 18:48:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795027694;
	bh=evlmjINWQl2fBTP2cl7S57XOl1Rc6wPIj2Qx8IbqiHA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hz+RgMdSDSkLeXWr9juRyqbejC0krf3IodXRqoSDW2X7P7LScNwywTCdLZqZs0br/
	 iY0PvuLsvGPZO43Z1+anSIIRqLmTHqyAxrEWVLVQcwWKNO2VKB3FpgLcWH4MyI5bPJ
	 0Y4LUmEqVbAK4r426Efk0YSVcJPWBRK+ajq15d+Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hannes Reinecke <hare@kernel.org>,
	Maurizio Lombardi <mlombard@redhat.com>,
	Daniel Wagner <wagi@kernel.org>,
	Keith Busch <kbusch@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1881/2151] nvme-fabrics: reset io_queues before computing the queue mapping
Date: Wed, 18 Nov 2026 16:00:16 +0100
Message-ID: <20261118150230.318993611@linuxfoundation.org>
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
index b13b455ee8299..9c3e0c755ce54 100644
--- a/drivers/nvme/host/fabrics.c
+++ b/drivers/nvme/host/fabrics.c
@@ -1125,6 +1125,8 @@ static int nvmf_parse_options(struct nvmf_ctrl_options *opts,
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



