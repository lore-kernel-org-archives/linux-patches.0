Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795061080;
	b=Ou3AF1u/4IrTKXlYC4Tfrr+kfgbeiQZffQfEWza5Izey8Tu+kNkqQjZaQ2PFn3VKqgW8
	 mMd7R9b9orUaMhUweWjfOSZezZ26aUzqEzl6raVG953DhDgQJuyQ3SY0VMygrqDp2bCkC
	 FjAUYY1nobLzvQ7mDjcPfnEk73XDzyjd2UNocFovbCfFPOqMw0cGcTuqwshv/TmPk0gnR
	 GGov0SyB1oRPrjUVTr6WjHJLK4zMKkKlPSKGQf/jZZfvlJYJQL0mhQiPfm7pfzSYkK2Ho
	 WXst0oxlqXZ0I/TsTutgcto3htJjdP+71GRsONu9+2/J/N/up7y/foRaTBUqbzcnfGw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795061080;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=dDEWoGIkBaXLKt/D0COQvrTzKZDqZg684Ujw1Ml4lTo=;
	b=HqbhMsY3h6oP6ZV77Fy1iW/aNvhbhU/Q/ZXCL85Z7ZxVGaWmCldm1ixMqKu3ARb6+a1c
	 mRt8hc4ibvQ57HbLJwvY/hdVnCVDgDtjYGI+kdEOLcNiQ3gvR2jozKwVYZWEscaoSfKVW
	 LZ7oQDzWzcR3B6EgmDhK0Z+Hj/eXyz9Qv6eYEfFdEJRDsxd1Wb3bnCha6RvsAKOvbMt82
	 /ft0dJx3od7cQuLvVgtOr/BHELZX/p0d4qv3WTFx9C6ww7gHoEDnm74U9vPeGuxkLRkgg
	 /YejjqCTc+oHudTGcZy7mylg++ETIQSY9hMsw0qXmD9uzQUiZ6lujfM4KYsMcdvkZBQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=uYtWmJaG;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C48D1606A325;
	Thu, 19 Nov 2026 04:04:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=uYtWmJaG
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 256151F000C5;
	Thu, 19 Nov 2026 04:04:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795061080;
	bh=dDEWoGIkBaXLKt/D0COQvrTzKZDqZg684Ujw1Ml4lTo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=uYtWmJaGF52L2mJcWRMYxzJOJRtx5xQ0rCQxQETS/1zsIkDCrcmWQiUtqLCmrKX3p
	 3hPKQTFA+qmqMolqwEBSTOcCXYSGm4lu52TabmUMPFY2pa+GKsZZ9TuQku+Ohzo5Wz
	 CI74rEkom1Q4YlZ6zSNaRhjFrEGt7RKK5VPBJ84c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chuanhong Guo <gch981213@gmail.com>,
	Linus Walleij <linusw@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 1427/1848] pinctrl: mediatek: mt7629: fix the 2.4 GHz Wi-Fi pin mode array
Date: Wed, 18 Nov 2026 15:57:45 +0100
Message-ID: <20261118150019.277607270@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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



