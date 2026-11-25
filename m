Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795621085;
	b=IZUFsoi9FFPF4FfPycfGG1QMMXwYSZIvO50h3cWOCLhYyLg+bUUpzNlZj7DCXfdzj3yi
	 DgfPZpTtSuewkhJetSigWvvC1HHXTYR+whH4G8YDuKB8XVfJqMvkDqHi4TDUQ97AOG4Fz
	 B2WeeJQ3A3PLoDBCU7TnSu6b0dZ10BCLOemZ39uQZkojB1VHY4hxabrzUOdBPfEXewsOH
	 YpqCVJTsYSA4Tsx5ufh5pUqdq3EL+bwMU4ZE+nWjnLc11pYQXDIqPrj9FPqVGRwjgDVQq
	 /HWBE3nkDoi4nY8AeMaXIU2VdtqBRBZOc7Pjw3MjPQEDHpP9tD6hcGfT8JFSB/SUhKQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795621085;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=HDRRL7Cbd6B3W2zON1shDDk0LmxiVSWSZt1sZZ9B6CQ=;
	b=BrRUzU1HzC1tuQrahWX5i8MZWq5O6LmJxevD3Vmwt3XTMOQKMpoFxx7hMDqe0UZCv6Lp
	 h/F0Yfo0fYMqstMaaGI7pAlwaQBxfafdvIlllSoCmXVOsrclTBIXNfOi2SVFXuRtGmlbq
	 aHyNbhC/CIPSZdqyVK0IsJKUZ5/lOBiEyygH42qNm9nLQykzRcK01Z5GtYen7BeMANh/d
	 m6RLIdf6hP6dPhjojtghkMWeslPTn7kiMuFBYzpIF/lyG5yKU/fuI1JVzyXfLIDZ8uLpt
	 08+zsvi3ElrM+Ac8+4dc02qNMCiJGFfmU5cEC+Lp2Dik18X8nO3/0yDD187QyFaoP+g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=NK1e9DOQ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 30240606A31E;
	Wed, 25 Nov 2026 15:38:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=NK1e9DOQ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 82ABE1F000C4;
	Wed, 25 Nov 2026 15:38:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795621085;
	bh=HDRRL7Cbd6B3W2zON1shDDk0LmxiVSWSZt1sZZ9B6CQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=NK1e9DOQp73L2IRB+KchGf1pOVLUlHll/fMCDIE6Vx5BZPBTucpYpTlfliwv2WX/H
	 24YbkFavKN8um6HS3mmsvUBEsxZ9W7mvSZh6eTLpSIB9tRLXVgdnEL9+QcZMx+SEGG
	 OxJJTGJ0fFuMOLWzTUrnsuhUrHkUyfvhf6WRsy9o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mehmet Fide <mehmet.fide@screeningeagle.com>,
	=?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>,
	Jeff Johnson <jeff.johnson@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 071/990] wifi: ath9k_htc: start ANI when an AP interface begins to beacon
Date: Wed, 25 Nov 2026 15:23:58 +0100
Message-ID: <20261125143823.750959194@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

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



