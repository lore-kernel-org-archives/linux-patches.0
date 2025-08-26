Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E9FE7228C9D;
	Tue, 26 Aug 2025 13:04:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756213462; cv=none; b=NbIQuLJci4r67ohrkZI059kUKsAmPn+ZVSj67M5PyKv+Kw7J04H10oRFsyU+iGphF+z1SSNEvQBktmyk9B0cbnv/lQhj/hRgAMGo3sdcB3W/W5y5opvZqcAALZG+z04gha0b0sjbTZ3D6PRlvBK6XzP/mL7Twx6ttOJk6zwyGeg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756213462; c=relaxed/simple;
	bh=6XCM0+mn+HS/v1h94Lka7prg7LkItFW59lXGcNQJVnY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ib4Ij5o170WLhVyPf1p5YnDEtbfqjwn7/EPFRi4QxSs5M5Z8KOJlu+5o5fsLZJGKQMVwd6+L59jHaHbZMbsdYIDLFeWs/QCa8yfqZV/kYchw+6p5Gz5Hz4+4zYQDGa1GA+YqeijSxikS4sEzzcxPwhnvjwkpG4jE2zyu4CN7bK0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AcKUEoFw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AcKUEoFw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1A27EC4CEF1;
	Tue, 26 Aug 2025 13:04:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756213461;
	bh=6XCM0+mn+HS/v1h94Lka7prg7LkItFW59lXGcNQJVnY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AcKUEoFwTTY2+v/3ZWM6YiFN6YIZvb0HMhcBgUI7kcM0MlVBTsuQjlWhupveNxKFK
	 EM7vrxtonQIMbDWmxAG5w9+WHHrBAAK0+fCp6sn+CmyNrC+PbgfLbuRgQ4gjT9jtSn
	 HH9NsREqgFBAbneZHm37Fc10IJ0eooKuKvaV5Uqw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hong Guan <hguan@ti.com>,
	Bryan Brattlof <bb@ti.com>,
	Vignesh Raghavendra <vigneshr@ti.com>
Subject: [PATCH 6.6 356/587] arm64: dts: ti: k3-am62a7-sk: fix pinmux for main_uart1
Date: Tue, 26 Aug 2025 13:08:25 +0200
Message-ID: <20250826111001.968811166@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110952.942403671@linuxfoundation.org>
References: <20250826110952.942403671@linuxfoundation.org>
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

From: Hong Guan <hguan@ti.com>

commit 8e44ac61abaae56fc6eb537a04ed78b458c5b984 upstream.

main_uart1 reserved for TIFS firmware traces is routed to the
onboard FT4232 via a FET switch which is connected to pin A21 and
B21 of the SoC and not E17 and C17. Fix it.

Fixes: cf39ff15cc01a ("arm64: dts: ti: k3-am62a7-sk: Describe main_uart1 and wkup_uart")
Cc: stable@vger.kernel.org
Signed-off-by: Hong Guan <hguan@ti.com>
[bb@ti.com: expanded commit message]
Signed-off-by: Bryan Brattlof <bb@ti.com>
Link: https://lore.kernel.org/r/20250707-uart-fixes-v1-1-8164147218b0@ti.com
Signed-off-by: Vignesh Raghavendra <vigneshr@ti.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/boot/dts/ti/k3-am62a7-sk.dts |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/arch/arm64/boot/dts/ti/k3-am62a7-sk.dts
+++ b/arch/arm64/boot/dts/ti/k3-am62a7-sk.dts
@@ -144,8 +144,8 @@
 
 	main_uart1_pins_default: main-uart1-default-pins {
 		pinctrl-single,pins = <
-			AM62AX_IOPAD(0x01e8, PIN_INPUT, 1) /* (C17) I2C1_SCL.UART1_RXD */
-			AM62AX_IOPAD(0x01ec, PIN_OUTPUT, 1) /* (E17) I2C1_SDA.UART1_TXD */
+			AM62AX_IOPAD(0x01ac, PIN_INPUT, 2) /* (B21) MCASP0_AFSR.UART1_RXD */
+			AM62AX_IOPAD(0x01b0, PIN_OUTPUT, 2) /* (A21) MCASP0_ACLKR.UART1_TXD */
 			AM62AX_IOPAD(0x0194, PIN_INPUT, 2) /* (C19) MCASP0_AXR3.UART1_CTSn */
 			AM62AX_IOPAD(0x0198, PIN_OUTPUT, 2) /* (B19) MCASP0_AXR2.UART1_RTSn */
 		>;


