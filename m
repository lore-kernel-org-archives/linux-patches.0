Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795017375;
	b=c3c//nlFCEoEh1QrE+q2p5l8h4RXAP1LopkI5WQ+PUh3vTaX/fS/juqbkdmDDg3J8in5
	 OxGt+DwqUV0fwB+K4OzsUP8SRnzz5rXGU8u9ItZJCKP7N2PXl61kdV3xEXkCdzHBGYFal
	 cHik9jFQy38zDsSwYx4o/zIjsXTwXBPQ2ukvZKS4qWNxpO2WgY6CiZ0Ppz6QadaPJqiEa
	 3IDrmgNAJfpm/C0qFqAYT2K87LDqsWYGZyikyrANp65YRaRgAEuCz1/yNNDUgQWivS16n
	 H8VdJdS7V7K2Qr+TStxhSEf1eF4RtqikXIZRohNdVmGGFW7DhaqLah8RIPSQ9AKMkuw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795017375;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=tiLPWq2ESqge6Uxdor7E4IpQMicrQHO/ocXi6xat7/A=;
	b=2E/AQtPQRYrCqX2eR+4o/r/CyRl8OCLjXSeTPb3WMQpIq3uQeZvQTOEDY+mtdsgYD/An
	 j/IgmRML8F6sDC/s69OeIwaYKKS5i/DLG29MpWxVxkIzJ/OQP75JKo9OENvBTQdqm5sQY
	 o0JrlPhIQhAgr0q9bhA+X3gFbjuEW66p/jRpVZoniDNfzTPt1c4PH6T4Mlcm5dyMnpB2O
	 JchBuJlSyYLyvr0+AamJkaohCdj3DwemgEvZZ4Y7+WTraSAeeLizhLju9HqN51eab+82g
	 tAU06p/h6uwqmmPMyahqFuxLPRBJpPKAv83x5GA+gWgYwU4ADFkfEIDWbP0hVMMaA5w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=hg3N3QCQ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 10F6A606A325;
	Wed, 18 Nov 2026 15:56:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=hg3N3QCQ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 683061F000C4;
	Wed, 18 Nov 2026 15:56:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795017374;
	bh=tiLPWq2ESqge6Uxdor7E4IpQMicrQHO/ocXi6xat7/A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hg3N3QCQAu3tft4/VuS/iTbU194uvaIWUHMHZY3NTErdGqxLyU9vV5y69wSiN04di
	 2Vp7IZLcqLgYLw7k2ARzoYZzrn00ll661OIUUQheFqtwVWwyac1Vdq4Nz9nTbYERpS
	 DlctDyf9gQPGSRj0mMyycoOMgeN9LYo0JzNUSkqE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>,
	Abel Vesa <abel.vesa@oss.qualcomm.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0861/2651] dt-bindings: clock: qcom: sm8750-gcc: Add CX power domain
Date: Wed, 18 Nov 2026 15:35:01 +0100
Message-ID: <20261118150318.859384106@linuxfoundation.org>
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

From: Abel Vesa <abel.vesa@oss.qualcomm.com>

[ Upstream commit f9c74b6ed57922b1fdb1ed6835665e06b5ba01a5 ]

The GDSCs provided by the SM8750 and Kaanapali GCCs are supplied by the
RPMh CX power domain. Model that parent domain in the GCC binding so the
provider can describe the dependency in devicetree.

Add a single CX power-domain entry to the binding and make it required.
Without this dependency, GCC GDSC consumers cannot vote for CX and RPMh may
undervolt it.

Fixes: 342d2a607450 ("dt-bindings: clock: qcom: Add Kaanapali Global clock controller")
Reviewed-by: Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>
Signed-off-by: Abel Vesa <abel.vesa@oss.qualcomm.com>
Link: https://patch.msgid.link/20260924-qcom-tie-cx-to-gcc-v5-9-38732033e5b5@oss.qualcomm.com
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../devicetree/bindings/clock/qcom,sm8750-gcc.yaml         | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/Documentation/devicetree/bindings/clock/qcom,sm8750-gcc.yaml b/Documentation/devicetree/bindings/clock/qcom,sm8750-gcc.yaml
index 0114d347b26ff..59da3eb2b0738 100644
--- a/Documentation/devicetree/bindings/clock/qcom,sm8750-gcc.yaml
+++ b/Documentation/devicetree/bindings/clock/qcom,sm8750-gcc.yaml
@@ -34,9 +34,14 @@ properties:
       - description: UFS Phy Tx symbol 0 clock source
       - description: USB3 Phy wrapper pipe clock source
 
+  power-domains:
+    items:
+      - description: CX power domain
+
 required:
   - compatible
   - clocks
+  - power-domains
   - '#power-domain-cells'
 
 allOf:
@@ -47,6 +52,7 @@ unevaluatedProperties: false
 examples:
   - |
     #include <dt-bindings/clock/qcom,rpmh.h>
+    #include <dt-bindings/power/qcom,rpmhpd.h>
     clock-controller@100000 {
       compatible = "qcom,sm8750-gcc";
       reg = <0x00100000 0x001f4200>;
@@ -58,6 +64,7 @@ examples:
                <&ufs_mem_phy 1>,
                <&ufs_mem_phy 2>,
                <&usb_1_qmpphy>;
+      power-domains = <&rpmhpd RPMHPD_CX>;
       #clock-cells = <1>;
       #reset-cells = <1>;
       #power-domain-cells = <1>;
-- 
2.53.0



