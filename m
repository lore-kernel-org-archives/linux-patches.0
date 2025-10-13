Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C256230C36B;
	Mon, 13 Oct 2025 15:24:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760369067; cv=none; b=J9GkGxGy3PROEYqfUYoprUxNN6Gf2Ftspcm/pkM2lb1wKNreWXeUq12Vc0OBgV1qIBHS0tvXAglxrsPQzccW/znGJ/NyW+mncuZz6qSn/H9AtsXYvOhHfisJ+heKUkrZHmGo//nzulg4r+mItCE1BXy66N09It981X7C+f70HO8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760369067; c=relaxed/simple;
	bh=UhWpqT2i2nclpC5jaF8eYBDEWOcS1HgoQQDLWF/3Hyo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aj0kSz1w6PiDlc5osRys+0w+RUAo8aJy4iwErUzVqVhragI0JO2EJw76tRMvs/KKZVafuQR5WWRidh/fmS8GnYjCZ9bCc30XiELON11YfdQuRSyJXONBytxQlVOYqRGlY7VqKFNtk2yxes//TEvjNf1dSb/8ZD5eTfddmaj4yfc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0ECQ20P9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0ECQ20P9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E42C6C4CEE7;
	Mon, 13 Oct 2025 15:24:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760369067;
	bh=UhWpqT2i2nclpC5jaF8eYBDEWOcS1HgoQQDLWF/3Hyo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0ECQ20P9F7b0R3E9qcedZVFHfD3orTlvPwdZ7sxt4Z5YZE1wCeQ8iVv3L2VrbISz6
	 2IltQ7zKutlOXwwqP/Cmhtr+maD7HH6x0A4g2lVC+5vaJtYEVg0ht+v7M+H2dOEjhF
	 8w2vHFD09Uo13iwlas5uFJpgNWKZ5pj6KOzJPmcw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xianwei Zhao <xianwei.zhao@amlogic.com>,
	Martin Blumenstingl <martin.blumenstingl@googlemail.com>,
	Neil Armstrong <neil.armstrong@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 116/563] dts: arm: amlogic: fix pwm node for c3
Date: Mon, 13 Oct 2025 16:39:37 +0200
Message-ID: <20251013144415.497378635@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251013144411.274874080@linuxfoundation.org>
References: <20251013144411.274874080@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Xianwei Zhao <xianwei.zhao@amlogic.com>

[ Upstream commit f8c9fabf2f3d87773613734a8479d0ef9b662b11 ]

Fix reg address for c3 pwm node.

Fixes: be90cd4bd422 ("arm64: dts: amlogic: Add Amlogic C3 PWM")
Signed-off-by: Xianwei Zhao <xianwei.zhao@amlogic.com>
Reviewed-by: Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Link: https://lore.kernel.org/r/20250717-fix-pwm-node-v2-1-7365ac7d5320@amlogic.com
Signed-off-by: Neil Armstrong <neil.armstrong@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/amlogic/amlogic-c3.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/amlogic/amlogic-c3.dtsi b/arch/arm64/boot/dts/amlogic/amlogic-c3.dtsi
index cb9ea3ca6ee0f..71b2b3b547f7c 100644
--- a/arch/arm64/boot/dts/amlogic/amlogic-c3.dtsi
+++ b/arch/arm64/boot/dts/amlogic/amlogic-c3.dtsi
@@ -792,7 +792,7 @@ spicc1: spi@52000 {
 			pwm_mn: pwm@54000 {
 				compatible = "amlogic,c3-pwm",
 					     "amlogic,meson-s4-pwm";
-				reg = <0x0 54000 0x0 0x24>;
+				reg = <0x0 0x54000 0x0 0x24>;
 				clocks = <&clkc_periphs CLKID_PWM_M>,
 					 <&clkc_periphs CLKID_PWM_N>;
 				#pwm-cells = <3>;
-- 
2.51.0



