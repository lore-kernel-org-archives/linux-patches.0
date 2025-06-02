Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA369221299;
	Mon,  2 Jun 2025 14:16:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748873805; cv=none; b=oSjrFvNFFElKb7xUc3Q1r4E02vhFDc/u1DPicqy850ZUcvaNdWK2cLA+lXHRv9JFUKGl43gj8DhzSNwOyoLaYqYfN22c+XlOWmvfVyVmi/tMv7Ve9T7Lp37xzjx5oNZYBDsyOX5OAUXMyGAbMTeDCSZNT8++a1u9tV/40ytM0SY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748873805; c=relaxed/simple;
	bh=OXldEu8VXMYwb+suDim8mQdBid9/KQaEpMpUSLR/aY8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=P+r+r972HQi/9KNJ6TsIXqucc2Hy8ygqRF7U1enRF70jwYNogxhO8MKF0dmgJH8DsY8bjs/6LQZpDxCVRPZgqPin/ChrnrEgdbypYi1dc24onIfKF8T+27A2mXHY4V0PXmt7q98SUieXNB7SMkDcV2VMsjw6BX2GkaM9MV0EzSI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=O2dfcTCY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="O2dfcTCY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 67557C4CEEB;
	Mon,  2 Jun 2025 14:16:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748873805;
	bh=OXldEu8VXMYwb+suDim8mQdBid9/KQaEpMpUSLR/aY8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=O2dfcTCY25nINCF5Y+u4W65Ve6r0i6Zw1/8eXYhE/CjGwqtPtNtj03kOKmHpm1C4G
	 lzBunoxK4IxD2L07otpBjeDcoB5lCsybl0xerOpa4m09Qhadk5C3GI0VVFWJlqHBzA
	 3QHnWAHgBSzvdq5tyeCNIFo5jZSwyLxQTVvI9SSk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johannes Berg <johannes.berg@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
	Miri Korenblit <miriam.rachel.korenblit@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 258/444] wifi: mac80211: remove misplaced drv_mgd_complete_tx() call
Date: Mon,  2 Jun 2025 15:45:22 +0200
Message-ID: <20250602134351.398659041@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250602134340.906731340@linuxfoundation.org>
References: <20250602134340.906731340@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johannes Berg <johannes.berg@intel.com>

[ Upstream commit f4995cdc4d02d0abc8e9fcccad5c71ce676c1e3f ]

In the original commit 15fae3410f1d ("mac80211: notify driver on
mgd TX completion") I evidently made a mistake and placed the
call in the "associated" if, rather than the "assoc_data". Later
I noticed the missing call and placed it in commit c042600c17d8
("wifi: mac80211: adding missing drv_mgd_complete_tx() call"),
but didn't remove the wrong one. Remove it now.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Reviewed-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Miri Korenblit <miriam.rachel.korenblit@intel.com>
Link: https://patch.msgid.link/20250205110958.6ed954179bbf.Id8ef8835b7e6da3bf913c76f77d201017dc8a3c9@changeid
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/mac80211/mlme.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index 37163d84104fa..2c7e139efd532 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -7822,7 +7822,6 @@ int ieee80211_mgd_deauth(struct ieee80211_sub_if_data *sdata,
 		ieee80211_report_disconnect(sdata, frame_buf,
 					    sizeof(frame_buf), true,
 					    req->reason_code, false);
-		drv_mgd_complete_tx(sdata->local, sdata, &info);
 		return 0;
 	}
 
-- 
2.39.5



