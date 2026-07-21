Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 79C4A46D562;
	Tue, 21 Jul 2026 18:25:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784658355; cv=none; b=WuxwqIiuImSYEZx+GDNSvGxW/5MbCxa5tTe+2r199BQXMwC3rl8p9Llj98BphadlQY7ShXnu6tXg/l8QZB9zCpL/V9iG3R9jeu8TwPF9tYqhaQnt9HWprmSErmAzOJPbQZQyTm52TltHPDeXYFPtTbJ0o9YSC23wvmx5WP5FyVk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784658355; c=relaxed/simple;
	bh=Rlzj/czyxHkC7qQaDHDHmK2/qvKF7gJ7gM2q3QxjPOQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZYEaNI6GGnkwFRjRxWgA1GEL0AiTCwpL9mVRI3tp7W553fioW64l8ltzQEx45KHpiDH2tOM+qJaDeuNZoxpiuM1sRbtFDxEnx90n8dkf1+Cd30YHgfJGpzvWyQWu44sb7f0oBH6Ydq9oiYqIYIZyk1ZU93mkpZssh3loYLNXQfw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LdUegSRH; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LdUegSRH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E019A1F000E9;
	Tue, 21 Jul 2026 18:25:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784658354;
	bh=JQvQrZ2krYBFikyP5d9QEjJE+uL1FbvsQIvX10hw5mE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=LdUegSRHHI1Sd6SDWijQ2GNd+Vg/bj2Az7ZDF761Y6lUC+njpJJHFCw1Z78lfVc8g
	 hiE12YWccGStvWQFkk3oWAkpPxqt58SXhK/opcGSJgdxN0uYL1IFSHbjVeDV/7WXzX
	 9lL18F/2SF+6Lf9vipnzjYMHdOnFA8CtpNzuL2Sc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>,
	Daniel Lezcano <daniel.lezcano@oss.qualcomm.com>,
	Frank Li <Frank.Li@nxp.com>
Subject: [PATCH 6.18 1110/1611] arm64: dts: s32g3: Fix SWT8 watchdog address
Date: Tue, 21 Jul 2026 17:20:26 +0200
Message-ID: <20260721152540.381062122@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152514.750365251@linuxfoundation.org>
References: <20260721152514.750365251@linuxfoundation.org>
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

From: Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>

commit 65210e81f7837a871a17237d15e4b1191d5e8771 upstream.

Add missing hex annotation to fix the SWT8 watchdog address in 'reg'
property, as reported by dtc W=1:

  s32g3.dtsi:863.27-869.5: Warning (simple_bus_reg): /soc@0/watchdog@40500000: simple-bus unit address format error, expected "269fb20"

Lack of hex '0x' meant address would be interpreted as decimal thus
completely different value used as this device MMIO.  If device was
enabled this could lead to corruption of other device address space and
broken boot.

Cc: stable@vger.kernel.org
Fixes: 6db84f042745 ("arm64: dts: s32g3: Add the Software Timer Watchdog (SWT) nodes")
Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>
Reviewed-by: Daniel Lezcano <daniel.lezcano@oss.qualcomm.com>
Signed-off-by: Frank Li <Frank.Li@nxp.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/boot/dts/freescale/s32g3.dtsi |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/arm64/boot/dts/freescale/s32g3.dtsi
+++ b/arch/arm64/boot/dts/freescale/s32g3.dtsi
@@ -806,7 +806,7 @@
 
 		swt8: watchdog@40500000 {
 			compatible = "nxp,s32g3-swt", "nxp,s32g2-swt";
-			reg = <40500000 0x1000>;
+			reg = <0x40500000 0x1000>;
 			clocks = <&clks 0x3a>, <&clks 0x3b>, <&clks 0x3b>;
 			clock-names = "counter", "module", "register";
 			status = "disabled";


