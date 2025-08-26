Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2FD00286881;
	Tue, 26 Aug 2025 13:52:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756216342; cv=none; b=KnEq1dGc2GgPvjsQLCv02NnRSa+wPOFCsl/i4H/0eLDLuXrFHdgakB4IXCyDSQQvGyW1fx1xjRVxNjSCHKEdoCqkDMFeOTzanXxhRFJIykH0XIQX8BLXy9sEXh6SJeFrfeni9JfQ1WOkeS5WXDmrtA4CDeIeF4aSbNg89tX0Jq4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756216342; c=relaxed/simple;
	bh=dj89qMR9X5ZRmcq/feecMTv4m7czOFHQaNshVJ0rXU8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gvzxtoVUDr3i6Vuy0tMuSKUDm2Z9t6jOmMCEgkuedEZVSrtCKt9YI1EwWeymL8Ei5Ie121WS3gbkFbZepywXBf/GuAZzdmlLEdQ8XJUqqJtz7kyH0Fai0+sXQ9B5R21CZUIKwA6sVHdqac1XDNUqblYFp2E0e3y7cSqxC9FT07w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mYHeyb5y; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mYHeyb5y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B4DCFC4CEF1;
	Tue, 26 Aug 2025 13:52:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756216342;
	bh=dj89qMR9X5ZRmcq/feecMTv4m7czOFHQaNshVJ0rXU8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mYHeyb5yDznPJ7H14pjMNGFhT3wDSAh11NB8ga/eKohDD7b+rezbNROUD5/oba/sg
	 RJ1+rjRO8KjWDhBlSeR30xEx79Or7qjSK2dM6LOVv2bU/l+NW6rOhk310/heJttXUk
	 1F1MlCYyLe8FXPTxk0APPtCpSXjHqe4AH33srRrk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ilan Peer <ilan.peer@intel.com>,
	Miri Korenblit <miriam.rachel.korenblit@intel.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 348/644] wifi: cfg80211: Fix interface type validation
Date: Tue, 26 Aug 2025 13:07:19 +0200
Message-ID: <20250826110955.019719844@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110946.507083938@linuxfoundation.org>
References: <20250826110946.507083938@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ilan Peer <ilan.peer@intel.com>

[ Upstream commit 14450be2332a49445106403492a367412b8c23f4 ]

Fix a condition that verified valid values of interface types.

Signed-off-by: Ilan Peer <ilan.peer@intel.com>
Signed-off-by: Miri Korenblit <miriam.rachel.korenblit@intel.com>
Link: https://patch.msgid.link/20250709233537.7ad199ca5939.I0ac1ff74798bf59a87a57f2e18f2153c308b119b@changeid
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/cfg80211.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index 963a810ed70d..66a75723f559 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -507,7 +507,7 @@ ieee80211_get_sband_iftype_data(const struct ieee80211_supported_band *sband,
 {
 	int i;
 
-	if (WARN_ON(iftype >= NL80211_IFTYPE_MAX))
+	if (WARN_ON(iftype >= NUM_NL80211_IFTYPES))
 		return NULL;
 
 	if (iftype == NL80211_IFTYPE_AP_VLAN)
-- 
2.39.5



