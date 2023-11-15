Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE1103DB8D
	for <patches@lists.linux.dev>; Wed, 15 Nov 2023 19:21:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nANRHOoQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6A3D2C433C8;
	Wed, 15 Nov 2023 19:21:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700076066;
	bh=0I/OQce0ai5oYfvKW20ZUkVruaSBLFFbUcbFQba/tpI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nANRHOoQH2UGSiWWOB9tX/VJuDV4RtpQjwq3fjEuD7+MHaLmbO7hdyNXoZ6BMfOZ5
	 DSAQ4kxx8Gvyz5u4pKYLuyeh0PqvDemA0QlKvEyUfH9Z5W8xsg3KdWXuHxCCHr8XUP
	 3WOqT4s0EZYxgx1Agc0084b/hqXKsLabxQONt9SU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stephen Rothwell <sfr@canb.auug.org.au>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.5 054/550] wifi: cfg80211: fix kernel-doc for wiphy_delayed_work_flush()
Date: Wed, 15 Nov 2023 14:10:38 -0500
Message-ID: <20231115191604.432179147@linuxfoundation.org>
X-Mailer: git-send-email 2.42.1
In-Reply-To: <20231115191600.708733204@linuxfoundation.org>
References: <20231115191600.708733204@linuxfoundation.org>
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

[ Upstream commit 8c73d5248dcf112611654bcd32352dc330b02397 ]

Clearly, there's no space in the function name, not sure how
that could've happened. Put the underscore that it should be.

Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
Fixes: 56cfb8ce1f7f ("wifi: cfg80211: add flush functions for wiphy work")
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/cfg80211.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index 0f0bf26adb15d..d58d6d37a4479 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -5881,7 +5881,7 @@ void wiphy_delayed_work_cancel(struct wiphy *wiphy,
 			       struct wiphy_delayed_work *dwork);
 
 /**
- * wiphy_delayed work_flush - flush previously queued delayed work
+ * wiphy_delayed_work_flush - flush previously queued delayed work
  * @wiphy: the wiphy, for debug purposes
  * @work: the work to flush
  *
-- 
2.42.0



