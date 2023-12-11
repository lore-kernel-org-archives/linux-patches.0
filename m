Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ABC0C51C25;
	Mon, 11 Dec 2023 18:30:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QiZhxTKY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D7EFEC433C7;
	Mon, 11 Dec 2023 18:30:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1702319413;
	bh=jyMJ0Hu05EwS7pJCyCZIwEXwocHBASW9gryiD3QMS3g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QiZhxTKYy5YUTCPxGT2bf+ghc6Ow559F4p5ruKivUNqHjIjejelj2IbExmWun7kH5
	 aGknQ05Ai1TtNaGJyLvbeHLHwFiOEkFpAVG93pTUaj4V8zc0pm2WABn2MV0e3ZRlcP
	 5GDIGeKXYlM3IyrDvL8cDqRNpVrBfU3/l2mlpBf4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexander Stein <alexander.stein@ew.tq-group.com>,
	Shawn Guo <shawnguo@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 095/244] arm64: dt: imx93: tqma9352-mba93xxla: Fix LPUART2 pad config
Date: Mon, 11 Dec 2023 19:19:48 +0100
Message-ID: <20231211182050.034130961@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231211182045.784881756@linuxfoundation.org>
References: <20231211182045.784881756@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alexander Stein <alexander.stein@ew.tq-group.com>

[ Upstream commit 2bfba37b3d90d6d2d499d5b0dfe99c05c38b1b54 ]

LPUART2_RTS# has an external pull-down, so do not enable the internal
pull-up at the same time, use a pull-down instead.

Fixes: c982ecfa7992a ("arm64: dts: freescale: add initial device tree for MBa93xxLA SBC board")
Signed-off-by: Alexander Stein <alexander.stein@ew.tq-group.com>
Signed-off-by: Shawn Guo <shawnguo@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/freescale/imx93-tqma9352-mba93xxla.dts | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/freescale/imx93-tqma9352-mba93xxla.dts b/arch/arm64/boot/dts/freescale/imx93-tqma9352-mba93xxla.dts
index f06139bdff97e..3c5c67ebee5d3 100644
--- a/arch/arm64/boot/dts/freescale/imx93-tqma9352-mba93xxla.dts
+++ b/arch/arm64/boot/dts/freescale/imx93-tqma9352-mba93xxla.dts
@@ -577,7 +577,7 @@
 		fsl,pins = <
 			MX93_PAD_UART2_TXD__LPUART2_TX		0x31e
 			MX93_PAD_UART2_RXD__LPUART2_RX		0x31e
-			MX93_PAD_SAI1_TXD0__LPUART2_RTS_B	0x31e
+			MX93_PAD_SAI1_TXD0__LPUART2_RTS_B	0x51e
 		>;
 	};
 
-- 
2.42.0



