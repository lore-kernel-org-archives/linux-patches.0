Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 958341D0412;
	Wed,  2 Oct 2024 14:22:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727878949; cv=none; b=M3B17E7u9Nff6UuAxnhFhJuai3pG+4EsANboTff8RHbI40OU23ACrppU4u2bW4SLHthJkA/k1eWS9Y8FHgY4dk8xLdGYaRYbpFZpdLaCu7PdzT6HhVkN/Bk5BTqTcwm1/mFy1QLY0+Hll8xec8nvxyxHuntbqgtHvfb7zexNHH8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727878949; c=relaxed/simple;
	bh=Z00XGJ1LYGHwpYqcw7yw6K5f4sMIohAVgie9IRIoKPU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lsG+IODzaTOiBKkdYj/Mjq5Oots6UOaxv3g+mjXpxxvaZQtBW/eSUPb+efU02djuowhBLMb/hixSWmfYlblQhKTP4Jh2Zyg3Be67B4zef69Zwc6Hvhoj0F9I4nlJEM/WTEyVh0tckuINiidXRP65f2/iWMONkxTOeCfk3t24DL4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mdksIPrB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mdksIPrB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 20CF9C4CEC2;
	Wed,  2 Oct 2024 14:22:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727878949;
	bh=Z00XGJ1LYGHwpYqcw7yw6K5f4sMIohAVgie9IRIoKPU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mdksIPrBSUUtTNRQmQ0S5gdQsEM3tfPvOdMDSbPQ90SRLukMNAwFR7/FqDYmTRENE
	 3HZ1Q+fwd8H6R4qxlbzzSWE+jYVpsXc2DXeSh041UJjeML2Bnjmpf0UTpWnzKEk94E
	 ob5vwyZPPX8I/T0rjVb3dw8eaZan0jML52EI31xg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Michael Trimarchi <michael@amarulasolutions.com>,
	Shawn Guo <shawnguo@kernel.org>
Subject: [PATCH 6.10 588/634] ARM: dts: imx6ul-geam: fix fsl,pins property in tscgrp pinctrl
Date: Wed,  2 Oct 2024 15:01:28 +0200
Message-ID: <20241002125834.324244843@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125811.070689334@linuxfoundation.org>
References: <20241002125811.070689334@linuxfoundation.org>
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


