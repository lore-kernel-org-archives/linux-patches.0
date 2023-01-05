Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C66363DA
	for <patches@lists.linux.dev>; Thu,  5 Jan 2023 12:57:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0BE4DC433D2;
	Thu,  5 Jan 2023 12:57:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1672923443;
	bh=CV4RKlmjO8d95e+2rfgbJgdm1N7zZCMcUHV2xIcpz1U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OLzY025outEFSRIy8WVrmyBWz+IZ4e3Okvk16bydxlI+mMdveX8vovxgEkwusmnN7
	 +7RfxB/c0qAKeGisYfPwL1ETRavZFhu3eWzldnJQxJDwKS5zu/LF0CXL8hFfZqT3XM
	 xEc9WhjYCPlRKL3/TZOzHRg687RyUjYCOlcrL1Q4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Pali=20Roh=C3=A1r?= <pali@kernel.org>,
	Gregory CLEMENT <gregory.clement@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 021/251] ARM: dts: armada-xp: Fix assigned-addresses for every PCIe Root Port
Date: Thu,  5 Jan 2023 13:52:38 +0100
Message-Id: <20230105125335.718388036@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230105125334.727282894@linuxfoundation.org>
References: <20230105125334.727282894@linuxfoundation.org>
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

[ Upstream commit eab276787f456cbea89fabea110fe0728673d308 ]

BDF of resource in DT assigned-addresses property of Marvell PCIe Root Port
(PCI-to-PCI bridge) should match BDF in address part in that DT node name
as specified resource belongs to Marvell PCIe Root Port itself.

Fixes: 9d8f44f02d4a ("arm: mvebu: add PCIe Device Tree informations for Armada XP")
Fixes: 12b69a599745 ("ARM: mvebu: second PCIe unit of Armada XP mv78230 is only x1 capable")
Fixes: 2163e61c92d9 ("ARM: mvebu: fix second and third PCIe unit of Armada XP mv78260")
Signed-off-by: Pali Rohár <pali@kernel.org>
Signed-off-by: Gregory CLEMENT <gregory.clement@bootlin.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/armada-xp-mv78230.dtsi |  8 ++++----
 arch/arm/boot/dts/armada-xp-mv78260.dtsi | 16 ++++++++--------
 2 files changed, 12 insertions(+), 12 deletions(-)

