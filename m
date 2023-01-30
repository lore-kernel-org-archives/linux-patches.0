Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5EDE528EB
	for <patches@lists.linux.dev>; Mon, 30 Jan 2023 13:57:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A3BE3C433D2;
	Mon, 30 Jan 2023 13:57:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1675087021;
	bh=2OBjSD5wQA2l0uCnNLlTKFxX2UpDFBT8TxV1iUmOCtw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fZlOxxpv86+hExW58DR2hj9ppaGkOHhkMR47mVkMyzBi/P7TZI6fhZOpvQfRISiXF
	 nb/elEbTXRfxJI8cJ/ub3fVcVvmWuF4OvO/1CcOpL6BuRxK3UGQ35f37I2IpdbP7fB
	 4QPo/ILCcbr4PicWnRkIk87j7h9P5AhvnoZ/UXFQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chris Packham <chris.packham@alliedtelesis.co.nz>,
	Gregory CLEMENT <gregory.clement@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 044/313] arm64: dts: marvell: AC5/AC5X: Fix address for UART1
Date: Mon, 30 Jan 2023 14:47:59 +0100
Message-Id: <20230130134338.745448625@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230130134336.532886729@linuxfoundation.org>
References: <20230130134336.532886729@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Chris Packham <chris.packham@alliedtelesis.co.nz>

[ Upstream commit 80502ffab2fa92ba9777e381efea2efddc348d13 ]

The correct address offset is 0x12100.

Fixes: 31be791e26cf ("arm64: dts: marvell: Add UART1-3 for AC5/AC5X")
Signed-off-by: Chris Packham <chris.packham@alliedtelesis.co.nz>
Signed-off-by: Gregory CLEMENT <gregory.clement@bootlin.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/marvell/ac5-98dx25xx.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/marvell/ac5-98dx25xx.dtsi b/arch/arm64/boot/dts/marvell/ac5-98dx25xx.dtsi
index 44ed6f963b75..8e2ac687a410 100644
--- a/arch/arm64/boot/dts/marvell/ac5-98dx25xx.dtsi
+++ b/arch/arm64/boot/dts/marvell/ac5-98dx25xx.dtsi
@@ -97,7 +97,7 @@ uart0: serial@12000 {
 
 			uart1: serial@12100 {
 				compatible = "snps,dw-apb-uart";
-				reg = <0x11000 0x100>;
+				reg = <0x12100 0x100>;
 				reg-shift = <2>;
 				interrupts = <GIC_SPI 84 IRQ_TYPE_LEVEL_HIGH>;
 				reg-io-width = <1>;
-- 
2.39.0



