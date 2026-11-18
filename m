Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795025053;
	b=eGpcx2fImSXs20fIW99RQjAPJpsGpXsompL/E4cVK2x/EVCCU+ixjWaEXyUO93EfhVCF
	 4r5L25dW9iUsDx/+p29oPd8gMioqNmavPv7DuQ/u3qwmAOZNTFE9d3hb0yRAsLhG7ltUp
	 wMHmnAlsKk6gvQGVoc+1Z5wkGSTxBaecmHrl3rwVcODwts8ZWFd5q/tBt74vGjbAipFeb
	 oTotFYCLRWv/Md7TYEt+OKh3GI90TZxrdRB2IDD2KVx3/c1yJ+jn7sKE7pZDixbfroZGM
	 7kPKWJ4jNeQMo1w+dtrY0cwF1P7ypWyuvvZQ4ehY+7u5tfv52eliEBNQs062LS/84xQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795025053;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=LppppZuqkoDHM9jhDXjtmHVz5rTSf9pOgLXy4uNDksY=;
	b=0enb00OxgDep32TS6P80rorhHdIabKfEETazlGlyccOfoBhhZsa6wQwAYXtuAEBcF6Qb
	 lSFtMnkfRJF0+GMdi4FznUYtM5UyKa6dCjbL0hWL5f7OVoDRGlWKOXjFLR8YPPGyLT1Ee
	 ZKOXbpOyILUz45yY521yHGdSUlmJsAfpI2zycB5NjnIET/KuiICHWPTXsWfDPAp/uuQKE
	 bISsgf+jXZMduZP3HUqjUP7zsPlMmZGiUlXsmnEKBllb8kojtHWecSsTqbBzzX5TjJGSk
	 r42aV0qFVZbUK8x/Lj+CnbC8rJg+7f1a2jUY/VzYJ1A2Nk0G/aXqvt+FLZHEq6+M4bg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=nTXCus2H;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F3BC2606A320;
	Wed, 18 Nov 2026 18:04:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=nTXCus2H
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 580741F000C5;
	Wed, 18 Nov 2026 18:04:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795025052;
	bh=LppppZuqkoDHM9jhDXjtmHVz5rTSf9pOgLXy4uNDksY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=nTXCus2H7aL6PqqkSi6X1bBZalcgQt6Dm5ArXdcqMoQBWVxp6fJhK2EFyrX0UhXIv
	 ZvxoSpWPwDAw5h1A5wG0CYoOD9fJ+2GSoOm1VJgEcKVLrf8hG3DZOUV3Bk2Hrcy12W
	 woWk4+/hdwIXaCJlkJeSrtI3IDSfAuF35ctEDv3M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chuanhong Guo <gch981213@gmail.com>,
	Linus Walleij <linusw@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0944/2151] pinctrl: mediatek: mt7629: fix the 2.4 GHz Wi-Fi pin mode array
Date: Wed, 18 Nov 2026 15:44:39 +0100
Message-ID: <20261118150156.861709808@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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
index cc0694881ac9d..6daf9e55b5947 100644
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



