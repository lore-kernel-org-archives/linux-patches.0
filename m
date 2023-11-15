Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1074F33CDF
	for <patches@lists.linux.dev>; Wed, 15 Nov 2023 19:44:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XGnbNY2L"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B5A27C433C7;
	Wed, 15 Nov 2023 19:44:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700077445;
	bh=bc+QMVeHRBvS4A5nf/Y8lyiX2ZOvvC+8tiCQn3XqXoM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XGnbNY2LUgs5YW3YHKJmeTzzt+te9hVefnwDk15/rr1kx2+rFYcSYHHAfc9rjRAzQ
	 lvLaRXipSYDJobrlkna7HVMuCyWBVadVts6sTo+YZKc4aei+8QUWPQlBgH2yHx2Rqp
	 0Yzo8zbryex9dLsmjSvv3I55gNmkBIs9Dogv2gSo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Devarsh Thakkar <devarsht@ti.com>,
	Aradhya Bhatia <a-bhatia1@ti.com>,
	Jai Luthra <j-luthra@ti.com>,
	Vignesh Raghavendra <vigneshr@ti.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 308/603] arm64: dts: ti: k3-am62a7-sk: Drop i2c-1 to 100Khz
Date: Wed, 15 Nov 2023 14:14:13 -0500
Message-ID: <20231115191634.734886714@linuxfoundation.org>
X-Mailer: git-send-email 2.42.1
In-Reply-To: <20231115191613.097702445@linuxfoundation.org>
References: <20231115191613.097702445@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Jai Luthra <j-luthra@ti.com>

[ Upstream commit 63e5aa69b821472a3203a29e17c025329c1b151f ]

The TLV320AIC3106 audio codec is interfaced on the i2c-1 bus. With the
default rate of 400Khz the i2c register writes fail to sync:

[   36.026387] tlv320aic3x 1-001b: Unable to sync registers 0x16-0x16. -110
[   38.101130] omap_i2c 20010000.i2c: controller timed out

Dropping the rate to 100Khz fixes the issue.

Fixes: 38c4a08c820c ("arm64: dts: ti: Add support for AM62A7-SK")
Reviewed-by: Devarsh Thakkar <devarsht@ti.com>
Reviewed-by: Aradhya Bhatia <a-bhatia1@ti.com>
Signed-off-by: Jai Luthra <j-luthra@ti.com>
Link: https://lore.kernel.org/r/20231003-mcasp_am62a-v3-3-2b631ff319ca@ti.com
Signed-off-by: Vignesh Raghavendra <vigneshr@ti.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/ti/k3-am62a7-sk.dts | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/ti/k3-am62a7-sk.dts b/arch/arm64/boot/dts/ti/k3-am62a7-sk.dts
index cff283c75f8ec..99f2878de4c67 100644
--- a/arch/arm64/boot/dts/ti/k3-am62a7-sk.dts
+++ b/arch/arm64/boot/dts/ti/k3-am62a7-sk.dts
@@ -250,7 +250,7 @@ &main_i2c1 {
 	status = "okay";
 	pinctrl-names = "default";
 	pinctrl-0 = <&main_i2c1_pins_default>;
-	clock-frequency = <400000>;
+	clock-frequency = <100000>;
 
 	exp1: gpio@22 {
 		compatible = "ti,tca6424";
-- 
2.42.0



