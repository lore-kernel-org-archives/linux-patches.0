Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793215404;
	b=0cQE+DiCaFNTkMGoJy7H47zlWNOpChslNHiRQfDEFCxrofS0JrSm0NOYaq8h0UaYftcI
	 VQxzf3t010VrePFtpbCkX5OiGeZmjRJBWxyfIo/zFjc/Uv0TJkjegfgDSUe2bUxztiJSm
	 64NJZ53fV9YB0uXGG/7x5AiGn1n8nX2cJbdMPY2/SBW+RNgjlDag96Zixs2JXw5K9NGSV
	 jbYjEgTsPZHgo6WJ5AWlX0PQx6T+K0gkd4ZoBOzaBO1qazkOo1lD2gcGa1YeRN+0Mm168
	 MxAwuX1uITXV+mRM/IxXeAZkLkRxe2xqjRKesKLuqPEP9FWAdGOrPAiKPRmdPJMb6Bw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793215404;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=M0t0ctyBBE74jO2A78YpioEoj+8U3RWPeLsrpvWS5Eo=;
	b=H8UdPLbOeKbhsKbjwE2B9TYYSoHNis6ISzKUNZLnnmVkb/UoJVhNLHiUutOJ2zsLf7Ah
	 94uAOotJ1Tz4tdFie0kp7+5skCcedrIHq+2WIm2OaSTEmz8wVZ+o33rfSZ/D5GMi5+zsI
	 0o4vaBbNd6JxfqivTMnQD2iuq+XF0HUNmrBOpsHIDO92iPCnYdVwU68wyw9/I6Rgnte/b
	 l9//5stZe+/RCZ1rvJNWcRtpAAgM/353UC2+cTJJk2EWYjhObWGYtZalt/EZ90jqcmV2x
	 U9XqWDobC/xncSDTQ2RFSjHE4Quiszn8DDoCcD6GIKIZkZBNnEDUBb0xbNl4uZ5Lebg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=1KX2F0al;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8FE78606A32C;
	Wed, 28 Oct 2026 19:23:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=1KX2F0al
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DC8CC1F01828;
	Wed, 28 Oct 2026 19:23:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793215404;
	bh=M0t0ctyBBE74jO2A78YpioEoj+8U3RWPeLsrpvWS5Eo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1KX2F0ali6C/GYhwRkUtd2YAjSysXNXTpOMKEMOxP3ZKncO64JHZYbfI1wSrbC1Cy
	 x/S68xTP9Jbdme1CNwFZtGBzFuKrOYQ918buOSjauvR6Z+uza5RSjRPXtRuIIF+h/H
	 PjpSqLQ7m4sPq2rnIHR+XEIbcpHP3GiSo0S+vmzA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhao Li <enderaoelyther@gmail.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1199/1887] wifi: ieee80211: validate MLE common info length
Date: Wed, 28 Oct 2026 17:54:55 +0100
Message-ID: <20261028170526.689910116@linuxfoundation.org>
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

From: Zhao Li <enderaoelyther@gmail.com>

[ Upstream commit 293baeae9b2434a3e432629d7720b5603db2d77e ]

ieee80211_mle_common_size() uses the first common-info octet as the
common information length for all known MLE types. However,
ieee80211_mle_size_ok() only validates that octet for Basic, Probe
Request, and TDLS MLEs.

Reconfiguration MLEs also skipped the length octet when calculating the
minimum common size, and Priority Access MLEs skipped validation of the
advertised common information length.

Account for the Reconfiguration common-info length octet and validate
the advertised common information length for all known MLE types. Keep
unknown-type handling unchanged.

Fixes: 0f48b8b88aa9 ("wifi: ieee80211: add definitions for multi-link element")
Cc: stable@vger.kernel.org
Signed-off-by: Zhao Li <enderaoelyther@gmail.com>
Link: https://patch.msgid.link/20260611173506.36838-2-enderaoelyther@gmail.com
[remove now misleading comment]
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/ieee80211.h | 12 ++++--------
 1 file changed, 4 insertions(+), 8 deletions(-)

diff --git a/include/linux/ieee80211.h b/include/linux/ieee80211.h
index c16e90c5588ee..d7ad2e9b0baa2 100644
--- a/include/linux/ieee80211.h
+++ b/include/linux/ieee80211.h
@@ -4601,7 +4601,7 @@ static inline bool ieee80211_mle_size_ok(const u8 *data, u8 len)
 	const struct ieee80211_multi_link_elem *mle = (const void *)data;
 	u8 fixed = sizeof(*mle);
 	u8 common = 0;
-	bool check_common_len = false;
+	u8 common_len;
 	u16 control;
 
 	if (!data || len < fixed)
@@ -4612,7 +4612,6 @@ static inline bool ieee80211_mle_size_ok(const u8 *data, u8 len)
 	switch (u16_get_bits(control, IEEE80211_ML_CONTROL_TYPE)) {
 	case IEEE80211_ML_CONTROL_TYPE_BASIC:
 		common += sizeof(struct ieee80211_mle_basic_common_info);
-		check_common_len = true;
 		if (control & IEEE80211_MLC_BASIC_PRES_LINK_ID)
 			common += 1;
 		if (control & IEEE80211_MLC_BASIC_PRES_BSS_PARAM_CH_CNT)
@@ -4630,15 +4629,14 @@ static inline bool ieee80211_mle_size_ok(const u8 *data, u8 len)
 		common += sizeof(struct ieee80211_mle_preq_common_info);
 		if (control & IEEE80211_MLC_PREQ_PRES_MLD_ID)
 			common += 1;
-		check_common_len = true;
 		break;
 	case IEEE80211_ML_CONTROL_TYPE_RECONF:
+		common += 1;
 		if (control & IEEE80211_MLC_RECONF_PRES_MLD_MAC_ADDR)
 			common += ETH_ALEN;
 		break;
 	case IEEE80211_ML_CONTROL_TYPE_TDLS:
 		common += sizeof(struct ieee80211_mle_tdls_common_info);
-		check_common_len = true;
 		break;
 	case IEEE80211_ML_CONTROL_TYPE_PRIO_ACCESS:
 		common = ETH_ALEN + 1;
@@ -4651,11 +4649,9 @@ static inline bool ieee80211_mle_size_ok(const u8 *data, u8 len)
 	if (len < fixed + common)
 		return false;
 
-	if (!check_common_len)
-		return true;
+	common_len = mle->variable[0];
 
-	/* if present, common length is the first octet there */
-	return mle->variable[0] >= common;
+	return common_len >= common && common_len <= len - fixed;
 }
 
 enum ieee80211_mle_subelems {
-- 
2.53.0



