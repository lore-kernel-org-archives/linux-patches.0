Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795056989;
	b=qgoJ3GAEFoPiH2m7MD1ReCISK8LuKqd3EONXfoTKI42fHgD1gG+DOHyxiO4Fr5ylfFZA
	 m+68M0vf3tqAICTW3aExzzwJgPb9PUCIkl1RzSMxU9eEAPT2/oNxrvKSWeejMGPrl6gBX
	 /Zb6XGL+XBc6b0KaJi4Qgy72Gpy7bUItwfu8m2Yfhp80RLCFvo7KKdQuwiNGqljoo4zgF
	 JFANETm/ZfA1FNVQ0/upwZaRryhD9OFWqPHvDNCI1dwXqU20vm0drFZoXMqtvlrJvYrKv
	 iNOm78gjKewB44QVu6xlc8tE7e+AJEYv9TfmxYoFukdctxqP3Kw0IGko59HN70ygaqg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795056989;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=J+mS4mqDPeLigkHjX0ZzpFUCp/o58/D7ZlW+YqI7Tws=;
	b=zNj08HhoG/fYTvZ1f+hk7OJzCDppBCkouog/7x62yLlrmXg75HHwumrrewm/fgQ59KaM
	 s6KTfKIfkK6NCuPeiy8AZkknB74FgECcNPPkB4RvczsFvrxV8zjFEAAfCnOSks2n/mfjO
	 rGWWXzzPdJe9qI1MlKYGgqWxYt/QNimtPwI9MfOJj3emcIkMV6ap4D4flx1+vkdC9I9sD
	 kM/7phMqQydqkUyG/zLLWmP5L+8tWbiT45PjUEV+YEIz/2TmJ+Bv9YvLj0LRmdrj583BK
	 +/fWp6zuby5fLxChk6g8pfQ5lMvK2LmAQ2UUqJg5UT/tt6dOQncFmA6ZvrxNm5i0+NA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=o+62vprc;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 152D0606A320;
	Thu, 19 Nov 2026 02:56:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=o+62vprc
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 66EB71F000C4;
	Thu, 19 Nov 2026 02:56:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795056988;
	bh=J+mS4mqDPeLigkHjX0ZzpFUCp/o58/D7ZlW+YqI7Tws=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=o+62vprcj+BKQ6LYPjVg6Bbb+xSLAsXVs5Wf2+YclmUUFMb/4GDk/gys3Gwb3jfWw
	 PYABsipwukiZzFECg6WhSXnzt3QadnQywoxbmjrZQqqYpIYXH7b0z1csHuWa5pwK8C
	 cvN/MT88IRgQJXC+9NkpG+Ohvmj9HaDhW9PeCyFI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexandre Belloni <alexandre.belloni@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 2167/2214] rtc: add alarm related features
Date: Wed, 18 Nov 2026 16:04:03 +0100
Message-ID: <20261118150137.106198393@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alexandre Belloni <alexandre.belloni@bootlin.com>

[ Upstream commit 917425f71f36ce6f61841497040e10d0166106d8 ]

Add more alarm related features to be declared by drivers.

Signed-off-by: Alexandre Belloni <alexandre.belloni@bootlin.com>
Link: https://lore.kernel.org/r/20211018151933.76865-2-alexandre.belloni@bootlin.com
Stable-dep-of: 6199051016cd ("rtc: s35390a: Read 24-hour mode on access")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/uapi/linux/rtc.h | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/include/uapi/linux/rtc.h b/include/uapi/linux/rtc.h
index f950bff75e97e..f4037c5419257 100644
--- a/include/uapi/linux/rtc.h
+++ b/include/uapi/linux/rtc.h
@@ -114,7 +114,9 @@ struct rtc_pll_info {
 #define RTC_FEATURE_ALARM		0
 #define RTC_FEATURE_ALARM_RES_MINUTE	1
 #define RTC_FEATURE_NEED_WEEK_DAY	2
-#define RTC_FEATURE_CNT			3
+#define RTC_FEATURE_ALARM_RES_2S	3
+#define RTC_FEATURE_UPDATE_INTERRUPT	4
+#define RTC_FEATURE_CNT			5
 
 #define RTC_MAX_FREQ	8192
 
-- 
2.53.0



