Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8602A19EED0;
	Thu, 15 Aug 2024 13:44:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723729450; cv=none; b=pNMYao8+4+JJQOVo3UsjdGpAwNW0uqjG3fxtMYeAfyd6X5SbKYY2CMx6K5w3J+SdDjQcAl0mSttUoCyYLS6TS/MnVb8m15sEWx4BEO8Amm5qUdW/hyxAJRLCBdTLb3/iBF5yGqj/pjp9oha2YTXpPjzfUj+oRpf60NRlvJYwJxo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723729450; c=relaxed/simple;
	bh=6atr6dNWt0jLluxGjMuV7KrvxKADM0YWkQXe64uNCh0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nTfBK2BcRFXaexn8aUIYfufhrHXLCeoN7u+klvOaYKxGXge7OI69elJ5KP/w9cw1xMjCoUMRtvQPYOXNmSLKblmKWO1UZZnWUG53bA0Qjvi9Gue5XcSBglt4fKezTzJ5M8EjSUb6eLgDyL3L94KSVZVUfpv3TVLFSOuuIv3upLY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eMMYIP8E; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eMMYIP8E"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0219EC32786;
	Thu, 15 Aug 2024 13:44:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723729450;
	bh=6atr6dNWt0jLluxGjMuV7KrvxKADM0YWkQXe64uNCh0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=eMMYIP8ES0Ay7ydADq4uUTJ2XjW2mOiKuebbqdpSJo6UjpPAqoYQvv69/XAzyH9F4
	 bC4AtzN3DYKgOSE36qurcbh+xCwl/m150YvIlHM7BFyIVnU88OheNgqdinjsYW1wIz
	 uZog33u8/yC1ivPe2sD1kUOdc0N/N+SnHJBc8f1M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Baochen Qiang <quic_bqiang@quicinc.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 060/484] wifi: cfg80211: fix typo in cfg80211_calculate_bitrate_he()
Date: Thu, 15 Aug 2024 15:18:38 +0200
Message-ID: <20240815131943.602217026@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240815131941.255804951@linuxfoundation.org>
References: <20240815131941.255804951@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index d40c2cf777dc0..a879d6b310a90 100644
--- a/net/wireless/util.c
+++ b/net/wireless/util.c
@@ -1363,7 +1363,7 @@ static u32 cfg80211_calculate_bitrate_he(struct rate_info *rate)
 		  5120, /*  0.833333... */
 	};
 	u32 rates_160M[3] = { 960777777, 907400000, 816666666 };
-	u32 rates_969[3] =  { 480388888, 453700000, 408333333 };
+	u32 rates_996[3] =  { 480388888, 453700000, 408333333 };
 	u32 rates_484[3] =  { 229411111, 216666666, 195000000 };
 	u32 rates_242[3] =  { 114711111, 108333333,  97500000 };
 	u32 rates_106[3] =  {  40000000,  37777777,  34000000 };
@@ -1388,7 +1388,7 @@ static u32 cfg80211_calculate_bitrate_he(struct rate_info *rate)
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



