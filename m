Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 29AEF1863
	for <patches@lists.linux.dev>; Wed, 28 Dec 2022 15:04:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9FAE5C433EF;
	Wed, 28 Dec 2022 15:04:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1672239862;
	bh=Mdsob+SE7nZK0xnBTXgXVW89uWMn9GX9eUzueW0JSjA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=E+KrZnNSe4YW5lBjrfBVqyudu8fZS2+YP3JEMa15bdzzF28uctrjqusBO1Inkp4/g
	 DyLiL9c5xxJeXHMc3IboCiOsMs+FHoCABprwO/ENKSvS2znKvnHgEN03NdcRzVJvUB
	 RP7dgQnxV5UCp0kVJzZo+XMuTb/Km5EtWEl4iGAM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Janne Grunau <j@jannau.net>,
	Mark Kettenis <kettenis@openbsd.org>,
	Hector Martin <marcan@marcan.st>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 0087/1073] arch: arm64: apple: t8103: Use standard "iommu" node name
Date: Wed, 28 Dec 2022 15:27:55 +0100
Message-Id: <20221228144330.422178384@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144328.162723588@linuxfoundation.org>
References: <20221228144328.162723588@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Janne Grunau <j@jannau.net>

[ Upstream commit 56d32c51dffac8a431b472a4c31efb8563b048d1 ]

The PCIe iommu nodes use "dart" as node names. Replace it with the
the standard "iommu" node name as all other iommu nodes.

Fixes: 3c866bb79577 ("arm64: dts: apple: t8103: Add PCIe DARTs")
Signed-off-by: Janne Grunau <j@jannau.net>
Reviewed-by: Mark Kettenis <kettenis@openbsd.org>
Signed-off-by: Hector Martin <marcan@marcan.st>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/apple/t8103.dtsi | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/arm64/boot/dts/apple/t8103.dtsi b/arch/arm64/boot/dts/apple/t8103.dtsi
index 51a63b29d404..a4d195e9eb8c 100644
--- a/arch/arm64/boot/dts/apple/t8103.dtsi
+++ b/arch/arm64/boot/dts/apple/t8103.dtsi
@@ -412,7 +412,7 @@ nvme@27bcc0000 {
 			resets = <&ps_ans2>;
 		};
 
-		pcie0_dart_0: dart@681008000 {
+		pcie0_dart_0: iommu@681008000 {
 			compatible = "apple,t8103-dart";
 			reg = <0x6 0x81008000 0x0 0x4000>;
 			#iommu-cells = <1>;
@@ -421,7 +421,7 @@ pcie0_dart_0: dart@681008000 {
 			power-domains = <&ps_apcie_gp>;
 		};
 
-		pcie0_dart_1: dart@682008000 {
+		pcie0_dart_1: iommu@682008000 {
 			compatible = "apple,t8103-dart";
 			reg = <0x6 0x82008000 0x0 0x4000>;
 			#iommu-cells = <1>;
@@ -430,7 +430,7 @@ pcie0_dart_1: dart@682008000 {
 			power-domains = <&ps_apcie_gp>;
 		};
 
-		pcie0_dart_2: dart@683008000 {
+		pcie0_dart_2: iommu@683008000 {
 			compatible = "apple,t8103-dart";
 			reg = <0x6 0x83008000 0x0 0x4000>;
 			#iommu-cells = <1>;
-- 
2.35.1



