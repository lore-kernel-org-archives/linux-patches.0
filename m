Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B44D8DDAB;
	Tue, 11 Nov 2025 01:33:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762824839; cv=none; b=ioKVLAKXjlq38g10idgnVUF/xee+xA6T0UbdMbh1llxq5nrTtccApVO16vpqyG2psmcs6eWqlEg3JaIThmR9PCQvDEbbbLFKx/SxgoJkpsnqylCYVoZFLlBwmPbAmy0san8mfujve/IpSeMqb5NuPnQTG3RDyz0g8JPvY8tIaXE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762824839; c=relaxed/simple;
	bh=VGUmldoED8TRc2Od/Ot4q848F40qmm5gRVhpXFJ2hlo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QRGQMJUCfO1rkbJHkYOQ7KRonZ2H5stqQhyOLhu2gdov47henXX4s6VZon4Fw4188R6KX95i492zFMygSV3A7eFg4i2Sima2mpYTw8MYoxcBJ1m9ZiO9NGzftNn92SvKWACrOQH0Wx4Fp1gtwojXCxiRbRL2kAOJxrOuhxc/ZMc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hWwxSJR7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hWwxSJR7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 54133C113D0;
	Tue, 11 Nov 2025 01:33:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762824839;
	bh=VGUmldoED8TRc2Od/Ot4q848F40qmm5gRVhpXFJ2hlo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hWwxSJR7Bd8hBALOC4jOYI8I2PRpD2h7KZ2GNSqCbqXeP9oPjOCniqRe04JHzZLm9
	 xECFK4HgnGVgySUnaugiybwK9S7sqCYcTtVDY9LNxsEDs0gszsLfW4HzvwqrUYA5wK
	 QmaRdK0lkhg63WKVtA7rvqeo7H53P68SqZIqyFaI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chih-Kang Chang <gary.chang@realtek.com>,
	Ping-Ke Shih <pkshih@realtek.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 582/849] wifi: rtw89: disable RTW89_PHYSTS_IE09_FTR_0 for ppdu status
Date: Tue, 11 Nov 2025 09:42:32 +0900
Message-ID: <20251111004550.490260384@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004536.460310036@linuxfoundation.org>
References: <20251111004536.460310036@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chih-Kang Chang <gary.chang@realtek.com>

[ Upstream commit 4e79a5cc01c5e1f1ba393ed3b44b0c3611eaadf1 ]

The IE length of RTW89_PHYSTS_IE09_FTR_0 is dynamic, need to calculate
more to get it. This IE is not necessary now, disable it to avoid get
wrong IE length to let the parse function check failed.

Signed-off-by: Chih-Kang Chang <gary.chang@realtek.com>
Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>
Link: https://patch.msgid.link/20250915065213.38659-4-pkshih@realtek.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/realtek/rtw89/phy.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtw89/phy.c b/drivers/net/wireless/realtek/rtw89/phy.c
index 01a03d2de3ffb..59cb32720fb7b 100644
--- a/drivers/net/wireless/realtek/rtw89/phy.c
+++ b/drivers/net/wireless/realtek/rtw89/phy.c
@@ -5929,8 +5929,6 @@ static void __rtw89_physts_parsing_init(struct rtw89_dev *rtwdev,
 			val |= BIT(RTW89_PHYSTS_IE13_DL_MU_DEF) |
 			       BIT(RTW89_PHYSTS_IE01_CMN_OFDM);
 		} else if (i >= RTW89_CCK_PKT) {
-			val |= BIT(RTW89_PHYSTS_IE09_FTR_0);
-
 			val &= ~(GENMASK(RTW89_PHYSTS_IE07_CMN_EXT_PATH_D,
 					 RTW89_PHYSTS_IE04_CMN_EXT_PATH_A));
 
-- 
2.51.0



