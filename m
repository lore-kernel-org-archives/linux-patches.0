Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795034034;
	b=AXVcBoxUQop75Odh+KqzNexvEJSoTXZfV4jozmCi7DYHyDfui0wYu7W+KgE/y4kObI9X
	 x0fkXzIsqOi75Om5UyZ7vxuGVEEUIUoaxCr5jEo+wyJuduiOqYgvWRQ2fCjLQhPhuRrbc
	 RyhOw7YtxYuro52g1yHDV1bVE0pJ/kx7MVqxXTi3gEOmquUNwiEL6gLlSEcKCaan7ycc6
	 cyOahYAdiEM3DFz+JxKimZKTSQlGrVSQ+2PWGLDhtzadgEXtVJlVcJzTrj4SvKk7IPMk+
	 MH4F++iieBxlxkEv35UY+TJ39LVl9/MgJwE2HGfW9a926NffUIINo8njUoH3vV1yYdQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795034034;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=qMWTywAlR8glN6x27hTqd99BK/IPfoYJ3L+bdDJPlUc=;
	b=imQJluA669LgcWB/84uQppzyISnrS92Wqj4n2+vkiqPzxK+/ljF1ZTrbsGeLOLt56RdQ
	 Mngqx15zOpMXZ0//FQYJGrHLqCk0y0WHpG+TGUb4NPhHVwvJ08fQZIK4N8PwTXrY2ThSw
	 E73ieXCnTzPAQMfTYmAz8L9vLAFyJqdw1ayCC2toVxTS0X5yz3ViUG6yDtWcDebco69Fv
	 7vqGz6vckBG2C3EVzyJ8YuOEvnrUqmVPWXPQWSRI9AQbFP8jVF3mXCBkQ3iq3uqtRAgJX
	 PbyhyGYcf8ZKOhvXY8N8kMOeX1lXvRxPyr8Vs227bK8ZPxanCIo4Nbwiuja0cRCfCbg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=prQ25SKX;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A9E80606A336;
	Wed, 18 Nov 2026 20:33:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=prQ25SKX
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 075551F000CD;
	Wed, 18 Nov 2026 20:33:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795034034;
	bh=qMWTywAlR8glN6x27hTqd99BK/IPfoYJ3L+bdDJPlUc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=prQ25SKXg/yHLpo742Q9zO2rI6MHYF9yRdK+4eXVeFCbgc/8htyPikeCTYxEem14K
	 kIg68AcYgfFTE3vC14lTyWHckGv11zyos7hro0+XX4wD7IVtb4HooS91EeZ5LT6OAs
	 7w0yCtBC9Hs1Xa0srTLNIyo/gxuRaykca2HAu4j4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Jan=20H=C3=B6ppner?= <hoeppner@linux.ibm.com>,
	Stefan Haberland <sth@linux.ibm.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0226/3318] s390/dasd: Snapshot intrc before freeing the request block
Date: Wed, 18 Nov 2026 15:14:08 +0100
Message-ID: <20261118150321.820405055@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 21c5a0dd6fb01..7ec6e9f5d815a 100644
--- a/drivers/s390/block/dasd.c
+++ b/drivers/s390/block/dasd.c
@@ -2736,17 +2736,23 @@ static void __dasd_cleanup_cqr(struct dasd_ccw_req *cqr)
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
 			/*
 			 * DASD doesn't implement SCSI/NVMe reservations, but it
-- 
2.53.0



