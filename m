Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B79236605E;
	Wed, 20 May 2026 16:46:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779295621; cv=none; b=dklfqgvCVCNdiChrOheytKT90VpZnfMMiayGxpn0udzhhoHe+KibMMhlHEpZgsx2emQqKA2oVGdg8trHcTFgveYW9UmsTzvDyCc9AVyB10dZI57tt5zzmZWRaZ4JwUS4IOdPa0b7nZrrIRuwvcLmjy7uVBWUtIDB40yqV6R05Zg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779295621; c=relaxed/simple;
	bh=SK4o+zqRqtORdR2BhXQ9gq21D0VBIpC2/vo/Oeu9gZo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Jj6PkilF6/oRGdTLJSRYVNzIf6vic8m2c7Y7gg0m+2gW4vcq+mw0TOHIVMxzP/Nhq+KrKVhXrWdvKoWQ9xeyYyxVcs0QufWOYY9CB5FUaW03HGtGuUlwM3nbj2X0YTSBKoM00YX9mGym2ygyUpoZZAzjUZyiAlprRlBe86d8GEo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mOKVCOE0; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mOKVCOE0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5697E1F00893;
	Wed, 20 May 2026 16:46:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779295618;
	bh=a3OrJQHRHji6Q+pznd4GP9tntbE2R5oCk5hC5Zo0IQg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mOKVCOE0z44IyvJRxtrsMdaAbtVTVk06DgUrhe5YaTK2LvwEEf2MPIK8mBXJZRrPW
	 0AGJDGYj9RrooXlDCMlaaRUCaZQ1f38Jh3hz1abJQHwcD8LBaMUV4UhUVijB+1lGjo
	 UNTU/yYeZogUOfWvwGHvRp3vzvkozIExF0jf+Jz8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Frieder Schrempf <frieder.schrempf@kontron.de>,
	Frank Li <Frank.Li@nxp.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 0489/1146] arm64: dts: imx8mp-kontron: Drop vmmc-supply to fix SD card on SMARC eval carrier
Date: Wed, 20 May 2026 18:12:19 +0200
Message-ID: <20260520162159.259893062@linuxfoundation.org>
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



