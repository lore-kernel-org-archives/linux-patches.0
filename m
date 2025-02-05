Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D63158634E;
	Wed,  5 Feb 2025 14:26:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738765583; cv=none; b=abA6H/SEuNjSPAZwfLZ6W1X+lJKX7G5uk3R9l4yVqhknX+sBW55F+H7xRbnOxcySsN19PdaVQ1+NAa2H+1a6LJUpu4vJziKPILvubeJCnBuzyIVNroKDu3zp6NQseE/LpfWRLFGRZUgwUixzQeAPRYtDZgGltmlzlWu7LT85YQo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738765583; c=relaxed/simple;
	bh=Xw3QdAYtWHLACtImA/I5K5zsh6U7AwfF4bSHruNqYIA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XcnREay8NwgU1m9PFPqUdY75TCDzATCZDrRYI9i6YxyMqR/Il0wd24VLGpxXaL9aD4cnQkcZOfZ+hlzcvZ5SZ7U0wVtj3Fm6DgR4thGd59+t1gY61cogIf8rZhl0nOTn6jWz/mBnShZMpijqQLOroTzhxK7gqDrJVgWExczXvTo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ut/9vyQT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ut/9vyQT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5C8A2C4CED1;
	Wed,  5 Feb 2025 14:26:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738765583;
	bh=Xw3QdAYtWHLACtImA/I5K5zsh6U7AwfF4bSHruNqYIA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ut/9vyQT73/XDT8Q+IDpD6IJBOEpLCsFV0/xPZ3Av6qGdO6XHNG+HyLNURwCwPDlI
	 r8A60TypXGGK1dr4PlyEb2hXhplEPdkaYsDFnqFOqIh4YBYYTRhfhJwSncX68ZUgMw
	 5QpKjjAcBbhqo1YeywuSRotmREnvR7xeoyXOdx70=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bryan ODonoghue <bryan.odonoghue@linaro.org>,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 256/393] arm64: dts: qcom: sdm845-db845c-navigation-mezzanine: Convert mezzanine riser to dtso
Date: Wed,  5 Feb 2025 14:42:55 +0100
Message-ID: <20250205134430.102401576@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250205134420.279368572@linuxfoundation.org>
References: <20250205134420.279368572@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Bryan O'Donoghue <bryan.odonoghue@linaro.org>

[ Upstream commit 30df676a31b7a4881352097d8ae7c2bb83515a17 ]

Convert the navigation / camera mezzanine from its own dts to a dtso. A
small amount of additional includes / address / cell size change needs to
be applied to convert.

Tested-by: Bryan O'Donoghue <bryan.odonoghue@linaro.org> # rb3
Signed-off-by: Bryan O'Donoghue <bryan.odonoghue@linaro.org>
Reviewed-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Link: https://lore.kernel.org/r/20241025-b4-linux-next-24-10-25-camss-dts-fixups-v1-2-cdff2f1a5792@linaro.org
[bjorn: Corrected up makefile syntax, added missing cells for cci_i2c1]
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Stable-dep-of: 80b47f14d543 ("arm64: dts: qcom: sdm845-db845c-navigation-mezzanine: remove disabled ov7251 camera")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/Makefile                      |  3 +++
 ...ine.dts => sdm845-db845c-navigation-mezzanine.dtso} | 10 +++++++++-
 2 files changed, 12 insertions(+), 1 deletion(-)
 rename arch/arm64/boot/dts/qcom/{sdm845-db845c-navigation-mezzanine.dts => sdm845-db845c-navigation-mezzanine.dtso} (91%)

diff --git a/arch/arm64/boot/dts/qcom/Makefile b/arch/arm64/boot/dts/qcom/Makefile
index 2cca20563a1d6..0da076db0418d 100644
--- a/arch/arm64/boot/dts/qcom/Makefile
+++ b/arch/arm64/boot/dts/qcom/Makefile
@@ -171,6 +171,9 @@ dtb-$(CONFIG_ARCH_QCOM)	+= sdm845-cheza-r1.dtb
 dtb-$(CONFIG_ARCH_QCOM)	+= sdm845-cheza-r2.dtb
 dtb-$(CONFIG_ARCH_QCOM)	+= sdm845-cheza-r3.dtb
 dtb-$(CONFIG_ARCH_QCOM)	+= sdm845-db845c.dtb
+
+sdm845-db845c-navigation-mezzanine-dtbs	:= sdm845-db845c.dtb sdm845-db845c-navigation-mezzanine.dtbo
+
 dtb-$(CONFIG_ARCH_QCOM)	+= sdm845-db845c-navigation-mezzanine.dtb
 dtb-$(CONFIG_ARCH_QCOM)	+= sdm845-lg-judyln.dtb
 dtb-$(CONFIG_ARCH_QCOM)	+= sdm845-lg-judyp.dtb
diff --git a/arch/arm64/boot/dts/qcom/sdm845-db845c-navigation-mezzanine.dts b/arch/arm64/boot/dts/qcom/sdm845-db845c-navigation-mezzanine.dtso
similarity index 91%
rename from arch/arm64/boot/dts/qcom/sdm845-db845c-navigation-mezzanine.dts
rename to arch/arm64/boot/dts/qcom/sdm845-db845c-navigation-mezzanine.dtso
index a21caa6f3fa25..b5f717d0ddd97 100644
--- a/arch/arm64/boot/dts/qcom/sdm845-db845c-navigation-mezzanine.dts
+++ b/arch/arm64/boot/dts/qcom/sdm845-db845c-navigation-mezzanine.dtso
@@ -4,8 +4,10 @@
  */
 
 /dts-v1/;
+/plugin/;
 
-#include "sdm845-db845c.dts"
+#include <dt-bindings/clock/qcom,camcc-sdm845.h>
+#include <dt-bindings/gpio/gpio.h>
 
 &camss {
 	vdda-phy-supply = <&vreg_l1a_0p875>;
@@ -28,6 +30,9 @@
 };
 
 &cci_i2c0 {
+	#address-cells = <1>;
+	#size-cells = <0>;
+
 	camera@10 {
 		compatible = "ovti,ov8856";
 		reg = <0x10>;
@@ -65,6 +70,9 @@
 };
 
 &cci_i2c1 {
+	#address-cells = <1>;
+	#size-cells = <0>;
+
 	camera@60 {
 		compatible = "ovti,ov7251";
 
-- 
2.39.5



