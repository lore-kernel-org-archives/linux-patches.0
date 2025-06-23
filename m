Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 099D8C2E0;
	Mon, 23 Jun 2025 21:32:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750714336; cv=none; b=NphMQguUNCRCK6B5fA/b2EVJgJx6rg//L1hGPPEwXgxt7puKZnB0oZbYMKfD/v05WWSwrHUynQ0FKPBbuQetWw7C3rQzQ2kGAlGxs0Hgb2BMhOBaF+lWN68XdRw/qNzMuNUobTE6NYBhj+i2j4zPcjfZen4kxEhT1AZ0vKNT4JA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750714336; c=relaxed/simple;
	bh=UBsWxQEYF3/Y5KeLCjSCr1O2JzTzBiQMy3O5kOUA8zY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ua1KzHlsfpv2O2kHIoXu0i5r2cQpQI3GOCFJmOFm2K1k3afsYNNs7jb2fY/AOzUnihtAuu+FRBf1PU4IaqdS5Ojw5MXg4HoGxPxnnadrb/j6siqBwqXxJGZNYflDRbHqHkPtBlyhQ7jOHdyTewpdaAcHsMSIqWhLdKt+Gy3DkqE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GpwNL+vU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GpwNL+vU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9092AC4CEEA;
	Mon, 23 Jun 2025 21:32:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750714335;
	bh=UBsWxQEYF3/Y5KeLCjSCr1O2JzTzBiQMy3O5kOUA8zY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GpwNL+vUUyET9o0fUnjnP18hEtZd6UHYCPU4L8itknfmmso/euQ+CpaG0xmPHMa+H
	 emLycsvvZFRo630uZSYqteF1Tu70xiwCa3Byszoq43dshoDGYmKVDcAFHnKjuqFaYA
	 Si/FSXTIuDI+jexdcW0ISsQOJPdCGCSMvTC1k5AQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kuan-Chung Chen <damon.chen@realtek.com>,
	Ping-Ke Shih <pkshih@realtek.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 384/592] wifi: rtw89: 8922a: fix TX fail with wrong VCO setting
Date: Mon, 23 Jun 2025 15:05:42 +0200
Message-ID: <20250623130709.576574926@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130700.210182694@linuxfoundation.org>
References: <20250623130700.210182694@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kuan-Chung Chen <damon.chen@realtek.com>

[ Upstream commit 20aac091a15dc7229ef1a268253fe36bb6b2be39 ]

An incorrect Voltage Controlled Oscillator (VCO) setting
may cause Synthesizer (SYN) unlock, which may lead to a
failure in the TX authentication request.

Signed-off-by: Kuan-Chung Chen <damon.chen@realtek.com>
Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>
Link: https://patch.msgid.link/20250416081241.36138-3-pkshih@realtek.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/realtek/rtw89/rtw8922a_rfk.c | 5 -----
 1 file changed, 5 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtw89/rtw8922a_rfk.c b/drivers/net/wireless/realtek/rtw89/rtw8922a_rfk.c
index c4c93f836a2f5..1659ea64ade11 100644
--- a/drivers/net/wireless/realtek/rtw89/rtw8922a_rfk.c
+++ b/drivers/net/wireless/realtek/rtw89/rtw8922a_rfk.c
@@ -77,11 +77,6 @@ void rtw8922a_ctl_band_ch_bw(struct rtw89_dev *rtwdev, enum rtw89_phy_idx phy,
 					     RR_CFGCH_BAND0 | RR_CFGCH_CH);
 			rf_reg[path][i] |= u32_encode_bits(central_ch, RR_CFGCH_CH);
 
-			if (band == RTW89_BAND_2G)
-				rtw89_write_rf(rtwdev, path, RR_SMD, RR_VCO2, 0x0);
-			else
-				rtw89_write_rf(rtwdev, path, RR_SMD, RR_VCO2, 0x1);
-
 			switch (band) {
 			case RTW89_BAND_2G:
 			default:
-- 
2.39.5



