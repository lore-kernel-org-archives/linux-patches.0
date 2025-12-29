Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B041327BF3;
	Mon, 29 Dec 2025 16:27:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767025673; cv=none; b=pbo2mf4cyo4Iv9Ohd7CYjY874apQFbhWGFr0w0LaFxee8c6WByuDbUFA1dlG+g1XqtUMc/WPQm5v5ZxDo56ecPgSjlXkx28Wgbkx9yx8nlUVw/Jhy7oqMq7OKuTkcRVEG5Z28e3X8r2DH2ZzoWo7h22vCPDdqk1o1Ed5TnMxzNY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767025673; c=relaxed/simple;
	bh=JbIMtyrRwF1BvESZrvSoVaaYPf3Fn8BHJ5AtDgCTyJo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Zcg4bd6ROIStpS2Lk+cbVgT9iyVuvA074JqnRa9KGskxC0kxrxsBQRnEIO1SzWhA4hkxHRLLYPmCG8pA7465jT9FVQZ8AVY3MxUHuNlconghlcoHlb7D1GJ46TIizqf/CUk9uYxpVx7cszeKFNFDYCr0qDSk1GTVqVm5k6miGYw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=udCyB3lI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="udCyB3lI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AD159C4CEF7;
	Mon, 29 Dec 2025 16:27:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767025673;
	bh=JbIMtyrRwF1BvESZrvSoVaaYPf3Fn8BHJ5AtDgCTyJo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=udCyB3lIqsGNxioDB6agJRkEKXSGH6LfmPhlmnJGFvn0NmsEOBbPIAU6P1NdCBM/T
	 UuX4SrqfEvBdtcVNrOpL8s+X/mpIc7PksdAceug7wqNXLmZLRHrpZGAKJ4GM3HmzXX
	 d3jCeyz1Ukh1CTm4SqekcrbdctV+ygdV8U0tk8vs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Rob Herring <robh@kernel.org>,
	Srinivas Kandagatla <srinivas.kandagatla@oss.qualcomm.com>,
	Srinivas Kandagatla <srini@kernel.org>
Subject: [PATCH 6.18 296/430] dt-bindings: slimbus: fix warning from example
Date: Mon, 29 Dec 2025 17:11:38 +0100
Message-ID: <20251229160735.231712907@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251229160724.139406961@linuxfoundation.org>
References: <20251229160724.139406961@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Srinivas Kandagatla <srinivas.kandagatla@oss.qualcomm.com>

commit 4d4e746aa9f0f07261dcb41e4f51edb98723dcaa upstream.

Fix below warnings generated dt_bindings_check for examples in the
bindings.

Documentation/devicetree/bindings/slimbus/slimbus.example.dtb:
slim@28080000 (qcom,slim-ngd-v1.5.0): 'audio-codec@1,0' does not match
any of the regexes: '^pinctrl-[0-9]+$', '^slim@[0-9a-f]+$'
        from schema $id:
http://devicetree.org/schemas/slimbus/qcom,slim-ngd.yaml#
Documentation/devicetree/bindings/slimbus/slimbus.example.dtb:
slim@28080000 (qcom,slim-ngd-v1.5.0): #address-cells: 1 was expected
        from schema $id:
http://devicetree.org/schemas/slimbus/qcom,slim-ngd.yaml#
Documentation/devicetree/bindings/slimbus/slimbus.example.dtb:
slim@28080000 (qcom,slim-ngd-v1.5.0): 'dmas' is a required property
        from schema $id:
http://devicetree.org/schemas/slimbus/qcom,slim-ngd.yaml#
Documentation/devicetree/bindings/slimbus/slimbus.example.dtb:
slim@28080000 (qcom,slim-ngd-v1.5.0): 'dma-names' is a required
property
        from schema $id:
http://devicetree.org/schemas/slimbus/qcom,slim-ngd.yaml#

Fixes: 7cbba32a2d62 ("slimbus: qcom: remove unused qcom controller driver")
Cc: stable <stable@kernel.org>
Reported-by: Rob Herring <robh@kernel.org>
Signed-off-by: Srinivas Kandagatla <srinivas.kandagatla@oss.qualcomm.com>
Acked-by: Rob Herring (Arm) <robh@kernel.org>
Signed-off-by: Srinivas Kandagatla <srini@kernel.org>
Link: https://patch.msgid.link/20251114110505.143105-1-srini@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 .../devicetree/bindings/slimbus/slimbus.yaml     | 16 +++++++++++-----
 1 file changed, 11 insertions(+), 5 deletions(-)

diff --git a/Documentation/devicetree/bindings/slimbus/slimbus.yaml b/Documentation/devicetree/bindings/slimbus/slimbus.yaml
index 89017d9cda10..5a941610ce4e 100644
--- a/Documentation/devicetree/bindings/slimbus/slimbus.yaml
+++ b/Documentation/devicetree/bindings/slimbus/slimbus.yaml
@@ -75,16 +75,22 @@ examples:
         #size-cells = <1>;
         ranges;
 
-        slim@28080000 {
+        controller@28080000 {
             compatible = "qcom,slim-ngd-v1.5.0";
             reg = <0x091c0000 0x2c000>;
             interrupts = <GIC_SPI 163 IRQ_TYPE_LEVEL_HIGH>;
-            #address-cells = <2>;
+            dmas = <&slimbam 3>, <&slimbam 4>;
+            dma-names = "rx", "tx";
+            #address-cells = <1>;
             #size-cells = <0>;
-
-            audio-codec@1,0 {
+            slim@1 {
+              reg = <1>;
+              #address-cells = <2>;
+              #size-cells = <0>;
+              codec@1,0 {
                 compatible = "slim217,1a0";
                 reg = <1 0>;
+              };
             };
+          };
         };
-    };
-- 
2.52.0



