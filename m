Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795057486;
	b=Fity1w/QP78zQYujB4VfKFzq9aitcpefiQJ19lSB9kiy+3s4gTI6FNcFf2mYaYsRogoO
	 Ikb7rwtHAm3E11wVP/tj9o5KzRb36Gacpfaladm3pX3+AkZ8NKUW5aZJS8IbPZbSYLoue
	 uh/txJeHXpFOA1AC3hViD5EwxwIFN8msErz24fcXk8gcbfhBkj9yrR2Jr3C4ZqQN48GiQ
	 pd5VPgNNzsmdZ/nIDga8IgNC36MFhqzSVEDfyYE+vBOIHwBd4shVi85GfZFOJN7xubBmT
	 wcdarYcXJF+CVE011w/7ltQvVSjcRIWjGi5JAunA35Jc1ghtKgtUHmpiC7syZw9TgfQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795057486;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=D74KAbTtlzDttFK6SLGa0Q/8DNMklqMO0gSfMCuSnpk=;
	b=Lk9FToeXbxuEG4YEzxIoQCGKOg7jBHXHvsGl8yGLN9Br02CkL2KA83QUArcjqZ8Aj/KG
	 mRpaEIaCjVsYfrtit95JM2efV1x+iPDn4dTw89cYyOCVy5Bsgq+2z/rbK3NqHI9mE7QTL
	 DVz90lGOxllF7vrz3EwCTqgW3DP8mGXV5Q/IlrwlV8YqKPtWe9p81WOFs2sQo6Hj00Lhv
	 Jd1Ennrtj1DHRNPHhhpsPgPRWFTYJSFrbNyBOREl5a4yF7OIVHG0wLP7RG7V9SvHFwD6W
	 xFG5Fi99VKGxcgT90/3C8Q6FNGRhSA7ew5Kvb/eLMkYt771HgVQ79NwdPrJrzUjx/5g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=pAivOO3v;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E58D760A2601;
	Thu, 19 Nov 2026 03:04:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=pAivOO3v
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 441081F000C4;
	Thu, 19 Nov 2026 03:04:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795057485;
	bh=D74KAbTtlzDttFK6SLGa0Q/8DNMklqMO0gSfMCuSnpk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=pAivOO3vNACDhicrWhuYM6C06o5qFD0X2ZLbdGBEdx8WsrK+kkae20jJijJKu2s6i
	 u8MPCPDGHZl5sLI/0A/ks+vlVuYbJI6Ca8H09erVvjHaTlVYo4E35SAjiV+FcycUSy
	 86kniKO8EbRGGG9U3h5+KwRi+sJ4woUF0CubVJDI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Jan=20H=C3=B6ppner?= <hoeppner@linux.ibm.com>,
	Stefan Haberland <sth@linux.ibm.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 0148/1848] s390/dasd: Snapshot intrc before freeing the request block
Date: Wed, 18 Nov 2026 15:36:26 +0100
Message-ID: <20261118145917.463955899@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 9ed61a588eb40..86e7323dec44a 100644
--- a/drivers/s390/block/dasd.c
+++ b/drivers/s390/block/dasd.c
@@ -2784,17 +2784,23 @@ static void __dasd_cleanup_cqr(struct dasd_ccw_req *cqr)
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



