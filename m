Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795048657;
	b=0mBJQijp56eThUt8i/9bQE8Hf7Wr2SInwMFeEqbJGWVpGUmo0SzVZtPmcq+OmlJOUT1K
	 WoLXgyfeNcyMS6nAfmvtgus/NPJ0alxFpw4lM4yVVx4PIZw04G/kTUFegzULaJcetlBcW
	 IHOrHGd+PvjSD8fx5DgOF3hbggkieXjH3tZf7Jz1VEf5v6A+Iaym5Cx5uZ/T+HcgqKKoX
	 Ox4ZqK/dLRMBIai20TflJWVz7RI3gsOwW00P9Axduhmw/U1DwO1ilt+hkoOzT8Xr1A56v
	 /3R5l8ogmsEU7208jGwz6DUwF5BmGQ43kc6Omtd8z+VErHdUR8Pqd82qMooMItGDZjA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795048657;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=tzI8PbSiNh0GpbBHEK4zh89W1w8GDJOPlDZjGAi3ki4=;
	b=Phx/0bJdTTucGWQLinv3jhYMu17BO5yZhVnMBYLbk1DlAQkiHzxMFfFOtH7iZlcyRvsp
	 m45fXeisoprutA0fP3cGPE+1ary/mppwXYhS4S+Ry6P4JNT1yR78ucwBUIXEl/T9/eDmu
	 bCJU6lYx/6h9K457xlAIB9qzioCsnMQ21YtD30Z73vfdnP4/to+pv1B0VuXyWtYm0SPsE
	 bQTYV9g4YYklYUhlbalYZUYCH8O8zOfB0+3ePOPV7eBeOy986tfMrZtpBbA7LUMrtBHES
	 chWq9exHzeAeCr2RAVsMk3jwqwsDCZTSUiVpN0H8cYRt0+8lpPQz4W2Pll1eBklo6UQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=YSZ9+K0b;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C79B8606A32F;
	Thu, 19 Nov 2026 00:37:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=YSZ9+K0b
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2CD7A1F000C4;
	Thu, 19 Nov 2026 00:37:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795048657;
	bh=tzI8PbSiNh0GpbBHEK4zh89W1w8GDJOPlDZjGAi3ki4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=YSZ9+K0bSNM/WgpSXUVvA7msfNyP90mL5anCF+jdgrkf6ljirNiCdep9t7kcTmQF5
	 LhXRiLWwmjRRdzUt/tXHhsX1W24R/SgLGjAsc16SvvA8ZJnPnGTrMxCtmB7RPxGfvu
	 qypleRxjvuYVPoD4zKc6ZQqXG36Hdp+v5Zx7Ajzs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Adam Skladowski <a39.skl@gmail.com>,
	Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 2071/2857] dt-bindings: vendor-prefixes: Add LeEco
Date: Wed, 18 Nov 2026 15:51:45 +0100
Message-ID: <20261118150315.982600211@linuxfoundation.org>
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

From: Adam Skladowski <a39.skl@gmail.com>

[ Upstream commit 1658af4d25bd3133d1b3403ccdda6214d40c0ebb ]

Add vendor prefix for now dead ecosystem company LeEco

Signed-off-by: Adam Skladowski <a39.skl@gmail.com>
Acked-by: Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>
Link: https://patch.msgid.link/20260821-next-patches-v5-1-ec81cee63e09@gmail.com
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 Documentation/devicetree/bindings/vendor-prefixes.yaml | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/Documentation/devicetree/bindings/vendor-prefixes.yaml b/Documentation/devicetree/bindings/vendor-prefixes.yaml
index 5ac28adcf572a..3cadc10908bbd 100644
--- a/Documentation/devicetree/bindings/vendor-prefixes.yaml
+++ b/Documentation/devicetree/bindings/vendor-prefixes.yaml
@@ -723,6 +723,8 @@ patternProperties:
     description: Lattice Semiconductor
   "^leadtek,.*":
     description: Shenzhen Leadtek Technology Co., Ltd.
+  "^leeco,.*":
+    description: Leshi Holding Beijing.
   "^leez,.*":
     description: Leez
   "^lego,.*":
-- 
2.53.0



