Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795029218;
	b=jZDDoOwDrzFGiTmqk1E1nLeMJzy0ayJWDFu+QYQkyY3XeYni8v1Zh2Ns40hcSITFhNvQ
	 OX4V2g4FtIkKPTBW5ELke1UEzxugF5DfMFPyIElc8zpqJFSsOBVhACMLyH3d41mzkF7Ei
	 4pKJmOhvRvJQu5fcgnMrHztYAuK6sl5Wp8SBRjI48qyIcJzu5OtqW3gsFHF/4IJzq0eQU
	 v4r8p9rf6xHyqodYe7fDym2XmoX4kFw2zuhEmWILfTftxEBbRbHoEBo6KHP9e7xz/EPHL
	 4HUWo60pdrJaF6IO+66FwAC33n/vIp00VwRy/uFPE6XWgia51xJAJdHNF1a6nTVPsrQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795029218;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=qmI5VdsMae63zDGpwpEL0o1tQM8mWsKz11fOGhuZSa4=;
	b=mTd9TCFZb/mfm1s9gTUGFmCvtUXBGcOwE0cA/IiGTupTJikxfM6jhobMGcXN5/Eki6IJ
	 7ZS9eIJPcqmLA7qG3X8njvu2lf/tC0xpwNlw89ahd1UnMowLmWw7cW0X4S9VSxcAiSWR/
	 dwCz2uDTht1dAQpWq56HVpqAd5CzsM/v1qsIQj6R0z9UQMjqa1zIxXk/1mMclPAUKKQax
	 YXLwB3o4IrEd4kZ1XtYIHbRSwqd3I385deDZeqHvMx4+6Zt9giI0PGbvRFRBRcvXmH5jT
	 RAA5+51GqA/kcmssza12ab5GWfPRSb5SNyc2EUFus3+3DjhyGt8DQvT40TOQwClV79A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=nLF8JeCm;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 857DB606A31C;
	Wed, 18 Nov 2026 19:13:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=nLF8JeCm
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BED6E1F000C4;
	Wed, 18 Nov 2026 19:13:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795029218;
	bh=qmI5VdsMae63zDGpwpEL0o1tQM8mWsKz11fOGhuZSa4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=nLF8JeCmlcTYo/COgs+L01EubgSozI1Z5v2HAg1f04TKRblaxerv1WwEZAxt2CMLK
	 AKRn/gZqqrVMjOBL6k9bqw4Nq+0S5Dxq0PFOaIN2ZUEt7VTzQrCzMx/QrUJiRFCNc8
	 sm66IoPqXZQt1Ld/McU4V2DxOIhxjMOxeCju3XPw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0221/1756] wifi: mac80211: dont send encap offload frames unencrypted
Date: Wed, 18 Nov 2026 15:39:08 +0100
Message-ID: <20261118150017.095784337@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
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

[ Upstream commit a48daf145fed445d41ef422573411500785415c8 ]

For 802.11 frames, ieee80211_tx_h_select_key() drops a data frame
that ended up without a key if the station requires encryption, so
that traffic can never leak out unprotected. Encapsulation offload
erroneously didn't get this code path. Fix that.

Fixes: 50ff477a8639 ("mac80211: add 802.11 encapsulation offloading support")
Link: https://patch.msgid.link/20260802085818.1336616-7-johannes@sipsolutions.net
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/mac80211/tx.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index 2336786680e87..bcc3b16bc183e 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -599,6 +599,9 @@ ieee80211_select_key_8023(struct ieee80211_tx_data *tx)
 		tx->key = rcu_dereference(tx->sta->ptk[tx->sta->ptk_idx]);
 		if (!tx->key)
 			tx->key = rcu_dereference(tx->sdata->default_unicast_key);
+
+		if (!tx->key && test_sta_flag(tx->sta, WLAN_STA_USES_ENCRYPTION))
+			return TX_DROP;
 	} else if (!ieee80211_vif_is_mld(&tx->sdata->vif)) {
 		tx->key = rcu_dereference(tx->sdata->deflink.default_multicast_key);
 	}
-- 
2.53.0



