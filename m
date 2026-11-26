Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795704153;
	b=ZYa40YVzihZLrqVQXVFtLbJcSqAX0HibdLZubFZQk7uXUEge47hEZ5B4uco3AVV0wTtU
	 P7mnztm71X9d/6zlTq7zJKHHHF1H+SAJcbWHryG3Z++CpUwXe/Lr3iRwY4ockC8hpmt1P
	 XRMOSpJyexBl2GPcXjkstoRtBP0WypsyiL1fvntfjFD8dunw5iGeEdAQkniQnUgONgZzg
	 6CwXFP8qScpA4iqq631RZUCkPF9UFV/ZQtx6/OO8d+AsbpiWuXM0h0IfRiDXA408EEi/S
	 x3YV0Eu58u0b6o3eDUv7r7WMhEz+hJkmMSMWP9hZvWzt6noQopDHLCKLeGWs1smXUEQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795704153;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=hXqCFsGrkWFckrNotJ7FkZkGUGjpGUdCyq4gfhFbljo=;
	b=iEbU0hTbOpdKnb2X8K9TmHPGCRxyDRzPove7hsPYeEGUqcqAoN6h6qITcYj+CIkif1mo
	 bEfZq1ehOJ8Y6xkXNRlqwWwgFSU0WNFBYdqBcS3iZFgVxtRyNIVjNvLFrOnsbu/nEgxq0
	 M2PZ06QElA87/hFcVaFIH6/guNH3nGrAnvY/rtU0L7xQ5FPZ1Gpn/pNlEvj41NASxWpV/
	 /Fgx9yxoV3kK3hKpufUSR0TF0PuM2tsPbT3eZXbq1KWyHrvF3t7U91rsrW0jDOU7AgTmK
	 5tGvwilqCT3BfYUlMvbmMeynmWdfFzNmCnR6WjV0TzHtwQBPpe4N2FZSegQmAYMlWTg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=msHx3Bqz;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 35B05606A31C;
	Thu, 26 Nov 2026 14:42:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=msHx3Bqz
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1FD171F000C4;
	Thu, 26 Nov 2026 14:42:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795704152;
	bh=hXqCFsGrkWFckrNotJ7FkZkGUGjpGUdCyq4gfhFbljo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=msHx3Bqz2BxLk8ZjLkKm9lZHlkJq2slfU7YVy7Pzrttg8bv2iAkBgJExi6tXbA+bH
	 6S7T7cNlLeYRpXxwc4RS+ufKDBaVuIAPBkNVyjyc20OkOcvCYXmcPMhSvNc6G/98vG
	 kzfc1071jCxT9VjGbb+YJ/VMD8PCgtw+fV8x9IpI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mehmet Fide <mehmet.fide@screeningeagle.com>,
	=?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>,
	Jeff Johnson <jeff.johnson@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 024/265] wifi: ath9k_htc: start ANI when an AP interface begins to beacon
Date: Thu, 26 Nov 2026 15:35:54 +0100
Message-ID: <20261126143606.772043146@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

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



