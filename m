Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792774473;
	b=4SfvtCyrR7uuEXH9TJCDbqt6X1GHsU05AzE9VP2eABvQ5Z4hK6wWoG2W4cGckLfAJACK
	 wGDqz2GRZ7mGTExhB9BRnjo+Uu/4fDThZEXgjwO62qH11qMf0NVJwBNrpetlOzQzdtzjP
	 ZI+8NjPXYvF2uLkbhLRrTxjtuUht0GYmPraaK9Hdh/XhvY6TqdYwey5Qm7wsN1W72EL5J
	 AXcG2jm0qJtGco5+zKoqsks2cHZxqaCW5byy11YrtfKJoVKMthlHOxFVQONK7Ic43/M1T
	 /7lxSFVGpeUH0vanEEK/QKDpP0QtXs11FSlx8phFnPp0y5G6IcO/vwlUGyUwKlhQjIQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792774473;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Im1Ep6GlXqkFQWgsk9JLPRsw/N6CUHETaDGWhadvTg4=;
	b=g7N6GZexO0ZhCAZSMcf6Y+KvieVDBKuRaLLLb5aMQmjQaE4uxJK+IKlu7daShlDnItBb
	 CsSPMRioMUVmZoNoqxIDIHGhgYpo/kCYVlgSc4jWeUfXcObkZ7zbuxyLjwOAVQIi9xCRq
	 BsqQb2XYrxPqcmY7KEBdKosUAoh0IC7ptNxtPxBIc/Cjbnus/sZ253mN6/dkA/IQaUfM2
	 xcjlELN8LSjtFREw1vHCCbsakH6zw544Ry8pPcYk8cKtNa2cdCpkDNUg9eZ+lfdphm4Nn
	 B21tVvCjFPatN6fuczDWs9PONlfVU1CE/2R7b+DURfwvvdHLvk4JQM4cJIYW/keLPjQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=GuAdR2pJ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EEE2F606A31D;
	Fri, 23 Oct 2026 16:54:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=GuAdR2pJ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4D6B31F01825;
	Fri, 23 Oct 2026 16:54:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792774472;
	bh=Im1Ep6GlXqkFQWgsk9JLPRsw/N6CUHETaDGWhadvTg4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=GuAdR2pJ4KwQ30EsFNzaxSTm6seEBKi0NDbf9/az7QwC2obgPannC0PJ1JmR5uztK
	 GvMQBG7tt2sB/XyP44VMRMxOaePfv89Bsjm80jMILxfsc8yr3mhHgkUXaBUnykmOWu
	 s68W4aQUg+T8L/oazljg4GOfDW/ddFXqrWAosHN8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Oberhollenzer <david.oberhollenzer@sigma-star.at>,
	"Kevin Hilman (TI)" <khilman@baylibre.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 004/242] ARM: dts: ti/omap: dra7: fix PCIe PHY clock divider definition
Date: Fri, 23 Oct 2026 18:37:26 +0200
Message-ID: <20261023163713.913814069@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261023163713.816071858@linuxfoundation.org>
References: <20261023163713.816071858@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: David Oberhollenzer <david.oberhollenzer@sigma-star.at>

[ Upstream commit 2fabd2f406d0cf787be47b3bbeea99b30004033d ]

Commit d0bdd8bb7f35 ("ARM: dts: ti/omap: dra7: fix redundant
clock divider definition") removes the clock divider definition
from optfclk_pciephy_div, reasoning that the table is redundant,
as it contains the values 1 and 2, while also setting ti,max-div
to 2 while ti,min-div is implicitly initialized to 1.

What that commit missed was the fact that the values in the table
are in reverse order, i.e. first 2, then 1.

As is clearly described in the documentation, the ordering is
signifficant, the actual values for the register setting are
derived from the index. If no table is specified, the driver
assumes that the register value is divider - 1 (see also `_get_val`
in `drivers/clk/ti/divider.c`).

What is in fact redundant is the value of ti,max-div that is
derived from the table if none is specified. To satisfy device
tree semantic linters, it is removed instead.

Fixes: d0bdd8bb7f35 ("ARM: dts: ti/omap: dra7: fix redundant clock divider definition")
Signed-off-by: David Oberhollenzer <david.oberhollenzer@sigma-star.at>
Link: https://patch.msgid.link/20260716113947.92513-1-david.oberhollenzer@sigma-star.at
Signed-off-by: Kevin Hilman (TI) <khilman@baylibre.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/ti/omap/dra7xx-clocks.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/boot/dts/ti/omap/dra7xx-clocks.dtsi b/arch/arm/boot/dts/ti/omap/dra7xx-clocks.dtsi
index 0de16ee262cf4..615a8fb477761 100644
--- a/arch/arm/boot/dts/ti/omap/dra7xx-clocks.dtsi
+++ b/arch/arm/boot/dts/ti/omap/dra7xx-clocks.dtsi
@@ -1376,8 +1376,8 @@ optfclk_pciephy_div: clock-optfclk-pciephy-div-8@4a00821c {
 		clocks = <&apll_pcie_ck>;
 		#clock-cells = <0>;
 		reg = <0x021c>;
+		ti,dividers = <2>, <1>;
 		ti,bit-shift = <8>;
-		ti,max-div = <2>;
 	};
 
 	apll_pcie_clkvcoldo: clock-apll-pcie-clkvcoldo {
-- 
2.53.0



