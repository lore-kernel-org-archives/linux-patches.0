Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E0EC2D5436;
	Tue, 21 Jul 2026 17:40:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784655632; cv=none; b=A4pBt7zLmA+ER5bjIlPtnNVtMlz5Latyt7bAlkNw5zNjv83R33bNbZVaOMgUkV9dWEmhRCVGcbEcfe4ve6Xg8gmIk0LnOfRYyNEkPq+H2LiubZYwWsZS3o6XUoGz1p3nmzXG9bw+gC8vsH/782JZ7DANVa4axKu/TadLybHBdag=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784655632; c=relaxed/simple;
	bh=u7ViV0KzZwpXTU8GnTCnLf4o1EebqSBQd0HIkA1HgpM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mAh7vjdf6WpThS6GtdMA3UQoNjImrISqPzylRJFBze7REtXBPX99PqHpyKR+4j69yEnKg1MsiSGchMA8fyGaoMgw96LSzQvrDrt+NS8Ft/GlCCgPvsmImJ6RUxf96eJAwv8F4DAY4PiLswEBaSnCazjqWjWgxZV8ICZEwgyo1ts=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DNIT47tI; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DNIT47tI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C38CC1F00A3A;
	Tue, 21 Jul 2026 17:40:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784655631;
	bh=yVaCdCXwuA/8zGUwygD1mlR8+xfoBwTRK8WHCCdz4CM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DNIT47tIWgbUEVhvDkZbUfn+jkFj9e4CqzdggoIkOEjnIP/Xim5iaytxH0VjKmwuL
	 meb71kGHKpVGcTKsr60kBj+UumxDIzfrahkp16pNBGVLAZmyuASBlhpvk6Rvq3vvtC
	 0OcDQOjYZ8I3lba7/4sA5PYqsdtlsR7Ck2LpOgzk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Louis Kotze <loukot@gmail.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0081/1611] wifi: cfg80211: fix grammar in MLO group key error message
Date: Tue, 21 Jul 2026 17:03:17 +0200
Message-ID: <20260721152516.667476729@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152514.750365251@linuxfoundation.org>
References: <20260721152514.750365251@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index 54a4585eb3a2dd..6e41a4269e1c57 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -4828,7 +4828,7 @@ static int nl80211_validate_key_link_id(struct genl_info *info,
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



