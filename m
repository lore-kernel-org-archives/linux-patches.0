Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2DEB028EB
	for <patches@lists.linux.dev>; Mon, 30 Jan 2023 14:10:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 94B35C433EF;
	Mon, 30 Jan 2023 14:10:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1675087848;
	bh=yUHBjmFLjMYwcY7SnUyKxfiSPXFDJoUe+TS5m1cXtXg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BTjG8mPO/oTl1+OsDmfVkXLaoZdLU0fNOqjjsHe/aADQwo0Yk0x8fWYlComvNJp99
	 Z3YPfu+Ze8C5my033mMFDglTh5PYtxJs9DIpdAHJPicsMsx7cisn8bO1T5Imgc9eO5
	 Qa3TWyoAYAQAJ447s7YHKeGkihjbxHPzmM0vWpqc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Konrad Dybcio <konrad.dybcio@somainline.org>,
	Bjorn Andersson <bjorn.andersson@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 029/204] arm64: dts: qcom: msm8992-libra: Add CPU regulators
Date: Mon, 30 Jan 2023 14:49:54 +0100
Message-Id: <20230130134317.593770470@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230130134316.327556078@linuxfoundation.org>
References: <20230130134316.327556078@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Konrad Dybcio <konrad.dybcio@somainline.org>

[ Upstream commit 13cff03303676148bc8f0bbe73a6d40d5fdd020e ]

Specify CPU regulator voltages for both VDD_APC rails.

Signed-off-by: Konrad Dybcio <konrad.dybcio@somainline.org>
Signed-off-by: Bjorn Andersson <bjorn.andersson@linaro.org>
Link: https://lore.kernel.org/r/20220319174645.340379-3-konrad.dybcio@somainline.org
Stable-dep-of: 69876bc6fd4d ("arm64: dts: qcom: msm8992-libra: Fix the memory map")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../boot/dts/qcom/msm8992-xiaomi-libra.dts      | 17 +++++++++++++++++
 1 file changed, 17 insertions(+)

diff --git a/arch/arm64/boot/dts/qcom/msm8992-xiaomi-libra.dts b/arch/arm64/boot/dts/qcom/msm8992-xiaomi-libra.dts
index a3d6340a0c55..d55de06447f6 100644
--- a/arch/arm64/boot/dts/qcom/msm8992-xiaomi-libra.dts
+++ b/arch/arm64/boot/dts/qcom/msm8992-xiaomi-libra.dts
@@ -125,6 +125,23 @@ &peripheral_region {
 	no-map;
 };
 
+&pm8994_spmi_regulators {
+	VDD_APC0: s8 {
+		regulator-min-microvolt = <680000>;
+		regulator-max-microvolt = <1180000>;
+		regulator-always-on;
+		regulator-boot-on;
+	};
+
+	/* APC1 is 3-phase, but quoting downstream, s11 is "the gang leader" */
+	VDD_APC1: s11 {
+		regulator-min-microvolt = <700000>;
+		regulator-max-microvolt = <1225000>;
+		regulator-always-on;
+		regulator-boot-on;
+	};
+};
+
 &rpm_requests {
 	pm8994-regulators {
 		compatible = "qcom,rpm-pm8994-regulators";
-- 
2.39.0



