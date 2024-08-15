Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B86AE1A76A2;
	Thu, 15 Aug 2024 14:14:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723731240; cv=none; b=rVcJ99ZFnt30QRgh02yDcdna8/AyT5N+aaprgxBbWqh9Z9usStrNiL8Nhk0Yk6ZX2UhfPCoGNNpUN7eMx4FiILY36ZtejCI0Udws0Lw7MigabAilN+qRvxz9R/uYeFu9MuJvknsGQAdV+dYnlsUhxgXinf/kj1ZtM4Q47PTvSfQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723731240; c=relaxed/simple;
	bh=+E2tsID6VUq5lo+bIM61jfNSO4O0Jv3jX57t43ZUbRE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XgzxPZQO56/ktgpPI6Vx6SBxNCvo3KMwL0+E8ZLcHKFC/EBzHWNjDUhaVsrL8wDp/ieHi13OHj8jvFr0ulpUKS7vVicTPbMkaI6Oyvgii5OmICAffSsXTnuo+eWkAwqNHc2qjqb1xC0yVPIeJYxzyMZ5h0vSIB6ioN+rlW1sZ8Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RWUu5n4l; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RWUu5n4l"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CBC51C32786;
	Thu, 15 Aug 2024 14:13:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723731240;
	bh=+E2tsID6VUq5lo+bIM61jfNSO4O0Jv3jX57t43ZUbRE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RWUu5n4l1N85TG/AA/gdbbxL+us2YggYc8zjDws01LqUnHqNeaGTLyVoe4SLM3qs4
	 VWiBdkaCCphcZ8TczWeBeZVUogBN92QuS7nKzqZX2VWwRYFnXAXxL/bGbW8sdEX+fB
	 h5B4r3jj3jjKuDRSnW+q+yKvjxj+hu44rOkRAjOQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Baochen Qiang <quic_bqiang@quicinc.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 035/259] wifi: cfg80211: fix typo in cfg80211_calculate_bitrate_he()
Date: Thu, 15 Aug 2024 15:22:48 +0200
Message-ID: <20240815131904.154007274@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240815131902.779125794@linuxfoundation.org>
References: <20240815131902.779125794@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
index 95533732f9d6f..3557a81037cc1 100644
--- a/net/wireless/util.c
+++ b/net/wireless/util.c
@@ -1281,7 +1281,7 @@ static u32 cfg80211_calculate_bitrate_he(struct rate_info *rate)
 		 2048, /*  1.000000... */
 	};
 	u32 rates_160M[3] = { 960777777, 907400000, 816666666 };
-	u32 rates_969[3] =  { 480388888, 453700000, 408333333 };
+	u32 rates_996[3] =  { 480388888, 453700000, 408333333 };
 	u32 rates_484[3] =  { 229411111, 216666666, 195000000 };
 	u32 rates_242[3] =  { 114711111, 108333333,  97500000 };
 	u32 rates_106[3] =  {  40000000,  37777777,  34000000 };
@@ -1306,7 +1306,7 @@ static u32 cfg80211_calculate_bitrate_he(struct rate_info *rate)
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



