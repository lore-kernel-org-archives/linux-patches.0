Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0946A3016E1;
	Sat, 30 May 2026 17:14:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780161273; cv=none; b=nbKHk/lwpz0bnAMG21Gt8Kl1TJB25Cbm0ELKMSqftWsCdn66uIp3H6kWLOyLtlXXc2VBJgVEUftthLndsXADx5S8tuWx2FpIwfg7vyBnLvYIs32ps1JH2/AyRc9Teu75KACGaHMZQLIg6XmFrX4YbjnrJC1AnXlL4nO+hmVyRic=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780161273; c=relaxed/simple;
	bh=LBdGhx9hOZjF1U6/wqPj/c2QIOkm135/AoRlGEbw+Bg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=e6BdxdJ72hPqR+suP96vzNGpuxchKzkxjYS/OWWlrehmEmpx76/YtAmbUb2P0QelT6vQk4UqAs8fuWMGRUiBKD5ZYFi4G4f/ejqy2KLTAi6HPtRw0REkNDW5gadkYrLHkBJTdYo8xw4C1ebyMTOlLxt3IVCUIDTa3Yjqk7i0scI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pUYawT2P; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pUYawT2P"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DD78A1F00898;
	Sat, 30 May 2026 17:14:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780161272;
	bh=z2u0Py4be/xHJehXGCPKHQAqZBoK9JV+LQTw4+NHhBc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=pUYawT2PhWvmUaIyDXchKq/uXUQnAFAcALHBmsqQQYo1Tm6YO+l9z/Zjk8EyxetvR
	 07SRGzey9je31xLgy7h9X+zpwQ1YZr1UP61v5Es8pNghq49Xj2BgcXaXEvjQLMcQ2o
	 +kD+QpRhzgnztVFJpDyF9hpapfLFNHUlGMcrVarQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Akari Tsuyukusa <akkun11.open@gmail.com>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 576/969] arm64: dts: mediatek: mt6795: Fix gpio-ranges pin count
Date: Sat, 30 May 2026 18:01:40 +0200
Message-ID: <20260530160316.313223413@linuxfoundation.org>
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

[ Upstream commit c4c4823c8a5baa10b8100b01f49d7c3f4a871689 ]

The gpio-ranges in the MT6795 pinctrl node were incorrectly defined,
therefore, GPIO196 cannot be used.
Correct the range count to match the driver.

Fixes: b888886a4536 ("arm64: dts: mediatek: mt6795: Add pinctrl controller node")
Signed-off-by: Akari Tsuyukusa <akkun11.open@gmail.com>
Signed-off-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/mediatek/mt6795.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/mediatek/mt6795.dtsi b/arch/arm64/boot/dts/mediatek/mt6795.dtsi
index 46f0e54be7664..8c715015284fb 100644
--- a/arch/arm64/boot/dts/mediatek/mt6795.dtsi
+++ b/arch/arm64/boot/dts/mediatek/mt6795.dtsi
@@ -200,7 +200,7 @@ pio: pinctrl@10005000 {
 				     <GIC_SPI 154 IRQ_TYPE_LEVEL_HIGH>;
 			gpio-controller;
 			#gpio-cells = <2>;
-			gpio-ranges = <&pio 0 0 196>;
+			gpio-ranges = <&pio 0 0 197>;
 			interrupt-controller;
 			#interrupt-cells = <2>;
 		};
-- 
2.53.0



