Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794590724;
	b=M7yHZxqkZG6M2F3QXHaqsrfNEuAdE3fQ3/Z9Z4/qZGMIkwtJYC0CRF1zG8dFihKtsEcy
	 xJDIlOgcspvyIPxc/ojYNPrR741jZSMNRec9YtrjrosDnxdZ3KrxEK77EpyU/ZOd2CJ3M
	 eZcR2F7PiYdj7zuSvhXj2IsORHBbCivPTIRmkVr3c4cSSuMQASd0fEgqv7DMvZzJ9seR5
	 mQHDAovXLV0R8OSBL6q1OnlGed7Lq9yER7drCGyPHSj1tICAA7NzfXwq25S0aOFJGxttg
	 BdAGpkUytvJfUJWrVcbCNpC4jJ0ugI+nOQf6voFjVT382MX9Th+t4sfxLHpja21VNhw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794590724;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=9oF7VsS9OCknRwcSGZiWvugXZThO79cD3g3uCCzKUG4=;
	b=ZGR3ZbNimgaS3ii+X6hshMcKIapSVm8k75zc0JVxiSQdl1MioNck3/G4zOIQO/csM7Iz
	 RXq5YP0TcVr+Y+DBG9dIxccsMxJK44+a50xml2s480Vesh2fR/fp9gWJ+nomveuz4WQR8
	 ORM/jVbQ5K7RPVhQQkuVEbZAngfcR/sLSII6GSSY2Jl6JGbNnUGS+QtQXvZi7HJ4nAme3
	 vXcoGy6i41AwcT+mLamLMenCDSw20xd9zs7c0f/pq94n+Ard7qEsJp5hso2IklJY3BHIR
	 0iqObCydSTd6m3nmZIX+7J+NzDIawtTmc8aCEQHndLE+N5w21QrofBKskREfYuolUBw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=1WQbza1T;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B1ACE607A5E8;
	Fri, 13 Nov 2026 17:25:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=1WQbza1T
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5DE4B1F000C4;
	Fri, 13 Nov 2026 17:25:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794590724;
	bh=9oF7VsS9OCknRwcSGZiWvugXZThO79cD3g3uCCzKUG4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1WQbza1TdHGNPib3EJdvtk1aEE2EIcolu1IrafMGwsRjs521JZW9Z3n9PqjpXWqn4
	 RjBMoj0ne/vozYiBLy2svS82Qf7kn6GbHI28IADVhcnxu/TWIVTXhHo1WIxS+sH5JX
	 IV0q913DkLzy75BjrarRAWpbrqSQjz0fzLIpncog=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nick Morrow <morrownr@gmail.com>,
	Devin Wittmayer <lucid_duck@justthetip.ca>,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 603/686] wifi: mt76: mt7921: assert sniffer on chanctx change
Date: Fri, 13 Nov 2026 10:52:16 -0500
Message-ID: <20261113153842.356072225@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153820.902362109@linuxfoundation.org>
References: <20261113153820.902362109@linuxfoundation.org>
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

From: Devin Wittmayer <lucid_duck@justthetip.ca>

[ Upstream commit a7d35545c2ce11849de4b4397abaf664d79acd28 ]

mt7921_change_chanctx() configures the channel for monitor vifs but
does not re-assert sniffer mode. mt7925_change_chanctx() does. Match
mt7925 by adding the missing mt7921_mcu_set_sniffer(true) call,
completing the architectural pattern from commit 914189af23b8 ("wifi:
mt76: mt7921: fix channel switch fail in monitor mode").

The user-visible regression this asymmetry produced on v6.17 and v6.18
was addressed by commit cdb2941a516c ("Revert "wifi: mt76: mt792x:
improve monitor interface handling"") in v6.19 and backported to the
6.17.y and 6.18.y stable trees. This patch is defense in depth in
case the NO_VIRTUAL_MONITOR change is reintroduced in a future series.

Tested-by: Nick Morrow <morrownr@gmail.com>
Tested-on: RasPi4B, RasPiOS 64 bit, Alfa AWUS036AXML mt7921u
Tested-on: RasPi4B, RasPiOS 64 bit, Netgear A9000 mt7925u
Signed-off-by: Devin Wittmayer <lucid_duck@justthetip.ca>
Link: https://patch.msgid.link/20260515183921.23484-1-lucid_duck@justthetip.ca
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Stable-dep-of: 68342a7bd7e5 ("wifi: mt76: move the channel survey when the channel changes")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/mt7921/main.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7921/main.c b/drivers/net/wireless/mediatek/mt76/mt7921/main.c
index 35ece0f617337..1e9070a010345 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7921/main.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7921/main.c
@@ -1405,10 +1405,12 @@ mt7921_change_chanctx(struct ieee80211_hw *hw,
 	vif = container_of((void *)mvif, struct ieee80211_vif, drv_priv);
 
 	mt792x_mutex_acquire(phy->dev);
-	if (vif->type == NL80211_IFTYPE_MONITOR)
+	if (vif->type == NL80211_IFTYPE_MONITOR) {
+		mt7921_mcu_set_sniffer(mvif->phy->dev, vif, true);
 		mt7921_mcu_config_sniffer(mvif, ctx);
-	else
+	} else {
 		mt76_connac_mcu_uni_set_chctx(mvif->phy->mt76, &mvif->bss_conf.mt76, ctx);
+	}
 	mt792x_mutex_release(phy->dev);
 }
 
-- 
2.53.0



