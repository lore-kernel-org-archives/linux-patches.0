Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E38C2E63B
	for <patches@lists.linux.dev>; Wed, 20 Sep 2023 12:13:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D318DC433C7;
	Wed, 20 Sep 2023 12:13:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1695212028;
	bh=gfBPQlogCmkgoElZM/vnkDbrNj2bI8fWa222YHCPnpw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rBslKlac70kEg382EkUJP9a1UuOTBlYMt6oXasP4UjW6vIcinQPPoP7iDtxY1anPs
	 Rga1F5qzBAstc/wtSNCVOF04rR/n7hNvoTrFq6abq9+90E0rYg2Ttin9itZFbAzh9W
	 16SQuTPSD9itCN29EAKt17WIpPlxkTC3r4R+whvI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alim Akhtar <alim.akhtar@samsung.com>,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 094/273] ARM: dts: samsung: s5pv210-smdkv210: correct ethernet reg addresses (split)
Date: Wed, 20 Sep 2023 13:28:54 +0200
Message-ID: <20230920112849.346057496@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230920112846.440597133@linuxfoundation.org>
References: <20230920112846.440597133@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>

[ Upstream commit 982655cb0e7f18934d7532c32366e574ad61dbd7 ]

The davicom,dm9000 Ethernet Controller accepts two reg addresses.

Fixes: b672b27d232e ("ARM: dts: Add Device tree for s5pc110/s5pv210 boards")
Reviewed-by: Alim Akhtar <alim.akhtar@samsung.com>
Link: https://lore.kernel.org/r/20230713152926.82884-2-krzysztof.kozlowski@linaro.org
Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/s5pv210-smdkv210.dts | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/boot/dts/s5pv210-smdkv210.dts b/arch/arm/boot/dts/s5pv210-smdkv210.dts
index ec5e18c59d3cf..53a841ecf7a44 100644
--- a/arch/arm/boot/dts/s5pv210-smdkv210.dts
+++ b/arch/arm/boot/dts/s5pv210-smdkv210.dts
@@ -41,7 +41,7 @@ pmic_ap_clk: clock-0 {
 
 	ethernet@a8000000 {
 		compatible = "davicom,dm9000";
-		reg = <0xA8000000 0x2 0xA8000002 0x2>;
+		reg = <0xa8000000 0x2>, <0xa8000002 0x2>;
 		interrupt-parent = <&gph1>;
 		interrupts = <1 IRQ_TYPE_LEVEL_HIGH>;
 		local-mac-address = [00 00 de ad be ef];
-- 
2.40.1



