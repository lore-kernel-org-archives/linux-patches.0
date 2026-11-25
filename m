Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795626026;
	b=sTpXhIUwpoHZ/NIuVYdO3PLXtMcLJ2oLVzxkim8hcRTvjf0zasKJcFQ1Gi5igluo9prz
	 Jiz0uATM4kK8JlXsTS169AnmIDFAcYV6zUAkLNu44udX3uN/lXKDHwmkLvvf3EZa3k1qx
	 tANMGiy16mIyK/5YviPcRCTL5ukYWdWIjnqasBDRJYZl1cWAQmZWo3OZC9pdsQui3CgJK
	 4Nci6t0Fo844AR0xZFxjDiacjacj2famXFFYpWf1jHyyISwZcXqTxvsmtOtcU+MyYwVoq
	 XPZOonZRQiwVf5DdV/x67f7eh+x/kt4Bg1j73zWtXmoKgbUpno4lZpXJrmaLlXWbnOw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795626026;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ru9pfyK4QTysJlw/7ZjuwOIaVOM4BSRu21wS4St0G2I=;
	b=gQ2ioV6WyJ/FyBE0azMX0ok+2LhfrnclXJihknu8dw2iisxJJmCCGhxX2usVqPI1CihW
	 1qOj69NlBVwPS8xypmr6lTARXElo5MRWb/CQ4aRiN2IFifw4qyFXARO6Vha+SME/b80K7
	 7c8QSnSZDYitPHCs/na7bBhTjH+FWBcIA1Ej1IVwLZyYPhAnG8I77hRSIo5Mb7VN54ESe
	 wJ2NltyCQgscASkL4x2O+0m+yhoujj7wCZwgQnFjt5IdFuKRqBIhgmdgz6HCaRiUwB5bW
	 WTdZVfgWt1BZ5Y3M62nc0Je/HIPyFtRbHWqYpLthJ46s2iu8p34lhX6iw+lbBjqLr+g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=W27e4rUX;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 60270606A31E;
	Wed, 25 Nov 2026 17:00:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=W27e4rUX
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B16B41F000C0;
	Wed, 25 Nov 2026 17:00:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795626026;
	bh=ru9pfyK4QTysJlw/7ZjuwOIaVOM4BSRu21wS4St0G2I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=W27e4rUXxxGmJjnKE6d72w2nKj94YYGo59bXN0/PFRS+cL3Z7+Yv0l4g7maIV5fxj
	 bYsVFsOGdXJgrjoekrKi1hiM1aNqPyxPAdps6qHG4MQTFzMRrfCfVisGgvVyCtwEON
	 MT1U9olD6Kb5YRuiC1zPX6t6UDw53vDePUwEgkwg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wahid Khan <wahidzk0091@gmail.com>,
	Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 6.12 662/816] wifi: cfg80211: dont truncate the merged MBSSID profile length
Date: Wed, 25 Nov 2026 15:36:50 +0100
Message-ID: <20261125143904.502141177@linuxfoundation.org>
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
@@ -2497,7 +2497,7 @@ cfg80211_parse_mbssid_data(struct wiphy
 		if (elem->data[0] < 1 || (int)elem->data[0] > 8)
 			continue;
 		for_each_element(sub, elem->data + 1, elem->datalen - 1) {
-			u8 profile_len;
+			size_t profile_len;
 
 			if (sub->id != 0 || sub->datalen < 4) {
 				/* not a valid BSS profile */


