Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795030677;
	b=hMVot5t79jsrf+o5pzzPIYzOlG3aJ/M6vfawZ4J1obuSMLQB923p5NDqTYZ6Qp8uV6fl
	 QDNa1vAiNCAG3jpOBwYkFv+GR0Pj0UUnPqribYlkeuVCmelhWfBswBYPfzbwAG1lsa73c
	 CoJRTXObZ1LYB2c1MtbDnB9n33mUQdsdkHPIZz8PJsRHEj88csb3SlyGHHsKkAXQFWUhL
	 RnR526IYNed9ez8tBVXGM+aw0oI/sX0+3tD2A0OxyuPSYHXCld+yiq7OtllXn9QnnHWqy
	 J3a6lG7ahIsq+q7nwFyRxNgFAb+3aIpAUl3QdK76w9zT+kYxjxc6I5UHimbN02+NXDg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795030677;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ol4dulk0NtBPmmuA2jHwUkbcK/fMQpWIHjCx0zPb1Vw=;
	b=ZkbcmovzItlYoxmh0MRB2cjmvA27exXuytjrH1ine52xNszl0RGd2o3Rcg3CdKnyo8ot
	 koz1ZeonN80ts2/FUPMg+Vf7B/O1r7v4l6iW8MAPCtkoom7R+wAc9ZLYQAGLVFd0+55oL
	 vp9EP4pNQ+Bb5QKAszyKnN4alI3QDsZoo+eX2dfaduw9WmIg4fn3jRzBC3AdCs3oUeXto
	 JiSzGE2jcSG1CUFILvpBnkm87WqcUk/y4lew/kAEVWwnzaDltkY5dlMvAUROQSdFzYFuY
	 5auDmUxA+pkcoyz06VBtQOvwFdx0grAnh+tzGA8BYO+QtpE5wJmw7MTCbJKaY2XI1hg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=x6GfoGnr;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F4FC606A320;
	Wed, 18 Nov 2026 19:37:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=x6GfoGnr
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8DF6C1F000C4;
	Wed, 18 Nov 2026 19:37:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795030677;
	bh=ol4dulk0NtBPmmuA2jHwUkbcK/fMQpWIHjCx0zPb1Vw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=x6GfoGnrJgo5Z/vHtKRzZFTlN4WK7kJEyNlegLSm3DcWMzH6G/eYUa9OlFIIim/Vh
	 x/LssYZnfDZsdCHm0dqPkQs8hHa5myzXqx8okmunoRdy2W4xh15iPQkJZm5cQQuZCZ
	 7ZN9k4yfwGkQny+wFsvFELh+UCrbp310vmmREUxU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chuanhong Guo <gch981213@gmail.com>,
	Linus Walleij <linusw@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0747/1756] pinctrl: mediatek: mt7629: fix the 2.4 GHz Wi-Fi pin mode array
Date: Wed, 18 Nov 2026 15:47:54 +0100
Message-ID: <20261118150039.316249325@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 98142e8c98011..b536ac32e57d9 100644
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



