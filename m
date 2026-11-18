Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795055407;
	b=lgrXMn+weDoY9FwvHW0V6cjP6ncY9r0yAp0/G9YMKw5pOvRY1JmHMn5imqJtuVHLJ27f
	 qd1h92mxZ5pIpeEznnEQrQqF/jdL2Qll2X0TDWqef4v2UelwdQQ1rnHqNpXINJxexXGQd
	 IrQssPsghPk1YVIQRWQAP/J1foCJbnJYLKOCAHTaRM2kSF79wlY3SKee5M3WMoq4jPz/u
	 uqPSmcwidS6VPcBCNCZkkm+a5B27GRbNEOWrcuRSgcZbiZZEbyLzlTZx6Cnwdx5JfyQ4L
	 Dr7AlQcKhqrvmusS2Bk+1ienV0F1s9FAsC2+Hu9neK/SEi9yfD+QwRDVUpV1L6zXqtQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795055407;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=uNzWZI/zi/uJJ9bV8Ta1RE7GVxTVbPOMk6qxal2GuNE=;
	b=1CcjZUrMgORq/qbeAIQqbgGkikZVU6JzrlP21eSDjIScPDTPjDiGfwSWuNDSOfTSaaua
	 xK7vYJkfQ9ONs/otwYNJnumhludM4/hOCrK0QcZBxIxFyEVGMeeTp7WDtMkplb9B9OkoA
	 nqkfHNYejsEItd9Tew6hzQ09dBQMfetdbxku7sYcjmjRsQTrDsfenhnRyvctKVmKXgGZl
	 N/DUfqM3iPsl2vQPQxvqMjasiOlxjKLBGYf13x1GCbBqbyWSIPlP4ChrI4JDhNRhUruyG
	 sMSel6xpzXJ6c1L8hwqgAIHdaTD/AN9wXb3whd78iZy77FW6EMqkmjlvWa374CYnDGA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=MNhuI1ji;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1AC68606A320;
	Thu, 19 Nov 2026 02:30:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=MNhuI1ji
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7028E1F000C4;
	Thu, 19 Nov 2026 02:30:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795055407;
	bh=uNzWZI/zi/uJJ9bV8Ta1RE7GVxTVbPOMk6qxal2GuNE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=MNhuI1jiNqrjDw7BXkvhkbrBPznMzh6JXSQw0I9vRLXnQj3g5AsQ5MSTLnL6olPaM
	 2lXO9blpjc3k32b1xvwa9KF/NkvhtnqhC7XzIcfUQ8K8c+CQRVxAgHYhdp8dismMCz
	 d6KmeYhLv/GPiFHqpbZXF1QNmfx+9vUs8OW6aWQ0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Geert Uytterhoeven <geert+renesas@glider.be>,
	=?UTF-8?q?Niklas=20S=C3=B6derlund?= <niklas.soderlund+renesas@ragnatech.se>,
	Marek Vasut <marek.vasut+renesas@mailbox.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 1620/2214] dt-bindings: vendor-prefixes: Add Retronix Technology Inc.
Date: Wed, 18 Nov 2026 15:54:56 +0100
Message-ID: <20261118150116.787865929@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Marek Vasut <marek.vasut+renesas@mailbox.org>

[ Upstream commit da076d5562d2fc99138ff8ab04ff82eee7a4a3d8 ]

Add vendor prefix for Retronix Technology Inc.
https://www.retronix.com.tw/en/about.html

Acked-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Reviewed-by: Geert Uytterhoeven <geert+renesas@glider.be>
Tested-by: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>
Signed-off-by: Marek Vasut <marek.vasut+renesas@mailbox.org>
Link: https://lore.kernel.org/20250420173829.200553-2-marek.vasut+renesas@mailbox.org
Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
Stable-dep-of: ea55bba4c68a ("dt-bindings: vendor-prefixes: Add Retroid Pocket")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 Documentation/devicetree/bindings/vendor-prefixes.yaml | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/Documentation/devicetree/bindings/vendor-prefixes.yaml b/Documentation/devicetree/bindings/vendor-prefixes.yaml
index 2b4e259fd816a..e70b0c59a0806 100644
--- a/Documentation/devicetree/bindings/vendor-prefixes.yaml
+++ b/Documentation/devicetree/bindings/vendor-prefixes.yaml
@@ -1004,6 +1004,8 @@ patternProperties:
     description: iMX6 Rex Project
   "^rervision,.*":
     description: Shenzhen Rervision Technology Co., Ltd.
+  "^retronix,.*":
+    description: Retronix Technology Inc.
   "^revotics,.*":
     description: Revolution Robotics, Inc. (Revotics)
   "^richtek,.*":
-- 
2.53.0



