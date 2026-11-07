Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794065307;
	b=vDMOJ+Bz05Sm6CQ22dbXuor8Qpa7hzXsEWDN1btipWdXD3HEDQrQ7ktgECJOaH0KGRjS
	 gq1vL/Gy9DUjjPgYrEYSyCksT8Tq2y0MhMZPzqUwBoHSbzLUw4+scwwh+V0klSQTVtQHu
	 cgSGdmHjvJ1qFln7H6BxVsiCu7vw1a/lO7QcU6HqtUpwVMIC7BZ/n7NiDn3zaV0vmwOye
	 JQZ4CoHRbPDtLJ32EKX9n+SBats5ImW6TCFC2bYqvjetAv60BPxEh1WjTzoCJYr2w+hqP
	 OSpTVQtmcZG4tVx0IFwTqykQnrr0m0VXzil4i6B5RmMTO4y91XqnEJFn/hs5He6m7wQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794065307;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=9uRJnaazBZKHun67T5VjTgoKUzBmpWLmn0Q7FYKYAWs=;
	b=MZCLTwYWY6/cOF/7yFmAUOA9/JidCma0EMkkkw9FOgbsjB9YbsmQ1aDHtSYCOGpqMmzI
	 oUvCYH4Oos9TrujHTQ5Qb2vrpCgQcjz4P+oKbG42c3j9PeePiSViRHLHDoG4wZygjC3yz
	 zgJrKY66cb2LeL4eg/SNiATGzxePxF1sYZGVSeIYJBm5fgEMG8EsF0GwFnJrM/3jm6HHa
	 3xWsMOXHgxjKaVtcdgDZjPzxsVkcb/48gSZ8afjtd1iTZx9+qsKX3y+uKxXEGWlduwwHs
	 A1MFnVk3VDQ/BpqPCCZWh/tUokqDLqW2mMj7Wx1XqHJao3BccurcuR8GmpgIQK3Mp0w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=FBX+dxi0;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7028C606A32C;
	Sat,  7 Nov 2026 15:28:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=FBX+dxi0
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1F08D1F0089F;
	Sat,  7 Nov 2026 15:28:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794065307;
	bh=9uRJnaazBZKHun67T5VjTgoKUzBmpWLmn0Q7FYKYAWs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=FBX+dxi0+62OE6SnhqZavJ2MD589xQA7WE4WzTQPtNtSGbAwDT2t1bo6IYjI1oa5P
	 I+olZf34z5I7+23UL7Yo0MUcxZJMi7trz1s85GOhHOesN8sS4x0NSkB11J2BXCF2WD
	 FgMO8go0K097+2/4zkSwHZ1TNp6YAzIPHv6i2J+I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bart Van Assche <bvanassche@acm.org>,
	Bean Huo <beanhuo@micron.com>,
	Peter Wang <peter.wang@mediatek.com>,
	Stanley Jhu <stanleyjhu@google.com>,
	"Martin K. Petersen (Oracle)" <mkp@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1058/1257] scsi: ufs: core: Add a helper for clearing hba->outstanding_reqs
Date: Sat,  7 Nov 2026 08:55:54 -0500
Message-ID: <20261107135008.507455617@linuxfoundation.org>
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

[ Upstream commit 22d14117ec1845a81acb3a5c4be325f7e8332f70 ]

ufshcd_poll() and ufshcd_abort() each have their own copy of the code that
clears bits in hba->outstanding_reqs under hba->outstanding_lock.

Move that code into ufshcd_clear_outstanding_reqs() and its locked variant
__ufshcd_clear_outstanding_reqs(), and use them in both functions. No
functional change.

Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/3779e125-9acc-42c8-9489-51b9e3c6716d@acm.org
Suggested-by: Bart Van Assche <bvanassche@acm.org>
Reviewed-by: Bean Huo <beanhuo@micron.com>
Reviewed-by: Peter Wang <peter.wang@mediatek.com>
Signed-off-by: Stanley Jhu <stanleyjhu@google.com>
Reviewed-by: Bart Van Assche <bvanassche@acm.org>
Link: https://patch.msgid.link/20261022034443.3034432-3-stanleyjhu@google.com
Signed-off-by: Martin K. Petersen (Oracle) <mkp@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/ufs/core/ufshcd.c | 48 +++++++++++++++++++++++++++++----------
 1 file changed, 36 insertions(+), 12 deletions(-)

diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index 2c4fffd4b824f..25aeab7a73aa3 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -6002,6 +6002,37 @@ static void ufshcd_clear_polled(struct ufs_hba *hba,
 	}
 }
 
+/*
+ * Return a bitmask of the transfer requests cleared from
+ * @hba->outstanding_reqs.
+ */
+static unsigned long __ufshcd_clear_outstanding_reqs(struct ufs_hba *hba,
+						     unsigned long mask,
+						     bool from_irq)
+	__must_hold(&hba->outstanding_lock)
+{
+	unsigned long completed_reqs = mask & hba->outstanding_reqs;
+
+	if (from_irq) {
+		/* Do not complete polled requests from interrupt context. */
+		ufshcd_clear_polled(hba, &completed_reqs);
+	}
+	hba->outstanding_reqs &= ~completed_reqs;
+
+	return completed_reqs;
+}
+
+/*
+ * Return a bitmask of the transfer requests cleared from
+ * @hba->outstanding_reqs.
+ */
+static unsigned long ufshcd_clear_outstanding_reqs(struct ufs_hba *hba,
+						   unsigned long mask)
+{
+	guard(spinlock_irqsave)(&hba->outstanding_lock);
+	return __ufshcd_clear_outstanding_reqs(hba, mask, false);
+}
+
 /*
  * Return: > 0 if one or more commands have been completed or 0 if no
  * requests have been completed.
@@ -6012,6 +6043,7 @@ static int ufshcd_poll(struct Scsi_Host *shost, unsigned int queue_num)
 	unsigned long completed_reqs, flags;
 	u32 tr_doorbell;
 	struct ufs_hw_queue *hwq;
+	bool from_irq;
 
 	if (hba->mcq_enabled) {
 		hwq = &hba->uhq[queue_num];
@@ -6021,12 +6053,9 @@ static int ufshcd_poll(struct Scsi_Host *shost, unsigned int queue_num)
 
 	spin_lock_irqsave(&hba->outstanding_lock, flags);
 	tr_doorbell = ufshcd_readl(hba, REG_UTP_TRANSFER_REQ_DOOR_BELL);
-	completed_reqs = ~tr_doorbell & hba->outstanding_reqs;
-	if (queue_num == UFSHCD_POLL_FROM_INTERRUPT_CONTEXT) {
-		/* Do not complete polled requests from interrupt context. */
-		ufshcd_clear_polled(hba, &completed_reqs);
-	}
-	hba->outstanding_reqs &= ~completed_reqs;
+	from_irq = queue_num == UFSHCD_POLL_FROM_INTERRUPT_CONTEXT;
+	completed_reqs = __ufshcd_clear_outstanding_reqs(hba, ~tr_doorbell,
+							 from_irq);
 	spin_unlock_irqrestore(&hba->outstanding_lock, flags);
 
 	if (completed_reqs)
@@ -8060,7 +8089,6 @@ static int ufshcd_abort(struct scsi_cmnd *cmd)
 	struct ufshcd_lrb *lrbp = scsi_cmd_priv(cmd);
 	unsigned long flags;
 	int err = FAILED;
-	bool outstanding;
 	u32 reg;
 
 	ufshcd_hold(hba);
@@ -8155,11 +8183,7 @@ static int ufshcd_abort(struct scsi_cmnd *cmd)
 	 * Clear the corresponding bit from outstanding_reqs since the command
 	 * has been aborted successfully.
 	 */
-	spin_lock_irqsave(&hba->outstanding_lock, flags);
-	outstanding = __test_and_clear_bit(tag, &hba->outstanding_reqs);
-	spin_unlock_irqrestore(&hba->outstanding_lock, flags);
-
-	if (outstanding)
+	if (ufshcd_clear_outstanding_reqs(hba, BIT(tag)))
 		ufshcd_release_scsi_cmd(hba, cmd);
 
 	err = SUCCESS;
-- 
2.53.0



