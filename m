Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 247AD8F5B
	for <patches@lists.linux.dev>; Sun, 16 Jul 2023 20:28:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 95421C433C8;
	Sun, 16 Jul 2023 20:28:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1689539330;
	bh=0L5yrgvaF46IHRKW6sg6uiwR1ROOGNtyadbWlv9Csr0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iCXHy5KAqC1CAT/kL2D9BrGSkJF3uMwsBTOeDQ6HeRzpGrjBsR5VEugXQBcYhFk1F
	 qV6mgy35yEztg5i/fUUpB0zCNzM1GdQmYkRERM1sXAb5HN06dwd2tQN1ZfJp3Ln8dA
	 4syDqC3XSEuS2mZsVIQA9FLNzbLoqq2ZItpPRI8I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Konrad Dybcio <konrad.dybcio@linaro.org>,
	Manivannan Sadhasivam <mani@kernel.org>,
	Bjorn Andersson <andersson@kernel.org>
Subject: [PATCH 6.4 770/800] ARM: dts: qcom: ipq4019: fix broken NAND controller properties override
Date: Sun, 16 Jul 2023 21:50:23 +0200
Message-ID: <20230716195007.034165019@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230716194949.099592437@linuxfoundation.org>
References: <20230716194949.099592437@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>

commit edcbdd57de499305e2a3737d4a73fe387f71d84c upstream.

After renaming NAND controller node name from "qpic-nand" to
"nand-controller", the board DTS/DTSI also have to be updated:

  Warning (unit_address_vs_reg): /soc/qpic-nand@79b0000: node has a unit name, but no reg or ranges property

Cc: <stable@vger.kernel.org>
Fixes: 9e1e00f18afc ("ARM: dts: qcom: Fix node name for NAND controller node")
Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Reviewed-by: Konrad Dybcio <konrad.dybcio@linaro.org>
Reviewed-by: Manivannan Sadhasivam <mani@kernel.org>
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Link: https://lore.kernel.org/r/20230420072811.36947-1-krzysztof.kozlowski@linaro.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm/boot/dts/qcom-ipq4019-ap.dk04.1-c1.dts |    8 ++++----
 arch/arm/boot/dts/qcom-ipq4019-ap.dk04.1.dtsi   |   10 +++++-----
 arch/arm/boot/dts/qcom-ipq4019-ap.dk07.1.dtsi   |   12 ++++++------
 3 files changed, 15 insertions(+), 15 deletions(-)

--- a/arch/arm/boot/dts/qcom-ipq4019-ap.dk04.1-c1.dts
+++ b/arch/arm/boot/dts/qcom-ipq4019-ap.dk04.1-c1.dts
@@ -11,9 +11,9 @@
 		dma-controller@7984000 {
 			status = "okay";
 		};
-
-		qpic-nand@79b0000 {
-			status = "okay";
-		};
 	};
 };
+
+&nand {
+	status = "okay";
+};
--- a/arch/arm/boot/dts/qcom-ipq4019-ap.dk04.1.dtsi
+++ b/arch/arm/boot/dts/qcom-ipq4019-ap.dk04.1.dtsi
@@ -102,10 +102,10 @@
 			status = "okay";
 			perst-gpios = <&tlmm 38 GPIO_ACTIVE_LOW>;
 		};
-
-		qpic-nand@79b0000 {
-			pinctrl-0 = <&nand_pins>;
-			pinctrl-names = "default";
-		};
 	};
 };
+
+&nand {
+	pinctrl-0 = <&nand_pins>;
+	pinctrl-names = "default";
+};
--- a/arch/arm/boot/dts/qcom-ipq4019-ap.dk07.1.dtsi
+++ b/arch/arm/boot/dts/qcom-ipq4019-ap.dk07.1.dtsi
@@ -65,11 +65,11 @@
 		dma-controller@7984000 {
 			status = "okay";
 		};
-
-		qpic-nand@79b0000 {
-			pinctrl-0 = <&nand_pins>;
-			pinctrl-names = "default";
-			status = "okay";
-		};
 	};
 };
+
+&nand {
+	pinctrl-0 = <&nand_pins>;
+	pinctrl-names = "default";
+	status = "okay";
+};


