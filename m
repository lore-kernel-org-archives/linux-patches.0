Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF4EE31A7F5;
	Tue, 16 Dec 2025 12:11:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765887076; cv=none; b=Ta+292+GnmOyqGCuOyxYLaGfP0S8jlWY00Un/VuM72ZfSn40Z+/y+tEiVrDf3hZ7YAqv0mkh9pwsY2a65naVN/EPwNGqx86+rsXQA7m4VoZTOKAav2KshuhdIaRkWDEuey2Z+2VDPB/W9I3SxwxPSEUv0uDlz5EX/IczSkPlb4Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765887076; c=relaxed/simple;
	bh=bNhNA8CjNY6+2EQmLoo+vb0cRl8yW0iiqQbbVBkXHlg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ed/Pc4joStJig/f4a5n/FhkSjagMo3yf+hKeWGeVqbZMnIHB+nincvpLG5QTfAKEjSdii+nzpGQIIiCOOvjeUdAIGmQ0drbYO9kPjEkkW/FcX0WOXwHC33TGBE+H0FiJWxThf0xqRA70rLLILDAurdM5w7zU60Z+pezysBdxt7E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oAhUNIVH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oAhUNIVH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 257E7C4CEF1;
	Tue, 16 Dec 2025 12:11:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765887076;
	bh=bNhNA8CjNY6+2EQmLoo+vb0cRl8yW0iiqQbbVBkXHlg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oAhUNIVHFUitNS8Kj0xB0jbsRNSynX6CQaSmZ3CKR/m5lypcPrIGik+nm9DLFz1Ut
	 ViXJkDS5cqABVRTLoa0IWOI9Xhboy2rCGBnh7BUMpKmE0dRQE+CmrOZP3+AUJ6qhlh
	 3LhFTVMUJKtq5MvmtbfWzqhEpuO70oOn82xMv3wY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Krishna Chaitanya Chundru <krishna.chundru@oss.qualcomm.com>,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 119/614] arm64: dts: qcom: sm8750-mtp: move PCIe GPIOs to pcieport0 node
Date: Tue, 16 Dec 2025 12:08:06 +0100
Message-ID: <20251216111405.648304193@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251216111401.280873349@linuxfoundation.org>
References: <20251216111401.280873349@linuxfoundation.org>
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

From: Krishna Chaitanya Chundru <krishna.chundru@oss.qualcomm.com>

[ Upstream commit cc8056a16472d186140d1a66ed5648cee41f4379 ]

Relocate the wake-gpios and perst-gpios properties from the pcie0
controller node to the pcieport0 node. These GPIOs are associated with
the PCIe root port and should reside under the pcieport0 node.

Also rename perst-gpios to reset-gpios to match the expected property name
in the PCIe port node.

Fixes: 141714e163bb ("arm64: dts: qcom: sm8750-mtp: Add WiFi and Bluetooth")
Signed-off-by: Krishna Chaitanya Chundru <krishna.chundru@oss.qualcomm.com>
Reviewed-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Tested-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Link: https://lore.kernel.org/r/20251008-sm8750-v1-1-daeadfcae980@oss.qualcomm.com
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/sm8750-mtp.dts | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/arm64/boot/dts/qcom/sm8750-mtp.dts b/arch/arm64/boot/dts/qcom/sm8750-mtp.dts
index 3bbb53b7c71f3..45b5f75815670 100644
--- a/arch/arm64/boot/dts/qcom/sm8750-mtp.dts
+++ b/arch/arm64/boot/dts/qcom/sm8750-mtp.dts
@@ -960,9 +960,6 @@ &pon_resin {
 };
 
 &pcie0 {
-	wake-gpios = <&tlmm 104 GPIO_ACTIVE_HIGH>;
-	perst-gpios = <&tlmm 102 GPIO_ACTIVE_LOW>;
-
 	pinctrl-0 = <&pcie0_default_state>;
 	pinctrl-names = "default";
 
@@ -977,6 +974,9 @@ &pcie0_phy {
 };
 
 &pcieport0 {
+	wake-gpios = <&tlmm 104 GPIO_ACTIVE_HIGH>;
+	reset-gpios = <&tlmm 102 GPIO_ACTIVE_LOW>;
+
 	wifi@0 {
 		compatible = "pci17cb,1107";
 		reg = <0x10000 0x0 0x0 0x0 0x0>;
-- 
2.51.0



