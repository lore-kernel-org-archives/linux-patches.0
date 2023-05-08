Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 00AC1168C4
	for <patches@lists.linux.dev>; Mon,  8 May 2023 11:35:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 59FF9C433EF;
	Mon,  8 May 2023 11:35:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1683545722;
	bh=6F9jg284flEmvZXZwX7l9QqDf8kXNTDlsynVvc3zk20=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LdBDgg+wO02+Ct2xTo7/myjm/UvBTndeRUIbmV/cz2HZ/N3VvinvfeVwjF7XT//h6
	 yaDkBBj99bv7pgC5qhrWBveS9KaouhiFei/8wqnmR0tXRPN0jrmdAM9N6ma7SV4A6K
	 EebyuZh95zyVVzclMbOl1BnU55THH1cgY2FGaxWk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christian Marangi <ansuelsmth@gmail.com>,
	Jonathan McDowell <noodles@earth.li>,
	Bjorn Andersson <bjorn.andersson@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 103/371] ARM: dts: qcom: ipq8064: reduce pci IO size to 64K
Date: Mon,  8 May 2023 11:45:04 +0200
Message-Id: <20230508094816.105442199@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230508094811.912279944@linuxfoundation.org>
References: <20230508094811.912279944@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Christian Marangi <ansuelsmth@gmail.com>

[ Upstream commit 8fafb7e5c041814876266259e5e439f93571dcef ]

The current value for pci IO is problematic for ath10k wifi card
commonly connected to ipq8064 SoC.
The current value is probably a typo and is actually uncommon to find
1MB IO space even on a x86 arch. Also with recent changes to the pci
driver, pci1 and pci2 now fails to function as any connected device
fails any reg read/write. Reduce this to 64K as it should be more than
enough and 3 * 64K of total IO space doesn't exceed the IO_SPACE_LIMIT
hardcoded for the ARM arch.

Signed-off-by: Christian Marangi <ansuelsmth@gmail.com>
Tested-by: Jonathan McDowell <noodles@earth.li>
Signed-off-by: Bjorn Andersson <bjorn.andersson@linaro.org>
Link: https://lore.kernel.org/r/20220707010943.20857-7-ansuelsmth@gmail.com
Stable-dep-of: 0b16b34e4916 ("ARM: dts: qcom: ipq8064: Fix the PCI I/O port range")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/qcom-ipq8064.dtsi | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/arm/boot/dts/qcom-ipq8064.dtsi b/arch/arm/boot/dts/qcom-ipq8064.dtsi
index 4139d3817bd6f..8ec927f044c38 100644
--- a/arch/arm/boot/dts/qcom-ipq8064.dtsi
+++ b/arch/arm/boot/dts/qcom-ipq8064.dtsi
@@ -808,7 +808,7 @@
 			#address-cells = <3>;
 			#size-cells = <2>;
 
-			ranges = <0x81000000 0 0x0fe00000 0x0fe00000 0 0x00100000   /* downstream I/O */
+			ranges = <0x81000000 0 0x0fe00000 0x0fe00000 0 0x00010000   /* downstream I/O */
 				  0x82000000 0 0x08000000 0x08000000 0 0x07e00000>; /* non-prefetchable memory */
 
 			interrupts = <GIC_SPI 35 IRQ_TYPE_LEVEL_HIGH>;
@@ -859,7 +859,7 @@
 			#address-cells = <3>;
 			#size-cells = <2>;
 
-			ranges = <0x81000000 0 0x31e00000 0x31e00000 0 0x00100000   /* downstream I/O */
+			ranges = <0x81000000 0 0x31e00000 0x31e00000 0 0x00010000   /* downstream I/O */
 				  0x82000000 0 0x2e000000 0x2e000000 0 0x03e00000>; /* non-prefetchable memory */
 
 			interrupts = <GIC_SPI 57 IRQ_TYPE_LEVEL_HIGH>;
@@ -910,7 +910,7 @@
 			#address-cells = <3>;
 			#size-cells = <2>;
 
-			ranges = <0x81000000 0 0x35e00000 0x35e00000 0 0x00100000   /* downstream I/O */
+			ranges = <0x81000000 0 0x35e00000 0x35e00000 0 0x00010000   /* downstream I/O */
 				  0x82000000 0 0x32000000 0x32000000 0 0x03e00000>; /* non-prefetchable memory */
 
 			interrupts = <GIC_SPI 71 IRQ_TYPE_LEVEL_HIGH>;
-- 
2.39.2



