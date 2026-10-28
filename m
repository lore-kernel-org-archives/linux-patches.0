Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793216794;
	b=YoAJU0rrnPUoB/hgxR2xm9L+vYzkArtkHVR/VGx3juJpqkpPKXrBNs/brKepjtIKvlXB
	 GqxOJ8aWu0aVpWlpsSdC1AFe9wzEmOpAeQrCJNQzflIe1IU/kbRuCxN1qditQRV0D4RKb
	 pVt6AGYrYRidrzB6pS2gHdYfYUgV/nEnhvn6m/g86VVb5Cd5PA/YnIbqlQQ7gK9KHtFud
	 CUqKnNxZcSViZOT0xupvPu0dk08X7KqMTMWLEN5yxLCGtW89+McZURyQXLRgO9iGaAoCq
	 IWCPzRmGAAxlPmtKSZu7wsDJZunFcF3tJOIvlA2H/xX0oz6xH8U2tJGav91K7AiWwgA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793216794;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=QTibB32Q2aX0j3cNIxlBnw8REqxUIMT6PpG10DomGlE=;
	b=Xpbm5GJIsJDWNki8r7xAoeWV2Fjes3aCocrodFy2p7RaVC+4IvpubP/nZzjxsDGOySAz
	 KJKm88xXWAnn7zbv5dMYV7Cwf6H1vBiDawz+JCJkYA9xIM9rk29Mb3VKnCVekZ8t4VEAf
	 XSc0+zFZi7lS8toVO1mPeGD6zPNFUFgoFGd9PIHSBY4d+XKMIt1sk31QNvwCd+jlWNVD/
	 d7dhgxbhu28T8Z4Uoyj0i8h1xKNgns+9fWNUmTRmyz4CuhNMawnaRfnR4Wgach/vH8mci
	 I8dAMzd5KRE8NvHr75MDmD3KTOpIabt/9IAhMyL4ig9Z6S2m3tya3yBUs6hf2ofxjMw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=aY2cJOWy;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E750606A31C;
	Wed, 28 Oct 2026 19:46:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=aY2cJOWy
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5EE071F01825;
	Wed, 28 Oct 2026 19:46:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793216793;
	bh=QTibB32Q2aX0j3cNIxlBnw8REqxUIMT6PpG10DomGlE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=aY2cJOWyJpuWG1fWf1gpg/bqqjr9n/CebHiP9Nml3Swd3HG2n2orhp37AqcEUDyRW
	 fiFzSXvOaBTaUujujQjWIotksX2AfgKaprdG8HcIiATBbl4PS2Cju+IOxZbRJ2bf2O
	 WjBlIql4scPY5u5UHrgfmqh6KXOtk955FozWNEO0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ping-Ke Shih <pkshih@realtek.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1680/1887] wifi: rtw89: phy: check length before parsing PHY status IE
Date: Wed, 28 Oct 2026 18:02:56 +0100
Message-ID: <20261028170537.688314980@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ping-Ke Shih <pkshih@realtek.com>

[ Upstream commit 884495c39de1a02f42bd40051b921e2311d6ac91 ]

Hardware might report PHY status IE with unexpected length, and parser
might access out of range. Check the length ahead.

Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>
Link: https://patch.msgid.link/20260506131000.1706298-12-pkshih@realtek.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/realtek/rtw89/core.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtw89/core.c b/drivers/net/wireless/realtek/rtw89/core.c
index ff3a31bf3a87d..ec9712b74876f 100644
--- a/drivers/net/wireless/realtek/rtw89/core.c
+++ b/drivers/net/wireless/realtek/rtw89/core.c
@@ -1258,14 +1258,18 @@ static int rtw89_core_rx_parse_phy_sts(struct rtw89_dev *rtwdev,
 	pos = (u8 *)phy_ppdu->buf + PHY_STS_HDR_LEN;
 	end = (u8 *)phy_ppdu->buf + phy_ppdu->len;
 	while (pos < end) {
-		ie_len = rtw89_core_get_phy_status_ie_len(rtwdev, pos);
-		rtw89_core_process_phy_status_ie(rtwdev, pos, phy_ppdu);
+		u8 *iehdr = pos;
+
+		ie_len = rtw89_core_get_phy_status_ie_len(rtwdev, iehdr);
 		pos += ie_len;
 		if (pos > end || ie_len == 0) {
 			rtw89_debug(rtwdev, RTW89_DBG_TXRX,
 				    "phy status parse failed\n");
+
 			return -EINVAL;
 		}
+
+		rtw89_core_process_phy_status_ie(rtwdev, iehdr, phy_ppdu);
 	}
 
 	return 0;
-- 
2.53.0



