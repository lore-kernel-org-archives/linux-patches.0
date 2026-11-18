Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795017628;
	b=cB/s20WRUwH17n6NEMraD0UlMKivGZ0I6rpCFCt7kFKQJ27ykNJqeTmJTIGoeKrYonhm
	 t3laenTL/BcyuvOw2tNNxEvJ9zJ66JPcEWsKLYqT7x1ICX+AKz40Gnj+aaEeyJnWAfr1G
	 /nP1V1iNqUyh/VX20ERghTsIeiWkOHczPCNhhaGTZWRXEtUkHGmycXSMveJ0scU+ljoGQ
	 AGXD2N7ZHeNAdDoTf4dOoPtZqCWI2ZL2Wn4oO3n0M6QktfdG3zKNJsGTraKfIPYpKj96d
	 Z5o3XoCoGzIbYqCN3Ml2jQGjtHx5nlT1fftUlShLjqbHUBP2/hocNwu4JIeMdRmEigQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795017628;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=rr2vJjyyivSsgplTcAsGi9JE9oMYMR7eMD9nz4cxs08=;
	b=B9Ua4E79E/hZLDe2GeJ4Li4V5IfZ4BJ7vY2sURG8HcW9WwNTsjOSmis3SzIyCPaPb7/z
	 mOl3FLeouErxNg4O92CLxcMp/9Ov8FQi6hzHTdTx88UwKKlGsbD4QkF5xx25tA/kMVOhv
	 70ZFThbPfPj14G0G6Lh9+oJxymSC4C/8lcaxMNdAGdit4SchkOxsWQvbkzhXHQ/abiUmk
	 IaG7JnxZZMxiqhR/Y92SULmfugjsnlHO3lGYhILQMA2LoJZM6AcshwR+18fmwCrWQGDDp
	 uKqH7bM7zaBXTmnX2et1QUpjRHsPZmfzw/d0THghLjGP6A7027YlSHcS77uPGJLjd+w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Dm8r9vd5;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1CB74606A337;
	Wed, 18 Nov 2026 16:00:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Dm8r9vd5
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 743CB1F000C5;
	Wed, 18 Nov 2026 16:00:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795017628;
	bh=rr2vJjyyivSsgplTcAsGi9JE9oMYMR7eMD9nz4cxs08=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Dm8r9vd518aw1Zw9oX9lCD1uXFRL1z9pTssJ59Kf12tBJwzpo2RKQjRDGB2KvuEVo
	 ClI9ERtSR1HKxa72PZr19Bxh6MCn7IsV1GhfIL/h+rrZEzNwIbHuEcAkY4VMD8j3Kx
	 tvQzO1slQSS+ObHgn2rrQtL8yRrnP1+PFVmnFkJ0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>,
	Geert Uytterhoeven <geert+renesas@glider.be>,
	Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0950/2651] dt-bindings: iio: adc: renesas,r9a09g077-adc: Drop unwired interrupts
Date: Wed, 18 Nov 2026 15:36:30 +0100
Message-ID: <20261118150322.106344646@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>

[ Upstream commit 1182148719cffb5ea7a4610dac34deac9a70cf89 ]

Remove the compare match and compare mismatch interrupts from the binding,
as these interrupts are not wired to the GIC on RZ/T2H and RZ/N2H SoCs
according to the hardware manual Rev. 1.30.

While this change introduces an ABI break, the expected impact on existing
users is minimal, if any, since the interrupts are not wired to the GIC
and are not used by the driver.

Fixes: 4d8d58987cb5 ("dt-bindings: iio: adc: document RZ/T2H and RZ/N2H ADC")
Signed-off-by: Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>
Reviewed-by: Geert Uytterhoeven <geert+renesas@glider.be>
Signed-off-by: Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../bindings/iio/adc/renesas,r9a09g077-adc.yaml        | 10 ++--------
 1 file changed, 2 insertions(+), 8 deletions(-)

diff --git a/Documentation/devicetree/bindings/iio/adc/renesas,r9a09g077-adc.yaml b/Documentation/devicetree/bindings/iio/adc/renesas,r9a09g077-adc.yaml
index dc0206b282315..ae14fdbe44b1e 100644
--- a/Documentation/devicetree/bindings/iio/adc/renesas,r9a09g077-adc.yaml
+++ b/Documentation/devicetree/bindings/iio/adc/renesas,r9a09g077-adc.yaml
@@ -34,8 +34,6 @@ properties:
       - description: A/D scan end interrupt for Group C
       - description: Window A compare match
       - description: Window B compare match
-      - description: Compare match
-      - description: Compare mismatch
 
   interrupt-names:
     items:
@@ -44,8 +42,6 @@ properties:
       - const: gcadi
       - const: cmpai
       - const: cmpbi
-      - const: wcmpm
-      - const: wcmpum
 
   clocks:
     items:
@@ -107,11 +103,9 @@ examples:
                    <GIC_SPI 709 IRQ_TYPE_EDGE_RISING>,
                    <GIC_SPI 710 IRQ_TYPE_EDGE_RISING>,
                    <GIC_SPI 711 IRQ_TYPE_LEVEL_HIGH>,
-                   <GIC_SPI 712 IRQ_TYPE_LEVEL_HIGH>,
-                   <GIC_SPI 855 IRQ_TYPE_EDGE_RISING>,
-                   <GIC_SPI 856 IRQ_TYPE_EDGE_RISING>;
+                   <GIC_SPI 712 IRQ_TYPE_LEVEL_HIGH>;
       interrupt-names = "adi", "gbadi", "gcadi",
-                        "cmpai", "cmpbi", "wcmpm", "wcmpum";
+                        "cmpai", "cmpbi";
       clocks = <&cpg CPG_CORE R9A09G077_CLK_PCLKL>,
                <&cpg CPG_MOD 225>;
       clock-names = "adclk", "pclk";
-- 
2.53.0



