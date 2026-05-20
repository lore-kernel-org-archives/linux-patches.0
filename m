Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 358E936CE19;
	Wed, 20 May 2026 18:12:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779300755; cv=none; b=iIIpfcWbgGlbHrvXyI1Kh6iH37H354ZealeZEbpt4LImgSrGVPTy3RtUrczBCsIlXI0loC+gU8HhvdRU4oBq/EumT5jzf6i7PrvTh8l/UhY8CP1mtSbnCBB6Heen7D4If8zJPa8yCYXvpvSv5WGvGPpfRjm+0GDiQ/QSH22y4KY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779300755; c=relaxed/simple;
	bh=+wuQHm7Ot3k+irWzj5NL3ZgJnkw91VnhTUP50GYubd8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uLzv8/rOFelxYbLEzerEeeRIKsp7jLy+crtuM1ObugtotiUoAzQ5O9s1CPsfzJoPkwj7qrAtC6olKQm3v4KysiGviG1wS+WC/gulPw5Wuw79teVAYhwYZLkggweNKkiVT0hQq2M2Wn2OOQr1dbkt/uQCHLYMlaeqixVFohaZpto=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Kt7O6CnF; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Kt7O6CnF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9A70E1F000E9;
	Wed, 20 May 2026 18:12:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779300754;
	bh=ud1nUya5nmCkRz3O86WnYULn2lYVnYUfeOnndRcSwNM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Kt7O6CnFJM8RlaBMLIrrHv4xpp7rZKHi024SfewYq9hImondmHCkuYKLCETplsl20
	 7B2A+NS539k6jsqvjYs52L1th0Ob14o4v3X5e4Q10Iho7DIBw76vHvo+zbVVxq1fdm
	 K9FOFEQJPpI040Rpe9eGhlRuVQ+W7cMY1VzSLevc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Judith Mendez <jm@ti.com>,
	Moteen Shah <m-shah@ti.com>,
	Vignesh Raghavendra <vigneshr@ti.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 293/666] arm64: dts: ti: k3-am62p5-sk: Disable MMC1 internal pulls on data pins
Date: Wed, 20 May 2026 18:18:24 +0200
Message-ID: <20260520162117.566440986@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162111.222830634@linuxfoundation.org>
References: <20260520162111.222830634@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Judith Mendez <jm@ti.com>

[ Upstream commit 6d4441be969bea89bb9702781f5dfb3a8f2a02a4 ]

AM62P SK has external 10K pullups on MMC1 DAT1-DAT3 pins [0].
Disable internal pullups on DAT1-DAT3 so that each line has a
single pullup source:
- with both pullups enabled, the effective parallel resistance on
  DAT1-3 (~8.33K) drops below the 10K minimum pullup requirement
  for data lines (per SD Physical Layer Specification)
- removing internal pullups makes DAT1-3 match DAT0 10K
  external pullup so its consistent and within spec
- both internal and external pullups enabled equals unnecessary power
  consumption

[0] https://www.ti.com/lit/zip/SPRR487

Fixes: c00504ea42c0 ("arm64: dts: ti: k3-am62p5-sk: Updates for SK EVM")
Signed-off-by: Judith Mendez <jm@ti.com>
Reviewed-by: Moteen Shah <m-shah@ti.com>
Link: https://patch.msgid.link/20260223233731.2690472-2-jm@ti.com
Signed-off-by: Vignesh Raghavendra <vigneshr@ti.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/ti/k3-am62p5-sk.dts | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/arm64/boot/dts/ti/k3-am62p5-sk.dts b/arch/arm64/boot/dts/ti/k3-am62p5-sk.dts
index b94093a7a392a..de3a999aab139 100644
--- a/arch/arm64/boot/dts/ti/k3-am62p5-sk.dts
+++ b/arch/arm64/boot/dts/ti/k3-am62p5-sk.dts
@@ -224,9 +224,9 @@ main_mmc1_pins_default: main-mmc1-default-pins {
 			AM62PX_IOPAD(0x023c, PIN_INPUT, 0) /* (H20) MMC1_CMD */
 			AM62PX_IOPAD(0x0234, PIN_OUTPUT, 0) /* (J24) MMC1_CLK */
 			AM62PX_IOPAD(0x0230, PIN_INPUT, 0) /* (H21) MMC1_DAT0 */
-			AM62PX_IOPAD(0x022c, PIN_INPUT_PULLUP, 0) /* (H23) MMC1_DAT1 */
-			AM62PX_IOPAD(0x0228, PIN_INPUT_PULLUP, 0) /* (H22) MMC1_DAT2 */
-			AM62PX_IOPAD(0x0224, PIN_INPUT_PULLUP, 0) /* (H25) MMC1_DAT3 */
+			AM62PX_IOPAD(0x022c, PIN_INPUT, 0) /* (H23) MMC1_DAT1 */
+			AM62PX_IOPAD(0x0228, PIN_INPUT, 0) /* (H22) MMC1_DAT2 */
+			AM62PX_IOPAD(0x0224, PIN_INPUT, 0) /* (H25) MMC1_DAT3 */
 			AM62PX_IOPAD(0x0240, PIN_INPUT, 0) /* (D23) MMC1_SDCD */
 		>;
 		bootph-all;
-- 
2.53.0



