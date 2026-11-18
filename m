Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795023001;
	b=gu4/xbL1fBcB4NzqkX1yhTrEq1J/sTLIQywarTQOeITn/cT/7yzDLCW1EZstgT/1I9B3
	 A/pDS237BJfSObPwccVxquMyVunqQBYKZuVreAbMT8/zUDLkmRIoUTwZMzun7zFUzgOkz
	 MvUsO4ivrVJ9MRenXxR5BmliDExG8NSG5Di6j2ITTY+Xj40xo+WQBhRZNRUpgtlJy7LH6
	 djvRTcjhZRUIhW6wFsyqwDTEVkZKExivHSObo3wMI0AbRvlLVaE2Zay328xnrMhEkwd5n
	 YhU8S00y1jRALFsLwNd1R6opbWw7dxhN0xguV6yaZnpSOmw8GD45fcouR7Oo2uHpMlg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795023001;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=NczEokDZEu5VaG8O0/qR3bMKj0m7/0Et4rW469wX81Y=;
	b=tn6UMtux+r9TOJkqOWsjwv/e0Z/CrRo5LvnyvXpV8s+ay9pdubb9LAzLDm2+JeKbxN3K
	 DEjqDwK9DopzOexdje/Y3T0CLe9qDsY7eFB16O54BCQWGSTS7ZHGzUSri4yPWtfpETspO
	 IwOiDq4rjGIuL9sm4uLC2AU9+Dd4pn6einxViCH2Gy9MxuAysxA0djAGqNyzHaVAIasdh
	 j2kwyzL0ootQ5bnPfLfsemIRCiVzhfQZuQsSb6Sq1KP53pUs5PRxlzXT6wENeJxOLIvoH
	 bYxx9WYUilJJpqTsEZmq0Dt4VS6g84j8WxupwisglTNSN9r/wTvcPobqXIQxOJ83qnw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=kCTZbvej;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E1A75606A754;
	Wed, 18 Nov 2026 17:30:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=kCTZbvej
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3976A1F000C4;
	Wed, 18 Nov 2026 17:30:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795023000;
	bh=NczEokDZEu5VaG8O0/qR3bMKj0m7/0Et4rW469wX81Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=kCTZbvejEuIpA+SAgDrHgCpkr980GwTeyF2zL2iJlsudJRbTw1vgHoPTYRh47lVsj
	 v26PD7+hhDGBVRM0mrNx6eubHoFFYoOTtWG2qEWLIgqXy+gZTClElaP4iMInDuFIeN
	 8kk1psJt+HiSwZziw72GdPbmQrJ+fVa0UsI6ZvHY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Baochen Qiang <baochen.qiang@oss.qualcomm.com>,
	Rameshkumar Sundaram <rameshkumar.sundaram@oss.qualcomm.com>,
	Jeff Johnson <jeff.johnson@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0213/2151] wifi: ath12k: signal regd update completion when reg event is dropped
Date: Wed, 18 Nov 2026 15:32:28 +0100
Message-ID: <20261118150129.538563103@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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

From: Baochen Qiang <baochen.qiang@oss.qualcomm.com>

[ Upstream commit f2576dc0f894ef33045ba7ed057ec417988bba8a ]

During driver bring-up, ath12k_mac_hw_register() reinitializes
ar->regd_update_completed and sends a set current country command to
firmware. It then relies on the regulatory event from firmware to signal
that completion via ath12k_reg_chan_list_event().

However, when the country being set is identical to the one already
applied at boot time, ath12k_reg_validate_reg_info() returns
ATH12K_REG_STATUS_DROP through the "Avoid multiple overwrites to default
regd" path. In that case ath12k_reg_chan_list_event() jumps to mem_free
before assigning pdev_idx, so pdev_idx stays at its initial value of 255,
'ar' remains NULL and complete_all() is never called.

As a result the reinitialized completion is left unsignalled and the next
ath12k_regd_update() waits the full timeout, printing:

  Timeout while waiting for regulatory update

Fix this by assigning pdev_idx from the event's phy_id right after it is
extracted, before validation, so that the drop and fallback paths still
reach complete_all(). Change the guard at the end to check the index
against ab->num_radios so that an out-of-range phy_id does not lead to an
invalid pdevs[] access.

Tested-on: WCN7850 hw2.0 PCI WLAN.HMT.1.1.c7-00108-QCAHMTSWPL_V1.0_V2.0_SILICONZ_UPSTREAM-3

Fixes: 906619a00967 ("wifi: ath12k: handle regulatory hints during mac registration")
Signed-off-by: Baochen Qiang <baochen.qiang@oss.qualcomm.com>
Reviewed-by: Rameshkumar Sundaram <rameshkumar.sundaram@oss.qualcomm.com>
Link: https://patch.msgid.link/20260729-ath12k-regd-wait-timeout-v1-1-504aa6e7e93c@oss.qualcomm.com
Signed-off-by: Jeff Johnson <jeff.johnson@oss.qualcomm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/ath/ath12k/wmi.c | 11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/ath12k/wmi.c b/drivers/net/wireless/ath/ath12k/wmi.c
index 67c9174a30aab..026afd352e2ce 100644
--- a/drivers/net/wireless/ath/ath12k/wmi.c
+++ b/drivers/net/wireless/ath/ath12k/wmi.c
@@ -6821,6 +6821,14 @@ static int ath12k_reg_chan_list_event(struct ath12k_base *ab, struct sk_buff *sk
 		goto mem_free;
 	}
 
+	/*
+	 * Set the valid pdev_idx before validating so that, even when the
+	 * event is dropped or falls back, the completion the caller in
+	 * ath12k_mac_hw_register() may be waiting on is still signalled at
+	 * the end and it does not time out.
+	 */
+	pdev_idx = reg_info->phy_id;
+
 	ret = ath12k_reg_validate_reg_info(ab, reg_info);
 	if (ret == ATH12K_REG_STATUS_FALLBACK) {
 		ath12k_warn(ab, "failed to validate reg info %d\n", ret);
@@ -6837,7 +6845,6 @@ static int ath12k_reg_chan_list_event(struct ath12k_base *ab, struct sk_buff *sk
 	}
 
 	/* free old reg_info if it exist */
-	pdev_idx = reg_info->phy_id;
 	if (ab->reg_info[pdev_idx]) {
 		ath12k_reg_reset_reg_info(ab->reg_info[pdev_idx]);
 		kfree(ab->reg_info[pdev_idx]);
@@ -6876,7 +6883,7 @@ static int ath12k_reg_chan_list_event(struct ath12k_base *ab, struct sk_buff *sk
 
 out:
 	/* In some error cases, even a valid pdev_idx might not be available */
-	if (pdev_idx != 255)
+	if (pdev_idx < ab->num_radios)
 		ar = ab->pdevs[pdev_idx].ar;
 
 	/* During the boot-time update, 'ar' might not be allocated,
-- 
2.53.0



