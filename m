Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795049891;
	b=Kn+EV5Pr7Rp/QOiG6O155TsWfCt5lOwjyBwgkvRdYOhoQ3vGZks5P9pcU2O2ZM3ebPZR
	 Itpk+1bHyAWQCASFmlN/bI2NyGCfwxXIdZn0OvmfSNkXrQSk89Vo3lVuQLwjKGROQ4htg
	 fIEwvQozQCdACtUypgsGLl71vC4a6btIjqKGOx62HZ8EaduM5I2IMgk8XLs1KDWp38xsr
	 dqNjOhHmie6Ke/6YEqRg7lKpzGjs+CNCC33+0aFK1WzGzcMpS7ID0ebTZ7QQzTnmHOF9V
	 VXNyXDo/ONmXodta0McxrKfTWceZbvpxS2dbHfeGDkzCJxg7It2P74jrhezuNA01BLA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795049891;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=WJ2f/h8r1Lb9LxAG/tjVJhVAkULfDBeiovhZYBvaiWI=;
	b=lTIu327hF82lzoUny3Y2KB+g6Kns3iCt6stFBoVmxr9lv8aLPNat28WcVs4EyEMaTulu
	 rZe62PcXxaSoqtfDUPO7l+TMZFgYkhjAP1wB706YDCUnwoNJf4R49awPAHvivoGn3RfKT
	 j0MYfcrbMeplJyfC7RAjngULeYb48lc4tWIUat6aj8UWmxAOOiq7t3zJWGY8BkwWUlrUh
	 aNlvj2gvtlC6FTxoTjO0En6uVk/3piYpYG8vfg51ZysoJTH1EV+w/9Tg6RNA2aXaHjs2+
	 DqzNK7hhDTkxFK99yp/WAZsDw5b5IhKqP2pIux3uQzsgfVXA4QbeWNyuBo9+k4P3iwA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=REooDUhA;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 24113606A31C;
	Thu, 19 Nov 2026 00:58:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=REooDUhA
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 779861F000C4;
	Thu, 19 Nov 2026 00:58:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795049891;
	bh=WJ2f/h8r1Lb9LxAG/tjVJhVAkULfDBeiovhZYBvaiWI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=REooDUhAp15/wbMIxBtZ8eB+Pi+TMH+vk9mVE8REsBK2ZVxf2hEUQ1v09i0ixJEDZ
	 eStI6/dzUn1fpGOPuCEtUk58tFWHrbJ5ZhsaPe3djctjkjlFxwrzBjRFzuTu++X83C
	 V9IZhdDFlWFH9B+OHlgKjsjhPKVptuH7+fFFI56w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Long Zhao <longzhao@ambarella.com>,
	Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>,
	Linus Walleij <linusw@kernel.org>,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	"Rob Herring (Arm)" <robh@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 2513/2857] dt-bindings: vendor-prefixes: add Ambarella
Date: Wed, 18 Nov 2026 15:59:07 +0100
Message-ID: <20261118150332.020470155@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Long Zhao <longzhao@ambarella.com>

[ Upstream commit 5ef299ffb56531b3a4f2b311000da76beed403ee ]

Document the Ambarella, Inc. vendor prefix so Ambarella DT bindings
can be applied without waiting for the SoC series.

Signed-off-by: Long Zhao <longzhao@ambarella.com>
Acked-by: Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>
Reviewed-by: Linus Walleij <linusw@kernel.org>
Acked-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Link: https://patch.msgid.link/20261014-cv75-prefix-v1-1-fe95ed567880@ambarella.com
Signed-off-by: Rob Herring (Arm) <robh@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 Documentation/devicetree/bindings/vendor-prefixes.yaml | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/Documentation/devicetree/bindings/vendor-prefixes.yaml b/Documentation/devicetree/bindings/vendor-prefixes.yaml
index b8fb542fa9d11..750a9154dc2a8 100644
--- a/Documentation/devicetree/bindings/vendor-prefixes.yaml
+++ b/Documentation/devicetree/bindings/vendor-prefixes.yaml
@@ -89,6 +89,8 @@ patternProperties:
     description: Amarula Solutions
   "^amazon,.*":
     description: Amazon.com, Inc.
+  "^ambarella,.*":
+    description: Ambarella, Inc.
   "^amcc,.*":
     description: Applied Micro Circuits Corporation (APM, formally AMCC)
   "^amd,.*":
-- 
2.53.0



