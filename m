Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795049119;
	b=ExjuN1V2nniPholqMZRcJG0qUAejWQk7w9Xwsv7kxVEcfDKrc1Igi7O1PsESHw/gbDh1
	 gDoDEKBVzq3rNhvIa1R7CyQ+51lpfXZJg/HclG8Z055ziF4S2doGkmEzRENy96I4U3MNo
	 1VZ4tcT1/t6so80ETkVqpMGLM3UGkFy6Oi08+2pRB9A43D+qQL19QXcx8LXjdc8z8ihBf
	 cbsIpa519UXh1HeOlIkuzod0zvJggEDbWlhBepBdGV1nrKzCYhQ7IlAeVvqrKmoENUr5u
	 yHZY+XgWSXPg96rMHCt48teeYZUawpA14UXbdqRiZsHnq9vLhZ58wF7c6oxPZ8ul5jA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795049119;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=rfOiAHHp6Vxbflx5SugTGcoIJ7f/uJYYdiX9mbS3o3k=;
	b=UGi+cDEmWWEq9LmyWwm0c4lauoNOCpK2TdAHqi6MEFRY7R+ErcoCBTf1sSdduYr5V3Jm
	 scidOQyfyBvSb52Gew5TG9RZdyOF3QBhqC+3xpGUA9rtznLUBA8ZUoutXdsFpEIfPmZcS
	 famdTs9M9mK4x05oqMfstFJN7I8mri0yij3mO0CEpafCaWfzgOmv3htAqd9BIaXMpIvW+
	 TUi9KBEnqgjvWQCJRWyFYBGa10DAir5XD/x7Y29yoC8UCW0nTLdGFHJAgUmACfpewbRCx
	 9jolStxyMLwD5G/hCyginkhWWCshksq6w5BjCmXtpe1hXBDeLMkc+AQzvFsFZ8D1/7Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Wa4wj45z;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D386D606A325;
	Thu, 19 Nov 2026 00:45:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Wa4wj45z
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 381A41F000C4;
	Thu, 19 Nov 2026 00:45:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795049119;
	bh=rfOiAHHp6Vxbflx5SugTGcoIJ7f/uJYYdiX9mbS3o3k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Wa4wj45za0itiAdRgVRmPni2wsRz9fIDJptecvJTwkV2DfKd0uh8i9Ybj1t4bVe3Q
	 72UdKcHGJQNEeO/P5HRWsOSPDYmkQs0LQHuDQCg8yCIqY762F0QFpqQcZKfLrp9Gwi
	 7OgPBURDOAizeUdwdcYAXNZOQq5DrMtHrlHi2+OI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aloka Dixit <aloka.dixit@oss.qualcomm.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 2239/2857] Revert "wifi: mac80211: do not use old MBSSID elements"
Date: Wed, 18 Nov 2026 15:54:33 +0100
Message-ID: <20261118150322.058947019@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Aloka Dixit <aloka.dixit@oss.qualcomm.com>

[ Upstream commit 56fb2334c86cef0b6d44099a6b21de4c8d80a7cb ]

Commit a519be2f5d95 ("wifi: mac80211: do not use old MBSSID
elements") fixed the incorrect inclusion of stopped/removed
non-transmitted profiles from the Beacon frames, but it caused
a regression for channel switch (CSA) and BSS color change (CCA)
operations initiated from hostapd.

Hostapd passes two Beacon templates to kernel for CSA and CCA -
(1) beacon_csa/beacon_color_change used during the countdown.
(2) beacon_after/beacon_next used after the countdown completes.
Hostapd relies on the kernel to include the old MBSSID elements
while sending beacon_csa/beacon_color_change templates to the
driver.

This path is now broken and results in CSA/CCA failure.

Including existing MBSSID elements explicitly makes the netlink
buffer larger than default 4 KB depending on the number of APs
which would need unnecessary complication to pre-calculate the
buffer length.

Revert the commit to fix the regression.

Regarding the original issue fixed by the reverted commit -
Hostapd now has a new commit which always includes at least one
MBSSID element when the feature is enabled, hence when all
non-transmitted profiles are removed, this empty element ensures
that stopped profiles are not advertised.

Fixes: a519be2f5d95 ("wifi: mac80211: do not use old MBSSID elements")
Signed-off-by: Aloka Dixit <aloka.dixit@oss.qualcomm.com>
Link: https://patch.msgid.link/20261002-csa_cca_fix-v1-1-b83a998aeb44@oss.qualcomm.com
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/mac80211/cfg.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index 10df0b81a878d..16bd28290ae68 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -1144,6 +1144,7 @@ static int ieee80211_assign_beacon(struct ieee80211_sub_if_data *sdata,
 
 	size = sizeof(*new) + new_head_len + new_tail_len;
 
+	/* new or old multiple BSSID elements? */
 	if (params->mbssid_ies) {
 		mbssid = params->mbssid_ies;
 		size += struct_size(new->mbssid_ies, elem, mbssid->cnt);
@@ -1153,6 +1154,15 @@ static int ieee80211_assign_beacon(struct ieee80211_sub_if_data *sdata,
 		}
 		size += ieee80211_get_mbssid_beacon_len(mbssid, rnr,
 							mbssid->cnt);
+	} else if (old && old->mbssid_ies) {
+		mbssid = old->mbssid_ies;
+		size += struct_size(new->mbssid_ies, elem, mbssid->cnt);
+		if (old && old->rnr_ies) {
+			rnr = old->rnr_ies;
+			size += struct_size(new->rnr_ies, elem, rnr->cnt);
+		}
+		size += ieee80211_get_mbssid_beacon_len(mbssid, rnr,
+							mbssid->cnt);
 	}
 
 	new = kzalloc(size, GFP_KERNEL);
-- 
2.53.0



