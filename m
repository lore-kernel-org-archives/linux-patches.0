Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795048964;
	b=EOxq3T9dCQu0zadqTJClpFx2KxDwfYt4cazOBF2iUbh97WslfDklzM/2pi3j4sQfa3OH
	 cyqKyNvXVq4v0RlvDjtXbRDHmo2cRaYNqzPs/IuqelXh+ZXv8CQtZ1H8P1Es5wyE0hFFe
	 I+10MAZ4NJXZcmGsUDeu6pSK2kkz9/tewhJqbpfP6O+yJ0gVE+PHPTp559MFyzy/Al+bW
	 MI07sfoGpBk4Y54HX28ZHG9GfShQ7CBUr6YR5IwLzvVjixt7WgmJnNQZ/xGflRN6rqKWV
	 u8R8XNU9AbARse2UF+Xba5bHFRsvmAgjYALNuLkTRkEjdVcjH+63l0lqJ8INnjXkC0A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795048964;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=YqF4faKcVhrzU2zb9hFupWpqcwXzGbL/lXPyKQoIZYU=;
	b=ZxfyHY8ZRu7xhEUVg84pXGtQvBggtU4mOUZAS6gi2VioDBkAp4FUHypa8umlGh544YGs
	 qrWNmOKdF7DBfFRIxsZBba/2o8RMG1B12F7ZKDqMY/NoMEXpaDTF1AnpNKxQZTOaEkmM5
	 AAaIejSbP9X/MV2C8O9qufgDMcQqfLq6HNWupflqSD95YX/wChfpkYkKSFjqe/4LO3oGE
	 MQgozfkxY1tKKVzhrGaRQjak6aAzRTlFy2y0UPowy04a9ECIqfXN3VFTPuefrjPXgCTyR
	 knwZpV7u07klOwwaqamAzD6lt3iSR589R7WBsl8mvg9PLTWoF9as/+Iqa5cNRdVpxaQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=x5vqJTPU;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 48C97606A325;
	Thu, 19 Nov 2026 00:42:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=x5vqJTPU
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9A3741F000C5;
	Thu, 19 Nov 2026 00:42:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795048964;
	bh=YqF4faKcVhrzU2zb9hFupWpqcwXzGbL/lXPyKQoIZYU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=x5vqJTPUh3foAvtQnRcORISVFa97oACOEIpb1VCxwcIUzOfPYvK3hO6nStWX1w0Gu
	 RVWvxUtsglLrJb0XpYDKiacV5DyAM8FeYw1vgECpFxUS6loaVNtBm5uRQGua9NN4Tp
	 CBn0QOP81eIrxiOcRDq4/zsM3FXyRj/lF+ARujR8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chuanhong Guo <gch981213@gmail.com>,
	Linus Walleij <linusw@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 2165/2857] pinctrl: mediatek: mt7629: fix the 2.4 GHz Wi-Fi pin mode array
Date: Wed, 18 Nov 2026 15:53:19 +0100
Message-ID: <20261118150319.357070801@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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
index 2ce411cb9c6ec..a6b85c52ef11c 100644
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



