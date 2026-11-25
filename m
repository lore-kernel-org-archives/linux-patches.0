Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795623301;
	b=WGNemzkBxaPXxLhLvRdja9wNpdisZfsvB6eg4XJVuYsktTer/7yJ3itGhqvlr8+sPBbF
	 RSbARjvtA63EiViW4q9fmJ8mS5W8KJR0eo76RiBxj+SeQsVq5bDJZw7zdiJkyN001M/yB
	 ynR6RhRL78G41gNUu7RewF/M5JLfixhLrHlMEsmjg4JtAD1o/44lEKSR+0/shuttGoYCS
	 w6kBvoMuZ4mKBQMB8XnxFR1Ibw/yBaErNDH0ohYFeaKi5u5v3Rm+VgNH0aZU1+tgHhP7F
	 AytRPQGyI52IaPKZTzJppQHyXpwWPR6R78MAg3QCnS9Dtc5K+UbQnoaTftsGEui7+QA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795623301;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=QmVpkljwqxwqxZOiz8ptRdVO8eIfksdT/1JN1Zv2i5Q=;
	b=bAIVnZKx1Jp/pHf2PjnGlJeJzCitm30ZFJdX3/70l3KPxjH/3ZxkwCosWlmfHKx6BbPk
	 oUkdAXhVM7Ojt3xvcDlyuL39FrYtGR3NgfD4zq+Bt1TwoS6HMD5r+B/Cewe5dslKkBm2o
	 mCZD2bUfAoOEeo8UScl/FyRnI5L2NLaHYqX/MZJhAHLDsA3rTSTog7OoGek0XgfcIettX
	 iwqIW6UQYitWe5w6TgdUcwd7qlebhC3gDsPCES41B3k/U8iNkxE3aSc7/okk0cDMvGXNi
	 v1PZZhSmoZuDvjlhEV2Ffwv9bHO67BDl/McqQ2Abbem7ZX+oliHYgZ2fEhc9i0/QnLA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=D6AJxRZm;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A197606A327;
	Wed, 25 Nov 2026 16:15:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=D6AJxRZm
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CC6381F000C0;
	Wed, 25 Nov 2026 16:15:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795623301;
	bh=QmVpkljwqxwqxZOiz8ptRdVO8eIfksdT/1JN1Zv2i5Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=D6AJxRZmSwzU6QCwBDivGmG6oWXHn7Aq7GRpGOTq1v4hhOEjQ4gCDxpaZmV9EZOOo
	 yajd9T3N1bpjNd2XqblQ6ZUXBJAQuVl5AQCTs8wwqLxZhXesJvwn+35JzIacy6VvSj
	 PyALRi8vZkbOr2dS6FmjpHbhddDjX9V0OHOXwilE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wahid Khan <wahidzk0091@gmail.com>,
	Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 6.18 813/990] wifi: cfg80211: dont truncate the merged MBSSID profile length
Date: Wed, 25 Nov 2026 15:36:20 +0100
Message-ID: <20261125143841.086568336@linuxfoundation.org>
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

From: Wahid Khan <wahidzk0091@gmail.com>

commit 3ea152f3f77eeffc37b2f4423688b4df9136f90c upstream.

cfg80211_parse_mbssid_data() keeps the length of a non-transmitted BSSID
profile in a u8. cfg80211_merge_profile() returns a size_t, and it
concatenates a profile that is split over several Multiple BSSID
elements, so the merged length can be well above 255 even though every
single sub-element is at most 255 bytes long.

The value is then cut to its low 8 bits. A 300 byte profile is handled
as a 44 byte one: the elements after the cut are lost from the generated
non-transmitted BSS, and if the Multiple BSSID-Index element lies past
the cut the BSS is dropped altogether. Any AP in range can send such a
profile.

The multi-link code further down in the same file already uses a signed
size type for the profile length. Do the same here, cfg80211_find_ie()
and cfg80211_gen_new_ie() take a size_t anyway.

Fixes: fe806e4992c9 ("cfg80211: support profile split between elements")
Cc: stable@vger.kernel.org
Signed-off-by: Wahid Khan <wahidzk0091@gmail.com>
Link: https://patch.msgid.link/20261104211451.693451-1-wahidzk0091@gmail.com
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/wireless/scan.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/net/wireless/scan.c
+++ b/net/wireless/scan.c
@@ -2580,7 +2580,7 @@ cfg80211_parse_mbssid_data(struct wiphy
 		if (elem->data[0] < 1 || (int)elem->data[0] > 8)
 			continue;
 		for_each_element(sub, elem->data + 1, elem->datalen - 1) {
-			u8 profile_len;
+			size_t profile_len;
 
 			if (sub->id != 0 || sub->datalen < 4) {
 				/* not a valid BSS profile */


