Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 748F71D0164;
	Wed,  2 Oct 2024 13:49:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727876972; cv=none; b=Ihd7chZBypVjeRw1a8v5cGoSr8UUCMDtp43liD4aRiD+7m2YR84H1YafLE8/jm6ZvOPVEYOo1w1bIyXy94ReY1ya0zRtHZ/ghxOPsn/3KG69fKiqR7oGgdYDx13Jv+uedsGriyDI4L/ktK1K2EgbmKcjaZZErA15u5ymQfK4zV8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727876972; c=relaxed/simple;
	bh=LgTgJSGY5IryIB9NWOqQLXQ1/Sz9+TggdOsWdmXze2g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cL7lKJ2D86ue4d7u+tXIhxxA/elbT+uW9bkJx4+ns9oVsxI0NDQ+5zDHYm8pPlZj2H/eeZFjOFdmZHEq7byObyUrwJDNc1w4D6vEcG0AV3E/xhjlSSIzTVBHvqlK0Q6k5TnMgolp/eOsa2uw1bIyK6qe0ZHa12i3YCZePGzIzb0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=El+1btWX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="El+1btWX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F3BDEC4CEC2;
	Wed,  2 Oct 2024 13:49:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727876972;
	bh=LgTgJSGY5IryIB9NWOqQLXQ1/Sz9+TggdOsWdmXze2g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=El+1btWXhiEyC3DoOmEQIFMxz7tz7rYlOms+Tp8aAaV3jBk5t31kj5h8z3jj6ED/5
	 cy0dL+/iYJ9qH97gLmT/yTIaRcJUqaLlFnggCEVX9AegHI2YLJdSItS7bAIRty66UF
	 TJzcv0lPWmJnQWxudwfdrRA38oenriHTOnp41uZc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bitterblue Smith <rtl8821cerfe2@gmail.com>,
	Fiona Klute <fiona.klute@gmx.de>,
	Ping-Ke Shih <pkshih@realtek.com>
Subject: [PATCH 6.11 621/695] wifi: rtw88: 8703b: Fix reported RX band width
Date: Wed,  2 Oct 2024 15:00:19 +0200
Message-ID: <20241002125847.299574683@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125822.467776898@linuxfoundation.org>
References: <20241002125822.467776898@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Bitterblue Smith <rtl8821cerfe2@gmail.com>

commit 0129e5ff2842450f1426e312b5e580c0814e0de3 upstream.

The definition of GET_RX_DESC_BW is incorrect. Fix it according to the
GET_RX_STATUS_DESC_BW_8703B macro from the official driver.

Tested only with RTL8812AU, which uses the same bits.

Cc: stable@vger.kernel.org
Fixes: 9bb762b3a957 ("wifi: rtw88: Add definitions for 8703b chip")
Signed-off-by: Bitterblue Smith <rtl8821cerfe2@gmail.com>
Tested-by: Fiona Klute <fiona.klute@gmx.de>
Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>
Link: https://patch.msgid.link/1cfed9d5-4304-4b96-84c5-c347f59fedb9@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/wireless/realtek/rtw88/rx.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/net/wireless/realtek/rtw88/rx.h
+++ b/drivers/net/wireless/realtek/rtw88/rx.h
@@ -41,7 +41,7 @@ enum rtw_rx_desc_enc {
 #define GET_RX_DESC_TSFL(rxdesc)                                               \
 	le32_get_bits(*((__le32 *)(rxdesc) + 0x05), GENMASK(31, 0))
 #define GET_RX_DESC_BW(rxdesc)                                                 \
-	(le32_get_bits(*((__le32 *)(rxdesc) + 0x04), GENMASK(31, 24)))
+	(le32_get_bits(*((__le32 *)(rxdesc) + 0x04), GENMASK(5, 4)))
 
 void rtw_rx_stats(struct rtw_dev *rtwdev, struct ieee80211_vif *vif,
 		  struct sk_buff *skb);


