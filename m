Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C088C345EC1;
	Sat, 12 Sep 2026 14:25:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789223114; cv=none; b=n1F0GaiJQVha/I/O4Ln07+ohLXvc55YBOnHZNcxq+l0jwn6RP8vehtq+EX54q2kG+W1Eb6olg7BNyyMifj+Oxln/Qdc+SjsHxCMf14dDMFs16nlrrPQVCDWuWqD+Tx0MXqcVKAy95rCsI0sgch9TWP26Imb4RkzpBlgbbqqsxVQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789223114; c=relaxed/simple;
	bh=vohoXN2A2/vdQSO1FIMNsrftFo5pCuX4DNCVtP4tlOE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tuc6inZl1xRSFuhkgM1garRF5rpXxE1q+zMUc7WhXxSpZzsFRR/nYTpNZlSJDUGLMVXr671l3t6pxI39McfyVpRtW+8fJc8SmI6l126lD5FyPRw+GVtOM0N0QtMLt4E0LEq2m+lv4OxVp9nbkCVkXvwDZbS/SFQ8OENT+qAkaoU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OY7rUeOF; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OY7rUeOF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2136D1F000FF;
	Sat, 12 Sep 2026 14:25:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789223110;
	bh=R3Rcv3PLj7ExfVGxrL8X3wslx4QGyNJ32nH9L7uIQwo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=OY7rUeOFA91yKS+xSwbxguiC2+S/PaHomEbArY13McUoOKAnL/rMUNEYgxQ0XlWRF
	 RNqVuYwTOiHZWUvraC1qqG4lJMLXVe8CdV4x5uH2igV2SgFLTp1qpmVAh0t4fqRWFN
	 XA5idFbxFyr9kyMsbNBlvALhtTNCape0ob1RUuwM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bjorn Andersson <quic_bjorande@quicinc.com>,
	Steev Klimaszewski <steev@kali.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0680/1424] arm64: dts: qcom: sc8180x: Enable the power key
Date: Sat, 12 Sep 2026 08:51:52 +0200
Message-ID: <20260912065622.529589680@linuxfoundation.org>
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

From: Bjorn Andersson <quic_bjorande@quicinc.com>

[ Upstream commit 3706bcfbdb8aecdb506b80e45e2e5851044f1f28 ]

No input events are generated from the pressing of the power key on
either Primus or Flex 5G, because the device node isn't enabled.

Give the power key node a label and enable this for the two devices.

Signed-off-by: Bjorn Andersson <quic_bjorande@quicinc.com>
Tested-by: Steev Klimaszewski <steev@kali.org>
Link: https://lore.kernel.org/r/20240812-sc8180x-pwrkey-enable-v1-1-2bcc22133774@quicinc.com
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Stable-dep-of: d5f5c089858f ("arm64: dts: qcom: sc8180x-lenovo-flex-5g: Describe the display power net")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/sc8180x-lenovo-flex-5g.dts | 4 ++++
 arch/arm64/boot/dts/qcom/sc8180x-pmics.dtsi         | 2 +-
 arch/arm64/boot/dts/qcom/sc8180x-primus.dts         | 4 ++++
 3 files changed, 9 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/qcom/sc8180x-lenovo-flex-5g.dts b/arch/arm64/boot/dts/qcom/sc8180x-lenovo-flex-5g.dts
index 0308677335f1d..05afc9a57e968 100644
--- a/arch/arm64/boot/dts/qcom/sc8180x-lenovo-flex-5g.dts
+++ b/arch/arm64/boot/dts/qcom/sc8180x-lenovo-flex-5g.dts
@@ -475,6 +475,10 @@ &pcie3_phy {
 	status = "okay";
 };
 
+&pmc8180_pwrkey {
+	status = "okay";
+};
+
 &pmc8180c_lpg {
 	status = "okay";
 };
diff --git a/arch/arm64/boot/dts/qcom/sc8180x-pmics.dtsi b/arch/arm64/boot/dts/qcom/sc8180x-pmics.dtsi
index ddc84282f1428..68af5888b034f 100644
--- a/arch/arm64/boot/dts/qcom/sc8180x-pmics.dtsi
+++ b/arch/arm64/boot/dts/qcom/sc8180x-pmics.dtsi
@@ -77,7 +77,7 @@ pmc8180_0: pmic@0 {
 		pon: pon@800 {
 			compatible = "qcom,pm8916-pon";
 			reg = <0x0800>;
-			pwrkey {
+			pmc8180_pwrkey: pwrkey {
 				compatible = "qcom,pm8941-pwrkey";
 				interrupts = <0x0 0x8 0x0 IRQ_TYPE_EDGE_BOTH>;
 				debounce = <15625>;
diff --git a/arch/arm64/boot/dts/qcom/sc8180x-primus.dts b/arch/arm64/boot/dts/qcom/sc8180x-primus.dts
index 7c92ab433ba41..0941fc6c4cf86 100644
--- a/arch/arm64/boot/dts/qcom/sc8180x-primus.dts
+++ b/arch/arm64/boot/dts/qcom/sc8180x-primus.dts
@@ -545,6 +545,10 @@ &pcie1_phy {
 	status = "okay";
 };
 
+&pmc8180_pwrkey {
+	status = "okay";
+};
+
 &pmc8180c_lpg {
 	status = "okay";
 };
-- 
2.53.0



