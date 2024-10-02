Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B1291D0438;
	Wed,  2 Oct 2024 13:51:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727877086; cv=none; b=YCQwf+F4WwYo0zmckf4Ib/GVKOsgpmAwnLFhYPuJz7O7YB6WzAf1ulY+i6iNVvolDor3UDMTiIF25E3ltsoZGj6eRpmjvNMV4/xrqTYek/ifNT5AmMBAaxkfwQ9FOEWKSV6bGx5hcPSLkZDIBa9XCf72awO5ouimkrioJrsje+Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727877086; c=relaxed/simple;
	bh=egZSNyze5HfnB5pJNl2WAdAoLLt8PDZ1b/WKskvXbwE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pob6239fUJBWzg65Z5ygiXbcj7mjIKVlBqr7gZGDaiwgAGWJqZBoR52pWc9CPXR1lqZLiZ+ai/zHxgYaa5x3ES5Obx+AGK8y8B8mYIn0nHIw5dsJCVh9nOHeoyZBHeXs/ozeCL0Mc5UxgPjNULZSEciiegOtcMrXc6GsykgA2VU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FbXU31FX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FbXU31FX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 86469C4CEC2;
	Wed,  2 Oct 2024 13:51:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727877085;
	bh=egZSNyze5HfnB5pJNl2WAdAoLLt8PDZ1b/WKskvXbwE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FbXU31FXf61A8i/HkIKn5oQtKqp+e9qZ1s9tFT8CFiKWkct9Qg0rLQ0ICNomiou2K
	 m9O9vn/X1vkK1iLcF6D7Jyyk/d4D7IK1qa2rMSqBGY/IqS+h2Djqc/bRC+pKyS9DbK
	 ePbwZG5/z4Yx/6YdaReE9dkORibnpc9di0VJCcAM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Michael Trimarchi <michael@amarulasolutions.com>,
	Shawn Guo <shawnguo@kernel.org>
Subject: [PATCH 6.11 658/695] ARM: dts: imx6ul-geam: fix fsl,pins property in tscgrp pinctrl
Date: Wed,  2 Oct 2024 15:00:56 +0200
Message-ID: <20241002125848.775384033@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125822.467776898@linuxfoundation.org>
References: <20241002125822.467776898@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

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
@@ -365,7 +365,7 @@
 	};
 
 	pinctrl_tsc: tscgrp {
-		fsl,pin = <
+		fsl,pins = <
 			MX6UL_PAD_GPIO1_IO01__GPIO1_IO01	0xb0
 			MX6UL_PAD_GPIO1_IO02__GPIO1_IO02	0xb0
 			MX6UL_PAD_GPIO1_IO03__GPIO1_IO03	0xb0


