Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 69E711D63EF;
	Tue, 27 May 2025 17:44:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748367852; cv=none; b=MlxEUFkkaLMd2OqCCAXEHzSjDvkmPNHgAp67fJ+TrXs1LTub5yH01F9S3olGO8X7P6PW30oW8wrF5mjJbiod4r1GsS1MGE7kIvv/EJWYJ6CVDmZhW/F/P8ttb5zJxJq5K7+hCWj2UbHW9PlRmJsusDiXKcnnOZaEfgQSpO3Vk4A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748367852; c=relaxed/simple;
	bh=Ks+FoSR8Ui2lVh3SOE4+5QPULXfUSEzv0VborlVoepo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gvO9G7v5AxlIrybzqoi5JoevamBY2auozxeL/29w0MYjCbu4QrsNv+04eBgqTSdWaGkQMdXjksbhkANVo1hRYEa40lVhVgCiAikMT8xppQqEzBN1o/Ge6U4YXjB17roZlvGC11OOi2TVaUnRvz6tpeMdOWJNtCQpcA+20F35Opk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ER2TDDy2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ER2TDDy2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E6BC2C4CEE9;
	Tue, 27 May 2025 17:44:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748367852;
	bh=Ks+FoSR8Ui2lVh3SOE4+5QPULXfUSEzv0VborlVoepo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ER2TDDy2koSJMxKkDfIxuAJ0PjpoVQM7ZFVnvfa1iNeu6ETa1yfkVIwVlEcsZWMej
	 52SxVNINT0S3gH9SOvX6/aCGinmBUuq9ReDkGxZFA27v1rMQstHY5c6KS/fq7VFos3
	 pFkJaI1V0AfB/H8rEPF+NQj2f8AL+OwbamVAUlcQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johannes Berg <johannes.berg@intel.com>,
	Miri Korenblit <miriam.rachel.korenblit@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 520/783] wifi: mac80211: always send max agg subframe num in strict mode
Date: Tue, 27 May 2025 18:25:17 +0200
Message-ID: <20250527162534.320737064@linuxfoundation.org>
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

From: Johannes Berg <johannes.berg@intel.com>

[ Upstream commit 3fca951123b68df8d1b47bbf90409f8a3671362b ]

Instead of only sending the correct number for EHT and up,
always send the correct number as it should be in strict
mode.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Miri Korenblit <miriam.rachel.korenblit@intel.com>
Link: https://patch.msgid.link/20250205110958.5910263db6da.Icd1f93fabc9705e4e760d834095c29b60b934d9e@changeid
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/mac80211/agg-tx.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/net/mac80211/agg-tx.c b/net/mac80211/agg-tx.c
index 61f2cac37728c..92120f9051499 100644
--- a/net/mac80211/agg-tx.c
+++ b/net/mac80211/agg-tx.c
@@ -9,7 +9,7 @@
  * Copyright 2007, Michael Wu <flamingice@sourmilk.net>
  * Copyright 2007-2010, Intel Corporation
  * Copyright(c) 2015-2017 Intel Deutschland GmbH
- * Copyright (C) 2018 - 2023 Intel Corporation
+ * Copyright (C) 2018 - 2024 Intel Corporation
  */
 
 #include <linux/ieee80211.h>
@@ -464,7 +464,8 @@ static void ieee80211_send_addba_with_timeout(struct sta_info *sta,
 	sta->ampdu_mlme.addba_req_num[tid]++;
 	spin_unlock_bh(&sta->lock);
 
-	if (sta->sta.deflink.eht_cap.has_eht) {
+	if (sta->sta.deflink.eht_cap.has_eht ||
+	    ieee80211_hw_check(&local->hw, STRICT)) {
 		buf_size = local->hw.max_tx_aggregation_subframes;
 	} else if (sta->sta.deflink.he_cap.has_he) {
 		buf_size = min_t(u16, local->hw.max_tx_aggregation_subframes,
-- 
2.39.5



