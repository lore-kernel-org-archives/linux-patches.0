Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795043499;
	b=tKTu/X5mKHKWkADE9zTgRZGNF2DO6EanU8u98HmLwG3GHVlyiqQuKPTiIz7+/WErYRUT
	 MuuRA4ewN3oALRd+1pc5caGusOdbg2B44RL6XbZt+0/tId1TDCBEt8e63EjJEs7F3ouyH
	 4f1plqLYx/XyQYYKsDBzGB/GclEE2ap30XT7c17JH3xFI8vZ93yvHb7RZVEbz2CrOVToR
	 mS6vIhOnelAp3hzU3qIi6m1xmxV5wfVsj07CHhoT3rvzVS5NTFDpTJJ/gaTMzSqJB00fp
	 3dBXfolfZijySrQLp8vNt4mNwcCKQPoIwKYvvU5UWXEwJKMYoZ27gxyuYrhUPVTHD0g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795043499;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=bFYaD7BivjiY9ZBTFIV4KPEEYMJ1jLDKbFhIDNh0V6o=;
	b=z5IRRxJUR4H4YBfjtSq4TVwtZ07tSTCEJk5L3ApDlegsigvgrOIvVv9YgnS5y2D+DTbA
	 aU49XP1UcnAEsf4x39EPirOhW2KzNKDX2KJmkDxbp+3nVjTURkEgDNOBNBTQ4R18Oq5f7
	 pz++aVBZZAj+VbCzWghtspwS7QpCGauSEh7rq717hupn36FVwb2D1qpls4DZ+TXKdGyvr
	 hC8BgK6gsPcRjUK7PTa8O/GXUvaoW5GtD9NRyuQCcXiHOK0P8cfevG1TXZIHrKg4G/I0W
	 2M3l/rDwPLLCArjRPRtv10xeqyj5wzgrWaymrUm5rjUP7PP08TvWPsiug5CzOs25aPQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=r88jCz7x;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA32A606A31C;
	Wed, 18 Nov 2026 23:11:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=r88jCz7x
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B63081F000C4;
	Wed, 18 Nov 2026 23:11:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795043499;
	bh=bFYaD7BivjiY9ZBTFIV4KPEEYMJ1jLDKbFhIDNh0V6o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=r88jCz7xxWDcOOse5Tc1oUOr8nue//Om0d1ytGLELAoPySGpl2wEdUCM617S8fPif
	 lAxFly20Ly+gbhXxbTLfWFQveycxVGpMszxezDwDC1lczYR0skVEGwCJi3aFEibh+Z
	 M9qTjnZhuPvPCOrAnB8B/xv83zxCvKukntE9qVmc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Jan=20H=C3=B6ppner?= <hoeppner@linux.ibm.com>,
	Stefan Haberland <sth@linux.ibm.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0196/2857] s390/dasd: Snapshot intrc before freeing the request block
Date: Wed, 18 Nov 2026 15:20:30 +0100
Message-ID: <20261118150208.410843196@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 1d58b2f19ad2d..24a3169514a75 100644
--- a/drivers/s390/block/dasd.c
+++ b/drivers/s390/block/dasd.c
@@ -2723,17 +2723,23 @@ static void __dasd_cleanup_cqr(struct dasd_ccw_req *cqr)
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



