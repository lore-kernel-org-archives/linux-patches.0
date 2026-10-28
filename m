Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793216814;
	b=nNPoObBCQzD37e7x/HjBGQYXEW/XEWTcPd+txOw4ymjkrY00e28ipiLpTmwVOdi7Bkds
	 o8lxgNLEhkXeLeouPico28FC8dK5F0nE3yMkzTjtmu/ifjMiCbLUZYaJH7iQVP0oTg20G
	 bcIDGKA0fSMxTEUAe+mFZEIn37AJ5K14zSau8fFalg/6VEgqjDGkiIyxkKvneIVSMsWFF
	 W21QdHDJlAyftoBHkFrRlzrCVspzleY3LGM5ZBj+4AsoOlfC+3PggczehSJsS5wdfRmMR
	 1UZ1y++w9bzRmwppBi6eiaaXMH8XkWpTB4y4u9sy98LFveaxDI/v09VruZpT+oTOPjg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793216814;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=iuODM13/ggX6kCZ3SlkXXE8YHEDSkhX1jDArd2eQyWc=;
	b=Y3TG9qI94ftjIPSGlXi3bLKd32MSiFKIXxIScTg6XdMO8KxPh/WBAE2zUUGuFGNI+fGX
	 MQGbmKZ146pHPzSrIDANTba4kttSvjje/vtG0it4lQw29JnznAMt8Qq7DWn4sqBimW6tA
	 2MhpwOBdgeufwlRQSmBLuxHeA8mUINS5YAKLbMFIeLD/uPUszbHOPRtQqEMITHBbFuggR
	 tCQej1osljeK8NbnIWFx4Ym3jIz6gRAOmL0KJLl/HzT3+1vw1090W8oXYjtK3MKeWemMu
	 vhH+xZVoJrRj5Ga/70zrshIT/BPUZH0NxhoeOE+7livlDqj3Fl48UejgEs5bhoT2l0Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=BPzqdCDC;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 29939606A31A;
	Wed, 28 Oct 2026 19:46:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=BPzqdCDC
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7D5A41F01825;
	Wed, 28 Oct 2026 19:46:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793216814;
	bh=iuODM13/ggX6kCZ3SlkXXE8YHEDSkhX1jDArd2eQyWc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=BPzqdCDCNxcBvv5GhIbE75+e+TgmGt7z3H8G6CDwyF5xiiiEXW0e4aUMe5vsBLbAQ
	 b1Bdpsd7dkoq4OgEqj9s1HeUS7f0BYZGTJE9laDSbyphD0VmSYYs96HnOJGYrnrKk0
	 L6GrnU87YyYKtlE8Kp0UnjjcZa4himDWTrZ5HaUA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yifan Wu <yifanwucs@gmail.com>,
	Juefei Pu <tomapufckgml@gmail.com>,
	Yuan Tan <yuantan098@gmail.com>,
	Xin Liu <bird@lzu.edu.cn>,
	Yuqi Xu <xuyuqiabc@gmail.com>,
	Ren Wei <n05ec@lzu.edu.cn>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1686/1887] wifi: cfg80211: reject duplicate wiphy cipher suite entries
Date: Wed, 28 Oct 2026 18:03:02 +0100
Message-ID: <20261028170537.823913232@linuxfoundation.org>
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

From: Yuqi Xu <xuyuqiabc@gmail.com>

[ Upstream commit 7187d145d9042b037e4f10538f70cf95e380219f ]

Duplicate entries in wiphy->cipher_suites do not describe any
additional capability, but cfg80211 currently accepts them and leaves
individual consumers to deal with them.

One such consumer is the WEXT compatibility code, which appends a WEP
key length for each WEP cipher entry it sees. Repeated WEP entries can
therefore overflow the fixed iw_range::encoding_size array returned by
SIOCGIWRANGE.

Reject duplicate cipher suite entries in wiphy_register() instead.
This keeps the cipher suite invariant in one place and makes malformed
wiphy descriptions fail early with -EINVAL, rather than relying on a
single cfg80211 user to handle duplicates correctly.

Reported-by: Yifan Wu <yifanwucs@gmail.com>
Reported-by: Juefei Pu <tomapufckgml@gmail.com>
Co-developed-by: Yuan Tan <yuantan098@gmail.com>
Signed-off-by: Yuan Tan <yuantan098@gmail.com>
Suggested-by: Xin Liu <bird@lzu.edu.cn>
Signed-off-by: Yuqi Xu <xuyuqiabc@gmail.com>
Signed-off-by: Ren Wei <n05ec@lzu.edu.cn>
Link: https://patch.msgid.link/20260413123000.1480661-1-n05ec@lzu.edu.cn
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/wireless/core.c | 21 +++++++++++++++++++++
 1 file changed, 21 insertions(+)

diff --git a/net/wireless/core.c b/net/wireless/core.c
index 1cd214a743428..3179eb8899d65 100644
--- a/net/wireless/core.c
+++ b/net/wireless/core.c
@@ -693,6 +693,24 @@ static int wiphy_verify_combinations(struct wiphy *wiphy)
 	return 0;
 }
 
+static bool wiphy_cipher_suites_valid(const struct wiphy *wiphy)
+{
+	int i, j;
+
+	if (wiphy->n_cipher_suites && !wiphy->cipher_suites)
+		return false;
+
+	for (i = 0; i < wiphy->n_cipher_suites; i++) {
+		for (j = 0; j < i; j++) {
+			if (wiphy->cipher_suites[i] ==
+			    wiphy->cipher_suites[j])
+				return false;
+		}
+	}
+
+	return true;
+}
+
 int wiphy_register(struct wiphy *wiphy)
 {
 	struct cfg80211_registered_device *rdev = wiphy_to_rdev(wiphy);
@@ -824,6 +842,9 @@ int wiphy_register(struct wiphy *wiphy)
 	if (res)
 		return res;
 
+	if (!wiphy_cipher_suites_valid(wiphy))
+		return -EINVAL;
+
 	/* sanity check supported bands/channels */
 	for (band = 0; band < NUM_NL80211_BANDS; band++) {
 		u16 types = 0;
-- 
2.53.0



