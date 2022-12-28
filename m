Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 03E8F1863
	for <patches@lists.linux.dev>; Wed, 28 Dec 2022 14:46:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 60F27C433D2;
	Wed, 28 Dec 2022 14:46:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1672238792;
	bh=H2Ve4Dg+Fjtj16bqGitGPbh5zr+NA8NadMiE60rJaVQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=l6ormn6Mus38e+jhBGuUqxuuc9xYLYdXdp4r4ieZ7pYFnKSNPnssZkLy4So2FH6cn
	 X9i1/Ux1FX2MH+0YJwJEp4mEHP5MtG9ozYJPir58PKXUpf7lkbKmSZgEnxnkhZ+hoE
	 aSW5KIKiF8IBNZo/lao2av+sp1Wxxe5nBSF3LPPo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Marek Vasut <marex@denx.de>,
	Alexandre Torgue <alexandre.torgue@foss.st.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 014/731] ARM: dts: stm32: Fix AV96 WLAN regulator gpio property
Date: Wed, 28 Dec 2022 15:32:01 +0100
Message-Id: <20221228144256.952799910@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144256.536395940@linuxfoundation.org>
References: <20221228144256.536395940@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Marek Vasut <marex@denx.de>

[ Upstream commit d5d577e3d50713ad11d98dbdaa48bb494346c26d ]

The WLAN regulator uses 'gpios' property instead of 'gpio' to specify
regulator enable GPIO. While the former is also currently handled by
the Linux kernel regulator-fixed driver, the later is the correct one
per DT bindings. Update the DT to use the later.

Fixes: 7dd5cbba42c93 ("ARM: dts: stm32: Enable WiFi on AV96")
Signed-off-by: Marek Vasut <marex@denx.de>
Signed-off-by: Alexandre Torgue <alexandre.torgue@foss.st.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/stm32mp15xx-dhcor-avenger96.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/boot/dts/stm32mp15xx-dhcor-avenger96.dtsi b/arch/arm/boot/dts/stm32mp15xx-dhcor-avenger96.dtsi
index 8eb51d84b698..d3375ad8c91f 100644
--- a/arch/arm/boot/dts/stm32mp15xx-dhcor-avenger96.dtsi
+++ b/arch/arm/boot/dts/stm32mp15xx-dhcor-avenger96.dtsi
@@ -100,7 +100,7 @@ wlan_pwr: regulator-wlan {
 		regulator-min-microvolt = <3300000>;
 		regulator-max-microvolt = <3300000>;
 
-		gpios = <&gpioz 3 GPIO_ACTIVE_HIGH>;
+		gpio = <&gpioz 3 GPIO_ACTIVE_HIGH>;
 		enable-active-high;
 	};
 };
-- 
2.35.1



