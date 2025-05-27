Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1EFD81FB3;
	Tue, 27 May 2025 17:46:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748367981; cv=none; b=ZmLPTiIuMzd5VZaMRuR+H4NhCC/5UuDqO9Gja+s1FCIivJVRIPVDiAd4QgU9gn1mjhsatxDK6jhaHZOG4Wl3HUDVGeT0GKY/mb4O6nwY6+nh2kTYnnf63hncKR99DdWzV/gAmiQc/w/zeqI3Ag803dyryNa7aMGIUDLYWqaBBB0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748367981; c=relaxed/simple;
	bh=6JCLMDAFhWr8eK1weSeAUBYNY7Q3yMI3LlPx1UenH7M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uQoe0v6P885rGckWCEa+f35v0QDhtpHPJeycy3FjYkNS8MA+NZPVQ7NTGb7ilN2wOXbvY4DtJmPGMVl3jECrKaDXt8hjXhG7Oi8AbeXdxLx1++y3znglJwNENeSdTVWQYfhGmAt7UZppeWVzZeJapxqbdnbcXqMaaICNeYTs6xw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sEg8uJAR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sEg8uJAR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A652DC4CEE9;
	Tue, 27 May 2025 17:46:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748367981;
	bh=6JCLMDAFhWr8eK1weSeAUBYNY7Q3yMI3LlPx1UenH7M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sEg8uJARcjh5BEU6LjK1+REpbzdb2GfAubEKkhO1gXovr3loAHn7XuQ6630If3wKq
	 Z3Y1IOQVWRJ8EwkUvNi3DYt1WiTsms37ANHV3+T+y4ONfuR4z+RHYljBAPukhsvD31
	 3pRoslJZcyI8DGNizKo4RPMRbhkIXdy0CLYJsnV8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ching-Te Ku <ku920601@realtek.com>,
	Ping-Ke Shih <pkshih@realtek.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 543/783] wifi: rtw89: coex: Assign value over than 0 to avoid firmware timer hang
Date: Tue, 27 May 2025 18:25:40 +0200
Message-ID: <20250527162535.272707817@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250527162513.035720581@linuxfoundation.org>
References: <20250527162513.035720581@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

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
index 9e06cc36a75e2..d94a028555e20 100644
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



