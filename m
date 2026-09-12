Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F0950246BCD;
	Sat, 12 Sep 2026 10:09:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789207762; cv=none; b=AyUq+Wb87PZlblFavrCZWEmXzjAa8bHetgbCUxf5Lb4Vr13Bqcf21PwXIOYotK/1xUlV6huI7yIgMyJdnKyfFbyNSIgoAmZ2WSF19ZfCTxyXCeyMm2Q+QXbORj7GT+XAClZ6oEKFNt79vEO4kcocyIVJ6vtCuBEpwad76ov8HRc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789207762; c=relaxed/simple;
	bh=1NTe9RtGZlDUY+BLExp489EtfT179R5UCkEnViPLbpw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EM4QI3DvB1mF0e4qD7N17LI0Y3p5NhU7HHOYsbGsI66d27VOmVgV9b4/aTIH5sJEbKLsIYbVPGCbG/Ctpyzd5zQZrhArWdsBq5+5R3xL2W3N/31ayENtD9HhyqxrEmdKvjoXIgTJc3akD3h5zUxKxem22w8TRa/NhDdwtUpu1PI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CdnksZ5n; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CdnksZ5n"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 002D11F000FF;
	Sat, 12 Sep 2026 10:09:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789207760;
	bh=8UmqrFYovWBhleISSicF0wkx+79xgcHF9yoN08ObmLU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=CdnksZ5nmINk66EKjEaCabtGx7RUNXTw7bT/DtXQ/7M21ujadok4FB6wQk8GL22pQ
	 62wCE7T2/pSI/M3nSu36B1OT3rQ7uJXrT/1cEBStRwid0XkJJ2INrbQm4XAkKuQ0Qr
	 Can2PqmLU6mlMKKUP6rC5vKpDHctETmkES+OWPdI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jun Yan <jerrysteve1101@gmail.com>,
	Martin Blumenstingl <martin.blumenstingl@googlemail.com>,
	Neil Armstrong <neil.armstrong@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0479/1518] arm64: dts: amlogic: meson-axg: Add missing nand_rb0 pin to nand_all_pins
Date: Sat, 12 Sep 2026 08:44:08 +0200
Message-ID: <20260912065634.283189736@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065623.398859879@linuxfoundation.org>
References: <20260912065623.398859879@linuxfoundation.org>
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

From: Jun Yan <jerrysteve1101@gmail.com>

[ Upstream commit 45eb76f9ab6854f79690d56d04df227429a536b8 ]

The nand_all_pins pinctrl node was missing the nand_rb0 (ready/busy)
pin description, which is required for NAND controller operation.

Add it to the pinmux list.

Fixes: be18d53c32b2 ("arm64: dts: amlogic: meson-axg: pinctrl node for NAND")
Signed-off-by: Jun Yan <jerrysteve1101@gmail.com>
Reviewed-by: Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Link: https://patch.msgid.link/20260624135650.727077-3-jerrysteve1101@gmail.com
Signed-off-by: Neil Armstrong <neil.armstrong@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/amlogic/meson-axg.dtsi | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/amlogic/meson-axg.dtsi b/arch/arm64/boot/dts/amlogic/meson-axg.dtsi
index 3058b60338dbf..e9c1aae95fe7c 100644
--- a/arch/arm64/boot/dts/amlogic/meson-axg.dtsi
+++ b/arch/arm64/boot/dts/amlogic/meson-axg.dtsi
@@ -481,7 +481,8 @@ mux {
 							 "nand_ale",
 							 "nand_cle",
 							 "nand_wen_clk",
-							 "nand_ren_wr";
+							 "nand_ren_wr",
+							 "nand_rb0";
 						function = "nand";
 						input-enable;
 						bias-pull-up;
-- 
2.53.0



