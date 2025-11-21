Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 69648350A27;
	Fri, 21 Nov 2025 13:50:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763733044; cv=none; b=moXttZ3ORh18d3bRWiCTXbm/+okFE3cZI0KJjduKmESw4F1qJtH0TEiMl2uwASDslfXc5uaMB/4FbrfKH7hq5+m2xw68zAYiSgsC+5sDmtvwXj5uBDOPZi3LX3fwhrX12nGDQdBqZbV13tKaVKsFuosAGF4G6NjSw7HenwJXzNA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763733044; c=relaxed/simple;
	bh=KMTzLC8oDBNHsTxbBum5+VeWQAOBtz7a8xkXqvHypqU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KRP6y2Tvu0D/DbIjkDojNoRocu3PBbPwG60z53nOIxIoIJwgRA2hM8ZuWDvCg8/jwuUI/PmXm/01ZO8oQnq30AM8A7zBRoUzUaBN/gGqVmzo/3HGm41mVjeZMxtPyx7sf2H2OEgHHp+UmeLMkDM19r6SNUS57JmOWAAol2IvCZM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gK5BX5Po; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gK5BX5Po"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E6FFBC4CEFB;
	Fri, 21 Nov 2025 13:50:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1763733044;
	bh=KMTzLC8oDBNHsTxbBum5+VeWQAOBtz7a8xkXqvHypqU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gK5BX5Poi9R3oR/cyF9plp0kTvlO0F4bBuIPfLhw8cLigm4k5tooQxvsVOut/B+bF
	 DlHZvxIzsttgRJxjwtghERdvVkovs1ZSfCf2br8yunUZj4Rmy1PfEr8vbXPVlpPd7S
	 E40NflgJia3HaAVA10U2WwsySsWoY+J5ondb2fkc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Baochen Qiang <baochen.qiang@oss.qualcomm.com>,
	Vasanthakumar Thiagarajan <vasanthakumar.thiagarajan@oss.qualcomm.com>,
	Jeff Johnson <jeff.johnson@oss.qualcomm.com>
Subject: [PATCH 6.6 331/529] Revert "wifi: ath10k: avoid unnecessary wait for service ready message"
Date: Fri, 21 Nov 2025 14:10:30 +0100
Message-ID: <20251121130242.803968405@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251121130230.985163914@linuxfoundation.org>
References: <20251121130230.985163914@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Baochen Qiang <baochen.qiang@oss.qualcomm.com>

commit 2469bb6a6af944755a7d7daf66be90f3b8decbf9 upstream.

This reverts commit 51a73f1b2e56b0324b4a3bb8cebc4221b5be4c7a.

Although this commit benefits QCA6174, it breaks QCA988x and
QCA9984 [1][2]. Since it is not likely to root cause/fix this
issue in a short time, revert it to get those chips back.

Compile tested only.

Fixes: 51a73f1b2e56 ("wifi: ath10k: avoid unnecessary wait for service ready message")
Link: https://lore.kernel.org/ath10k/6d41bc00602c33ffbf68781f563ff2e6c6915a3e.camel@gmail.com # [1]
Closes: https://bugzilla.kernel.org/show_bug.cgi?id=220671 # [2]
Signed-off-by: Baochen Qiang <baochen.qiang@oss.qualcomm.com>
Reviewed-by: Vasanthakumar Thiagarajan <vasanthakumar.thiagarajan@oss.qualcomm.com>
Cc: stable@vger.kernel.org
Link: https://patch.msgid.link/20251027-ath10k-revert-polling-first-change-v1-1-89aaf3bcbfa1@oss.qualcomm.com
Signed-off-by: Jeff Johnson <jeff.johnson@oss.qualcomm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/wireless/ath/ath10k/wmi.c |   39 +++++++++++++++++-----------------
 1 file changed, 20 insertions(+), 19 deletions(-)

--- a/drivers/net/wireless/ath/ath10k/wmi.c
+++ b/drivers/net/wireless/ath/ath10k/wmi.c
@@ -1763,32 +1763,33 @@ void ath10k_wmi_put_wmi_channel(struct a
 
 int ath10k_wmi_wait_for_service_ready(struct ath10k *ar)
 {
-	unsigned long timeout = jiffies + WMI_SERVICE_READY_TIMEOUT_HZ;
 	unsigned long time_left, i;
 
-	/* Sometimes the PCI HIF doesn't receive interrupt
-	 * for the service ready message even if the buffer
-	 * was completed. PCIe sniffer shows that it's
-	 * because the corresponding CE ring doesn't fires
-	 * it. Workaround here by polling CE rings. Since
-	 * the message could arrive at any time, continue
-	 * polling until timeout.
-	 */
-	do {
+	time_left = wait_for_completion_timeout(&ar->wmi.service_ready,
+						WMI_SERVICE_READY_TIMEOUT_HZ);
+	if (!time_left) {
+		/* Sometimes the PCI HIF doesn't receive interrupt
+		 * for the service ready message even if the buffer
+		 * was completed. PCIe sniffer shows that it's
+		 * because the corresponding CE ring doesn't fires
+		 * it. Workaround here by polling CE rings once.
+		 */
+		ath10k_warn(ar, "failed to receive service ready completion, polling..\n");
+
 		for (i = 0; i < CE_COUNT; i++)
 			ath10k_hif_send_complete_check(ar, i, 1);
 
-		/* The 100 ms granularity is a tradeoff considering scheduler
-		 * overhead and response latency
-		 */
 		time_left = wait_for_completion_timeout(&ar->wmi.service_ready,
-							msecs_to_jiffies(100));
-		if (time_left)
-			return 0;
-	} while (time_before(jiffies, timeout));
+							WMI_SERVICE_READY_TIMEOUT_HZ);
+		if (!time_left) {
+			ath10k_warn(ar, "polling timed out\n");
+			return -ETIMEDOUT;
+		}
+
+		ath10k_warn(ar, "service ready completion received, continuing normally\n");
+	}
 
-	ath10k_warn(ar, "failed to receive service ready completion\n");
-	return -ETIMEDOUT;
+	return 0;
 }
 
 int ath10k_wmi_wait_for_unified_ready(struct ath10k *ar)


