Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795704932;
	b=mqAhzBgQcXqiYw6kK/9N8f6KNBXrXUeWwDwwNkeTDAQt6eO7BESy4x4JEmVpLDcoakkE
	 miUaaA71RwGGumMrB3n7FVQDxqNdUEp06ZjU0DJO/DU8mUgztJmTC+XGog0+H7Iw2Hi7B
	 WoFGAxkSmAf9/arXczMuLu9UCJiHAG8vrA/NE/GTWBJFkXIJuyM89Ld/u0UGF0ArK+IXp
	 jGHNdKiW2Vq6hxWF0ScvdyWCsUfT+izdunv7CZNutt95wVgUUQdRXnsNykDUKtZN+5qyw
	 0x+IIQZtruitax9Gbh+vQMsEVHqIM0GEtFOTGJOK1FNY6kIT8tDgsOmlDirNKaGK9fw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795704932;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=/unZPiZyth6QJJCpkL+4HkxJQK4/VRfZlEzu03RcRt0=;
	b=4mLm1EzWQYZ/RWjbStTeuN6trFmLPMZYYRjt+67sUDImrQwzxKy2F18LHU4/THYBRcLh
	 yKV+2ziOtCYIF/M6sl1Cm2zAJBTLASVtiA1VzvapRZPk3G4cWr8lfrvFbbWnp1qgsTIpw
	 nw5QjwAMAWw2tk9W9cbYI/ilGh86OAVOTEJxxeznneP63Z/onIn4GfyVRD7ZLQI+1klxf
	 mhuwuLvgN3noTWG4+o2mwoeMNm2mvnSryfK65oIPXZSfEXi39XGgpwt/4duBP3zrwuLEU
	 FSGcA6E6Rtl0UHE1Z1jQXpQDfQLa0eC/U6wI9vWaNH9CInyQ8iQyDGyFrtF8rx8GjAQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=SJi6Ny2Y;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE3F9606A31C;
	Thu, 26 Nov 2026 14:55:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=SJi6Ny2Y
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1BE111F000C0;
	Thu, 26 Nov 2026 14:55:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795704932;
	bh=/unZPiZyth6QJJCpkL+4HkxJQK4/VRfZlEzu03RcRt0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=SJi6Ny2YbANwtagH1LHsCINKPDbz84EnGKlv7bLrV6MADxBgujnwDny3Xm/6Yynpp
	 U8RYiZgbM/q9iYz4xOB53kCSGRcqgfEHYWz8/haxGVZcmRgUgr6XnNaA6aaCdT++PJ
	 NaW+yRB9uSafU/R6ETVH41uu9HhlWZHkVPpsXmA0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sergey Ryazanov <ryazanov.s.a@gmail.com>,
	Kalle Valo <quic_kvalo@quicinc.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 025/319] ath10k: turn rawmode into frame_mode
Date: Thu, 26 Nov 2026 15:36:33 +0100
Message-ID: <20261126144007.309066984@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261126144006.732901931@linuxfoundation.org>
References: <20261126144006.732901931@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sergey Ryazanov <ryazanov.s.a@gmail.com>

[ Upstream commit a09740548275a74b897654b3aca5af589289b57a ]

Turn boolean rawmode module param into integer frame_mode param that
contains value from ath10k_hw_txrx_mode enum. As earlier the default
param value is non-RAW (native Wi-Fi) encapsulation. The param name
is selected to be consistent with the similar ath11k param.

This is a preparation step for upcoming encapsulation offloading
support.

Signed-off-by: Sergey Ryazanov <ryazanov.s.a@gmail.com>
Signed-off-by: Kalle Valo <quic_kvalo@quicinc.com>
Link: https://lore.kernel.org/r/20220516032519.29831-4-ryazanov.s.a@gmail.com
Stable-dep-of: 2a87e367c628 ("wifi: ath10k: Stop unanswered temperature reads")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/ath/ath10k/core.c | 11 +++++++----
 drivers/net/wireless/ath/ath10k/core.h |  1 +
 2 files changed, 8 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/core.c b/drivers/net/wireless/ath/ath10k/core.c
index 4a93c415db07b..0a8fc3cd74038 100644
--- a/drivers/net/wireless/ath/ath10k/core.c
+++ b/drivers/net/wireless/ath/ath10k/core.c
@@ -32,9 +32,11 @@ EXPORT_SYMBOL(ath10k_debug_mask);
 static unsigned int ath10k_cryptmode_param;
 static bool uart_print;
 static bool skip_otp;
-static bool rawmode;
 static bool fw_diag_log;
 
+/* frame mode values are mapped as per enum ath10k_hw_txrx_mode */
+unsigned int ath10k_frame_mode = ATH10K_HW_TXRX_NATIVE_WIFI;
+
 unsigned long ath10k_coredump_mask = BIT(ATH10K_FW_CRASH_DUMP_REGISTERS) |
 				     BIT(ATH10K_FW_CRASH_DUMP_CE_DATA);
 
@@ -43,15 +45,16 @@ module_param_named(debug_mask, ath10k_debug_mask, uint, 0644);
 module_param_named(cryptmode, ath10k_cryptmode_param, uint, 0644);
 module_param(uart_print, bool, 0644);
 module_param(skip_otp, bool, 0644);
-module_param(rawmode, bool, 0644);
 module_param(fw_diag_log, bool, 0644);
+module_param_named(frame_mode, ath10k_frame_mode, uint, 0644);
 module_param_named(coredump_mask, ath10k_coredump_mask, ulong, 0444);
 
 MODULE_PARM_DESC(debug_mask, "Debugging mask");
 MODULE_PARM_DESC(uart_print, "Uart target debugging");
 MODULE_PARM_DESC(skip_otp, "Skip otp failure for calibration in testmode");
 MODULE_PARM_DESC(cryptmode, "Crypto mode: 0-hardware, 1-software");
-MODULE_PARM_DESC(rawmode, "Use raw 802.11 frame datapath");
+MODULE_PARM_DESC(frame_mode,
+		 "Datapath frame mode (0: raw, 1: native wifi (default))");
 MODULE_PARM_DESC(coredump_mask, "Bitfield of what to include in firmware crash file");
 MODULE_PARM_DESC(fw_diag_log, "Diag based fw log debugging");
 
@@ -2490,7 +2493,7 @@ static int ath10k_core_init_firmware_features(struct ath10k *ar)
 	ar->htt.max_num_amsdu = ATH10K_HTT_MAX_NUM_AMSDU_DEFAULT;
 	ar->htt.max_num_ampdu = ATH10K_HTT_MAX_NUM_AMPDU_DEFAULT;
 
-	if (rawmode) {
+	if (ath10k_frame_mode == ATH10K_HW_TXRX_RAW) {
 		if (!test_bit(ATH10K_FW_FEATURE_RAW_MODE_SUPPORT,
 			      fw_file->fw_features)) {
 			ath10k_err(ar, "rawmode = 1 requires support from firmware");
diff --git a/drivers/net/wireless/ath/ath10k/core.h b/drivers/net/wireless/ath/ath10k/core.h
index 5aeff2d9f6cf7..f5b00f55bd5fd 100644
--- a/drivers/net/wireless/ath/ath10k/core.h
+++ b/drivers/net/wireless/ath/ath10k/core.h
@@ -1311,6 +1311,7 @@ static inline bool ath10k_peer_stats_enabled(struct ath10k *ar)
 	return false;
 }
 
+extern unsigned int ath10k_frame_mode;
 extern unsigned long ath10k_coredump_mask;
 
 void ath10k_core_napi_sync_disable(struct ath10k *ar);
-- 
2.53.0



