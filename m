Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795031003;
	b=D4r+ZN6ruSZq1X9lOUGwez6KrlkM6OwrZV3X3F5ExmpJrbDSUIUPyWo5P8CQLGh9esRN
	 dAfwYFBmSVox958d51Yc2PvF2TvzT0RnzlaUbC2pRpiPDaKLPJRkEud4CsaCRxqYbMBXL
	 vxKo7Y18FPI/+3ifhNDU5P76IxDPjIcnqMm4a2+xAg0bqUXJeV2CuDkZmGwrZr8Nc2hdK
	 snhH0IxWSx7kB7S0FEoGbLMbAstqabu5//f57w+85/kZEtEmnYMWWSQFItl0wniItHDiv
	 YOQdcfBEkdT+1Q14I1mn1CQNfBPB8s76hQe+ACNgvS1hMtd/k/ZofPG/H5BoiPQFWig==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795031003;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=KkgaR9UbTkyiR8yS+ljgEi76DS/o6XZi4Kg6SkPv0FU=;
	b=5dWbAG8Hk0bA1AV1HX3GX/ASP6ZCSmeB+n0h7A/qE9GwsfI9lFlUnM1eeI+2FgDWBNVV
	 /Ti7vNkvfmjBO01CFS4uY1AkOdBr1k6QR9WlwnEbkZcmyFijmyYLs4CdDr2rNSYWpNQIq
	 ohcO5uxOB1ZZw8RW6drgO1XK8asWgHK4VCi9B+kBhMbPN5K3CBtn8woVXBUKxSYxG7Uz5
	 20TodaIlWhdTT1V0M0SUvXPadj/5mly/K2OYTZznUU/0hxP0/PNYytx/U/gmeRWASUoEO
	 Le8NNa4w+jicKneA9NPrLSlBwcZ1lC3yqxrNMmblklZusM72rTK9NGlmLrSDX723ANQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=2izlkYqx;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6BB4B606A332;
	Wed, 18 Nov 2026 19:43:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=2izlkYqx
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BA73C1F000C7;
	Wed, 18 Nov 2026 19:43:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795031003;
	bh=KkgaR9UbTkyiR8yS+ljgEi76DS/o6XZi4Kg6SkPv0FU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=2izlkYqxRncsNip7WaaJBkPr6cmcCjOSY6JR02vB6qTzo0f/K69xonm1eEAV+e/gP
	 a7ff4/cZWc34gcfULSaye5YaQpEMl641tYJrAQCNGnrQ+aMGNSPaj32oN6kBLy1ca/
	 JpDIX+CfcrvejQMQj/To/geEPvWUB/LLSn5b74Rg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jernej Skrabec <jernej.skrabec@gmail.com>,
	Chen-Yu Tsai <wens@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0904/1756] arm64: dts: allwinner: sun50i-h6: Add missing SRAM region for video engine
Date: Wed, 18 Nov 2026 15:50:31 +0100
Message-ID: <20261118150045.976537282@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chen-Yu Tsai <wens@kernel.org>

[ Upstream commit d7287d940f3cd8d5945009076058a8120281744b ]

The SRAM C region contains a partial alias to the VE SRAM already
referenced by the video engine. To avoid access through this alias
window, the region should also be claimed by the video engine.

Add a reference to the SRAM C region to the video engine node.

Fixes: b542570e5605 ("arm64: dts: allwinner: h6: Add Video Engine node")
Reviewed-by: Jernej Skrabec <jernej.skrabec@gmail.com>
Link: https://patch.msgid.link/20260712030011.3778169-6-wens@kernel.org
Signed-off-by: Chen-Yu Tsai <wens@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/allwinner/sun50i-h6.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/allwinner/sun50i-h6.dtsi b/arch/arm64/boot/dts/allwinner/sun50i-h6.dtsi
index 2301c59b41b18..ba9b026677665 100644
--- a/arch/arm64/boot/dts/allwinner/sun50i-h6.dtsi
+++ b/arch/arm64/boot/dts/allwinner/sun50i-h6.dtsi
@@ -209,7 +209,7 @@ video-codec@1c0e000 {
 			clock-names = "ahb", "mod", "ram";
 			resets = <&ccu RST_BUS_VE>;
 			interrupts = <GIC_SPI 89 IRQ_TYPE_LEVEL_HIGH>;
-			allwinner,sram = <&ve_sram 1>;
+			allwinner,sram = <&ve_sram 1>, <&de2_sram 1>;
 			iommus = <&iommu 3>;
 		};
 
-- 
2.53.0



