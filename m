Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795048305;
	b=Ci5FjEHHVgT28RrPkj1tBDFpyzob0nxPUXGlmCDdZtRTem/jmaPNwlBFnm2AGsqHvKZ7
	 wpx6GT5W5wZsQQh0a0NdGwsGMFAJf/Mg/AB+T2JclYV9n1sx9ashSfOAwNzk0Jf1UaG9e
	 i+bwNsmhudmNbPJ/sN8jpqK5Du5o7H1kpxYCjj+ZLPSk6F4diXIiuPZ/0gudKEtdBF0x0
	 BgNf+smUvT3hiYQuTuMyz6iTrX5w2qeZnRaCaIOwgHJNpdDo2Fe91s63YxxYJCAdaZMDO
	 /Iem4uyii3jr/zVsTCgWGBSywyYiYBW7sliv1VlkcARFTQWPiwMfxl7LnWxNHE/9QzA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795048305;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=4mt3zmW2ti2zZEya/v4O/FPfbhVwNjJf/wdwo76SJqs=;
	b=fZIVIeLL+VGQmUQEUh1ajgAw0SjwNqx6fje075cYS2JJy1IGKc06D/FJXYxJCISLoagd
	 q6nJCAjk5HBOemiMlfMm3fjqNEfYP1ldXPCdHdIEluvV+molp93U1qmpyD2BCvWSMEUJ2
	 cpNIQNXocXpHSabh7/G4snCTPG58XBNRdF7TlDJ19bYuPPMDVVCELIyFgtzhFc1ddlJTZ
	 uR2Y2rWn6B3VXPujimUC/UvIzhb33aQuj21/3TX2Lbnmjm5OzLgW8Z7sJdHPAWGaxJO2R
	 koCyb2OV/dKNz4XFiDr8ObgwQGl80Q0CPcgIP/T52QQqZSmPfldmF+7ifvp0X/Xgbkg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=zzbd1Xcv;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D2310606A32A;
	Thu, 19 Nov 2026 00:31:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=zzbd1Xcv
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E3A2E1F000C9;
	Thu, 19 Nov 2026 00:31:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795048305;
	bh=4mt3zmW2ti2zZEya/v4O/FPfbhVwNjJf/wdwo76SJqs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=zzbd1XcvOOKWiCsbIum/AKgFz7W/6OR3gmyxdbs/mvhoCA7vImEVP1h3CIa8HkHp1
	 vLrfgk8o2DUJR193rGzWa0TXw23L4037/3HW8KQ4uwBznqga6W0Cp3TGsAyZTExPTg
	 dQctH9SdnSg+kbYPSDyeO3lHNHYUaqEmrKSpu5wU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Marek Vasut <marex@nabladev.com>,
	Alexandre Torgue <alexandre.torgue@foss.st.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1906/2857] ARM: dts: stm32: Drop bias-disable from STM32MP15xx DHCOM SoM sdmmc1_b4_pins_a
Date: Wed, 18 Nov 2026 15:49:00 +0100
Message-ID: <20261118150309.850546851@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
 arch/arm/boot/dts/stm32mp15xx-dhcom-som.dtsi | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/arm/boot/dts/stm32mp15xx-dhcom-som.dtsi b/arch/arm/boot/dts/stm32mp15xx-dhcom-som.dtsi
index 74a11ccc5333f..ec1b47f29aaf5 100644
--- a/arch/arm/boot/dts/stm32mp15xx-dhcom-som.dtsi
+++ b/arch/arm/boot/dts/stm32mp15xx-dhcom-som.dtsi
@@ -500,9 +500,11 @@ &sdmmc1_b4_pins_a {
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



