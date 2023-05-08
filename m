Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5FE9B168B4
	for <patches@lists.linux.dev>; Mon,  8 May 2023 09:57:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9BA55C433EF;
	Mon,  8 May 2023 09:57:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1683539823;
	bh=O4vYzXkxzlPVwjlpQlH9UFOWuXvh1cFJar0Ot66WfZU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tL+cj8nMH3TqHMP04AZ5E+kyaWJ2mzFLa4EaO/+FEupq7/9mFIVzQd6YdBqF0jcqw
	 L1agneU/UwPQSy1nnIvUoBQ5x95hXPdJKsN8jvvfnUtsibDOORwo49Ms4h0kLkCgfe
	 bgPLNvaf1llvKZJ+LJFMYfrrM+ewkhPbcxuUrRbE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nitin Yadav <n-yadav@ti.com>,
	Nishanth Menon <nm@ti.com>,
	Bryan Brattlof <bb@ti.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 149/611] arm64: dts: ti: k3-am62-main: Fix GPIO numbers in DT
Date: Mon,  8 May 2023 11:39:51 +0200
Message-Id: <20230508094427.100729063@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230508094421.513073170@linuxfoundation.org>
References: <20230508094421.513073170@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Nitin Yadav <n-yadav@ti.com>

[ Upstream commit 28c8f2189d80c8b37068c367e9864b5aa530f208 ]

Fix number of gpio pins in main_gpio0 & main_gpio1
DT nodes according to AM62x SK datasheet. The Link
of datasheet is in the following line:
https://www.ti.com/lit/ds/symlink/am625.pdf?ts=1673852494660

Section: 6.3.10 GPIO (Page No. 63-67)

Fixes: f1d17330a5be ("arm64: dts: ti: Introduce base support for AM62x SoC")
Signed-off-by: Nitin Yadav <n-yadav@ti.com>
Signed-off-by: Nishanth Menon <nm@ti.com>
Reviewed-by: Bryan Brattlof <bb@ti.com>
Link: https://lore.kernel.org/r/20230202085917.3044567-1-n-yadav@ti.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/ti/k3-am62-main.dtsi | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/boot/dts/ti/k3-am62-main.dtsi b/arch/arm64/boot/dts/ti/k3-am62-main.dtsi
index edcf6b2718814..eb8690a6be168 100644
--- a/arch/arm64/boot/dts/ti/k3-am62-main.dtsi
+++ b/arch/arm64/boot/dts/ti/k3-am62-main.dtsi
@@ -354,7 +354,7 @@
 			     <193>, <194>, <195>;
 		interrupt-controller;
 		#interrupt-cells = <2>;
-		ti,ngpio = <87>;
+		ti,ngpio = <92>;
 		ti,davinci-gpio-unbanked = <0>;
 		power-domains = <&k3_pds 77 TI_SCI_PD_EXCLUSIVE>;
 		clocks = <&k3_clks 77 0>;
@@ -371,7 +371,7 @@
 			     <183>, <184>, <185>;
 		interrupt-controller;
 		#interrupt-cells = <2>;
-		ti,ngpio = <88>;
+		ti,ngpio = <52>;
 		ti,davinci-gpio-unbanked = <0>;
 		power-domains = <&k3_pds 78 TI_SCI_PD_EXCLUSIVE>;
 		clocks = <&k3_clks 78 0>;
-- 
2.39.2



