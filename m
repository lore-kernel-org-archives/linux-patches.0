Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795625306;
	b=0t3qjt8YOe3IiUcD9Ad+2nicxI1ZIrhw9Z9VlMUePqB+XxhcFlAuZUZI32VtqXOqyPha
	 KInoiTka4ZzwJ5CEQeUHtobuF+aDIKccFOjw2YPl6sfMzQMPA54xxynsgcpXT2W5eRIcx
	 NSFMhswa3vgDSCr+IAZdzvA9Ph46qWofE/3tJr+b9jg9uOZchfJVUX4527Sk43hqBYjy8
	 cRm/2eYM0O7Z4wCtF1UhszgtlQWzUavqEPYWHhQOCofoF2AZII8Tl0hffq7Dt8Nxg/3se
	 X4WisDjZVGUVz/RpYQddmF6Cz9TsOl2zZWzBIZJBHKDCyyo3vjXp3IjUuUINnoMLtHQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795625306;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=d23an01DYSZZRzH5cwf27J4kYLY2HD5N4ko2z4E4Su4=;
	b=nVDmfX17HyDQzjPKK0bwEYJIBqdzNpDlsd4dNJDWLeeF9ITxhznmMmb7S1bHHMeav6yD
	 rKegk5BUStQ273Pcdx2cfRlAD/+xwhK9plcwezKQ+irb6RfL3VpsoaZyvXl/2WN3uLV1/
	 1BrwouJJJxiEriF2aTq0HcmTn2M3xyZKTKIUTnLt7DRS4nmAkKuQ3bQardvIDu6+ViMOr
	 2+b2RAIorKmPlS0ds5/BKamvdavqqsPRy5Q2ZW+6daxSFCOl2CxtagqFhTd8sWxoRyVhT
	 e+01TLQCk27UgA2FtLd+pr6dHQGpbflmZlqwBPw5FL70QN02LcS4L21Da27z1JKiKyg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=KzU2Lmm0;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DBB26606A326;
	Wed, 25 Nov 2026 16:48:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=KzU2Lmm0
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C60C21F000CF;
	Wed, 25 Nov 2026 16:48:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795625306;
	bh=d23an01DYSZZRzH5cwf27J4kYLY2HD5N4ko2z4E4Su4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=KzU2Lmm0/dq+2s7IYNEB5Nl2xhpOFs0EiBCN+GwmNgr/YLEmfXnCKawZfKY6n9IS6
	 3GoVoIA8S8aspmwa52uJ0PkPoEd1sUv3t3V2T0lMrOT8318eErUSC0XJYKCotjidrf
	 3Rq4c8lI5ueukaSZpLhqRLLr5ZKxqOznYY8uvk5Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 474/816] wifi: nl80211: reject zero RNR/MBSSID elements
Date: Wed, 25 Nov 2026 15:33:42 +0100
Message-ID: <20261125143900.171852134@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143849.205329330@linuxfoundation.org>
References: <20261125143849.205329330@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johannes Berg <johannes.berg@intel.com>

[ Upstream commit c767e1173aeab7825a8dfb197041d3996db84e39 ]

That's a nonsensical configuration, and we get errors
reported further down in mac80211 for it; hostapd has
code that only adds the nested element if it'll not be
an empty list.

Remove an unnecessary NULL check while at it.

Fixes: dbbb27e183b1 ("cfg80211: support RNR for EMA AP")
Assisted-by: LLM
Link: https://patch.msgid.link/20261005224950.97db49d9d104.I5765a3310528b3d1cb1673dc90ad5ab5fc3ea571@changeid
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
[ sashal: Kept the existing kzalloc(struct_size(...), GFP_KERNEL) allocation instead of kzalloc_flex() in both parsers, and added the zero-element check above it. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/wireless/nl80211.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index 0062ce34d4efb..4961c324a1714 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -5581,6 +5581,9 @@ nl80211_parse_mbssid_elems(struct wiphy *wiphy, struct nlattr *attrs,
 		num_elems++;
 	}
 
+	if (!num_elems)
+		return ERR_PTR(-EINVAL);
+
 	elems = kzalloc(struct_size(elems, elem, num_elems), GFP_KERNEL);
 	if (!elems)
 		return ERR_PTR(-ENOMEM);
@@ -5616,6 +5619,9 @@ nl80211_parse_rnr_elems(struct wiphy *wiphy, struct nlattr *attrs,
 		num_elems++;
 	}
 
+	if (!num_elems)
+		return ERR_PTR(-EINVAL);
+
 	elems = kzalloc(struct_size(elems, elem, num_elems), GFP_KERNEL);
 	if (!elems)
 		return ERR_PTR(-ENOMEM);
@@ -5764,7 +5770,8 @@ static int nl80211_parse_beacon(struct cfg80211_registered_device *rdev,
 			if (IS_ERR(rnr))
 				return PTR_ERR(rnr);
 
-			if (rnr && rnr->cnt < bcn->mbssid_ies->cnt) {
+			/* RNR elements are only used with MBSSID elements */
+			if (rnr->cnt < bcn->mbssid_ies->cnt) {
 				kfree(rnr);
 				return -EINVAL;
 			}
-- 
2.53.0



