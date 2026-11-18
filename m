Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795030208;
	b=v57/Y9oqKgdoJqEeISUVZjKoQNgctb5Fh3+mlLSY5Z8iE4E8XzZ4ZUaIfVqPiXSTyECq
	 7euTncbVvBMWiciv/0t1F9gSADyxMlHdWthgfaU3GWxi443ngG/lmytQXmFvEIlUnr5iq
	 qbYMvWQSHaWbQqCpIakO71k4zxkWvHIs3oLB71GSJ+Zs4QxhOr/F5oUEFTg77o7f1EI4O
	 yAURbQyfBBkovgSQlk8c9hh6Xy629lZfAvzYDVJCMlUrzqgyDFf1/3S8auhl4H+73sZ6f
	 mN496zsfBFyP+fe32E92ARWDr4R2SA2D/qVzTL3Z4ziUfDOlze9zAOLpUEJrQskSfIg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795030208;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=fjx3Adt2M+DMBHnH/SzalVy6tL9X0nscw6lewwHBIc0=;
	b=LhKuCRx7putVNhkipld9pBzcapkiVGFEIPTS/6suHqL31xgNcBiMwzhEaDWBk73MPWrw
	 zZpQqcykO9XG7F4dDKql6QsP5xgt3DpI3yYChfK74hvbIEruVHpgSqLbMUdiA5a87k4B+
	 aarriqf29l/lgev26Ou3zXhepgYluXmcppkKCQVkN6T+BhifsHYuQn3k3u+UtJKcz6c6z
	 hJoxA8r8ltKAh6Bi8KHLAedqdCoK0B5BDMroPt06vXiSHEE8u0Qe9Fdw4Vo1h9HjbyIg9
	 y/nIgv5NLjpb+Li69v+kz6v7H/7R/pXeg3TUzkWUijDVaVp2Y23TLWrzho7LcQ9M4oA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="FnlweQH/";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 96E0E606D34E;
	Wed, 18 Nov 2026 19:30:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=FnlweQH/
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E586A1F000C9;
	Wed, 18 Nov 2026 19:30:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795030208;
	bh=fjx3Adt2M+DMBHnH/SzalVy6tL9X0nscw6lewwHBIc0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=FnlweQH/LCK9+nZI2onKffHIOnwxTHwqZkfkJ9fl58qHXPatQxx+abLX9aOaZSPzf
	 iTifCl+K3/BxtFlcVUhhuLjhntZKJ5dhCF8meRipkHl4Dc9CbTNoXAOFG01AkGudwD
	 be1FMP0bV+xiZNyYVk6vWQVAtKTjJReyxEOtNnaQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mateusz Nowicki <mateusz.nowicki@posteo.net>,
	Antonio Borneo <antonio.borneo@foss.st.com>,
	Alexandre Torgue <alexandre.torgue@foss.st.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0623/1756] arm64: dts: st: fix arm,smc-id of the SMC watchdog on stm32mp2
Date: Wed, 18 Nov 2026 15:45:50 +0100
Message-ID: <20261118150033.700064358@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mateusz Nowicki <mateusz.nowicki@posteo.net>

[ Upstream commit ae4d08bbe3f4f5ec920dbdba26091adf0ae6ba71 ]

OP-TEE implements the STM32MP2 watchdog SMC service with function ID
0xbc000000 (CFG_WDT_SM_HANDLER_ID), not 0xb200005a. With the current
value the arm_smc_wdt probe fails with -EIO and the IWDG started by the
bootloader is never refreshed.

Fixes: 89fca38168c9 ("arm64: dts: st: add arm-wdt node for watchdog support on stm32mp251")
Fixes: e9b03ef21386 ("arm64: dts: st: introduce stm32mp23 SoCs family")
Signed-off-by: Mateusz Nowicki <mateusz.nowicki@posteo.net>
Reviewed-by: Antonio Borneo <antonio.borneo@foss.st.com>
Link: https://lore.kernel.org/r/20260907091400.55954-1-mateusz.nowicki@posteo.net
Signed-off-by: Alexandre Torgue <alexandre.torgue@foss.st.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/st/stm32mp231.dtsi | 2 +-
 arch/arm64/boot/dts/st/stm32mp251.dtsi | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/boot/dts/st/stm32mp231.dtsi b/arch/arm64/boot/dts/st/stm32mp231.dtsi
index 8820d219a33e6..39f67d80c3645 100644
--- a/arch/arm64/boot/dts/st/stm32mp231.dtsi
+++ b/arch/arm64/boot/dts/st/stm32mp231.dtsi
@@ -35,7 +35,7 @@ arm-pmu {
 
 	arm_wdt: watchdog {
 		compatible = "arm,smc-wdt";
-		arm,smc-id = <0xb200005a>;
+		arm,smc-id = <0xbc000000>;
 		status = "disabled";
 	};
 
diff --git a/arch/arm64/boot/dts/st/stm32mp251.dtsi b/arch/arm64/boot/dts/st/stm32mp251.dtsi
index ed7804f061895..777652026bb64 100644
--- a/arch/arm64/boot/dts/st/stm32mp251.dtsi
+++ b/arch/arm64/boot/dts/st/stm32mp251.dtsi
@@ -35,7 +35,7 @@ arm-pmu {
 
 	arm_wdt: watchdog {
 		compatible = "arm,smc-wdt";
-		arm,smc-id = <0xb200005a>;
+		arm,smc-id = <0xbc000000>;
 		status = "disabled";
 	};
 
-- 
2.53.0



