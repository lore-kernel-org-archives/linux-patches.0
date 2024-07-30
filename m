Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 132B41A617E;
	Tue, 30 Jul 2024 16:21:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722356481; cv=none; b=QQyrj8G7k3gHaznu46HzoZ7gfu6nYcNgj9GBPI3tFHJ7PwhhUOYBPfeSrSM/V9woAWWFs4i8gShFNkIuJMg74J+7wk5KOuBcGmQLqXvyc3a03XTBv+tmTtaUnqzUGTyxHUHPw33aMx3pLMIEUR9mnZlSMwHKnFYwLRDHq9vr0B4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722356481; c=relaxed/simple;
	bh=BIcfr4hXQ+pC82r3I20MgbbK2z87MxA+XxDWNCr+qb0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XF2x2eT2nvrbLMK6Z3/R7W9o6rAyAI7BoqAC2cSz41x3BvzDJm8pMBzREREZhQGhZixtPgjDh1SiT407Zt8TAish5qyR1VSLI4eO7yy4TUAlZSnieq0mK7iDltp0yP6U4fxbsRa1HMhF3mMSifEYNcJKSa/+//L7y4/gtAyyvRE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=txrjPW/U; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="txrjPW/U"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8D868C32782;
	Tue, 30 Jul 2024 16:21:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722356481;
	bh=BIcfr4hXQ+pC82r3I20MgbbK2z87MxA+XxDWNCr+qb0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=txrjPW/Uoi54j+VKKkAXHcX/R69AFyM1Os0XGncUBDkYL3EyApTXBn98N/eDlDaFh
	 ZW5327v3JMARD7UiuA7plH6a4jeYGy8vHR/hvpJ0WGjFU+sZp+VtVP5itr7o4Tu1tl
	 LaPHvRUa5bWwA0CmxAzGWNJnOH3RzW2dHRw3IdHg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aleksandr Mishin <amishin@t-argos.ru>,
	Ping-Ke Shih <pkshih@realtek.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 152/568] wifi: rtw89: Fix array index mistake in rtw89_sta_info_get_iter()
Date: Tue, 30 Jul 2024 17:44:19 +0200
Message-ID: <20240730151645.817146516@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151639.792277039@linuxfoundation.org>
References: <20240730151639.792277039@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Aleksandr Mishin <amishin@t-argos.ru>

[ Upstream commit 85099c7ce4f9e64c66aa397cd9a37473637ab891 ]

In rtw89_sta_info_get_iter() 'status->he_gi' is compared to array size.
But then 'rate->he_gi' is used as array index instead of 'status->he_gi'.
This can lead to go beyond array boundaries in case of 'rate->he_gi' is
not equal to 'status->he_gi' and is bigger than array size. Looks like
"copy-paste" mistake.

Fix this mistake by replacing 'rate->he_gi' with 'status->he_gi'.

Found by Linux Verification Center (linuxtesting.org) with SVACE.

Fixes: e3ec7017f6a2 ("rtw89: add Realtek 802.11ax driver")
Signed-off-by: Aleksandr Mishin <amishin@t-argos.ru>
Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>
Link: https://patch.msgid.link/20240703210510.11089-1-amishin@t-argos.ru
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/realtek/rtw89/debug.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/realtek/rtw89/debug.c b/drivers/net/wireless/realtek/rtw89/debug.c
index d162e64f60647..94fe921e9ff28 100644
--- a/drivers/net/wireless/realtek/rtw89/debug.c
+++ b/drivers/net/wireless/realtek/rtw89/debug.c
@@ -3292,7 +3292,7 @@ static void rtw89_sta_info_get_iter(void *data, struct ieee80211_sta *sta)
 	case RX_ENC_HE:
 		seq_printf(m, "HE %dSS MCS-%d GI:%s", status->nss, status->rate_idx,
 			   status->he_gi <= NL80211_RATE_INFO_HE_GI_3_2 ?
-			   he_gi_str[rate->he_gi] : "N/A");
+			   he_gi_str[status->he_gi] : "N/A");
 		break;
 	}
 	seq_printf(m, " BW:%u", rtw89_rate_info_bw_to_mhz(status->bw));
-- 
2.43.0



