Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 45E5532AABE
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 17:53:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772301237; cv=none; b=QLU0AFHXMKDjc6b4QqsNmmMo4yTQazXq+2n6quJsUeHN+PO4Wrx0MQ0kxz8kLTDNd+Zp8Xf94pFuriYUctWZlJC8mXkugvw85M0zvDLvEnzaN0epEBXmBbH+RR8OCdYoMsM56hNOmPh2GJBvalGWE/A4JdN5UAUzuDO7rtaiuxA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772301237; c=relaxed/simple;
	bh=Z3JggKkIQWZ7ZM1BGBwbAxjDIQXOhJSkTCR4Gf/52sM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FYl+6qtkKX2HJEILqBIx78tfFuKYdvL5fe9BjiiJ2AOWCZNUkyMPMyDgA4sCelqUIGKzAprEUfGekgUeCwG8v+Paw+RWDTFLCBYT5hgFFQ6fLdyDetHIq/yxfnHp9c4Ha0tL+oVjgu4cuRJBTiRv14xXq+J3kb+sRlJMQZSDlfo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=DcD7tKFb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="DcD7tKFb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A7130C116D0;
	Sat, 28 Feb 2026 17:53:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772301237;
	bh=Z3JggKkIQWZ7ZM1BGBwbAxjDIQXOhJSkTCR4Gf/52sM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DcD7tKFbZh9JTsYPvd8Rz3LxPUGdZLiQ9dOzCCkBBMmC025cgKIa2tK1AnDCasuut
	 qxR1IJOpShdFgETg8v0biv/Repg+uCxL0FaTz5tQOQTH960yzPgp07d8K+8o51J7IN
	 7Zh31imzZYGd/imlWU9WtSA8s7kOM5cOufDp34n6mO9g84EIFVGiqb+nKrebDA8ShF
	 oCTGUauqSpoOmhm978t2Qh0L0DpoIxF4ft4uq0ZoFNPvOWr0JMZ5HyOntUBF4TB8sr
	 mr0Vfg+wyK9flnA0XUFooIDbSVbP/GATA7os3NblMUSJOcyrGmw1uQCpBzZQERWgH9
	 ZtI2Pka6nNIpQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Johannes Berg <johannes.berg@intel.com>,
	Jouni Malinen <j@w1.fi>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 416/752] wifi: cfg80211: wext: fix IGTK key ID off-by-one
Date: Sat, 28 Feb 2026 12:42:07 -0500
Message-ID: <20260228174750.1542406-416-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228174750.1542406-1-sashal@kernel.org>
References: <20260228174750.1542406-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Johannes Berg <johannes.berg@intel.com>

[ Upstream commit c8d7f21ead727485ebf965e2b4d42d4a4f0840f6 ]

The IGTK key ID must be 4 or 5, but the code checks against
key ID + 1, so must check against 5/6 rather than 4/5. Fix
that.

Reported-by: Jouni Malinen <j@w1.fi>
Fixes: 08645126dd24 ("cfg80211: implement wext key handling")
Link: https://patch.msgid.link/20260209181220.362205-2-johannes@sipsolutions.net
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/wireless/wext-compat.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/wireless/wext-compat.c b/net/wireless/wext-compat.c
index 1241fda78a68c..680500fa57cfd 100644
--- a/net/wireless/wext-compat.c
+++ b/net/wireless/wext-compat.c
@@ -684,7 +684,7 @@ static int cfg80211_wext_siwencodeext(struct net_device *dev,
 
 	idx = erq->flags & IW_ENCODE_INDEX;
 	if (cipher == WLAN_CIPHER_SUITE_AES_CMAC) {
-		if (idx < 4 || idx > 5) {
+		if (idx < 5 || idx > 6) {
 			idx = wdev->wext.default_mgmt_key;
 			if (idx < 0)
 				return -EINVAL;
-- 
2.51.0

