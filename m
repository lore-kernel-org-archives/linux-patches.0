Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A13443806C6;
	Sat, 12 Sep 2026 07:14:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789197264; cv=none; b=TNxGWKinye1ob7HcAHzAkTiSYZuFE7qh6xrAN/tCPmPGSfOjsDrDm6999AnZ4OpaecQuY+wmZAeVBLUeKIosRvA3OZGTepFOE7sOsADTY+/aZfFzR02os2JsO/w9bMU6WkxQcT2oDHAmgfe4ivXs05wTtXLD3UAvtrgCoQLugsg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789197264; c=relaxed/simple;
	bh=xOFBCaq4FZ17UUuKx4tWVBCg241WD18b85erCp/dFxQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bUrLLPOd0mxKz3Tij4qi/MOgKkUY+EfnMzW2JlugNmCcv5WPg33eI065mYOax9ddpB/4PNcZgMw/WRx20hTKBJRzGAC7AYfNjOyAWmv+FUaGqJ8VHWNalKFLdCq9YJlzHPqtQXbJxnZssNMpfoAJZfy88HUGBQv5wD4v2mUDDr0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oM9NLQVx; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oM9NLQVx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C209B1F000FF;
	Sat, 12 Sep 2026 07:14:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789197263;
	bh=15kugHcC4BF2wPE4UuknllUEkXuPs6RDDs1zUV+Ohfg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=oM9NLQVxNbem6FIGhNY/V6aSHjqFI7mh4Nf2hzGI9DCdYQcZ7dmbk0oBbSD/tfyDh
	 D+tetaN5sbGoJ4SLbwYKt2ucp1LqQSZzvFZuBOMLAB2dBG+l00DjvUPXAejsHGctF5
	 yJnqPtK71KwXDnsVZz5FKHcl3QcXIEcR3vR+R79g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Francesco Dolcini <francesco.dolcini@toradex.com>,
	Peng Fan <peng.fan@nxp.com>,
	Frank Li <Frank.Li@nxp.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 0095/1815] arm64: dts: freescale: imx95-toradex-smarc: add alias for lpuart5
Date: Sat, 12 Sep 2026 08:30:45 +0200
Message-ID: <20260912065651.240154353@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Francesco Dolcini <francesco.dolcini@toradex.com>

[ Upstream commit 3385e2f77182469940c136b9eeedf01f27b7441f ]

Add alias for lpuart5 so the UART gets a stable line number.
Without this alias, the lpuart driver fails:

  fsl-lpuart 42590000.serial: failed to get alias id, errno -19

This prevents the Bluetooth controller connected to this UART from
working.

Fixes: 104a391bb6ff ("arm64: dts: freescale: imx95-toradex-smarc: Enable bluetooth on lpuart5")
Signed-off-by: Francesco Dolcini <francesco.dolcini@toradex.com>
Acked-by: Peng Fan <peng.fan@nxp.com>
Signed-off-by: Frank Li <Frank.Li@nxp.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/freescale/imx95-toradex-smarc.dtsi | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm64/boot/dts/freescale/imx95-toradex-smarc.dtsi b/arch/arm64/boot/dts/freescale/imx95-toradex-smarc.dtsi
index 7d760470201fa..a6c5398a81e3c 100644
--- a/arch/arm64/boot/dts/freescale/imx95-toradex-smarc.dtsi
+++ b/arch/arm64/boot/dts/freescale/imx95-toradex-smarc.dtsi
@@ -24,6 +24,7 @@ aliases {
 		serial1 = &lpuart1;
 		serial2 = &lpuart6;
 		serial3 = &lpuart3;
+		serial4 = &lpuart5;
 	};
 
 	chosen {
-- 
2.53.0



