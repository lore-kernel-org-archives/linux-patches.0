Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795620977;
	b=3WlYCIO2rO0Wvw0DvS1aTXgVJBfMTEevlnUS4wg3gtngMKwsS2Sxo7LpWhap2JnbQsn0
	 860LHx6NcAJAZjOutNfYPCiWbC1jFRWxfE6tPXDj2EDrrQQq0cpiHY8/mvWOsKWc45Gq4
	 4EkKaiMiPot2lT5s9Fr76RlVNcfD3ndyp1DqMwGosmRfJPvL6vj1S4hQIBlkOFS3Hp6me
	 VSRdizoggNXRmsAVpPzE2C5Kzsy5k9bFiUhPrlDQkD6pwbrZgzrxrab0xXOgRUEvPDIIT
	 RJ0fXpyC4ch3SNvJm1yDcNbi0nsl//sfO08ygglbEeZtVQhVQkC5fQ7xhQPAHiMmpTQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795620977;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=t1MBOOLuczWLPfetTjqi5Rkqod+e6oWWNHdHotspKTU=;
	b=MWK2GDau6vPLA63LMGX/10JcaWCnJadQ1cOg8o3tnPAFRCq3gbBM/Yc2TwrhNgLelVRM
	 wGub7v6POYruczWEfiLnDp7jKyi8ZbdPqoEAeF58PM8UVu0ioDtEEulIj3dbRiTDClFXv
	 7le03l3xKK1Tpb4SklaJWnp5f+wJslRchF6FG7oSkcv6+zkCqkWLdmnwLSjIl+rdgawFY
	 4yFe6U1H2GN67wNkmw/Sq4iO1HHjiNEVgH/kQHKwm4wSeH4lKu7ghLLV0jL8478aPFcuN
	 BtVK77NXTkQAmDFGZp7Zyr7J3evQslkBLNaA5I/YjM/mfSF6QEYiPNfeEk28ZxlB53Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=WAvXXeN2;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2FFB9606A327;
	Wed, 25 Nov 2026 15:36:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=WAvXXeN2
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3A6551F000D4;
	Wed, 25 Nov 2026 15:36:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795620976;
	bh=t1MBOOLuczWLPfetTjqi5Rkqod+e6oWWNHdHotspKTU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=WAvXXeN2UTUd4q8V00aLmXwYpQ4gHgkoF/AaSaZ1SiVOtzHXuhADSgOSH++j++gYi
	 FgJsSRmwhipyrIJ8c/68aTCJd1lWGHVNcvdi9fdqhEao6uKHVoPB4C82Bu5L0g9Wua
	 jse6V2RCXbZYIbRvMCB49sLQNfJ+R8p3/vtMyHVY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Filippo Falezza <effeffe99@gmail.com>,
	Loic Poulain <loic.poulain@oss.qualcomm.com>,
	Jeff Johnson <jeff.johnson@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 082/990] wifi: ath10k: Stop unanswered temperature reads
Date: Wed, 25 Nov 2026 15:24:09 +0100
Message-ID: <20261125143824.011476534@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143822.072087159@linuxfoundation.org>
References: <20261125143822.072087159@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index 9ae3595fb6986..f57105ad09759 100644
--- a/drivers/net/wireless/ath/ath10k/core.c
+++ b/drivers/net/wireless/ath/ath10k/core.c
@@ -2986,6 +2986,7 @@ int ath10k_core_start(struct ath10k *ar, enum ath10k_firmware_mode mode,
 	clear_bit(ATH10K_FLAG_CRASH_FLUSH, &ar->dev_flags);
 
 	ar->running_fw = fw;
+	ar->thermal.broken = false;
 
 	if (!test_bit(ATH10K_FW_FEATURE_NON_BMI,
 		      ar->running_fw->fw_file.fw_features)) {
diff --git a/drivers/net/wireless/ath/ath10k/thermal.c b/drivers/net/wireless/ath/ath10k/thermal.c
index 8b15ec07b1071..9b81f9ae58d74 100644
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



