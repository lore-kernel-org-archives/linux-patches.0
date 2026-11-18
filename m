Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795040570;
	b=mtN86jOcshPn12iHi5QLIC/ANWfZPC1Ks0vqZowP0w8Wz44B5AX0i2imrqmBYBX4YN1H
	 QiZacVET4RrcTLOe9FDD41U6q79d9/Is3UM5JwCPQSp6HLfKbDO7c8viHn7N6RKnY26lT
	 tzFlbBQ5q1ApPgFLbPTYHlprL4DKYjhl5Q4avKhnfGvADE8modt3tEa0aWpB9Zyo4RE/c
	 yfWM9kfRcGLTknYn0HWrQh2cs/ND738DmiVvfXxJV6cOi88v+fUiVaOzfqkq6m0LIAc48
	 IN7R8McK9OBsx5cfPVyT4z9RR1TWu+Ht1j64aGvjsr89HQn+ER3xzAmkiduJD75weUA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795040570;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=/u/K4+AC098m5YpoLBkliNBGDlczttiamlj9axMHDok=;
	b=Enbjtucd/aB6tM1Ipxkx4UVkv6KtshPKbkcq2sMv9BohSBI6jNf3HdvYr2B8Pkh3JdLE
	 Xr0PZnpBfZR5T9jGJwIcxuejbsSM0V2jHunUhhS1JvLgv3RdnLyE16X9WTzXzk7KAAO7M
	 PMdriwq0r/CVn8ucYB1S9o+5LqoTcOf3PK5olTdcA8IWsWmPhKQyhimQPPBi42sIMatcP
	 Bnvm5PXAEo8EJNUCvSoI+uTo6xb0c77VFh0UKXcn1W3xG2fR/NNx4TOjt8cMJgAYEF1kL
	 sfbTYD8rXPEXl8Bnx3gqFVSpTDfMcIxoUWCejIoiyeEiqkPv4NAri/kfWkp+QOQWGoQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=pvqupD2X;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B4CC6606A32A;
	Wed, 18 Nov 2026 22:22:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=pvqupD2X
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 16F9A1F000C4;
	Wed, 18 Nov 2026 22:22:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795040570;
	bh=/u/K4+AC098m5YpoLBkliNBGDlczttiamlj9axMHDok=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=pvqupD2Xvb0jZB/cELkJ9toOQl8V0X8VMjzvZuqXEcMRLFXzAIlSswSG0IwiQvY4O
	 B8DNS8k40/QIpRcCUOiMD2yZrmfTVP5/4EdnGsQjE/S8Fenhd+rCq/3IloLbtDNN1k
	 I8RV1QwWSCb66UL39Nqjut6JwoHeHhKxkvW4GG8Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chuanhong Guo <gch981213@gmail.com>,
	Linus Walleij <linusw@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 2505/3318] pinctrl: mediatek: mt7629: fix the 2.4 GHz Wi-Fi pin mode array
Date: Wed, 18 Nov 2026 15:52:07 +0100
Message-ID: <20261118150436.525666494@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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



