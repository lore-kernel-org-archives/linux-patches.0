Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA6003C23
	for <patches@lists.linux.dev>; Mon, 19 Jun 2023 10:37:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D43D3C433C0;
	Mon, 19 Jun 2023 10:37:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1687171058;
	bh=9Q/Qb7ZYPRmqdEB/QUXDxCQOT5kQDYXPzIN7sSovbWg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=eQ3oNjGtYlDISDRq9SunUQQBmLeN+/ldGaOIgZUbybB+MK6GiPprvo0zIIP8UAc2H
	 +mgPhMw/Vag015G0kMI1dpEfVrHHDMsWTxqRQFTYVlSyOx/OZLAOxsWrMSeFpDXtT8
	 GaP2AlAaMqo628saM1bGlvumthrONoWeUDoA52v0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Benjamin Berg <benjamin.berg@intel.com>,
	Gregory Greenman <gregory.greenman@intel.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.3 133/187] wifi: cfg80211: fix link del callback to call correct handler
Date: Mon, 19 Jun 2023 12:29:11 +0200
Message-ID: <20230619102204.055297943@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230619102157.579823843@linuxfoundation.org>
References: <20230619102157.579823843@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Benjamin Berg <benjamin.berg@intel.com>

[ Upstream commit 1ff56684fa8682bdfbbce4e12cf67ab23cb1db05 ]

The wrapper function was incorrectly calling the add handler instead of
the del handler. This had no negative side effect as the default
handlers are essentially identical.

Fixes: f2a0290b2df2 ("wifi: cfg80211: add optional link add/remove callbacks")
Signed-off-by: Benjamin Berg <benjamin.berg@intel.com>
Signed-off-by: Gregory Greenman <gregory.greenman@intel.com>
Link: https://lore.kernel.org/r/20230608163202.ebd00e000459.Iaff7dc8d1cdecf77f53ea47a0e5080caa36ea02a@changeid
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/wireless/rdev-ops.h | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/net/wireless/rdev-ops.h b/net/wireless/rdev-ops.h
index 13b209a8db287..ee853a14a02de 100644
--- a/net/wireless/rdev-ops.h
+++ b/net/wireless/rdev-ops.h
@@ -2,7 +2,7 @@
 /*
  * Portions of this file
  * Copyright(c) 2016-2017 Intel Deutschland GmbH
- * Copyright (C) 2018, 2021-2022 Intel Corporation
+ * Copyright (C) 2018, 2021-2023 Intel Corporation
  */
 #ifndef __CFG80211_RDEV_OPS
 #define __CFG80211_RDEV_OPS
@@ -1441,8 +1441,8 @@ rdev_del_intf_link(struct cfg80211_registered_device *rdev,
 		   unsigned int link_id)
 {
 	trace_rdev_del_intf_link(&rdev->wiphy, wdev, link_id);
-	if (rdev->ops->add_intf_link)
-		rdev->ops->add_intf_link(&rdev->wiphy, wdev, link_id);
+	if (rdev->ops->del_intf_link)
+		rdev->ops->del_intf_link(&rdev->wiphy, wdev, link_id);
 	trace_rdev_return_void(&rdev->wiphy);
 }
 
-- 
2.39.2



