Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793208608;
	b=tY/LTv1QqXOLLFt25c9LfiVQlE3LRUVKf92iHU0QWfXNH87lOUsceay/NXi/oKyPJZzg
	 KpAUkl1dYk/2CF7FQZNAlG/e1W4zcop7MvbmiCq3kqsraPvMGaE8pB1kUW4gC5XBUm+Db
	 n4/rQBn+kR3XR26HcL75BLoSaVBFLFo/w1CInyWDPdW0ckYQLAytG/3Vj6YEU9T33rF47
	 /02K/9S++q5yFa+C7Eycxr9Jj2lgXg6ziNDCSLfMP/Nl0GEiX6M0SE7hIe8FxFZOYV1jR
	 3/I1gNwyFjncj6N/zXyCZIDhS2IDjaaA/KtIVa75Lo6HvtkKHeA4tFpukm6YZBjw0og==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793208608;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=vBaKCMPRwEELCESWIh8a5wanNx33wT0aKRye2MaGOi4=;
	b=rlgffqzDa5E05YhkRaxNX7+hLH+2z/vDbobr99ZAZIcmqS+WnJ20a60pBy3J9xa29xC0
	 AKbjb8x4zP1HV/Za78Tm4R5yhl2+h6Ep9sQPvGtu3JGJy3i6/nY9v9KUorqL6UikIfLL4
	 W2kLpVkPMZPdutC6s/nTKRC0n7ECkrtkhpF4DRoCINIuurVmm42J3J9di3KyB5sw/8ALr
	 o9Clx02hUPbyd4LZN5/4MgvmyTLpYrSyYAx8jWZTmtxxN6kfQNVmQbaoK9k6L0Dmpa5qv
	 kpNUHSvFWOtGYgcocCcCj7ERSvOUIv1NkJ1hg4Jh6BjfOnAb1YRPZL+ONaNWjkRB1yA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=v0CoA6wy;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D1F0D606A31F;
	Wed, 28 Oct 2026 17:30:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=v0CoA6wy
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2D6D31F01825;
	Wed, 28 Oct 2026 17:30:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793208607;
	bh=vBaKCMPRwEELCESWIh8a5wanNx33wT0aKRye2MaGOi4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=v0CoA6wy48jpuJ39aKPZUqPwBFCwy6rJwanadAUO2SNmEweGZfafXpf7Xz0kv/Ijq
	 yBiDlIInhqFG3+2jE2GmLvg6lJnpPO+eiFmSJU3VMowVfLSFPotjhfPA4/0ytvcyvk
	 5EIdKluAI6OkZ4NNQLwrYuRoq5YnEqBiUzGQHwkw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hongjian Dai <daihongjian@kylinsec.com.cn>,
	Andi Shyti <andi.shyti@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 178/516] i2c: at91: release DMA channels when probe defers
Date: Wed, 28 Oct 2026 17:55:30 +0100
Message-ID: <20261028170007.721886213@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170003.522232767@linuxfoundation.org>
References: <20261028170003.522232767@linuxfoundation.org>
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

From: Hongjian Dai <daihongjian@kylinsec.com.cn>

[ Upstream commit c98bf3b86609a18ab16d067280257326e557c636 ]

at91_twi_probe_master() can return -EPROBE_DEFER from
at91_init_twi_recovery_info() after at91_twi_configure_dma() has already
claimed the tx/rx DMA channels. at91_twi_probe() then returns without
releasing them, and since dma_request_chan() is not devres-managed the
channels leak on every deferred probe attempt.

Release the channels before deferring the probe.

Fixes: f7eeb1af8537 ("i2c: at91: release DMA channels on remove and probe error")
Assisted-by: LLM
Signed-off-by: Hongjian Dai <daihongjian@kylinsec.com.cn>
Signed-off-by: Andi Shyti <andi.shyti@kernel.org>
Link: https://patch.msgid.link/7D85C6CB6BF0A82E+20260929164340.41628-1-daihongjian@kylinsec.com.cn
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/i2c/busses/i2c-at91-master.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/drivers/i2c/busses/i2c-at91-master.c b/drivers/i2c/busses/i2c-at91-master.c
index b7787033b9e62..d2f7337a0d5a0 100644
--- a/drivers/i2c/busses/i2c-at91-master.c
+++ b/drivers/i2c/busses/i2c-at91-master.c
@@ -920,8 +920,14 @@ int at91_twi_probe_master(struct platform_device *pdev,
 	at91_calc_twi_clock(dev);
 
 	rc = at91_init_twi_recovery_info(pdev, dev);
-	if (rc == -EPROBE_DEFER)
+	if (rc == -EPROBE_DEFER) {
+		/*
+		 * The DMA channels were already set up above, release them
+		 * before deferring the probe so they are not leaked.
+		 */
+		at91_twi_dma_release(dev);
 		return rc;
+	}
 
 	dev->adapter.algo = &at91_twi_algorithm;
 	dev->adapter.quirks = &at91_twi_quirks;
-- 
2.53.0



