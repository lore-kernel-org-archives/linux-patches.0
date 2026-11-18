Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795053074;
	b=B3xcEom+adDEoFfRDYg4UMU2iW+1AoLPibrtpguZk7tVAzvGQRZqmeNyNFPpFxxrh31G
	 6/2An8F+2/QgOz3qPnWM29Ia940sD+zu0k1Nx1md1n5TZhU/zQKLJn+r+IpGyGuPvyHCw
	 4sy6LvHbp5o22TinEANhL2GH+za50+pT4+sC2JaaO2xQ0OvH4AoOtI9sAUXMGoibErUVi
	 YvgLwiPBTnS+nmIjH368vmtd8wvBKHrUsdpmeNxKgTWnMekBtD/3GaDdXxwwpy+R8m9uo
	 zdM249QSDTAmK4eWHv7Njkpp/JPOtTK8sTwTYQmqfbsHBsa1P8WU1W1uP1QcD5a2byA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795053074;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=X3pi7L2K5cfqtb0llPUepprrj4zuv9oXd4jerHNAdy4=;
	b=pJBYafgKjIpGuUI+CuVh6zL3b1US+LM1MpVz9m6JW+jbvQ4FmcNx6FDsZavP9r1QBqlc
	 JaS/XWy3a/p3N8zhRAr54v56MObOAYngNIg5IsNG+XoO580OTOEI8gOfwAIn0Sp/f/LHM
	 OrRDLI0D3MHqLap37XXrHeRK2DzXA3eFtoxBVwT4QogYRFxSNeFcjd8zctpcieDPgsqaD
	 cuncbXuAGPR5DiL4pbNiV9VXvvTXpeh0rdf7tycuPCFfX3gM61U35RbWgTFz55pNglfbd
	 utEO28TVsxh7SWdPS88FBMQLbAjaovFWyBR/J206PlfVc/Kl+KVttfEYqi42zOSy8AA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=vVA249FK;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E0BF606A325;
	Thu, 19 Nov 2026 01:51:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=vVA249FK
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 29C601F000C4;
	Thu, 19 Nov 2026 01:51:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795053073;
	bh=X3pi7L2K5cfqtb0llPUepprrj4zuv9oXd4jerHNAdy4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=vVA249FK2vy2pIE4QxJLh4AGglVjjdmgUxLbvnelDp+CkKu3ELR1/BPpWkjlQ/rse
	 2OS/F/B/jv45DU9yqw2uvlAN24zc4qX0tmmVWIaOcy/PIyaBxcmrNMbrmrZug+d76f
	 +mmYLqOmxD4oEJPx9wwqrNTRF3hkMQVLvRFWXTUI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christoph Hellwig <hch@lst.de>,
	Andrea Parri <parri.andrea@gmail.com>,
	Keith Busch <kbusch@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 0740/2214] nvmet-fc: only send read data for successful commands
Date: Wed, 18 Nov 2026 15:40:16 +0100
Message-ID: <20261118150041.425719910@linuxfoundation.org>
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

From: Andrea Parri <parri.andrea@gmail.com>

[ Upstream commit 94f93c61b1a5dd08d011be58172ce4392b849008 ]

When a read command completes with an error,
__nvmet_fc_fcp_nvme_cmd_done() still pushes the whole data buffer to
the host before the response. nvmet_fc_alloc_tgt_pgs() allocates that
buffer with sgl_alloc() and no __GFP_ZERO, and a command rejected by
nvmet_check_transfer_len() leaves it untouched, so the host receives
stale target memory.

The buffer is as large as the data length in the command IU, so the
amount of stale memory returned is up to the host.

The tcp and rdma targets send data only when cqe->status is zero (see
nvmet_tcp_need_data_out() and nvmet_rdma_need_data_out()), so no nvmet
command can rely on returning data with an error status. Do the same
for fc. The ERSP then reports a transferred length of fod->offset,
which is 0, matching what nvme_fc_fcpio_done() checks on the host.

Tested over nvme-fcloop: a failed read command no longer transfers
data and still completes with its error status, and successful reads
are unaffected.

Fixes: c53432030d86 ("nvme-fabrics: Add target support for FC transport")
Cc: stable@vger.kernel.org
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Andrea Parri <parri.andrea@gmail.com>
Signed-off-by: Keith Busch <kbusch@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/target/fc.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/nvme/target/fc.c b/drivers/nvme/target/fc.c
index cfd1dc14bc712..adb6a207cf2d6 100644
--- a/drivers/nvme/target/fc.c
+++ b/drivers/nvme/target/fc.c
@@ -2464,11 +2464,11 @@ __nvmet_fc_fcp_nvme_cmd_done(struct nvmet_fc_tgtport *tgtport,
 	} else {
 
 		/*
-		 * try to push the data even if the SQE status is non-zero.
-		 * There may be a status where data still was intended to
-		 * be moved
+		 * A failed command may not have filled its read buffer, so
+		 * only push data for success, as the tcp and rdma targets do.
 		 */
-		if ((fod->io_dir == NVMET_FCP_READ) && (fod->data_sg_cnt)) {
+		if (fod->io_dir == NVMET_FCP_READ && fod->data_sg_cnt &&
+		    !cqe->status) {
 			/* push the data over before sending rsp */
 			nvmet_fc_transfer_fcp_data(tgtport, fod,
 						NVMET_FCOP_READDATA);
-- 
2.53.0



