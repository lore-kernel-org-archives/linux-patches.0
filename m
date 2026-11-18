Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795024629;
	b=2oqDLpqlxofgYIhfOr1776vXfFG5XCqOaanYJHumDw7ej1eXgkMIhD0uTMNn8OvFS1n2
	 +xVdIgWbiwGMPAFK63a/8QlUHULfwqp9sqUywojasr8RY1igSGIuQ4WLZ8/1uNsY6vz1B
	 JrKmWCi2FcqoA+8Op5mN6Eni+bBVPKzyP0HTLOQjwICjEGcmh8lj5J8fR82ioKoarct7d
	 TwMUxSOS4xmlqQWf3aJuO8+k9ZIZbydqLqWOhn/sbmZK0qTAYkR7zt6jJdMGsn/b2Nzbn
	 nXqpXPOAPS6+67aQn752QaPWV5ZN/BUdC+qH4/a80o31pnzY73XZe0+WHrOMPn9uXhw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795024629;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=pN/Ln6JV14XelAN58IY9vuJ2SClpfq74ewDsErXzuSM=;
	b=GWJHQplqXLS2DXgqo46zz2vfXUO13zOkjj8uER1/4PfKq1nCSey9RpDrTRoX9nU3r/D/
	 I/xAvQXZlILrSWOxr+O4Fapp2IGp4vJ+pXnZyWtGtUOOiMXmkiBuEWU3Ji8EJcCCech2R
	 KrFdWJXsLs1N2b0YTsRmIncf1QzMgPpT1u+7Mizng/5UkbYLrNyD+e2tCF3/7ibT/usrO
	 xtI6Mle2ZXcy9jg8xBqFYCx1Z6CqmIpY/9GgdYMLlFt5k/WkrKK3PGoTwa+0yDhw60BVe
	 hE0p2ZUzohdgeb/Y5rZxTUtWbSEKXGw0AG+fH7g6khauOKkJGFp/grn4lGGPbi2Fm1Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=TdjQIsyM;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0CD3B606A330;
	Wed, 18 Nov 2026 17:57:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=TdjQIsyM
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5FBD51F000C4;
	Wed, 18 Nov 2026 17:57:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795024628;
	bh=pN/Ln6JV14XelAN58IY9vuJ2SClpfq74ewDsErXzuSM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=TdjQIsyM8ZLJYUvJ7BpiQ3bQnmk9YfsGiUH4VHShoh9NW5Ne835eI2ufFaKS9v/53
	 Mj9HG7aDX3jYgftxIPBOgs237545yCf7IHPc/BRNCGhtFWv/R4AuNhQVGZsB2slQ6d
	 It8QzRW/qDqsgZl8cxMxyTVmqBDva2FXyVM/SqaY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mateusz Nowicki <mateusz.nowicki@posteo.net>,
	Antonio Borneo <antonio.borneo@foss.st.com>,
	Alexandre Torgue <alexandre.torgue@foss.st.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0794/2151] arm64: dts: st: fix arm,smc-id of the SMC watchdog on stm32mp2
Date: Wed, 18 Nov 2026 15:42:09 +0100
Message-ID: <20261118150151.015896264@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index 88e214d395ab7..57ab9d785f347 100644
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
index e4e6f9f818d81..371bfa26bdd57 100644
--- a/arch/arm64/boot/dts/st/stm32mp251.dtsi
+++ b/arch/arm64/boot/dts/st/stm32mp251.dtsi
@@ -36,7 +36,7 @@ arm-pmu {
 
 	arm_wdt: watchdog {
 		compatible = "arm,smc-wdt";
-		arm,smc-id = <0xb200005a>;
+		arm,smc-id = <0xbc000000>;
 		status = "disabled";
 	};
 
-- 
2.53.0



