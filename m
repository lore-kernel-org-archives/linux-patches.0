Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795047012;
	b=zi+KuZKPnSHiMR8GgBiqdc6kHq3XI0QYGzG/A4krVsIVuzcGtt+Tf4ifYKcddZSfMnZu
	 clO73uImBSBbfpG3L2I7Ms0vXg4kVrD92WcvXvsaQBA8DQdVZsPMoM3YGvg6BfEjN0mKL
	 TzD+hjZD2cvqzeBmw+sXqrJwTAnUgW4ij14r377DQQKSc2JJhSdHWAGaXmxgImR2Yx6pM
	 j1+xUimEA0IY0Ip+Vc32wHftTk29g4NO2Y1kADbRF9VU0WFCw+Ohy6F1ZaYj4R7X5GEiR
	 2e/8R7Pr5Ukg7SvJ0QqjlpuC9PcgQ63ikIkuRXFelYiXLyIqt+ouCimMwOT8HelAfPA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795047012;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=fRNLPz72qMBmu0HxJXQ/Cto6Bi5A5DQc946H/3HYCHI=;
	b=gJ8omMaFFDwVqkQ1WECKuscyRvPA/GQzYstO8cQBXuxeKU51EXxNHl8q4aU21/BSZcQt
	 DSYOFwP2zK1ydj94t3MO/4JU65Mrp8O9lS0SIO44+eqmbrCo+uOBrdpMViv9kEbHacqig
	 wdBipDuIwg18u9aOD7EBAGH6pIuEFHcIaYkIf4Pf8+GWEKrshZQQMfw2U7S6+uz1cUHVG
	 3sxm6eHJYAOwcpg6izmz8KSThHkhgRT2ancvBWx6YKkmUB5fTgfBFv0Y8+mCfNQ+yswBR
	 Illm+v1x60Z1qq/6MG3bUnPmmxpPvCJbwh56O7SHxDPEm/2zEw9f2bc3huS3NRYGK4g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=HhY6Im14;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB338606A32C;
	Thu, 19 Nov 2026 00:10:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=HhY6Im14
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BFF781F000C5;
	Thu, 19 Nov 2026 00:10:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795047012;
	bh=fRNLPz72qMBmu0HxJXQ/Cto6Bi5A5DQc946H/3HYCHI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=HhY6Im14ho74sHfKM94ZmX2B6OCHlnaRwayArApbeDkMxvGHwFeG2mqpD38uw88Mu
	 OF5GQ8Mi+zxMgWUeRT/MkD0tlzjm7qTCWnEI7KkFp4o8s5rz9ZdMeDh+6rQQpZW9xz
	 g3LK406GtR1e6CrN5G7R+Wbyyc8J8L84tezazusM=
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
Subject: [PATCH 6.1 1486/2857] scsi: ufs: core: Add a helper for clearing hba->outstanding_reqs
Date: Wed, 18 Nov 2026 15:42:00 +0100
Message-ID: <20261118150254.826886977@linuxfoundation.org>
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
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

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
[ sashal: adjusted context for the existing single-queue UFS implementation ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/ufs/core/ufshcd.c | 48 +++++++++++++++++++++++++++++----------
 1 file changed, 36 insertions(+), 12 deletions(-)

diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index c86f4d226fb3e..24d1321a9b519 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -5435,6 +5435,37 @@ static void ufshcd_clear_polled(struct ufs_hba *hba,
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
  * Returns > 0 if one or more commands have been completed or 0 if no
  * requests have been completed.
@@ -5444,15 +5475,13 @@ static int ufshcd_poll(struct Scsi_Host *shost, unsigned int queue_num)
 	struct ufs_hba *hba = shost_priv(shost);
 	unsigned long completed_reqs, flags;
 	u32 tr_doorbell;
+	bool from_irq;
 
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
@@ -7251,7 +7280,6 @@ static int ufshcd_abort(struct scsi_cmnd *cmd)
 	struct ufshcd_lrb *lrbp = &hba->lrb[tag];
 	unsigned long flags;
 	int err = FAILED;
-	bool outstanding;
 	u32 reg;
 
 	WARN_ONCE(tag < 0, "Invalid tag %d\n", tag);
@@ -7333,11 +7361,7 @@ static int ufshcd_abort(struct scsi_cmnd *cmd)
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



