Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B21E53382CB;
	Sat, 12 Sep 2026 14:25:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789223107; cv=none; b=ZRHiQ61kFqecRsNazP0mysZhA6z4meEi0qA04L65m0+22Ol6v/7meJbYhMlEVxjKMlmHkn1BpYqvZ7v8JakMtFjm+QnpL8KiP/rwjuNFs8oiRcE5LFV7jWueVb2IPgezKwcMFT5l77aeXPjuM2LLDN6K6Z34FPqizu2bawc4IPA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789223107; c=relaxed/simple;
	bh=7+h55i5oCWeCo144xGKjt0Xt7oJA8vyqeZxUozrOHYw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kqTk1F7LdxmV4uyAZLyqIuKJSr+AwaZG0eL2ex743zoSehqh/BAjbT1/DKjcilkiFhRNpyYQ0nvkXttqDSQN6MqdRDWDxjkGPk1Bf5jENZQnLqmPNDhG3WWdj8bgTlgO5PaPBrs4eygM+8LcdbZqeq8P0FB1l70tZTFduOlc8P0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GHU8vY91; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GHU8vY91"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 171F91F000FF;
	Sat, 12 Sep 2026 14:25:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789223105;
	bh=li1bzFv/RavvV9oZClCc+J1FsY3AJtEavmo7JZpovwE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=GHU8vY91Bzi7+WO3Di2lJyxYDv0Nbf2bK4lhoDSqPg7rqi3sNPtGU+Vlou90HqQkP
	 dtlkj9i7BuEvNTdTWlLuljbm8CxMuvb+39tyXZ9rBocrC7u+P9Ps1GxPGgPmK9Hd7Z
	 5dqq4h9wQEM4TtqLt7wdULWk54fgBxr8zQVASxCc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Anton Bambura <jenneron@postmarketos.org>,
	Konrad Dybcio <konrad.dybcio@linaro.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0679/1424] arm64: dts: qcom: sc8180x-lenovo-flex-5g: move pinctrl to appropriate nodes
Date: Sat, 12 Sep 2026 08:51:51 +0200
Message-ID: <20260912065622.506068465@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.279695368@linuxfoundation.org>
References: <20260912065607.279695368@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Anton Bambura <jenneron@postmarketos.org>

[ Upstream commit 0d76ffe33e5eb5b0a7bd09e4fa8a72f7f4cfbc0d ]

Split keyboard and touchpad pinctrl nodes since they are for different
devices and move keyboard, touchpad and touchscreen pinctrl references to
appropriate nodes.

Signed-off-by: Anton Bambura <jenneron@postmarketos.org>
Reviewed-by: Konrad Dybcio <konrad.dybcio@linaro.org>
Link: https://lore.kernel.org/r/20240203191200.99185-4-jenneron@postmarketos.org
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Stable-dep-of: d5f5c089858f ("arm64: dts: qcom: sc8180x-lenovo-flex-5g: Describe the display power net")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../boot/dts/qcom/sc8180x-lenovo-flex-5g.dts  | 41 +++++++++++++------
 1 file changed, 29 insertions(+), 12 deletions(-)

diff --git a/arch/arm64/boot/dts/qcom/sc8180x-lenovo-flex-5g.dts b/arch/arm64/boot/dts/qcom/sc8180x-lenovo-flex-5g.dts
index abc66613ccaad..0308677335f1d 100644
--- a/arch/arm64/boot/dts/qcom/sc8180x-lenovo-flex-5g.dts
+++ b/arch/arm64/boot/dts/qcom/sc8180x-lenovo-flex-5g.dts
@@ -356,7 +356,7 @@ zap-shader {
 &i2c1 {
 	clock-frequency = <100000>;
 
-	pinctrl-0 = <&i2c1_active>, <&i2c1_hid_active>;
+	pinctrl-0 = <&i2c1_active>;
 	pinctrl-names = "default";
 
 	status = "okay";
@@ -367,13 +367,16 @@ hid@10 {
 		hid-descr-addr = <0x1>;
 
 		interrupts-extended = <&tlmm 122 IRQ_TYPE_LEVEL_LOW>;
+
+		pinctrl-0 = <&ts_int_default>;
+		pinctrl-names = "default";
 	};
 };
 
 &i2c7 {
 	clock-frequency = <100000>;
 
-	pinctrl-0 = <&i2c7_active>, <&i2c7_hid_active>;
+	pinctrl-0 = <&i2c7_active>;
 	pinctrl-names = "default";
 
 	status = "okay";
@@ -384,6 +387,9 @@ hid@5 {
 		hid-descr-addr = <0x20>;
 
 		interrupts-extended = <&tlmm 37 IRQ_TYPE_LEVEL_LOW>;
+
+		pinctrl-0 = <&kb_int_default>;
+		pinctrl-names = "default";
 	};
 
 	hid@2c {
@@ -392,6 +398,9 @@ hid@2c {
 		hid-descr-addr = <0x20>;
 
 		interrupts-extended = <&tlmm 24 IRQ_TYPE_LEVEL_LOW>;
+
+		pinctrl-0 = <&tp_int_default>;
+		pinctrl-names = "default";
 	};
 };
 
@@ -668,14 +677,6 @@ i2c1_active: i2c1-active-state {
 		drive-strength = <2>;
 	};
 
-	i2c1_hid_active: i2c1-hid-active-state {
-		pins = "gpio122";
-		function = "gpio";
-
-		bias-pull-up;
-		drive-strength = <2>;
-	};
-
 	i2c7_active: i2c7-active-state {
 		pins = "gpio98", "gpio99";
 		function = "qup7";
@@ -684,8 +685,8 @@ i2c7_active: i2c7-active-state {
 		drive-strength = <2>;
 	};
 
-	i2c7_hid_active: i2c7-hid-active-state {
-		pins = "gpio37", "gpio24";
+	kb_int_default: kb-int-default-state {
+		pins = "gpio37";
 		function = "gpio";
 
 		bias-pull-up;
@@ -717,6 +718,22 @@ wake-n-pins {
 		};
 	};
 
+	tp_int_default: tp-int-default-state {
+		pins = "gpio24";
+		function = "gpio";
+
+		bias-pull-up;
+		drive-strength = <2>;
+	};
+
+	ts_int_default: ts-int-default-state {
+		pins = "gpio122";
+		function = "gpio";
+
+		bias-pull-up;
+		drive-strength = <2>;
+	};
+
 	usbprim_sbu_default: usbprim-sbu-state {
 		oe-n-pins {
 			pins = "gpio152";
-- 
2.53.0



