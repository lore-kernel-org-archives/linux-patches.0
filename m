Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 33EE72110E;
	Tue, 27 May 2025 17:06:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748365611; cv=none; b=hBinIm/fP4bR+pyEI1sSEkHgkJ4MBnmjDdGJPBX92BaQMfCbqEE3Wk1N41+6wLCKBt2kBL/h94y/nEDUXx6JjeyQbfutFr0EWaHNvVlN7XvqbMgNaKvSWrlTc9AAQdjL/sKPKLzBiZXqPooYNQw9+Cjp/H8Zi3bbheuvDzlwQE4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748365611; c=relaxed/simple;
	bh=IS7I1Mnmq+Ls2bNBHUCLx2B8vcjtCSG/+hic06ANv6s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=a+WhNWFGFx6PLIav69sXWVJfV1ouCX1sq19ywyYV8wifrNOUSy0qoSR5YaiBlsuISIbDEAlVn7ERvcGRnIJbYnBt8jWKk6NbkytbHI2e4pv0h5U8gTKHvQieqNOVR9TRIr5FrOibVZ/aupFUbD/sldeDnP/wFHxg/mhFVIO+/8w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vRJ6Mawe; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vRJ6Mawe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 911E2C4CEE9;
	Tue, 27 May 2025 17:06:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748365611;
	bh=IS7I1Mnmq+Ls2bNBHUCLx2B8vcjtCSG/+hic06ANv6s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vRJ6MaweM649pbUNm5MNNPIASXqvMRKK/5roYSGe98WJeZ+15lgV7QHY6iKKQT5rG
	 1Y3nt+Ao9ReFM1xqET4A07xOgVTiwLLT4h6tXINoMBmjsRkNPdAnd9Tcvwi3/6dNKc
	 TcV2VOPhYGAaC9/U2thfCDhWrwDe64iOnsa6mUgs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ching-Te Ku <ku920601@realtek.com>,
	Ping-Ke Shih <pkshih@realtek.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 432/626] wifi: rtw89: coex: Assign value over than 0 to avoid firmware timer hang
Date: Tue, 27 May 2025 18:25:25 +0200
Message-ID: <20250527162502.559049840@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250527162445.028718347@linuxfoundation.org>
References: <20250527162445.028718347@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ching-Te Ku <ku920601@realtek.com>

[ Upstream commit 2e4c4717b3f6f019c71af984564b6e4d0ae8d0bd ]

If the slot duration is 0, the firmware timer will trigger timer hang at
the timer initializing state in a low rate due to hardware algorithm.

Signed-off-by: Ching-Te Ku <ku920601@realtek.com>
Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>
Link: https://patch.msgid.link/20250205013233.10945-2-pkshih@realtek.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/realtek/rtw89/coex.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtw89/coex.c b/drivers/net/wireless/realtek/rtw89/coex.c
index 8d54d71fcf539..5f878f086f7cf 100644
--- a/drivers/net/wireless/realtek/rtw89/coex.c
+++ b/drivers/net/wireless/realtek/rtw89/coex.c
@@ -89,10 +89,10 @@ static const struct rtw89_btc_fbtc_slot s_def[] = {
 	[CXST_B4]	= __DEF_FBTC_SLOT(50,  0xe5555555, SLOT_MIX),
 	[CXST_LK]	= __DEF_FBTC_SLOT(20,  0xea5a5a5a, SLOT_ISO),
 	[CXST_BLK]	= __DEF_FBTC_SLOT(500, 0x55555555, SLOT_MIX),
-	[CXST_E2G]	= __DEF_FBTC_SLOT(0,   0xea5a5a5a, SLOT_MIX),
-	[CXST_E5G]	= __DEF_FBTC_SLOT(0,   0xffffffff, SLOT_ISO),
+	[CXST_E2G]	= __DEF_FBTC_SLOT(5,   0xea5a5a5a, SLOT_MIX),
+	[CXST_E5G]	= __DEF_FBTC_SLOT(5,   0xffffffff, SLOT_ISO),
 	[CXST_EBT]	= __DEF_FBTC_SLOT(5,   0xe5555555, SLOT_MIX),
-	[CXST_ENULL]	= __DEF_FBTC_SLOT(0,   0xaaaaaaaa, SLOT_ISO),
+	[CXST_ENULL]	= __DEF_FBTC_SLOT(5,   0xaaaaaaaa, SLOT_ISO),
 	[CXST_WLK]	= __DEF_FBTC_SLOT(250, 0xea5a5a5a, SLOT_MIX),
 	[CXST_W1FDD]	= __DEF_FBTC_SLOT(50,  0xffffffff, SLOT_ISO),
 	[CXST_B1FDD]	= __DEF_FBTC_SLOT(50,  0xffffdfff, SLOT_ISO),
-- 
2.39.5



