Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 44B154C8FFA;
	Tue, 21 Jul 2026 16:01:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784649701; cv=none; b=aPl1zApus5OzQAdL+fs4LuKMYJj/jbySbqOK7Ck5xEutpQxhXaOAVsA/DTtTpJtUOTEmSbWJmgqTtO46HMTNuzHk4IQ7Mhviht51pfTrOUh82ZFIfdcKuqCohaXK27x6rRLSPlsA8Je8/OmqFA3wgiuQ3x5ocVatGI0Awh0aO34=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784649701; c=relaxed/simple;
	bh=n2q4l4xty2FuQavWSGFeG9wljBgWd4hfUoHfafdcnOU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VccCYeT9zMKEw7ZplNHl27SuFM00agNZ+Q+iXK9A6M3juSj11j08GP+ynk3AgSYedG+9zSrGnlq2gfYfwPWtg723kBLnPXNMbPWnYmA7Qkjznmil71Kcztd15fUMcTYwAKS7qwR2NREHHrOSD0asuWOACHSLbcnJ3NDEZ/wxwfA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nji5aa4b; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nji5aa4b"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A99451F000E9;
	Tue, 21 Jul 2026 16:01:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784649700;
	bh=iwYuhS8Bwq/60WuEKGk7GvjbFxSU9aUQ+WTo9Vssljs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=nji5aa4brIPyaBYtalQY5ICoyKGr7QhkPyRcnAU+C+dKFpYLkUSV+Hlbq/JVnGaYd
	 De1HBRhrRXXRl//+dj6r3Ioy2KgX+eV5LJAJTH/Y3P6WX+7aQuQBRYvqx9oN9WOdZu
	 sdtDoGbDoOhA7676KTTvMWuHO33plP+mZs4RwNw8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andre Przywara <andre.przywara@arm.com>,
	Chen-Yu Tsai <wens@kernel.org>,
	Jernej Skrabec <jernej.skrabec@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 0674/2077] arm64: dts: allwinner: a523: Add missing GPIO interrupt
Date: Tue, 21 Jul 2026 17:05:47 +0200
Message-ID: <20260721152608.695420036@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andre Przywara <andre.przywara@arm.com>

[ Upstream commit 6b81aa0c8a4f038712fa549e4d44d8279eeb0440 ]

Even though the Allwinner A523 SoC implements 10 GPIO banks, it has
actually registers for 11 IRQ banks, and even an interrupt assigned to
the first, non-implemented IRQ bank.
Add that first interrupt to the list of GPIO interrupts, to correct the
association between IRQs and GPIO banks.

This fixes GPIO IRQ operation on boards with A523 SoCs, as seen by
broken SD card detect functionality, for instance.

Signed-off-by: Andre Przywara <andre.przywara@arm.com>
Fixes: 35ac96f79664 ("arm64: dts: allwinner: Add Allwinner A523 .dtsi file")
Reviewed-by: Chen-Yu Tsai <wens@kernel.org>
Reviewed-by: Jernej Skrabec <jernej.skrabec@gmail.com>
Link: https://patch.msgid.link/20260327113006.3135663-4-andre.przywara@arm.com
Signed-off-by: Chen-Yu Tsai <wens@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/allwinner/sun55i-a523.dtsi | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/allwinner/sun55i-a523.dtsi b/arch/arm64/boot/dts/allwinner/sun55i-a523.dtsi
index 5afa8d92acbfbd..b71dc1d78987a6 100644
--- a/arch/arm64/boot/dts/allwinner/sun55i-a523.dtsi
+++ b/arch/arm64/boot/dts/allwinner/sun55i-a523.dtsi
@@ -128,7 +128,8 @@ gpu: gpu@1800000 {
 		pio: pinctrl@2000000 {
 			compatible = "allwinner,sun55i-a523-pinctrl";
 			reg = <0x2000000 0x800>;
-			interrupts = <GIC_SPI 69 IRQ_TYPE_LEVEL_HIGH>,
+			interrupts = <GIC_SPI 67 IRQ_TYPE_LEVEL_HIGH>,
+				     <GIC_SPI 69 IRQ_TYPE_LEVEL_HIGH>,
 				     <GIC_SPI 71 IRQ_TYPE_LEVEL_HIGH>,
 				     <GIC_SPI 73 IRQ_TYPE_LEVEL_HIGH>,
 				     <GIC_SPI 75 IRQ_TYPE_LEVEL_HIGH>,
-- 
2.53.0



