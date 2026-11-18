Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795038252;
	b=e2f6sCmLpQYiO8EEo59D//0PBlU30IsC5iWc17KQycFWodHAIXXi23InBFEDjLC9/mRG
	 McK4N1yEzU/aQPPB8Nfpclhgz9NKh6mtIHMuGVJ4fNMG/v3Kp6UHNcoAr9tlzFTQVGv7G
	 xyRauI857kJbyfvA6is3V1v+WBKJ+oOuP4ntRbCZL05WkG0ZEjgmMlv/XVEuXDzVqqqEg
	 V8UTHtkfv/eZtZSWEiDy5LVjN6y2C3la8AWTbNNr47EmMTFzAMZIgVGEIbMoAahuG/Qu5
	 EyVoniI2JBhLrfzpW0tynrOIAVxWse9ZLPQq7PHe/QThnEian7E2Zum13fUQaVc6i1g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795038252;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=4t0A0R/Pn7MBD1RaEjBXpUSM2UXV2yKuDfpx4nUxWgM=;
	b=G6ZaPfuhcB9j7henYb3vmXFuldQmz7Ec99vdgQw1DUfxDOiCCStPO6Z8DBRDq4yX36Gu
	 g8ao8GP0PGAdql7ZsfcOQjnSYNxWtOJ2SwUBZaFhaqHexgwgPvgbFPyS4F/djBh/YRWiJ
	 OTwfwG5j6VC3EcMHU5btkKmuPKdHO+fzPc10/jdgUeonhPSsVAWEccCW4xFzHOLqoAu6Z
	 392IlZhNFErGI1CzVMTdgs3scqb5jnBDjyaCM88s5dInaQkyOJ10tJ9ukXUH015petr0Q
	 m42r962ZSKcOvPSNppm5abwOZzgexCrKSZJ2zLctASDIvKcm98D6cdc/leNe6xUOxYA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ZNTU2kq5;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1235F606A31C;
	Wed, 18 Nov 2026 21:44:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ZNTU2kq5
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 664BE1F000C4;
	Wed, 18 Nov 2026 21:44:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795038251;
	bh=4t0A0R/Pn7MBD1RaEjBXpUSM2UXV2yKuDfpx4nUxWgM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ZNTU2kq5/KXFiN089tCHszBBkcXb67c3Og7y6xzbQpFUjUHcwOQr+f3orNnfv7jFG
	 00QTKquJY+nTXyjDS234/o48M/opSsut+rmZsZFyFpQ9g4IYVE6+3AdMQWOQRXScPW
	 Y3awVUf2a0+0CYp4nsDQT+/tB70CKgQh8AqHKiyM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ping-Ke Shih <pkshih@realtek.com>,
	Mehmet Fide <mehmet.fide@screeningeagle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1678/3318] wifi: rtw88: widen the ATIM window while an AP interface is up
Date: Wed, 18 Nov 2026 15:38:20 +0100
Message-ID: <20261118150412.144064493@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 1c3b0f1e93db5..395af1744bb32 100644
--- a/drivers/net/wireless/realtek/rtw88/mac80211.c
+++ b/drivers/net/wireless/realtek/rtw88/mac80211.c
@@ -455,6 +455,7 @@ static int rtw_ops_start_ap(struct ieee80211_hw *hw,
 
 	mutex_lock(&rtwdev->mutex);
 	rtw_write32_set(rtwdev, REG_TCR, BIT_TCR_UPDATE_HGQMD);
+	rtw_write16(rtwdev, REG_ATIMWND, ATIMWND_AP);
 	rtwdev->ap_active = true;
 	rtw_store_op_chan(rtwdev, true);
 	chip->ops->phy_calibration(rtwdev);
@@ -471,6 +472,7 @@ static void rtw_ops_stop_ap(struct ieee80211_hw *hw,
 
 	mutex_lock(&rtwdev->mutex);
 	rtw_write32_clr(rtwdev, REG_TCR, BIT_TCR_UPDATE_HGQMD);
+	rtw_write16(rtwdev, REG_ATIMWND, ATIMWND_DEFAULT);
 	rtwdev->ap_active = false;
 	if (!rtw_core_check_sta_active(rtwdev))
 		rtw_clear_op_chan(rtwdev);
diff --git a/drivers/net/wireless/realtek/rtw88/reg.h b/drivers/net/wireless/realtek/rtw88/reg.h
index 0e76bc07bddef..ec8fe835a9592 100644
--- a/drivers/net/wireless/realtek/rtw88/reg.h
+++ b/drivers/net/wireless/realtek/rtw88/reg.h
@@ -397,6 +397,8 @@
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



