Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 713A26FA0
	for <patches@lists.linux.dev>; Mon, 16 Jan 2023 17:01:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EC09CC433D2;
	Mon, 16 Jan 2023 17:01:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1673888501;
	bh=xBogSYZwY6T/4XVTdjf/gt4heMHGxXGKNKzpTeuALXM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=g0afW6sAxhenxg7hkL/KwJlyDCGiXIu2KvSVT08ZuODGdPtpDgfk5dpg6wxPGad6h
	 OhfOppo7Ah78hGgGHxCm9LNd41DnoDOScBrbzEjHHxoaOFclzrlENnC7qnpgoV+Vz5
	 GrynYzJNQMboNcu5xg/mVsKg2DYEgjec1luhxdjk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Pali=20Roh=C3=A1r?= <pali@kernel.org>,
	Gregory CLEMENT <gregory.clement@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 030/338] ARM: dts: armada-370: Fix assigned-addresses for every PCIe Root Port
Date: Mon, 16 Jan 2023 16:48:23 +0100
Message-Id: <20230116154822.087804809@linuxfoundation.org>
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

[ Upstream commit d9208b0fa2e803d16b28d91bf1d46b7ee9ea13c6 ]

BDF of resource in DT assigned-addresses property of Marvell PCIe Root Port
(PCI-to-PCI bridge) should match BDF in address part in that DT node name
as specified resource belongs to Marvell PCIe Root Port itself.

Fixes: a09a0b7c6ff1 ("arm: mvebu: add PCIe Device Tree informations for Armada 370")
Signed-off-by: Pali Rohár <pali@kernel.org>
Signed-off-by: Gregory CLEMENT <gregory.clement@bootlin.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/armada-370.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/boot/dts/armada-370.dtsi b/arch/arm/boot/dts/armada-370.dtsi
index b1cf5a26f3c2..7a4d308a56f4 100644
--- a/arch/arm/boot/dts/armada-370.dtsi
+++ b/arch/arm/boot/dts/armada-370.dtsi
@@ -111,7 +111,7 @@ pcie0: pcie@1,0 {
 
 			pcie2: pcie@2,0 {
 				device_type = "pci";
-				assigned-addresses = <0x82002800 0 0x80000 0 0x2000>;
+				assigned-addresses = <0x82001000 0 0x80000 0 0x2000>;
 				reg = <0x1000 0 0 0 0>;
 				#address-cells = <3>;
 				#size-cells = <2>;
-- 
2.35.1



