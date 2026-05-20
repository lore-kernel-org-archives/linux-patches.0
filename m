Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6385528DC4;
	Wed, 20 May 2026 17:32:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779298353; cv=none; b=BASJW5Wnpbtuqfl2IZhl3DuTp3/G6Ne8MHHYxicTW6Icv6qJIcZuQ/VIZ03bbdXHLJCGO1P2IYdL/IVCQmhQALSV62678+qD9tYOm+3fdOsss1eAgR8oWfNdukIb9vJy159DvxSpbHWWShOD0rAFBZI1GQhb5frY/cxbnbxJ9w4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779298353; c=relaxed/simple;
	bh=910idmpLCCugK8P7VyRP7TGBOW7kfV/4Gb879NrNbbc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HOvcO4mkhPzVA/Df1wzD8WLU4V3NBZ9s69RnPvDe02PWPq1ShIkm1P2BmGz6Rgi5YHxFXViXat7yebA1NZR+yvsVUeFPfccJRwr23ySL5Cblyggfm2Vcc1EKK4i6XeHUXKtAzHc/iTul/nGJuixiAhG6nCnSQM1GfDadha4X4/k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kW5oWB8D; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kW5oWB8D"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BF1DE1F000E9;
	Wed, 20 May 2026 17:32:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779298352;
	bh=CLkXKn+sd2YBjlKeRyon6odgEUJx1KnAxNsDKORg8UE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=kW5oWB8DROk/ri3r+edrxK62GYHWlBAmuC/h2eaneLrvfh/Aq0G3g49hfe4Sfxhfc
	 fXY8pHZLZPU0Xw0JsXb1fLbD2bEgDTFoqZIgsTF7wodEY2Jf7EQaYgtg5uhLWewzPg
	 J3cD688yHyanpi5J6JSEBFXHoNOt3U3NN2wdiih4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Akari Tsuyukusa <akkun11.open@gmail.com>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 378/957] arm64: dts: mediatek: mt7986a: Fix gpio-ranges pin count
Date: Wed, 20 May 2026 18:14:21 +0200
Message-ID: <20260520162142.725656219@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162134.554764788@linuxfoundation.org>
References: <20260520162134.554764788@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Akari Tsuyukusa <akkun11.open@gmail.com>

[ Upstream commit 820ed0c1a13c5fafb36232538d793f99a0986ef3 ]

The gpio-ranges in the MT7986A pinctrl node were incorrectly defined,
therefore, pin 100 cannot be used.
Correct the range count to match the driver.

Fixes: c3a064a32ed9 ("arm64: dts: mediatek: add pinctrl support for mt7986a")
Signed-off-by: Akari Tsuyukusa <akkun11.open@gmail.com>
Signed-off-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/mediatek/mt7986a.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/mediatek/mt7986a.dtsi b/arch/arm64/boot/dts/mediatek/mt7986a.dtsi
index a8972330a7b89..6786e5b590e85 100644
--- a/arch/arm64/boot/dts/mediatek/mt7986a.dtsi
+++ b/arch/arm64/boot/dts/mediatek/mt7986a.dtsi
@@ -187,7 +187,7 @@ pio: pinctrl@1001f000 {
 				    "iocfg_lb", "iocfg_tr", "iocfg_tl", "eint";
 			gpio-controller;
 			#gpio-cells = <2>;
-			gpio-ranges = <&pio 0 0 100>;
+			gpio-ranges = <&pio 0 0 101>;
 			interrupt-controller;
 			interrupts = <GIC_SPI 225 IRQ_TYPE_LEVEL_HIGH>;
 			interrupt-parent = <&gic>;
-- 
2.53.0



