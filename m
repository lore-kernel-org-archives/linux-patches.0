Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 257A8221F11;
	Mon,  2 Jun 2025 14:00:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748872836; cv=none; b=tlyC2VKKAEkljtTSrGIIAANEkxM75brI7a/ae5BU3smFz/60ybI5MVYOFGGsPyukMg4h4Iip3PRB32QnvfZGnTlrV2ImiLuwpQi308JU8tsmALc0nR9RWSgh/KWoZytyCwqG6Ey4boORlONNkKPxPidd7m7VF+S5xfXh8XSe5Bg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748872836; c=relaxed/simple;
	bh=JCg3lMgEhZa13QvLWJ5LIbrQVSl4h8+9fkZryeQKYg4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LCJTxsETgUeq5w8+GptOM2pYOWa1a2uE5jY1+rWgjczB9zP92wVcIrQfUtTWfUnlAdEiAF3Lws17W4FtL+qkN/vKewKno0ZFT8lExg3o5Oy0M8WxZmMHaoLJ6hpKyyL2xkO9utDztoUMPFR1yWIBA3c0wwLZmp2DvgofVOCIWEY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VHZHttfZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VHZHttfZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A2B4FC4CEEB;
	Mon,  2 Jun 2025 14:00:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748872836;
	bh=JCg3lMgEhZa13QvLWJ5LIbrQVSl4h8+9fkZryeQKYg4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VHZHttfZuEAlcQ5grjEeBqxsKw2r8yViT+9JL3JXAvm5HvpC85oNpKrRjNLl3cXig
	 7fRADa9XdbVD+IscjfFNxzvz/AxJ2anFLj/kFHnbAf2j6+V3maC8eEnhEDeTa2L29V
	 8fQvoI5FahSP2mNBoxk2IwNwrP9rbEDahivaIAh0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stephan Gerhold <stephan.gerhold@linaro.org>,
	Johan Hovold <johan+linaro@kernel.org>,
	Abel Vesa <abel.vesa@linaro.org>,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Bjorn Andersson <andersson@kernel.org>
Subject: [PATCH 6.12 11/55] arm64: dts: qcom: x1e80100-qcp: Fix vreg_l2j_1p2 voltage
Date: Mon,  2 Jun 2025 15:47:28 +0200
Message-ID: <20250602134238.720340533@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250602134238.271281478@linuxfoundation.org>
References: <20250602134238.271281478@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Stephan Gerhold <stephan.gerhold@linaro.org>

commit efdbeae860bf0278b050c6c9ad5921afba4596d0 upstream.

In the ACPI DSDT table, PPP_RESOURCE_ID_LDO2_J is configured with 1256000
uV instead of the 1200000 uV we have currently in the device tree. Use the
same for consistency and correctness.

Cc: stable@vger.kernel.org
Fixes: af16b00578a7 ("arm64: dts: qcom: Add base X1E80100 dtsi and the QCP dts")
Signed-off-by: Stephan Gerhold <stephan.gerhold@linaro.org>
Reviewed-by: Johan Hovold <johan+linaro@kernel.org>
Reviewed-by: Abel Vesa <abel.vesa@linaro.org>
Reviewed-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Link: https://lore.kernel.org/r/20250423-x1e-vreg-l2j-voltage-v1-6-24b6a2043025@linaro.org
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/boot/dts/qcom/x1e80100-qcp.dts |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/arch/arm64/boot/dts/qcom/x1e80100-qcp.dts
+++ b/arch/arm64/boot/dts/qcom/x1e80100-qcp.dts
@@ -594,8 +594,8 @@
 
 		vreg_l2j_1p2: ldo2 {
 			regulator-name = "vreg_l2j_1p2";
-			regulator-min-microvolt = <1200000>;
-			regulator-max-microvolt = <1200000>;
+			regulator-min-microvolt = <1256000>;
+			regulator-max-microvolt = <1256000>;
 			regulator-initial-mode = <RPMH_REGULATOR_MODE_HPM>;
 		};
 


