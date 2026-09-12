Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D8BE32D47F1;
	Sat, 12 Sep 2026 14:18:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789222738; cv=none; b=PfztKYBbwEIGhHs1X1GSytoDfZTF+7DloCOZ587Qie5IV8JGfn8uDvK1K+2J7zssVV+U1TYOslZo7cRMJpMmT8aHJADFXLkGnAi7pX2kVuQ89GPESqhxbFdBdcWpChR2rfY4JSzhyeLKUiN9aPzXLIVz4/GUG770UPWkm182Ufo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789222738; c=relaxed/simple;
	bh=fZus5+Gi0Eca1pA2S0MivZPC6rcpPR1nbrTniv+HkOE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hOGXoYWW1QcDXLxoM3mIKsGfNhyWjSEfKimEcQKUkju8UleeCm/zeNAfTVUKfFCjEGvRo80sBAyH2jBZTqWWCaDlusF+hZYV6sASq52CiIE8IVKXYiI/LGK9pf0MK9Og16avLEJqDtzOlBG9z7RmKyzf28SS8YaXV/QvgeSUbjY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0xZxfz+9; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0xZxfz+9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7B1351F000FF;
	Sat, 12 Sep 2026 14:18:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789222737;
	bh=IZd5brJw6gSUk98d808xCHhPi6jSsqh1sNtJm2mrJGI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=0xZxfz+9AyrkA2JC++gxU7xF995ucJIgSjS/mK0kAkWAZ14Pp7QQlG96rmaSG1k1f
	 AdDLfLBAEeBduqJrX6tht58eYTmh5zW3jWiPtTLJ4AdVKI+DeUVHSFveEboHcyP2f1
	 KYae/h2LGpngqoRO7N3WtLMZM6Na8sb4ghn4hUUA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pengpeng Hou <pengpeng@iscas.ac.cn>,
	Ping-Ke Shih <pkshih@realtek.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0630/1424] wifi: rtw89: fix HE extended capability length check
Date: Sat, 12 Sep 2026 08:51:02 +0200
Message-ID: <20260912065621.397434791@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.279695368@linuxfoundation.org>
References: <20260912065607.279695368@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 3d63f8b2770e2..fede78213ad8a 100644
--- a/drivers/net/wireless/realtek/rtw89/mac.c
+++ b/drivers/net/wireless/realtek/rtw89/mac.c
@@ -4223,7 +4223,7 @@ static void rtw89_mac_check_he_obss_narrow_bw_ru_iter(struct wiphy *wiphy,
 	elem = cfg80211_find_elem(WLAN_EID_EXT_CAPABILITY, ies->data,
 				  ies->len);
 
-	if (!elem || elem->datalen < 10 ||
+	if (!elem || elem->datalen < 11 ||
 	    !(elem->data[10] & WLAN_EXT_CAPA10_OBSS_NARROW_BW_RU_TOLERANCE_SUPPORT))
 		*tolerated = false;
 	rcu_read_unlock();
-- 
2.53.0



