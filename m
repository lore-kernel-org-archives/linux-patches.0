Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5DC9B19A29C;
	Thu, 25 Jul 2024 14:38:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721918326; cv=none; b=OoA5SRDLfnvmp50tlKabdFdqLmg/NNwd6jpt6l+Wrru+h9KH4aE8wHUW3D4lZBL2BCZVx1B3gn838q9xRXzvsX7VeGVtJ72JBT/DpVHvQwJ21W5QeVc/gjckcoDWJZK/9SuV2kIwFEKZBZ3NNX9Lk+6SVAoZix38wTvo9lV0deA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721918326; c=relaxed/simple;
	bh=J1GJWfE2i2KJGpyHwwDnrd9ImpqQGJWLSpPkvO+zSLU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oBBxlURszbEfJSSzS70QvizqzCczRdkEX/HTzeqBTcfUmZ1FSNlNZq6EbjIcHHFmT4MzQA72pBJszMNE1Gd6A61X7qTvNhotVF2TisponpPkaxV+H+x9HUTZE9Oc6db7ZS1lgIn3Fgf9BZW+NXPFBFmK5z4YNL7IoOJDP7DNb54=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iee3oue9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iee3oue9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D0052C116B1;
	Thu, 25 Jul 2024 14:38:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1721918326;
	bh=J1GJWfE2i2KJGpyHwwDnrd9ImpqQGJWLSpPkvO+zSLU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iee3oue9xPWbDhP1LJ8jiV8TwMJh9l6CNZcbzz8Axo/DNhBFPNGY2XV57thQ50z4h
	 KhgjfUwp7rjesPV9wWcLUduTx3o4JkJKNw7ZbFJOIEF31GjB5+81OxRIk4m3C2HZFp
	 A1oI+BTiF0qQQcy0T/EuM0cbD5/06z5N9NImcuSI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Abel Vesa <abel.vesa@linaro.org>,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Bjorn Andersson <andersson@kernel.org>
Subject: [PATCH 6.10 16/29] arm64: dts: qcom: x1e80100-crd: Fix the PHY regulator for PCIe 6a
Date: Thu, 25 Jul 2024 16:36:32 +0200
Message-ID: <20240725142732.425665394@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240725142731.814288796@linuxfoundation.org>
References: <20240725142731.814288796@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Abel Vesa <abel.vesa@linaro.org>

commit cf7d2157aa87dca6f078a2d4867fd0a9dbc357aa upstream.

The actual PHY regulator is L1d instead of L3j, so fix it accordingly.

Fixes: d7e03cce0400 ("arm64: dts: qcom: x1e80100-crd: Enable more support")
Signed-off-by: Abel Vesa <abel.vesa@linaro.org>
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Cc: stable@vger.kernel.org      # 6.9
Link: https://lore.kernel.org/r/20240530-x1e80100-dts-pcie6a-v1-1-ee17a9939ba5@linaro.org
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/boot/dts/qcom/x1e80100-crd.dts |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/arm64/boot/dts/qcom/x1e80100-crd.dts
+++ b/arch/arm64/boot/dts/qcom/x1e80100-crd.dts
@@ -659,7 +659,7 @@
 };
 
 &pcie6a_phy {
-	vdda-phy-supply = <&vreg_l3j_0p8>;
+	vdda-phy-supply = <&vreg_l1d_0p8>;
 	vdda-pll-supply = <&vreg_l2j_1p2>;
 
 	status = "okay";


