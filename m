Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 855C7134746;
	Tue, 23 Jan 2024 00:22:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705969323; cv=none; b=WzVQfZMt3w/5bOzS1SsGJaQCW7UncnLuBpoMKvw1ntht3iGbDD9cMyDHOSf8qG8cpc/6EwHg3rvZKFn2br3vg4TIDjQl85J8b7LwgE4119qlAvvGpiBqI0ZCROSLsmnvBN1PMmsrqH/tSYQoDkc3VbDoJdTX+FQofQd40/qRckk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705969323; c=relaxed/simple;
	bh=/MrWmlUOxqJFU5xQgb5vuqUi8OFO7RwHdYTXOPtxX3M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LCj5EINpUgV1z+G03kJjt+ZjHRutcrFuSYxKPeY0qYKtQTs3UVqrL2e21vuU9KKjLsAgAl2EuoLnSYrW9HHzEc0fQH6Cu6hfwiDNmiXfBpXcgNurt7dZ8XHn9/JTYTys6JQIX4xtJaxmiURtHDVHRXlPLmCg/pw89VUatVMT5o0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GEKdjK/P; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GEKdjK/P"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2C17FC433B1;
	Tue, 23 Jan 2024 00:22:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705969323;
	bh=/MrWmlUOxqJFU5xQgb5vuqUi8OFO7RwHdYTXOPtxX3M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GEKdjK/PNkKBj4JTEx+lDL9nvMPF2mVZnxEWOVgmcbNykmBzptcervZobpNxADTeg
	 mePAwsbL3xLGfo0IYFOcqe31C50NfLFKmieLWFotRTL0xEWF6H16dX7JO57NtlkPr5
	 7VPp67oTphlYk8UQllvHogbUS9tuEIm2OvthV8ZI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Geert Uytterhoeven <geert+renesas@glider.be>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 173/641] arm64: dts: renesas: white-hawk-cpu: Fix missing serial console pin control
Date: Mon, 22 Jan 2024 15:51:17 -0800
Message-ID: <20240122235823.429505319@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235818.091081209@linuxfoundation.org>
References: <20240122235818.091081209@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Geert Uytterhoeven <geert+renesas@glider.be>

[ Upstream commit fc67495680f60e88bb8ca43421c1dd628928d581 ]

The pin control description for the serial console was added, but not
enabled, due to missing pinctrl properties in the serial port device
node.

Fixes: 7a8d590de8132853 ("arm64: dts: renesas: white-hawk-cpu: Add serial port pin control")
Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
Link: https://lore.kernel.org/r/8a51516581cd71ecbfa174af9c7cebad1fc83c5b.1702459865.git.geert+renesas@glider.be
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/renesas/r8a779g0-white-hawk-cpu.dtsi | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/arch/arm64/boot/dts/renesas/r8a779g0-white-hawk-cpu.dtsi b/arch/arm64/boot/dts/renesas/r8a779g0-white-hawk-cpu.dtsi
index bb4a5270f71b..913f70fe6c5c 100644
--- a/arch/arm64/boot/dts/renesas/r8a779g0-white-hawk-cpu.dtsi
+++ b/arch/arm64/boot/dts/renesas/r8a779g0-white-hawk-cpu.dtsi
@@ -187,6 +187,9 @@ &extalr_clk {
 };
 
 &hscif0 {
+	pinctrl-0 = <&hscif0_pins>;
+	pinctrl-names = "default";
+
 	status = "okay";
 };
 
-- 
2.43.0



