Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793214598;
	b=EqqlbecTU815ZvEPmR4Dq/GcSkv+K2EeqyptndO2SkZZcuFXxZA/Cm11Varq3a9jsOUd
	 K07zqHdIpRqETM/e+QKB4s1SfvNUzRaH4e0Wdlfn4m+ijVweaY9NStxfjW52XZp/e2piH
	 MAs74yPZM7A5+ZzQqbXVykYs6sHzDnd0kGbSwWQAbKmG38IaZ1uIM1VsT7xbSl1KKp1Qf
	 gfAyShSVzyfGOpejRVR6FMv9JVV+NINkCFhHIDbjLEOj7co+TCyOxDux7o7ApB3d9Alaa
	 P1coqNAsLRRjPNRM7tkMb4vCPdJbhG33Abbr7qgblTK+eAo3ZfT6LVSrPbzMVoAANog==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793214598;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=qD6Z4ZQHa/4RI3yVwBV0Fu1Ebm0w09NhjbymFEkdrgM=;
	b=sF35W/WFPzL0QGCL1JarOi16lmO0D/RjODWjSyVDtkbtmy5Z2UlAbjwfdoZtSd+LPKOP
	 AlmCHvT7Vbc5aCrM4Wk9DBaDcT/P+d5H2IxYQtNBc1ykgBs4ogSOqwkTfijU+uiwdGMAV
	 sshyIPqKd/d61ZBIw8EX3l6KhcVnYEyRQgCu8mMC/BsA0MVq6HL7nyHhl+tW43RFbC9an
	 +HPvOxI1DDxqAMkaHrqRTdjk5i97TTbsiqJFQiMTOLE8LUcDwxIW3sYlK4Q1RUhkofQdI
	 uzOue8nXHL0mHw1so+D2pkBEePcVGtbjjzFHI9AkvAVbCSY3/8rNOXSLP/s5xlHCb7g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=iZgU31JP;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 889FB606A32E;
	Wed, 28 Oct 2026 19:09:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=iZgU31JP
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DAC3A1F01829;
	Wed, 28 Oct 2026 19:09:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793214598;
	bh=qD6Z4ZQHa/4RI3yVwBV0Fu1Ebm0w09NhjbymFEkdrgM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=iZgU31JP+lNkCDzXYuImfL5a47eFOh5u+qb1Y6Kao7EZrKFRT7nmPgVOVsgh2NQQj
	 Rd7Wv3+FZSOeMMVTBw5yKrLlqUqOhPBVTI14bNf2rYRmXDA350C50ZxTwfgme3G+Ab
	 kaUBwMMr9zRRwaWYq9Vljb9U6mLF/BBqxFzNyeek=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+639af5aa411f2581ad38@syzkaller.appspotmail.com,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0916/1887] wifi: mac80211: dont WARN for connections on invalid channels
Date: Wed, 28 Oct 2026 17:50:12 +0100
Message-ID: <20261028170520.258385289@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
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

From: Johannes Berg <johannes.berg@intel.com>

[ Upstream commit 99067b58a408a384d2a45c105eb3dce980a862ce ]

It's not clear (to me) how exactly syzbot managed to hit this,
but it seems conceivable that e.g. regulatory changed and has
disabled a channel between scanning (channel is checked to be
usable by cfg80211_get_ies_channel_number) and connecting on
the channel later.

With one scenario that isn't covered elsewhere described above,
the warning isn't good, replace it with a (more informative)
error message.

Reported-by: syzbot+639af5aa411f2581ad38@syzkaller.appspotmail.com
Link: https://patch.msgid.link/20251202102511.5a8fb5184fa3.I961ee41b8f10538a54b8565dbf03ec1696e80e03@changeid
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/mac80211/mlme.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index 56120762c7fbf..05c7eda181968 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -452,7 +452,10 @@ ieee80211_determine_chantype(struct ieee80211_sub_if_data *sdata,
 	while (!cfg80211_chandef_usable(sdata->local->hw.wiphy, chandef,
 					tracking ? 0 :
 						   IEEE80211_CHAN_DISABLED)) {
-		if (WARN_ON(chandef->width == NL80211_CHAN_WIDTH_20_NOHT)) {
+		if (chandef->width == NL80211_CHAN_WIDTH_20_NOHT) {
+			sdata_info(sdata,
+				   "unusable channel (%d MHz) for connection\n",
+				   chandef->chan->center_freq);
 			ret = IEEE80211_CONN_DISABLE_HT |
 			      IEEE80211_CONN_DISABLE_VHT |
 			      IEEE80211_CONN_DISABLE_HE |
-- 
2.53.0



