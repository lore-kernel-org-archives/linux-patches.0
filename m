Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 84D7434A79D;
	Sat, 30 May 2026 17:14:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780161277; cv=none; b=BHU5P3CaA5SNO8BKqqwlBvxZtVDGzw/KiBpwpDHHYTMi/4isTV9XP7ami6ixOp4xsnAWpyLbxo7nDHjn4hKWMMCnQz6bAVNJXLL396OXFPjHxvaOQkJRgMWFhlsEIBjVOTU0C71+a9KLGsd+QMd5TTJdO+IlvTqkPIoaCxS8OHY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780161277; c=relaxed/simple;
	bh=liFXwFINprBl+GYG8Fdp0DJr5yEBi7p1Q8WdDdBy3Jc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kj3jrLECSj1D4Xg5enZR97va9iot3XDv+dCYoVeFccx2WK9h8AmB+eEAFgoNUdUwZk6znrEfTOUlbYk4Y60kUxe1YI47jkl7D3Ip5DEcvWl0LJeP58Tymx9akvvM+YfVVD7qfO0Ns5ggoeDVSNRbny7mBPJI2p6LfHEtru0tPvQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YMIguWHI; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YMIguWHI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CC6221F00893;
	Sat, 30 May 2026 17:14:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780161276;
	bh=Zz6PdKnlPvtFAkFEKtAUQNno10XDH2hJpihiEeERJMI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=YMIguWHIdbaU6gCfwnFbbN/8Mx3V4IxhDKcq7iFMBK3QphYoLFEZjMd2qOS6jPkQ/
	 JkqFv55uPi8h7D7TfgUR9xVtu98h3ZZSMfVVJZtwN12Khyx8+EiXsYBdLDBWzODxhv
	 ZNS8Oz63JyH9IbOjgvs4oBub1Ud2PxnfvOgeG0Bs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Akari Tsuyukusa <akkun11.open@gmail.com>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 577/969] arm64: dts: mediatek: mt7986a: Fix gpio-ranges pin count
Date: Sat, 30 May 2026 18:01:41 +0200
Message-ID: <20260530160316.340271337@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160300.485627683@linuxfoundation.org>
References: <20260530160300.485627683@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 108931e796465..c647d99c9554a 100644
--- a/arch/arm64/boot/dts/mediatek/mt7986a.dtsi
+++ b/arch/arm64/boot/dts/mediatek/mt7986a.dtsi
@@ -153,7 +153,7 @@ pio: pinctrl@1001f000 {
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



