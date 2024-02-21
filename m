Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 13FA67BB02;
	Wed, 21 Feb 2024 13:30:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708522204; cv=none; b=OcH3HQrFepTpVG85sRlSde0OdEFU6tKRWx86wwBWwUHl4Du3gSLOax7z66l3RnVx7vVZjvxS+0YdOtxlEdMDRQyrWpoXPP0fEiiqmotAYI32k1EDPrPPQUGHzpUQGA6b4h0MqKtVPibxLiu6xPDMYlsIl/68xpwRuC2CiFubhMw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708522204; c=relaxed/simple;
	bh=I1nSq7ags4nTMYcJG0Q3BSu6o+otlpn7sdGVNeZBwJQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=W7cLb0uIDOwOZDJNFkAKOkr2kbyrJ3IUKK3NzmHfjem7wEBe1WTDRu4L4ZPFSUPhupyoKUTdqXfgMDtLCG7Don4kJ3nxHtXkve/MI748SdW5U9K3xcvTy81FoHdVbreozPko/fMmI+61v1QkpzXVQNkQboJc4JAtaQpc/i/sVBE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cCzx1Yxv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cCzx1Yxv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7308FC43390;
	Wed, 21 Feb 2024 13:30:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708522203;
	bh=I1nSq7ags4nTMYcJG0Q3BSu6o+otlpn7sdGVNeZBwJQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cCzx1YxvWjAwlbyQJRX3Gn4Sb+gS5vO/YMEsZ89lIiUThbI+MkjqArza81nZGkZLh
	 iK7/xjjSDqqIOeYQNOlVcYhvmUUcyBs4xeX88vcOyl12CrR0NtLwuOhBCxrMZeLcGh
	 DVYNQGmWSJj+BL4sr75tN5ubfiozrAfXFCW8RuFU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Manivannan Sadhasivam <mani@kernel.org>,
	Johan Hovold <johan+linaro@kernel.org>,
	Konrad Dybcio <konrad.dybcio@linaro.org>,
	Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 103/476] ARM: dts: qcom: sdx55: fix pdc #interrupt-cells
Date: Wed, 21 Feb 2024 14:02:34 +0100
Message-ID: <20240221130011.780321669@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240221130007.738356493@linuxfoundation.org>
References: <20240221130007.738356493@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johan Hovold <johan+linaro@kernel.org>

[ Upstream commit cc25bd06c16aa582596a058d375b2e3133f79b93 ]

The Qualcomm PDC interrupt controller binding expects two cells in
interrupt specifiers.

Fixes: 9d038b2e62de ("ARM: dts: qcom: Add SDX55 platform and MTP board support")
Cc: stable@vger.kernel.org      # 5.12
Cc: Manivannan Sadhasivam <mani@kernel.org>
Signed-off-by: Johan Hovold <johan+linaro@kernel.org>
Reviewed-by: Konrad Dybcio <konrad.dybcio@linaro.org>
Reviewed-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Link: https://lore.kernel.org/r/20231213173131.29436-2-johan+linaro@kernel.org
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/qcom-sdx55.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/boot/dts/qcom-sdx55.dtsi b/arch/arm/boot/dts/qcom-sdx55.dtsi
index 4e7381d0e205..e8b4cbd39413 100644
--- a/arch/arm/boot/dts/qcom-sdx55.dtsi
+++ b/arch/arm/boot/dts/qcom-sdx55.dtsi
@@ -447,7 +447,7 @@ pdc: interrupt-controller@b210000 {
 			compatible = "qcom,sdx55-pdc", "qcom,pdc";
 			reg = <0x0b210000 0x30000>;
 			qcom,pdc-ranges = <0 179 52>;
-			#interrupt-cells = <3>;
+			#interrupt-cells = <2>;
 			interrupt-parent = <&intc>;
 			interrupt-controller;
 		};
-- 
2.43.0



