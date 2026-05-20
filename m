Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA352318ED6;
	Wed, 20 May 2026 18:37:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779302228; cv=none; b=KEigoFGDF4XODSVwvmXh+p4ptOHHka46AY1GWSjjzyotcQ8ueOr4DTGz76eSl3VKaVJlPNT6FVSK5XmaTFRuPL0rEzR0BHXTv6XdrIHdDH9TXPjv8ztFMf4o96uySsGnUU9nKjJ1OTiqPy5Vt7CV3E4S2X53myELmMNGQNhxiVo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779302228; c=relaxed/simple;
	bh=0/NYMyDRFWRJMKvPVq/dxORzHdbAv7XPSYIKY9IHACI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lh34FpjyLYpiyIN/osFFhsC3DQDzp1/43z0Mk58FgtbLcnwTAZQ2N7+Wz0mdLpNItAdXtyFLVi5/AFdK4DrAuuStWXCTZ+fuVfnOU4Xk4JBiJVfBOtYdQXRjXNnHlODlxiia47opXwVc+0ZgOXp/N2+wDRzq3jlgHw2Zg1QE9F0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=telOL5uO; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="telOL5uO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1B8B81F000E9;
	Wed, 20 May 2026 18:37:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779302227;
	bh=cQ15i/vlY6oiWMqCFGFRhjfO577ZVRk5es5DXMZL/2g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=telOL5uO2inmZ595meGR9miBNPzwfGmwiXT3JEiSyYuevkYMUBz0pU+BWduCqB0tM
	 EcFguNNay2ScD2WP2yH3PFEsW3hTLpKhHiD238xcYM/kFOZLH8h+5Hnw+mrQ6+bz9/
	 A2uKMDRVmVVKBtGCX66BLE0IpVRnx6zT15fGxEVw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Akari Tsuyukusa <akkun11.open@gmail.com>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 187/508] arm64: dts: mediatek: mt6795: Fix gpio-ranges pin count
Date: Wed, 20 May 2026 18:20:10 +0200
Message-ID: <20260520162102.689569059@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162058.573354582@linuxfoundation.org>
References: <20260520162058.573354582@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 597bce2fed729..228c15b962ea0 100644
--- a/arch/arm64/boot/dts/mediatek/mt6795.dtsi
+++ b/arch/arm64/boot/dts/mediatek/mt6795.dtsi
@@ -353,7 +353,7 @@ pio: pinctrl@10005000 {
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



