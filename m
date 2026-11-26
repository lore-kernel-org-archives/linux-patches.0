Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795704158;
	b=a/dSH71wFliJ7yZZyK0iQQIpLF6adcdGY5MvVh1QNBxtKzBTEVUyi/qHEAzMJJL83ocu
	 6kfbN1+7mHJ/wS8qvWGSTezMby7TJTJY6WN2b26Ku+uTTzWWZfjfiaZY3lqLa8tqA1/1C
	 m3nGy2GM366kF0fiTBDA+LoWFSbciLJ1OZnGkAjJ0L8mOgWLzWFMrRrmnNXD210Qw9UB6
	 wvoLwdfUHOxPtihHUA2G30KzFOw/jk/87ffMqk3+vkG+B9Sv0WGe+jor4jeiRElpNJfhP
	 xEGsyHfdQwDQdtMZl0sLaK9mDLAc63NJ5t/0h/xYZuDWaVtsqXRMmaaitWrGPcZUCkQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795704158;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=LXz1AVe0jjUjne4tHMT8tYqiOCILuYoKheFWRPNM+Ws=;
	b=tHbk1J6BvV9vgiWpd0om5H7WEOc0rbrCmw/yqrfHx77EpyQOZKQDBV3fE8bGzNlSgUI4
	 ms8aO56eraGpMj7J3QLluGo2Q543xnVbJcvfsfDwtffHz26vViEi7HjJMHtxzzvgQn+0q
	 y0PoA+XYrhfuzZ284u+t9QV+L0mxA1Lub2Jx3FtImC9sanK6/yxy7k+FTn5Yl38zGuo2q
	 b4JyC/FCjT8sMclWIp5H8A+8BtOvvBD6dq6qFG7+ki/RFAimjsF6Ywe5P22Og34zeTE2u
	 lGXXLU9ITH/MumGYOaEL/cd59FqQmJvDBHLb2BYdgFZis3p/82cTE8G4Ag3aLE64yXg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="Zq/bi8OS";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B6ADD606A31E;
	Thu, 26 Nov 2026 14:42:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Zq/bi8OS
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E33E81F000C4;
	Thu, 26 Nov 2026 14:42:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795704158;
	bh=LXz1AVe0jjUjne4tHMT8tYqiOCILuYoKheFWRPNM+Ws=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Zq/bi8OSJpFJwlH61dYLPgRfvJeAIq3UcsPaU/OJwg9luNrJTx8Ut5EmQM4bArvRt
	 zqLhwSxku5wMu8T00bbKxzA7oEP+D24B2yrmWTTIPaYQg6coAHnop5fASTq2TqxUxf
	 Q9KvR/wDQAvWTtWsljdBTbEQFy1e0NBs5o1DiNwo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sergey Ryazanov <ryazanov.s.a@gmail.com>,
	Kalle Valo <quic_kvalo@quicinc.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 026/265] ath10k: turn rawmode into frame_mode
Date: Thu, 26 Nov 2026 15:35:56 +0100
Message-ID: <20261126143606.922483473@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261126143605.076581697@linuxfoundation.org>
References: <20261126143605.076581697@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index a2a52c6276729..78ab02c0b20e7 100644
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
 
@@ -2452,7 +2455,7 @@ static int ath10k_core_init_firmware_features(struct ath10k *ar)
 	ar->htt.max_num_amsdu = ATH10K_HTT_MAX_NUM_AMSDU_DEFAULT;
 	ar->htt.max_num_ampdu = ATH10K_HTT_MAX_NUM_AMPDU_DEFAULT;
 
-	if (rawmode) {
+	if (ath10k_frame_mode == ATH10K_HW_TXRX_RAW) {
 		if (!test_bit(ATH10K_FW_FEATURE_RAW_MODE_SUPPORT,
 			      fw_file->fw_features)) {
 			ath10k_err(ar, "rawmode = 1 requires support from firmware");
diff --git a/drivers/net/wireless/ath/ath10k/core.h b/drivers/net/wireless/ath/ath10k/core.h
index 30c01f18b3d2d..2edb5eafdfdb8 100644
--- a/drivers/net/wireless/ath/ath10k/core.h
+++ b/drivers/net/wireless/ath/ath10k/core.h
@@ -1301,6 +1301,7 @@ static inline bool ath10k_peer_stats_enabled(struct ath10k *ar)
 	return false;
 }
 
+extern unsigned int ath10k_frame_mode;
 extern unsigned long ath10k_coredump_mask;
 
 void ath10k_core_napi_sync_disable(struct ath10k *ar);
-- 
2.53.0



