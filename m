Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DCAB043E08C;
	Thu, 30 Jul 2026 14:22:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785421322; cv=none; b=jvSBb3cQVjprvsMvWRq1ucrhmIVjjeC0Xbk+yZIwBG/Dlb0Dh++bsiQutKGZ3PR51lgN8FuuiH+cQq1DvjnWrsoWFTaML5QF8apaFSAc2xq09zE+13GlKwDZUTuNbcqWTLi+Ayi7p98i0dg7SA9JFowDrrz+Xy5E2NwxIBYX0Dk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785421322; c=relaxed/simple;
	bh=nSky7C/iQbPmStt0zFZjs3z8fDIUwtWiJLBTYNMbqxY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RnbJF/gNlCNJeQoAVmhlyXNT73bibVTjNcyRp15P505oLgsdud7kBoPDN128Ghm2ubF3Q855haCBMS3cctf/eWriRR8odmxKOLTwFjRJZ1KtrLHGs/Y0HOHNE/cNj901uQgzfBM0W+B0qT5Idsm2PG+pM6/OV7fZ8FL8bPV/CP8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=T0PvXJKM; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="T0PvXJKM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 35F521F000E9;
	Thu, 30 Jul 2026 14:22:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785421320;
	bh=JwiofZ3JOjY35ApKihY6sJAZFdpsOOtRgZb1eoh6eTo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=T0PvXJKMhSMsxxrypZT0LRhi/yEtW/+5TKE46fBT8Q7rrkIDpvB3ZcntE4Rb6OZau
	 NItzN+BxkkdNJGX/O5qoRfcl2r6ecwDYqHVAHZiTgkN6nxizHpwd6/C3la+HDRV84m
	 p4LeBaBZYSlK4HdBT+1RtAyWqFGiVPXlFV+ABnbA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhao Li <enderaoelyther@gmail.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 063/744] wifi: nl80211: constrain MBSSID TX link ID range
Date: Thu, 30 Jul 2026 16:05:36 +0200
Message-ID: <20260730141445.617524341@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141444.267951807@linuxfoundation.org>
References: <20260730141444.267951807@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zhao Li <enderaoelyther@gmail.com>

[ Upstream commit 172f06023669f0a96d32511669ff45c600731380 ]

MBSSID transmitted-profile link IDs are valid only in the range
0..IEEE80211_MLD_MAX_NUM_LINKS - 1. Constrain the nl80211 policy to
reject out-of-range values during attribute validation.

Fixes: 37523c3c47b3 ("wifi: nl80211: add link id of transmitted profile for MLO MBSSID")
Assisted-by: Codex:gpt-5.5
Assisted-by: Claude:claude-opus-4.8
Signed-off-by: Zhao Li <enderaoelyther@gmail.com>
Link: https://patch.msgid.link/20260612131854.43575-4-enderaoelyther@gmail.com
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/wireless/nl80211.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index 264ae4e742a1c4..3024fa8dd78021 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -616,7 +616,7 @@ nl80211_mbssid_config_policy[NL80211_MBSSID_CONFIG_ATTR_MAX + 1] = {
 	[NL80211_MBSSID_CONFIG_ATTR_TX_IFINDEX] = { .type = NLA_U32 },
 	[NL80211_MBSSID_CONFIG_ATTR_EMA] = { .type = NLA_FLAG },
 	[NL80211_MBSSID_CONFIG_ATTR_TX_LINK_ID] =
-		NLA_POLICY_MAX(NLA_U8, IEEE80211_MLD_MAX_NUM_LINKS),
+		NLA_POLICY_RANGE(NLA_U8, 0, IEEE80211_MLD_MAX_NUM_LINKS - 1),
 };
 
 static const struct nla_policy
-- 
2.53.0



