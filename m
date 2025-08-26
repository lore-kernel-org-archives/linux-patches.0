Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 706A4393DCA;
	Tue, 26 Aug 2025 13:20:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756214406; cv=none; b=hdDuIrfFZmhvzEon+uxl7QJaS4Z3z63AmKYlPnverXJko1UMa/3jfo4AuQxWuv8gtb/2aXqS68jXJm3ML8HV8GP2b0ZehFSLqjtkzWSawDFBJANPLVRGEIzglUtAA2FEIzxrMGCxIaPaExPZvg2jybouD8i0S0h6bnGYcw8kd5I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756214406; c=relaxed/simple;
	bh=C5Wt+A7P046nxzpYgvqY+Bokox2q18Z8nK6zUiIm0mU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Mks+3gsKkj26fkDtjuuDS7wAtlFqyN3Qem7HmThwT5JLCyuHixJ+CDyPDPmVTkuryqIks/UF7OHAeam9oSHIaISdRScZQBCb+FBhidu6aITVGjj3mVYA79+ww0kiAsQRh8Ar0VpKrFOMBrtjUxeYLl+f34HN2J2eqfsdUjypQ8U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=v+v8psD/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="v+v8psD/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9D25EC4CEF1;
	Tue, 26 Aug 2025 13:20:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756214406;
	bh=C5Wt+A7P046nxzpYgvqY+Bokox2q18Z8nK6zUiIm0mU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=v+v8psD/AS/4s/upVYDV8lE0zd+GpPfBjkmyyOUGmX09dUOG/lECbklQbFUbgdPFb
	 3XswH/GA6QI/mpbG9Z4N2nLcRZe3wU6gYpUBdRgAqUBki9EZ9RbrQn8XwJctSiuehB
	 n8GFr59Gp0U88dOq+6/NDUoOEPPvpS7umSdCoFGg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ilan Peer <ilan.peer@intel.com>,
	Miri Korenblit <miriam.rachel.korenblit@intel.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 126/482] wifi: cfg80211: Fix interface type validation
Date: Tue, 26 Aug 2025 13:06:19 +0200
Message-ID: <20250826110933.933948359@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110930.769259449@linuxfoundation.org>
References: <20250826110930.769259449@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 2a0fc4a64af1..e35bc5c35732 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -559,7 +559,7 @@ ieee80211_get_sband_iftype_data(const struct ieee80211_supported_band *sband,
 {
 	int i;
 
-	if (WARN_ON(iftype >= NL80211_IFTYPE_MAX))
+	if (WARN_ON(iftype >= NUM_NL80211_IFTYPES))
 		return NULL;
 
 	if (iftype == NL80211_IFTYPE_AP_VLAN)
-- 
2.39.5



