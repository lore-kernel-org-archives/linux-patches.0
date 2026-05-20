Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5064C2C15AB;
	Wed, 20 May 2026 16:46:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779295613; cv=none; b=paWX1YoMCF4GpCw2EMwK3rborAc9DENRpkXKV8oZ0TprX+zRAsF7Lj2TZe8E/u4subzypQhjxdma8tzgZHL2PuRrfivXrb0BuxraXuH76GDQohNO9EXSfyN4NaHqxfXJoVEoZu4l3Eda86ercvfX8rLr/AYJQfhpdZBS93Gxlk8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779295613; c=relaxed/simple;
	bh=GHN3CAXJ4HyTNxTWuShEE7iQeaQ54h6dYxBm7KhFu0Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GcIgA7TGXSkSANHR+eCPacp017An2jL/MvIPfmf17XpgCj5fU5xaQ1aDAiPjXn6+2xe1s4apUnAo9nyh7z8DdTNtBGGkiEXWujZyG01QBLnevSOcWZ9rrYrDL5cU6Laia9s0AiAtlaMByJiJq44UkOsLwSRoUbEnihxwXAQO60Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IJYV4sYi; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IJYV4sYi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6D3D81F000E9;
	Wed, 20 May 2026 16:46:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779295610;
	bh=oon/Z91NKPUelLNurhS8CIduNE8F2f7DFl918bhYxno=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=IJYV4sYia1v7NxhEr5jfdpBPcOAjAytHEFbFQRz1UK+uXuVETZctBOM+H1oKsP2te
	 xT+nXjBYPyUGfEC/yaOxNHiCNXV/1KuimEDr8VNQzCTjGG1YGtk76TnEhLevv0QbkJ
	 AWHcUErwecTLXPrY/n/SycrniB0C88FuICTyABgY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Akari Tsuyukusa <akkun11.open@gmail.com>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 0486/1146] arm64: dts: mediatek: mt7986a: Fix gpio-ranges pin count
Date: Wed, 20 May 2026 18:12:16 +0200
Message-ID: <20260520162159.190842159@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162148.390695140@linuxfoundation.org>
References: <20260520162148.390695140@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

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
index 9693f62fd0136..9ebc196107e5a 100644
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



