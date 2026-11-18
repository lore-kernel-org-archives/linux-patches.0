Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795019341;
	b=kDf6iZHf3DdanQS6g0GoYQzG35gPsRTjcI9Mycw8OnajazWa0LktQQ/jQszuhWVliJsQ
	 sBNUocRu4Dixbe7CoLKoFuHJgP4k9eYEOgWSyq3A9OEhFCOleY3oWoE77L7xyxJTi5ln6
	 aiXO0isPqGlPGNNXvvavHcjO3Rl5QyyKeKg9BJQbW11LpmyJpNKQkCAeXPl6WmC9He2tl
	 6X1gtYx+u9IYESzQYdOx+GbXcgfIxYInT/0dtpiUZumweywI0QtOSIq05I0AFlYmJXsoh
	 9tEAFRS0nELgJ5hjsCUIf/DDlTbxgiNGnpxaaZ7IuszNuOW9OSm4D9r7idcniLFBMtw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795019341;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Cq4p/NvocinL2vmnDGf7csFzKI+JXWeGlPfSiqGd6Mc=;
	b=R/2ec1UylIT2JbamB642y9VfUfiGa1KpcLSCi485b9VX8rsx8H07iMHI8Vgf5cAyNcEC
	 TlS2wqNByYui8eAbooDlhBj5Sv0DK0TkrvEaHIIVBPwfvJ1eP8OX6RNoheUjU0Ft8XzuE
	 uuJV3v5PwKeMwBHYtpWJK8qq24tRxfayq6aNOfDQlmj44Y4bMoqfs1TGlPvxJqDoRvtCt
	 Jle6CIxUTn2EF+Rkel4z+I2DWCjO/uuX2h1PPSG9x2BxdtD1Tezk2Vh2Gvm1P90bzyMfE
	 BqjwLAB9AsVn6rPzL0t6+Xg8/lq37xDY9kJiYd0PKeKZlw1ogExvuNOBqmJWgzlSErw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=laCLyd+X;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3892D60A260B;
	Wed, 18 Nov 2026 16:29:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=laCLyd+X
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 81CE91F000C5;
	Wed, 18 Nov 2026 16:29:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795019340;
	bh=Cq4p/NvocinL2vmnDGf7csFzKI+JXWeGlPfSiqGd6Mc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=laCLyd+XatKxaoXiafsdyNTD/KOuJzsG/lCrS5BT4swE2f0IcKQpjBXaXCQvjyyto
	 M2RB/8y1qA5ZRZ2DnWLWuEs1mWMDokuDXgZKwawAR6LVndaR5SuE6iDemlptuc1Jik
	 SmOLPQr8/rC7Y4o5ygQKMZDDk37eZMU4WbsHTx3s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aloka Dixit <aloka.dixit@oss.qualcomm.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1560/2651] wifi: mac80211: remove redundant null check in ieee80211_assign_beacon()
Date: Wed, 18 Nov 2026 15:46:40 +0100
Message-ID: <20261118150344.114687412@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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

From: Aloka Dixit <aloka.dixit@oss.qualcomm.com>

[ Upstream commit 229cf0621950919c38a271ab3c07dfd41dd301d0 ]

The else-if branch condition 'old && old->mbssid_ies' already
guarantees 'old' is non-NULL. The inner 'old &&' in
'if (old && old->rnr_ies)' is therefore redundant; remove it.

Signed-off-by: Aloka Dixit <aloka.dixit@oss.qualcomm.com>
Link: https://patch.msgid.link/20261002-csa_cca_fix-v1-2-b83a998aeb44@oss.qualcomm.com
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Stable-dep-of: baf0d4feed2f ("wifi: mac80211: fix mbssid/rnr allocation in beacon data")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/mac80211/cfg.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index e86255b4721d1..bfdfc018a185d 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -1514,7 +1514,7 @@ ieee80211_assign_beacon(struct ieee80211_sub_if_data *sdata,
 	} else if (old && old->mbssid_ies) {
 		mbssid = old->mbssid_ies;
 		size += struct_size(new->mbssid_ies, elem, mbssid->cnt);
-		if (old && old->rnr_ies) {
+		if (old->rnr_ies) {
 			rnr = old->rnr_ies;
 			size += struct_size(new->rnr_ies, elem, rnr->cnt);
 		}
-- 
2.53.0



