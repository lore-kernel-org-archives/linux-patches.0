Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793213676;
	b=pe4PpT8WY3zHrBNEW2UaizPacBcZwrGXUFvgupsP9upONuX5mOkRSuB8Y2MAhAoHrTZ7
	 E2zhLwFuxsjfQlgg3qJH9M2Cd3XjYKQFMThbY7rBi6SAjwsBZmKuEKoMHbwJZ/1bUSFlx
	 MUZRcfxCfhfdzRv6eEhsAZeA0QCt5hMEVBSSeSWJP16TV1w2hx45iWafuQ0G5OuO3I+ji
	 i+DFjh92QkQJSfxyCz6f9OEFBbeoVzEmYsyMC0KA+zzEiFMinQ/utfv59bgcD26OxjaQr
	 87eO0WtHglT7H1QF4PA9fHM03aRN/e6CuREHV4H8cvLkM3mPZR++yyHF7W48YrUF4BQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793213676;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=0c46JenrhLMEiaJD6txSVcQntDk3lFnd5QKGK87MR7g=;
	b=ockhK9yCiiVKdaHbxRrGkIr6qLAnq5oshmpq/foKNZKH/CHpPzjJHPfUv6Zq+nLDZHtU
	 KTG7qEKkReI8Xx79wqzkXbRbJ2BiUyaUBZCqSosSS9MpTDW8WNfJwflmNyNnbN8ifsphY
	 L/oWg3VzNhNhEJKdVmYTj5jBiKCneeeP6yT7bIPyplwc9S7cZ7NpB1qEbaVFNmnDJiNEG
	 3r8IGJwWiIr+BMD1hKrgs674ZoR8+MI2Ov38lHQ8B1rliwHWLE/dCTsKKbvCS0c7Z4DBx
	 B0xJjp5B8R/TS/i21rnQbwjDBlDQEOJFH3ud5QF6EHLsRFC/eT4T0m7lOgkQcEVA1dA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=T7OnyQI2;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9BB4760A2618;
	Wed, 28 Oct 2026 18:54:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=T7OnyQI2
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EEEAF1F031E2;
	Wed, 28 Oct 2026 18:54:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793213676;
	bh=0c46JenrhLMEiaJD6txSVcQntDk3lFnd5QKGK87MR7g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=T7OnyQI2KmhKi8cAfDJlS4t+S6WdwwNtL+oro2DIcZoeR3d8xgenHZlfSRftSmySt
	 NTxfR6RaI/wGnEVVk59uQEMll2GIebNOfFHXTeSxGp2MP0usWp4kY/LvN+ntFCEEc1
	 RQmaO2jx/2wivJcU0qDZOkgDpk3J8ncD1kQGhTvc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mads Bligaard Nielsen <bli@bang-olufsen.dk>,
	=?UTF-8?q?Alvin=20=C5=A0ipraga?= <alsi@bang-olufsen.dk>,
	Robert Foss <rfoss@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0591/1887] drm/bridge: adv7511: fix crash on irq during probe
Date: Wed, 28 Oct 2026 17:44:47 +0100
Message-ID: <20261028170512.869462274@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mads Bligaard Nielsen <bli@bang-olufsen.dk>

[ Upstream commit aeedaee5ef5468caf59e2bb1265c2116e0c9a924 ]

Moved IRQ registration down to end of adv7511_probe().

If an IRQ already is pending during adv7511_probe
(before adv7511_cec_init) then cec_received_msg_ts
could crash using uninitialized data:

    Unable to handle kernel read from unreadable memory at virtual address 00000000000003d5
    Internal error: Oops: 96000004 [#1] PREEMPT_RT SMP
    Call trace:
     cec_received_msg_ts+0x48/0x990 [cec]
     adv7511_cec_irq_process+0x1cc/0x308 [adv7511]
     adv7511_irq_process+0xd8/0x120 [adv7511]
     adv7511_irq_handler+0x1c/0x30 [adv7511]
     irq_thread_fn+0x30/0xa0
     irq_thread+0x14c/0x238
     kthread+0x190/0x1a8

Fixes: 3b1b975003e4 ("drm: adv7511/33: add HDMI CEC support")
Signed-off-by: Mads Bligaard Nielsen <bli@bang-olufsen.dk>
Signed-off-by: Alvin Šipraga <alsi@bang-olufsen.dk>
Reviewed-by: Robert Foss <rfoss@kernel.org>
Signed-off-by: Robert Foss <rfoss@kernel.org>
Link: https://patchwork.freedesktop.org/patch/msgid/20240219-adv7511-cec-irq-crash-fix-v2-1-245e53c4b96f@bang-olufsen.dk
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/bridge/adv7511/adv7511_drv.c | 22 ++++++++++----------
 1 file changed, 11 insertions(+), 11 deletions(-)

diff --git a/drivers/gpu/drm/bridge/adv7511/adv7511_drv.c b/drivers/gpu/drm/bridge/adv7511/adv7511_drv.c
index 3e6fe86049599..ac8bc356bcac0 100644
--- a/drivers/gpu/drm/bridge/adv7511/adv7511_drv.c
+++ b/drivers/gpu/drm/bridge/adv7511/adv7511_drv.c
@@ -1292,17 +1292,6 @@ static int adv7511_probe(struct i2c_client *i2c, const struct i2c_device_id *id)
 
 	INIT_WORK(&adv7511->hpd_work, adv7511_hpd_work);
 
-	if (i2c->irq) {
-		init_waitqueue_head(&adv7511->wq);
-
-		ret = devm_request_threaded_irq(dev, i2c->irq, NULL,
-						adv7511_irq_handler,
-						IRQF_ONESHOT, dev_name(dev),
-						adv7511);
-		if (ret)
-			goto err_unregister_cec;
-	}
-
 	adv7511_power_off(adv7511);
 
 	i2c_set_clientdata(i2c, adv7511);
@@ -1326,6 +1315,17 @@ static int adv7511_probe(struct i2c_client *i2c, const struct i2c_device_id *id)
 
 	adv7511_audio_init(dev, adv7511);
 
+	if (i2c->irq) {
+		init_waitqueue_head(&adv7511->wq);
+
+		ret = devm_request_threaded_irq(dev, i2c->irq, NULL,
+						adv7511_irq_handler,
+						IRQF_ONESHOT, dev_name(dev),
+						adv7511);
+		if (ret)
+			goto err_unregister_audio;
+	}
+
 	if (adv7511->type == ADV7533 || adv7511->type == ADV7535) {
 		ret = adv7533_attach_dsi(adv7511);
 		if (ret)
-- 
2.53.0



