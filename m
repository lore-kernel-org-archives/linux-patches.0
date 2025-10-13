Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 564343093CE;
	Mon, 13 Oct 2025 15:35:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760369714; cv=none; b=TvZ4r3H/mJtel1La0nC2bTtza1r9aXscJbv8Fz2cEWMth0IXJdFAI5tCRz2qM3ZkWssLxIt+0TIoyXsiNVewV968evnK2H4JjVdswi0PXohq7rM6pRCtFKnOXjN2olJk2pjbTDp55WJmEL6tUl2nwhPAPL8Rg6/bodqEfqBk/co=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760369714; c=relaxed/simple;
	bh=gFO1nVF3OPkAVhWf0dHEhrK23Zh2H3H7QDqbpl0nMl8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Up5fxobR2SjTCb8VS3M5SAfL9iGU4TSBplKTHc/6+OGf6BPy2+SDOnWh4VooO8oSUoQPumQpM8pvqe4steeponLHe9RPTb4K0Oo8sZA3zgDtFtFLU2BqOV6tV1dJR6hassba3ky5f95spz7vbTcFWXED4FItRzbq1c+qDu3/vnQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QHd4Umk/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QHd4Umk/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D6299C4CEE7;
	Mon, 13 Oct 2025 15:35:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760369714;
	bh=gFO1nVF3OPkAVhWf0dHEhrK23Zh2H3H7QDqbpl0nMl8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QHd4Umk/QEpo7P12VomRSJHTUO4y6AGBxyJw6IjTy4Y1lM156rvIOFUbpLslSm6UH
	 0HRUtzkhnn+sy2tuPP4PjNvtR/KCig4F5T2WP13HRsCc9wcFsb5GkDs+7aqLpVUYMM
	 pl+7iMwkocBptB81L5j7Ry/dRfrxqvWjbrce2Jjc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lorenzo Bianconi <lorenzo@kernel.org>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 309/563] wifi: mac80211: Make CONNECTION_MONITOR optional for MLO sta
Date: Mon, 13 Oct 2025 16:42:50 +0200
Message-ID: <20251013144422.458561237@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251013144411.274874080@linuxfoundation.org>
References: <20251013144411.274874080@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lorenzo Bianconi <lorenzo@kernel.org>

[ Upstream commit ac36daa83650c26fd55dee1a6ee5144769239911 ]

Since commit '1bc892d76a6f ("wifi: mac80211: extend connection
monitoring for MLO")' mac80211 supports connection monitor for MLO
client interfaces. Remove the CONNECTION_MONITOR requirement in
ieee80211_register_hw routine.

Fixes: 1bc892d76a6f ("wifi: mac80211: extend connection monitoring for MLO")
Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
Link: https://patch.msgid.link/20250826-remove-conn-mon-check-ieee80211_register_hw-v2-1-5a1e2f038245@kernel.org
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/mac80211/main.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/net/mac80211/main.c b/net/mac80211/main.c
index 3ae6104e5cb20..78f862f79aa82 100644
--- a/net/mac80211/main.c
+++ b/net/mac80211/main.c
@@ -1164,9 +1164,6 @@ int ieee80211_register_hw(struct ieee80211_hw *hw)
 		if (WARN_ON(!ieee80211_hw_check(hw, MFP_CAPABLE)))
 			return -EINVAL;
 
-		if (WARN_ON(!ieee80211_hw_check(hw, CONNECTION_MONITOR)))
-			return -EINVAL;
-
 		if (WARN_ON(ieee80211_hw_check(hw, NEED_DTIM_BEFORE_ASSOC)))
 			return -EINVAL;
 
-- 
2.51.0



