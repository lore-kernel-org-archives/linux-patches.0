Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6DED813A27F;
	Tue, 23 Jan 2024 00:23:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705969433; cv=none; b=cOW+VeztPJZcNTBICm/3gbCDfaJ0k3Inv1Ke13/mMJsLtNfzdBWZ+pU4jaSfWP0GSFYNjIzDaxBkxN8LDSJNrMDScr/dYSanxgvmK4vOd7yzGEDU9GnD4VqF1pRGWdjnFyOkDs0X7y7+y3A4MxRkpeoZ1phzE1e9s95yM1IbHjg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705969433; c=relaxed/simple;
	bh=wtNJDXpbk1pmv6nCQOCoQaeTBdGiYR9qNSbms0WATgY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FA4FEiAMwSLdq9WSdhsn6FT37AKnvrRUEA8jjizqVAjmqELVaSVKHifioQ/8w94v6CPu9XS5XFSeQpd7/Rf/a/96KNYXhUw7+gce4/U6H+AgTej9Blo7v/HlYIJaYEvLB9x6rxobw68CSUmt9yYv/EACLBLTfbbv1d1pit0i7yc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QvrNZcZA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QvrNZcZA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2F47AC433F1;
	Tue, 23 Jan 2024 00:23:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705969433;
	bh=wtNJDXpbk1pmv6nCQOCoQaeTBdGiYR9qNSbms0WATgY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QvrNZcZAvppa1tPqrLCTqd07B/4sRoRz5vCF2u5VtVoIJwS6Ezp+e6NaB4ieS7kDm
	 1WERESiGQvcyiP5DwXTr6/oGIGp42mQnC/+GvoSjrncLykg+KhvbBaPv1WjfoxHMwr
	 EEyRQGMSdgJ53ygG8nB4B+1O1uKbeXj+pWYDkQYA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ilan Peer <ilan.peer@intel.com>,
	Gregory Greenman <gregory.greenman@intel.com>,
	Miri Korenblit <miriam.rachel.korenblit@intel.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 218/641] wifi: iwlwifi: mvm: Do not warn if valid link pair was not found
Date: Mon, 22 Jan 2024 15:52:02 -0800
Message-ID: <20240122235824.760799702@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235818.091081209@linuxfoundation.org>
References: <20240122235818.091081209@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ilan Peer <ilan.peer@intel.com>

[ Upstream commit c5bfdb46636a2ea7f0678243c6d3e9f8d26b027a ]

It is possible that though multiple links are enabled we cannot enabled
EMLSR enable more than a single link, e.g., all valid links are on the
same band etc. Thus, do not warn in case no valid link pair is found.

Fixes: b9be67fb4207 ("wifi: iwlwifi: mvm: Add basic link selection logic")
Signed-off-by: Ilan Peer <ilan.peer@intel.com>
Reviewed-by: Gregory Greenman <gregory.greenman@intel.com>
Signed-off-by: Miri Korenblit <miriam.rachel.korenblit@intel.com>
Link: https://msgid.link/20231219215605.142e57a05230.I7cfe78c94c3d15c4c744bccadd8f187e43594932@changeid
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/intel/iwlwifi/mvm/mld-mac80211.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/mld-mac80211.c b/drivers/net/wireless/intel/iwlwifi/mvm/mld-mac80211.c
index ff6cb064051b..8e263acbc763 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/mld-mac80211.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/mld-mac80211.c
@@ -716,7 +716,7 @@ void iwl_mvm_mld_select_links(struct iwl_mvm *mvm, struct ieee80211_vif *vif,
 		}
 	}
 
-	if (WARN_ON(!new_active_links))
+	if (!new_active_links)
 		return;
 
 	if (vif->active_links != new_active_links)
-- 
2.43.0



