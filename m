Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2786214C580;
	Tue, 23 Jan 2024 00:21:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705969269; cv=none; b=OVkyKhHwI/KME6/2lMeJVQFI19f4j2ZOAp6pmge9IrjtetjhOVGaapV+glxDWG4jn8aRWWGnT+ni/fK5TLRD6KaN34Uh/SmOcR8QCDSb4ycpm87xImcjFuWWo8rsVuR82QS7H6ZtGBrb8su3Y9E0aO+EPi1cYo+JO+ndPx+5uEo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705969269; c=relaxed/simple;
	bh=6Mpd4A2YYJzyotehXnNfCnfpRQRWMz8EQP8PEBPG7VQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KJdCUxOTvrY9udAUvlSEIs7VwqFiX8WF1cLsDyS5R8FMGlaB0dHYcgUUuzmuN1nUkaEk2Bl6oUKowH7YxO+CKiMU4OvN+yB76SEOocGdlJRLiNbuiYPwsrQiVkFXPZ2t26qK9EtYl/Kgjr9wn2zf2UkVmHwy/A9pf/5EYE3nh5g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=F/F6gbRx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="F/F6gbRx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DAABAC43399;
	Tue, 23 Jan 2024 00:21:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705969269;
	bh=6Mpd4A2YYJzyotehXnNfCnfpRQRWMz8EQP8PEBPG7VQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=F/F6gbRx4lwJWgN/xKa10Uth8EruH4QxvZCnQmigtfh1w5B7Vl81/5p0Vr6t33YJS
	 TA8KnlZPfOVn2zUAhLPR8qGQHJJjMAXZMCsVf8p1RkqzpcNASBh8WuIBeMpHoSriah
	 SbtQTfXI/UZ0/01hMTU6FbWpN4us2T2MFVew6ZZU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nitin Yadav <n-yadav@ti.com>,
	Nishanth Menon <nm@ti.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 110/641] arm64: dts: ti: k3-am62a-main: Fix GPIO pin count in DT nodes
Date: Mon, 22 Jan 2024 15:50:14 -0800
Message-ID: <20240122235821.482230575@linuxfoundation.org>
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

From: Nitin Yadav <n-yadav@ti.com>

[ Upstream commit 7dc4af358cc382c5d20bd5b726e53ef0f526eb6d ]

Fix number of gpio pins in main_gpio0 & main_gpio1 DT nodes according
to AM62A7 datasheet[0].

[0] https://www.ti.com/lit/gpn/am62a3 Section: 6.3.10 GPIO (Page No. 52-55)
Fixes: 5fc6b1b62639 ("arm64: dts: ti: Introduce AM62A7 family of SoCs")
Signed-off-by: Nitin Yadav <n-yadav@ti.com>
Link: https://lore.kernel.org/r/20231027065930.1187405-1-n-yadav@ti.com
Signed-off-by: Nishanth Menon <nm@ti.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/ti/k3-am62a-main.dtsi | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/boot/dts/ti/k3-am62a-main.dtsi b/arch/arm64/boot/dts/ti/k3-am62a-main.dtsi
index 4ae7fdc5221b..ccd708b09acd 100644
--- a/arch/arm64/boot/dts/ti/k3-am62a-main.dtsi
+++ b/arch/arm64/boot/dts/ti/k3-am62a-main.dtsi
@@ -462,7 +462,7 @@ main_gpio0: gpio@600000 {
 			     <193>, <194>, <195>;
 		interrupt-controller;
 		#interrupt-cells = <2>;
-		ti,ngpio = <87>;
+		ti,ngpio = <92>;
 		ti,davinci-gpio-unbanked = <0>;
 		power-domains = <&k3_pds 77 TI_SCI_PD_EXCLUSIVE>;
 		clocks = <&k3_clks 77 0>;
@@ -480,7 +480,7 @@ main_gpio1: gpio@601000 {
 			     <183>, <184>, <185>;
 		interrupt-controller;
 		#interrupt-cells = <2>;
-		ti,ngpio = <88>;
+		ti,ngpio = <52>;
 		ti,davinci-gpio-unbanked = <0>;
 		power-domains = <&k3_pds 78 TI_SCI_PD_EXCLUSIVE>;
 		clocks = <&k3_clks 78 0>;
-- 
2.43.0



