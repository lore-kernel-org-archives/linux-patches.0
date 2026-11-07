Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794060634;
	b=jJ5Jkmj0FgXW197qyFKrsOn+gE4CNq6RryXthI2K9TFC66g2LbMecba5Pyv3KQlmu+Cy
	 gcPIcLBn+O9VqrHL0+AvcBzCH4WABJAxlgU8F2hxEQYUCrJZkFc2CpAD7dMGpDi2oF4Eu
	 2ReW1UwCiOwuAwOw8ZvF3UjEnEvWqTp3hH99QNyjnWJ/4qZHworYrnxiViwKmPwABX1qZ
	 S22enlaiOnuZW92UxRVEoC4Z3QbYGQLfyKvWLWQhitV8rj5FDBcA5iL4TSZ/R5WdD+FKH
	 gDLgg4T6ntFyExYlpyNoC8Jdo572dsa0Wl8oIeEo4iDosW0LmeIS8OkNI3XuljeNJ1A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794060634;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=QS6Yepooq1GppTw7wcazlvfVTN3OVqhCup3gNJxskb0=;
	b=0/2Xx97Pr7yOh/pej8m+dmD1sWAWd1ewWc70hJsHMTcvCoNbe2ad5AThiuteoq0cxl8r
	 QjWvQ6wy5u/Vpvq8z9Jf45yXsWgek1kZYbmz9dQ+gqOKoQGIWX/88XUxKaAeIB8VAAUHR
	 FCrjh2U8qCETUijqZo3bf0/Pf1q3Yxx0PyAAhtZbvjVnEnLSib+Amjri5mZQs5hvKMTxH
	 SeViLge3piFB8mql6OoZBK/WQ2Y4pJpqu8W3mhlVqT1rytcYw/KYKjA3pJnFPn7gJ14gk
	 ivGZgt2FI5OR6pmsP2GhwRZn7da+EB+e0fbjxTKsajgZu/x/y/kdI9DAQOAVZGGgfbg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=FemJGabi;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4EE21606A32C;
	Sat,  7 Nov 2026 14:10:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=FemJGabi
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B98CD1F0089F;
	Sat,  7 Nov 2026 14:10:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794060634;
	bh=QS6Yepooq1GppTw7wcazlvfVTN3OVqhCup3gNJxskb0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=FemJGabi8V+8b/fm1QJL4xsNnC3QG5SYE9iHZtX/fADpwLO7PtU0dJpm38XrhuhLi
	 7OB6A/nvObdz6cEvjkYfrDibWLzFFX90JumvuL4KmQbm7JQ3MniUm5xYE/CQEK3/J0
	 w+UOu7/XDW11QxJkbB/K18aXwRmI2QqVedFWuUx8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chih-Kang Chang <gary.chang@realtek.com>,
	Ping-Ke Shih <pkshih@realtek.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0076/1536] wifi: rtw89: wow: only WiFi 6 chips initialize RF registers in WoWLAN mode
Date: Sat,  7 Nov 2026 08:34:52 -0500
Message-ID: <20261107134959.810570370@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134957.653319350@linuxfoundation.org>
References: <20261107134957.653319350@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index db68ac988cd24..38181035ef8ea 100644
--- a/drivers/net/wireless/realtek/rtw89/wow.c
+++ b/drivers/net/wireless/realtek/rtw89/wow.c
@@ -1249,7 +1249,8 @@ static int rtw89_wow_swap_fw(struct rtw89_dev *rtwdev, bool wow)
 	if (disable_intr_for_dlfw)
 		rtw89_hci_enable_intr(rtwdev);
 
-	rtw89_phy_init_rf_reg(rtwdev, true);
+	if (chip->chip_gen == RTW89_CHIP_AX)
+		rtw89_phy_init_rf_reg(rtwdev, true);
 
 	ret = rtw89_fw_h2c_role_maintain(rtwdev, rtwvif_link, rtwsta_link,
 					 RTW89_ROLE_FW_RESTORE);
-- 
2.53.0



