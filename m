Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795018263;
	b=GzyQ0kQrr4bZGL6ScWdNkX3csRaQZNy9durdclSpkgCHlsLH7yP1gVRBY6otDDkHoJin
	 sKL5p04juYYqjiEhLe/1EA4A9dRujaStg+mf6KgX06ssyh6iNOf23UO48ocIuOOKkjz4u
	 jbvpWKr93dz1iRuc60hYZQz+haknA/5bTT0uoaGnu6yGe+jgtWBxjgy8T6ti0T46gV+97
	 LtUdOrwRCV1HgiLFf1xaJvD8kYJhDriOQZ+mQkS5Z9GfHhs2dHauM3CmVYH2r8YFNGc+U
	 fPS6OLNalHIkMrE6Jl0877/xWbpPsX9h4ASW01OI2OvN4YO+hHbnKsC6tT2tLUosWhQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795018263;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=/GHkS/k9YfWv25LAiWrFdAz0VFC4bSR0FYLbknmi9/M=;
	b=LgJvkgmbTU2Xl+btDhyjX5biOxzAdU5gZPkNrfmHSKa6agcK6TjzxmswRANlzskBDuaV
	 HlZCcgF+GS+rSpsOxJITx0tMWYjZK02bO/FKg6xtENeEQFVIc7iDYZoFV75Aj7v+Y1dLw
	 litGFdLw9bgZr4Lmy5FKrwuqANDceCMyelKVLFArKmU8g+7REXOfkmznzpzuq4a28uQQI
	 D/O7Q3sDJjYn3hvKF32zemNbF4SYNBxujut+ONAK4l8+5ec83UVBYL4Op6elBatcDJlAz
	 rnHZz0HgeC8tG4uG3+pFeC8JqUlCvzghEnDc8gfe1tkTO12y0KlHa7i+Ax7jUK7SwuQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=CndbbCDl;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 75F95606A320;
	Wed, 18 Nov 2026 16:11:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=CndbbCDl
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A51851F000C4;
	Wed, 18 Nov 2026 16:11:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795018263;
	bh=/GHkS/k9YfWv25LAiWrFdAz0VFC4bSR0FYLbknmi9/M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=CndbbCDlBHgPi+yKbdI3bk697Zbz+N9zl8FuAt2KP/1kCIlelJtSiecNKUNjDyHjW
	 FW5wuFbSgTYyVa7eqQ+jBFDroKmt6Q032IDiANCHi3Sbc0yGUUPtdEeO5C5Sxd6jEh
	 9mTermSlP5SKMpFaVxaDLCCv62HuCiJGwaH/2EvA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chuanhong Guo <gch981213@gmail.com>,
	Linus Walleij <linusw@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1137/2651] pinctrl: mediatek: mt7629: fix the 2.4 GHz Wi-Fi pin mode array
Date: Wed, 18 Nov 2026 15:39:37 +0100
Message-ID: <20261118150328.939497461@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

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
index 385d66b8e3fb6..29a4c171e8b60 100644
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



