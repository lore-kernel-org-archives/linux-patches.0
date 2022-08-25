Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 515174C76
	for <patches@lists.linux.dev>; Thu, 25 Aug 2022 21:09:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 0F541C4347C
	for <patches@lists.linux.dev>; Thu, 25 Aug 2022 21:09:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1661461791;
	bh=k/VF18szPF3Oz3TaSXdfaP7LCFbey23x9Isa00ZENmw=;
	h=From:Date:Subject:References:In-Reply-To:To:From;
	b=pKQXQPqXGACOrgX0uNBvHyi+QVSuSQq8Hu3iXIH4vP/b+V7SqB6y+luM0Xa2nxxH+
	 JIelhzXwRRsPdOBrz3Y/P4kHXWBBeRzdOrQQFlCKkP21jxOwfvNAWBA1qzRemAgODA
	 o0b6/GDdsowydB+8x09iBO3jIUpPcoEBtdbrBrRs=
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E9F8BECAAD4
	for <patches@lists.linux.dev>; Thu, 25 Aug 2022 21:09:50 +0000 (UTC)
From: Konstantin Ryabitsev <konstantin@linuxfoundation.org>
Date: Thu, 25 Aug 2022 17:09:20 -0400
Subject: [PATCH v1 4/4] arm64: dts: allwinner: beelink-gs1: Enable GPU OPP
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="utf-8"
Message-Id: <20220825-test-endpoint-send-2-v1-4-e732ebcaa48a@linuxfoundation.org>
References: <20220825-test-endpoint-send-2-v1-0-e732ebcaa48a@linuxfoundation.org>
In-Reply-To: <20220825-test-endpoint-send-2-v1-0-e732ebcaa48a@linuxfoundation.org>
To: patches@lists.linux.dev
X-Mailer: b4 0.10.0-dev-65ba7
X-Developer-Signature: v=1; a=openpgp-sha256; l=885;
 i=konstantin@linuxfoundation.org; h=from:subject:message-id;
 bh=Qr3s8jOoe3h/47KVIGHPxRIoa7LD5uKtv3jm7eyG6/8=;
 b=owGbwMvMwCW27YjM47CUmTmMp9WSGJLZn8rNmib95s/x6+8/fBdPzYpm8Viza+PTL3JaQcmSd2ra
 blekdZSyMIhxMciKKbKU7YvdFFT40EMuvccUZg4rE8gQBi5OAZjI5GxGhhY18YTsBU6G9TJxmdd9Uu
 +pvuWWND5vd5SZt/xvhcKeQkaGZ1tnnvArMeLtj3sSPlHCLrDk/dTYB18v6GmnNCxq3LaHCwA=
X-Developer-Key: i=konstantin@linuxfoundation.org; a=openpgp;
 fpr=DE0E66E32F1FDD0902666B96E63EDCA9329DD07E
X-Endpoint-Received: by B4 Submission Endpoint with auth_id=1

From: Clément Péron <peron.clem@gmail.com>

Enable GPU OPP table for Beelink GS1

Signed-off-by: Clément Péron <peron.clem@gmail.com>
Signed-off-by: Konstantin Ryabitsev <konstantin@linuxfoundation.org>

diff --git a/arch/arm64/boot/dts/allwinner/sun50i-h6-beelink-gs1.dts b/arch/arm64/boot/dts/allwinner/sun50i-h6-beelink-gs1.dts
index 6249e9e02928..20fc0584d1c6 100644
--- a/arch/arm64/boot/dts/allwinner/sun50i-h6-beelink-gs1.dts
+++ b/arch/arm64/boot/dts/allwinner/sun50i-h6-beelink-gs1.dts
@@ -5,6 +5,7 @@
 
 #include "sun50i-h6.dtsi"
 #include "sun50i-h6-cpu-opp.dtsi"
+#include "sun50i-h6-gpu-opp.dtsi"
 
 #include <dt-bindings/gpio/gpio.h>
 
@@ -261,6 +262,7 @@ reg_dcdca: dcdca {
 			};
 
 			reg_dcdcc: dcdcc {
+				regulator-always-on;
 				regulator-enable-ramp-delay = <32000>;
 				regulator-min-microvolt = <810000>;
 				regulator-max-microvolt = <1080000>;

-- 
b4 0.10.0-dev-65ba7

