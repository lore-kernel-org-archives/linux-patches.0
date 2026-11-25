Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795624013;
	b=qVmWYVZzFCF7qbxzEI6gAoqkbFY549GFzTX/yLcWUhabc8q2nUMRa6/q9SFJ2fymBgUF
	 vMXTotgahNcj81uuobMeTjEhO6WuacosnsXuLLOBQ9hoW9d42yRdLm3V5CSsA3ylpQj1O
	 s/ejnGJq+RjyIMB9BKSg46LeLDcTr7A4DM4uKZEvEYCqHpqBjdf1TUGgiHs5WCW68Oj/L
	 HVgFeUCjkQwhYRNSNX9jb8Lqfthi7mZztdZTS+2C3+0zCyvBTAlg1urHbiWMpCQb3rDT6
	 yKsy8Bc6kbN8zefRz/2or9SCYLWB1yCenYE3tDDUDz210yuhG51AAeMdN2Y2j8JS88A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795624013;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=//uathzvhYSb9ws78WKcU9sxNMC+Lr1sC0l4wd2KrT4=;
	b=DJPdBoZvzn5yJvlg2gpIUCcF4dmnTFNWTjaFDBfqNuGW9DwmegHFg9a11OrceEzBZ6Mm
	 gAPux6m6va7xAfzTaRga6+60E38Bcc3dQMVjiuxISdiNXsJWEZTWSOR5oOrJtC1MtztOW
	 j89wcKirlZQ5KUVDGPEG/cMTVtilPJFr0vhAc3Nd7ShImA1VwYm3VkXvqaNNCimT555YG
	 4xaZYN3tVeImxl37BxHIf3dkCnErYY6GHCzNsYXzRhkHlUpg7vQN5GnAzKy9KjGXaIiJq
	 upGx66LhcnQqIlBwL5p+RdfAF0mdTlAIlNwIDAgLzfSy5YYboPzOfqyAAIJbTR2vCwA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=eYOpjkp6;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DFAE5606A32D;
	Wed, 25 Nov 2026 16:26:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=eYOpjkp6
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2AD111F000D8;
	Wed, 25 Nov 2026 16:26:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795624012;
	bh=//uathzvhYSb9ws78WKcU9sxNMC+Lr1sC0l4wd2KrT4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=eYOpjkp6SbduESHaTfQWT/21wOSFN9qIDx6yeHVeBw6LboSJQk1D99u3+rnsZkHFf
	 KGcjX6LDovh4cgnEGWdZQOVuQnqkuStxaNrRo48qHGbRYLh9rHzcze7ocifYZGVZnw
	 I3WF0j7moxBFwtbQrXScWYx/TRy+Fk+w5EGwpC94=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mehmet Fide <mehmet.fide@screeningeagle.com>,
	=?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>,
	Jeff Johnson <jeff.johnson@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 058/816] wifi: ath9k_htc: start ANI when an AP interface begins to beacon
Date: Wed, 25 Nov 2026 15:26:46 +0100
Message-ID: <20261125143850.561412680@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143849.205329330@linuxfoundation.org>
References: <20261125143849.205329330@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 8a03bcc2789e8..afddfac699ce6 100644
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



