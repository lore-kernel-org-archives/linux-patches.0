Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795619020;
	b=IEvGqwAIyNHf8PCdWpz/hHSH9lH5Aun9AxHbxwO9Qk5KnAqOTui5bhU0Ko8WQAMeGTxn
	 L0d9GYo7ntE5Au5VZwI0AO3FSoXZS0V7syhB9en6Cf9uTImKZhn/9fr+qLVy59fLpsaqE
	 8bHT9Oqgy7uYt9M7tjyVOCZmgzt2ddtMKutMyjq7MxVkQutDZKWi1ICQXSIsvadPx6EH5
	 XaOWtW45ZdXNVEMxyysMyyY8F+DjJFQCjSO4sOAEadW1ArcDwwiuzrLRNqMdVUn481QRc
	 8YmvL2R0d1/5+TGr/VT6wjECStEadzwZYX3ARufIidLDsRO24COO6vmI5mfBLSQ7f5A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795619020;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=Y6UxEpBLcKhRhUlwUSALPcvK3JpzD3cqOTk8AZoadMs=;
	b=hWhxf2meOfSVPaXrLDxTXbLSr1ZnB5/nREmOCjOIr96W6fdJBtWV+DJeX+VGVrZ8NLTY
	 GdmxBcLK/6W8rbkYTxXLK4U+0AWfsM0RpCF5QmE9Zccv69UiKxyKi+qh+LKj+zB4O+l59
	 v3bvWXvJh2bdm1NjkxWh/E2hwmTMrackdht6qSkm3YZTImo9YFeShEuQvhR3Nsogpy800
	 oVX3/WKogEEwibAbX8t7wGWsTNx+Ze6XHLGmP6SjNg/NuzwWEupqBhbTX0xjUE26DuzbX
	 Myt9MD84QFYMs62q+oroGr8pFNhptYUcpHyyc+BECyTfICNsQi8bFlM5PH9DuEHbgag==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="QWle9bH/";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8AC0C606A31E;
	Wed, 25 Nov 2026 15:03:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=QWle9bH/
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9DE3E1F000C0;
	Wed, 25 Nov 2026 15:03:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795619020;
	bh=Y6UxEpBLcKhRhUlwUSALPcvK3JpzD3cqOTk8AZoadMs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=QWle9bH/j4r4CBRSYaSNeIjgaH/JJjxGS4jyeLJWFIEI3nqQwaUPImXfJqcoV73HE
	 lOcPdt6SEtpF/Oz6PssJJ5RL2rre+HkMko+OKcnxdt2+Qr7SRxGDykSFqSKoPs2j2o
	 kynYevKKFUJW8w19LcxtlYP9EzH62sTj0rTHG01U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Lo=C3=AFc=20Kassel?= <loic.kassel@gmail.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0464/1005] wifi: mac80211_hwsim: use CLOCK_BOOTTIME for the beacon timer
Date: Wed, 25 Nov 2026 15:30:02 +0100
Message-ID: <20261125143832.614549093@linuxfoundation.org>
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

From: Loïc Kassel <loic.kassel@gmail.com>

[ Upstream commit 0da2be70425b21acf6e11bcf02f8a10fd55e85b0 ]

The simulated TSF is based on boottime, and the beacon timer is re-armed
with an absolute expiry derived from the TSF through
mac80211_hwsim_tsf_to_boottime(). The timer itself is however still set
up with CLOCK_MONOTONIC.

Boottime keeps running while the system is suspended, monotonic does
not. After the host has been suspended once, every beacon is therefore
scheduled too late by the total time spent in suspend, and APs
practically stop sending beacons.

Set the beacon timer up with CLOCK_BOOTTIME so that it is consistent
with the TSF.

Fixes: 933f5bec98a1 ("wifi: mac80211_hwsim: register beacon timer by calculating TBTT")
Closes: https://lore.kernel.org/linux-wireless/CAAzpgGdksHZjx4jc20zqnAG_PQ2e1ggANQjt2eiycUiWc+vPHg@mail.gmail.com/
Signed-off-by: Loïc Kassel <loic.kassel@gmail.com>
Link: https://patch.msgid.link/20261023-hwsim-beacon-clock-v1-1-9b3f3ffc099b@gmail.com
[remove useless commit message fluff]
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/virtual/mac80211_hwsim_main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/virtual/mac80211_hwsim_main.c b/drivers/net/wireless/virtual/mac80211_hwsim_main.c
index b9446577ff499..203bf9a4b96e3 100644
--- a/drivers/net/wireless/virtual/mac80211_hwsim_main.c
+++ b/drivers/net/wireless/virtual/mac80211_hwsim_main.c
@@ -6136,7 +6136,7 @@ static int mac80211_hwsim_new_radio(struct genl_info *info,
 
 	for (i = 0; i < ARRAY_SIZE(data->link_data); i++) {
 		hrtimer_setup(&data->link_data[i].beacon_timer, mac80211_hwsim_beacon,
-			      CLOCK_MONOTONIC, HRTIMER_MODE_ABS_SOFT);
+			      CLOCK_BOOTTIME, HRTIMER_MODE_ABS_SOFT);
 		data->link_data[i].link_id = i;
 	}
 
-- 
2.53.0



