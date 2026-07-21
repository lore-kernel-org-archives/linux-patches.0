Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7525D35C682;
	Tue, 21 Jul 2026 22:26:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784672797; cv=none; b=ul2ve9SsiV7wOwEBS4PmyUxwA8TkJR/U34Ca26uh+f6+etorQ3L5v24bHVE8vW2fuYCuniP24EHVYo8kSkLQJq4gkA7B/3VLl+UhklpOIgL486R8r3ydPow9taPWNVr1/MZv7qS0IuK6NPilpMEhaBGBF+3R7srXMg6/X1sv6Ws=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784672797; c=relaxed/simple;
	bh=HdOJcLYAjVwLAiTnArOP5lhf/vqfY/eOx8g85G2PiQg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NTPamrGK0ijGer0sdFmKC0gtPJcsqkgXsCrLfRdS9+lMgm1wSjuxsapIxvQloyxQWP9xU5xqNF2C7b2nziJlAkXelTC0isQyYM7q6+2j7gmOGIBw79I87QJpyPv6Aur9K5+xoJHPjNkaQI2TKSF+2LaMlhmCM9L1xNjyF1rsBek=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GxoWmkq1; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GxoWmkq1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DA24A1F000E9;
	Tue, 21 Jul 2026 22:26:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784672796;
	bh=2e2oRLYrMwqk32kUtpL2KYSYiB+0ftTiRD9WXbt5OkI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=GxoWmkq1pbqY/4ZGTDHu3qDkqiE9MiXm016SJs7PYtRwvglDkJJBRdSW2ejO3orNC
	 msIjQkbr/rtwFfAY6HhIuuxTRRAdUP+XGn3jb8lCHkfGh7UKxiqOM8pucBAUhitMpa
	 0OFQY6PkJcOFxYT6FR01L5T/P+ScBbJbeIiBfoqw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sevinj Aghayeva <sevinj.aghayeva@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 759/843] staging: rtl8723bs: Remove redundant else branches.
Date: Tue, 21 Jul 2026 17:26:34 +0200
Message-ID: <20260721152423.124891698@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152405.946368001@linuxfoundation.org>
References: <20260721152405.946368001@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sevinj Aghayeva <sevinj.aghayeva@gmail.com>

[ Upstream commit 4610e57a7d2edeef14aa852cd945f9920e1759da ]

This patch fixes the following checkpatch.pl warning:

WARNING: else is not generally useful after a break or return

Signed-off-by: Sevinj Aghayeva <sevinj.aghayeva@gmail.com>
Link: https://lore.kernel.org/r/20220329140904.GA3566@ubuntu
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Stable-dep-of: 1463ca3ec660 ("staging: rtl8723bs: fix OOB reads in rtw_get_sec_ie(), rtw_get_wapi_ie(), and rtw_get_wps_attr()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/staging/rtl8723bs/core/rtw_ieee80211.c |   27 ++++++++++---------------
 1 file changed, 11 insertions(+), 16 deletions(-)

--- a/drivers/staging/rtl8723bs/core/rtw_ieee80211.c
+++ b/drivers/staging/rtl8723bs/core/rtw_ieee80211.c
@@ -94,16 +94,14 @@ bool rtw_is_cckratesonly_included(u8 *ra
 
 int rtw_check_network_type(unsigned char *rate, int ratelen, int channel)
 {
-	if (channel > 14) {
+	if (channel > 14)
 		return WIRELESS_INVALID;
-	} else { /*  could be pure B, pure G, or B/G */
-		if (rtw_is_cckratesonly_included(rate))
-			return WIRELESS_11B;
-		else if (rtw_is_cckrates_included(rate))
-			return	WIRELESS_11BG;
-		else
-			return WIRELESS_11G;
-	}
+	/* could be pure B, pure G, or B/G */
+	if (rtw_is_cckratesonly_included(rate))
+		return WIRELESS_11B;
+	if (rtw_is_cckrates_included(rate))
+		return WIRELESS_11BG;
+	return WIRELESS_11G;
 }
 
 u8 *rtw_set_fixed_ie(unsigned char *pbuf, unsigned int len, unsigned char *source,
@@ -155,10 +153,9 @@ u8 *rtw_get_ie(u8 *pbuf, signed int inde
 		if (*p == index) {
 			*len = tmp;
 			return p;
-		} else {
-			p += (tmp + 2);
-			i += (tmp + 2);
 		}
+		p += (tmp + 2);
+		i += (tmp + 2);
 	}
 	return NULL;
 }
@@ -702,9 +699,8 @@ u8 *rtw_get_wps_ie(u8 *in_ie, uint in_le
 			cnt += in_ie[cnt+1]+2;
 
 			break;
-		} else {
-			cnt += in_ie[cnt+1]+2; /* goto next */
 		}
+		cnt += in_ie[cnt+1]+2; /* goto next */
 	}
 
 	return wpsie_ptr;
@@ -753,9 +749,8 @@ u8 *rtw_get_wps_attr(u8 *wps_ie, uint wp
 				*len_attr = attr_len;
 
 			break;
-		} else {
-			attr_ptr += attr_len; /* goto next */
 		}
+		attr_ptr += attr_len; /* goto next */
 	}
 
 	return target_attr_ptr;


