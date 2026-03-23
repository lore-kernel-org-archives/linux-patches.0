Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C6201387563;
	Mon, 23 Mar 2026 14:06:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774274807; cv=none; b=pBeEBM9PR5n2BIWSZoskhOizauHMjMNH5uW+Js9GUwQXrbB0FVGXsss7WHm0o8e19kMui7L0ea4Yx+axiSZDXPAw1vZYB8BmL0sqSdZzMW3wp42WOrX80GJVRDtNR9q5gdgD5gV2bMQ3If9PfrYbG29WfCEc0c2c4MDfNn4/WBY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774274807; c=relaxed/simple;
	bh=NHDZO5dJYU0mMWz/itVtQwLFWFWVz9NSmaahRgh26Kg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DahVnDqcNW871tDIpd7EHu8FB/3eeSlW+e6fWdejtsJhg4kopCDvKk0otuK3kyzsMdOTGOIyGqitMmc01/psxeubhZgCN+qas57MP/uehPWXwxZEY3U/mAyl7yxczW2ZpU+vZKgtJiS7g5Nm99kP+k+iv1QUobTzNm70ybOFDqU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=njNC9ikb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="njNC9ikb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5710CC4CEF7;
	Mon, 23 Mar 2026 14:06:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774274807;
	bh=NHDZO5dJYU0mMWz/itVtQwLFWFWVz9NSmaahRgh26Kg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=njNC9ikbZkzj8UQTysjrssqQUALAdjX8rNtZ2RI9rcymQGJDeC43YtCtTjS1LZ41W
	 D+wgoi75W5r7rXLeqyDRPNLIvR0nZlfa93Cs4uBNcrOklsrCoV9PMFdBNYLWfmrlB5
	 fVKg8CS6J7dlN9Pd4j1OFyMo/QSx7SXlx5s66v24=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ovidiu Panait <ovidiu.panait.rb@renesas.com>,
	Geert Uytterhoeven <geert+renesas@glider.be>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 114/212] arm64: dts: renesas: r9a09g057: Add RTC node
Date: Mon, 23 Mar 2026 14:45:35 +0100
Message-ID: <20260323134507.379115286@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260323134503.770111826@linuxfoundation.org>
References: <20260323134503.770111826@linuxfoundation.org>
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

From: Ovidiu Panait <ovidiu.panait.rb@renesas.com>

[ Upstream commit cfc733da4e79018f88d8ac5f3a5306abbba8ef89 ]

Add RTC node to Renesas RZ/V2H ("R9A09G057") SoC DTSI.

Signed-off-by: Ovidiu Panait <ovidiu.panait.rb@renesas.com>
Reviewed-by: Geert Uytterhoeven <geert+renesas@glider.be>
Link: https://patch.msgid.link/20251107210706.45044-4-ovidiu.panait.rb@renesas.com
Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
Stable-dep-of: a3f34651de42 ("arm64: dts: renesas: r9a09g057: Remove wdt{0,2,3} nodes")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/renesas/r9a09g057.dtsi | 15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff --git a/arch/arm64/boot/dts/renesas/r9a09g057.dtsi b/arch/arm64/boot/dts/renesas/r9a09g057.dtsi
index 630f7a98df386..f59c3040f536a 100644
--- a/arch/arm64/boot/dts/renesas/r9a09g057.dtsi
+++ b/arch/arm64/boot/dts/renesas/r9a09g057.dtsi
@@ -586,6 +586,21 @@ wdt3: watchdog@13000400 {
 			status = "disabled";
 		};
 
+		rtc: rtc@11c00800 {
+			compatible = "renesas,r9a09g057-rtca3", "renesas,rz-rtca3";
+			reg = <0 0x11c00800 0 0x400>;
+			interrupts = <GIC_SPI 524 IRQ_TYPE_EDGE_RISING>,
+				     <GIC_SPI 525 IRQ_TYPE_EDGE_RISING>,
+				     <GIC_SPI 526 IRQ_TYPE_EDGE_RISING>;
+			interrupt-names = "alarm", "period", "carry";
+			clocks = <&cpg CPG_MOD 0x53>, <&rtxin_clk>;
+			clock-names = "bus", "counter";
+			power-domains = <&cpg>;
+			resets = <&cpg 0x79>, <&cpg 0x7a>;
+			reset-names = "rtc", "rtest";
+			status = "disabled";
+		};
+
 		scif: serial@11c01400 {
 			compatible = "renesas,scif-r9a09g057";
 			reg = <0 0x11c01400 0 0x400>;
-- 
2.51.0



