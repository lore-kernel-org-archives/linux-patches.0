Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795038562;
	b=YdXLw3sVXDHUC+5bPdYH0hMYrik9xhrAM7XxrA/W+IW15kKGuUDpM16T0vDs1P2eWSJ/
	 rL08aQLX2HEmV0WEASjxnVgh9XB23OV7osLkZBUDabnPJU+GuYLsnE0Gw9Jz65DTAERnZ
	 SMR0epJkUbQAPHzzYk8S10slFa8J15ka9ThSH38mgqL+B1g3c/x6FLoWl4kWjoZpee+MC
	 ZtgjkNY6iJNUyGQAHsvvvgL6j3Uf0Wt5XEDsOgL3nsp4bFaytx1bP2WEjlpXmmfn6FOf8
	 eKPFh/trRRt7M9LUXpvkAOLCdFV9O6t3eXwDuq7a9koiaM0zqUmMahMKL2KKeL7GwvQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795038562;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=FqsWOz/qs1Yjewffuh14TBq2QPF42kjgdhEKelTgd3Q=;
	b=s3UCAN9zM40hCQ1O6wqdF/mBXUXCI2XDdt7ATU9Ao6j3p+SPeWAXwlvusISTfZG1oDsQ
	 13m2yxGIMe3ClKKAdceO34xS2hHvHvgaXQraEjUMTIJJDqoOe7cos7gL7fZe7ygi9JIq2
	 tPTZHJ2F+y0grmBLgJ5yfXnliyRGO4yo2QZZRnO9peLuFuM9zHNnmql7Cij02Fx0m63il
	 Bgsbgdq8bOY6Xjs3UEell/kCCXj3sXGneKI4Jff0dw9GshdOGHFKPlVUKc3w9RBH1dCLQ
	 059fPDJE/Y0pCZ55R7ZV5N38v0KVlGkvXitZf/VF0jchKUg9YEEEbwHdxpnuGnqmKwA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=YFlO6Lsq;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA3DF606A32A;
	Wed, 18 Nov 2026 21:49:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=YFlO6Lsq
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 145821F000C4;
	Wed, 18 Nov 2026 21:49:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795038562;
	bh=FqsWOz/qs1Yjewffuh14TBq2QPF42kjgdhEKelTgd3Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=YFlO6Lsq1/Fqr83MNUkqntMHFIEiTmoyJWLcu2BJ4eyFVKxig8/rvFy+/oTqhpqJA
	 6v+CG4FjmBAY3jqZoGZZu8dSUEOlegzfoTL6jVcjgPFlUva+g88NhJc0rfCtaeQvdh
	 F+mzAzkK36zn+YHXJKArtWmpEEQyoODOLXushb3k=
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
Subject: [PATCH 6.6 1745/3318] scsi: ufs: core: Add a helper for clearing hba->outstanding_reqs
Date: Wed, 18 Nov 2026 15:39:27 +0100
Message-ID: <20261118150414.210174457@linuxfoundation.org>
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
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 3ffd18aa9675d..c70ffdd299a2c 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -5601,6 +5601,37 @@ static void ufshcd_clear_polled(struct ufs_hba *hba,
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
@@ -5611,6 +5642,7 @@ static int ufshcd_poll(struct Scsi_Host *shost, unsigned int queue_num)
 	unsigned long completed_reqs, flags;
 	u32 tr_doorbell;
 	struct ufs_hw_queue *hwq;
+	bool from_irq;
 
 	if (is_mcq_enabled(hba)) {
 		hwq = &hba->uhq[queue_num];
@@ -5620,12 +5652,9 @@ static int ufshcd_poll(struct Scsi_Host *shost, unsigned int queue_num)
 
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
@@ -7694,7 +7723,6 @@ static int ufshcd_abort(struct scsi_cmnd *cmd)
 	struct ufshcd_lrb *lrbp = &hba->lrb[tag];
 	unsigned long flags;
 	int err = FAILED;
-	bool outstanding;
 	u32 reg;
 
 	WARN_ONCE(tag < 0, "Invalid tag %d\n", tag);
@@ -7786,11 +7814,7 @@ static int ufshcd_abort(struct scsi_cmnd *cmd)
 	 * Clear the corresponding bit from outstanding_reqs since the command
 	 * has been aborted successfully.
 	 */
-	spin_lock_irqsave(&hba->outstanding_lock, flags);
-	outstanding = __test_and_clear_bit(tag, &hba->outstanding_reqs);
-	spin_unlock_irqrestore(&hba->outstanding_lock, flags);
-
-	if (outstanding)
+	if (ufshcd_clear_outstanding_reqs(hba, BIT(tag)))
 		ufshcd_release_scsi_cmd(hba, lrbp);
 
 	err = SUCCESS;
-- 
2.53.0



