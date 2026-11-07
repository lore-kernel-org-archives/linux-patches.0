Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794065311;
	b=Dbr3R4g0wK4LjMEuBQtK2wL2CyrJ+KJl8ot3m7O5j1lHRxzVNglxqdLhQi5j7EZZChLH
	 61jSlFPIQeZIWRDef6v1hNgDEAs4z+jKUN3HXsimb+lZ6kRfQkfP8RHZjIOq6heI0AKKU
	 JiGZ9ocHILbztrYNvWmy3TO2LnkvwAX5hjYnrTOMmrTw23bGyhAqtyTLllNz6COs9RZZW
	 XsfAs3cWY5G0fOHZKrkW++q0nSgI5cjv1tDOo9jrrdwdTi+1m4YXw4PTFm+upJ90M5UgI
	 Hk2rwdagEmy/wF2yE0ro3bunXYvGI06miw/hrBgM1EcmV7gJ/iv8z2vAXK07cRZZpeA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794065311;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=IuCEcE9YWtuJJUxdLpwQ6ryQRq/vh/RMGnSY+NjM+8U=;
	b=hcOeqsf+jrokLjF4jY3cnuAQ5mO67KiWUbS7RoiL5cllzXiBhA13kun/0H8J98xyBPDR
	 nO5bQHx/3TZVPjZsbkyLxD5UkOLXnjoBQn7ofJKBlHQ/rMBm7/zSWwbbaLCwyPl0mg9zC
	 feP6M5FVCW5k2Moq6PWM1+gI1ZbO3RUyS7Ibn3z4gZ6TGDU27x81rDFq1EJCNLLZsqzT9
	 uN2K0tQbJhiJqy+P4R+luXWmnXxRsqwuexyiqHddkB7b52VRrz4x9LMGK93ObUB7pQKoL
	 r+haYangDmjNm2dsMtBXvlnAlrRuV8HRqiHdIQaGixJaXpDFPuyrgm3Yj6E0IM94vOA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=u0ROHhCx;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 41FF9606A326;
	Sat,  7 Nov 2026 15:28:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=u0ROHhCx
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EB25C1F0089F;
	Sat,  7 Nov 2026 15:28:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794065311;
	bh=IuCEcE9YWtuJJUxdLpwQ6ryQRq/vh/RMGnSY+NjM+8U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=u0ROHhCxv2GrOS+7nMlJ+rrGEq7epRzF+RfZnxJY2tGGc6rpPTL6kuBwy5BiyvK19
	 xSxHHndw4Y9li+qB1xIRJtUESlaGmz1oJt3lBPY6bRugfc3fIsqgSqwBKk5lDkQByy
	 q9mTtQJIg+hcHkKZjdysIdwQ1ThclagpR6moflFw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stanley Jhu <stanleyjhu@google.com>,
	Peter Wang <peter.wang@mediatek.com>,
	Bean Huo <beanhuo@micron.com>,
	Bart Van Assche <bvanassche@acm.org>,
	"Martin K. Petersen (Oracle)" <mkp@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1061/1257] scsi: ufs: core: Remove completed-without-interrupt path in ufshcd_abort()
Date: Sat,  7 Nov 2026 08:55:57 -0500
Message-ID: <20261107135008.586834475@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134939.434104957@linuxfoundation.org>
References: <20261107134939.434104957@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Stanley Jhu <stanleyjhu@google.com>

[ Upstream commit 7cfdfdd6557906fd09cf0a9a564a07012e7fb0c1 ]

In SDB mode, a command that times out right as the controller finishes it
can be completed twice:

 1. The command times out and scsi_timeout() schedules ufshcd_abort().

 2. The controller finishes the command and clears its doorbell bit in
    REG_UTP_TRANSFER_REQ_DOOR_BELL, while the completion handler has not
    yet cleared BIT(tag) in hba->outstanding_reqs.

 3. ufshcd_abort() sees the doorbell bit clear and calls
    __ufshcd_transfer_req_compl() without clearing BIT(tag) in
    hba->outstanding_reqs.

 4. The normal completion handler or the logical unit reset that follows
    sees BIT(tag) still set in hba->outstanding_reqs and completes the same
    command a second time.

This branch only exists for a rare corner case, a completion interrupt that
is lost or arrives late. Remove it to simplify the abort path and leave
such a command to the SCSI error handler, like any other command that
cannot be aborted. The cost is a slower recovery in this corner case, which
is acceptable since it only happens after a timeout.

Fixes: 169f5eb28869 ("scsi: ufs: Optimize SCSI command processing")
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/fdb5c391-01ef-4a23-94c2-4f3853909348@acm.org
Signed-off-by: Stanley Jhu <stanleyjhu@google.com>
Reviewed-by: Peter Wang <peter.wang@mediatek.com>
Reviewed-by: Bean Huo <beanhuo@micron.com>
Reviewed-by: Bart Van Assche <bvanassche@acm.org>
Link: https://patch.msgid.link/20261022034443.3034432-6-stanleyjhu@google.com
Signed-off-by: Martin K. Petersen (Oracle) <mkp@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/ufs/core/ufshcd.c | 9 ---------
 1 file changed, 9 deletions(-)

diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index 974bdadcff28e..47e0e6b8d3724 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -8129,15 +8129,6 @@ static int ufshcd_abort(struct scsi_cmnd *cmd)
 	}
 	hba->req_abort_count++;
 
-	if (!hba->mcq_enabled && !(reg & (1 << tag))) {
-		/* only execute this code in single doorbell mode */
-		dev_err(hba->dev,
-		"%s: cmd was completed, but without a notifying intr, tag = %d",
-		__func__, tag);
-		__ufshcd_transfer_req_compl(hba, 1UL << tag);
-		goto release;
-	}
-
 	/*
 	 * Task abort to the device W-LUN is illegal. When this command
 	 * will fail, due to spec violation, scsi err handling next step
-- 
2.53.0



