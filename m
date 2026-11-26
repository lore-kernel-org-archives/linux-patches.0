Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795704924;
	b=XjGDVGB55xb/FJRix4os1Z1S0nvKy9VOJ4tvYovO5YTdLNN0dPM2/akO9JKm6J353OGw
	 7R4ERNd4ZO1+Jjqf1TSq0OjK6xsu3+dcqW6WgZp/Fu7llLko+NIz9FhRyrqHX1j14WJC9
	 w18djeZAZqor1A2gSsOTAw5plMsNN6zZvOKVdHEPwADplHiCM+JFiQzM3/69wziCFDIyf
	 yC9fZnzxRmvJZZ4GhXShazgKRLLPTw8wDi/yB+j0Ox50SQGZnnbxamVJRN6c29wAbjuQ5
	 TaXbiFirrzHVkj+3Rs+nmfIV9tYKPPgzmYrBnAerkEMkR4kBSfkQjzuexjpaeEUP43w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795704924;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=ndjTefv0G1dlH/GBLv9Mm9wYoXq8AIuGy76+KKiBWF0=;
	b=gFqpwDQbc1ytJnrWG9BvZahH/+ntwY2VKRrEky7R5a+k2vYB7VSpUTEo/TMyab1mVPos
	 OG5gnetTLx8JJA9fsN+Aeci47YApLciZbZhptDMLmaR5m7Lc+elhriIWmw5tOSC5q+VEc
	 tAB9bo3tdZZy6q3lqQ7akvmk1LtesDGhSsu3cMQD4f92wSoCknBo9wAUGreW5vIkcZM48
	 rR4FK3eQBLhS+itmETq9+4VKLIrzTUDDXFZrdIQysM2Dbti3lFl0/Uxa124Wjrjxo21gK
	 A/fnrdjQtgRhjxdmFy3KKwVdovakbiiGko0OpO/zirUeFxU5S5QR/x6hXCNw1qg+QMg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=wBGQVWfk;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BEB79606A321;
	Thu, 26 Nov 2026 14:55:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=wBGQVWfk
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F28351F000C4;
	Thu, 26 Nov 2026 14:55:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795704924;
	bh=ndjTefv0G1dlH/GBLv9Mm9wYoXq8AIuGy76+KKiBWF0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=wBGQVWfkp4+5XBWNwu7gcfQic0lEXTQ8WDHpp82xK6HZ/nL0+TFGFdOsorOS/uJHU
	 jiBsXKaqwV1ymmGy680wGqmTluflUPc4R4mEDsnRKC6WXZLv292WtyztCLsZM0mIkl
	 Gkys74CeXfgYAaC/OOSC0k99zhHxBtnNoDwslmGU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mehmet Fide <mehmet.fide@screeningeagle.com>,
	=?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>,
	Jeff Johnson <jeff.johnson@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 022/319] wifi: ath9k_htc: start ANI when an AP interface begins to beacon
Date: Thu, 26 Nov 2026 15:36:30 +0100
Message-ID: <20261126144007.241875829@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mehmet Fide <mehmet.fide@screeningeagle.com>

[ Upstream commit 5c1b202d67a212c87e7389aaa093ce77828fa98f ]

ath9k_htc_vif_reconfig() re-arms ANI after a channel change when an AP
interface beacons. mac80211 configures the channel before it enables
the beacon, so during a normal AP start that never triggers, and the
start from add_interface that the previous patch removed was cancelled
by the same channel configuration: with hostapd, ANI and the periodic
calibration it drives did not run in AP mode until a later channel
change.

Start ANI when the beacon is enabled. The channel and its calibration
data are in place by then, which is the state vif_reconfig() re-arms
it in, and remove_interface() already stops it with the last AP
interface.

Fixes: a236254c35f0 ("ath9k_htc: Add ANI for AP mode")
Signed-off-by: Mehmet Fide <mehmet.fide@screeningeagle.com>
Acked-by: Toke Høiland-Jørgensen <toke@toke.dk>
Link: https://patch.msgid.link/20261005072209.4101009-3-mehmet.fide@gmail.com
Signed-off-by: Jeff Johnson <jeff.johnson@oss.qualcomm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/ath/ath9k/htc_drv_main.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/wireless/ath/ath9k/htc_drv_main.c b/drivers/net/wireless/ath/ath9k/htc_drv_main.c
index 72ef319feeda7..859fcd59a45df 100644
--- a/drivers/net/wireless/ath/ath9k/htc_drv_main.c
+++ b/drivers/net/wireless/ath/ath9k/htc_drv_main.c
@@ -1552,6 +1552,9 @@ static void ath9k_htc_bss_info_changed(struct ieee80211_hw *hw,
 		ath9k_htc_set_tsfadjust(priv, vif);
 		priv->cur_beacon_conf.enable_beacon = 1;
 		ath9k_htc_beacon_config(priv, vif);
+		if (priv->ah->opmode == NL80211_IFTYPE_AP &&
+		    !test_bit(ATH_OP_ANI_RUN, &common->op_flags))
+			ath9k_htc_start_ani(priv);
 	}
 
 	if ((changed & BSS_CHANGED_BEACON_ENABLED) && !bss_conf->enable_beacon) {
-- 
2.53.0



