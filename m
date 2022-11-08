Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D238815CAE
	for <patches@lists.linux.dev>; Tue,  8 Nov 2022 14:02:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 58CA9C433C1;
	Tue,  8 Nov 2022 14:02:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1667916172;
	bh=MPQiUJuGh3Mkt+2KtvbwhRfouXtdios22qeyaqeMAHM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zLSmub2BXnO7FXpBO0J2m1d8Et7wRbp893Zw/0veJFILLbp5B1V8BsumTDihIZe53
	 H2R2t+DVfY4zpmcGp7a6bHfwpnZ0JZqPhTwJJZgLoNpQSARkuXvUxnNKHHvmKA0Hxw
	 1Afo+qG8WvlDxdK9xQ2J39JzVUOGsPvawukJVdPY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tim Harvey <tharvey@gateworks.com>,
	Shawn Guo <shawnguo@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 085/144] ARM: dts: imx6qdl-gw59{10,13}: fix user pushbutton GPIO offset
Date: Tue,  8 Nov 2022 14:39:22 +0100
Message-Id: <20221108133348.865496227@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221108133345.346704162@linuxfoundation.org>
References: <20221108133345.346704162@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Tim Harvey <tharvey@gateworks.com>

[ Upstream commit bb5ad73941dc3f4e3c2241348f385da6501d50ea ]

The GW5910 and GW5913 have a user pushbutton that is tied to the
Gateworks System Controller GPIO offset 2. Fix the invalid offset of 0.

Fixes: 64bf0a0af18d ("ARM: dts: imx6qdl-gw: add Gateworks System Controller support")
Signed-off-by: Tim Harvey <tharvey@gateworks.com>
Signed-off-by: Shawn Guo <shawnguo@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/imx6qdl-gw5910.dtsi | 2 +-
 arch/arm/boot/dts/imx6qdl-gw5913.dtsi | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm/boot/dts/imx6qdl-gw5910.dtsi b/arch/arm/boot/dts/imx6qdl-gw5910.dtsi
index 68e5ab2e27e2..6bb4855d13ce 100644
--- a/arch/arm/boot/dts/imx6qdl-gw5910.dtsi
+++ b/arch/arm/boot/dts/imx6qdl-gw5910.dtsi
@@ -29,7 +29,7 @@ gpio-keys {
 
 		user-pb {
 			label = "user_pb";
-			gpios = <&gsc_gpio 0 GPIO_ACTIVE_LOW>;
+			gpios = <&gsc_gpio 2 GPIO_ACTIVE_LOW>;
 			linux,code = <BTN_0>;
 		};
 
diff --git a/arch/arm/boot/dts/imx6qdl-gw5913.dtsi b/arch/arm/boot/dts/imx6qdl-gw5913.dtsi
index 8e23cec7149e..696427b487f0 100644
--- a/arch/arm/boot/dts/imx6qdl-gw5913.dtsi
+++ b/arch/arm/boot/dts/imx6qdl-gw5913.dtsi
@@ -26,7 +26,7 @@ gpio-keys {
 
 		user-pb {
 			label = "user_pb";
-			gpios = <&gsc_gpio 0 GPIO_ACTIVE_LOW>;
+			gpios = <&gsc_gpio 2 GPIO_ACTIVE_LOW>;
 			linux,code = <BTN_0>;
 		};
 
-- 
2.35.1



