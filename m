Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB6103375A8;
	Mon, 18 Aug 2025 13:28:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755523735; cv=none; b=JikKH/0DNWXusiJkHdyHiu8Dld6YiOJdbad0Xz9s2RdMegvVeIHyyawt4nGL5C9UKNrgTK/8pJeE5AnYO2B/Jm6NJGmYY7rf07WgHCKDUQD/DhunzYFjABZ+bEdoHZ+QOZEw/UkKZf0j4/IKwJkFCjcW3MgYwkGaLC9I7cYOSR0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755523735; c=relaxed/simple;
	bh=ZD9g4MewnSA1/AcwVK3UjvlGakWm1Dz0VA/JGnXxh7g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tE2wml2x+l6d7bmdOuKwR09bnwd79VOUNPJsw8XO96r98Y+2V4JccXNk97HMuqJ7pQzcvhAFL2+OPpfaWzX2lGAWPrw8My62Yihzi/dUU3FzKWzI8Di22Qb0QLKtOHwJQMHUNh2Ih+qjHfSfu52qRSyErzif8JrQZ56iLopBueg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=x/Qdqtz8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="x/Qdqtz8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3B643C4CEF1;
	Mon, 18 Aug 2025 13:28:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755523735;
	bh=ZD9g4MewnSA1/AcwVK3UjvlGakWm1Dz0VA/JGnXxh7g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=x/Qdqtz8CnOmekk4dasOE+StpgFwL2ncQMYJrozpCaB8maQe5kz898p+go1/tfRAq
	 oiY/jvyX4PWJBikg+x2JpOGYkFEZOwMA5pwak9+RU123P8RtaRRvUp+NqWxy+2M2yF
	 l8EeM87wsec6N86xqM+tjDi3wKot8RlA/tOZyUec=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ilan Peer <ilan.peer@intel.com>,
	Miri Korenblit <miriam.rachel.korenblit@intel.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 226/515] wifi: cfg80211: Fix interface type validation
Date: Mon, 18 Aug 2025 14:43:32 +0200
Message-ID: <20250818124507.068543527@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250818124458.334548733@linuxfoundation.org>
References: <20250818124458.334548733@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

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
index 75f2e5782887..71db571617ba 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -633,7 +633,7 @@ ieee80211_get_sband_iftype_data(const struct ieee80211_supported_band *sband,
 	const struct ieee80211_sband_iftype_data *data;
 	int i;
 
-	if (WARN_ON(iftype >= NL80211_IFTYPE_MAX))
+	if (WARN_ON(iftype >= NUM_NL80211_IFTYPES))
 		return NULL;
 
 	if (iftype == NL80211_IFTYPE_AP_VLAN)
-- 
2.39.5



