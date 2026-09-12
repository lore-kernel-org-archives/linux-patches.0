Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 371AB34252D;
	Sat, 12 Sep 2026 09:45:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789206360; cv=none; b=V7LdVP3N2Lc1wPnS0+TTyydYtHzpnQB2m5+YUj8y0G+5+qYRnivCQsP/xSQtUTQv+wJVcMB4qlCVxQVQN7dSfzDNgmalvhV30e3KxLRAU/ePW0ppaC9JTczwwaRTUBYna8FPsBP+g38p0ZpyruUzBkJW+WReZ3+x8gvVE790KTk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789206360; c=relaxed/simple;
	bh=UhRYiBTRM0+SYRrfsZzB1VjGvrKFMARU8ILR190XaZY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OW3SdGmlHsKppdfoJ194ONosvEW7MYhgJQW0hbNh9Lp+/yZZioqzh48uzYUZZOvG4waj1gLhlX6KpTxZbirB1i9qG5rI3xb0/xNBhcFDawAjGMp5xyUDFKej1jX7kMcmg2tDLmsiAavxXWqXKejvZtd3JKWJuFVxFWJx9pv230w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=x9WaC+2i; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="x9WaC+2i"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0920D1F000FF;
	Sat, 12 Sep 2026 09:45:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789206359;
	bh=d19xBI4FndS7v3yZh+3PUB0fD9lBgcKfE9osLKOUFzA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=x9WaC+2iydtpkgCx+iOwulZcsY9j1BxILf+mhxm2WOOxk74x46C4X3j4DbSvkg/eN
	 Hwso1THMzI/cIZ+eSJ1zVzib4nQvZWsy7ejCE/cvDiVL20dQHWTbvMwLosZzc7pmhp
	 gurNOXdJAdHZPKGAwRFbe0pDdKD8fs8ICH5tu2nc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pengpeng Hou <pengpeng@iscas.ac.cn>,
	Ping-Ke Shih <pkshih@realtek.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0192/1518] wifi: rtw89: fix HE extended capability length check
Date: Sat, 12 Sep 2026 08:39:21 +0200
Message-ID: <20260912065627.834492135@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065623.398859879@linuxfoundation.org>
References: <20260912065623.398859879@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index 8194ae570ee94..f0773f7c3749a 100644
--- a/drivers/net/wireless/realtek/rtw89/mac.c
+++ b/drivers/net/wireless/realtek/rtw89/mac.c
@@ -4885,7 +4885,7 @@ static void rtw89_mac_check_he_obss_narrow_bw_ru_iter(struct wiphy *wiphy,
 	elem = cfg80211_find_elem(WLAN_EID_EXT_CAPABILITY, ies->data,
 				  ies->len);
 
-	if (!elem || elem->datalen < 10 ||
+	if (!elem || elem->datalen < 11 ||
 	    !(elem->data[10] & WLAN_EXT_CAPA10_OBSS_NARROW_BW_RU_TOLERANCE_SUPPORT))
 		*tolerated = false;
 	rcu_read_unlock();
-- 
2.53.0



