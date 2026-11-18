Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795016137;
	b=fvX2B3E/zxlLQgKwJcHE/hXAwC08Uxh7Nv8PU/UJO2jdE1Bku9/O5vpl5UpXwrs1mPpI
	 njL9LXa2GDkm0cYlHwoGV/PivckdqiMls/r3ziBqIQsJ8Nnwbw+WBLNT8pNp+99WJuTsl
	 C79s3QEUn0TVusmirNQqfcpy2UKnw+HXloqT6ka3WliVxqbwy7Vkro7Fa6pL1POKeEuFI
	 ASQNdMgzBjN6wSlDKbVMGfbWXjPYhi3iMJW+YM2YB1On55rd4H1PduhDf0Hr3ZZ0ZcpOz
	 Yo3WKIupUjmse64x9Wg9Vceot3JbcxLa3T0mw9eRVBx5srEOGc/GyqESH0Tv8O0HuNA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795016137;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=cQ5d3kciBAA1izwtLwc0QA029bZSZN4Xe5kSOEGnnaQ=;
	b=2zI4J2MkLlAQtzD/Fr+xaRgm9YlVaJ0gFaq9HdaD+u5IZg4Tyas3EA5nrfltfgTfdr/F
	 RVeLs2f6DPIpRZGMG3PtoKLteFyKKcqK5kxIBagQkwsuG5HvEkQMKL7mbD5+5J/UnmCCQ
	 bdF+mk/YIF6x+p3lKFQ9ANxRgQSGDzGYngRmT8JTBDTaFBMn2waBLjgEzNGmRfroTNSls
	 62uBGtkx1T+jv27zu3IFYNID223ZK2SoPSONePROEGV4zT+ZOXGjBMy7pEjanIJc7dEWe
	 9mrKC3Ees8KPtyskN6Kkqiq5FEr1Ni+oSUFZVOFs4FGNqWAkS3Obdb7i5E+Pou5biqg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=BuB8Kwhu;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 80ADE606A31C;
	Wed, 18 Nov 2026 15:35:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=BuB8Kwhu
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D7D4B1F000C4;
	Wed, 18 Nov 2026 15:35:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795016137;
	bh=cQ5d3kciBAA1izwtLwc0QA029bZSZN4Xe5kSOEGnnaQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=BuB8Kwhuf5/rwuAyCioRQGiaEELbwUm9KSPQl4ae4ZFDcOAEco9uZCvenJ/O7j5Ek
	 VUiQIZtlgtg+NKMC4R6FZhfN6hEBed/lC937r6aefaJK3uGrd/KO6ztfRFXCecDPMk
	 o/DTOjaO/9b1fIyt7WZ2hzayF33nxLXpdApxZK3g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Marek Vasut <marex@nabladev.com>,
	Alexandre Torgue <alexandre.torgue@foss.st.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0420/2651] ARM: dts: stm32: Drop bias-disable from STM32MP15xx DHCOM SoM sdmmc1_b4_pins_a
Date: Wed, 18 Nov 2026 15:27:40 +0100
Message-ID: <20261118150302.952447262@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

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
index 4cc633683c6b7..0a4263e6209d8 100644
--- a/arch/arm/boot/dts/st/stm32mp15xx-dhcom-som.dtsi
+++ b/arch/arm/boot/dts/st/stm32mp15xx-dhcom-som.dtsi
@@ -505,9 +505,11 @@ &sdmmc1_b4_pins_a {
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



