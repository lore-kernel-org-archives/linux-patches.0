Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794590761;
	b=Opp/+/V3yeofraFKsGSr7IZ9dzmNMEoypE5fY4hJpuhiHAQSpW+vTqU1pmu1nK9A8a/r
	 I2MgVQ1XdTpu26Cp/ssTD2FChPeKxE/Gy37+YL/GF3eWy3RlK6IFgVdalZArdL49XqLvR
	 n1sUbR9Qd9pNCKJBahXu3S5zI4Bdo3pcsJ/pdqBcK5G+t5stsCCLzRkQHIR+iqhXGog40
	 9VMSvUCk/D6EurxBeojv/j8WNPcdJKwLbL4lCr5agU8PrghCbX385b9n9JZveEcT5r9Ab
	 TtGvkaF3ENUWDg82y+tp3uEVRFk1q8rme/LEVYofjEJUG/wkbKIuaU9Pm6RgWyBx4mg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794590761;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ibUFDzVlgioodZ/AFMphia3kbc5ra+lRWdijbTX7qQ4=;
	b=DqJFrQhrPO+ddUS/crbI+XsjBdhOawjBg0cIBDeJIvUymURYEpYKtJMVEbYoXFoSGwQF
	 N4minA3fSNI6Klhk8n/FomOIE9yi2c5fewNeTcclNLZeO1Uuko4kBGn6F1hzGvZ2wusjW
	 GgVNHi1silpJRQ0qEluvJ2zD5diBIItz1EFcMEjDFUKh5RbF74PZNOSuNk23F02jlxaX3
	 uODqq1x0stogztuqqpMNWXklWbn5z10L5THz3RF3Q+jxU97mU4QahsyQSJOKR2ER+NYu3
	 q0A2kMI/AvkLThEeh3usQqljrtWcKgu9oDCalvdscZv6PL/efqVCmw2hVFZq6dqh3Yw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=MO9Yc2cA;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4455E607C34F;
	Fri, 13 Nov 2026 17:26:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=MO9Yc2cA
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D1CCB1F000C6;
	Fri, 13 Nov 2026 17:26:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794590761;
	bh=ibUFDzVlgioodZ/AFMphia3kbc5ra+lRWdijbTX7qQ4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=MO9Yc2cASRcLQ9wRTKI3HWvYqCRCop92Ut1dt+r4U2vEOxAikOeFm2QTjKAWmYg5g
	 aI82hj0NaBP40s7/G1JJxi7cJ+ryXzU9lg2EqWXScR0weHlQaTqvHhNpma2M80iK3m
	 kZESOiQPJbiGjrw92oWxIC+F1xh1GbhV2RcoLfTo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Conor Dooley <conor.dooley@microchip.com>,
	Miquel Raynal <miquel.raynal@bootlin.com>,
	Jerome Brunet <jbrunet@baylibre.com>,
	Brian Masney <bmasney@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 661/686] dt-bindings: clock: ma35d1: Drop CLK_MAX_IDX define
Date: Fri, 13 Nov 2026 10:53:14 -0500
Message-ID: <20261113153844.116426399@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153820.902362109@linuxfoundation.org>
References: <20261113153820.902362109@linuxfoundation.org>
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

From: Miquel Raynal <miquel.raynal@bootlin.com>

[ Upstream commit 653738db38c7c7f0fb959a7870f9461cf4987825 ]

Drop CLK_MAX_IDX define of MA35D1 include. This is not a binding and
should not be placed here. Value is defined in the user driver.

Acked-by: Conor Dooley <conor.dooley@microchip.com>
Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
Link: https://patch.msgid.link/20260930-perso-ma35d1-upstream-clk-v6-3-48937ee6c9bb@bootlin.com
Signed-off-by: Jerome Brunet <jbrunet@baylibre.com>
Signed-off-by: Brian Masney <bmasney@redhat.com>
Stable-dep-of: 1dc3871ce7ec ("clk: nuvoton: ma35d1: Add missing WDT/WWDT parent clocks")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/dt-bindings/clock/nuvoton,ma35d1-clk.h | 1 -
 1 file changed, 1 deletion(-)

diff --git a/include/dt-bindings/clock/nuvoton,ma35d1-clk.h b/include/dt-bindings/clock/nuvoton,ma35d1-clk.h
index ba2d70f776a6d..2d6a44a7e55c4 100644
--- a/include/dt-bindings/clock/nuvoton,ma35d1-clk.h
+++ b/include/dt-bindings/clock/nuvoton,ma35d1-clk.h
@@ -248,6 +248,5 @@
 #define ADC_GATE	233
 #define EADC_DIV	234
 #define EADC_GATE	235
-#define	CLK_MAX_IDX	236
 
 #endif /* __DT_BINDINGS_CLOCK_NUVOTON_MA35D1_CLK_H */
-- 
2.53.0



