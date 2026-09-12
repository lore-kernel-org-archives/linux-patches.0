Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF67747CA7E;
	Sat, 12 Sep 2026 16:07:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789229285; cv=none; b=Do2sYVviWR1f5vneJAe8YjtQnKgXm2yLwBL9hbcJBBvRBZRJMncUNElel84bnInrlZcxA1rne1T3rmlhFTouPUKMyZnx1n2lpyauI9Fh7RBc6LasXElmONf75AmC5MCdBGIhG/7iy34Sar3NkGzamTefS3+U8uijG61cF4bzWpw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789229285; c=relaxed/simple;
	bh=VBZOINZfgLYIRonsHTLwI72cmLoPS7lNX9GC4R4+3TU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rreG+5oSz9maYHksHE9oW6pzKjfIbmiF9xvCIiAuulaFk1A1TMlutSn6OW4PL3VSeeHddwxLHSg6SDbnu0rDFK1XbxBB24m65vofs62nxSqg28eOQEPWQxI9utFCHFhSafn2BBzdVhNhbKT3bmaprHZ4/agVLQD893Q2H7kj6kc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=j7MVNy6Q; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="j7MVNy6Q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EB1111F000FF;
	Sat, 12 Sep 2026 16:07:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789229275;
	bh=aEjhUe5rU2PDFzLsi0y0TxrrXXxk2SRpTCQcsj01x64=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=j7MVNy6QrnWOza335g9VxyMZYNfEoCJpIpXAvIU0HWkr9nNcBYoYDE/8gHcubn4UN
	 JNlaWGrogQ4NJSCm1gr7yQ8GmctrThNhYICAZ3REMowSEdsszCcNp3sA7Qh6IMBiOk
	 /dg0dEo2wdFPZ70IR+qlOiEZT4XGN8ZeKSwX5uP8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pengpeng Hou <pengpeng@iscas.ac.cn>,
	Ping-Ke Shih <pkshih@realtek.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0514/1191] wifi: rtw89: fix HE extended capability length check
Date: Sat, 12 Sep 2026 08:54:02 +0200
Message-ID: <20260912065559.794760096@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065548.086904252@linuxfoundation.org>
References: <20260912065548.086904252@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pengpeng Hou <pengpeng@iscas.ac.cn>

[ Upstream commit 2aba608a86e9b099c9af2ea70b620552dee2b628 ]

rtw89_mac_check_he_obss_narrow_bw_ru_iter() reads extended capability
byte 10, but rejects only datalen values below 10.  Byte 10 requires at
least 11 bytes.

Require datalen >= 11 before reading data[10].

Fixes: 8d540f9d2916 ("wifi: rtw89: disable 26-tone RU HE TB PPDU transmissions")
Signed-off-by: Pengpeng Hou <pengpeng@iscas.ac.cn>
Acked-by: Ping-Ke Shih <pkshih@realtek.com>
Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>
Link: https://patch.msgid.link/2026063009025530.2-ccfa108-0024-wifi-rtw89-fix-HE-extended--pengpeng@iscas.ac.cn
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/realtek/rtw89/mac.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/realtek/rtw89/mac.c b/drivers/net/wireless/realtek/rtw89/mac.c
index f15a2c6874cb0..719e07b826fdf 100644
--- a/drivers/net/wireless/realtek/rtw89/mac.c
+++ b/drivers/net/wireless/realtek/rtw89/mac.c
@@ -3768,7 +3768,7 @@ static void rtw89_mac_check_he_obss_narrow_bw_ru_iter(struct wiphy *wiphy,
 	elem = cfg80211_find_elem(WLAN_EID_EXT_CAPABILITY, ies->data,
 				  ies->len);
 
-	if (!elem || elem->datalen < 10 ||
+	if (!elem || elem->datalen < 11 ||
 	    !(elem->data[10] & WLAN_EXT_CAPA10_OBSS_NARROW_BW_RU_TOLERANCE_SUPPORT))
 		*tolerated = false;
 	rcu_read_unlock();
-- 
2.53.0



