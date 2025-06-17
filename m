Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 88E8E2ED84A;
	Tue, 17 Jun 2025 16:19:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750177195; cv=none; b=MOu2ixqfkJvvps9Kk+e7nZBjTgm+x/eUsBntgT2Sd/lQNrdF/uUN3Y2g3HkynW+76zlXj+0QGXWDWD/EkgqP28VJ7qTBsZ+iZwCxUnVBauVcsnUoDc2FST4PT3A15RsLZBdKSim3qfgd55+LM1Zgkg35ldUmHS4COeSHM3mNBDk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750177195; c=relaxed/simple;
	bh=yHOrWKvR43kb8Z7jJ5xyqKVDc9w2QSzWkYpPkn60YH4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TAPgg+8eOHi4D4N5Uro8ACs2DbLMmMNnBv8MiYVRnODTEnqeYBK5Tb9S0L29zCW/Ytd4k73f0h5DSyKQHDJwe6Am06eEO+NWiNTaYKxNsP4O1C1RtIcDWWTq8nxvCzxzZ67MYDNjGuAvqAdmkkLttlhG0s2ac4Is2YwyzR6E9rs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=G3sCOfvp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="G3sCOfvp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ED409C4CEE7;
	Tue, 17 Jun 2025 16:19:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750177195;
	bh=yHOrWKvR43kb8Z7jJ5xyqKVDc9w2QSzWkYpPkn60YH4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=G3sCOfvpUwDmU3O6SSiCCDj7jV+pD7zac/d2PXFkmO1Ej4zQVglXhVhCz4K3vVLNf
	 OKQOHMYrneJHoBJkiT4RJbsrAiDyoRIU1vSn4KO0xjrgWVxL/uvdrODSI5ZGx/ulE6
	 xPob18fSEEnO+dJV5JRVfKLszLLsJFns2OT7PKCc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chin-Yen Lee <timlee@realtek.com>,
	Ping-Ke Shih <pkshih@realtek.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 270/780] wifi: rtw89: fix firmware scan delay unit for WiFi 6 chips
Date: Tue, 17 Jun 2025 17:19:38 +0200
Message-ID: <20250617152502.462482078@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152451.485330293@linuxfoundation.org>
References: <20250617152451.485330293@linuxfoundation.org>
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

From: Chin-Yen Lee <timlee@realtek.com>

[ Upstream commit 3cc35394fac15d533639c9c9e42f28d28936a4a0 ]

The scan delay unit of firmware command for WiFi 6 chips is
microsecond, but is wrong set now and lead to abnormal work
for net-detect. Correct the unit to avoid the error.

Fixes: e99dd80c8a18 ("wifi: rtw89: wow: add delay option for net-detect")
Signed-off-by: Chin-Yen Lee <timlee@realtek.com>
Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>
Link: https://patch.msgid.link/20250513125203.6858-1-pkshih@realtek.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/realtek/rtw89/fw.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/realtek/rtw89/fw.c b/drivers/net/wireless/realtek/rtw89/fw.c
index 8643b17866f89..6c52b0425f2ea 100644
--- a/drivers/net/wireless/realtek/rtw89/fw.c
+++ b/drivers/net/wireless/realtek/rtw89/fw.c
@@ -5477,7 +5477,7 @@ int rtw89_fw_h2c_scan_list_offload_be(struct rtw89_dev *rtwdev, int ch_num,
 	return 0;
 }
 
-#define RTW89_SCAN_DELAY_TSF_UNIT 104800
+#define RTW89_SCAN_DELAY_TSF_UNIT 1000000
 int rtw89_fw_h2c_scan_offload_ax(struct rtw89_dev *rtwdev,
 				 struct rtw89_scan_option *option,
 				 struct rtw89_vif_link *rtwvif_link,
-- 
2.39.5



