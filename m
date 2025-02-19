Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B82651B6D0F;
	Wed, 19 Feb 2025 09:13:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739956417; cv=none; b=ZhTEU69+xfhbPPIfSbwwmN/uGE+FWkAViiJMdL0xrnLF14/LVrQ0vYzBnOf9cCWLtdSi15WD+JpnhoeGkkPWCZpSZiDm7ffKKZJt7KXgv975/uk6tA2KQjTxKhH0GknsfRtM/ZAtNLeaByOVk9mZ5+N0N38s1g7qXcJK7jBaWDA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739956417; c=relaxed/simple;
	bh=NVVOamABlYbmc6/1U6rwD4i9r6sFeWoU2dn35mqAnQE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DKjRPDWguzarNLDf3PDypglz0xJ2mesVVdWrH+D0sORNi8N6ZzOy2VOvL2QP3kxO5MRfR9t7cnL/xc95Xv2lrjA7YUbQEgL3vI+dgRhO0GkDQXjEUgoUPJ8LLTpJCS2Hyqzf9v16U0m5WDzogBqAkfGRVYsmDGp0YoLxu1FNwcg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BIZFhaPT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BIZFhaPT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 43A7DC4CED1;
	Wed, 19 Feb 2025 09:13:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739956417;
	bh=NVVOamABlYbmc6/1U6rwD4i9r6sFeWoU2dn35mqAnQE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BIZFhaPTqQEh6HwHw3NHkghvdxGw/2UE840WvtBSCcdj510X+pz3yaqmep5MuzLCd
	 3e1paD/3aeIwBOK5uyrSV+fCL92/qREHYKQ/u+wkTckFSszPq+SV2653AoJdoA+HY9
	 4Fe27I/82ue4ikYKrb+XMJ0QDtdQ/+I+iJYQ7xu8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nikita Travkin <nikita@trvn.ru>,
	Konrad Dybcio <konrad.dybcio@linaro.org>,
	Douglas Anderson <dianders@chromium.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 171/578] arm64: dts: qcom: sc7180: Drop redundant disable in mdp
Date: Wed, 19 Feb 2025 09:22:55 +0100
Message-ID: <20250219082659.696215681@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250219082652.891560343@linuxfoundation.org>
References: <20250219082652.891560343@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nikita Travkin <nikita@trvn.ru>

[ Upstream commit 39238382c4991d7d9442de4aa6636b19355be1e9 ]

mdss is useless without a display controller which makes explicitly
enabling mdp redundant. Have it enabled by default to drop the extra
node for all users.

Signed-off-by: Nikita Travkin <nikita@trvn.ru>
Reviewed-by: Konrad Dybcio <konrad.dybcio@linaro.org>
Reviewed-by: Douglas Anderson <dianders@chromium.org>
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Link: https://lore.kernel.org/r/20230515093744.289045-3-nikita@trvn.ru
Stable-dep-of: aa09de104d42 ("arm64: dts: qcom: sc7180-trogdor-quackingstick: add missing avee-supply")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/sc7180-idp.dts      | 4 ----
 arch/arm64/boot/dts/qcom/sc7180-trogdor.dtsi | 4 ----
 arch/arm64/boot/dts/qcom/sc7180.dtsi         | 2 --
 3 files changed, 10 deletions(-)

diff --git a/arch/arm64/boot/dts/qcom/sc7180-idp.dts b/arch/arm64/boot/dts/qcom/sc7180-idp.dts
index ebb4f4541e14d..02b507691cc33 100644
--- a/arch/arm64/boot/dts/qcom/sc7180-idp.dts
+++ b/arch/arm64/boot/dts/qcom/sc7180-idp.dts
@@ -328,10 +328,6 @@
 	vdds-supply = <&vreg_l4a_0p8>;
 };
 
-&mdp {
-	status = "okay";
-};
-
 &mdss {
 	status = "okay";
 };
diff --git a/arch/arm64/boot/dts/qcom/sc7180-trogdor.dtsi b/arch/arm64/boot/dts/qcom/sc7180-trogdor.dtsi
index 75f05ae095be2..d537b8784b472 100644
--- a/arch/arm64/boot/dts/qcom/sc7180-trogdor.dtsi
+++ b/arch/arm64/boot/dts/qcom/sc7180-trogdor.dtsi
@@ -810,10 +810,6 @@ hp_i2c: &i2c9 {
 	status = "okay";
 };
 
-&mdp {
-	status = "okay";
-};
-
 &mdss {
 	status = "okay";
 };
diff --git a/arch/arm64/boot/dts/qcom/sc7180.dtsi b/arch/arm64/boot/dts/qcom/sc7180.dtsi
index 12982fa848c68..3a13cc02c9832 100644
--- a/arch/arm64/boot/dts/qcom/sc7180.dtsi
+++ b/arch/arm64/boot/dts/qcom/sc7180.dtsi
@@ -2937,8 +2937,6 @@
 				interrupt-parent = <&mdss>;
 				interrupts = <0>;
 
-				status = "disabled";
-
 				ports {
 					#address-cells = <1>;
 					#size-cells = <0>;
-- 
2.39.5



