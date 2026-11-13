Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794590628;
	b=Jq1Bx+Z11v/vEEjfWn0cQhDwq3iw0wrbI88evtd2fKCEpPwbXFoa2d/HnoTP7QDGtvMk
	 OY8gJnby4HZAvMZTrQIxnmvpfnrBxcKCRp55HWzfP1FmZqX5D013dzypRSlRQgyUARV4Q
	 ZH7Fk7VlJ/XaTEQX7RUQ8kSh6tbRgW99ryuFmwypl8X5jizCBhQsompxtdV3D1VNZYVqa
	 ORZaGTTGC46zeQDYo0f8FGYEXua4d3lg1G/ZDrsjWaOzaPGwGtFG+Zv/NFsTlnKiDDann
	 z8WYkV7J3ehqE73l1W8V5YxZXsER2xa+74il5WDB6DK+SHresHFr+zEaaKZoq4G3Exg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794590628;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=r51XPGMHw1yUI4ha6vYMA6Ny4hyKSEt/jDq8l/VIHig=;
	b=NpZoHgtnDz6EQ5nANJHpJm32erpNKCW9JYdtWfETyer/3ibxIaWPR9w18PHwczxDfA9c
	 GNzTQxbf/EYNiaB7q7jzFh9UKbIrUZzb5F4xoJwqwvEC8PwjCGJX1zAt2vTAQl2HNr+Ug
	 4XJdt1OTxIhFAUpOrwgoL68xpiwh6LYFoeise0h4HhUWOSpkoJEEn4rTvJwuiXC/wRf1o
	 6ZhUo6BDsMouRh90jWbBDC6w8taNqwXlKeeeu5NZcGUJndtX31OubJTE6gtSwuFnQ4GNj
	 MMi1HPdWjrQVDuRs6x0OQwXABiroBmHslhWvVDOw67YaTg/nG/JVTocQSUu6N/r7avw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Qk7nZeUx;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B092B6075E35;
	Fri, 13 Nov 2026 17:23:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Qk7nZeUx
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5C7691F000C5;
	Fri, 13 Nov 2026 17:23:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794590628;
	bh=r51XPGMHw1yUI4ha6vYMA6Ny4hyKSEt/jDq8l/VIHig=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Qk7nZeUx6LKHAk9xa4fKcXA1KrmoOrTeNNKgvCbwtQqe+P0t9FD2jqtvd4J+o4a48
	 KExNYyqZCbJg2IBIDgG8+AO5/8FoiLxCaWHMIJNsuqMqmvbeZFzz6s3aD0zPqCmHBv
	 VxzEJZnPUnVr4ld6ceCWxYjXXWNVAvuj8G8wTIT0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ping-Ke Shih <pkshih@realtek.com>,
	Mehmet Fide <mehmet.fide@screeningeagle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 550/686] wifi: rtw88: widen the ATIM window while an AP interface is up
Date: Fri, 13 Nov 2026 10:51:23 -0500
Message-ID: <20261113153840.205127980@linuxfoundation.org>
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
index 3b6302f14de03..a832720f441bf 100644
--- a/drivers/net/wireless/realtek/rtw88/mac80211.c
+++ b/drivers/net/wireless/realtek/rtw88/mac80211.c
@@ -468,6 +468,7 @@ static int rtw_ops_start_ap(struct ieee80211_hw *hw,
 
 	mutex_lock(&rtwdev->mutex);
 	rtw_write32_set(rtwdev, REG_TCR, BIT_TCR_UPDATE_HGQMD);
+	rtw_write16(rtwdev, REG_ATIMWND, ATIMWND_AP);
 	rtwdev->ap_active = true;
 	rtw_store_op_chan(rtwdev, true);
 	chip->ops->phy_calibration(rtwdev);
@@ -484,6 +485,7 @@ static void rtw_ops_stop_ap(struct ieee80211_hw *hw,
 
 	mutex_lock(&rtwdev->mutex);
 	rtw_write32_clr(rtwdev, REG_TCR, BIT_TCR_UPDATE_HGQMD);
+	rtw_write16(rtwdev, REG_ATIMWND, ATIMWND_DEFAULT);
 	rtwdev->ap_active = false;
 	if (!rtw_core_check_sta_active(rtwdev))
 		rtw_clear_op_chan(rtwdev);
diff --git a/drivers/net/wireless/realtek/rtw88/reg.h b/drivers/net/wireless/realtek/rtw88/reg.h
index 08e9494977e06..0b9ba6f37680b 100644
--- a/drivers/net/wireless/realtek/rtw88/reg.h
+++ b/drivers/net/wireless/realtek/rtw88/reg.h
@@ -483,6 +483,8 @@
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



