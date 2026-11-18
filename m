Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795022904;
	b=dKcIiErCs3FeTCZXp7s/QJhymzr9t1I91GsE9PEmi9LfdwgxSFb0B1wOp3Ae/cSafd7A
	 lRT5gWQ5KABKEMVPseV5CvueTKH1Axo/D9SmK8oXIzxtLCzzvRavVZtzGryhcMKrwpc1d
	 xlTb6x6AV2uORA6/zODj93VVS7lCabxnDeZJpkrjnWKVeO0UQN/pZcJBZl4AqSEx3YZXL
	 AQzcdFYmew2tKY+OJ6mkpUWjr3RNDmR+nKYWifhjdXdM25W90gD/0KzHRb2pDVXs8/5Ok
	 aTtc7vMFT+yZIJtg+Ig/4tiVP1sakWOmlGbzWs76yx2E8CISUYaEqqi8INAxpvOOs9Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795022904;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=9YLaxjXKbRnWr2Rojuve0kvYBlqLV5Z5DoBHwekGaxY=;
	b=gIHX0trUJg+c9JB28Jz6Y60+fTzreX4NjuBTcJHyxnNUvnWY7Sl2R6HJIsPvMELSAlAO
	 kitLxuyRC7Axabxu0ITxRakL1gMTbI2bdqYlrvhlTbyzR51Z3lIe3EmMy4nWEW1njEJVK
	 Rfv0KoNe3ufyZk5rhNKRZ6dlzFsXghseiowvskVu+5GFf7yRR1D1HnOLpB3zPT53XiP6n
	 icjSAB8Ea5UwcqpCwKogd2lbzD4mGtSMVdo/rvxSM9vnsARU1CiBPPLazfLl5sudwf6RT
	 cF3sguZ4XpqFRkZeBiTCbl74m1XLzHB3u6JVbX5rHPzn3LJAm2Rlo9Fwm2p8GBIy+3g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ytg0qgdK;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 040A3606A751;
	Wed, 18 Nov 2026 17:28:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ytg0qgdK
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5B7571F000C5;
	Wed, 18 Nov 2026 17:28:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795022903;
	bh=9YLaxjXKbRnWr2Rojuve0kvYBlqLV5Z5DoBHwekGaxY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ytg0qgdK5heseQXt5W+otQ1YGWy4h2Z9Hd7PvSBIKnq5mN23xmzZpitwBFNvOghy2
	 r12vQ0mVfNbjVE8BDJfDA8mZCyaEca43fes38fFWVlnFBFx84/0w7VCUu5FEQKfLCw
	 27LfWktEpR7g05FH4cpRqOZndN9NzUXVHWtPf8Dc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Luca Weiss <luca.weiss@fairphone.com>,
	Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0177/2151] dt-bindings: clock: qcom,milos-camcc: Document interconnect path
Date: Wed, 18 Nov 2026 15:31:52 +0100
Message-ID: <20261118150128.177461637@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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

From: Luca Weiss <luca.weiss@fairphone.com>

[ Upstream commit 7e622e74d2700da4d6ed3aa2a4d7e1b7d7293768 ]

Document an interconnect path for camcc which needs to be enabled so
that the CAMSS_TOP_GDSC power domain can turn on successfully.

Signed-off-by: Luca Weiss <luca.weiss@fairphone.com>
Reviewed-by: Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>
Link: https://lore.kernel.org/r/20260501-milos-camcc-icc-v2-2-bb83c1256cc3@fairphone.com
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Stable-dep-of: e0f335a4e17f ("dt-bindings: clock: qcom,milos-camcc: Add missing power-domains support")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../devicetree/bindings/clock/qcom,milos-camcc.yaml       | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/Documentation/devicetree/bindings/clock/qcom,milos-camcc.yaml b/Documentation/devicetree/bindings/clock/qcom,milos-camcc.yaml
index f63149ecf3e1b..707b25d2c11e6 100644
--- a/Documentation/devicetree/bindings/clock/qcom,milos-camcc.yaml
+++ b/Documentation/devicetree/bindings/clock/qcom,milos-camcc.yaml
@@ -25,6 +25,10 @@ properties:
       - description: Sleep clock source
       - description: Camera AHB clock from GCC
 
+  interconnects:
+    items:
+      - description: Interconnect path to enable the MultiMedia NoC
+
 required:
   - compatible
   - clocks
@@ -37,12 +41,16 @@ unevaluatedProperties: false
 examples:
   - |
     #include <dt-bindings/clock/qcom,milos-gcc.h>
+    #include <dt-bindings/interconnect/qcom,icc.h>
+    #include <dt-bindings/interconnect/qcom,milos-rpmh.h>
     clock-controller@adb0000 {
         compatible = "qcom,milos-camcc";
         reg = <0x0adb0000 0x40000>;
         clocks = <&bi_tcxo_div2>,
                  <&sleep_clk>,
                  <&gcc GCC_CAMERA_AHB_CLK>;
+        interconnects = <&mmss_noc MASTER_CAMNOC_HF QCOM_ICC_TAG_ALWAYS
+                         &mmss_noc SLAVE_MNOC_HF_MEM_NOC QCOM_ICC_TAG_ALWAYS>;
         #clock-cells = <1>;
         #reset-cells = <1>;
         #power-domain-cells = <1>;
-- 
2.53.0



