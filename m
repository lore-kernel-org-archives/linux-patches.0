Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794591409;
	b=a0L89YIxUqJoY5ickUSZtMpD6G8XGgwTt1Ld5eUY2VP4LUOTf0HjBsR0pL6Nr0EURwIP
	 Wtl9znoQj7go0N4tBTHkd8EO0tMGsjY3hNtWalC0g4x8x9VtiuTCjMhh9fckqqfewxVmw
	 vZbjL4SraGvSuw7fp0urBj8ZU+MeXiI5symCP3awBl3Zkxs3tPArT/lNQluKehZvi3BO7
	 YiLgWJx+2JkYbBymcR3KYxCIPLuzMzgZ7pEzacRcXxT7z3wrrscBZDYXC2pRzKshsppRX
	 zZbFzKrKxhq8DoAm+4tIbEhWhVFAgdCS4HH1sS4DCxE9IHzUGQ8ZwdrCY68F7PBBypw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794591409;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=5fIfxi2Jds45R1uxVvuKMODNMw38lj8NLHEoc7fBt00=;
	b=mTs9ufNELOf6fXoBtasdOmoq/qXc/cdvB/jg19AYOKSggKs8n4xNZLN4Ox9b635N24m6
	 VcY9aZC9gXtU+9B4DfnuwvYkUl05CC2uIiJRHXnme11Jpue9TRn44bYBYvOzVUZ225Egl
	 M9nGlAJ2m6DLNXJOL4Tf+R+SB4DvDYgVD0uTWKyYg6KDszIBuXjqULH7P4Y8h0gO4n12J
	 cVodIrjEO8rT+r0XVBOgOdsyGZOmN8Cnf4jy4FO4D3Rnjm+ZSjUAXmEisao+edu7bxcC3
	 Zc1jNtkLQkCF//e7onfRTvuZf/1RJcfjfhsWPW5AM7B65wEWTgGfmSL82OPlFtjI4+w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=HEylzwH9;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F7156079D5B;
	Fri, 13 Nov 2026 17:36:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=HEylzwH9
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AF0DD1F000C4;
	Fri, 13 Nov 2026 17:36:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794591408;
	bh=5fIfxi2Jds45R1uxVvuKMODNMw38lj8NLHEoc7fBt00=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=HEylzwH9Z9mfu9JeSQzdZ80CFPePD6w6Cesg3zu2Skrs92449FuR3Z4foNd1TYluv
	 +rdMSXHpjMK1Jak89EIPA1aX+ue+87wbtU40enwoSYQB6hVOXHSvSywjQ1P+ZCtL3P
	 4eAjgwiSTD5KJUI6OwVlXwmbBRZEvYyie5ttzro8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ping-Ke Shih <pkshih@realtek.com>,
	Mehmet Fide <mehmet.fide@screeningeagle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 504/670] wifi: rtw88: widen the ATIM window while an AP interface is up
Date: Fri, 13 Nov 2026 10:51:08 -0500
Message-ID: <20261113153829.028512737@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153811.177190860@linuxfoundation.org>
References: <20261113153811.177190860@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mehmet Fide <mehmet.fide@screeningeagle.com>

[ Upstream commit cf8b516f67652f550e040951b88a2040b375afcf ]

The frames held for dozing stations go out right after the DTIM beacon
and only for the duration of the ATIM window. The chips come up with a
2 TU window (the two that program it set 0x2 at init), which drains
about three frames per DTIM; the vendor driver sets 0xa or 0xc in AP
mode instead. With the 2 TU window the measured page pool exhaustion
takes ~100 s of ordinary multicast chatter; at 0x4 the same storm
already drains, so 0xa leaves comfortable headroom.

Program 0xa when an AP interface starts and put the default back when
it stops, since most chips never initialize the register themselves.
The bound and the filter of the previous patches still apply: the
window adds drain capacity, the budget protects the pool when that is
not enough, the filter keeps chatter off the beacon-paced path.

Suggested-by: Ping-Ke Shih <pkshih@realtek.com>
Signed-off-by: Mehmet Fide <mehmet.fide@screeningeagle.com>
Acked-by: Ping-Ke Shih <pkshih@realtek.com>
Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>
Link: https://patch.msgid.link/20260910081716.769081-4-mehmet.fide@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/realtek/rtw88/mac80211.c | 2 ++
 drivers/net/wireless/realtek/rtw88/reg.h      | 2 ++
 2 files changed, 4 insertions(+)

diff --git a/drivers/net/wireless/realtek/rtw88/mac80211.c b/drivers/net/wireless/realtek/rtw88/mac80211.c
index 910431591420f..bf21937f25b29 100644
--- a/drivers/net/wireless/realtek/rtw88/mac80211.c
+++ b/drivers/net/wireless/realtek/rtw88/mac80211.c
@@ -466,6 +466,7 @@ static int rtw_ops_start_ap(struct ieee80211_hw *hw,
 
 	mutex_lock(&rtwdev->mutex);
 	rtw_write32_set(rtwdev, REG_TCR, BIT_TCR_UPDATE_HGQMD);
+	rtw_write16(rtwdev, REG_ATIMWND, ATIMWND_AP);
 	rtwdev->ap_active = true;
 	rtw_store_op_chan(rtwdev, true);
 	chip->ops->phy_calibration(rtwdev);
@@ -482,6 +483,7 @@ static void rtw_ops_stop_ap(struct ieee80211_hw *hw,
 
 	mutex_lock(&rtwdev->mutex);
 	rtw_write32_clr(rtwdev, REG_TCR, BIT_TCR_UPDATE_HGQMD);
+	rtw_write16(rtwdev, REG_ATIMWND, ATIMWND_DEFAULT);
 	rtwdev->ap_active = false;
 	if (!rtw_core_check_sta_active(rtwdev))
 		rtw_clear_op_chan(rtwdev);
diff --git a/drivers/net/wireless/realtek/rtw88/reg.h b/drivers/net/wireless/realtek/rtw88/reg.h
index 2708ee2f12a47..6ff593f620661 100644
--- a/drivers/net/wireless/realtek/rtw88/reg.h
+++ b/drivers/net/wireless/realtek/rtw88/reg.h
@@ -431,6 +431,8 @@
 #define REG_DRVERLYINT		0x0558
 #define REG_BCNDMATIM		0x0559
 #define REG_ATIMWND		0x055A
+#define ATIMWND_DEFAULT		0x2
+#define ATIMWND_AP		0xa
 #define REG_USTIME_TSF		0x055C
 #define REG_BCN_MAX_ERR		0x055D
 #define REG_RXTSF_OFFSET_CCK	0x055E
-- 
2.53.0



