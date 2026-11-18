Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795048417;
	b=MNB9lMhQ93yWvZwRRgR/F21+freoRd3tFYToi+XzmJOKRoYyDiHet1dn7s0TARI5XhnL
	 AXlqTHbc9AKKhldi6gmEgLbAW2U5ZmXamlFiUZEcjxdbHyhxSFxqniH4JyGoZWL1eq1P1
	 yGtOdnQLltOSKCV3A9el629M/tWGzDCmRf9OW2S2kR2+5pv1Ugoumb5jDAk2RApCUTexd
	 YSnDHzJnsdAfgrFJTOL+A95ViVZpLXTh3gkJNgUGj2YVaYl/9qrMG/O2uyriJQXg5OXK6
	 sSawkTb2v0rOZqk6dxMp9t0FiH8F7dN+i1pcdLCQgJX2y4lH+5H3FxG7ThQs+1X5UrQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795048417;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=zNVUL2fjDx3CafzM21G58M0VdteBwIbBh+T0F73Ur3Y=;
	b=Oek6lxi6QXklodm+CqzbI/3wtXL6KuGxHDLEB199zHpc7kykUs7ZrapxUE0RZ5NZ8ML2
	 IzNMYyTYeCFTcLZQf0PT5KQxdWATKJ1yJDBjPgwQiPctvMraCBx9dm5UZbLmb2L1TGZ0P
	 ywsN+hr6zoRpBZhobETZ0DQYTQN4AM6wRY2YicTU/uwo6gQjmhXR+297nC0NChdwAG9Zj
	 wZIsc+yqIjD48id84oBqLkOS/JAD+xbtdySD96gZ7amUD+67MNeuDaUIAGIUtG5C+BLYx
	 1r+lDEUJGlycGureFuxj+sE71JQGxUJnpRYplsNbYDFVPt1T9bRBmv+VPUrWA1sTvEA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=dMxWlDct;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 79AE8606A339;
	Thu, 19 Nov 2026 00:33:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=dMxWlDct
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D36321F000C4;
	Thu, 19 Nov 2026 00:33:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795048417;
	bh=zNVUL2fjDx3CafzM21G58M0VdteBwIbBh+T0F73Ur3Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dMxWlDct0o1EAtNaLgy28h+BJ5ArLC+hdqE3KmipdiGBqk8c8TxQ/FKZ8ruX5NmSq
	 IFGLNitwpivxz2RrHm29i72dhxPplMXdzGgAE7hZ4p539VkaN5nrQx9bkd/pbGY98t
	 Ud78xFvTZCGU8xEc9tokNXWWqAOb+oey3BwRCo80=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chris Morgan <macromorgan@hotmail.com>,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Linus Walleij <linus.walleij@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1985/2857] dt-bindings: vendor-prefixes: add NewVision vendor prefix
Date: Wed, 18 Nov 2026 15:50:19 +0100
Message-ID: <20261118150312.851437176@linuxfoundation.org>
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

From: Chris Morgan <macromorgan@hotmail.com>

[ Upstream commit a2f79d7f140c8e01b719d9404e4a4eaa2c849ede ]

NewVision (also sometimes written as New Vision) is a company based in
Shenzen that manufactures ICs for controlling LCD panels.

https://www.newvisiondisplay.com/

Signed-off-by: Chris Morgan <macromorgan@hotmail.com>
Acked-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Link: https://patchwork.freedesktop.org/patch/msgid/20221111203130.9615-2-macroalpha82@gmail.com
Stable-dep-of: cb81a22504f4 ("dt-bindings: vendor-prefixes: Add vendor prefix for Teclast")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 Documentation/devicetree/bindings/vendor-prefixes.yaml | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/Documentation/devicetree/bindings/vendor-prefixes.yaml b/Documentation/devicetree/bindings/vendor-prefixes.yaml
index 655d56b06efd0..2da6ca65e722f 100644
--- a/Documentation/devicetree/bindings/vendor-prefixes.yaml
+++ b/Documentation/devicetree/bindings/vendor-prefixes.yaml
@@ -889,6 +889,8 @@ patternProperties:
     description: Shenzhen Netxeon Technology CO., LTD
   "^neweast,.*":
     description: Guangdong Neweast Optoelectronics CO., LTD
+  "^newvision,.*":
+    description: New Vision Display (Shenzhen) Co., Ltd.
   "^nexbox,.*":
     description: Nexbox
   "^nexperia,.*":
-- 
2.53.0



