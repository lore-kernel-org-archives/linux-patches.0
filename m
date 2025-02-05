Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF3321547F2;
	Wed,  5 Feb 2025 13:59:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738763960; cv=none; b=msWZh5SBsRRsHgUbQloIrFg8cENeNbZE0mAacBNc2x4iD8eNHZiAjJKjwGUTvFPiYkpwr69d0trh4+9d2CgwIC375cCLC0q/OUa3CW4fzIw34rBIqqFtMjIy1eVys0+0CiOqciItG/dsuJoZ3SPv16lEUabYLYIa2sYaN4B8HL0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738763960; c=relaxed/simple;
	bh=8WRI6RZ7l2rSeRAfXd9c9q/SaOLEiaiXw4Q16TcsBQE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fXkSUFWlVmb1VeE22bkO+aBeg9U2Bdw5TWTRi6mTMcu+Umkq0VJVmrAK0POEFoqzNpR4Ko+I4NSb51zbHQLZQmfdvEpcNrx1O5eSP75XqmJL5zHPLVMsdjbYKjlsr8r7K0QJzS0myC3FM6v3Ve3npTXMI423PKoQjSBaLIlTCOU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=o72OGa29; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="o72OGa29"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EECB8C4CED1;
	Wed,  5 Feb 2025 13:59:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738763959;
	bh=8WRI6RZ7l2rSeRAfXd9c9q/SaOLEiaiXw4Q16TcsBQE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=o72OGa29pQX7w7X6vFrF0Q6FV6s/p592z4fL+vtbeFGCtxXc7PMsh76MGQkeVzGbU
	 11HnPP1eq/5TGOyjxi6XpeYuFcO2OwAbfsuH/jeZ7W+dIAH52a0Vd1i/7Pzkxg6Qs0
	 VWgM+XgnlfwvBKms7gN5vJN4J0wuXqO3vSMGRN7E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Colin Ian King <colin.i.king@gmail.com>,
	Ping-Ke Shih <pkshih@realtek.com>,
	Su Hui <suhui@nfschina.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 076/590] wifi: rtlwifi: rtl8821ae: phy: restore removed code to fix infinite loop
Date: Wed,  5 Feb 2025 14:37:11 +0100
Message-ID: <20250205134458.161969239@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250205134455.220373560@linuxfoundation.org>
References: <20250205134455.220373560@linuxfoundation.org>
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

From: Colin Ian King <colin.i.king@gmail.com>

[ Upstream commit 5e5903a442bb889a62a0f5d89ac33e53ab08592c ]

A previous clean-up fix removed the assignment of v2 inside a while loop
that turned it into an infinite loop. Fix this by restoring the assignment
of v2 from array[] so that v2 is updated inside the loop.

Fixes: cda37445718d ("wifi: rtlwifi: rtl8821ae: phy: remove some useless code")
Signed-off-by: Colin Ian King <colin.i.king@gmail.com>
Tested-by: Ping-Ke Shih <pkshih@realtek.com>
Reviewed-by: Su Hui <suhui@nfschina.com>
Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>
Link: https://patch.msgid.link/20241106154642.1627886-1-colin.i.king@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/realtek/rtlwifi/rtl8821ae/phy.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8821ae/phy.c b/drivers/net/wireless/realtek/rtlwifi/rtl8821ae/phy.c
index 1be51ea3f3c82..9eddbada8af12 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8821ae/phy.c
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8821ae/phy.c
@@ -2033,8 +2033,10 @@ static bool _rtl8821ae_phy_config_bb_with_pgheaderfile(struct ieee80211_hw *hw,
 			if (!_rtl8821ae_check_condition(hw, v1)) {
 				i += 2; /* skip the pair of expression*/
 				v2 = array[i+1];
-				while (v2 != 0xDEAD)
+				while (v2 != 0xDEAD) {
 					i += 3;
+					v2 = array[i + 1];
+				}
 			}
 		}
 	}
-- 
2.39.5



