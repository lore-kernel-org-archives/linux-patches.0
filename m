Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 570BD346E75;
	Sat, 12 Sep 2026 07:17:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789197433; cv=none; b=QPdQ2CcF1lJI0uFBzjZvlQ77c6O28zCW4ALvoOIRR7iy22CWWjmozSittq4EOf+8KPZ++U/YB2dvGQ+GEiDkJyc2TOAcy0Nz68sbiU3ReZu+3+wI/tB/ABkKLFNkwYGb/J9PzcLwVz3g1/x/Rs0GUc/QEIQx8Nv5bvBdg34+Sm0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789197433; c=relaxed/simple;
	bh=k7K1bbPgvgVN30E5blHtBXfZFGeVqSq7W/1npG46Lhg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=d0NemUauY/YE1j6k5UA2i95qvYQokE1KgNVktbi1lMVFL19Hy/wRs+YF+sAQLxXZgNEHD6ZNAB9U8A3B5dgahmLN933nG/BBOglquypWadv5c1V6NBm3rdUvix+0Gf1pTbFVOrDLS9BZAZiNPODOyTUsVansD3QPG8FopK6dFaU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VkMUWeg2; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VkMUWeg2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EB6E31F000FF;
	Sat, 12 Sep 2026 07:17:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789197432;
	bh=a5VuUMEoWvGpXSRNeaW5FTTcM8ADhq0K+Y3pCtPuG1A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=VkMUWeg2JSNGLBphsCpKpAhOOSSlnUlSKP73iXk0sctmBU6syLjJWZUqbyPibhqAa
	 7BNe3uLJzgcVazbin37JcDSWMcQuLxuwImadO+pkz1uwrOHvdg2kkwI3zYeorMBop2
	 aPk8yqIblK1A4Welgc69H7o+58T0rSSJHSTBfNkY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pengpeng Hou <pengpeng@iscas.ac.cn>,
	Ping-Ke Shih <pkshih@realtek.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 0172/1815] wifi: rtw89: fix HE extended capability length check
Date: Sat, 12 Sep 2026 08:32:02 +0200
Message-ID: <20260912065653.044537622@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

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
index 8c395517bd2fe..99de1b2029768 100644
--- a/drivers/net/wireless/realtek/rtw89/mac.c
+++ b/drivers/net/wireless/realtek/rtw89/mac.c
@@ -5167,7 +5167,7 @@ static void rtw89_mac_check_he_obss_narrow_bw_ru_iter(struct wiphy *wiphy,
 	elem = cfg80211_find_elem(WLAN_EID_EXT_CAPABILITY, ies->data,
 				  ies->len);
 
-	if (!elem || elem->datalen < 10 ||
+	if (!elem || elem->datalen < 11 ||
 	    !(elem->data[10] & WLAN_EXT_CAPA10_OBSS_NARROW_BW_RU_TOLERANCE_SUPPORT))
 		*tolerated = false;
 	rcu_read_unlock();
-- 
2.53.0



