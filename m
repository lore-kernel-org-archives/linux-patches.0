Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795622571;
	b=EDZURBArC4pUGDXXdvceewsWIgQkncoP6nal5sSehZrw+Ni8GYdzTslTJ5VldlLNaYeN
	 +l4/xYHHpAmk0Sm7mXdFvvbPHYVoPBjQbVFI7CkQTl7dkhgg4V37RRBfHdPS/OKyOPJ18
	 QzSkoW9ibUOoph4o676WNWwFZL2Ode94CIVW+ovUeb2tIK5aJBYt2E60BnWlZ2xLyYwQG
	 eaY15Eo7sm4caS1/w3GUvVWb8GJP/5z+h6nZbxXUPybC3mKeo9ucchQfoLeCQNKeG4wdZ
	 +dryDBfJ6uTBYYNwW5wKOSzqrZjzymUF0m36i1Q+sbTmoRhwlnR3MGMUmYgtSByGwTA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795622571;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Xs4yfV8UTWG1XTz1S507KNErVQ7ULQsoJ1itBj1cy1E=;
	b=yb/S7+jYZCUwHP+8iSYSuqtJIYVBaz2jz7Wdvmyx5oxEO+KP8xfDQy8CQlgSuvBeAV7K
	 Tw9nfmOoKf8jdyWBGeNubqb7YadvXhE+883TwstrwrzowczwYA3ZVjvCXp0w5jh5QNjJy
	 ZrptKB1xQoj2u+2yGkY6Vj8e7IVuNKflCYro+BtVef+f7/8PDG3Yaj073QNOxrNlwA7dE
	 B5Rg9LycWcvF7CljWsLBtLW3DKjKxJmcQQptfakcWQ0csm4Uz578E2xJVh7kLfVn8ObYr
	 UwjB+OugRuYXwn5FN+ydJsWXd+ia3xb3HmPneZAgzFhtjMVf8S9n3lBb6OI/SnY9onw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=nL3U2KM0;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 31367606A321;
	Wed, 25 Nov 2026 16:02:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=nL3U2KM0
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 358221F000C6;
	Wed, 25 Nov 2026 16:02:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795622570;
	bh=Xs4yfV8UTWG1XTz1S507KNErVQ7ULQsoJ1itBj1cy1E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=nL3U2KM06wr/7dSRCJvrjwvYSoNLT5DxPzhoOKxOQBnP7mic+INiasmdOxESRkUeq
	 QH7GG1vO7NrRj8F+U83De3ytjm7tOIAQC3K5NhqM7gw8JHS3GhJqgDcBFUfbUcaKUw
	 0NMY5S4VbCrDD0BzXoqm/ej1uGAD5Kf+g2PDPFks=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 579/990] wifi: nl80211: reject zero RNR/MBSSID elements
Date: Wed, 25 Nov 2026 15:32:26 +0100
Message-ID: <20261125143835.653392450@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143822.072087159@linuxfoundation.org>
References: <20261125143822.072087159@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
[ sashal: Kept the existing kzalloc(struct_size(...), GFP_KERNEL) allocation instead of upstream's kzalloc_flex(), adding the zero-element guard above it in both parse functions. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/wireless/nl80211.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index d4b1e5dc5eb4f..429dba541cb88 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -6152,6 +6152,9 @@ nl80211_parse_mbssid_elems(struct wiphy *wiphy, struct nlattr *attrs,
 		num_elems++;
 	}
 
+	if (!num_elems)
+		return ERR_PTR(-EINVAL);
+
 	elems = kzalloc(struct_size(elems, elem, num_elems), GFP_KERNEL);
 	if (!elems)
 		return ERR_PTR(-ENOMEM);
@@ -6187,6 +6190,9 @@ nl80211_parse_rnr_elems(struct wiphy *wiphy, struct nlattr *attrs,
 		num_elems++;
 	}
 
+	if (!num_elems)
+		return ERR_PTR(-EINVAL);
+
 	elems = kzalloc(struct_size(elems, elem, num_elems), GFP_KERNEL);
 	if (!elems)
 		return ERR_PTR(-ENOMEM);
@@ -6335,7 +6341,8 @@ static int nl80211_parse_beacon(struct cfg80211_registered_device *rdev,
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



