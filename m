Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795705534;
	b=GIVuj9CzvIl/ExVvA90Ik0WqP4cNC2hjf2VncsC9iuCWUWj/C010WQjkeytbZBbkRget
	 zJfaSPEokesVnD6C3gnLvULD3KnOutXizo6KN6/vQ/mpub6LDSQLxcNzZSY48NFrjxr3x
	 rGHisQajxxJ5uQNRmY0k08GzbaIsDtzhnM8oCT5wLAQKN1edhfDEiVNcuFbRNo5kHZVme
	 R6aDYHAQzSjoCS4wTOsr0q5pcLYurU23pjVXxD48ycykkygLIFXcCpL8H+Vm5nvN24qO/
	 cyXS8ZmmvplOg1geHXG8RqHCZSLhkVBtKVyXeKpVzlK3gWf5868QBj4Skjp3wjKDbJA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795705534;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=kmvVy3b0hncVxkSS/LqgWlHdeySI2nTLzerY3WlEH1I=;
	b=xvnhD25tSf/gOsvt+owv2RvRlR28KHMavlXk0Jnrl58Mb/Qc8S5dbrWHkUtWphyDRYjm
	 AUJzTxyMmHQhPB9oYZGvQiGdYyqLvCkYsAqzPZc7PjdRTxiSyQi1RN2yuTbuG1EwhC4wt
	 eTe4mx7uGuWyhYJ8qEeGc3BOlaaA+AR7zD/EFiADaGDsSdN1cRUk4cRTzqYalloNOu8N3
	 5IK+b5ds56EyBIzngPnjRAfzqaesRVFLaaZCagteDjIvc+v6rcecgj5nlC5YY0DnZG8Tm
	 ef2la0iV+v5OkC5qTS2140Fbu5d7/dld6VgxCgRkHVWxxllbqyBnB+0U9y6C14g7CDQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=D2moO1SC;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EFDE1606A321;
	Thu, 26 Nov 2026 15:05:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=D2moO1SC
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C95891F000D4;
	Thu, 26 Nov 2026 15:05:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795705533;
	bh=kmvVy3b0hncVxkSS/LqgWlHdeySI2nTLzerY3WlEH1I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=D2moO1SCC54Qvwch87mHvhds3P2wlotcGAgWUY+GeEmJRBXRjerEonlB/w8Hm99RJ
	 Wazr4L0yzFeLAaLGU+XvXrXcu2u9chFvL2R0G2aib9+ZsRVCrlONUZKZoCz0cf27+p
	 UG1WIvFA/KnDypYfg40J0FFIMgp+s0OpuKY6EAd4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wahid Khan <wahidzk0091@gmail.com>,
	Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 5.15 231/319] wifi: cfg80211: dont truncate the merged MBSSID profile length
Date: Thu, 26 Nov 2026 15:39:59 +0100
Message-ID: <20261126144011.963248527@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261126144006.732901931@linuxfoundation.org>
References: <20261126144006.732901931@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
@@ -2241,7 +2241,7 @@ static void cfg80211_parse_mbssid_data(s
 		if (elem->data[0] < 1 || (int)elem->data[0] > 8)
 			continue;
 		for_each_element(sub, elem->data + 1, elem->datalen - 1) {
-			u8 profile_len;
+			size_t profile_len;
 
 			if (sub->id != 0 || sub->datalen < 4) {
 				/* not a valid BSS profile */


