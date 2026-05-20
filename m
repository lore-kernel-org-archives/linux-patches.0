Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4738C35C1A0;
	Wed, 20 May 2026 17:18:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779297520; cv=none; b=QhToNiXUnR8pydixyvBsFM/Pmb3RZX9pO5ZZkaUxJahINoOR7R7KHApS3RHy8qduj6STrgGnOkFnhyHfLGhm5oJ9Vxs25hKa7dd2QMXwV1kJ3Erour8OIh/sNRjsTz7HpWPzcn2GnAaqKN7vXAQoP71KcunajdWNsN8yoL60y28=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779297520; c=relaxed/simple;
	bh=eJAp1Ne5v+LqdAf6ZnKJ+2Mrrd4AN44sKDEyryypkeg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=NkvvCMvn90lgd1qiQmODg0mKPg+T9rB/t+R9HNw5N2HboxRDETviNXbD4+YZovLuChtCauSoTnEgRIAW07LCKSgMRlwcwOdbt1sYu+SRxCNVjARRFPX1cW+iNIgHyt+ieqHYT3kID5vECDAQ/akpaQZJSuixPjj6YxvoAGQ63hE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gOX5oFYY; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gOX5oFYY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ADF9E1F000E9;
	Wed, 20 May 2026 17:18:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779297519;
	bh=pJvi2r178JHcgeYs9nC9Z7Rh/cSQLVI6Fp+fjDSgzck=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gOX5oFYYTNaIYQf1kNtT6Wb/vNSy5R2iSR/m/8nFHn3tAvCi7hNSqAGa9j1PVr0eU
	 5klgibZSfzJZu7QmBsGZen4zDBC7+Tp8vy0JPtofIQvlojJQqNONxOTiswJdOtK2ok
	 gctU8C3lQJva9DhtPxXQ9FxzYfc+SFJ0dOHBb1GE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shayne Chen <shayne.chen@mediatek.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 062/957] wifi: ieee80211: fix definition of EHT-MCS 15 in MRU
Date: Wed, 20 May 2026 18:09:05 +0200
Message-ID: <20260520162135.909202789@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162134.554764788@linuxfoundation.org>
References: <20260520162134.554764788@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Shayne Chen <shayne.chen@mediatek.com>

[ Upstream commit cb0caadb64ca0894c4a24e1a34841f260d462f90 ]

According to the definition in IEEE Std 802.11be-2024, Table 9-417r, each
bit indicates support for the transmission and reception of EHT-MCS 15 in:
- B0: 52+26-tone and 106+26-tone MRUs.
- B1: a 484+242-tone MRU if 80 MHz is supported.
- B2: a 996+484-tone MRU and a 996+484+242-tone MRU if 160 MHz is
      supported.
- B3: a 3×996-tone MRU if 320 MHz is supported.

Fixes: 6239da18d2f9 ("wifi: mac80211: adjust EHT capa when lowering bandwidth")
Signed-off-by: Shayne Chen <shayne.chen@mediatek.com>
Link: https://patch.msgid.link/20260313062150.3165433-1-shayne.chen@mediatek.com
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/ieee80211-eht.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/include/linux/ieee80211-eht.h b/include/linux/ieee80211-eht.h
index f9782e46c5e52..cd9abf5193966 100644
--- a/include/linux/ieee80211-eht.h
+++ b/include/linux/ieee80211-eht.h
@@ -251,8 +251,8 @@ struct ieee80211_eht_operation_info {
 #define IEEE80211_EHT_PHY_CAP5_SUPP_EXTRA_EHT_LTF		0x40
 #define IEEE80211_EHT_PHY_CAP6_MAX_NUM_SUPP_EHT_LTF_MASK	0x07
 
-#define IEEE80211_EHT_PHY_CAP6_MCS15_SUPP_80MHZ			0x08
-#define IEEE80211_EHT_PHY_CAP6_MCS15_SUPP_160MHZ		0x30
+#define IEEE80211_EHT_PHY_CAP6_MCS15_SUPP_80MHZ			0x10
+#define IEEE80211_EHT_PHY_CAP6_MCS15_SUPP_160MHZ		0x20
 #define IEEE80211_EHT_PHY_CAP6_MCS15_SUPP_320MHZ		0x40
 #define IEEE80211_EHT_PHY_CAP6_MCS15_SUPP_MASK			0x78
 #define IEEE80211_EHT_PHY_CAP6_EHT_DUP_6GHZ_SUPP		0x80
-- 
2.53.0



