Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EBC593BF2E6;
	Thu, 15 Jan 2026 17:09:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768496956; cv=none; b=ll/WWCAu9OdA3AZMeqGBPGrgpflPY/6P+W+A0FdPVtcfOeL3yv5mvK7OiOWT6mBUi3Jlg+0IylnPoFXVVxvE/xZZOpMgjA3I0nsOkkzJz9N57JyS/JeqbzCtGET9e6fzr2jvWIEWEkg2V5JV1Fmnrdu0HcYcFxDnGjW0Gq5/Y5Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768496956; c=relaxed/simple;
	bh=dhQssuoaF0w7ohMdGPwH4bWvxbZr3/a1+6JNbvbQTNs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YPHO1FJ+pQwgxqq5DXr3K/CQd3/t0kZ1pExbPQ/YtxLXkBYcM/5ZF+b6GhlV3tAGn/skhwee8lmlT4SFiTcjQygSjgNsFLUcoISBpe4jamoPxd948UKiZsC2CabzqvyCD4NDDoHYHvBZ9EHwSyMkZJ5dzKtpFMKmu9i5crpMGcA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XnjSUSus; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XnjSUSus"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BBAD0C116D0;
	Thu, 15 Jan 2026 17:09:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768496955;
	bh=dhQssuoaF0w7ohMdGPwH4bWvxbZr3/a1+6JNbvbQTNs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XnjSUSus2N16nYpIesRrnm1E8mOgw6gWhS9KVO2ZGaN7BCPIEsmSzUDl1xSQuzp4y
	 k2kO2vfqm1TOCESnTcNeQH2IoUsLvcHvC0yWtoEfEzi2cLtFoItx2N60vuqC6skVDP
	 whE5PzOQoniCLpUB8eC2P+blHn6ghQzx/2k0YTBQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ian Ray <ian.ray@gehealthcare.com>,
	Shawn Guo <shawnguo@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 41/88] ARM: dts: imx6q-ba16: fix RTC interrupt level
Date: Thu, 15 Jan 2026 17:48:24 +0100
Message-ID: <20260115164147.797416126@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260115164146.312481509@linuxfoundation.org>
References: <20260115164146.312481509@linuxfoundation.org>
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

From: Ian Ray <ian.ray@gehealthcare.com>

[ Upstream commit e6a4eedd49ce27c16a80506c66a04707e0ee0116 ]

RTC interrupt level should be set to "LOW". This was revealed by the
introduction of commit:

  f181987ef477 ("rtc: m41t80: use IRQ flags obtained from fwnode")

which changed the way IRQ type is obtained.

Fixes: 56c27310c1b4 ("ARM: dts: imx: Add Advantech BA-16 Qseven module")
Signed-off-by: Ian Ray <ian.ray@gehealthcare.com>
Signed-off-by: Shawn Guo <shawnguo@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/nxp/imx/imx6q-ba16.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/boot/dts/nxp/imx/imx6q-ba16.dtsi b/arch/arm/boot/dts/nxp/imx/imx6q-ba16.dtsi
index f266f1b7e0cfc..0c033e69ecc04 100644
--- a/arch/arm/boot/dts/nxp/imx/imx6q-ba16.dtsi
+++ b/arch/arm/boot/dts/nxp/imx/imx6q-ba16.dtsi
@@ -335,7 +335,7 @@ rtc@32 {
 		pinctrl-0 = <&pinctrl_rtc>;
 		reg = <0x32>;
 		interrupt-parent = <&gpio4>;
-		interrupts = <10 IRQ_TYPE_LEVEL_HIGH>;
+		interrupts = <10 IRQ_TYPE_LEVEL_LOW>;
 	};
 };
 
-- 
2.51.0



