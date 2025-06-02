Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C885D1A01C6;
	Mon,  2 Jun 2025 13:56:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748872592; cv=none; b=HhlHvrIZmy36d8rgXQKRNKY9XrBVdLdsfmGhVg3PeCfg5xqimk2e5sDLPgWxOtTeiEfzS+8PC08LHhKoRRcpka2up/lL6dnSgIz9JJHLwj8Cq/1mnwAXMTsAJAFPHpBPk6DcwDOplTy9myPIlUOvU1P4afi4OEQeNqSqeeiwWqQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748872592; c=relaxed/simple;
	bh=JzgHLVeD1neLmicwG61LNAat7eURGGPKjDl3sJk9KrU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qDlajB8nNIQ+OrOWWfOIH2Q12tkpYmAqZyLTI3s2hE/IzwVCEO3GnfT4CtIp2DBL5TmuFUji+UAmlK3dxYU9tIlb2N7zwJ6jQBKcZykXp9OXNgtaVaxOQtUM83aYr0z6OtzsNzBqhdp0tcyawrqWix2N8UAIp1YNMrqflvsxJJw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WxEbtqbS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WxEbtqbS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C93F4C4CEEB;
	Mon,  2 Jun 2025 13:56:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748872591;
	bh=JzgHLVeD1neLmicwG61LNAat7eURGGPKjDl3sJk9KrU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WxEbtqbSpBeNFu8dJWqH7B/R7pY7XvfI1Fec7icW7SFikWLMUBBuSF+J8EBYUN+KR
	 mKgCEOCoDCSuiw/HplJxLUqcUze5VNbbPJm1c81PFZ/DdbAaSLxQPQkkWVkE2luKzP
	 HNVGfzpIDYieX8v0GaH/aXtSthvPrF/olgAfeAZg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stephan Gerhold <stephan.gerhold@linaro.org>,
	Johan Hovold <johan+linaro@kernel.org>,
	Abel Vesa <abel.vesa@linaro.org>,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Bjorn Andersson <andersson@kernel.org>
Subject: [PATCH 6.14 12/73] arm64: dts: qcom: x1e001de-devkit: Fix vreg_l2j_1p2 voltage
Date: Mon,  2 Jun 2025 15:46:58 +0200
Message-ID: <20250602134242.179678671@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250602134241.673490006@linuxfoundation.org>
References: <20250602134241.673490006@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Stephan Gerhold <stephan.gerhold@linaro.org>

commit 3ed2a9e03abfeece9e30ebc746f935536f661414 upstream.

In the ACPI DSDT table, PPP_RESOURCE_ID_LDO2_J is configured with 1256000
uV instead of the 1200000 uV we have currently in the device tree. Use the
same for consistency and correctness.

Cc: stable@vger.kernel.org
Fixes: 7b8a31e82b87 ("arm64: dts: qcom: Add X1E001DE Snapdragon Devkit for Windows")
Signed-off-by: Stephan Gerhold <stephan.gerhold@linaro.org>
Reviewed-by: Johan Hovold <johan+linaro@kernel.org>
Reviewed-by: Abel Vesa <abel.vesa@linaro.org>
Reviewed-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Link: https://lore.kernel.org/r/20250423-x1e-vreg-l2j-voltage-v1-2-24b6a2043025@linaro.org
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/boot/dts/qcom/x1e001de-devkit.dts |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/arch/arm64/boot/dts/qcom/x1e001de-devkit.dts
+++ b/arch/arm64/boot/dts/qcom/x1e001de-devkit.dts
@@ -745,8 +745,8 @@
 
 		vreg_l2j_1p2: ldo2 {
 			regulator-name = "vreg_l2j_1p2";
-			regulator-min-microvolt = <1200000>;
-			regulator-max-microvolt = <1200000>;
+			regulator-min-microvolt = <1256000>;
+			regulator-max-microvolt = <1256000>;
 			regulator-initial-mode = <RPMH_REGULATOR_MODE_HPM>;
 		};
 


