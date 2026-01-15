Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8AB8127B340;
	Thu, 15 Jan 2026 17:38:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768498706; cv=none; b=oHe6qskIqt3LTsBFSamIQgwew/BdkG5ZU9fjUkyY6Z4JZQJESnBHMK+e1AcIu04Fsb/SsYe74woCfVBYycDuWEcSSj9D904W8wOrQlj76hc5bLGtXBuemDe85Cb5BnXo+4BwuZ4WDLNmOPXTggo4+iUCh0y/FWprOHNiQEIgaIE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768498706; c=relaxed/simple;
	bh=vTNBoNm8OFM3Q2qEfRYAhCS/YW1m5TeBrAR9E/rF0Io=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BtpF6U0Kc6gJ1j7KaC3tnPSrYuNAfiakAA/Pan2YIIZ/naeMcpiv+AzVriGovqo0UGtk0ECMAzhEuaoF6PrESbSoTbX2K8omyFBXZYbM77N3YcnpBNZLaVMoKBZ80U+1P0gckB+HeepsS2EtHiEl8mchFh8r7qxQWOChsBo6kEI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QfRkELux; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QfRkELux"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 196C7C116D0;
	Thu, 15 Jan 2026 17:38:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768498706;
	bh=vTNBoNm8OFM3Q2qEfRYAhCS/YW1m5TeBrAR9E/rF0Io=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QfRkELuxjgFupO8OZEmqiQLwgZPAYiQgdPkLpTNGk/QrbpI39yKX/QE8+deJOFneq
	 rLiDiBYP2CBkhHUyJYs3q+ow93idD8HhcATgnJb20iPlXTXPpvlol8ysCRwLKLVaHP
	 UAXDZwXc7oTbuW6Qfzp6AB7TpKX6bu8V5ynQbyC8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ian Ray <ian.ray@gehealthcare.com>,
	Shawn Guo <shawnguo@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 524/554] ARM: dts: imx6q-ba16: fix RTC interrupt level
Date: Thu, 15 Jan 2026 17:49:50 +0100
Message-ID: <20260115164305.294645112@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260115164246.225995385@linuxfoundation.org>
References: <20260115164246.225995385@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
 arch/arm/boot/dts/imx6q-ba16.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/boot/dts/imx6q-ba16.dtsi b/arch/arm/boot/dts/imx6q-ba16.dtsi
index f266f1b7e0cfc..0c033e69ecc04 100644
--- a/arch/arm/boot/dts/imx6q-ba16.dtsi
+++ b/arch/arm/boot/dts/imx6q-ba16.dtsi
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



