Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3ED07331220;
	Wed, 20 May 2026 18:11:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779300697; cv=none; b=habdLIxWpxkpZy9yrE3va7mpRWmo9+PwiZDe5XOzImDMW4OZn0ojEg7D2tOqlJk4e2YJRoDCp1Ky66y3T5XmeFnvj3jl/DS07ZWHpNRqxzspq2kn6A2fxM88tc+k9EoUH6r76m+r4QE7E1UnEUT8rVcLwR5SSZd1RM4fKE+tbJI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779300697; c=relaxed/simple;
	bh=LvvShUOmrhFBPG2cNbScdrDLB5D2JcAfQjvo5UtxfSc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=W1EQyerxEwDvJWFuJ1QB6YLZaXNj3nzQLOLxB3T1vtcUT97jSW8SqtfYQf2w1B05fx76ebmO/6CFajRoAIfy1WbiSzTGT7H8Ttx8ZLI93zkEeshwuj0ZkS0JiUVR5+9c9ZDrYYFSn5fHJdzZ3bdB6eHTUJyC8v/YyUBKgWJffSc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oxZi3Cfh; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oxZi3Cfh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A52181F00893;
	Wed, 20 May 2026 18:11:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779300696;
	bh=nCDHOddkT6ojidnvA258v2j8E86BmQZAVXvNLbsIOG8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=oxZi3CfhboGFmthTyV7pAoCgFGNSlEtfh4YazV+UZRBPibTJBWInUKZx/HhkScrri
	 92gagM+w7UXK7KIRrBgittU+zFIOynwHxfTSMY4MJWGGji7eXJarC5ELFgvY8XAzo2
	 bHW/11DHU7/smGrr28oaAcaPyISJXrI53X4x5I20=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Akari Tsuyukusa <akkun11.open@gmail.com>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 273/666] arm64: dts: mediatek: mt7986a: Fix gpio-ranges pin count
Date: Wed, 20 May 2026 18:18:04 +0200
Message-ID: <20260520162117.132122227@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162111.222830634@linuxfoundation.org>
References: <20260520162111.222830634@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 559990dcd1d17..05bd2938242fc 100644
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



