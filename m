Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D3C3029D26E;
	Wed, 20 May 2026 17:32:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779298363; cv=none; b=TjSgVVvKJOsKhaFgCUg929rKN2jkZzBGYybMaZZlv6nCO0EiWfmOJi8nRAlHqneHN3BzqrvHfqRS0Qu59hipxygOqJLBMRE5rI7JoxQMnDoH+sl6T2sudtG+/j5WBZBZUaA5Q0zGvo2z4OuhNyk8k+q3oQpd1GpUmTSH+kWDlRM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779298363; c=relaxed/simple;
	bh=os0DK8UNN6MmwmZXJN8YAKsTYfc61bvmfGcrucx4je0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LIGN+DVvDf7YbRi2HqQNIgbNp9IhTzKCXId7A/frC7qDU5KadrD9Kva5V6fzfW5bkElrX5p4WvVqU1Tkph3p2Wckq3if4WpDavgG9BSYAtzLYkIvxvF50Z0G0n1N/aF2ZSeV3zfl/ho+lPWUSiWIcAHpET+YmvvbiXpQ2c8jMHk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rYG30VWq; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rYG30VWq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 45FE21F000E9;
	Wed, 20 May 2026 17:32:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779298362;
	bh=msH0wUfDuIW2OfqlktA+lp3vzqYtNWNRT61SUeabCu8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=rYG30VWq6eObJonLhjL9oA2L3oN482A1DTS1joIi9pQsaFEsgiwPTBZ+BlYr+tpKR
	 PbRZHYwdQqLzFtGdOrPyvYcu/lgLC8b/qjpC30F7ebxQCCI4jlK/6qPPQlvIvlVlam
	 n5qRaW6PrrgcaM8haIHoZMZb06+ZCUSK2Bn/Jb1Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Frieder Schrempf <frieder.schrempf@kontron.de>,
	Frank Li <Frank.Li@nxp.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 381/957] arm64: dts: imx8mp-kontron: Drop vmmc-supply to fix SD card on SMARC eval carrier
Date: Wed, 20 May 2026 18:14:24 +0200
Message-ID: <20260520162142.791049180@linuxfoundation.org>
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

From: Frieder Schrempf <frieder.schrempf@kontron.de>

[ Upstream commit d2ce84eecf081056b1d18d7524de52f849281ba7 ]

The SMARC evaluation carrier provides an SD card power switch that
complies with the OSM standard definition. The OSM base devicetree
already describes this correctly.

Stop overriding the vmmc-supply in the board devicetree and rely on
the definition from the OSM base DTS instead to fix the power supply
configuration for the SD card.

Fixes: 6fe1ced5ccab7 ("arm64: dts: Add support for Kontron i.MX8MP SMARC module and eval carrier")
Signed-off-by: Frieder Schrempf <frieder.schrempf@kontron.de>
Signed-off-by: Frank Li <Frank.Li@nxp.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../boot/dts/freescale/imx8mp-kontron-smarc-eval-carrier.dts     | 1 -
 1 file changed, 1 deletion(-)

diff --git a/arch/arm64/boot/dts/freescale/imx8mp-kontron-smarc-eval-carrier.dts b/arch/arm64/boot/dts/freescale/imx8mp-kontron-smarc-eval-carrier.dts
index 2173a36ff6917..74d620dd06b7b 100644
--- a/arch/arm64/boot/dts/freescale/imx8mp-kontron-smarc-eval-carrier.dts
+++ b/arch/arm64/boot/dts/freescale/imx8mp-kontron-smarc-eval-carrier.dts
@@ -249,6 +249,5 @@ &usb3_phy1 {
 };
 
 &usdhc2 {
-	vmmc-supply = <&reg_vdd_3v3>;
 	status = "okay";
 };
-- 
2.53.0



