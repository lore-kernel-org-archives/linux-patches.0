Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795617752;
	b=wdRtvUaQXlkqqdby5utLg+0ozVdfghVeq+mljZ74gYhMNRwPwJ3BDq+uKhIHcn8jaYWp
	 0iZPHRYO4DamFtFQ3hvW+XtCjhwHHrbSpPsPuTrrw6qGHizz5YmgA7sOXo+MTTmT2FlCr
	 QPc3oaAQOw28Zpdc24pIIp/nS16woZ2g6mWmUd/woB8NqrZ01qGrqIyH9x9y2l6X31zpP
	 GFLJ4VRGz4UB1++KVFZOZPgMr0UJytkhx6hRgOvG7QC1Lv2nRjAwNluBcMdoKbA8SS/Eo
	 CzlJ7fasD/IiuIL05epm3RDvPC5g8eo1rBwhLWsBxM1EhI2AVKWP9cQirOvud0eveGg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795617752;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=rL5TKZiCF4HMxV9LbCJC4uZr2PGz8N9mtP/IqHHidVc=;
	b=1n2VvDdDKWawGuSYQjrf7V4EsGKOAArtE0J/1/jz1tVbhRYtlxlvZCa+afFhOBPq3Qk6
	 qdyvP2zgg9DWWhqoOkcUidBIuoyXcboI5+R9tqeVuemj10yoyt/d2/xqBz67nlEXfDgHW
	 Gx7lOwxdp+Gf/fPHwCYnqYZFoFCRJntzddnEVrOJyDImG5LGDi1th1k9t+8UCSs3BaSFq
	 DL/vn5/yDLeArChDbMYO1wgqyNIX6Q0PssxvOUDwWZa7l/HjjGSextsBmm8bxYxajvzeD
	 awslsYDNriNqsaDug3KtkkJIgewMJzjV/0cqt0KwqS7pIpCPePiu39YdNS7zKATUmsA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=b4pHyOcF;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF29F606A321;
	Wed, 25 Nov 2026 14:42:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=b4pHyOcF
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1A12A1F000D3;
	Wed, 25 Nov 2026 14:42:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795617751;
	bh=rL5TKZiCF4HMxV9LbCJC4uZr2PGz8N9mtP/IqHHidVc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=b4pHyOcFxBKBLZkIqX+df7achyABw9i1b8a+NdUJQivEhx4IdmpnnzIMr0jLJtCyI
	 qA4NA5ROSv98iFJO0pjZlsrVhEp3zxjaGR2Xppzw3CigFXZARh3YBEcMzKVwKjbQv+
	 wYnmdFroF8je7HrkuENZebzGBMdSeNG3i5kkdsSQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Filippo Falezza <effeffe99@gmail.com>,
	Loic Poulain <loic.poulain@oss.qualcomm.com>,
	Jeff Johnson <jeff.johnson@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0061/1005] wifi: ath10k: Stop unanswered temperature reads
Date: Wed, 25 Nov 2026 15:23:19 +0100
Message-ID: <20261125143823.169938067@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143821.729802100@linuxfoundation.org>
References: <20261125143821.729802100@linuxfoundation.org>
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

From: Filippo Falezza <effeffe99@gmail.com>

[ Upstream commit 2a87e367c62856b87a90f745c6b7d2eb91e0c51f ]

Reading the ath10k hwmon temperature sends WMI_PDEV_GET_TEMPERATURE and
waits up to 5 s (ATH10K_THERMAL_SYNC_TIMEOUT_HZ) for the reply event,
holding conf_mutex. Not all firmware answers: the WCN3990 firmware
WLAN.HL.3.3.1-00694-QCAHLSWMTPLZ-1 on a Motorola Moto G 5G Plus
codename nairo (SM7250) never sends the event, so every read of
temp1_input stalls for 5 s, logs

  ath10k_snoc 18800000.wifi: failed to synchronize thermal read

and returns -ETIMEDOUT. Tools that read all hwmon sensors, such as
lm-sensors, hang for 5 s on every run, and configuration changes of the
interface wait for conf_mutex in the meantime.

