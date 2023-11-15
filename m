Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D7B0381DC
	for <patches@lists.linux.dev>; Wed, 15 Nov 2023 19:35:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FHgX4Fwk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E0F32C433C8;
	Wed, 15 Nov 2023 19:35:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700076926;
	bh=reKCB7yyYl5v8qFgobGXdXvTGPBXo7s7O+080RAx0Ik=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FHgX4FwkFlltM4ofvgVNqmDnPg8oGCXIVXIf6NbC65+22vHzrN16Dd9PT5oA8MH2I
	 oQeprQ5vlp+zuavXo0hnLJIbEAnpxlDMTsm0Wde2WQCqVzw4IfJhM5rO14ERHS3v18
	 o7ajzqpjbeYWYID7VivpfBk2Y/LXM3o67cJo/DKw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stephen Rothwell <sfr@canb.auug.org.au>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 051/603] wifi: cfg80211: fix kernel-doc for wiphy_delayed_work_flush()
Date: Wed, 15 Nov 2023 14:09:56 -0500
Message-ID: <20231115191616.678191179@linuxfoundation.org>
X-Mailer: git-send-email 2.42.1
In-Reply-To: <20231115191613.097702445@linuxfoundation.org>
References: <20231115191613.097702445@linuxfoundation.org>
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
index 308a004c1d1dc..153a8c3e7213d 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -5880,7 +5880,7 @@ void wiphy_delayed_work_cancel(struct wiphy *wiphy,
 			       struct wiphy_delayed_work *dwork);
 
 /**
- * wiphy_delayed work_flush - flush previously queued delayed work
+ * wiphy_delayed_work_flush - flush previously queued delayed work
  * @wiphy: the wiphy, for debug purposes
  * @work: the work to flush
  *
-- 
2.42.0



