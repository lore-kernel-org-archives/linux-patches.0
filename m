Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D5C525EF9C;
	Tue, 11 Nov 2025 01:06:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762823198; cv=none; b=f9HjcSXO9StVRQsoKaGR642WAc8zOKy0txnLDLx8lOvLGKMigXZVqEJ20Ee4sX4w17aHM+y7LGLsxaQ5SOIBPU5WEzP+oYA+OS0bDXVXbQb0gxgaAEwjtjWD7TtLL+N6T7lWpsNRy7EFTNAifkz5JxfnTUk/R7URaddX67BQSMg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762823198; c=relaxed/simple;
	bh=KUJMzbzgdVODCNF8i7xUyh8HLDcqi3ao0CmviePpYK0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Dkza4+byL1lf0MHdf2pR2PR2wsv2N4bhGuo8RvDuDFmB1g3wlvXPtVgppZ0rI8e7GGEzbFem4dVA9IBEJC/+wB7S98VOmyyGzr1yy7+LwqI1clRp9D9d3EoZVXL/UfQ2rk6vaGqgwmKxZvDbjIEy6+MmsvNXghle81pAKlpSXfk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Y7oAE4/v; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Y7oAE4/v"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F0283C4CEF5;
	Tue, 11 Nov 2025 01:06:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762823198;
	bh=KUJMzbzgdVODCNF8i7xUyh8HLDcqi3ao0CmviePpYK0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Y7oAE4/vGXQYwZlXd9PuWTyokFfDJ2/15c2MCaKWcX3XT/NsyfMsshP8UkGvquwlY
	 1QGNpjnYnhLq/O4H1kB37pG6YYv0ItUTLK9WJK0drOeUwdioHJDHsnatwxxZZcCzcS
	 a09ZhiGhvWLZU5qqJzJq2B4NFuhR664TU482fpvk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sean Anderson <sean.anderson@linux.dev>,
	Ping-Ke Shih <pkshih@realtek.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 195/565] wifi: rtw89: print just once for unknown C2H events
Date: Tue, 11 Nov 2025 09:40:51 +0900
Message-ID: <20251111004531.316894074@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004526.816196597@linuxfoundation.org>
References: <20251111004526.816196597@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 8b7ca63af7ed0..b956ea2add919 100644
--- a/drivers/net/wireless/realtek/rtw89/mac.c
+++ b/drivers/net/wireless/realtek/rtw89/mac.c
@@ -5532,12 +5532,11 @@ void rtw89_mac_c2h_handle(struct rtw89_dev *rtwdev, struct sk_buff *skb,
 	case RTW89_MAC_C2H_CLASS_FWDBG:
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
index 355c3f58ab185..b473e02ecd9e7 100644
--- a/drivers/net/wireless/realtek/rtw89/phy.c
+++ b/drivers/net/wireless/realtek/rtw89/phy.c
@@ -3125,12 +3125,11 @@ void rtw89_phy_c2h_handle(struct rtw89_dev *rtwdev, struct sk_buff *skb,
 			return;
 		fallthrough;
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



