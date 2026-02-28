Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F5D239448A
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 17:51:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772301085; cv=none; b=KCbmwW2ERPmI0PHl6vfDfNrMMl+iJ1pxwtG2wqS57M5vyn95NsdmaQOIpm4/0E+7TudoSQ2+7CQ6EJev3iTnsScV1fMZa0ew7M6GTDjLhbZYv7eGmcVvgvZy3sCbL5InvTuJ/YHQSzi55uZ7BZgBmzXdSec7iWhzKyDDgd/Cs5E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772301085; c=relaxed/simple;
	bh=ZiaFvJ5EdiCRm9RkosqkKvpfaqkMmLFWL2nOpbbj0Ic=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bKSz4c8LTTsG0d8l27BaxqhuZWpaDZs01DJL71AQVdZDTcBdz0c1GjPA574Sa1yzfY9YVjBx5gGIbJZWKZy4Lop+YgkczNJ2pRwK04riau/phTBKUjlRkSwcSenBz+r34kvNq3kT0lGeu6BZnKXP2Hc1yUTiGxkIqAHpe5nCJH0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ihuuGzP7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ihuuGzP7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F1A84C19423;
	Sat, 28 Feb 2026 17:51:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772301085;
	bh=ZiaFvJ5EdiCRm9RkosqkKvpfaqkMmLFWL2nOpbbj0Ic=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ihuuGzP7IMk6Oq/jj5USvAGpqOUaPM0ahcALaxDuPuezDP3bYq3JqiVNKfLQWbo4r
	 9ZOynC2jZL1tWUpcaNPj0UnSF8dM2UpE5ejj/BFOrZb7VenaUQqyPre7JRLX5hrugo
	 MP93ukBDgkn8x9t6cPhEehFXV+wdH8z6rM37Z4EdG2nZoWWztOmlwW/BRtGghTCbaJ
	 D8ifSvwWOScOXUyJnUCqjeYo295JOmSuHwk6rAgGcJSUZAykn1dPxBpTuSqMsuGyYL
	 EDL7Eeyteilx2Dv7AGIZOnl+8TSVJwTiWgR9Wi4F/8q8BxT++O7oNoBDhbibOjLGFr
	 l9V/iZ9UPI5FQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Ping-Ke Shih <pkshih@realtek.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 234/752] wifi: rtw89: mac: correct page number for CSI response
Date: Sat, 28 Feb 2026 12:39:05 -0500
Message-ID: <20260228174750.1542406-234-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228174750.1542406-1-sashal@kernel.org>
References: <20260228174750.1542406-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Ping-Ke Shih <pkshih@realtek.com>

[ Upstream commit aa2a44d0d22d45d659b9f01638809b1735e46cff ]

For beamforming procedure, hardware reserve memory page for CSI response.
The unit of register is (value - 1), so add one accordingly as expected.

Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>
Link: https://patch.msgid.link/20260110022019.2254969-7-pkshih@realtek.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/realtek/rtw89/mac_be.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/realtek/rtw89/mac_be.c b/drivers/net/wireless/realtek/rtw89/mac_be.c
index e33297220f8b5..e5a61c628b731 100644
--- a/drivers/net/wireless/realtek/rtw89/mac_be.c
+++ b/drivers/net/wireless/realtek/rtw89/mac_be.c
@@ -1168,7 +1168,7 @@ static int resp_pktctl_init_be(struct rtw89_dev *rtwdev, u8 mac_idx)
 
 	reg = rtw89_mac_reg_by_idx(rtwdev, R_BE_RESP_CSI_RESERVED_PAGE, mac_idx);
 	rtw89_write32_mask(rtwdev, reg, B_BE_CSI_RESERVED_START_PAGE_MASK, qt_cfg.pktid);
-	rtw89_write32_mask(rtwdev, reg, B_BE_CSI_RESERVED_PAGE_NUM_MASK, qt_cfg.pg_num);
+	rtw89_write32_mask(rtwdev, reg, B_BE_CSI_RESERVED_PAGE_NUM_MASK, qt_cfg.pg_num + 1);
 
 	return 0;
 }
-- 
2.51.0

