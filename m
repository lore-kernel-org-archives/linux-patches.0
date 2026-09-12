Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF2D51A8F7B;
	Sat, 12 Sep 2026 10:06:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789207590; cv=none; b=gcBhIChijkO5nhcVI08JJY2axKc32/bDYiOhjlp8zZv/TrDe8x02S/nZELzp7P6876mU3gkw+fNV3zgby6NLxMu8c+TLj8UrjGdAahJXV9EYrPOawCa+H2nyVH9E3Ynj4M0iJUp5rYrywvbRMqRHa5RX860QgTMSBjI3pnXnUJ4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789207590; c=relaxed/simple;
	bh=Aba9Hv/Hd/zeraQ0TcOn/kU1+mVBh263ye7M56lYJOE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nuPKUKKfI0wcTEn0LnBTbUf6XfhVZ18hzh8IhKECTRkt9jIDbHX68id9PeLxWhUvxxUDWR8UlToN24OuInSSWiPvyzfeP/tQR9eCdv43I1Nt8abeHEJcfznLpHGAXfQ1cHUH0CZEUFvxv8B2wQ8pIk1ieWp5t7oybIgjKSn0GUc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aBiB4WN5; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aBiB4WN5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 569871F000FF;
	Sat, 12 Sep 2026 10:06:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789207588;
	bh=lPcI15kR6eGqayG8+RFF+GX1nNxSrWriATvmN1fuZ/s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=aBiB4WN5ieaa4HlWMCUF4NF31WtZwq3i2PNt5cQsq1OPWEn6XDPijOJZ31tg3jW7T
	 yutUYZTvzCJxIyIDGrFvrQvc7drcvjyoFzQVM/DAC0rxsspAS9FZoiPOGm7OQap+oN
	 LL19hoq6UbOBqq9ZqvzkALS7Xe9RPkBOesHcsd9Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Navaneeth K <knavaneeth786@gmail.com>,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0442/1518] staging: rtl8723bs: use standard offsetof in cfg80211 operations
Date: Sat, 12 Sep 2026 08:43:31 +0200
Message-ID: <20260912065633.449500978@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065623.398859879@linuxfoundation.org>
References: <20260912065623.398859879@linuxfoundation.org>
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

From: Navaneeth K <knavaneeth786@gmail.com>

[ Upstream commit 6ddb173fcf34f4b9351a20f29e31aa2bc3f90574 ]

Replace usage of the custom FIELD_OFFSET macro with the standard
offsetof() macro in ioctl_cfg80211.c. This improves code readability
and uses the kernel's standard mechanism.

Also include <linux/stddef.h> in basic_types.h to ensure offsetof()
is available for this and future conversions.

Signed-off-by: Navaneeth K <knavaneeth786@gmail.com>
Reviewed-by: Dan Carpenter <dan.carpenter@linaro.org>
Link: https://patch.msgid.link/20251125112059.16913-3-knavaneeth786@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Stable-dep-of: 41b8209376df ("staging: rtl8723bs: fix xmit_frame/xmit_buf leaks on mgnt-frame error paths")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/staging/rtl8723bs/include/basic_types.h   | 1 +
 drivers/staging/rtl8723bs/os_dep/ioctl_cfg80211.c | 3 ++-
 2 files changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/staging/rtl8723bs/include/basic_types.h b/drivers/staging/rtl8723bs/include/basic_types.h
index 1c2da18e62100..16b270fe0203d 100644
--- a/drivers/staging/rtl8723bs/include/basic_types.h
+++ b/drivers/staging/rtl8723bs/include/basic_types.h
@@ -12,6 +12,7 @@
 #define FAIL	(-1)
 
 #include <linux/types.h>
+#include <linux/stddef.h>
 
 #define FIELD_OFFSET(s, field)	((__kernel_ssize_t)&((s *)(0))->field)
 
diff --git a/drivers/staging/rtl8723bs/os_dep/ioctl_cfg80211.c b/drivers/staging/rtl8723bs/os_dep/ioctl_cfg80211.c
index 0eb40b7bd0ba3..cc898131f5d06 100644
--- a/drivers/staging/rtl8723bs/os_dep/ioctl_cfg80211.c
+++ b/drivers/staging/rtl8723bs/os_dep/ioctl_cfg80211.c
@@ -1721,7 +1721,8 @@ static int cfg80211_rtw_connect(struct wiphy *wiphy, struct net_device *ndev,
 
 		if (wep_key_len > 0) {
 			wep_key_len = wep_key_len <= 5 ? 5 : 13;
-			wep_total_len = wep_key_len + FIELD_OFFSET(struct ndis_802_11_wep, key_material);
+			wep_total_len = wep_key_len +
+				offsetof(struct ndis_802_11_wep, key_material);
 			pwep = rtw_malloc(wep_total_len);
 			if (!pwep) {
 				ret = -ENOMEM;
-- 
2.53.0



