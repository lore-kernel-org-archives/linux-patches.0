Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795052683;
	b=I8RnoxMVXqxDQNuxHsX0FuTyteUlpMW56xf9aR7GyGKuWiKcd090pDCDJGNpAhaAVIgc
	 mkaqBF2Dd2yT6H9imASE+NGPPDij5/sljLtwNgzfXXyoHxbMptWDDrZiPlazAjJ+8aL9f
	 mLz25F/WOUykvaoIG6pQzoEOGoUqKtqPwI+L0MOrIOh4OpVcE8sA8Z7uvteVoCAZMwUZN
	 xTH6d+TvyQlmxjuQe8OW+ZEhwXLVKc4asY/4Q2ZOcHzUPxpfeckWO2GQNef6sMDxZHEwu
	 RvntJUm8lK6Z8gP4wRHGVGL7LoGzlYTWkuo3wxLg9vmXHkJ49UWY/ZpH63fG/u5o4Mw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795052683;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=FBfIzX2Tz5UMKXNPf2IXuFh3hsorexHbZF8wz7qZRrU=;
	b=vDelvJuiS2UOk2WL7pNBPcD4b7dhIO6Ti+CNqPiLqoo1U9zbOtsIBHfqLa2wcXmHZ7le
	 hp9kLH/kGMXSNmZB0FR6WaDSXWUdTuUYKPyavZRNQbSlKiyOC92zU+08S6+mKdczTNRNL
	 vII/BzJUToGsH8oIar9jksTR239aMavmcetZTphokju3bMJdlmgqpmc2GA86h1zDL0C3r
	 HAv75+5kerc17VnUX8i+G4ANVqyv3FG8373Qi81rr8hNvt7Zts3Ad7ifnuhURYiY+z1PX
	 BLP+dckMAWlAe+GCldn0LkNtghY78FAcWI+Ks/sZD0+cJjG+K3+Pqms4r3Kv15qIrgA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="L/KUP9nC";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 11CB6606A32C;
	Thu, 19 Nov 2026 01:44:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=L/KUP9nC
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 606761F000C7;
	Thu, 19 Nov 2026 01:44:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795052682;
	bh=FBfIzX2Tz5UMKXNPf2IXuFh3hsorexHbZF8wz7qZRrU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=L/KUP9nCGqSX44wXPcibGEXyoH5T0QMi1g+FlSqpi+cUKP/RTShyJ26O/jICD/aFh
	 Cgx9X/zoTfjPbxfeD8hIfmOLla5HDvGuYk+BWLBv65QFK1DX9hQO1SXde56eOLwgQz
	 aWviiIS52oQ3imHyqFR9fdHfbF16reAbRUK2dbtY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Radiy Zhambakiev <r.zhambakiev@prosoftsystems.ru>,
	Lee Jones <lee@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 0651/2214] mfd: tps65217: Check return value when masking interrupt sources
Date: Wed, 18 Nov 2026 15:38:47 +0100
Message-ID: <20261118150037.540848640@linuxfoundation.org>
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

From: Radiy Zhambakiev <r.zhambakiev@prosoftsystems.ru>

[ Upstream commit 66ed12c1e5a986bee1dc63f9bd9c7f068138a69a ]

tps65217_irq_init() ignores the error returned by
tps65217_set_bits() when masking all interrupt sources. A failed
register write leaves the driver's software mask out of sync with the
hardware and may result in spurious interrupts.

Check the return value and propagate the error to the caller.

Found by Linux Verification Center (linuxtesting.org) with SVACE.

Fixes: 6556bdacf646fcaa ("mfd: tps65217: Add support for IRQs")
Cc: stable@vger.kernel.org
Signed-off-by: Radiy Zhambakiev <r.zhambakiev@prosoftsystems.ru>
Link: https://patch.msgid.link/20261002113624.178588-3-r.zhambakiev@prosoftsystems.ru
Signed-off-by: Lee Jones <lee@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mfd/tps65217.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/mfd/tps65217.c b/drivers/mfd/tps65217.c
index 74b1f20806da8..e11d325967c3d 100644
--- a/drivers/mfd/tps65217.c
+++ b/drivers/mfd/tps65217.c
@@ -164,8 +164,12 @@ static int tps65217_irq_init(struct tps65217 *tps, int irq)
 
 	/* Mask all interrupt sources */
 	tps->irq_mask = TPS65217_INT_MASK;
-	tps65217_set_bits(tps, TPS65217_REG_INT, TPS65217_INT_MASK,
-			  TPS65217_INT_MASK, TPS65217_PROTECT_NONE);
+	ret = tps65217_set_bits(tps, TPS65217_REG_INT, TPS65217_INT_MASK,
+				TPS65217_INT_MASK, TPS65217_PROTECT_NONE);
+	if (ret) {
+		dev_err(tps->dev, "Failed to mask interrupt sources: %d\n", ret);
+		return ret;
+	}
 
 	tps->irq_domain = irq_domain_add_linear(tps->dev->of_node,
 		TPS65217_NUM_IRQ, &tps65217_irq_domain_ops, tps);
-- 
2.53.0



