Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F54C15445E;
	Tue, 23 Jan 2024 00:23:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705969396; cv=none; b=U2eHh8e5H+/OqMEkGcQTy01pWK/cPfOavQ2MIZjmKnDhuITY1SIwUIiARimdRmonrJGlWZgAlRj/2AqxVcMgwYkArlIjJSCfV2wuEgzNnCJNykEW4hTD97DY/N5+vAJOMFTqXvlYSSY5FnxYBPVyjoDFMXC/ledkx1tY8I2wWxY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705969396; c=relaxed/simple;
	bh=9oROOpqIxO+cilhEEpPg6QOy9/ag9o6l62eaQkBqnsU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aJka6iE/TOnAHKEBTbMkFwNc3J0zmRxnfS7TcDe5gr8aa9i/pKbvvcw5MOF838SU0hUnWE+8NSw+RzzFov3xafw6SkggyGwq9+CchboBHC3TCM0U9bCeZtksxiOnXbCkdD9FdJxMnShQ7lJhDGLYllWF1G4MhwVoWwEOoggt5vM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Dh/Z7czM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Dh/Z7czM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 04F96C43399;
	Tue, 23 Jan 2024 00:23:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705969396;
	bh=9oROOpqIxO+cilhEEpPg6QOy9/ag9o6l62eaQkBqnsU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Dh/Z7czM3/rEJsqmHxOJOSNOAWVoSipTBWh1cRJcAVGdYZCDZqyEwaQj4fgrZiHX4
	 NlaKNX9k8k/Yw8QT9dFGaDlgA4Z/9FHhjkqbjtAbobmM3we/Nqi/kk+61Ky1a9yHwq
	 znaqLcMOFG/TozQjtWlqXvhZuCu1bJgPMCO57myg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Su Hui <suhui@nfschina.com>,
	Kalle Valo <kvalo@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 210/641] wifi: rtlwifi: rtl8192cu: using calculate_bit_shift()
Date: Mon, 22 Jan 2024 15:51:54 -0800
Message-ID: <20240122235824.521452322@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235818.091081209@linuxfoundation.org>
References: <20240122235818.091081209@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Su Hui <suhui@nfschina.com>

[ Upstream commit f4088c8fcbabadad9dd17d17ae9ba24e9e3221ec ]

Using calculate_bit_shift() to replace _rtl92c_phy_calculate_bit_shift().
And fix an undefined bitwise shift behavior problem.

Fixes: f0a39ae738d6 ("rtlwifi: rtl8192cu: Add routine phy")
Signed-off-by: Su Hui <suhui@nfschina.com>
Signed-off-by: Kalle Valo <kvalo@kernel.org>
Link: https://msgid.link/20231219065739.1895666-6-suhui@nfschina.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/realtek/rtlwifi/rtl8192cu/phy.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8192cu/phy.c b/drivers/net/wireless/realtek/rtlwifi/rtl8192cu/phy.c
index a8d9fe269f31..0b8cb7e61fd8 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8192cu/phy.c
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8192cu/phy.c
@@ -32,7 +32,7 @@ u32 rtl92cu_phy_query_rf_reg(struct ieee80211_hw *hw,
 		original_value = _rtl92c_phy_fw_rf_serial_read(hw,
 							       rfpath, regaddr);
 	}
-	bitshift = _rtl92c_phy_calculate_bit_shift(bitmask);
+	bitshift = calculate_bit_shift(bitmask);
 	readback_value = (original_value & bitmask) >> bitshift;
 	rtl_dbg(rtlpriv, COMP_RF, DBG_TRACE,
 		"regaddr(%#x), rfpath(%#x), bitmask(%#x), original_value(%#x)\n",
@@ -56,7 +56,7 @@ void rtl92cu_phy_set_rf_reg(struct ieee80211_hw *hw,
 			original_value = _rtl92c_phy_rf_serial_read(hw,
 								    rfpath,
 								    regaddr);
-			bitshift = _rtl92c_phy_calculate_bit_shift(bitmask);
+			bitshift = calculate_bit_shift(bitmask);
 			data =
 			    ((original_value & (~bitmask)) |
 			     (data << bitshift));
@@ -67,7 +67,7 @@ void rtl92cu_phy_set_rf_reg(struct ieee80211_hw *hw,
 			original_value = _rtl92c_phy_fw_rf_serial_read(hw,
 								       rfpath,
 								       regaddr);
-			bitshift = _rtl92c_phy_calculate_bit_shift(bitmask);
+			bitshift = calculate_bit_shift(bitmask);
 			data =
 			    ((original_value & (~bitmask)) |
 			     (data << bitshift));
-- 
2.43.0



