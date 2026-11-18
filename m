Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795056525;
	b=xH2hknklhL3gKUDqBWV2izsKue/DzQjmbksGRxw9XpNN/lPFgFMt9NM0qBtdZLJC4EJx
	 PGLbuhe2J+/QO+L4WBZzuiD9bEZ3Fd+7CAVxmpMHeLYYPFZm0g3jZ81XuGH0e+fJ/HaQZ
	 lvIOYhqu8NAwnOteqn6kDiuUD//QQQBVBAUyy/n8tuOQm5LmnuQ2AjEGR39oz1xBiOI8Z
	 ExP0jKq96VE0hF8bkJ7ewYCXYbSs5cUsDSA2KEbm8toIn7POLcKSBqvyjJXInDM/Iu2hC
	 FF8piatD+wPxsdy/A+/Cn+wHdaXzfbxRU/TiEwltEmarGh9z6IqoLfmGItGTVqVUXrQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795056525;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=AeTBzAs0rta8GiMpoRFu/18ysJbNGb+RNBGl2cfBeOc=;
	b=NHuI/cafDgeSVPuRtbDGVQrjJGl/4GIka0KL9ALLhcTSMKEWadr3V+uTfjgGZGFvTK7+
	 o6YqZemd12jdtCYFbTXLWk0dfDF75BwE4YRvG0CXKCQDweZrLGa+q2w3P/cORb05MecaY
	 k2ZiiI1K1bNUNTWZajwrUAlNhBPvjGAj0xJvbrjup/ATXSTvYOlIgq0AjPoHvqpbqOKVh
	 2+xJWPF5e9mgGoXe6xjXRYS/SAhRTg4Y3xfKO2Gee53TdVoAtdKSRiagWXe6PxjxbXVwO
	 MVqUn0g7Zwrfo7zh53QCCGXMyqbgzzS34yvEZMP38OJRdr35Bw3lZug3MCS2mEdcc+Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=DvoqHQj6;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DBC5A606A320;
	Thu, 19 Nov 2026 02:48:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=DvoqHQj6
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 366A11F000C4;
	Thu, 19 Nov 2026 02:48:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795056525;
	bh=AeTBzAs0rta8GiMpoRFu/18ysJbNGb+RNBGl2cfBeOc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DvoqHQj6lnAdB3BRp18EaCvHuLci6GxxedUeatDiX/T11bkbgo9reKk0QM6cvOUAO
	 RMWNtMnx0TPnK3elr6Nk45x53vmZXYssIxC0JU8knWrY6xvTec1xtUW7nazyMjwegb
	 2V4iCmENu1WjoJX1jZkUlnCGj0zIiJV2+2FtojnM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ajay Kumar Nandam <ajay.nandam@oss.qualcomm.com>,
	bui duc phuc <phucduc.bui@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 1992/2214] ASoC: mediatek: mt8195: Propagate IRQ lookup errors
Date: Wed, 18 Nov 2026 16:01:08 +0100
Message-ID: <20261118150130.504508681@linuxfoundation.org>
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

From: bui duc phuc <phucduc.bui@gmail.com>

[ Upstream commit 9d5dedb285fb61a40e04f337d9e06fc59c065857 ]

Propagate the error returned by platform_get_irq() instead of
replacing it with -ENXIO.

This preserves errors such as -EPROBE_DEFER for proper handling
by the caller.

Fixes: 6746cc858259 ("ASoC: mediatek: mt8195: add platform driver")
Reviewed-by: Ajay Kumar Nandam <ajay.nandam@oss.qualcomm.com>
Signed-off-by: bui duc phuc <phucduc.bui@gmail.com>
Link: https://patch.msgid.link/20261014112752.683032-12-phucduc.bui@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/mediatek/mt8195/mt8195-afe-pcm.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/sound/soc/mediatek/mt8195/mt8195-afe-pcm.c b/sound/soc/mediatek/mt8195/mt8195-afe-pcm.c
index f894e74317756..d1aee458fbb99 100644
--- a/sound/soc/mediatek/mt8195/mt8195-afe-pcm.c
+++ b/sound/soc/mediatek/mt8195/mt8195-afe-pcm.c
@@ -3168,7 +3168,7 @@ static int mt8195_afe_pcm_dev_probe(struct platform_device *pdev)
 	/* request irq */
 	irq_id = platform_get_irq(pdev, 0);
 	if (irq_id < 0)
-		return -ENXIO;
+		return irq_id;
 
 	ret = devm_request_irq(dev, irq_id, mt8195_afe_irq_handler,
 			       IRQF_TRIGGER_NONE, "asys-isr", (void *)afe);
-- 
2.53.0



