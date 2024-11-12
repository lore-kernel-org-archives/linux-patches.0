Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5DF1720EA2D;
	Tue, 12 Nov 2024 10:39:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731407983; cv=none; b=s6Uk+25sg5D56a1tyEbA0ygpxBOO/kq8p2Rb2csvMbFfYCc7IHmroNe1jHVO9fkSBPZX9793UAEP5CRzmr3R+/rI05O1z3xAjLov/VRG/ljMXNMGFqBkL2wujWM3qjDhhGayFgNnS3Psj/1mhxr1qxUIkCS/X/e91qBRWDVT8OI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731407983; c=relaxed/simple;
	bh=vaNo/HVNu7U+7XY/txhmOYPBxCfNObKFFPmlkn/nlWQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EWUvwgTc3SgzD3zH3Ksub+RBeg7hIuii/77pi5WZnUfSPF5aoGap7ZXNznByL9gzbyjJxASDzid3nmVwImh6QvCVbivjhcpSBoDHd0uPR2Xe4X1vyysADvksCCfV1C//MU5r9F6DRb9aEZuxmm75mkMOAgYbivPjCJOS4OtxfgU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YiF0G881; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YiF0G881"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D50E8C4CEDE;
	Tue, 12 Nov 2024 10:39:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1731407983;
	bh=vaNo/HVNu7U+7XY/txhmOYPBxCfNObKFFPmlkn/nlWQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YiF0G881uraQdy795SX4/9+IdsQ6rQyAtLYXYtcu46d01FsUrOX0Ypyyy6mZQmDFe
	 2SdYfgkChQSc6ajgOPMvf5m5uLiwy8LyW00wVXE2u6GZ4HXGKz8PSPjsSLdedWLQlI
	 AvEVoLky2khCTH8HOKTPHimoYBCD34972itkJ85c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Isaac Scott <isaac.scott@ideasonboard.com>,
	Marek Vasut <marex@denx.de>,
	Yannic Moog <y.moog@phytec.de>,
	Shawn Guo <shawnguo@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 023/184] arm64: dts: imx8mp-phyboard-pollux: Set Video PLL1 frequency to 506.8 MHz
Date: Tue, 12 Nov 2024 11:19:41 +0100
Message-ID: <20241112101901.757523594@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241112101900.865487674@linuxfoundation.org>
References: <20241112101900.865487674@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Marek Vasut <marex@denx.de>

[ Upstream commit 4fbb73416b10778adfd2c1319e9c5829780d8535 ]

The LVDS panel on this device uses 72.4 MHz pixel clock, set IMX8MP_VIDEO_PLL1
to 72.4 * 7 = 506.8 MHz so the LDB serializer and LCDIFv3 scanout engine can
reach accurate pixel clock of exactly 72.4 MHz.

Without this patch, the Video PLL1 frequency is the default set in imx8mp.dtsi
which is 1039.5 MHz, which divides down to inaccurate pixel clock of 74.25 MHz
which works for this particular panel by sheer chance.

Stop taking that chance and set correct accurate pixel clock frequency instead.

Fixes: 326d86e197fc ("arm64: dts: imx8mp-phyboard-pollux-rdk: add etml panel support")
Reported-by: Isaac Scott <isaac.scott@ideasonboard.com>
Signed-off-by: Marek Vasut <marex@denx.de>
Reviewed-by: Yannic Moog <y.moog@phytec.de>
Tested-by: Yannic Moog <y.moog@phytec.de>
Signed-off-by: Shawn Guo <shawnguo@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../dts/freescale/imx8mp-phyboard-pollux-rdk.dts     | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/arch/arm64/boot/dts/freescale/imx8mp-phyboard-pollux-rdk.dts b/arch/arm64/boot/dts/freescale/imx8mp-phyboard-pollux-rdk.dts
index 00a240484c254..b6fd292a3b91d 100644
--- a/arch/arm64/boot/dts/freescale/imx8mp-phyboard-pollux-rdk.dts
+++ b/arch/arm64/boot/dts/freescale/imx8mp-phyboard-pollux-rdk.dts
@@ -191,6 +191,18 @@
 	};
 };
 
+&media_blk_ctrl {
+	/*
+	 * The LVDS panel on this device uses 72.4 MHz pixel clock,
+	 * set IMX8MP_VIDEO_PLL1 to 72.4 * 7 = 506.8 MHz so the LDB
+	 * serializer and LCDIFv3 scanout engine can reach accurate
+	 * pixel clock of exactly 72.4 MHz.
+	 */
+	assigned-clock-rates = <500000000>, <200000000>,
+			       <0>, <0>, <500000000>,
+			       <506800000>;
+};
+
 &snvs_pwrkey {
 	status = "okay";
 };
-- 
2.43.0



