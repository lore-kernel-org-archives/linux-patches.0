Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793829756;
	b=5kPlGDP/QLzckQ4/gazNsu6XLGNlo/xPnA0cBvW+Zus5f1Xp5KWQmJ+XL9Jx3fVqdM5o
	 16Shp5kyUaoP3XD4PXGGwRD1fVr7oSql8QoTrEhElWxiseJhTfrDPnB3m2dGh7rojRq2M
	 Gf+E2zfH4mmj+kUM8cR3wNLnT/HXnTH2zklYumoIZo3Ri5rg+PMBmHK2My0vNY4JYFjYm
	 YlNp4YmU/0GIe0wChJ6LXwFISxFtOja3NaAlHefNSeanI9l5ZYtwvUvM75/cSxVRm0PZD
	 2kLy52fMRrgCWTH6Loj6bA7RRYdj5Tq8aj3kfZNeS+XiCggWW3tOyvq/ipqKXiBuRNg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793829756;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=IVo0KET7T5bE8MorwBDi0hMsJk2nCfCFdovpdKofcXk=;
	b=J4tzZUKnCf9/T52DX/eZLv8fI+NiR4Y71D1yaqhgs18huxztZSSjnHOBks8xX54vLG6k
	 2VTqBBJnjk669i3FfI1TvY+fAU3CxDaE2lXoUuZf7FVA0b0zbxMSiuhHHTF/SvLMHBzvg
	 8xrWKMIlQyMYJjhaEJ3ErI6ufkPZL5Cc0M3epstDf+1csedc1l8krLS5BHseh1dg26WvI
	 INVqNlJQ0Bdcsu9jbZ/wBfHBDkha5lcazkRGA0K/9s1sQCPjWlCDsU8mXYj2r8nQ6mUkl
	 TEVh1qAjGBH/h46PCCMQDpi9mX/IjclPVxQegsuJW48Jc2lEk+DEPRQ5IF6Ipzfm8MA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=udyvo2Gj;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1453A606C5AD;
	Wed,  4 Nov 2026 22:02:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=udyvo2Gj
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9FD881F000C1;
	Wed,  4 Nov 2026 22:02:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793829755;
	bh=IVo0KET7T5bE8MorwBDi0hMsJk2nCfCFdovpdKofcXk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=udyvo2GjnwpL2yKU/q6J6Vt2zHmeu6g/coN3zNmxq729SvAjJJGvcsJMByWIg+RB0
	 DDAeHFFsBwA74gnpVeLgTbbXPXxy1lU0Obj4MN0hktmHsAxSSrqc9AwJfN8LIQCilR
	 Wd+6zztkvwW/PajbFm8DqHrf62oCUG468eeVydng=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Jan=20H=C3=B6ppner?= <hoeppner@linux.ibm.com>,
	Stefan Haberland <sth@linux.ibm.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0323/1005] s390/dasd: Snapshot intrc before freeing the request block
Date: Wed,  4 Nov 2026 16:00:56 -0500
Message-ID: <20261104211052.992804393@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104211043.516122098@linuxfoundation.org>
References: <20261104211043.516122098@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index e7845c8ccc9ff..f6e86692a21d7 100644
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



