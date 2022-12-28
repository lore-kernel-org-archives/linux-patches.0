Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 703211863
	for <patches@lists.linux.dev>; Wed, 28 Dec 2022 14:49:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ED0D1C433D2;
	Wed, 28 Dec 2022 14:49:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1672238969;
	bh=T4r12HL+ymn7zLPbpeyo4FAJM7jFaXoK2bTcvEYzD2o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=taHLPmwSwmlp1TVFev3cpnIJfycMI/dh49qhpyFGp6DtPPHNFAMoav83DqLTSAgSW
	 iutvqWHR7pR4wPjQr1NtIEuw4PpVj5KWDHvi4yUpk+lm3NXM6r4hD76KyQm2kDsIkQ
	 ZV2ZMX92p+sVVtoSofQGcGtS3zIUfociBin3rj8g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Pali=20Roh=C3=A1r?= <pali@kernel.org>,
	Gregory CLEMENT <gregory.clement@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 051/731] ARM: dts: armada-39x: Fix assigned-addresses for every PCIe Root Port
Date: Wed, 28 Dec 2022 15:32:38 +0100
Message-Id: <20221228144258.035345522@linuxfoundation.org>
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
index e0b7c2099831..9525e7b7f436 100644
--- a/arch/arm/boot/dts/armada-39x.dtsi
+++ b/arch/arm/boot/dts/armada-39x.dtsi
@@ -453,7 +453,7 @@ pcie@1,0 {
 			/* x1 port */
 			pcie@2,0 {
 				device_type = "pci";
-				assigned-addresses = <0x82000800 0 0x40000 0 0x2000>;
+				assigned-addresses = <0x82001000 0 0x40000 0 0x2000>;
 				reg = <0x1000 0 0 0 0>;
 				#address-cells = <3>;
 				#size-cells = <2>;
@@ -472,7 +472,7 @@ pcie@2,0 {
 			/* x1 port */
 			pcie@3,0 {
 				device_type = "pci";
-				assigned-addresses = <0x82000800 0 0x44000 0 0x2000>;
+				assigned-addresses = <0x82001800 0 0x44000 0 0x2000>;
 				reg = <0x1800 0 0 0 0>;
 				#address-cells = <3>;
 				#size-cells = <2>;
@@ -494,7 +494,7 @@ pcie@3,0 {
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



