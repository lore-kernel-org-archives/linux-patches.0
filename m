Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6121325619;
	Thu, 18 Jan 2024 11:00:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705575641; cv=none; b=Xyr5Yj13s4UrFVK716k0F7mflcRXazgu+IfRw734P51h0llbpo4Hdl4RD8yB7X8AB4hSACUvEYeSH8ThRW0Jc3K1w/5Mippwc1d3y/tRhYH1ydZdk1dBvqoWymnXy5mENeyijXwcogzoiA2oImOA9+atc6SLYzbn86aTELvJx+M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705575641; c=relaxed/simple;
	bh=a6/+wkTqJw9GHg1samGqp9EoiUyhtB/LXUUUNqgqmpQ=;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:
	 X-Mailer:In-Reply-To:References:User-Agent:X-stable:
	 X-Patchwork-Hint:MIME-Version:Content-Transfer-Encoding; b=p6D8XPRgjAkJr4TVH3Vsx6+SdvoiaSpqoxQLMB6pTzircQYnGUY3iDEQTvCnd76g1wvgA1vTdsbz1QZi0bZza2CNv94HmmA6fddWPY3gVIHZZDtrFiYccRMlZqaxIc+nXbHtQNfiHNMwC31hqcgXH18SbCj6X7vtxBfdxRKXO4g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JUvsu0Ee; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JUvsu0Ee"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7888DC43390;
	Thu, 18 Jan 2024 11:00:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705575640;
	bh=a6/+wkTqJw9GHg1samGqp9EoiUyhtB/LXUUUNqgqmpQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JUvsu0EeUxKTq4kpSgg5VkXPYeaoe/eED0+yjOJP020ELTN3P2vvpb/4NYQ8psDMb
	 bpzfzKVSuyGDP/7aIZ2ezKdSqe59N0FBuA4TjhGpyICIff13SAIDjEP1a3ZYgXQsd2
	 UQclEM0ZTqOzzAIc8InR0etyAVYpchOMa+QGEgi0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Yanteng Si <siyanteng@loongson.cn>,
	Conor Dooley <conor.dooley@microchip.com>,
	Jiaxun Yang <jiaxun.yang@flygoat.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 053/100] MIPS: dts: loongson: drop incorrect dwmac fallback compatible
Date: Thu, 18 Jan 2024 11:49:01 +0100
Message-ID: <20240118104313.215436525@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240118104310.892180084@linuxfoundation.org>
References: <20240118104310.892180084@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>

[ Upstream commit 4907a3f54b12b8209864572a312cf967befcae80 ]

Device binds to proper PCI ID (LOONGSON, 0x7a03), already listed in DTS,
so checking for some other compatible does not make sense.  It cannot be
bound to unsupported platform.

Drop useless, incorrect (space in between) and undocumented compatible.

Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Signed-off-by: Yanteng Si <siyanteng@loongson.cn>
Reviewed-by: Conor Dooley <conor.dooley@microchip.com>
Acked-by: Jiaxun Yang <jiaxun.yang@flygoat.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/mips/boot/dts/loongson/loongson64-2k1000.dtsi | 3 +--
 arch/mips/boot/dts/loongson/ls7a-pch.dtsi          | 3 +--
 2 files changed, 2 insertions(+), 4 deletions(-)

diff --git a/arch/mips/boot/dts/loongson/loongson64-2k1000.dtsi b/arch/mips/boot/dts/loongson/loongson64-2k1000.dtsi
index 8143a61111e3..c16b521308cb 100644
--- a/arch/mips/boot/dts/loongson/loongson64-2k1000.dtsi
+++ b/arch/mips/boot/dts/loongson/loongson64-2k1000.dtsi
@@ -123,8 +123,7 @@ gmac@3,0 {
 				compatible = "pci0014,7a03.0",
 						   "pci0014,7a03",
 						   "pciclass0c0320",
-						   "pciclass0c03",
-						   "loongson, pci-gmac";
+						   "pciclass0c03";
 
 				reg = <0x1800 0x0 0x0 0x0 0x0>;
 				interrupts = <12 IRQ_TYPE_LEVEL_LOW>,
diff --git a/arch/mips/boot/dts/loongson/ls7a-pch.dtsi b/arch/mips/boot/dts/loongson/ls7a-pch.dtsi
index 2f45fce2cdc4..ed99ee316feb 100644
--- a/arch/mips/boot/dts/loongson/ls7a-pch.dtsi
+++ b/arch/mips/boot/dts/loongson/ls7a-pch.dtsi
@@ -186,8 +186,7 @@ gmac@3,0 {
 				compatible = "pci0014,7a03.0",
 						   "pci0014,7a03",
 						   "pciclass020000",
-						   "pciclass0200",
-						   "loongson, pci-gmac";
+						   "pciclass0200";
 
 				reg = <0x1800 0x0 0x0 0x0 0x0>;
 				interrupts = <12 IRQ_TYPE_LEVEL_HIGH>,
-- 
2.43.0



