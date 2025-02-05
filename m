Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7005EF510;
	Wed,  5 Feb 2025 14:08:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738764498; cv=none; b=PG34TX9uWt2Yhd26zfzluK5uwb8v30U8QKauLBMXrQiqm0FRYYKgsXAzvo+gmjM4P0GQ9dOcy+zXa+tFGQsuGXxo9YBVsqP1272WanLNB77tRvtdqZpESWp9tPwAfJFBRvHKhazET3m2bUz3NEXZhwO6F6sgl1fGWmfEMq7q2Lg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738764498; c=relaxed/simple;
	bh=GDr+B3HDXIwTmuw7r1cESKnkgHyPCOF+zIUbq9dO5W0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SmLzGSzd7lsUUNQWDgs3dUqePWL3BAwdOl/onkjfYG06+LO2ZdFm5Ub7U+QodAnkl9RxCdqyDg0+OeAbXIB6BDIxZSJZPiY1JZTEw0/IOgIb+84CcZueLOUHVVGXQOQTRr6iyHWSkOr5MLEhDS6LgS98GjGzpWj5fLwyQ8zIV98=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vR2LQ2ij; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vR2LQ2ij"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EB631C4CED1;
	Wed,  5 Feb 2025 14:08:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738764498;
	bh=GDr+B3HDXIwTmuw7r1cESKnkgHyPCOF+zIUbq9dO5W0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vR2LQ2ijqOPpxjsOBIj3M6Kk1SAGogX6dIwhDxFbgGSKRUW07e/Gvhq3cwM2UGOE8
	 KTthWB04xJ7QB+UkmUJDv5pg3zQ7+yH+97KlCZXel6VO3FE7VrQzIIyFKjIGwcw25c
	 TzL79d26TOS+Epmu+P3tWD9TRL9RTwbid9nQ7WPA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Colin Ian King <colin.i.king@gmail.com>,
	Ping-Ke Shih <pkshih@realtek.com>,
	Su Hui <suhui@nfschina.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 085/623] wifi: rtlwifi: rtl8821ae: phy: restore removed code to fix infinite loop
Date: Wed,  5 Feb 2025 14:37:07 +0100
Message-ID: <20250205134459.475577391@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250205134456.221272033@linuxfoundation.org>
References: <20250205134456.221272033@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

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



