Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 73CC52FDC25;
	Tue, 12 Aug 2025 17:40:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755020411; cv=none; b=a1F5TxtqMOabMf/tiC8jh/MAR/+EXo3/p8KRJfVRmClXAEZ6vH0skiEHpjBMsV1r9HnNIsuDbyAiM63vzkRaNgyjGIRt2Qtlli3+qfY05MXQSVomOJ9/ggx2oCitLchD9e7Is2JeeH0D0b9VWTH19zUKe5vR1Nf8wnZG5eZTONE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755020411; c=relaxed/simple;
	bh=stBtWMfdzY8dAn6zhIn0f1OYTGWBfesdL+odJ4YLRt8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JOl7LTOE4PrV4GWFSeH5KdbyIcE/NiZPpd02I0NPcFV8A0jo+yPNbc2ug6uuM9Z1L5qI+drgNRAAaGilVV2JUcY0aIGryLRK0p1xhaDeOr5Jkf5tcnb995alcvldwAHCW+bWvB+sbL+66frmZldBTPclHKIZ6o9wjc6qBZiOPQE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zgWubKDC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zgWubKDC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E1FBEC4CEF6;
	Tue, 12 Aug 2025 17:40:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755020411;
	bh=stBtWMfdzY8dAn6zhIn0f1OYTGWBfesdL+odJ4YLRt8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zgWubKDCW132PJfGPs4Xo58iUPnDPGPPKtm+XeXBC/EwUI6MVVrkx/phjrFuFfXQF
	 bdfbFrG0igedEYNssHSc9uqf1TUG2MWFYPe+QU8vmkYDDYWG473fToS1SiG9bgjLyv
	 Ua+5ct+iCkb6ai7R8HgXj+v0Lz85HCpm/mf3cdpA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Shawn Guo <shawnguo@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 074/253] ARM: dts: vfxxx: Correctly use two tuples for timer address
Date: Tue, 12 Aug 2025 19:27:42 +0200
Message-ID: <20250812172951.883182825@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812172948.675299901@linuxfoundation.org>
References: <20250812172948.675299901@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>

[ Upstream commit f3440dcf8b994197c968fbafe047ce27eed226e8 ]

Address and size-cells are 1 and the ftm timer node takes two address
spaces in "reg" property, so this should be in two <> tuples.  Change
has no functional impact, but original code is confusing/less readable.

Fixes: 07513e1330a9 ("ARM: dts: vf610: Add Freescale FlexTimer Module timer node.")
Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Signed-off-by: Shawn Guo <shawnguo@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/vfxxx.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/boot/dts/vfxxx.dtsi b/arch/arm/boot/dts/vfxxx.dtsi
index d53f9c9db8bf..eb7973fb4713 100644
--- a/arch/arm/boot/dts/vfxxx.dtsi
+++ b/arch/arm/boot/dts/vfxxx.dtsi
@@ -617,7 +617,7 @@ usbmisc1: usb@400b4800 {
 
 			ftm: ftm@400b8000 {
 				compatible = "fsl,ftm-timer";
-				reg = <0x400b8000 0x1000 0x400b9000 0x1000>;
+				reg = <0x400b8000 0x1000>, <0x400b9000 0x1000>;
 				interrupts = <44 IRQ_TYPE_LEVEL_HIGH>;
 				clock-names = "ftm-evt", "ftm-src",
 					"ftm-evt-counter-en", "ftm-src-counter-en";
-- 
2.39.5



