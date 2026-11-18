Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795036190;
	b=sPK1rRY1hn+F+0iwHJWEfnlWva489+n9m+QI0lOUt11XleEHeqWrfpIc78XpXdsJZ6LC
	 nDk1zqCDtVpKh1SW2oxGkeeubKrE2aJ3byjAS3CPYTJc03/nlvE2qyj5IpyNpk+k7e2tM
	 awncykmhEwJYNgeBClmg9ghZ9TfJXv8cnA1lqK8dDvKwoPGZa3GylHB6mtYZztv8nXJ/S
	 umJnM6J7lYF3Eda8MjCZ6ojudXOX3IaVQ8SBa7tG7gHPvnNSv43Srzi1xtG2UKWdRY6Dr
	 CrrVB9U/KZ8rH++Ii0BGtTAwjId5dEWSKzNK9U6SqC6SusiNAnEWFRvuOtWOGc67Q+g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795036190;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=rfTi1YarHB81pZ3xC+8lPHL19ahQ2tyVD0fsJDky/6M=;
	b=ie0SLPAITw371vp31LHhP4KS61rCWxtvUu1bSral3Jk2ex9ieEgUDqn1YL20Yu5O9bcb
	 7dIaPnHDjoss5WKOv8sntamHpydJPSYsaBiV1qNA5AI5wyqz2ZJYf2wSYjRO39SiPx5tJ
	 zL3voGWGC2PjxR3WDr5LJlqMJtjfBGo3YyguYWHpGdEI0xH11h7+JVMS6b04oYHoKS2Yn
	 9HP136xsD8d3RWOPaOCuha3wiWKWeUg0fQ9TLTLJHcklXu2qTFw3oLimIxxzvUi02exo9
	 /dfaahZGcgAvoHHjSaAT/+6leQtkb/Z2WNbW9ztwJhFuO02bFZiWkthCRpm76iQoBQw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=qkyH4efc;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 832A360A2612;
	Wed, 18 Nov 2026 21:09:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=qkyH4efc
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D39F01F000C8;
	Wed, 18 Nov 2026 21:09:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795036190;
	bh=rfTi1YarHB81pZ3xC+8lPHL19ahQ2tyVD0fsJDky/6M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=qkyH4efcITP1GNy2GcgNEdZSHAnihcsc0AZwgvSzD4BKQ3btRL06vIcRy4K2TUz1S
	 sHhGkq0YYokG/wZ+JS/VfK4XFxaSXoAI0nHYFrCaRTvIdyyiYPVB/S1scZf6C9K7ag
	 AKiA8KqZMlsPbNWMGHTwuCT4S3d84t04+RCjXF+A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Heidelberg <david@ixit.cz>,
	Lee Jones <lee@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0928/3318] mfd: wcd934x: set DMA mask on parent to silence "DMA mask not set"
Date: Wed, 18 Nov 2026 15:25:50 +0100
Message-ID: <20261118150347.385278853@linuxfoundation.org>
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

From: David Heidelberg <david@ixit.cz>

[ Upstream commit b296be1dc008fe3a536341afae01f66bb302e67f ]

The wcd934x MFD parent (a slim_device) never initializes its
dma_mask/coherent_dma_mask. When the DT-aware children pass through
of_dma_configure() this triggers the "DMA mask not set" warning for
each child.

Cc: stable@vger.kernel.org
Fixes: f959dcd6ddfd ("dma-direct: Fix potential NULL pointer dereference")
Assisted-by: tencent:hy3
Signed-off-by: David Heidelberg <david@ixit.cz>
Link: https://patch.msgid.link/20260903-wcd-dma-v2-1-189cff560a28@ixit.cz
Signed-off-by: Lee Jones <lee@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mfd/wcd934x.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/mfd/wcd934x.c b/drivers/mfd/wcd934x.c
index 6b942d5270c16..2ea70d163ac10 100644
--- a/drivers/mfd/wcd934x.c
+++ b/drivers/mfd/wcd934x.c
@@ -2,6 +2,7 @@
 // Copyright (c) 2019, Linaro Limited
 
 #include <linux/clk.h>
+#include <linux/dma-mapping.h>
 #include <linux/gpio/consumer.h>
 #include <linux/interrupt.h>
 #include <linux/kernel.h>
@@ -217,6 +218,11 @@ static int wcd934x_slim_probe(struct slim_device *sdev)
 	struct gpio_desc *reset_gpio;
 	int ret;
 
+	ret = dma_coerce_mask_and_coherent(dev, DMA_BIT_MASK(32));
+	if (ret)
+		return dev_err_probe(dev, ret,
+				     "Failed to set DMA mask\n");
+
 	ddata = devm_kzalloc(dev, sizeof(*ddata), GFP_KERNEL);
 	if (!ddata)
 		return	-ENOMEM;
-- 
2.53.0



