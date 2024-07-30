Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A12CF1A6160;
	Tue, 30 Jul 2024 16:18:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722356325; cv=none; b=fEf161nL0grtALZWmdTOGa535OKHo0yJ3XqB7IcpG/wJ6wEkbha5hopz6rbnYoN4NEhh4SURM/hU/DTWI+Lgj+ZIqoKOF0mW3Rjw1P7Q3/+PvJ4vfAnUH60leEQgXL+WRU60vs8VKGhhnx5asPr1VXvAW2N4nhKJqhxTmK0mJDQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722356325; c=relaxed/simple;
	bh=QixTVG/27NqhSMoQ0Onhc69TzxyCcX+ipDuB4uUKBTM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Gy1zYt6TWX6dBd8TRC4mSK3TwmiLoqhtzm8vkVXxx6pC/tQBnT/xu9XIjzZC1OciQ+WjxGQdLrYITzBhX01tXN9sSMsUvWCk8VMUw3925Rissr7bdGG829hQHh+++5+fWV7zizd+iFw5oG/3Kn33Ajw+/4eN0WLMg3i1pWm9huY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Of5zWIgL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Of5zWIgL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2B795C32782;
	Tue, 30 Jul 2024 16:18:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722356325;
	bh=QixTVG/27NqhSMoQ0Onhc69TzxyCcX+ipDuB4uUKBTM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Of5zWIgLpaqJxtTLbq8jm6vg1/NaYw33ZkSmZnHw22G/Ey19Z2ljbSj5i/SRFlcsu
	 HDQxEY/fUfju0WM1YNbPajhew3nY6CpgExR4NYBUYh7HdSNGVt+fk8TfyFwpYFNsUO
	 048rGYA8Jcx5yALc8lJz44t5MEOTMdsqOicWIo50=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Baochen Qiang <quic_bqiang@quicinc.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 134/568] wifi: cfg80211: fix typo in cfg80211_calculate_bitrate_he()
Date: Tue, 30 Jul 2024 17:44:01 +0200
Message-ID: <20240730151645.109771012@linuxfoundation.org>
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
index 57ea6d5b092d4..187e29a30c2af 100644
--- a/net/wireless/util.c
+++ b/net/wireless/util.c
@@ -1460,7 +1460,7 @@ static u32 cfg80211_calculate_bitrate_he(struct rate_info *rate)
 		  5120, /*  0.833333... */
 	};
 	u32 rates_160M[3] = { 960777777, 907400000, 816666666 };
-	u32 rates_969[3] =  { 480388888, 453700000, 408333333 };
+	u32 rates_996[3] =  { 480388888, 453700000, 408333333 };
 	u32 rates_484[3] =  { 229411111, 216666666, 195000000 };
 	u32 rates_242[3] =  { 114711111, 108333333,  97500000 };
 	u32 rates_106[3] =  {  40000000,  37777777,  34000000 };
@@ -1485,7 +1485,7 @@ static u32 cfg80211_calculate_bitrate_he(struct rate_info *rate)
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



