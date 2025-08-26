Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B2BBD2C0F60;
	Tue, 26 Aug 2025 14:17:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756217873; cv=none; b=P8WpPHmTagLIllWPddObWRRaq+QMOoW5BnnpSUJAsRRGapTcbh8KCsF+y6ow7F3+4x19upfmNJ8G2uZJAwMS6LZ7ZjypuftiEFzt0AyQGThjLapWMrUYLUf7vWa+qqyFWWi0Ch4Y0vqUIUT2dn1f+dV9PDD8gVEAOjtzg+Yv7S8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756217873; c=relaxed/simple;
	bh=VxKiKrYxITYl9BtrrVRN9HNuMhfxvSZkWyhweiJHMJw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ffh2SPAPFIET7Hz7hM+avfgNZ4xdGwk5vsUC5heLzjYjayZSQ8T4Vs1q74CMlL8r00NaMKnRe1ldHH86Ce4Ms0d///v2T0fmhMmZLVVR6eh/r5FX8LaPtqwDNBB+bI9A8o+CI+Gjtt454XELEPjBgaeARzuevLhfQcrkNnsAqaI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rboIEebl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rboIEebl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 36BF1C4CEF1;
	Tue, 26 Aug 2025 14:17:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756217873;
	bh=VxKiKrYxITYl9BtrrVRN9HNuMhfxvSZkWyhweiJHMJw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rboIEeblu1U1S3Rq1XrrnjQFqFadabjBr3n+7qSROViDKU6UiJ5ndDna0b1h9oEN8
	 P6ifSCb+oPaNaNxttcgaTjd5pRZ29IpVbV6nHYzSgnvKN2QviYmsVdsk5z4eSKC1UQ
	 GunUf9/k5ht4Fzhr6FK+qgbeEWJJks6a6JGTo4+Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ilan Peer <ilan.peer@intel.com>,
	Miri Korenblit <miriam.rachel.korenblit@intel.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 266/523] wifi: cfg80211: Fix interface type validation
Date: Tue, 26 Aug 2025 13:07:56 +0200
Message-ID: <20250826110930.987256760@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110924.562212281@linuxfoundation.org>
References: <20250826110924.562212281@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ilan Peer <ilan.peer@intel.com>

[ Upstream commit 14450be2332a49445106403492a367412b8c23f4 ]

Fix a condition that verified valid values of interface types.

Signed-off-by: Ilan Peer <ilan.peer@intel.com>
Signed-off-by: Miri Korenblit <miriam.rachel.korenblit@intel.com>
Link: https://patch.msgid.link/20250709233537.7ad199ca5939.I0ac1ff74798bf59a87a57f2e18f2153c308b119b@changeid
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/cfg80211.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index 4536a122c4bc..5595c2a94939 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -510,7 +510,7 @@ ieee80211_get_sband_iftype_data(const struct ieee80211_supported_band *sband,
 {
 	int i;
 
-	if (WARN_ON(iftype >= NL80211_IFTYPE_MAX))
+	if (WARN_ON(iftype >= NUM_NL80211_IFTYPES))
 		return NULL;
 
 	if (iftype == NL80211_IFTYPE_AP_VLAN)
-- 
2.39.5



