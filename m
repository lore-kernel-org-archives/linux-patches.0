Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D3E371A6160;
	Tue, 30 Jul 2024 16:27:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722356839; cv=none; b=kBjbnJNCoqpr55FXXFxotJYSm5u8XGeIZuU+AJFDi8YfC/0q4TfEONFu3x8OaqX5zN3k5dNMNllrEqjesOW0PPnbLnAaedwfCR/se2Nipgaa6XHPizKW/AZn15WTZo2c41CHENcCm6vuYmTtGxgqrTVTuX7883dfAEP6xSXpDZ0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722356839; c=relaxed/simple;
	bh=qzNYnvE/wJSOov6sa9lXXzGaYzF7s73D4tp1YRhcJHs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fXw51mw+pQd/lkJ4AgYVRmtbb5xIZQbGoBI4maZBeIhFLgWE62aQt8BIXuZXpfH1V1abq0+cwALHJD3iXtXBDdXvG3NQu2VxICg28RG2My+T7jWW9I0UqLjk9Eoh1e04qXUB1flXl05sRxDI86526126XXwCOl5a6e71+yNOuio=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=r4QBsVRm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="r4QBsVRm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5F1BAC32782;
	Tue, 30 Jul 2024 16:27:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722356839;
	bh=qzNYnvE/wJSOov6sa9lXXzGaYzF7s73D4tp1YRhcJHs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=r4QBsVRm983OMBC/6WBxUaU1wHVgPZ2gKEl8nnbZu5TshhwQ6B/2kvkhRg5tyeNY/
	 Tc0i3lCXR5HlfURwISmyBMWnkB6moGI0ntEX9JNO/UF+Qh2gogAwYEqtWenGEtG4Bk
	 ZXX4tx64t35Pf5RF9VITjGgmGYXuXp2VF69x4FhU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Baochen Qiang <quic_bqiang@quicinc.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 192/809] wifi: cfg80211: fix typo in cfg80211_calculate_bitrate_he()
Date: Tue, 30 Jul 2024 17:41:08 +0200
Message-ID: <20240730151732.193363753@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151724.637682316@linuxfoundation.org>
References: <20240730151724.637682316@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Baochen Qiang <quic_bqiang@quicinc.com>

[ Upstream commit 9ee0d44f055276fe2802b2f65058e920853f4f99 ]

rates_996 is mistakenly written as rates_969, fix it.

Fixes: c4cbaf7973a7 ("cfg80211: Add support for HE")
Signed-off-by: Baochen Qiang <quic_bqiang@quicinc.com>
Link: https://msgid.link/20240606020653.33205-2-quic_bqiang@quicinc.com
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/wireless/util.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/wireless/util.c b/net/wireless/util.c
index 082c6f9c5416e..d262d37c15193 100644
--- a/net/wireless/util.c
+++ b/net/wireless/util.c
@@ -1504,7 +1504,7 @@ static u32 cfg80211_calculate_bitrate_he(struct rate_info *rate)
 		  5120, /*  0.833333... */
 	};
 	u32 rates_160M[3] = { 960777777, 907400000, 816666666 };
-	u32 rates_969[3] =  { 480388888, 453700000, 408333333 };
+	u32 rates_996[3] =  { 480388888, 453700000, 408333333 };
 	u32 rates_484[3] =  { 229411111, 216666666, 195000000 };
 	u32 rates_242[3] =  { 114711111, 108333333,  97500000 };
 	u32 rates_106[3] =  {  40000000,  37777777,  34000000 };
@@ -1529,7 +1529,7 @@ static u32 cfg80211_calculate_bitrate_he(struct rate_info *rate)
 	else if (rate->bw == RATE_INFO_BW_80 ||
 		 (rate->bw == RATE_INFO_BW_HE_RU &&
 		  rate->he_ru_alloc == NL80211_RATE_INFO_HE_RU_ALLOC_996))
-		result = rates_969[rate->he_gi];
+		result = rates_996[rate->he_gi];
 	else if (rate->bw == RATE_INFO_BW_40 ||
 		 (rate->bw == RATE_INFO_BW_HE_RU &&
 		  rate->he_ru_alloc == NL80211_RATE_INFO_HE_RU_ALLOC_484))
-- 
2.43.0



