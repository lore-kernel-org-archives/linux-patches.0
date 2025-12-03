Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D88E9313523;
	Wed,  3 Dec 2025 16:08:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764778087; cv=none; b=hhGWo1GgbRlSMJc/mzzS104F8uDGpynhqdETPZgimz9Dyvi0pK6Hf5aB8MW+rSkHo58BuKyq0f4M7Lzz9LwJvNMdzVGdy+G34D0nxH93rg/F1SUzgSU9qYD/3wu+ABfC0HEhgie3mpyvzMsCOtMClhki+/F9v8uNjj2p5Jmw2YU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764778087; c=relaxed/simple;
	bh=qH3ls4yD/PPit/0P7DtXf8IiovBtsYbPFs16tf/8tKk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kuAEf7rStZLyMkMxfQs/mKUD1mx3eF4ic6gmuTVgyyOrvN1GJUo4VirMnYjRku6u/1w9QBSaonSBa9A5maahgWgxIPLM8Cz5fYWb2MjrJ2Apy+yYLFh9PaAClX4a7PDUcneDmXDaPxQvx+Bo6RDgb2DAPdHKqA/8AG7CD+a6b9Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fVHQoySA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fVHQoySA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 483F5C116B1;
	Wed,  3 Dec 2025 16:08:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764778087;
	bh=qH3ls4yD/PPit/0P7DtXf8IiovBtsYbPFs16tf/8tKk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fVHQoySA1FYMqjkdcSM8ZYRWyPpdBShoO2y9B4GILnhOEUwjzdTC8Ik4ksSibhMSJ
	 8SyF2/vTh2l406NNgdLzcpb+8CcQfCfWi4616Mpk4642AR0+zg/x8/61dH6lhqwH8e
	 10Mg3K0fP3HbMMwQUBMpBaFjL6jZ7EYT5MBpiKqQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Baochen Qiang <baochen.qiang@oss.qualcomm.com>,
	Vasanthakumar Thiagarajan <vasanthakumar.thiagarajan@oss.qualcomm.com>,
	Jeff Johnson <jeff.johnson@oss.qualcomm.com>
Subject: [PATCH 5.15 207/392] Revert "wifi: ath10k: avoid unnecessary wait for service ready message"
Date: Wed,  3 Dec 2025 16:25:57 +0100
Message-ID: <20251203152421.689509071@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251203152414.082328008@linuxfoundation.org>
References: <20251203152414.082328008@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1762,32 +1762,33 @@ void ath10k_wmi_put_wmi_channel(struct a
 
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


