Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A94F9168D5
	for <patches@lists.linux.dev>; Mon,  9 Oct 2023 13:11:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="o6D8CnKF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 26E54C433C8;
	Mon,  9 Oct 2023 13:11:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1696857095;
	bh=qVgVK9to3MbkVHD6z32ethxBBgNESBYLxehQQWPlCtE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=o6D8CnKFNeedviiuu7vmoFEWCgTYiyFbbJXH+/jRx4EwtdBx+2X2EFtP4hu4wr/Z5
	 FzbJ0qRklUdX7skc7OV7nKxEajfHW9F4cevzwKt9ykbt/1IGU6mHziCMXjHVAqS+SX
	 ZZWznJdKuWVu5An8IlWoyU2y5BlNVO80ywCyL1GE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stephen Rothwell <sfr@canb.auug.org.au>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.5 068/163] wifi: cfg80211: add missing kernel-doc for cqm_rssi_work
Date: Mon,  9 Oct 2023 15:00:32 +0200
Message-ID: <20231009130125.925481241@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231009130124.021290599@linuxfoundation.org>
References: <20231009130124.021290599@linuxfoundation.org>
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

6.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johannes Berg <johannes.berg@intel.com>

[ Upstream commit d1383077c225ceb87ac7a3b56b2c505193f77ed7 ]

As reported by Stephen, I neglected to add the kernel-doc
for the new struct member. Fix that.

Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
Fixes: 37c20b2effe9 ("wifi: cfg80211: fix cqm_config access race")
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/cfg80211.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index 0debc3c9364e8..641c6edc9b81d 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -5942,6 +5942,7 @@ void wiphy_delayed_work_cancel(struct wiphy *wiphy,
  * @event_lock: (private) lock for event list
  * @owner_nlportid: (private) owner socket port ID
  * @nl_owner_dead: (private) owner socket went away
+ * @cqm_rssi_work: (private) CQM RSSI reporting work
  * @cqm_config: (private) nl80211 RSSI monitor state
  * @pmsr_list: (private) peer measurement requests
  * @pmsr_lock: (private) peer measurements requests/results lock
-- 
2.40.1



