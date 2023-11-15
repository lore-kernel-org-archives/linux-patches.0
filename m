Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A86742837A
	for <patches@lists.linux.dev>; Wed, 15 Nov 2023 19:27:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZE+SP62b"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 54A20C433C9;
	Wed, 15 Nov 2023 19:27:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700076432;
	bh=MXLEPo5oRioxu8VuDDFW1MCUWksf3Xbq5UGhFpdiaO4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZE+SP62brcoUUMQzUF7pXLDJQ9OSXp6GtopSBkKIbxiT2eknQkmYedqqc339dGWBn
	 qY6cpbSwG1GJWpwzB0FVkfGUQyPkrj3ur4BDhD8Qup20liQimnimvN1bsP73U13RrV
	 YES/u1AYDqUpmkE64RgfYwHl8bMZBAUJph28JsYY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Devarsh Thakkar <devarsht@ti.com>,
	Aradhya Bhatia <a-bhatia1@ti.com>,
	Jai Luthra <j-luthra@ti.com>,
	Vignesh Raghavendra <vigneshr@ti.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.5 285/550] arm64: dts: ti: k3-am62a7-sk: Drop i2c-1 to 100Khz
Date: Wed, 15 Nov 2023 14:14:29 -0500
Message-ID: <20231115191620.547265629@linuxfoundation.org>
X-Mailer: git-send-email 2.42.1
In-Reply-To: <20231115191600.708733204@linuxfoundation.org>
References: <20231115191600.708733204@linuxfoundation.org>
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

6.5-stable review patch.  If anyone has any objections, please let me know.

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
index ecc0e13331c41..726afa29efe4c 100644
--- a/arch/arm64/boot/dts/ti/k3-am62a7-sk.dts
+++ b/arch/arm64/boot/dts/ti/k3-am62a7-sk.dts
@@ -232,7 +232,7 @@ &main_i2c1 {
 	status = "okay";
 	pinctrl-names = "default";
 	pinctrl-0 = <&main_i2c1_pins_default>;
-	clock-frequency = <400000>;
+	clock-frequency = <100000>;
 
 	exp1: gpio@22 {
 		compatible = "ti,tca6424";
-- 
2.42.0



