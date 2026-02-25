Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A2CD622579E;
	Wed, 25 Feb 2026 01:30:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771983045; cv=none; b=IDY0Rw5Mj2+xie4ITt7+Rs8alMUyK+TBOYTCVliycC0WELNl8eGX6dWz2LJBy2ZlzfWTZjULjROUc94btgwiqB5vHOfY70DuqCjXF08Kw1ebutQjza+KvxUJd2cHADKZdgOCmERRpbkGxAhoNcJDRNS6FDb3ZqJbLDCgP0kkgdk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771983045; c=relaxed/simple;
	bh=trZMgoeVNuIjrEIYRDR5K6jxZrTbErq8tZ2XEcHYhug=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SqqVQve16iyoK79BauVH+3IehbqtK1HYQvhWseXgvzc7b5DoX3l7S8wkoj+R+9cbn/o9657G08pRauuWWpuoLuFkeoM01qnhQuPqjPyv98aL49wfenb7yfJRetRHSXQMxk193GbAnZdkR2FgbGsxjHA3Qt/2de3p/ARadwKb2uM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iDSYj27g; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iDSYj27g"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 638A2C116D0;
	Wed, 25 Feb 2026 01:30:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1771983045;
	bh=trZMgoeVNuIjrEIYRDR5K6jxZrTbErq8tZ2XEcHYhug=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iDSYj27gsWZSm+rp67LmTWQ+ui+5C7sG2rCq/uz8mtZ+gPOZh68mV1wZxVQm9DvZJ
	 SOG3QWeft/TBgKaDYqpplNiZsL6VQBLv8+DrZM4NORfE7n1GZbQQIRI6cOsSjhyJGf
	 WxTccCHlDkUFjpAdIaSZJoRb89F7zQrbt9vYQIPM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>,
	Geert Uytterhoeven <geert+renesas@glider.be>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 166/781] arm64: dts: renesas: rzt2h-n2h-evk-common: Use GPIO for SD0 write protect
Date: Tue, 24 Feb 2026 17:14:35 -0800
Message-ID: <20260225012403.720766622@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260225012359.695468795@linuxfoundation.org>
References: <20260225012359.695468795@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>

[ Upstream commit a1b1ee0348f889ec262482e16e9ff670617db7b0 ]

Switch SD0 write-protect detection to a GPIO on the RZ/T2H and RZ/N2H
EVKs. Both boards use a full-size SD card slot on the SD0 channel with
a dedicated WP pin.

The RZ/T2H and RZ/N2H SoCs use of_data_rcar_gen3, which sets
MMC_CAP2_NO_WRITE_PROTECT and causes the core to ignore the WP signal
unless a wp-gpios property is provided. Describe the WP pin as a GPIO
to allow the MMC core to evaluate the write-protect status correctly.

Fixes: d065453e5ee0 ("arm64: dts: renesas: rzt2h-rzn2h-evk: Enable SD card slot")
Signed-off-by: Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>
Reviewed-by: Geert Uytterhoeven <geert+renesas@glider.be>
Link: https://patch.msgid.link/20260106131319.643084-1-prabhakar.mahadev-lad.rj@bp.renesas.com
Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/renesas/rzt2h-n2h-evk-common.dtsi | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/boot/dts/renesas/rzt2h-n2h-evk-common.dtsi b/arch/arm64/boot/dts/renesas/rzt2h-n2h-evk-common.dtsi
index 3eed1f3948e8e..63bd91690b540 100644
--- a/arch/arm64/boot/dts/renesas/rzt2h-n2h-evk-common.dtsi
+++ b/arch/arm64/boot/dts/renesas/rzt2h-n2h-evk-common.dtsi
@@ -224,8 +224,7 @@ data-pins {
 		ctrl-pins {
 			pinmux = <RZT2H_PORT_PINMUX(12, 0, 0x29)>, /* SD0_CLK */
 				 <RZT2H_PORT_PINMUX(12, 1, 0x29)>, /* SD0_CMD */
-				 <RZT2H_PORT_PINMUX(22, 5, 0x29)>, /* SD0_CD */
-				 <RZT2H_PORT_PINMUX(22, 6, 0x29)>; /* SD0_WP */
+				 <RZT2H_PORT_PINMUX(22, 5, 0x29)>; /* SD0_CD */
 		};
 	};
 
@@ -282,6 +281,7 @@ &sdhi0 {
 	pinctrl-names = "default", "state_uhs";
 	vmmc-supply = <&reg_3p3v>;
 	vqmmc-supply = <&vqmmc_sdhi0>;
+	wp-gpios = <&pinctrl RZT2H_GPIO(22, 6) GPIO_ACTIVE_HIGH>;
 	bus-width = <4>;
 	sd-uhs-sdr50;
 	sd-uhs-sdr104;
-- 
2.51.0



