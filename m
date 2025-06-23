Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3915F1EEA3C;
	Mon, 23 Jun 2025 21:28:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750714111; cv=none; b=l14Ri2HmKVB0bHcnzDWWjI1yVtfsDcBJVD8U5Nr+QOApC9kaGbVJm4SJDOWGYbUkn9MTNkPj/A0kkja4fAq3axpXWOTcTGl7X2Wm0dFLjopZzkbBlUs+ogSJ+rSWq99WpRRCLaEraHKEkZKD7DCBqV/wULymKqS0hmm+n0wm7yY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750714111; c=relaxed/simple;
	bh=539THhbACgAebh1J3nrpjLbMklshM3SCkLhiETufJZo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=q2LdnfaiBerWVgN5jd81LPY0b7OT/bklGrSeH7vhm06hP0x9pI5sTgIUdKbuMyV/c/EGiq1RhoP8JJ3WbBQFSutYwmUpdUYWv+EVUbR2CDziiXgraFuo8vz0J2Hgt83KtgDnWp7nHlSE3gYlo2ncb7VW47W0tnJ//IbbUr4L9No=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pmAQrtId; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pmAQrtId"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C6169C4CEEA;
	Mon, 23 Jun 2025 21:28:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750714111;
	bh=539THhbACgAebh1J3nrpjLbMklshM3SCkLhiETufJZo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pmAQrtIdgb7pYQDZCibO6R9a5JIdHGZSkMiwTG6l4APjHkhcS/PMNs5xrj7efEm3H
	 UOOIqRXuyygemrkBG/hs1G+oHwPXROtWZ4qDNamIE9PWZRjGmBVMNMuojGn1o0aJTr
	 pTn1Q0aMTAU0IPMAexsEe0OojbGuuIC3mSoO0J1I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Miri Korenblit <miriam.rachel.korenblit@intel.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 375/592] wifi: iwlwifi: mld: check for NULL before referencing a pointer
Date: Mon, 23 Jun 2025 15:05:33 +0200
Message-ID: <20250623130709.359066169@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130700.210182694@linuxfoundation.org>
References: <20250623130700.210182694@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Miri Korenblit <miriam.rachel.korenblit@intel.com>

[ Upstream commit f9151f16e140b9c43f076579146679408af6f442 ]

Errors can happen, and it is better not to risk with a NULL pointer
dereference.
Make sure that the links-to-remove pointers are not NULL before
dereferencing it.

Signed-off-by: Miri Korenblit <miriam.rachel.korenblit@intel.com>
Reviewed-by: Johannes Berg <johannes.berg@intel.com>
Link: https://patch.msgid.link/20250430151952.408652d45cda.I1bb72836dab17895a2e39910e4493d667db0fa80@changeid
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/intel/iwlwifi/mld/mac80211.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mld/mac80211.c b/drivers/net/wireless/intel/iwlwifi/mld/mac80211.c
index 68d97d3b8f026..2d5233dc3e242 100644
--- a/drivers/net/wireless/intel/iwlwifi/mld/mac80211.c
+++ b/drivers/net/wireless/intel/iwlwifi/mld/mac80211.c
@@ -2460,7 +2460,7 @@ iwl_mld_change_vif_links(struct ieee80211_hw *hw,
 		added |= BIT(0);
 
 	for (int i = 0; i < IEEE80211_MLD_MAX_NUM_LINKS; i++) {
-		if (removed & BIT(i))
+		if (removed & BIT(i) && !WARN_ON(!old[i]))
 			iwl_mld_remove_link(mld, old[i]);
 	}
 
-- 
2.39.5



