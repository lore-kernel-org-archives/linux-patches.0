Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793829382;
	b=T/c1WcFv/qRGqvBFontEmASB1naDHWpLpLtl4tJ2TQUc19pLKumTtv5vQ/9PldpmoF23
	 Gs2rxhAHvS+Z3XMZOkLC+DX5QwrMb2E1xF2A5s0MW/7CRK589sCDLvV15CM3ismDwQsfg
	 T6ZX2iN9CfyDYDJlqFxjn5kvm30jcRaz9X3510CI/dOjiT2S6gZdEPeQF7ACSpVP1gaOt
	 S0TMJJlQ3yJfYejk63VzkJfLLJyu1Oc9ONnrSWAJpG8j72CWNrlDu6BlGVlOr+CDRcRID
	 YmYUncfG/qWjioDkxClcNSUgbzEmowCrNMcxuGwsB0OlJvnAPLVerh9lnujNHwrmKMA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793829382;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=SGxcFQ5r4FjraY8EDdJnSw/qRkShd+MDvYmpBGcuhcM=;
	b=x9PH9mVKtHkjLE1GfY4QzkfY0lvDmpnK17uaAdtcGLws9A1vVAGItF36Wjnc42UxxMPG
	 fVHelgvfrkHyMAKbnQ1I36VALYoFEp076gelXQa8XHyXgYKjy4slku5ZaVS8cl8dY8th9
	 NU2Jxe11IUe/oVGr2nlLSwjf3QeER49yOzbK+jXyuPb0LZyK0s3E2tR2u/6Eh//MowiBs
	 jXU+dejM40wtl0TogW5KUqG+D5FSTy/CKIPA9/3egbKoYBRoY9SY4FjHKfDvRWmv9rQRF
	 rVeYQHqM6ihkdC4c0MUXkp6Tftpn+MFNrTVyLzGHac8aXY7B0Bhsbs4EtOQYP5/rdiQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=QdXmmw2C;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 04BEE606A865;
	Wed,  4 Nov 2026 21:56:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=QdXmmw2C
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 95FF21F00A18;
	Wed,  4 Nov 2026 21:56:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793829381;
	bh=SGxcFQ5r4FjraY8EDdJnSw/qRkShd+MDvYmpBGcuhcM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=QdXmmw2CBb37IX7I6y9jGvT1g0okyZXgkzs7pr6vlxtCg8fm1KwX4MxePDnWN/XyC
	 XOG8md1zPCwbsDaxmdCx9eYBTAq6oy4nRx3eaz+otIpNxrJPdnq4v27XPJo4mIRtHn
	 VsHwTp6XfoR8JeahPG2zoYs/ROuUFajn26lp+eQA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chih-Kang Chang <gary.chang@realtek.com>,
	Ping-Ke Shih <pkshih@realtek.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0089/1005] wifi: rtw89: wow: only WiFi 6 chips initialize RF registers in WoWLAN mode
Date: Wed,  4 Nov 2026 15:57:02 -0500
Message-ID: <20261104211046.120424234@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104211043.516122098@linuxfoundation.org>
References: <20261104211043.516122098@linuxfoundation.org>
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

From: Chih-Kang Chang <gary.chang@realtek.com>

[ Upstream commit dbff9040587e9bd6d3ee337315971957f9f76612 ]

Only the WiFi 6 chips need to initialize RF register when WoWLAN download
FW for some power save issue. Applying the same initialization flow to
WiFi 7 chips might trigger the error
'RF parameters exceed size. path=1, idx=1500.'.

This happens because normal mode uses rtw89_phy_config_rf_reg_v1(), which
skips registers with addresses below 0x100. However, WoWLAN mode uses
rtw89_phy_config_rf_reg_noio(), and WiFi 7 chips do not satisfy the
rtw89_chip_rf_v1() condition. As a result, more RF registers are
configured, causing the size overflow error.

Signed-off-by: Chih-Kang Chang <gary.chang@realtek.com>
Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>
Link: https://patch.msgid.link/20260625061545.44808-11-pkshih@realtek.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/realtek/rtw89/wow.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/realtek/rtw89/wow.c b/drivers/net/wireless/realtek/rtw89/wow.c
index f6cdbc15dcc4a..90046d6f620ef 100644
--- a/drivers/net/wireless/realtek/rtw89/wow.c
+++ b/drivers/net/wireless/realtek/rtw89/wow.c
@@ -1299,7 +1299,8 @@ static int rtw89_wow_swap_fw(struct rtw89_dev *rtwdev, bool wow)
 	if (disable_intr_for_dlfw)
 		rtw89_hci_enable_intr(rtwdev);
 
-	rtw89_phy_init_rf_reg(rtwdev, true);
+	if (chip->chip_gen == RTW89_CHIP_AX)
+		rtw89_phy_init_rf_reg(rtwdev, true);
 
 	ret = rtw89_fw_h2c_role_maintain(rtwdev, rtwvif_link, rtwsta_link,
 					 RTW89_ROLE_FW_RESTORE);
-- 
2.53.0