diff --git a/arch/arm/boot/dts/armada-xp-mv78230.dtsi b/arch/arm/boot/dts/armada-xp-mv78230.dtsi
index 6e6d0f04bf2b..b6e787b994ad 100644
--- a/arch/arm/boot/dts/armada-xp-mv78230.dtsi
+++ b/arch/arm/boot/dts/armada-xp-mv78230.dtsi
@@ -133,7 +133,7 @@ pcie@1,0 {
 
 			pcie@2,0 {
 				device_type = "pci";
-				assigned-addresses = <0x82000800 0 0x44000 0 0x2000>;
+				assigned-addresses = <0x82001000 0 0x44000 0 0x2000>;
 				reg = <0x1000 0 0 0 0>;
 				#address-cells = <3>;
 				#size-cells = <2>;
@@ -150,7 +150,7 @@ pcie@2,0 {
 
 			pcie@3,0 {
 				device_type = "pci";
-				assigned-addresses = <0x82000800 0 0x48000 0 0x2000>;
+				assigned-addresses = <0x82001800 0 0x48000 0 0x2000>;
 				reg = <0x1800 0 0 0 0>;
 				#address-cells = <3>;
 				#size-cells = <2>;
@@ -167,7 +167,7 @@ pcie@3,0 {
 
 			pcie@4,0 {
 				device_type = "pci";
-				assigned-addresses = <0x82000800 0 0x4c000 0 0x2000>;
+				assigned-addresses = <0x82002000 0 0x4c000 0 0x2000>;
 				reg = <0x2000 0 0 0 0>;
 				#address-cells = <3>;
 				#size-cells = <2>;
@@ -184,7 +184,7 @@ pcie@4,0 {
 
 			pcie@5,0 {
 				device_type = "pci";
-				assigned-addresses = <0x82000800 0 0x80000 0 0x2000>;
+				assigned-addresses = <0x82002800 0 0x80000 0 0x2000>;
 				reg = <0x2800 0 0 0 0>;
 				#address-cells = <3>;
 				#size-cells = <2>;
diff --git a/arch/arm/boot/dts/armada-xp-mv78260.dtsi b/arch/arm/boot/dts/armada-xp-mv78260.dtsi
index c5fdc99f0dbe..a4856b05440a 100644
--- a/arch/arm/boot/dts/armada-xp-mv78260.dtsi
+++ b/arch/arm/boot/dts/armada-xp-mv78260.dtsi
@@ -148,7 +148,7 @@ pcie@1,0 {
 
 			pcie@2,0 {
 				device_type = "pci";
-				assigned-addresses = <0x82000800 0 0x44000 0 0x2000>;
+				assigned-addresses = <0x82001000 0 0x44000 0 0x2000>;
 				reg = <0x1000 0 0 0 0>;
 				#address-cells = <3>;
 				#size-cells = <2>;
@@ -165,7 +165,7 @@ pcie@2,0 {
 
 			pcie@3,0 {
 				device_type = "pci";
-				assigned-addresses = <0x82000800 0 0x48000 0 0x2000>;
+				assigned-addresses = <0x82001800 0 0x48000 0 0x2000>;
 				reg = <0x1800 0 0 0 0>;
 				#address-cells = <3>;
 				#size-cells = <2>;
@@ -182,7 +182,7 @@ pcie@3,0 {
 
 			pcie@4,0 {
 				device_type = "pci";
-				assigned-addresses = <0x82000800 0 0x4c000 0 0x2000>;
+				assigned-addresses = <0x82002000 0 0x4c000 0 0x2000>;
 				reg = <0x2000 0 0 0 0>;
 				#address-cells = <3>;
 				#size-cells = <2>;
@@ -199,7 +199,7 @@ pcie@4,0 {
 
 			pcie@5,0 {
 				device_type = "pci";
-				assigned-addresses = <0x82000800 0 0x80000 0 0x2000>;
+				assigned-addresses = <0x82002800 0 0x80000 0 0x2000>;
 				reg = <0x2800 0 0 0 0>;
 				#address-cells = <3>;
 				#size-cells = <2>;
@@ -216,7 +216,7 @@ pcie@5,0 {
 
 			pcie@6,0 {
 				device_type = "pci";
-				assigned-addresses = <0x82000800 0 0x84000 0 0x2000>;
+				assigned-addresses = <0x82003000 0 0x84000 0 0x2000>;
 				reg = <0x3000 0 0 0 0>;
 				#address-cells = <3>;
 				#size-cells = <2>;
@@ -233,7 +233,7 @@ pcie@6,0 {
 
 			pcie@7,0 {
 				device_type = "pci";
-				assigned-addresses = <0x82000800 0 0x88000 0 0x2000>;
+				assigned-addresses = <0x82003800 0 0x88000 0 0x2000>;
 				reg = <0x3800 0 0 0 0>;
 				#address-cells = <3>;
 				#size-cells = <2>;
@@ -250,7 +250,7 @@ pcie@7,0 {
 
 			pcie@8,0 {
 				device_type = "pci";
-				assigned-addresses = <0x82000800 0 0x8c000 0 0x2000>;
+				assigned-addresses = <0x82004000 0 0x8c000 0 0x2000>;
 				reg = <0x4000 0 0 0 0>;
 				#address-cells = <3>;
 				#size-cells = <2>;
@@ -267,7 +267,7 @@ pcie@8,0 {
 
 			pcie@9,0 {
 				device_type = "pci";
-				assigned-addresses = <0x82000800 0 0x42000 0 0x2000>;
+				assigned-addresses = <0x82004800 0 0x42000 0 0x2000>;
 				reg = <0x4800 0 0 0 0>;
 				#address-cells = <3>;
 				#size-cells = <2>;
-- 
2.35.1



