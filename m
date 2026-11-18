Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795017566;
	b=JBX3D7naEsFqclM4F2RFNn/O1/66zpfkcmfqoTPSYjrfoG4dx7JA3YVS5DD4X4RRjqOV
	 oSe3qIBwr8CR3Svm0QefTBKaUxf3BrSQuufLCOgQeujI2h+xCQ3SRmJ28TvQxFKSXwHcm
	 yZfpujeQn/dT9ndJ6PebspGhpjSnD0GBip+OuQfb6hJVxEb0SVeojQ9zMjmQOuaAdqf8T
	 gUWPSCoelbFRO7MAjNu32edV1gJDPj73ZHfwyC9uJb6ZvK7r6KaLXhM++AFlLP3lfnd4Z
	 WxI08nfEd0PsmI3uH5pVNkjeU5gXynIhh0y662Y0OuP07SVVOC3bpqajiQN+iVLCBtg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795017566;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=mDGWKGIXrqLA6mykrlt12SewF2/1xJCiM7hxj2miDM8=;
	b=XezLKYauSL87cdjMtW188+/ktMeRWQ/5CneDh6v1lSouur1xt2sCyloO9NaJhhvsqvLb
	 LLk2843AE5rCEFgolMM20wLx554aemhIK2yWfRhmtpE5p+taNZlSTBtKQKMe/Xi5H0Nwe
	 6+Jx84mecYV9TrnaASXpCGJVYs7ImY2nq627YIwUSct5/VBR+WKe1/42kxsxAaMNoUf1i
	 pcZR0lQIY1QJsC+AjxZn9txnswDGep0ebJ/fLhRW+6Gl9OBJNbfhi+XEcWnjHR9NMEQyf
	 kHohvsg6Gi09VdPpytF/Ww5v4455/rvKkheJvTrAWSTs0ms1SfRRAB2kfZgID0uPFoQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="z/cL/ivY";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B4947606A32A;
	Wed, 18 Nov 2026 15:59:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=z/cL/ivY
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BF50A1F000C4;
	Wed, 18 Nov 2026 15:59:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795017566;
	bh=mDGWKGIXrqLA6mykrlt12SewF2/1xJCiM7hxj2miDM8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=z/cL/ivYNQYC8hmWKLu5TejGDy2qNWqlxOPhMWURfxfAkKE8NmFa7q7jhAzQa4qkH
	 6gS5KKV/jQB1uhbfUaMTFLnjC5IQAgIe3WimlR42gfAH3H3YgTsyhiEmDcwktJHrRS
	 vtomOytU8FqFdbAxCO3r59aIUdZoAqH8dGPfav7E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mateusz Nowicki <mateusz.nowicki@posteo.net>,
	Antonio Borneo <antonio.borneo@foss.st.com>,
	Alexandre Torgue <alexandre.torgue@foss.st.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0930/2651] arm64: dts: st: fix arm,smc-id of the SMC watchdog on stm32mp2
Date: Wed, 18 Nov 2026 15:36:10 +0100
Message-ID: <20261118150321.363683529@linuxfoundation.org>
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
index 9e1d240888ff2..35e247af957cb 100644
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
index 9c63fdb5a885a..2dcbba65e2986 100644
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



