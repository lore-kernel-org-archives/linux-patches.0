Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6FC7D46AA73;
	Tue, 21 Jul 2026 15:35:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784648154; cv=none; b=o6te5wm2AZjECG8dkkAn3e/vVW09Ek7fxZvhqZLsI3caiH4kGqhG7YXYewUdDt4m6TAm0jijasCn+4i70nn0JrT+PC7Y0tY3Ly/1EvL8/BeFi6injAfz31O1fJUHRjBmOovxrqcWGB+5pB8iU1ZG2MsEc+D1s/v+sCV6MOycKO4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784648154; c=relaxed/simple;
	bh=y322GALiyhVBJAMaw4/PONzL1sVUJ4KfxvottvQvq8E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nHSIa2Npu1rmQdLS+KsiJVH5CwHHyrZkxUrj4jhu/Y/BnMOvEaCibJqAATqm6u8Kn7C6iQNq/FUj5DYi4wi7VW1alK1+T2XlRj2ETeCNPRl3tyzOhIYESDufaiF+z53yjuQGt6FNgkoWb8A6fu3VTOS4lF7m2eJpwCO1NebeyaE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MGtDISU1; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MGtDISU1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CDF321F000E9;
	Tue, 21 Jul 2026 15:35:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784648153;
	bh=D4DCWwvIjtNFfZTrSauWD5HcHRb5nY1CncOeYBMOV7g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=MGtDISU1YUNgPxDjM935+iJLf5xgHWxMXM/PW8k0dSEnC6xsCyGpnb/lHxqEHYSrd
	 uYGGTWRJiZu1L0fAgW+V+36UoohUvgjIqQrnymSLYmJH8JKSF0ePNMbtmB9bTRvLYs
	 MonLVG9uYs+bI3xok44sIaDOhYfktSufqF3mMirA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Louis Kotze <loukot@gmail.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 0093/2077] wifi: cfg80211: fix grammar in MLO group key error message
Date: Tue, 21 Jul 2026 16:56:06 +0200
Message-ID: <20260721152554.885669453@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Louis Kotze <loukot@gmail.com>

[ Upstream commit 9dcc1af3bbf5441f71a1e51b8d81bdf38a249607 ]

The error message emitted by nl80211_validate_key_link_id() when a group
key install on an MLO wdev is missing the link ID reads "link ID must
for MLO group key", which is missing the words "be set". This makes the
error harder to grep and parse in userspace logs, and is reported
verbatim by wpa_supplicant via its nl80211 extack relay, e.g.:

  wpa_supplicant: nl80211: kernel reports: link ID must for MLO group key

The sibling error strings in the same helper already use grammatical
phrasing ("link ID not allowed for pairwise key", "invalid link ID for
MLO group key", "link ID not allowed for non-MLO group key"). Fix this
one to match.

No functional change.

Fixes: e7a7b84e3317 ("wifi: cfg80211: Add link_id parameter to various key operations for MLO")
Signed-off-by: Louis Kotze <loukot@gmail.com>
Link: https://patch.msgid.link/20260414122728.92234-1-loukot@gmail.com
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/wireless/nl80211.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index 76c537a6e8b52d..21e43e08b5d795 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -5112,7 +5112,7 @@ static int nl80211_validate_key_link_id(struct genl_info *info,
 	if (wdev->valid_links) {
 		if (link_id == -1) {
 			GENL_SET_ERR_MSG(info,
-					 "link ID must for MLO group key");
+					 "link ID must be set for MLO group key");
 			return -EINVAL;
 		}
 		if (!(wdev->valid_links & BIT(link_id))) {
-- 
2.53.0