Whether the firmware answers cannot be told from the chip: firmware that
answers and firmware that does not both advertise
WMI_SERVICE_THERM_THROT, and WCN3990 firmware differs between devices.
Instead, remember that the running firmware did not answer, and return
-EOPNOTSUPP right away on later reads. Forget it when the firmware
starts, so that a restarted or updated firmware is asked again.

The first read after each firmware start still takes 5 s when the
firmware does not answer. Reads on firmware that answers are unchanged.

Fixes: e98199a8c27f ("ath10k: enable QCA6174/QCA9377 to read the chip temperature")
Signed-off-by: Filippo Falezza <effeffe99@gmail.com>
Reviewed-by: Loic Poulain <loic.poulain@oss.qualcomm.com>
Link: https://patch.msgid.link/20261027-ath10k-temperature-v2-1-0793e80d73bc@gmail.com
Signed-off-by: Jeff Johnson <jeff.johnson@oss.qualcomm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/ath/ath10k/core.c    | 1 +
 drivers/net/wireless/ath/ath10k/thermal.c | 9 ++++++++-
 drivers/net/wireless/ath/ath10k/thermal.h | 2 ++
 3 files changed, 11 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath10k/core.c b/drivers/net/wireless/ath/ath10k/core.c
index 7c2939cbde5f0..a749ae582b0a4 100644
--- a/drivers/net/wireless/ath/ath10k/core.c
+++ b/drivers/net/wireless/ath/ath10k/core.c
@@ -2985,6 +2985,7 @@ int ath10k_core_start(struct ath10k *ar, enum ath10k_firmware_mode mode,
 	clear_bit(ATH10K_FLAG_CRASH_FLUSH, &ar->dev_flags);
 
 	ar->running_fw = fw;
+	ar->thermal.broken = false;
 
 	if (!test_bit(ATH10K_FW_FEATURE_NON_BMI,
 		      ar->running_fw->fw_file.fw_features)) {
diff --git a/drivers/net/wireless/ath/ath10k/thermal.c b/drivers/net/wireless/ath/ath10k/thermal.c
index 9bb486f8e9207..9ff7de0abd129 100644
--- a/drivers/net/wireless/ath/ath10k/thermal.c
+++ b/drivers/net/wireless/ath/ath10k/thermal.c
@@ -75,6 +75,12 @@ static ssize_t ath10k_thermal_show_temp(struct device *dev,
 		goto out;
 	}
 
+	/* Don't stall every read on firmware that never answers */
+	if (ar->thermal.broken) {
+		ret = -EOPNOTSUPP;
+		goto out;
+	}
+
 	reinit_completion(&ar->thermal.wmi_sync);
 	ret = ath10k_wmi_pdev_get_temperature(ar);
 	if (ret) {
@@ -90,7 +96,8 @@ static ssize_t ath10k_thermal_show_temp(struct device *dev,
 	time_left = wait_for_completion_timeout(&ar->thermal.wmi_sync,
 						ATH10K_THERMAL_SYNC_TIMEOUT_HZ);
 	if (!time_left) {
-		ath10k_warn(ar, "failed to synchronize thermal read\n");
+		ath10k_warn(ar, "failed to synchronize thermal read, not asking again until the firmware restarts\n");
+		ar->thermal.broken = true;
 		ret = -ETIMEDOUT;
 		goto out;
 	}
diff --git a/drivers/net/wireless/ath/ath10k/thermal.h b/drivers/net/wireless/ath/ath10k/thermal.h
index 1f4de9fbf2b30..d1fb5b958c37c 100644
--- a/drivers/net/wireless/ath/ath10k/thermal.h
+++ b/drivers/net/wireless/ath/ath10k/thermal.h
@@ -19,6 +19,8 @@ struct ath10k_thermal {
 	/* protected by conf_mutex */
 	u32 throttle_state;
 	u32 quiet_period;
+	/* the running firmware did not answer a temperature request */
+	bool broken;
 	/* temperature value in Celsius degree
 	 * protected by data_lock
 	 */
-- 
2.53.0



