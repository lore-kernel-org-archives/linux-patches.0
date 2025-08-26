Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DEFF620DD51;
	Tue, 26 Aug 2025 14:36:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756219001; cv=none; b=ruRu9aQh0B6Dnxk58FKOH+wL+NOhMzDtIhCjduuItfoDGt87mXLbS1RrkNhHzFVQQT+W0wbgKMx/161onimybrPbrzQ7esxwZXZNiD1veXipB1dyc4KUYt3IycC7P5eLxarVB4iM6jWGbeIEjQNZTsRgxLYvOdCXdJmpkOsoI/o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756219001; c=relaxed/simple;
	bh=LP4vPknJyOKLlt/b1nH8s0W0BLPFl6pGWK4SVT/INz0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dozY3r0SEVkklEbruVK57HSBCMb+bugAI+F3fdT66rcYtYa6WghH3+4DsQ10kwny5doVDCbU+AYgjlCLA6t6zuE2nq4AZHDTlxpLN+HoYOmD5ndccAOsiFznI0R4GVL3I/LQW6IPflmTuMdoPQwbjcCMZt5r5Mvexq7nbO9Es/Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iybEHxAe; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iybEHxAe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6F1ADC4CEF1;
	Tue, 26 Aug 2025 14:36:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756219000;
	bh=LP4vPknJyOKLlt/b1nH8s0W0BLPFl6pGWK4SVT/INz0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iybEHxAeSYsQ5RNJ79WIN7reEqmZrFX/anuMWUc1bXFJivxCWxqfEC0s2ICk4JerW
	 wyTu0MSkPm2zE1oG36njvRN1k41W+sZVHcgn0zhuj+XcAJsQJlB08PmZPYwgRwIYs4
	 C9NNUsqM7TptcWBRsg4m+m0ic/5KCObRtLHFAT28=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ilan Peer <ilan.peer@intel.com>,
	Miri Korenblit <miriam.rachel.korenblit@intel.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 213/403] wifi: cfg80211: Fix interface type validation
Date: Tue, 26 Aug 2025 13:08:59 +0200
Message-ID: <20250826110912.723390281@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110905.607690791@linuxfoundation.org>
References: <20250826110905.607690791@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
index 2dfa3331604e..3a550544dd9f 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -433,7 +433,7 @@ ieee80211_get_sband_iftype_data(const struct ieee80211_supported_band *sband,
 {
 	int i;
 
-	if (WARN_ON(iftype >= NL80211_IFTYPE_MAX))
+	if (WARN_ON(iftype >= NUM_NL80211_IFTYPES))
 		return NULL;
 
 	if (iftype == NL80211_IFTYPE_AP_VLAN)
-- 
2.39.5



