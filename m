Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C2316FA0
	for <patches@lists.linux.dev>; Mon, 16 Jan 2023 16:39:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D5045C433D2;
	Mon, 16 Jan 2023 16:39:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1673887143;
	bh=UdRqLFL5zMFiyl4XTCz27cDNjAUKdYCaldfdUFfSlgE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DMBxRWFmBtdzxRGIuxL1Scy85kMXI+8w1DxKmozDC9pNH0C/mzxIxDpRPZLMpsbX9
	 DbAbKo8rgdfIk33FDSjU1a/+fe/EKFOVCjpsC8M32AM99jjuUcK7mdqyFFiZpW+w5C
	 mMN4ROQ7l9SPo5xC5CharMydktTt0GRc5/UIIMns=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Pali=20Roh=C3=A1r?= <pali@kernel.org>,
	Gregory CLEMENT <gregory.clement@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 036/521] ARM: dts: armada-38x: Fix assigned-addresses for every PCIe Root Port
Date: Mon, 16 Jan 2023 16:44:58 +0100
Message-Id: <20230116154848.925130128@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230116154847.246743274@linuxfoundation.org>
References: <20230116154847.246743274@linuxfoundation.org>
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

[ Upstream commit 44f47b7a8fa4678ce4c38ea74837e4996b9df6d6 ]

BDF of resource in DT assigned-addresses property of Marvell PCIe Root Port
(PCI-to-PCI bridge) should match BDF in address part in that DT node name
as specified resource belongs to Marvell PCIe Root Port itself.

Fixes: 0d3d96ab0059 ("ARM: mvebu: add Device Tree description of the Armada 380/385 SoCs")
Signed-off-by: Pali Rohár <pali@kernel.org>
Signed-off-by: Gregory CLEMENT <gregory.clement@bootlin.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/armada-380.dtsi | 4 ++--
 arch/arm/boot/dts/armada-385.dtsi | 6 +++---
 2 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/arch/arm/boot/dts/armada-380.dtsi b/arch/arm/boot/dts/armada-380.dtsi
index cff1269f3fbf..7146cc8f082a 100644
--- a/arch/arm/boot/dts/armada-380.dtsi
+++ b/arch/arm/boot/dts/armada-380.dtsi
@@ -79,7 +79,7 @@ pcie@1,0 {
 			/* x1 port */
 			pcie@2,0 {
 				device_type = "pci";
-				assigned-addresses = <0x82000800 0 0x40000 0 0x2000>;
+				assigned-addresses = <0x82001000 0 0x40000 0 0x2000>;
 				reg = <0x1000 0 0 0 0>;
 				#address-cells = <3>;
 				#size-cells = <2>;
@@ -98,7 +98,7 @@ pcie@2,0 {
 			/* x1 port */
 			pcie@3,0 {
 				device_type = "pci";
-				assigned-addresses = <0x82000800 0 0x44000 0 0x2000>;
+				assigned-addresses = <0x82001800 0 0x44000 0 0x2000>;
 				reg = <0x1800 0 0 0 0>;
 				#address-cells = <3>;
 				#size-cells = <2>;
diff --git a/arch/arm/boot/dts/armada-385.dtsi b/arch/arm/boot/dts/armada-385.dtsi
index f0022d10c715..f081f7cb66e5 100644
--- a/arch/arm/boot/dts/armada-385.dtsi
+++ b/arch/arm/boot/dts/armada-385.dtsi
@@ -84,7 +84,7 @@ pcie1: pcie@1,0 {
 			/* x1 port */
 			pcie2: pcie@2,0 {
 				device_type = "pci";
-				assigned-addresses = <0x82000800 0 0x40000 0 0x2000>;
+				assigned-addresses = <0x82001000 0 0x40000 0 0x2000>;
 				reg = <0x1000 0 0 0 0>;
 				#address-cells = <3>;
 				#size-cells = <2>;
@@ -103,7 +103,7 @@ pcie2: pcie@2,0 {
 			/* x1 port */
 			pcie3: pcie@3,0 {
 				device_type = "pci";
-				assigned-addresses = <0x82000800 0 0x44000 0 0x2000>;
+				assigned-addresses = <0x82001800 0 0x44000 0 0x2000>;
 				reg = <0x1800 0 0 0 0>;
 				#address-cells = <3>;
 				#size-cells = <2>;
@@ -125,7 +125,7 @@ pcie3: pcie@3,0 {
 			 */
 			pcie4: pcie@4,0 {
 				device_type = "pci";
-				assigned-addresses = <0x82000800 0 0x48000 0 0x2000>;
+				assigned-addresses = <0x82002000 0 0x48000 0 0x2000>;
 				reg = <0x2000 0 0 0 0>;
 				#address-cells = <3>;
 				#size-cells = <2>;
-- 
2.35.1



