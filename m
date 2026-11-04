Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793829578;
	b=Rh+JGqx9pa5kfvvNaTOo7Q6BsOX591SrblgCgV2zE+JnDFKHfIisF+1tuumPN+NlVl7O
	 kLuFRu1+WB7nIUZFd1lsdquK/qiigqf/H6jRyHcFXxz1KqxAbmiohosQ8g6SlpZoSTzHP
	 Q7N+zuxdvwtaMma9LpdXV4kqrgUlHsvRjYgeX+Q0oTbxt9+AamByJm5nzfZ5l3R4bvEch
	 fBmUKxq/Xlf5eJeTAXWSnRRSUJbVuHpKyH0iE9HFvmUG+F4tDqtkrhTvfdRXT+F+F+hYe
	 KO3eZ0uNDvH1zqfz1jP3QsqweK1+Mz1pLPBRA/eQU6ZotIDOLb6l0OnrYKvtq0oYcKw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793829578;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=96D5aD6vrEPIKU2RW4CdZzcHln7B5s+XaeldzaqE6vw=;
	b=l8zVeVDWFChXMn33GGc62WoyPIxVqhTqJ6EkVL+0DXAghLyCEO7yOoGFkS6cs/nc8hzx
	 1z1a+HzQKfDsdRSZmn8WuiumlZp4c1aUXWLGh1zIltJ+HDO2q3LZr9Zd2PseolC+Jp9e0
	 a7rv8K0p6igcui2r6mh/1IadHMIqJMePtR6uuS8HXacC73UnQsK81X82ONOc8UjGg0qw8
	 uVICORGRwOeifivwxFwzioGEduITMMOwqgYt4Q/oKGjXgju42ciRBxRjwxv2L2O9pJoQq
	 nKNIlGF3r4IAThsaJXzr0FgMkU96XfmCGefuq4ltWCgCaYToiDevVgsl03RaGOGN6SA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=WlAGDpFc;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8DCD8606A33E;
	Wed,  4 Nov 2026 21:59:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=WlAGDpFc
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 287D81F0093A;
	Wed,  4 Nov 2026 21:59:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793829578;
	bh=96D5aD6vrEPIKU2RW4CdZzcHln7B5s+XaeldzaqE6vw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=WlAGDpFc7Ct8FoIP530rCX3B3lbH2+rWRIvmTbwVW6HYeifFADGP4nuNGIeh2hFfu
	 wwzNpsG4IbtvfIC4F0vFa/0rejuIm8sBS2BQKL/3Dh1FH+Pbj1Hopa/mXxRmQfm3KZ
	 yyZyaIEEg8GnE1GstVzS7IjEX2ynW1BIo/9AVpHU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shahar Tzarfati <shahar.tzarfati@intel.com>,
	Miri Korenblit <miriam.rachel.korenblit@intel.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0213/1005] wifi: mac80211: ibss: read deauth reason_code after frame length check
Date: Wed,  4 Nov 2026 15:59:06 -0500
Message-ID: <20261104211049.780111282@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104211043.516122098@linuxfoundation.org>
References: <20261104211043.516122098@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Shahar Tzarfati <shahar.tzarfati@intel.com>

[ Upstream commit aa4c0a649903567762edf2bbc7fff608953b3ca4 ]

The function was reading reason_code from the frame before validating
that the frame is at least IEEE80211_DEAUTH_FRAME_LEN bytes long.

Move the reason_code read to after the length check so the field is
guaranteed to be present before it is accessed.

Signed-off-by: Shahar Tzarfati <shahar.tzarfati@intel.com>
Signed-off-by: Miri Korenblit <miriam.rachel.korenblit@intel.com>
Link: https://patch.msgid.link/20260715212706.db26604650bd.I2caa73c396b8c9d357224b9334d5df3cafac498e@changeid
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/mac80211/ibss.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/net/mac80211/ibss.c b/net/mac80211/ibss.c
index 6ca2ff354e768..4dc748a667a72 100644
--- a/net/mac80211/ibss.c
+++ b/net/mac80211/ibss.c
@@ -910,11 +910,13 @@ static void ieee80211_rx_mgmt_deauth_ibss(struct ieee80211_sub_if_data *sdata,
 					  struct ieee80211_mgmt *mgmt,
 					  size_t len)
 {
-	u16 reason = le16_to_cpu(mgmt->u.deauth.reason_code);
+	u16 reason;
 
 	if (len < IEEE80211_DEAUTH_FRAME_LEN)
 		return;
 
+	reason = le16_to_cpu(mgmt->u.deauth.reason_code);
+
 	ibss_dbg(sdata, "RX DeAuth SA=%pM DA=%pM\n", mgmt->sa, mgmt->da);
 	ibss_dbg(sdata, "\tBSSID=%pM (reason: %d)\n", mgmt->bssid, reason);
 	sta_info_destroy_addr(sdata, mgmt->sa);
-- 
2.53.0



