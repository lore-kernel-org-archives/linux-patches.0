Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C59FD5398DA;
	Mon, 31 Aug 2026 13:45:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788183932; cv=none; b=BDDIOBkAb5Yizb72tRgR02sjJi87mivwyL5bGo7exBWak2Yz9UmCTCxTYpCKjNM+fSsr8917M47cD1F6yqANjfPuyb9lma7WD0X9QiE4FCyjYN6CA6cWIwB89d2+6rULMN2H95gwt/QvLHBc/7oOfRx7H7qa+dEFqxDOdf4Ym3U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788183932; c=relaxed/simple;
	bh=FBw6czmu5+cmyW7uUzVXmOiSu8BBz/BxNBmq0IQxZTg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=I9eNmD9C4wuqmQjlMaPmmkmSrL48Rd06lAOnPKX8Adq1E+7DCzEcaodEbBgBkSe0iZF0BWe2DIof0tOpDPNZSFzj5QKNMwOk7m26dEfmjx94n+A2u9In0Ca1RdrfHHeb8FKQVqoslSpIszGg+yZUTfQuF5cnleIYXFjklzfFym0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ZLo5Xrle; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ZLo5Xrle"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C83521F00ACF;
	Mon, 31 Aug 2026 13:45:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788183930;
	bh=K6Yaxx35S3e64yW2Ae4uo/uWRMkAPoEymF87g8Vps7A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ZLo5XrleprkPBmarYkaupRHk9+4O/4P+zZgcBkJLVo/vmq127GXWz4t95aDqt/s/A
	 W7lZCvcTN70ABSTUJ8AO0s+2tfi0s9ZFqlbwnjaqPJwrovt3DX5UdKoTKJqrKkP+ER
	 uepnexGPyTmwC8+HipQnkjodSfgb9M6AjaT2XsLKsgoIvMTDL51Y0kh7Yx9KpjH31p
	 GFQNQ91Frfrz2HUCRaBNeSfETjee6Fo+U3YlExV1NBhDOCOHx21aBVB8YUm+2oIsXP
	 NtoXAAe/6l5V5qpO+EzkmoM04ibDQ0+/GejYq4qWZsAqE1zZ0XUDyfmk0GaQuNpS3W
	 V+kJrZPyDAC6A==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Ibrahim Hashimov <security@auditcode.ai>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>,
	johannes@sipsolutions.net,
	linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18-5.10] wifi: mac80211_hwsim: reject undersized HWSIM_ATTR_TX_INFO
Date: Mon, 31 Aug 2026 09:26:56 -0400
Message-ID: <20260831133314.4125787-388-sashal@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260831133314.4125787-1-sashal@kernel.org>
References: <20260831133314.4125787-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.18.48
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Ibrahim Hashimov <security@auditcode.ai>

[ Upstream commit 3dc723ac78a6e4fa0fd49e27e487ed319da40a9f ]

hwsim_tx_info_frame_received_nl() casts the HWSIM_ATTR_TX_INFO payload
to a struct hwsim_tx_rate * and unconditionally reads
IEEE80211_TX_MAX_RATES entries (8 bytes) from it. The policy only bounds
the attribute from above (NLA_BINARY .len is a maximum) and the op sets
GENL_DONT_VALIDATE_STRICT, so a short or zero-length attribute is
accepted and the loop reads past the payload.

Require the exact length in the policy, so a malformed attribute is
rejected before the handler runs.

Signed-off-by: Ibrahim Hashimov <security@auditcode.ai>
Assisted-by: AuditCode-AI:2026.07
Link: https://patch.msgid.link/20260721115346.17236-1-security@auditcode.ai
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

The background history lookup didn’t finish — it was killed after ~67s
because it used `git log --all`, which is too slow on this repo.

That didn’t change the conclusion. The analysis already stands: this is
a small, maintainer-reviewed security fix (OOB read on undersized
`HWSIM_ATTR_TX_INFO`) in `mac80211_hwsim`, the buggy code is present in
this v6.18.44 tree, and a similar hwsim security fix was already
backported here.

**YES** for stable backport to this tree.

 drivers/net/wireless/virtual/mac80211_hwsim.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/virtual/mac80211_hwsim.c b/drivers/net/wireless/virtual/mac80211_hwsim.c
index a0724e1c53070..8294e2c344eb9 100644
--- a/drivers/net/wireless/virtual/mac80211_hwsim.c
+++ b/drivers/net/wireless/virtual/mac80211_hwsim.c
@@ -912,9 +912,9 @@ static const struct nla_policy hwsim_genl_policy[HWSIM_ATTR_MAX + 1] = {
 	[HWSIM_ATTR_FLAGS] = { .type = NLA_U32 },
 	[HWSIM_ATTR_RX_RATE] = { .type = NLA_U32 },
 	[HWSIM_ATTR_SIGNAL] = { .type = NLA_U32 },
-	[HWSIM_ATTR_TX_INFO] = { .type = NLA_BINARY,
-				 .len = IEEE80211_TX_MAX_RATES *
-					sizeof(struct hwsim_tx_rate)},
+	[HWSIM_ATTR_TX_INFO] =
+		NLA_POLICY_EXACT_LEN(IEEE80211_TX_MAX_RATES *
+				     sizeof(struct hwsim_tx_rate)),
 	[HWSIM_ATTR_COOKIE] = { .type = NLA_U64 },
 	[HWSIM_ATTR_CHANNELS] = { .type = NLA_U32 },
 	[HWSIM_ATTR_RADIO_ID] = { .type = NLA_U32 },
-- 
2.53.0

