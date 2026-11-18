Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795018890;
	b=jPD2VXA2KhzIGncb8lxDZyEFEzVR1edwc8va+rJWyy0zPLmt44eV1nS0yjxkCPZd2kXc
	 QUepJ3kLdqLJmKBncuVGECQSxrUG963Gi/y5VO9ZnWAkIa8bP3VjeYjamnJ1vkHW0EP+H
	 OoYxQSKXXy0d5C/DLMu0Y9vjSvHyljJ6Q1N2wyk/FLvWzVuGTOv6vyXwHSLWcHI6FEIX/
	 DLBDRgB3opbpQVYid3++O0Hz2qNERH43SHJtpwZKDxntQeAit43TJ1KoCTjl6AtzcUTXu
	 R+WyEXk7yf4O8sDq6AMGzdEISvyj1ALCSkGCOPUlmix9cypZwOZn/OlZoTvPUomjPRA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795018890;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=269Wl2Y73U+zqiesW6jVPLULzCIKPmlS3Rptdzr7HWE=;
	b=k8Ols/pMyyw5CjPgftopR69XkN2EnSegkWJyxsHT8QgkbAol3c2FwiKp9IcGaNgyok2R
	 8t7aSMwxUjBf1UbVGuxt/LsmbIcFBbsYTLGv2vgknRRo05mnZKh/IvkyRAU9nXU4yYN81
	 rSWy7iK8l2+kDW3UAmgoR039PeRMDr3WfsATzDteY4mxbd6ZKjCoE4y5ncNM8EoTxg+Rh
	 41U8Y0HCpNUXX/nhRvmQ/O1IGqfWCAQJvyodRsqNUAO7gPcq/UmxaYCDKbSCwPQIqyh7J
	 5xhNSGTCLnSBT2RlB5e1a+oo6QDAoBGPny3/NOftdDL9ZiqUtxKrkpfze06T+a7LX3A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=HEu2vY7L;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 50063606A320;
	Wed, 18 Nov 2026 16:21:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=HEu2vY7L
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AB5CC1F000C5;
	Wed, 18 Nov 2026 16:21:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795018890;
	bh=269Wl2Y73U+zqiesW6jVPLULzCIKPmlS3Rptdzr7HWE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=HEu2vY7L8v103OypSXzsyRCpuMNHSovga/2BxbcnDWi2CtRCyX119rCUD8W8lHmqk
	 8tXO5/DBDURDuvEovAlkXV7kURR9EnKNAmyVwkkFF7SrnFitigeb4WnDJZgU1jkkZp
	 Qkp1Kt+hwNHrzPJDeTSLHgJydnsZ2l1gDRaeG7GQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Samuele Yang <samuele.yang@morsemicro.com>,
	Lachlan Hodges <lachlan.hodges@morsemicro.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1402/2651] wifi: mm81x: start beaconing on beacon enable not interface add
Date: Wed, 18 Nov 2026 15:44:02 +0100
Message-ID: <20261118150338.487419779@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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

From: Samuele Yang <samuele.yang@morsemicro.com>

[ Upstream commit 54b96109768276fa6dd0bad8e5701ad55643412a ]

Currently we only initialise and start the beaconing process when the
AP interface is first added. If the BSS alone is reconfigured and
beaconing is temporarily stopped, the subsequent call to re-enable
the beacon via BSS_CHANGED_BEACON_ENABLED is ignored and beaconing will
be permanently stopped until the interface is completely re-added.

To fix, move the beaconing start/stop to mm81x_mac_ops_bss_info_changed
and react accordingly to info->enable_beacon and just keep the per-vif
work item init in the add_interface callback.

Fixes: b1906cea00b0 ("wifi: mm81x: add mm81x Wi-Fi HaLow driver")
Signed-off-by: Samuele Yang <samuele.yang@morsemicro.com>
Link: https://patch.msgid.link/20260929033408.69266-1-samuele.yang@morsemicro.com
Signed-off-by: Lachlan Hodges <lachlan.hodges@morsemicro.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/morsemicro/mm81x/mac.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/morsemicro/mm81x/mac.c b/drivers/net/wireless/morsemicro/mm81x/mac.c
index 2760e9389518b..e3740ba0f91e1 100644
--- a/drivers/net/wireless/morsemicro/mm81x/mac.c
+++ b/drivers/net/wireless/morsemicro/mm81x/mac.c
@@ -1319,11 +1319,10 @@ static void mm81x_mac_beacon_work(struct work_struct *work)
 	mm81x_skbq_skb_tx(mq, &beacon, &tx_info, MM81X_SKB_CHAN_BEACON);
 }
 
-static void mm81x_mac_beacon_init(struct mm81x_vif *mors_vif)
+static void mm81x_mac_beacon_start(struct mm81x_vif *mors_vif)
 {
 	struct mm81x *mors = mm81x_vif_to_mors(mors_vif);
 
-	INIT_WORK(&mors_vif->u.ap.beacon_work, mm81x_mac_beacon_work);
 	mm81x_mac_beacon_irq_enable(mors_vif, true);
 	atomic_inc(&mors->num_bcn_vifs);
 }
@@ -1546,7 +1545,9 @@ static void mm81x_mac_ops_bss_info_changed(struct ieee80211_hw *hw,
 		mm81x_cmd_config_beacon_timer(mors, mors_vif,
 					      info->enable_beacon);
 
-		if (!info->enable_beacon)
+		if (info->enable_beacon)
+			mm81x_mac_beacon_start(mors_vif);
+		else
 			mm81x_mac_beacon_finish(mors_vif);
 	}
 
@@ -2214,7 +2215,7 @@ static int mm81x_mac_ops_add_interface(struct ieee80211_hw *hw,
 	rcu_assign_pointer(mors->vifs[mors_vif->id], vif);
 
 	if (vif->type == NL80211_IFTYPE_AP)
-		mm81x_mac_beacon_init(mors_vif);
+		INIT_WORK(&mors_vif->u.ap.beacon_work, mm81x_mac_beacon_work);
 
 	ret = mm81x_cmd_get_capabilities(mors, mors_vif->id, &mors->fw_caps);
 	if (ret) {
-- 
2.53.0



