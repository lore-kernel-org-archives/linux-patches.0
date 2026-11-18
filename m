Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795015320;
	b=1GrkwbomlMq75oivxVX6OpgZenSOYp0ZoH3XfLa6zDlKuAfDg1u7dof6ld5PzGcMk+bq
	 hDfiV4tZDVVIL8KT5P6sKbvZHMv6XVEpm582eG9wBuRfqd9REeUVm/IVKfuXup/LtAUkv
	 rTDjgZJQ1xC/f5TV+BLOCz2TLX0IJMkLiGcxHfqbFnG5h5scmsFC0YDbxAXA9cenKW1Iz
	 0XFOXBm+p5sp/aI8LCXVhSNzXzJnv36DWkChuUQc5YEIVquu32rdevZNlobPhwxx/vA79
	 KGwsFxco2/I+ebGAgRTybCvBVRmpqp0OzOLEGhS84+9khJeA1A9w5NlLMviCKisMQXg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795015320;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=t2ju/u9R4tlNlBxIbs+5UHiScK9mGr34MvwXjPdYg9Y=;
	b=k++hXJBfu/mk1A+izEGQDDGoCWRHfW6RS8MtostVvtNWMHWlpkoFX97lhlPd/lrxQbHI
	 Say03kQ8sQh9ksw7PHeJe3R6tNNwzcjNvUgtlUjfE+dC0PKq+/xmy7j1FZ4OGpABV6vwW
	 Vi/0GCM7vlUmvAwMT+THkrbq3pbr3DA+W2v6qw8GiBJzrbOPYUFT6l6mD9KMyFRsVgsUA
	 0U2v7aWDrb6BqlpdvaeyE0IC2mLHBODFCv9r9bcR3f2xk0x637cYeSWRUJW+flQSeaeOi
	 +2EkA9SBVKU9MO0GLSG+EwjocrgtJM2MDtJ5fLcl9dwlP5rLe/9y98C7KAgmQL87sVw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=1BLkgXlb;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 12226606A331;
	Wed, 18 Nov 2026 15:22:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=1BLkgXlb
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 635F31F000C4;
	Wed, 18 Nov 2026 15:21:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795015319;
	bh=t2ju/u9R4tlNlBxIbs+5UHiScK9mGr34MvwXjPdYg9Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1BLkgXlbYFlW/yoIkgtQ9AHJZsXqxR7sci+4ZcVeY/vd4dOIwblRyM14NVdSIYUiS
	 kczd4Jb0AVmc3rlPRbmJJiC+dw3q1QXKAiD6kAEqJaF7HIAN1o5QDv55zJaU3gMs8d
	 UdP72LI0nZJ7bBkuf10JhTcYrx0ZHXEoAEDSlYc0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>,
	Taniya Das <taniya.das@oss.qualcomm.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0132/2651] dt-bindings: clock: qcom,milos-videocc: Add missing power-domains support
Date: Wed, 18 Nov 2026 15:22:52 +0100
Message-ID: <20261118150252.608101989@linuxfoundation.org>
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

From: Taniya Das <taniya.das@oss.qualcomm.com>

[ Upstream commit 3da90acddd2f211549032e9fdad40a5879803442 ]

The Milos video clock controller requires the CX and MX power
domains, along with their performance state votes, to be enabled
before the clock controller can be accessed.

Document the 'power-domains' and 'required-opps' properties and add
them to the required properties list and example. Since these
properties become required for the already-documented
qcom,milos-videocc compatible, this is an ABI break for any devicetree
using this binding without specifying them.

Fixes: a4937e974186 ("dt-bindings: clock: qcom: document the Milos Video Clock Controller")
Reviewed-by: Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>
Signed-off-by: Taniya Das <taniya.das@oss.qualcomm.com>
Link: https://lore.kernel.org/r/20260806-eliza-mm-cc-v9-v10-2-6ba52dd14343@oss.qualcomm.com
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../bindings/clock/qcom,milos-videocc.yaml    | 19 +++++++++++++++++++
 1 file changed, 19 insertions(+)

diff --git a/Documentation/devicetree/bindings/clock/qcom,milos-videocc.yaml b/Documentation/devicetree/bindings/clock/qcom,milos-videocc.yaml
index 14c31efe1308a..4d8d109cd304e 100644
--- a/Documentation/devicetree/bindings/clock/qcom,milos-videocc.yaml
+++ b/Documentation/devicetree/bindings/clock/qcom,milos-videocc.yaml
@@ -26,9 +26,21 @@ properties:
       - description: Sleep clock source
       - description: Video AHB clock from GCC
 
+  power-domains:
+    items:
+      - description: CX power domain
+      - description: MX power domain
+
+  required-opps:
+    items:
+      - description: CX performance point
+      - description: MX performance point
+
 required:
   - compatible
   - clocks
+  - power-domains
+  - required-opps
 
 allOf:
   - $ref: qcom,gcc.yaml#
@@ -38,6 +50,7 @@ unevaluatedProperties: false
 examples:
   - |
     #include <dt-bindings/clock/qcom,milos-gcc.h>
+    #include <dt-bindings/power/qcom,rpmhpd.h>
     clock-controller@aaf0000 {
         compatible = "qcom,milos-videocc";
         reg = <0x0aaf0000 0x10000>;
@@ -45,6 +58,12 @@ examples:
                  <&bi_tcxo_ao_div2>,
                  <&sleep_clk>,
                  <&gcc GCC_VIDEO_AHB_CLK>;
+
+        power-domains = <&rpmhpd RPMHPD_CX>,
+                        <&rpmhpd RPMHPD_MX>;
+        required-opps = <&rpmhpd_opp_low_svs>,
+                        <&rpmhpd_opp_low_svs>;
+
         #clock-cells = <1>;
         #reset-cells = <1>;
         #power-domain-cells = <1>;
-- 
2.53.0



