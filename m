Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F5A76FA0
	for <patches@lists.linux.dev>; Mon, 16 Jan 2023 17:01:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8850EC433D2;
	Mon, 16 Jan 2023 17:01:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1673888514;
	bh=DtwfP8jcpP2so2BT4lB4yUnXI/l5+aU7dw77pPZ9FGk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KO6wvrfnPfENjOLajXaPHdqlWM12KWIzw9YskmkkroFBJ2Xq0VfOxIfEZfM8zmFtK
	 7GT1zv0SrLbtKGzoKCxIVZX49qoaQz5OPTwiMy0Rp8AcVL9Xg2RHVC03p5oeXieWWa
	 pg2nyT+pmTWXO68JacPMUPc884xObnQzAkuRQu1g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Pali=20Roh=C3=A1r?= <pali@kernel.org>,
	Gregory CLEMENT <gregory.clement@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 034/338] ARM: dts: armada-39x: Fix assigned-addresses for every PCIe Root Port
Date: Mon, 16 Jan 2023 16:48:27 +0100
Message-Id: <20230116154822.263705615@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230116154820.689115727@linuxfoundation.org>
References: <20230116154820.689115727@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Pali Rohár <pali@kernel.org>

[ Upstream commit 69236d2391b4d7324b11c3252921571577892e7b ]

BDF of resource in DT assigned-addresses property of Marvell PCIe Root Port
(PCI-to-PCI bridge) should match BDF in address part in that DT node name
as specified resource belongs to Marvell PCIe Root Port itself.

Fixes: 538da83ddbea ("ARM: mvebu: add Device Tree files for Armada 39x SoC and board")
Signed-off-by: Pali Rohár <pali@kernel.org>
Signed-off-by: Gregory CLEMENT <gregory.clement@bootlin.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/armada-39x.dtsi | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/arm/boot/dts/armada-39x.dtsi b/arch/arm/boot/dts/armada-39x.dtsi
index 5218bd2a248d..8c162013c1cb 100644
--- a/arch/arm/boot/dts/armada-39x.dtsi
+++ b/arch/arm/boot/dts/armada-39x.dtsi
@@ -493,7 +493,7 @@ pcie@1,0 {
 			/* x1 port */
 			pcie@2,0 {
 				device_type = "pci";
-				assigned-addresses = <0x82000800 0 0x40000 0 0x2000>;
+				assigned-addresses = <0x82001000 0 0x40000 0 0x2000>;
 				reg = <0x1000 0 0 0 0>;
 				#address-cells = <3>;
 				#size-cells = <2>;
@@ -512,7 +512,7 @@ pcie@2,0 {
 			/* x1 port */
 			pcie@3,0 {
 				device_type = "pci";
-				assigned-addresses = <0x82000800 0 0x44000 0 0x2000>;
+				assigned-addresses = <0x82001800 0 0x44000 0 0x2000>;
 				reg = <0x1800 0 0 0 0>;
 				#address-cells = <3>;
 				#size-cells = <2>;
@@ -534,7 +534,7 @@ pcie@3,0 {
 			 */
 			pcie@4,0 {
 				device_type = "pci";
-				assigned-addresses = <0x82000800 0 0x48000 0 0x2000>;
+				assigned-addresses = <0x82002000 0 0x48000 0 0x2000>;
 				reg = <0x2000 0 0 0 0>;
 				#address-cells = <3>;
 				#size-cells = <2>;
-- 
2.35.1



