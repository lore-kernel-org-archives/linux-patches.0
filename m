Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795620202;
	b=Bh5qbgDdxDAoXJSq8A/O6U6De+DJLMk1+pBL4K4L8u8Z6qBYY88NK5pmbmiJ5zboPKrj
	 u8GtAGRLpI0RDACu+jzf/MEvIc8AibEfRLgcHXux+b7VkX0lyGI3H03EHOC+vMx08ii3h
	 a3aPFnQDnQKJrVIqe432u2SURjza0oBj9HxDxyMCsdETOf3xK0PDfQrJie+8PJTLVxgGk
	 Qjbs6LAMcXsjpg2x73qMNpEcrTR3FdVY08RWqZiQoYYP2ntUqUZijttbvDbyBf3GCoWjU
	 WyYNLG/IKDnsXE0JwnHnp+rsFJ+AALPutOVlFTnPfux7wOJSrsTUTkDk43aEusPZMZQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795620202;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=TvwEC2ntouQNpB1/IQEn6ekme+suJRE9uPh16jhXX4k=;
	b=ASHktfjWnkzI7dxrdSyXRJiTNwiVcOaVND7vgLLDYNAD/kD8DKULHg9dAS3Zqu7ZJovH
	 8D4DbzLG7Rkkrwv02GSEpF54JYzmOC+19QcIbE1U79LSildaIuwVot+7aDMOd22lvx1T9
	 /01mX82QnZ2MhTTdwWhTGD6QpOLm2zNvEGJVqAqbw6OXZ7lduqDuEongJXiUbMpkkUxml
	 1WQDzALwkGSjg21lQzmCzGI+h3reW0VfZywSSMmWoiVWQF88haOLcgnZD2oIPofy1Ehb/
	 uNqkajQvOVYvz/83LowGzMlV1+rN+/ORRgS9A9qI3s/hRpMMTDQTZlVWykPenqiQM1A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Zq4wUO8f;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F95D606A31E;
	Wed, 25 Nov 2026 15:23:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Zq4wUO8f
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D9F191F000C0;
	Wed, 25 Nov 2026 15:23:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795620201;
	bh=TvwEC2ntouQNpB1/IQEn6ekme+suJRE9uPh16jhXX4k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Zq4wUO8fSOWwUu/HQQhGVVfZw4O+sQtFEe8Uehg8Swme3BPfvzgz/ovN9gEKP9W9z
	 G012xeIkEQN5XL0M8OQsEC3dQW8P/xY5CYsM68WF0wP0/A3Qzyf8sVZMSaLkHJ+zpa
	 KACESpATo1Y2TqShF45DCAl27kZs8DEg/3jSMmLg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wahid Khan <wahidzk0091@gmail.com>,
	Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 7.3 0797/1005] wifi: cfg80211: dont truncate the merged MBSSID profile length
Date: Wed, 25 Nov 2026 15:35:35 +0100
Message-ID: <20261125143840.406326841@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143821.729802100@linuxfoundation.org>
References: <20261125143821.729802100@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

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
@@ -2592,7 +2592,7 @@ cfg80211_parse_mbssid_data(struct wiphy
 		if (elem->data[0] < 1 || (int)elem->data[0] > 8)
 			continue;
 		for_each_element(sub, elem->data + 1, elem->datalen - 1) {
-			u8 profile_len;
+			size_t profile_len;
 
 			if (sub->id != 0 || sub->datalen < 4) {
 				/* not a valid BSS profile */


