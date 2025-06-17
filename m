Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0856E28E8;
	Tue, 17 Jun 2025 15:49:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750175381; cv=none; b=rmTZmI/JDylxCZ/O0x7w6njwEWfRxWHz8f0bWa8CQt3DJmOwGHVZEcIeJ/bnFlIzfxqwlYLULEmCNcISfSRgkGP7Achsc9Sps6CrOTXRo5IAv+0pqZKSyxO46p0MgR34cWgkojGtfP4k4NwQYdmAKdkGzlI/SCB8R1LMBl5edho=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750175381; c=relaxed/simple;
	bh=aCwfL1VFQ/Lbz7tocIjEu7OhlQCr0PIU7blxC5pR6b4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=n04XVJezqrFaWrg4ffXSuXRzhoK3ZWZuSYwO49bJmOcmP4GmkGQoQo0inchhSKO1IS8Z92wNhOy88J6FstrVrWsp455JK28InlRmOCkHvLbcOsBrrldaETO0fHq/vIKe6yGMOgBWCHcXbxBoRKpDd5fVpZs2xdu04Sl7/hTgeqM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uDk0SMSv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uDk0SMSv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4D74CC4CEF0;
	Tue, 17 Jun 2025 15:49:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750175380;
	bh=aCwfL1VFQ/Lbz7tocIjEu7OhlQCr0PIU7blxC5pR6b4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uDk0SMSvmO+uSEfObi609mNm1/LPhtVb3eqlzcajnZrXGLtk0dqpiawDvHNChGvIv
	 NbTQL/dsACQOU/cHigheHn1/zrocUGg+4UuVrAcKgK+6B2bU19LHXbGTz0UCRWOWI+
	 6X+5Cvf7BmD/DjsMuCeudNpK50WMfuwrOjjGCTVk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Adam Ford <aford173@gmail.com>,
	Frank Li <Frank.Li@nxp.com>,
	Shawn Guo <shawnguo@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 171/356] arm64: dts: imx8mm-beacon: Set SAI5 MCLK direction to output for HDMI audio
Date: Tue, 17 Jun 2025 17:24:46 +0200
Message-ID: <20250617152345.099416118@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152338.212798615@linuxfoundation.org>
References: <20250617152338.212798615@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Adam Ford <aford173@gmail.com>

[ Upstream commit 8c716f80dfe8cd6ed9a2696847cea1affeeff6ff ]

The HDMI bridge chip fails to generate an audio source due to the SAI5
master clock (MCLK) direction not being set to output. This prevents proper
clocking of the HDMI audio interface.

Add the `fsl,sai-mclk-direction-output` property to the SAI5 node to ensure
the MCLK is driven by the SoC, resolving the HDMI sound issue.

Fixes: 8ad7d14d99f3 ("arm64: dts: imx8mm-beacon: Add HDMI video with sound")
Signed-off-by: Adam Ford <aford173@gmail.com>
Reviewed-by: Frank Li <Frank.Li@nxp.com>
Signed-off-by: Shawn Guo <shawnguo@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/freescale/imx8mm-beacon-kit.dts | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm64/boot/dts/freescale/imx8mm-beacon-kit.dts b/arch/arm64/boot/dts/freescale/imx8mm-beacon-kit.dts
index 905c98cb080d2..a6e6860bf0184 100644
--- a/arch/arm64/boot/dts/freescale/imx8mm-beacon-kit.dts
+++ b/arch/arm64/boot/dts/freescale/imx8mm-beacon-kit.dts
@@ -124,6 +124,7 @@
 	assigned-clock-parents = <&clk IMX8MM_AUDIO_PLL1_OUT>;
 	assigned-clock-rates = <24576000>;
 	#sound-dai-cells = <0>;
+	fsl,sai-mclk-direction-output;
 	status = "okay";
 };
 
-- 
2.39.5



