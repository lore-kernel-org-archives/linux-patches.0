Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795038284;
	b=CpycUH2JlNwGaxGnw+DMCtx6X2XCNlAEh10qQHgtTjwIam1qpfwLj1yB//T15RK0Ej+Q
	 7RWqvmK/8GCEoLRyV+KKwxSd5sOVRqbYxvtk7vIv47a6300yE9JVuVOQCitsOP03aEAqM
	 gxNpm+A+cPbNsMHPexPEpWkjMGEb+MMDIrL/FzkaBbBre67wDX7lRLqNXlkcGiq+ViIh5
	 vS1iSl9muhVajJ7fkOSNhoACuCMSejkKNHzxJnDUozae0utL9vFxV4I4NUhrZanuqv9ii
	 ZLYGAaI3bn5shKVxLUOc2qL5uwE0aFcCzU6FkxzlGl20nmyNdcVdoy9lMuCM09wGAEQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795038284;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=BJajV2RowAgSr68o5vzgFZrzLEnxwCkeEKqHiiyzcK8=;
	b=GR9oTQnHeSZzXB9Ek0lVa9yhWllMW/mI14OwH0PfWz65CLGHNi/eN2QZVWEWNMKL0qmP
	 BYJfh05lZcdRqiDWJ4y34iiTn8zFF8fEm8s88D+TEvormly+GF0EOnEgRfgBI14taNUTk
	 /bvaBdJuV8T7L056pYsm49nSpf9FazkDMyhJ5upxTyYWTQQKhsRXCkv+oDqA/Nm2sjvc+
	 bMQMcoJR1PM+aSYIU2+ftNOXTt8JjVKFiCgeLAPtgdUSzEIpZA0IdgqKyXl9flFkB+73Y
	 Vt4jWJXm9isrVd5zhKsWdbFGBUqpJkVAHqUNMrmZPK47m7apMj4HGEv3E0kjE/LFOPg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=x3HvcA+o;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5AA8D606A325;
	Wed, 18 Nov 2026 21:44:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=x3HvcA+o
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AAD5B1F000C4;
	Wed, 18 Nov 2026 21:44:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795038284;
	bh=BJajV2RowAgSr68o5vzgFZrzLEnxwCkeEKqHiiyzcK8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=x3HvcA+onK4Y2r9QD3ydZDgmFQyF89kH0i2+phsiazUMrnwM051/AvBipIo3MpXb+
	 B/hkv3fNLkpdnexh63XtVsdNUDGGPGMzSGEt2PZQdwPBREvrkB9lHnU1gdc+dONW3j
	 1Xdddq0esz2l/YIzr8XktW5rlntpuuY5G563rrQc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	bui duc phuc <phucduc.bui@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1688/3318] ASoC: stm: stm32_i2s: Drop redundant error messages
Date: Wed, 18 Nov 2026 15:38:30 +0100
Message-ID: <20261118150412.465368617@linuxfoundation.org>
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

From: bui duc phuc <phucduc.bui@gmail.com>

[ Upstream commit a6cdfb6230944082e7be64f9166eed64656b1162 ]

Both devm_request_irq() and snd_dmaengine_pcm_register() already log
failures internally. Drop the redundant error messages and return the
original errors directly.

Signed-off-by: bui duc phuc <phucduc.bui@gmail.com>
Link: https://patch.msgid.link/20260720074044.87528-3-phucduc.bui@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Stable-dep-of: 1b207c85551f ("ASoC: stm: stm32_i2s: request IRQ after regmap initialization")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/stm/stm32_i2s.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/sound/soc/stm/stm32_i2s.c b/sound/soc/stm/stm32_i2s.c
index 06a42130f5e48..4e4d8d0ed7bd7 100644
--- a/sound/soc/stm/stm32_i2s.c
+++ b/sound/soc/stm/stm32_i2s.c
@@ -1079,10 +1079,8 @@ static int stm32_i2s_parse_dt(struct platform_device *pdev,
 
 	ret = devm_request_irq(&pdev->dev, irq, stm32_i2s_isr, 0,
 			       dev_name(&pdev->dev), i2s);
-	if (ret) {
-		dev_err(&pdev->dev, "irq request returned %d\n", ret);
+	if (ret)
 		return ret;
-	}
 
 	/* Reset */
 	rst = devm_reset_control_get_optional_exclusive(&pdev->dev, NULL);
@@ -1136,7 +1134,7 @@ static int stm32_i2s_probe(struct platform_device *pdev)
 
 	ret = snd_dmaengine_pcm_register(&pdev->dev, &stm32_i2s_pcm_config, 0);
 	if (ret)
-		return dev_err_probe(&pdev->dev, ret, "PCM DMA register error\n");
+		return ret;
 
 	ret = snd_soc_register_component(&pdev->dev, &stm32_i2s_component,
 					 i2s->dai_drv, 1);
-- 
2.53.0



