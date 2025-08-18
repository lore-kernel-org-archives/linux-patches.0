Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B7D8012DDA1;
	Mon, 18 Aug 2025 13:02:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755522124; cv=none; b=ntxKl46tYsm3pC9SfovSTeXykoQEyII1Z/og29DuOBRSAH2KjstwZZCw1+1AnxLPwbduy3Qze9yZZcDHGAgoSc5aqExyaxD7y4CYodZg0x9zDUCpfhrub417KpwL52eb/NRUKveLka9YjJPyoLL2X5gVqZbtzRBgUoREYPhNOVk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755522124; c=relaxed/simple;
	bh=R8Ydotsb7SvMMtGFR0vLQ2SYBLClxlKPBv7WBR3pCws=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EhcQkim5caa7HLr0FyVqCrlMFfwutvUeK8wxL0asEo8+S140qRqA6tZt4+Vq3/ws/zdKMimohtdsqy9zf7waCmE28esVv/zIqjnzgVXmvUHoXGUXpd8Qwsmjx01fKN147Dn+4u3/GL9/ho4oeBzPlLOg2NcneIxoFUKJuD5XazU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PDXwMdal; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PDXwMdal"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B9506C4CEEB;
	Mon, 18 Aug 2025 13:02:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755522124;
	bh=R8Ydotsb7SvMMtGFR0vLQ2SYBLClxlKPBv7WBR3pCws=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PDXwMdalcRoG7kP0p4jUVsJVk07YQvo2GSfKnXfMiXFrALyBjDAOLJXsWDhsAulZB
	 FlYNK5R6e6lLQDZn1ZTB4FSx+qRAPfFsBEOs5aB+TgteEgghWREFcyO413qWBq1n9z
	 wZlEFS9OIEaHHGIarXJ8Ro9Fadji6d0Kwt0nUdck=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ilan Peer <ilan.peer@intel.com>,
	Miri Korenblit <miriam.rachel.korenblit@intel.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 189/444] wifi: cfg80211: Fix interface type validation
Date: Mon, 18 Aug 2025 14:43:35 +0200
Message-ID: <20250818124455.955453042@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250818124448.879659024@linuxfoundation.org>
References: <20250818124448.879659024@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index bb1862536f9c..c555d9964702 100644
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



