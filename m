Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C5F25168C4
	for <patches@lists.linux.dev>; Mon,  8 May 2023 11:02:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 28962C4339E;
	Mon,  8 May 2023 11:02:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1683543756;
	bh=Zy8d5MLEtYkDSmiyWljPO8IwYsxU4QBYCyQ3q+SQ01w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gnv/CXrdXyXgAgAFyorE9lOTYvf/xU9XxPYWZTaQQ2OstjWSWEFEdLLTm5ZeGnr3+
	 4Z/qBC+CbiTqYp9vXWnH8nedNrygMRkYJMe7C1f4V2M8mUi+n4rjxvscmDXLWgmL1T
	 eHrRL7bblpjPJ8bBv33mci/ixVT18tar0P+OGG/k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Arnd Bergmann <arnd@arndb.de>,
	Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.3 192/694] arm64: dts: qcom: sc8280xp: Fix the PCI I/O port range
Date: Mon,  8 May 2023 11:40:27 +0200
Message-Id: <20230508094438.647998932@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230508094432.603705160@linuxfoundation.org>
References: <20230508094432.603705160@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>

[ Upstream commit 89fe81c01715f81c3a7d371e9e5f7d7ae5bc557c ]

For 1MiB of the I/O region, the I/O ports of the legacy PCI devices are
located in the range of 0x0 to 0x100000. Hence, fix the bogus PCI addresses
(0x30200000, 0x32200000, 0x34200000, 0x38200000, 0x3c200000) specified in
the ranges property for I/O region.

Fixes: 813e83157001 ("arm64: dts: qcom: sc8280xp/sa8540p: add PCIe2-4 nodes")
Reported-by: Arnd Bergmann <arnd@arndb.de>
Link: https://lore.kernel.org/linux-arm-msm/7c5dfa87-41df-4ba7-b0e4-72c8386402a8@app.fastmail.com/
Signed-off-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Reviewed-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Link: https://lore.kernel.org/r/20230228164752.55682-11-manivannan.sadhasivam@linaro.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/sc8280xp.dtsi | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/arch/arm64/boot/dts/qcom/sc8280xp.dtsi b/arch/arm64/boot/dts/qcom/sc8280xp.dtsi
index 42bfa9fa5b967..60433c810f23f 100644
--- a/arch/arm64/boot/dts/qcom/sc8280xp.dtsi
+++ b/arch/arm64/boot/dts/qcom/sc8280xp.dtsi
@@ -1657,7 +1657,7 @@
 			reg-names = "parf", "dbi", "elbi", "atu", "config";
 			#address-cells = <3>;
 			#size-cells = <2>;
-			ranges = <0x01000000 0x0 0x30200000 0x0 0x30200000 0x0 0x100000>,
+			ranges = <0x01000000 0x0 0x00000000 0x0 0x30200000 0x0 0x100000>,
 				 <0x02000000 0x0 0x30300000 0x0 0x30300000 0x0 0x1d00000>;
 			bus-range = <0x00 0xff>;
 
@@ -1756,7 +1756,7 @@
 			reg-names = "parf", "dbi", "elbi", "atu", "config";
 			#address-cells = <3>;
 			#size-cells = <2>;
-			ranges = <0x01000000 0x0 0x32200000 0x0 0x32200000 0x0 0x100000>,
+			ranges = <0x01000000 0x0 0x00000000 0x0 0x32200000 0x0 0x100000>,
 				 <0x02000000 0x0 0x32300000 0x0 0x32300000 0x0 0x1d00000>;
 			bus-range = <0x00 0xff>;
 
@@ -1853,7 +1853,7 @@
 			reg-names = "parf", "dbi", "elbi", "atu", "config";
 			#address-cells = <3>;
 			#size-cells = <2>;
-			ranges = <0x01000000 0x0 0x34200000 0x0 0x34200000 0x0 0x100000>,
+			ranges = <0x01000000 0x0 0x00000000 0x0 0x34200000 0x0 0x100000>,
 				 <0x02000000 0x0 0x34300000 0x0 0x34300000 0x0 0x1d00000>;
 			bus-range = <0x00 0xff>;
 
@@ -1953,7 +1953,7 @@
 			reg-names = "parf", "dbi", "elbi", "atu", "config";
 			#address-cells = <3>;
 			#size-cells = <2>;
-			ranges = <0x01000000 0x0 0x38200000 0x0 0x38200000 0x0 0x100000>,
+			ranges = <0x01000000 0x0 0x00000000 0x0 0x38200000 0x0 0x100000>,
 				 <0x02000000 0x0 0x38300000 0x0 0x38300000 0x0 0x1d00000>;
 			bus-range = <0x00 0xff>;
 
@@ -2050,7 +2050,7 @@
 			reg-names = "parf", "dbi", "elbi", "atu", "config";
 			#address-cells = <3>;
 			#size-cells = <2>;
-			ranges = <0x01000000 0x0 0x3c200000 0x0 0x3c200000 0x0 0x100000>,
+			ranges = <0x01000000 0x0 0x00000000 0x0 0x3c200000 0x0 0x100000>,
 				 <0x02000000 0x0 0x3c300000 0x0 0x3c300000 0x0 0x1d00000>;
 			bus-range = <0x00 0xff>;
 
-- 
2.39.2



