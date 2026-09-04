Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8CA9630C366;
	Fri,  4 Sep 2026 05:52:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788501162; cv=none; b=WAYLIBv9qK32bGECOqIjpAXTVJZhiuHRXwAwFpUmhmvmJOPSLMnrhnO1nr4ealSCCD5VBnLm8eO52EpK7lOUp/nzMLUv39jH+Idjqyyh7dxhjd4S8rrtzuWphXsqw4WbxI3b6wLdTRxZbxnhEFl3/KJXkyZA0OPQSGP+TRukxag=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788501162; c=relaxed/simple;
	bh=HXXmLYklfulRZUlzemz05opF/ZgoOavKIR6SJPEhiLs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CLFEybtkVpdoD0lNjLCR9gvyzbPNdMK9LLvN4qEY8oZZ3WCkzSserFp6F7lma+tRn1XyuxfP9Fd8s8ErK5yhtjyRJIFPHiska5lv6Y0142x1DeXK9noZ608aPx5CYRuH8ZxUhgWsvFOP/QxrOGIbcJD8XMm8jSs32wVjpnmlrJM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0V10P7uY; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0V10P7uY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E58731F00A3D;
	Fri,  4 Sep 2026 05:52:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788501161;
	bh=0xyMBnRcuIkP0+LxolUISpTBOokdYmGrScARLxcWUoA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=0V10P7uYiPP79pzH1wTW4xAXNki3/fr5C4Md9nsZLlQKjptrvoHkDnXqSoVTcVvIf
	 jKGJRdflMgYSWKp6PYwyOFCnqKvS1gXkOkmxdsjqV/IfR6Wtzk+BsMYhoS9KSmtopR
	 Mr468Fkn9OQdQwxopZFh8+eD/TTBieIPeVYxkO7U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jakob Unterwurzacher <jakob.unterwurzacher@cherry.de>,
	Quentin Schulz <quentin.schulz@cherry.de>,
	Heiko Stuebner <heiko@sntech.de>
Subject: [PATCH 6.18 313/552] arm64: dts: rockchip: fix emmc reset polarity on px30-cobra
Date: Fri,  4 Sep 2026 06:57:50 +0200
Message-ID: <20260904045757.377267734@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260904045747.813364717@linuxfoundation.org>
References: <20260904045747.813364717@linuxfoundation.org>
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

From: Jakob Unterwurzacher <jakob.unterwurzacher@cherry.de>

commit 85babf47515e2adf266dcc3be9804e31f752083e upstream.

Technically, the reset signal is active low - it's called RST_n after all.

But it is ignored completely unless RST_n_FUNCTION=1 (byte 162 in extcsd)
is set in the emmc. It is 0 per default.

For emmcs that have RST_n_FUNCTION=1 we failed like this:

	[    3.074480] mmc1: Failed to initialize a non-removable card

With this change they work normally.

Cc: stable@vger.kernel.org
Fixes: bb510ddc9d3e ("arm64: dts: rockchip: add px30-cobra base dtsi and board variants")
Signed-off-by: Jakob Unterwurzacher <jakob.unterwurzacher@cherry.de>
Tested-by: Quentin Schulz <quentin.schulz@cherry.de>
Reviewed-by: Quentin Schulz <quentin.schulz@cherry.de>
Link: https://patch.msgid.link/20260609081728.30616-2-jakobunt@gmail.com
Signed-off-by: Heiko Stuebner <heiko@sntech.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/boot/dts/rockchip/px30-cobra.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/rockchip/px30-cobra.dtsi b/arch/arm64/boot/dts/rockchip/px30-cobra.dtsi
index add917af5de7..f14f9eca7d34 100644
--- a/arch/arm64/boot/dts/rockchip/px30-cobra.dtsi
+++ b/arch/arm64/boot/dts/rockchip/px30-cobra.dtsi
@@ -35,7 +35,7 @@ emmc_pwrseq: emmc-pwrseq {
 		compatible = "mmc-pwrseq-emmc";
 		pinctrl-0 = <&emmc_reset>;
 		pinctrl-names = "default";
-		reset-gpios = <&gpio1 RK_PB3 GPIO_ACTIVE_HIGH>;
+		reset-gpios = <&gpio1 RK_PB3 GPIO_ACTIVE_LOW>;
 	};
 
 	gpio-leds {
-- 
2.55.0



