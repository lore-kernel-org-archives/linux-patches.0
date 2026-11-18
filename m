Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795051438;
	b=kLcn6Hd7VCPPWMhY2Equs6D27vx+3LqZeTYNVrW+XtlPuzTQub4SJgG2tUa4sTAlNNBO
	 XhJKhtXHeUZDrTTzG1vo0KgCV4qA58jXFz4rmIwCkuhqFvs19dLAOIE9Ctsn8xsomzksI
	 vEjqct1wjWhrEcOMQZ6aMW9eisGJMC9i6JDvVeYMseSGlUcHI3cxpAoAXkLEVCMyCdMSm
	 JzaH5NnZQm6favJdeypZ2SQLw45AGv5QAGf6/bxuocEGrZroMpelxdrLj/LX0/vBPariv
	 vAh+81IUoroZx/H8RdpLjO475Nnt6rzHVp8mFH0a/O/DC6RDbnLV3Jk0jUpJ/UpY6Tw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795051438;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=iH2YUdLWgKIHUYHPj0Q1u7ZtF3Nzrb0F3IwCb9XRKEg=;
	b=Rket1SVg1IZm5wyqOxGYk2ytU1iOSXMG8xpNn2Gtwp1DO9AQAJaTGOahYxydyMNjuP6g
	 5u5V8Asnlmdf8zZTDENr1rD7AozC0BSCfkZ9vNgCB/LURQJNnBQO3HXd26hvptibEDohS
	 93ucxkKzuTeIOOfFgk+UZQd+fdKOM/ck9sokD30PIMrs6AM8t6FqfuCK/NRi9Zr1hiCdW
	 uvQt1AzLmd1fKZhRoKkQ/8D6PUs/jFLVuAbIcaa3W1RvB40qPWRao9gCXiSKMGPc7S+eF
	 X9DZTCZk9zzy6uiWMn5chZIvhh0NCIsUP26d0e5NTJ4HzrCjINPqcC4PgxNMC5PR9Ew==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=HdstCck7;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 61A7A606A32C;
	Thu, 19 Nov 2026 01:23:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=HdstCck7
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B0D521F000C4;
	Thu, 19 Nov 2026 01:23:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795051438;
	bh=iH2YUdLWgKIHUYHPj0Q1u7ZtF3Nzrb0F3IwCb9XRKEg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=HdstCck7FrEH0uO+XkuohYrGH7az0Hq/oPdPTDKwyHU4A4FvLJ7wtqSp56u/IIL2r
	 k94DKt3KkusE5eyKJKhcd3cgdj9Hj2yRAKpiRekMGvQQ0u/THvS/+CA/Zaatw0k/dq
	 HVO5eL6kyX5neQoA3PYC5v97VQoTpfC4/wTVJjFs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Jan=20H=C3=B6ppner?= <hoeppner@linux.ibm.com>,
	Stefan Haberland <sth@linux.ibm.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 0174/2214] s390/dasd: Snapshot intrc before freeing the request block
Date: Wed, 18 Nov 2026 15:30:50 +0100
Message-ID: <20261118150017.028560542@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Stefan Haberland <sth@linux.ibm.com>

[ Upstream commit dc3e3f7306cb74066f231251602b1be5aaec7bd8 ]

__dasd_cleanup_cqr() maps the completion result to a block status by
reading cqr->intrc, but only after discipline->free_cp() has returned the
request block to its memory pool (dasd_eckd_free_cp() ends in
dasd_sfree_request()). On SMP another CPU can reallocate that block and
overwrite cqr->intrc before it is read, completing the request with the
wrong error. proc_bytes is already snapshotted before free_cp() for the
same reason; do the same for intrc.

Reviewed-by: Jan Höppner <hoeppner@linux.ibm.com>
Signed-off-by: Stefan Haberland <sth@linux.ibm.com>
Link: https://patch.msgid.link/20260805111612.1285190-5-sth@linux.ibm.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/s390/block/dasd.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/drivers/s390/block/dasd.c b/drivers/s390/block/dasd.c
index eaa9457c1c29b..845f82215dfb3 100644
--- a/drivers/s390/block/dasd.c
+++ b/drivers/s390/block/dasd.c
@@ -2745,17 +2745,23 @@ static void __dasd_cleanup_cqr(struct dasd_ccw_req *cqr)
 	struct request *req;
 	blk_status_t error = BLK_STS_OK;
 	unsigned int proc_bytes;
-	int status;
+	int status, intrc;
 
 	req = (struct request *) cqr->callback_data;
 	dasd_profile_end(cqr->block, cqr, req);
 
+	/*
+	 * free_cp() returns the request block to its memory pool, so snapshot
+	 * everything still needed from cqr before calling it - another CPU can
+	 * reallocate and overwrite the block right after.
+	 */
 	proc_bytes = cqr->proc_bytes;
+	intrc = cqr->intrc;
 	status = cqr->block->base->discipline->free_cp(cqr, req);
 	if (status < 0)
 		error = errno_to_blk_status(status);
 	else if (status == 0) {
-		switch (cqr->intrc) {
+		switch (intrc) {
 		case -EPERM:
 			error = BLK_STS_NEXUS;
 			break;
-- 
2.53.0



