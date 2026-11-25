Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795617691;
	b=w2/ld1mkVt1jYIW4livZEzkKwuK/ypvILOtqupiPNdIdWIUd7HKiWptZ5rOhdsLJaRmz
	 eiomO+Ro2NVMGkI1QHZZDdOi5olmfzCKJQQSKFo+kLAB+o0LV3gwdBOOOUF5U5x2i9/3X
	 +nIoTitllBgKeN1fGat+2QbpBFI6su7KMM+urrvptwFFZiwP6rTnZUlT/XOg2z03kSX+U
	 TNHCcoG5mfNeQ/qkjLQtQo++OUapY7fLyTA/bWxXsyTGk0niSrHcUoW5Gtb490FBUsGuW
	 +iHQvUY56qjZ14GlTH8PkoeZmjI6mYMyjhGdZforI4mNwUpi4RQWDEgqgcVpBDUNreA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795617691;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=DmSUOVJ4rpVVOhCosPpiaREc6kQwlZGaw7SPFBe17C8=;
	b=wc3xzAeTB5x/TjRx/8ZI38ZlmqwDGMQ2zeZWYO280XEJpvVEW5/Nb/B6+3eeOmEf7Ua+
	 /ewV7dop7KoaHvAo+nmYWq7U7dGUNzcdX+hdnGXDkp+pW6WUtfcnxf0HgNsbYancrGvMJ
	 XTdyNVmL2xjCSqFpsglukEot48T6kpce1Pv1MEC5RsXfsVX7IleKVjrbRzCZMSls8Ozti
	 7pRnsABKgZNn0CL8/kHsWZOEusAkfeNtOal1fZVygGlas3gs5EIuwiAb14kEwIJf5otY5
	 4FzCZOFnAym8rEVVy8k33HkFvY6vYaAo1kfZAvtNFgsm2Xlzv4JsEG184rAk9yEpwQQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Jsa5ZI5Q;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E95A606A326;
	Wed, 25 Nov 2026 14:41:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Jsa5ZI5Q
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 872511F000C6;
	Wed, 25 Nov 2026 14:41:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795617691;
	bh=DmSUOVJ4rpVVOhCosPpiaREc6kQwlZGaw7SPFBe17C8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Jsa5ZI5QpgkPijjVvfB9nEPVemXOhQuL+8JZPtXtkB2G43y/kRZ9lfzH1JIrjsdP8
	 CiW6tYWe27U6tTWzI6UGZ6tMEygRk6nIll1HFyVJXoPe0BYfZWBEvkCW3pEE0RXuaR
	 RZ97ThZBI5Tiiev4Jy+AyuwPiOeXPW+vDhLhNFKc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Miaoqing Pan <miaoqing.pan@oss.qualcomm.com>,
	Rameshkumar Sundaram <rameshkumar.sundaram@oss.qualcomm.com>,
	Baochen Qiang <baochen.qiang@oss.qualcomm.com>,
	Jeff Johnson <jeff.johnson@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0044/1005] wifi: ath12k: Fix failure to create ath12k_dp_peer on MLO reconnect
Date: Wed, 25 Nov 2026 15:23:02 +0100
Message-ID: <20261125143822.772663025@linuxfoundation.org>
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
Content-Transfer-Encoding: 8bit

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Miaoqing Pan <miaoqing.pan@oss.qualcomm.com>

[ Upstream commit 843a011534b007a609ae25a91581c5c535e78741 ]

In ath12k_mac_op_sta_state(), when transitioning an MLO station from
IEEE80211_STA_NOTEXIST to IEEE80211_STA_NONE, after ath12k_dp_peer_create()
succeeds, on is_sta_assoc_link verification failure, it takes the
'goto exit' path instead of 'goto peer_delete', leaving a stale dp_peer on
the dp_peers_list.

On the next connection attempt, ath12k_dp_peer_create() finds the stale
entry and returns -EEXIST (-17):

    wlP4p1s0: failed to insert STA entry for the AP (error -17)

Fix it by changing 'goto exit' to 'goto free_unassign_link'.

Also, there is another error path in ath12k_mac_op_sta_state() that
jumps to peer_delete after ath12k_mac_assign_link_sta() succeeds, without
undoing the assignment through ath12k_mac_free_unassign_link_sta().
As a result, the link RCU pointer remains assigned and a stale bit is
left in ahsta->links_map, which can trigger the same -EEXIST failure
on subsequent reconnect attempts. Fix this by redirecting that error
path to free_unassign_link instead.

Tested-on: WCN7850 hw2.0 PCI WLAN.HMT.1.1.c7-00108-QCAHMTSWPL_V1.0_V2.0_SILICONZ_UPSTREAM-3

Fixes: 0cd46d1f36ce ("wifi: ath12k: identify assoc link vif in station mode")
Fixes: ee16dcf573d5 ("wifi: ath12k: Define ath12k_dp_peer structure & APIs for create & delete")
Signed-off-by: Miaoqing Pan <miaoqing.pan@oss.qualcomm.com>
Reviewed-by: Rameshkumar Sundaram <rameshkumar.sundaram@oss.qualcomm.com>
Reviewed-by: Baochen Qiang <baochen.qiang@oss.qualcomm.com>
Link: https://patch.msgid.link/20260915080053.918500-1-miaoqing.pan@oss.qualcomm.com
Signed-off-by: Jeff Johnson <jeff.johnson@oss.qualcomm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/ath/ath12k/mac.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/ath12k/mac.c b/drivers/net/wireless/ath/ath12k/mac.c
index 56578321e88c6..b5c3519065a2a 100644
--- a/drivers/net/wireless/ath/ath12k/mac.c
+++ b/drivers/net/wireless/ath/ath12k/mac.c
@@ -7845,7 +7845,7 @@ int ath12k_mac_op_sta_state(struct ieee80211_hw *hw,
 				ath12k_hw_warn(ah, "failed to verify assoc link setting with link id %u\n",
 					       link_id);
 				ret = -EINVAL;
-				goto exit;
+				goto free_unassign_link;
 			}
 
 			arsta->is_assoc_link = true;
@@ -7903,7 +7903,7 @@ int ath12k_mac_op_sta_state(struct ieee80211_hw *hw,
 
 			if (old_state == IEEE80211_STA_NOTEXIST &&
 			    new_state == IEEE80211_STA_NONE)
-				goto peer_delete;
+				goto free_unassign_link;
 			else
 				goto exit;
 		}
@@ -7943,6 +7943,8 @@ int ath12k_mac_op_sta_state(struct ieee80211_hw *hw,
 	ret = 0;
 	goto exit;
 
+free_unassign_link:
+	ath12k_mac_free_unassign_link_sta(ah, ahsta, link_id);
 peer_delete:
 	ath12k_dp_peer_delete(&ah->dp_hw, sta->addr, sta);
 ml_peer_id_clear:
-- 
2.53.0



