Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F34741AC896;
	Thu, 15 Aug 2024 14:27:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723732068; cv=none; b=X7L8seiM2kTdrQ5H4PTaXtT8u6Swi935SagQPULxbpDS6y5kLF+YXoSPtdti/Uyw6AHoqalyuRYDahUPIAEBtEcZ5CM8ZJt+PXeYpDhXhwFadqhD+h+snaWGa8L9/idHb+muvH7Tjq8uYvK52acFljEpA7iglEMr4rMx45Q77J8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723732068; c=relaxed/simple;
	bh=rCy2+TkYpd6ncSxJ6nBCAwoyL9hmhQGn6I9bykqGhGs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QXeMA0b72oalLIkNgMerJlGC6JZ8F7OyZaO897cm7zDZ9lDpfQ+pOshhBtGPpHoWl9JQSHhxn7APrA5LNy9AsH494zInQKfeM6mXM9FAWWxTLqAviKIrolWoI4HMWt364/T7QjUzefJ8baDKhgtmjv3Cb1gL09OgPrSTAzhoXZQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jamIaLza; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jamIaLza"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7B77AC32786;
	Thu, 15 Aug 2024 14:27:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723732067;
	bh=rCy2+TkYpd6ncSxJ6nBCAwoyL9hmhQGn6I9bykqGhGs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jamIaLzaZLFb7b2bPbhBSci16q/eEJh4oaTv4cG8ExsOZZ0ltV9BH21oOcCJP5BJx
	 x661CgH9vAezD/DK+la0qrrePxjWQgjs3sGENcPcIM+8aHIqlIev400o0xP6dRJJ9O
	 sfXH9VQrBB1JPb8yIGrGpppujQ8ujcNzrKRaxwYQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Baochen Qiang <quic_bqiang@quicinc.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 047/352] wifi: cfg80211: fix typo in cfg80211_calculate_bitrate_he()
Date: Thu, 15 Aug 2024 15:21:53 +0200
Message-ID: <20240815131921.057644607@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240815131919.196120297@linuxfoundation.org>
References: <20240815131919.196120297@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 4b32e85c2d9a1..0d5b1c18d62f2 100644
--- a/net/wireless/util.c
+++ b/net/wireless/util.c
@@ -1334,7 +1334,7 @@ static u32 cfg80211_calculate_bitrate_he(struct rate_info *rate)
 		 2048, /*  1.000000... */
 	};
 	u32 rates_160M[3] = { 960777777, 907400000, 816666666 };
-	u32 rates_969[3] =  { 480388888, 453700000, 408333333 };
+	u32 rates_996[3] =  { 480388888, 453700000, 408333333 };
 	u32 rates_484[3] =  { 229411111, 216666666, 195000000 };
 	u32 rates_242[3] =  { 114711111, 108333333,  97500000 };
 	u32 rates_106[3] =  {  40000000,  37777777,  34000000 };
@@ -1359,7 +1359,7 @@ static u32 cfg80211_calculate_bitrate_he(struct rate_info *rate)
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



