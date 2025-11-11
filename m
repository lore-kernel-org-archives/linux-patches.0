Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4FB0E306B30;
	Tue, 11 Nov 2025 01:08:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762823325; cv=none; b=nRGhObDRiJHqe8YDbM5KBEjEbFJFyWKU8xuUACtZs5Q8QR15IXqCrw3JstWYkGmQKWmDp211b3atjAviJIfbAKAhzmjBlADYxkWgfTyIO2Vs27Z9WA5GNA2+mejEr/1/Uak1eX3anj6XnA2tDPJtofDP+4tiQTmJIlPOaYmzHWQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762823325; c=relaxed/simple;
	bh=dWp2J/DWQky5/ZwP0tQm4eQpUJxq0Yw/r4rlf0iQzWI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MKO/eicMTcDaO1sHsufnzKww9anE9st3eDaAFrLA8dHzvULKddF7NqqXPPnMQxcLrrqKdMvkpFPdun3l1f/GIbRyICzJzTsnx/Q625PEAO79txBtC0cFQoJKKvQLyqjdMDCTPZdtCcssKyaEl/UrmRgVu3J86MnkDBG/XUG50EQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1XIun5LY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1XIun5LY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E2DA6C113D0;
	Tue, 11 Nov 2025 01:08:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762823325;
	bh=dWp2J/DWQky5/ZwP0tQm4eQpUJxq0Yw/r4rlf0iQzWI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1XIun5LY5WT1vUGQiJBC5zTjhfrHMAF17EBzH1IFz2DQk8ZubP50R3DUFs4sYX17D
	 rede+2oxxkPrTe03p59wx1UPiwRT39GY+C9UfOvZeJlwwzPkTXUxCyGUQpTL3NRsNa
	 psDOgo8AykeThy5f4Ad9/xVGjns4OaiuEtMZX7Us=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sean Anderson <sean.anderson@linux.dev>,
	Ping-Ke Shih <pkshih@realtek.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 276/849] wifi: rtw89: print just once for unknown C2H events
Date: Tue, 11 Nov 2025 09:37:26 +0900
Message-ID: <20251111004543.098245920@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004536.460310036@linuxfoundation.org>
References: <20251111004536.460310036@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ping-Ke Shih <pkshih@realtek.com>

[ Upstream commit 7e1c44fe4c2e1e01fa47d9490893d95309a99687 ]

When driver receives new or unknown C2H events, it print out messages
repeatedly once events are received, like

  rtw89_8922ae 0000:81:00.0: PHY c2h class 2 not support

To avoid the thousands of messages, use rtw89_info_once() instead. Also,
print out class/func for unknown (undefined) class.

Reported-by: Sean Anderson <sean.anderson@linux.dev>
Closes: https://lore.kernel.org/linux-wireless/20250729204437.164320-1-sean.anderson@linux.dev/
Reviewed-by: Sean Anderson <sean.anderson@linux.dev>
Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>
Link: https://patch.msgid.link/20250804012234.8913-2-pkshih@realtek.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/realtek/rtw89/debug.h | 1 +
 drivers/net/wireless/realtek/rtw89/mac.c   | 7 +++----
 drivers/net/wireless/realtek/rtw89/phy.c   | 7 +++----
 3 files changed, 7 insertions(+), 8 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtw89/debug.h b/drivers/net/wireless/realtek/rtw89/debug.h
index fc690f7c55dc7..a364e7adb0798 100644
--- a/drivers/net/wireless/realtek/rtw89/debug.h
+++ b/drivers/net/wireless/realtek/rtw89/debug.h
@@ -56,6 +56,7 @@ static inline void rtw89_debugfs_deinit(struct rtw89_dev *rtwdev) {}
 #endif
 
 #define rtw89_info(rtwdev, a...) dev_info((rtwdev)->dev, ##a)
+#define rtw89_info_once(rtwdev, a...) dev_info_once((rtwdev)->dev, ##a)
 #define rtw89_warn(rtwdev, a...) dev_warn((rtwdev)->dev, ##a)
 #define rtw89_err(rtwdev, a...) dev_err((rtwdev)->dev, ##a)
 
diff --git a/drivers/net/wireless/realtek/rtw89/mac.c b/drivers/net/wireless/realtek/rtw89/mac.c
index 5a5da9d9c0c5b..ef17a307b7702 100644
--- a/drivers/net/wireless/realtek/rtw89/mac.c
+++ b/drivers/net/wireless/realtek/rtw89/mac.c
@@ -5813,12 +5813,11 @@ void rtw89_mac_c2h_handle(struct rtw89_dev *rtwdev, struct sk_buff *skb,
 	case RTW89_MAC_C2H_CLASS_ROLE:
 		return;
 	default:
-		rtw89_info(rtwdev, "MAC c2h class %d not support\n", class);
-		return;
+		break;
 	}
 	if (!handler) {
-		rtw89_info(rtwdev, "MAC c2h class %d func %d not support\n", class,
-			   func);
+		rtw89_info_once(rtwdev, "MAC c2h class %d func %d not support\n",
+				class, func);
 		return;
 	}
 	handler(rtwdev, skb, len);
diff --git a/drivers/net/wireless/realtek/rtw89/phy.c b/drivers/net/wireless/realtek/rtw89/phy.c
index d607577b353c6..01a03d2de3ffb 100644
--- a/drivers/net/wireless/realtek/rtw89/phy.c
+++ b/drivers/net/wireless/realtek/rtw89/phy.c
@@ -3626,12 +3626,11 @@ void rtw89_phy_c2h_handle(struct rtw89_dev *rtwdev, struct sk_buff *skb,
 			handler = rtw89_phy_c2h_dm_handler[func];
 		break;
 	default:
-		rtw89_info(rtwdev, "PHY c2h class %d not support\n", class);
-		return;
+		break;
 	}
 	if (!handler) {
-		rtw89_info(rtwdev, "PHY c2h class %d func %d not support\n", class,
-			   func);
+		rtw89_info_once(rtwdev, "PHY c2h class %d func %d not support\n",
+				class, func);
 		return;
 	}
 	handler(rtwdev, skb, len);
-- 
2.51.0



