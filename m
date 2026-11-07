Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794060893;
	b=y0O80HX1k5RHq6/obE76cG05Xo3u+HH+agF3Kh/xkPFGQxuVYOy1sjzfnyaMsxSmDpOe
	 MNn/ihgG7wP1QbHEksjfhb+pyQJ9nHFVmLiforFIzYRcvTO6GEUIuaZyt+cEsvTeAbTT4
	 bzOKzFYDQ0elTZHZ4pBbWYD0IdHrjh6h821sGGGPoyu2iCAdyoq+7+spCHkYFJPHJpvGK
	 AJjITiX6bxjiL6i7yXvvvDeQovpLyhBPVAQXr1yXxHzqRDsB3ENksq+CaRNG4DCUqJGrP
	 DhBXOLtMtDbIh4XSVR1w9vvv5C69Nb5b/wF3yoN1iHpxlpEEzs9yVfpCPhxGsUj3Vvg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794060893;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=0myzE/3AqqifM+opNuUkkHURVaqXO0/xgLlKsrfvZuI=;
	b=Cb5qjD65ev/BiXGaIbqy0Sapz7OQjIfhulItq+blofvObr2shvAZKlu7JfKO3gGbdo12
	 fzl8WOIVQxFFw6TcIg8Y3t02smRHSeUdQI46Cx50JtXPhTqy0OP3S0vZwZAsB93ihWG4H
	 pIzNi3YFO0IH90REvxnVxa6o93bjYe27HKeIaJZW4WfsVaeglpd3kp53o5GZsJKgPJJJF
	 PNCsrvUlQ7xAUXRh4B0iNHork6VPrOwZF4Odn4xIFHIRBgD3gIdtXCSueQnXFZIsQfEDI
	 XrGrcY0pqBbRWP43gt8j8EySJnD3ChuQOZhsFJVHxINZaeMD3wHFpm0SwYg//17Yo4w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=EdAYScFg;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B8D9D606D835;
	Sat,  7 Nov 2026 14:14:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=EdAYScFg
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5E00E1F0089F;
	Sat,  7 Nov 2026 14:14:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794060892;
	bh=0myzE/3AqqifM+opNuUkkHURVaqXO0/xgLlKsrfvZuI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=EdAYScFg5eRv6FXW8XZyu/APLrSL1GrwdIvPun/7CmB78uj5MXSQay4KJ8wlAex4Z
	 wrc2f9PZlmXnNC1WcfKc4S43Me1xNyQ9KjgLmoHJwiQh+cuDthoSI3LqVaSNwtiac7
	 zAVjOo/JJgo4HAkX/OqqJJ3jpfvvf80zRH9IeHOc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Jan=20H=C3=B6ppner?= <hoeppner@linux.ibm.com>,
	Stefan Haberland <sth@linux.ibm.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0268/1536] s390/dasd: Snapshot intrc before freeing the request block
Date: Sat,  7 Nov 2026 08:38:04 -0500
Message-ID: <20261107135005.210453313@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134957.653319350@linuxfoundation.org>
References: <20261107134957.653319350@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 4d4bf50e6462f..12b219b72bd4a 100644
--- a/drivers/s390/block/dasd.c
+++ b/drivers/s390/block/dasd.c
@@ -2734,17 +2734,23 @@ static void __dasd_cleanup_cqr(struct dasd_ccw_req *cqr)
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



