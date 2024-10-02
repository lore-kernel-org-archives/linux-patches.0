Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EAB922F44;
	Wed,  2 Oct 2024 14:48:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727880504; cv=none; b=Z317nAKR8rGfvhgYYtWiaMNHCCWBRP3ch/2oUFG2H9FgZkXxIDDd35aWdLvqvyqLHm8kbrpMygdCiPbsYxyZyjmtAMq+OwtbY5BJtcdSLEd5ATkHCmyIfNq58xqyNG8XEDKulInx8OBsV4UFWkLfLFPpcxGbJaK3ulSWoSShRgM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727880504; c=relaxed/simple;
	bh=sEhVGrWJ7do3RbB1VfqcBpUuDBXoFJMbFqnkYkSUkGU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GIOxsVhRURI/CCaHuy3Tw1jFEJZIIACzcnOY2k8xpSdOz9Awl6KXoGsjX5AFFz+vtUFAE7NZ8Kgt7xrz/ZSAa2oLnS/U0g+45AvBicOzpBW2mVdRfBQWLXQ/B+k/UI5EICTy4PsSEyTuTiAF4gpCvAxdzYyTasQ3fdJAu3r+nwY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XnG3aYAv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XnG3aYAv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 76CDBC4CEC2;
	Wed,  2 Oct 2024 14:48:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727880503;
	bh=sEhVGrWJ7do3RbB1VfqcBpUuDBXoFJMbFqnkYkSUkGU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XnG3aYAvcVdbaOiaJ5szgmf2SxRlnVB1nq5F7h1eX9lVjO0TvS6hl05/p+4LUyWb5
	 UHIssuO9pIYLTVxc43KqabfZhF9QnG0xhfx5/w692Fjs9pDWTRErCWHpFr2h/tL10f
	 GOYpdlKWSWbGCCohYF7o8U19uNtI6+vqjMUfUpLE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Michael Trimarchi <michael@amarulasolutions.com>,
	Shawn Guo <shawnguo@kernel.org>
Subject: [PATCH 6.6 482/538] ARM: dts: imx6ul-geam: fix fsl,pins property in tscgrp pinctrl
Date: Wed,  2 Oct 2024 15:02:01 +0200
Message-ID: <20241002125811.469418156@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125751.964700919@linuxfoundation.org>
References: <20241002125751.964700919@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>

commit 1b0e32753d8550908dff8982410357b5114be78c upstream.

The property is "fsl,pins", not "fsl,pin".  Wrong property means the pin
configuration was not applied.  Fixes dtbs_check warnings:

  imx6ul-geam.dtb: pinctrl@20e0000: tscgrp: 'fsl,pins' is a required property
  imx6ul-geam.dtb: pinctrl@20e0000: tscgrp: 'fsl,pin' does not match any of the regexes: 'pinctrl-[0-9]+'

Cc: stable@vger.kernel.org
Fixes: a58e4e608bc8 ("ARM: dts: imx6ul-geam: Add Engicam IMX6UL GEA M6UL initial support")
Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Reviewed-by: Michael Trimarchi <michael@amarulasolutions.com>
Signed-off-by: Shawn Guo <shawnguo@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm/boot/dts/nxp/imx/imx6ul-geam.dts |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/arm/boot/dts/nxp/imx/imx6ul-geam.dts
+++ b/arch/arm/boot/dts/nxp/imx/imx6ul-geam.dts
@@ -366,7 +366,7 @@
 	};
 
 	pinctrl_tsc: tscgrp {
-		fsl,pin = <
+		fsl,pins = <
 			MX6UL_PAD_GPIO1_IO01__GPIO1_IO01	0xb0
 			MX6UL_PAD_GPIO1_IO02__GPIO1_IO02	0xb0
 			MX6UL_PAD_GPIO1_IO03__GPIO1_IO03	0xb0


