Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B4B7517592;
	Tue, 30 Apr 2024 11:28:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714476504; cv=none; b=SU0m7BO/OiWFVpYMJjBNalLFMZuEblEP/i2KaVNHEjZ6q4Zeb4Nn/0pxAoDTltMIjOM0EDAeQv30C48pafVeeMMaMDJh8vmKyRExHozxLvTc6+17FdCZc+KD/2IhVuaVNmeY9ImXyKPS45mxxsN8PdTWrqNIxOd1dxcjFFTtMD4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714476504; c=relaxed/simple;
	bh=ui9/I7AmgMsJl+D2LAwVLtahvUTreDgC7YHXrUHb8VQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WQTJZfpScj8zPkaZtbAcm8IUFh+FP32Y7tm1xPrP1bsyiPe2AMNzT6Gj+chUoO6ESNOxrdJ5VxK6p3t/L1iCfqIAWrAzcCn8VipPK/VWRC4kkHxtL+JylTRq29GX23xiqKMQVg4GvjFNJqOQCz8ApZkFNA0QV6eF/ZomraHXfEk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xfwzyHsY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xfwzyHsY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 35861C2BBFC;
	Tue, 30 Apr 2024 11:28:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1714476504;
	bh=ui9/I7AmgMsJl+D2LAwVLtahvUTreDgC7YHXrUHb8VQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xfwzyHsYT/eWmSx4bJp7UmZiySBzKv7ZFiHdXvNYBlvT3iapyL+YCHeAbuMZ39AfI
	 NDk4n/6a0Gtv3w8Dzi9ah5AiDn53CejCOSGbt0sz1IjvUgnjVjaRfzXREmc4Uxpi3J
	 H72QzDXPazq4O5OUD5SQQu5S116h3UIAnbY0afb4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pin-yen Lin <treapking@chromium.org>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 014/110] arm64: dts: mediatek: mt8192-asurada: Update min voltage constraint for MT6315
Date: Tue, 30 Apr 2024 12:39:43 +0200
Message-ID: <20240430103047.991292223@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240430103047.561802595@linuxfoundation.org>
References: <20240430103047.561802595@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pin-yen Lin <treapking@chromium.org>

[ Upstream commit 374a7c6400e314458178255a63c37d6347845092 ]

Update the minimum voltage from 300000 uV to 400000 uV so it matches
the MT6315 datasheet.

Also update the minimum voltage for Vgpu regulator from 606250 uV to
400000 uV because the requested voltage could be lower than the minimum
voltage on the GPU OPP table when the MTK Smart Voltage Scaling (SVS)
driver is enabled.

Fixes: 3183cb62b033 ("arm64: dts: mediatek: asurada: Add SPMI regulators")
Signed-off-by: Pin-yen Lin <treapking@chromium.org>
Reviewed-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Link: https://lore.kernel.org/r/20240315111621.2263159-2-treapking@chromium.org
Signed-off-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/mediatek/mt8192-asurada.dtsi | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/arm64/boot/dts/mediatek/mt8192-asurada.dtsi b/arch/arm64/boot/dts/mediatek/mt8192-asurada.dtsi
index c6080af1e4a30..0814ed6a7272d 100644
--- a/arch/arm64/boot/dts/mediatek/mt8192-asurada.dtsi
+++ b/arch/arm64/boot/dts/mediatek/mt8192-asurada.dtsi
@@ -903,7 +903,7 @@
 			mt6315_6_vbuck1: vbuck1 {
 				regulator-compatible = "vbuck1";
 				regulator-name = "Vbcpu";
-				regulator-min-microvolt = <300000>;
+				regulator-min-microvolt = <400000>;
 				regulator-max-microvolt = <1193750>;
 				regulator-enable-ramp-delay = <256>;
 				regulator-allowed-modes = <0 1 2>;
@@ -913,7 +913,7 @@
 			mt6315_6_vbuck3: vbuck3 {
 				regulator-compatible = "vbuck3";
 				regulator-name = "Vlcpu";
-				regulator-min-microvolt = <300000>;
+				regulator-min-microvolt = <400000>;
 				regulator-max-microvolt = <1193750>;
 				regulator-enable-ramp-delay = <256>;
 				regulator-allowed-modes = <0 1 2>;
@@ -930,7 +930,7 @@
 			mt6315_7_vbuck1: vbuck1 {
 				regulator-compatible = "vbuck1";
 				regulator-name = "Vgpu";
-				regulator-min-microvolt = <606250>;
+				regulator-min-microvolt = <400000>;
 				regulator-max-microvolt = <800000>;
 				regulator-enable-ramp-delay = <256>;
 				regulator-allowed-modes = <0 1 2>;
-- 
2.43.0



