Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795055622;
	b=EXXl/NfmBmlDcR9jsWLpYcHqU+maNJV1tpK6dRD5C7hk8mYF+TyciMj26fBNV2oSSNLm
	 WzHODAv8btE90NAtfuoCmhLRjroWNMBspMK/rOiysHzTpcgA99X8K4/SIcbu4iT+jebfG
	 C02CUbvncGbOD8/lQwtp62Q9iVilx5IHM/M2OeTroQtdsiYg3tz4BV15lAK2bVjhLkw8r
	 Eq4txSYqmLqif5WnjR7IA6Pvva3JGNY+Muu467ehdwa7Kjs0R0k8b3in39xvI5+7pAiK3
	 KcPBfcqODKv3hhs04khvdZhSEHRpLqj1OvphOxAxx+NRgp+mIv9Ik/XCZbENjBlTIfA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795055622;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=xsNtKJgxoBDEWNSjcFjTvUkXvFmJ/5AvqzmVS9QQWkc=;
	b=GtVMUDDm5Wz+8a8md4/b1mlLHPnXVGe9Hk6QsDjW6bNbU1yDR1ZC0vrXxp8ZRh758jR9
	 FtWm6IVXwvEmOErdMuDc3LPOcKa6HElnmmJgCCXgRnM1V0y6Kc1C64M8YP00R2DA+hojV
	 Yy9x0FmRVIYsB9lnHHzKhMW4iQ+d9/Ybi6/3tp96k7jktEAMAw417ZuCxGnR+1fL/8AnS
	 EhBkXC9k54dXU5FpT9TBj7SHz5+N44eJxJpc+hdQpQYvPrOqfZIif52c4VqsJ0bCGtZp+
	 4G+peDV6tQb7KCVAEHG6DGIBagy+VbSqcBXMwV4LFSdZqfB+g2T8O7PX4Qja29Oq5sg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=twouVtt6;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9EAA4606A337;
	Thu, 19 Nov 2026 02:33:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=twouVtt6
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F0C691F000C4;
	Thu, 19 Nov 2026 02:33:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795055622;
	bh=xsNtKJgxoBDEWNSjcFjTvUkXvFmJ/5AvqzmVS9QQWkc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=twouVtt6CNgOvNspDuja+X2iXVpALDFkbg8eO+UWJMXfSZ62o/482Qwt9H4IVcWzK
	 PBlL20g+7HupQWCMlLxLu5HDZeZovgsDHZcpBqp7YuidYUWMJtEgF8pEpBrZlTpLu6
	 Pt9SCVU8E6n6vp41dcJNY6O2tOvhW3pOPIbcdcLY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chuanhong Guo <gch981213@gmail.com>,
	Linus Walleij <linusw@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 1698/2214] pinctrl: mediatek: mt7629: fix the 2.4 GHz Wi-Fi pin mode array
Date: Wed, 18 Nov 2026 15:56:14 +0100
Message-ID: <20261118150119.729728623@linuxfoundation.org>
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

From: Chuanhong Guo <gch981213@gmail.com>

[ Upstream commit 0b056aef31602cd10d2b35adc4746781b4fb8609 ]

The wf0_2g group contains nine pins but only eight mux values.
mtk_pinmux_set_mux() indexes the mode array once for each pin, reading
past its end when configuring pin 78 (WF0_2G_HB6). This can select an
unrelated mux value or fail with -EINVAL, preventing the Wi-Fi device
from probing.

Add the missing mode 1 entry for WF0_2G_HB6.

Fixes: b44677375fee ("pinctrl: mediatek: add pinctrl support for MT7629 SoC")
Signed-off-by: Chuanhong Guo <gch981213@gmail.com>
Signed-off-by: Linus Walleij <linusw@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pinctrl/mediatek/pinctrl-mt7629.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/pinctrl/mediatek/pinctrl-mt7629.c b/drivers/pinctrl/mediatek/pinctrl-mt7629.c
index b5f0fa43245f1..5a47f57921955 100644
--- a/drivers/pinctrl/mediatek/pinctrl-mt7629.c
+++ b/drivers/pinctrl/mediatek/pinctrl-mt7629.c
@@ -294,7 +294,7 @@ static int mt7629_pwm_1_funcs[] = { 2, };
 
 /* WF 2G */
 static int mt7629_wf0_2g_pins[] = { 70, 71, 72, 73, 74, 75, 76, 77, 78, };
-static int mt7629_wf0_2g_funcs[] = { 1, 1, 1, 1, 1, 1, 1, 1, };
+static int mt7629_wf0_2g_funcs[] = { 1, 1, 1, 1, 1, 1, 1, 1, 1, };
 
 /* WF 5G */
 static int mt7629_wf0_5g_pins[] = { 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, };
-- 
2.53.0



