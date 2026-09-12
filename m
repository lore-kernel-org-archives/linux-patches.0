Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EEFF63563FB;
	Sat, 12 Sep 2026 12:06:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789214766; cv=none; b=Kj9n5Takxdk8Nxn82FrPGvCr3l6FdZX6T30VEh/ubAYg0XwrK039sZ6qVdYe4pBEdZQeoVD3yzueLrk/76eF3na97OoGTXz1TVeFUy7MoBDXfj7fBurq0nUjVL0tCUDgBiLL38BOjEYjnJzw7CCcE+DWNVfuC0xsn6v3WZ/3JSc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789214766; c=relaxed/simple;
	bh=FdSCCc2kNoKLy0i+VJU2bOD3quiL0RWniMLHIpPhd0g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=US8Wasef1yT4Ec3+82jlRICwslKtDmbQakUwutEDfbJlK3UJ36OvbsLAtDJWtum9b8OE7NeRs+PVuaAHfbVSif6u9sDO0tyc51ze0x0eozzEqtM+zdn7V5EdLuUk0xeA/bl84GTD9To8yCO2rjKkvD58QOWnfYHPtAGariAXIh4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MrFexq/P; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MrFexq/P"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 011FF1F000FF;
	Sat, 12 Sep 2026 12:06:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789214764;
	bh=df+r16EmchfccUtzzii15WREgcy0V2oqmcTVgXnbHao=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=MrFexq/PlK5d6qiZA8evY6VsRTtNgNKnHkm5GpENqvrFWrO5UJc+3toyt7i6aU7pg
	 f/tCD6sso3z5xM43yfxEPE8YtWKX/snX9O3FgRGq2OfD/ZkwFxHbhG1XisfOnPbYaO
	 czzaSOovLpUbC1zwU3VVaFPcb2oKzRqG6sq7rOoo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pengpeng Hou <pengpeng@iscas.ac.cn>,
	Ping-Ke Shih <pkshih@realtek.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0394/1376] wifi: rtw89: fix HE extended capability length check
Date: Sat, 12 Sep 2026 08:47:00 +0200
Message-ID: <20260912065616.327528739@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.535295758@linuxfoundation.org>
References: <20260912065607.535295758@linuxfoundation.org>
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
index 31465893f866d..f323417a88d20 100644
--- a/drivers/net/wireless/realtek/rtw89/mac.c
+++ b/drivers/net/wireless/realtek/rtw89/mac.c
@@ -4730,7 +4730,7 @@ static void rtw89_mac_check_he_obss_narrow_bw_ru_iter(struct wiphy *wiphy,
 	elem = cfg80211_find_elem(WLAN_EID_EXT_CAPABILITY, ies->data,
 				  ies->len);
 
-	if (!elem || elem->datalen < 10 ||
+	if (!elem || elem->datalen < 11 ||
 	    !(elem->data[10] & WLAN_EXT_CAPA10_OBSS_NARROW_BW_RU_TOLERANCE_SUPPORT))
 		*tolerated = false;
 	rcu_read_unlock();
-- 
2.53.0



