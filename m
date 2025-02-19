Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 107D51B6D0F;
	Wed, 19 Feb 2025 09:13:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739956412; cv=none; b=bn2cx2Ij7eY7lScx15aOSjqwTR4TTUhWXEl+5NukJWRNkHXSAlAYtiJHPP8hWniO6EYRgQWdsaOQ9LbHo92cECmAO9sZ84PHKMO2mRqaU7VNrNShMfMUIOKNqLqsDLa62erySpSx1LNIz9FDPY112Ud0c54TyxC47b6ADX2IXi8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739956412; c=relaxed/simple;
	bh=VYJOI+gcgoF9skSQe2bN2uo/aFgtRpp9z/et4TnlDzs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RUBWs/sEmIRjIfyxSAiEW9XnGhRa0yeBaUnrINmfX45b2bs4l9Z4CScitWIuCBgdB5+taG65ZX6KlZ4HVcw3p7oPv2mFqnoacWego5MS2d2C1lzviWfCFZBTbyzcZ/A21dPfrq8DrQcecxtXdTNY+lS5hRtsj9mV2ziZ4LG1wJg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OX/NQfec; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OX/NQfec"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8BE0EC4CEE6;
	Wed, 19 Feb 2025 09:13:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739956411;
	bh=VYJOI+gcgoF9skSQe2bN2uo/aFgtRpp9z/et4TnlDzs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OX/NQfecMWOiWLlNYTpM3N1MC/tYcF6l4Ep+JhTKzFSdaabH+Imp2uthGAkH2REXn
	 WGAjI89jxeFXNE+J0q0m+k+RIfpR/N/zOw/V5suQOJRk7D0jgxGhO68op+1Wa+tvB5
	 PHFusP50icC/G0aqpfpdmQJpGlcQYHVKiOFRx+KQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nikita Travkin <nikita@trvn.ru>,
	Konrad Dybcio <konrad.dybcio@linaro.org>,
	Douglas Anderson <dianders@chromium.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 170/578] arm64: dts: qcom: sc7180: Dont enable lpass clocks by default
Date: Wed, 19 Feb 2025 09:22:54 +0100
Message-ID: <20250219082659.652614135@linuxfoundation.org>
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

[ Upstream commit 43926a3cb19180b4fc6cd0d72bbefc7e93592f91 ]

lpass clocks are usually blocked from HLOS by the firmware and
instead are managed by the ADSP. Mark them as reserved and explicitly
enable in the CrOS boards that have special, cooperative firmware.

The IDP board gets lpass clocks disabled as it doesn't make use of sound
anyway and might use Qualcomm firmware that blocks those clocks. [1]

[1] https://lore.kernel.org/all/ZBJhmDd3zK%2FAiwBD@google.com/

Signed-off-by: Nikita Travkin <nikita@trvn.ru>
Reviewed-by: Konrad Dybcio <konrad.dybcio@linaro.org>
Reviewed-by: Douglas Anderson <dianders@chromium.org>
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Link: https://lore.kernel.org/r/20230515093744.289045-2-nikita@trvn.ru
Stable-dep-of: aa09de104d42 ("arm64: dts: qcom: sc7180-trogdor-quackingstick: add missing avee-supply")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/sc7180-trogdor.dtsi | 8 ++++++++
 arch/arm64/boot/dts/qcom/sc7180.dtsi         | 4 ++++
 2 files changed, 12 insertions(+)

diff --git a/arch/arm64/boot/dts/qcom/sc7180-trogdor.dtsi b/arch/arm64/boot/dts/qcom/sc7180-trogdor.dtsi
index f55ce6f2fdc28..75f05ae095be2 100644
--- a/arch/arm64/boot/dts/qcom/sc7180-trogdor.dtsi
+++ b/arch/arm64/boot/dts/qcom/sc7180-trogdor.dtsi
@@ -777,6 +777,10 @@ hp_i2c: &i2c9 {
 	};
 };
 
+&lpasscc {
+	status = "okay";
+};
+
 &lpass_cpu {
 	status = "okay";
 
@@ -802,6 +806,10 @@ hp_i2c: &i2c9 {
 	};
 };
 
+&lpass_hm {
+	status = "okay";
+};
+
 &mdp {
 	status = "okay";
 };
diff --git a/arch/arm64/boot/dts/qcom/sc7180.dtsi b/arch/arm64/boot/dts/qcom/sc7180.dtsi
index b4775159dde0b..12982fa848c68 100644
--- a/arch/arm64/boot/dts/qcom/sc7180.dtsi
+++ b/arch/arm64/boot/dts/qcom/sc7180.dtsi
@@ -3577,6 +3577,8 @@
 			power-domains = <&lpass_hm LPASS_CORE_HM_GDSCR>;
 			#clock-cells = <1>;
 			#power-domain-cells = <1>;
+
+			status = "reserved"; /* Controlled by ADSP */
 		};
 
 		lpass_cpu: lpass@62d87000 {
@@ -3622,6 +3624,8 @@
 			clock-names = "iface", "bi_tcxo";
 			#clock-cells = <1>;
 			#power-domain-cells = <1>;
+
+			status = "reserved"; /* Controlled by ADSP */
 		};
 	};
 
-- 
2.39.5



