Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795704650;
	b=YGrOSiJbyEQWAj/y5oVL2dY4ywf8rLHKcy7zaiWcBvkfc7iFqodaBsZOrfbMCwRSs7Q3
	 qznX23iNzkKnkQ7BRrNUrI5Mvfcxcl92H/ufSy2LuvIUZXXiXW7uxbiNMmSYremrRKDdt
	 gFcVfNDWEeaKnLsWGxkaJTHbCLh3NP90BxWe/7ADmgGuzRsR2eZEEXncdRJM+25kWsfhW
	 XQIdMwM1e04qh/B1/0BNVzlra5ra/FHLePyA8fur+4mbWXPbM8QVlXECaR5TsHiV8nQsj
	 O0713ZUVgmaQ9NEq98Vn3oGuQ3Wx+PE+NfBTeo/Pj1JYoDI76fYD/qkkWhM4uLeH6tQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795704650;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=uBmoPFuMmmhLAS44whSl7fU/T1qBHLxTohmj/GTyAW0=;
	b=mALpvc68Do23cNJp1AxksylRoC01E0BucjTlXDdNevj62ihXTQZ+d9NVEH26tr596VKN
	 lpPq4CM6sNaRMZiOxETbB9QneChuGAFmzpjxy2HsDrBQ/k9tMnEBWIPKxhvSJTuXTpgiK
	 MN6MY5PuxzempXm/fuf1RiTYTdJqZRt6mp33VKTeUs39WF6gjDMxdwaYEcu+OrhF4IwpB
	 EgW3PLZjhXDayi7Cz9fjgtZ2OEjOcSY/A07Ir5TreYunEiurNi2ciYs/Opv3IU9ep1esj
	 dkoWGunyuKbhsdM9v/3L/D+ZP5tZlHj2RcnnjzeTSnq4mP+njX6oCJYT97U5muOwxsg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=VJot4WB2;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EAC10606A32A;
	Thu, 26 Nov 2026 14:50:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=VJot4WB2
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 235541F000D2;
	Thu, 26 Nov 2026 14:50:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795704649;
	bh=uBmoPFuMmmhLAS44whSl7fU/T1qBHLxTohmj/GTyAW0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=VJot4WB26KbdbyIGgyxswOm06RmoBCjo4ipl1X9Ecwx++CNXiFfAfteoX3dwWZJ+F
	 cNy/ErXcRjv8ndatkEh7S3zAaEg627nLZQeYt/uCHArWYdpqtegYQeNp+wYuLIBZRg
	 g3DHvdpL65MVRHImSv8T+Fv8qw9ZfGNFsCON5FsA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wahid Khan <wahidzk0091@gmail.com>,
	Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 5.10 190/265] wifi: cfg80211: dont truncate the merged MBSSID profile length
Date: Thu, 26 Nov 2026 15:38:40 +0100
Message-ID: <20261126143618.482443668@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261126143605.076581697@linuxfoundation.org>
References: <20261126143605.076581697@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
@@ -2236,7 +2236,7 @@ static void cfg80211_parse_mbssid_data(s
 		if (elem->data[0] < 1 || (int)elem->data[0] > 8)
 			continue;
 		for_each_element(sub, elem->data + 1, elem->datalen - 1) {
-			u8 profile_len;
+			size_t profile_len;
 
 			if (sub->id != 0 || sub->datalen < 4) {
 				/* not a valid BSS profile */


