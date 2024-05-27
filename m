Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 717CA168C4;
	Mon, 27 May 2024 19:26:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716838001; cv=none; b=LpkG9WqyvxQPKsias+xH/LRIdK/42tIhbSMTvZIz8b7bbpwNGGEBbTPRW16vb4ACuxIFfz4PUvJCWeMMgReKHe3pkogrejvfuiBfpCZqysPNjDKKyXZgZGIcu83OmrhgHbOXsLCRzHEkM8hjl0sT9lZ907NmZj6xqS0+GC3Eg34=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716838001; c=relaxed/simple;
	bh=Q/B3tlMzdX9EbflMp2s49sZdiP3AQOTYZrxeVopX2/w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LUO6tOSOgQZ8VkrB9XRu1PCmfDUtchx+0mjhrpHSmN8ZI9m3/gYTw8da61khH4HR2PB2zA8UZDMFe9ZzlAuvZQGR1PVPEClw14WF83iEJg8j4CgGXIDnnuLtgjbRjOtcTkHFR0Th/hNNK1MWfvN3C+hgbpGpczd/+6irZiJ/Epc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TERSILsA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TERSILsA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 09987C2BBFC;
	Mon, 27 May 2024 19:26:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1716838001;
	bh=Q/B3tlMzdX9EbflMp2s49sZdiP3AQOTYZrxeVopX2/w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TERSILsAkuIonp+t/4s8YJBqw/X26XhxSJCM0vCpOMNWABU3nxU4KTBv6ibDtfWHJ
	 yTo6L7qbQrdPCIszkt2DNv9hUQ0k/xNIhZmBc2G8oyKxlaq3LlIqSlrFA4Z+v4A6BA
	 mjwpHmvKZ8wUzkzMzONWcG5Bf7fpaM1lvrPLUCOA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Binbin Zhou <zhoubinbin@loongson.cn>,
	Rob Herring <robh@kernel.org>,
	Huacai Chen <chenhuacai@loongson.cn>,
	Daniel Lezcano <daniel.lezcano@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.8 229/493] dt-bindings: thermal: loongson,ls2k-thermal: Add Loongson-2K0500 compatible
Date: Mon, 27 May 2024 20:53:51 +0200
Message-ID: <20240527185637.797296021@linuxfoundation.org>
X-Mailer: git-send-email 2.45.1
In-Reply-To: <20240527185626.546110716@linuxfoundation.org>
References: <20240527185626.546110716@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Binbin Zhou <zhoubinbin@loongson.cn>

[ Upstream commit 25c7d8472f6e90390931e93f59135478af3e5d86 ]

The thermal on the Loongson-2K0500 shares the design with the
Loongson-2K1000. Define corresponding compatible string, having the
loongson,ls2k1000-thermal as a fallback.

Signed-off-by: Binbin Zhou <zhoubinbin@loongson.cn>
Acked-by: Rob Herring <robh@kernel.org>
Acked-by: Huacai Chen <chenhuacai@loongson.cn>
Signed-off-by: Daniel Lezcano <daniel.lezcano@linaro.org>
Link: https://lore.kernel.org/r/26524a63abd2d032e4c45efe6ce3fedb46841768.1713837379.git.zhoubinbin@loongson.cn
Stable-dep-of: c8c435368577 ("dt-bindings: thermal: loongson,ls2k-thermal: Fix incorrect compatible definition")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../devicetree/bindings/thermal/loongson,ls2k-thermal.yaml       | 1 +
 1 file changed, 1 insertion(+)

diff --git a/Documentation/devicetree/bindings/thermal/loongson,ls2k-thermal.yaml b/Documentation/devicetree/bindings/thermal/loongson,ls2k-thermal.yaml
index b634f57cd011d..9748a479dcd4d 100644
--- a/Documentation/devicetree/bindings/thermal/loongson,ls2k-thermal.yaml
+++ b/Documentation/devicetree/bindings/thermal/loongson,ls2k-thermal.yaml
@@ -20,6 +20,7 @@ properties:
           - loongson,ls2k1000-thermal
       - items:
           - enum:
+              - loongson,ls2k0500-thermal
               - loongson,ls2k2000-thermal
           - const: loongson,ls2k1000-thermal
 
-- 
2.43.0



