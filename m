Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1247326E6F4;
	Fri, 21 Nov 2025 13:20:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763731256; cv=none; b=qFKzaJzhA/N+DYnC/mwmE+rLhtgzV6CHyuu/jsYYfqxtBTywOMjIwu9boV8EV/L5wMm0HoqLQAYYWkZ4fN6ABTrlC+0Uz4LJhmHE6Eng1Hw3QQ39kwYOC82tOL23Fm5hiWJFFoqdlhjxys1N3pONjy7tTL1G5KH86x8wnW4guX8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763731256; c=relaxed/simple;
	bh=k0Eybc8zhrSha0FAXrEtxOvAio5BhaAsOKWrUMHtxpk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WKNipzsvGJZPfW5/IrmxSqOjtWTSKc+3WRx7vc/C60NolLz52MHmn2pFotKP8DNHywOFv7BdDF1SvGbIqvlPlXkPSR1Mebe6/bBaoDJrinerMdAk+PqLkhtPhA4FPuxTo2Ec6cxPHQdCtlTdYD0mE0WRIoG1oavZWE+51e+uQxY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bfiiYAha; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bfiiYAha"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 87B88C4CEF1;
	Fri, 21 Nov 2025 13:20:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1763731255;
	bh=k0Eybc8zhrSha0FAXrEtxOvAio5BhaAsOKWrUMHtxpk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bfiiYAhaA+XzqIz5knlmnywCgWoamFSKgByjUmGqpDNbWJipM6Ah0Bgfw+GF/9eQA
	 6LXRBy+604YvpCZe19QMADzcOBACmIqCDtgPmIuA5i6K9mk06WQKQVrmngBqaDBJZl
	 hA8ttHpxnYdWmF0TQSm6UQ7KZ3Ja4cLHmAwssXWg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andrey Leonchikov <andreil499@gmail.com>,
	Heiko Stuebner <heiko@sntech.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 144/247] arm64: dts: rockchip: Fix USB power enable pin for BTT CB2 and Pi2
Date: Fri, 21 Nov 2025 14:11:31 +0100
Message-ID: <20251121130159.893191127@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251121130154.587656062@linuxfoundation.org>
References: <20251121130154.587656062@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andrey Leonchikov <andreil499@gmail.com>

[ Upstream commit a59e927ff46a967f84ddf94e89cbb045810e8974 ]

 Fix typo into regulator GPIO definition. With current
 definition - USB powered off. Valid definition can be found on "pinctrl"
 section:
 		vcc5v0_usb2t_en: vcc5v0-usb2t-en {
 				rockchip,pins = <3 RK_PD5 RK_FUNC_GPIO &pcfg_pull_none>;
 				 		};

 		vcc5v0_usb2b_en: vcc5v0-usb2b-en {
 			rockchip,pins = <4 RK_PC4 RK_FUNC_GPIO &pcfg_pull_none>;
 		};

Fixes: bfbc663d2733a ("arm64: dts: rockchip: Add BigTreeTech CB2 and Pi2")
Signed-off-by: Andrey Leonchikov <andreil499@gmail.com>
Link: https://patch.msgid.link/20251105210741.850031-1-andreil499@gmail.com
Signed-off-by: Heiko Stuebner <heiko@sntech.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/rockchip/rk3566-bigtreetech-cb2.dtsi | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/boot/dts/rockchip/rk3566-bigtreetech-cb2.dtsi b/arch/arm64/boot/dts/rockchip/rk3566-bigtreetech-cb2.dtsi
index f74590af7e33f..b6cf03a7ba66b 100644
--- a/arch/arm64/boot/dts/rockchip/rk3566-bigtreetech-cb2.dtsi
+++ b/arch/arm64/boot/dts/rockchip/rk3566-bigtreetech-cb2.dtsi
@@ -187,7 +187,7 @@
 	vcc5v0_usb2b: regulator-vcc5v0-usb2b {
 		compatible = "regulator-fixed";
 		enable-active-high;
-		gpio = <&gpio0 RK_PC4 GPIO_ACTIVE_HIGH>;
+		gpio = <&gpio4 RK_PC4 GPIO_ACTIVE_HIGH>;
 		pinctrl-names = "default";
 		pinctrl-0 = <&vcc5v0_usb2b_en>;
 		regulator-name = "vcc5v0_usb2b";
@@ -199,7 +199,7 @@
 	vcc5v0_usb2t: regulator-vcc5v0-usb2t {
 		compatible = "regulator-fixed";
 		enable-active-high;
-		gpios = <&gpio0 RK_PD5 GPIO_ACTIVE_HIGH>;
+		gpios = <&gpio3 RK_PD5 GPIO_ACTIVE_HIGH>;
 		pinctrl-names = "default";
 		pinctrl-0 = <&vcc5v0_usb2t_en>;
 		regulator-name = "vcc5v0_usb2t";
-- 
2.51.0



