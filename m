Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793829389;
	b=d1TS1JcHwjKfeFgmIV5pbaNU2mHgWNu/28KhsrNY3BXnnPXPQwFr7oCm1dmA1dfbsSJl
	 nEFysivvSLFF04ptn4+tk0QBII/VhOo537IEmAPO1Pbk+B5agnxh8oJ2qPrC1IuUM/s9I
	 IR0RRh5B82TaTvxqbRWR8mu2IBtsJQr4wClle04niww9y2Cx6XgdQDvAiuvF/tM+MOvGM
	 nWlhkbKQkqpkxwCMhY4q27e1PKjouZlbj2Cx/pQDCHbWmOwUBGqzElmhiJuS0BG9b7HcB
	 caZX9nmnuRaeyJdXjsO1W/0UVTKcf8bGMgjoVti8Vr49Wj+M4hwHi65hMMFbVswMmKw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793829389;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ULD2xrTHuPin6OKwXqLLOdnjIyeWJcMPxShpM1zzUVI=;
	b=JGHlhPeXEqgBtb9IGEjxuQy3Oy18QrdodMuWP/re5n/2i3HSQOLnX1Y7l/aL5vlZ3vV8
	 5BhAZ2gJkr6SEINhQVUTYIMVIekLc+j7yNbVZu+C5z/sCE1NIZw5Ri+5pYJ3gXAkJxyZC
	 XObTxkXkCGAFT465qfUHXgghJVjAnqlalSN2WWbqJLPnJbmt4ZUGmc8oweWNMS6dsmfbf
	 AuEK8QjW3LRb/4gLCXU8r54OcEhso0RgMD6jpRtMOvzSTK57ICOFeMr7TmhDEo+ijWcbo
	 je+nnMEhNjVwOh9JloBwXaRi/4kQHyUs9hGz8xln+12QBSRWZF50EXOyr3WphVIAhpQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ruhuvKEx;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D2B9606A865;
	Wed,  4 Nov 2026 21:56:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ruhuvKEx
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D4D731F000C1;
	Wed,  4 Nov 2026 21:56:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793829389;
	bh=ULD2xrTHuPin6OKwXqLLOdnjIyeWJcMPxShpM1zzUVI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ruhuvKExEtG5cn6k9MA+O9ISY/PPO4daDmFujttUuD416PzHmrlg5mp6ej96Vuzrl
	 BvaxKlu6mAaxIW1f6q+P8ZdAb4rFkAXLRdr6Sq1Y1HhjkLQumAaNphIh5Qb3c6ZW9k
	 x/XiUajxsplqrP1c2PF0KHr8Y5cdKzczthEpUwLA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ruoyu Wang <ruoyuw560@gmail.com>,
	Patrice Chotard <patrice.chotard@foss.st.com>,
	Krzysztof Kozlowski <krzk@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0056/1005] memory: stm32_omm: initialize ret in stm32_omm_set_amcr
Date: Wed,  4 Nov 2026 15:56:29 -0500
Message-ID: <20261104211045.161841387@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104211043.516122098@linuxfoundation.org>
References: <20261104211043.516122098@linuxfoundation.org>
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

From: Ruoyu Wang <ruoyuw560@gmail.com>

[ Upstream commit 1527acf2295cf2d6e11e3e9b121d63709667e6e7 ]

stm32_omm_set_amcr() returns ret after checking whether the AMCR value
matches the device tree description. On the normal matching path ret is
not otherwise assigned, so initialize it to 0 before the checks.

Signed-off-by: Ruoyu Wang <ruoyuw560@gmail.com>
Reviewed-by: Patrice Chotard <patrice.chotard@foss.st.com>
Link: https://patch.msgid.link/20260617182202.961843-1-ruoyuw560@gmail.com
Signed-off-by: Krzysztof Kozlowski <krzk@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/memory/stm32_omm.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/memory/stm32_omm.c b/drivers/memory/stm32_omm.c
index 5d06623f3f689..2a1af229d2444 100644
--- a/drivers/memory/stm32_omm.c
+++ b/drivers/memory/stm32_omm.c
@@ -47,7 +47,7 @@ static int stm32_omm_set_amcr(struct device *dev, bool set)
 	struct device_node *node;
 	struct resource res, res1;
 	unsigned int syscon_args[2];
-	int ret, idx;
+	int ret = 0, idx;
 	unsigned int i, amcr, read_amcr;
 
 	for (i = 0; i < omm->nb_child; i++) {
-- 
2.53.0



