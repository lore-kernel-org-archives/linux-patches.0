Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795617694;
	b=pac3Pujvo1Ta/vRc6yzYZiUnCLczKlLUYcfbV7wmB2PyftZTQcSUQdrfnf0KRwm5jfjP
	 k8NDvB8CNTJ1gVEdyE5i1aMBegSThWKHWU76wZzNabTbJXwQ727O2tm1+UV2IDv2HN8Rb
	 oVqpfaSC2L9sqv1QbYgNvousuzPyb2V7WSwCb05dRFTf+NWqY1uiVQHcq3pLLYH2+Unvk
	 G1z7WxwtFQwgK07cMHVPoY+3GjUGaWQtkBkBVeps55WiRlLWdJDpi72tYlvT5QrnhxBMz
	 KG32291hHL09oSuPJ6fQK2pr4Cud5QdBcjMbhcJY46buFvjcMj5mhsjcFvZkum46Wfw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795617694;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=TnqmaDSRDhEvqJV2rV82smyU/ol6H6KWdO2EKDHpJOo=;
	b=b19uDmwp7DnYxvm90XaPnlbsbNawr5TBPBHZKgEf/t9wG1swB7zzFCABgWhsbD2eErLz
	 yOyksaqeaHimI0NjhIgGdTP7Sl6OHB2/cKZYipIJzYlLA3C6CAkmlAb8QN4QXc720eGfM
	 noC9za6ONkrKgVnT6JaKa7NlR2qblrgDTlzNx4d0ClqIg3oyrJGA//Udx9Euq0f6DhBu/
	 k6miThsPunB0Vu9hgw2zFXKHQn2WY7aQYDiPXp/PiiHEtc4ALwIeC+NlQSHEKST0CUs2e
	 La0XpXv6fmK9sYKfaK1+ZHPuxgZgLJ6awki9ibT0hBfzdIhwnKYskTFR3otPCeJT4RA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="ay0NBw/3";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F6D0606A33A;
	Wed, 25 Nov 2026 14:41:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ay0NBw/3
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 771741F000F4;
	Wed, 25 Nov 2026 14:41:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795617694;
	bh=TnqmaDSRDhEvqJV2rV82smyU/ol6H6KWdO2EKDHpJOo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ay0NBw/3YfIMguY6S240GLDrqLlMObF+ePZMB6uiLt789Wx6JaGVZ33ZtDaMDQOmf
	 eticQGDYlgI4tYStqmHa4yaCtJrASFmenGMRcx1CPliIZ5JzVrsRybuxpgo2sSDVYQ
	 CJIhpIRyHtcD+FapIH02RlbSGZ/VTbMf7pF+40Is=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mehmet Fide <mehmet.fide@screeningeagle.com>,
	=?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>,
	Jeff Johnson <jeff.johnson@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0045/1005] wifi: ath9k_htc: start ANI when an AP interface begins to beacon
Date: Wed, 25 Nov 2026 15:23:03 +0100
Message-ID: <20261125143822.795901512@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

7.3-stable review patch.  If anyone has any objections, please let me know.

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
index 0d6272ac0dac8..611d17202eba2 100644
--- a/drivers/net/wireless/ath/ath9k/htc_drv_main.c
+++ b/drivers/net/wireless/ath/ath9k/htc_drv_main.c
@@ -1554,6 +1554,9 @@ static void ath9k_htc_bss_info_changed(struct ieee80211_hw *hw,
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



