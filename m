Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795039809;
	b=GaVOZktBKMEH1isToj9Sn8Z88UKRA3F7zZxp5X42LxUdkbJtAdVFcVoCKkHaEJZei3Sn
	 IDiDdoIA+iB/aPYy9/OnQyba8zIKOKOXBxs3xYYAGxJjWuDZu2SdtaucxMyQEUmQhYAY1
	 tFBLhQ0Vx8BruVglk7k5OweStBySHXRoh0DEwptkpuMJCPaAHUzrjPhwSq5y+/9FU9u+F
	 QP1QQ4d5jXzfYOA/kwI6MJ5bLqE4VlW0+cBTjTFO9/zYF9/nVkIJmupKcAXEYSyayrfno
	 KlocmPw63/hsfZZNiVhq+DcEu+LzSD+uOIonc0hIXUx9NuUCGlqqB2lX8Ok/3iXhDwA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795039809;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=QaatxxI4QyMJQbugQe9Izpih+LTj/SqOv3Uu6whIQeU=;
	b=LYk6jrnn5xjawJS8CWITG8+cJAp5YZGsIHc1EcqFRfUsgcXY7/DVoNeOYJV3a430yQtT
	 7xl/aSncvwDeZOSGI2Btal+4NNJLkVh/QPhwl1P7nGXz7JwrikSTFtqHzavvB0G2SJG/3
	 q03P8iNiXaXb14CYbC03626lH8kJC5xMTfUiXmcjUkPjeeeup/j48SQNelrWywYR4QQ5a
	 yDqcyWhmJjxpCsU9VQ3kMWIBXYBkYLCB6vKyuWmYdKADwdb9nJbMzdEhh9XbefuXSFX2T
	 WuIaozwEq1eFEavVPby1PV0/bQ54scJg3UFuwiVwTECtmiz68anpnfXo+3793x8VcRg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=pLvddLaH;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 97935606A32A;
	Wed, 18 Nov 2026 22:10:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=pLvddLaH
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EE9311F000C4;
	Wed, 18 Nov 2026 22:10:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795039809;
	bh=QaatxxI4QyMJQbugQe9Izpih+LTj/SqOv3Uu6whIQeU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=pLvddLaHOUeY31yStJp+kp1Gf4LQjnoWWC3jG+Pb+ic7WDjagybnQkIAniScPWpul
	 WDw/3xIetQm8G7Ra35CECIfnWggv1Lm1+GqMxCTINCEzjagAw2Lv8VpviJ+VrGLEJd
	 IMzllr3CVR2ihaWajPgzfQ+y5QJR8jYJ4baOLmU8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Marek Vasut <marex@nabladev.com>,
	Alexandre Torgue <alexandre.torgue@foss.st.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 2182/3318] ARM: dts: stm32: Drop bias-disable from STM32MP15xx DHCOM SoM sdmmc1_b4_pins_a
Date: Wed, 18 Nov 2026 15:46:44 +0100
Message-ID: <20261118150427.424459657@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Marek Vasut <marex@nabladev.com>

[ Upstream commit 3572825773791f4258b553391f4e2187df321731 ]

Drop bias-disable property from STM32MP15xx DHCOM SoM sdmmc1_b4_pins_a
to fix the following DT checker warning. The bias-pull-up property is
the only bias-related property that has to be present in those pinctrl
node subnodes.

"
arch/arm/boot/dts/st/stm32mp153c-dhcom-drc02.dtb: pinctrl@50002000 (st,stm32mp157-pinctrl): sdmmc1-b4-0:pins1: {'pinmux': [10253, 10509, 10765, 11021, 12813], 'slew-rate': 1, 'drive-push-pull': True, 'bias-disable': True, 'bias-pull-up': True} is valid under each of {'required': ['bias-pull-up']}, {'required': ['bias-disable']}
"

Fixes: 7cd8567d988a ("ARM: dts: stm32: Enable internal pull-ups for SDMMC1 on DHCOM SoM")
Signed-off-by: Marek Vasut <marex@nabladev.com>
Link: https://lore.kernel.org/r/20260828150111.173089-1-marex@nabladev.com
Signed-off-by: Alexandre Torgue <alexandre.torgue@foss.st.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/st/stm32mp15xx-dhcom-som.dtsi | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/arm/boot/dts/st/stm32mp15xx-dhcom-som.dtsi b/arch/arm/boot/dts/st/stm32mp15xx-dhcom-som.dtsi
index 142d4a8731f8d..65f81c0c233d2 100644
--- a/arch/arm/boot/dts/st/stm32mp15xx-dhcom-som.dtsi
+++ b/arch/arm/boot/dts/st/stm32mp15xx-dhcom-som.dtsi
@@ -507,9 +507,11 @@ &sdmmc1_b4_pins_a {
 	 * - mandatory on SoMs without SD voltage translator
 	 */
 	pins1 {
+		/delete-property/ bias-disable;
 		bias-pull-up;
 	};
 	pins2 {
+		/delete-property/ bias-disable;
 		bias-pull-up;
 	};
 };
-- 
2.53.0



