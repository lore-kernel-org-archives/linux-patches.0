Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4DFB6368968;
	Wed, 20 May 2026 16:58:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779296322; cv=none; b=FkxFmsHIBMpWd/qp1rFq2wrceqYrT0+cThRvnTU3DoFRmeKLKbM0lDFMzolpb0f6B00C+hDium9R9DiGRi7ogSOWjnYdokENboqFJuwX3/p4BnoNrELIQjeRhfoQYa67sXfNipC9mG0zoYdsL/AwghGrQwD0iE5Zy0QQ/tLE0x8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779296322; c=relaxed/simple;
	bh=TDm4Ug+3xkPlNDcBX8rTJ6Z9ax0O7skV9Pp6tubh/Lc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=e2UpIc00h5SdRFX1umPHoW7S124KTpSz+YrlyuRiPY+b9j5H82rFfzTH6FW8ke17SZzjg6CKF41waqbEQvu8Fl5WqMcp8vs95VSNL+wTb+L2a/b4rtggS/Lmqw5yoIzR4sYBXt2ISIvS+5oh0JrcWS8AsBsdFjJyFZ/d8A41Lmw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tXSSbQ7m; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tXSSbQ7m"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AB3F81F000E9;
	Wed, 20 May 2026 16:58:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779296321;
	bh=lHw5DmdrR0JSK3RVPMpyB/N7ET749vhYteg5TDUqqx4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=tXSSbQ7mL2PBRd/XFbVtWH10fHB/SDQDy8SKay91ziUdk7nTEu5gt/UKeW0JWvzpo
	 uhA+S+u6mny3u0+2B/eUGYbmeY1ONFEHvBS5nYf+i7TmNr/IC3Polnu8id8RtPWm32
	 rwRUr5GE4oBHPUeL+8K+Brm05zF6JKplB1xxf77I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peng Fan <peng.fan@nxp.com>,
	Frank Li <Frank.Li@nxp.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 0755/1146] arm64: dts: imx8mp-aristainetos3a-som-v1: Correct PAD settings for PMIC_nINT
Date: Wed, 20 May 2026 18:16:45 +0200
Message-ID: <20260520162205.297965688@linuxfoundation.org>
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

From: Peng Fan <peng.fan@nxp.com>

[ Upstream commit e6d2d8e49ca34bb39126a69128794d08ffd7c83e ]

With commit 5d0efaf47ee90 ("regulator: pca9450: Correct interrupt type"),
there might be interrupt storm for this board. Need to set PAD PUE and PU
together to make pull up work properly.

Fixes: eead8f3536d5c ("arm64: dts: imx8mp: add aristainetos3 board support")
Signed-off-by: Peng Fan <peng.fan@nxp.com>
Signed-off-by: Frank Li <Frank.Li@nxp.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/freescale/imx8mp-aristainetos3a-som-v1.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/freescale/imx8mp-aristainetos3a-som-v1.dtsi b/arch/arm64/boot/dts/freescale/imx8mp-aristainetos3a-som-v1.dtsi
index f654d866e58c0..e7666e54310be 100644
--- a/arch/arm64/boot/dts/freescale/imx8mp-aristainetos3a-som-v1.dtsi
+++ b/arch/arm64/boot/dts/freescale/imx8mp-aristainetos3a-som-v1.dtsi
@@ -903,7 +903,7 @@ MX8MP_IOMUXC_SAI1_MCLK__GPIO4_IO20	0x41
 
 	pinctrl_pmic: aristainetos3-pmic-grp {
 		fsl,pins = <
-			MX8MP_IOMUXC_GPIO1_IO03__GPIO1_IO03	0x41
+			MX8MP_IOMUXC_GPIO1_IO03__GPIO1_IO03	0x1c0
 		>;
 	};
 
-- 
2.53.0



