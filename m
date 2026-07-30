Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C276029DB6C;
	Thu, 30 Jul 2026 15:00:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785423641; cv=none; b=FL72WxGRgmfSilzDKKZscwsoIzC0S3Em9eKic2mBwYDXbpSOEXs2lu6KaaE4L1svvVc5DCit3K+wTA0mgAcWOPGqsrjfonqmXEXbGZ7r+K+WLJNCJoKVZrGuelJGGqV4UV3AEcHrLEvYfieqBr56xc6vXpxnHj3K6tD+Wq6kTPY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785423641; c=relaxed/simple;
	bh=ASMy+lJn0zJ7PNNr5iPBOLrRg/SK43RD1M7y0jOjvMo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rbI5MVGaU1Jy1BCEkyu5n5u2QKhzHYEAScYTrEVNGlWh/h0uWgVB9OZDe8KGcZGgNcSvHeFEmh4lyZSWNrHdCqlg0JYTSLs5feTNExvKwAQRWn8N4TRuc7k3RsgzuCvdNncJ6ZWAn/07OK+d1zNTDCQ2AlQUonwpgvaNn4fGvCs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=byWCCYGD; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="byWCCYGD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 28D5B1F00A3A;
	Thu, 30 Jul 2026 15:00:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785423640;
	bh=eNyMu5Ca//YU54AzRtEiN99Ip6cSRIS+HB5fWqKt9Nk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=byWCCYGDuCdlrjxopNYljdRMTmny6Lk6zLX7YOG3Fnj9dCok1oCiIyXSDG80QzGB2
	 lYq/crB6UlCWQSbjIDrJwd9wfK17oImFQXkaS3FcGhVyPWYnFMEQn5DlGwQzqwRyvU
	 0lXcK/05qi7cLOXdrbJWfDkB5qx0sk2L6l2oHJGg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhao Li <enderaoelyther@gmail.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 078/675] wifi: nl80211: constrain MBSSID TX link ID range
Date: Thu, 30 Jul 2026 16:06:48 +0200
Message-ID: <20260730141446.787876910@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141445.110192266@linuxfoundation.org>
References: <20260730141445.110192266@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index 5583edf4852775..237e5d7eeb47c3 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -501,7 +501,7 @@ nl80211_mbssid_config_policy[NL80211_MBSSID_CONFIG_ATTR_MAX + 1] = {
 	[NL80211_MBSSID_CONFIG_ATTR_TX_IFINDEX] = { .type = NLA_U32 },
 	[NL80211_MBSSID_CONFIG_ATTR_EMA] = { .type = NLA_FLAG },
 	[NL80211_MBSSID_CONFIG_ATTR_TX_LINK_ID] =
-		NLA_POLICY_MAX(NLA_U8, IEEE80211_MLD_MAX_NUM_LINKS),
+		NLA_POLICY_RANGE(NLA_U8, 0, IEEE80211_MLD_MAX_NUM_LINKS - 1),
 };
 
 static const struct nla_policy
-- 
2.53.0



