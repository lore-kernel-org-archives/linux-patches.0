Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 613258481
	for <patches@lists.linux.dev>; Fri, 10 Mar 2023 14:14:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DAA5DC4339E;
	Fri, 10 Mar 2023 14:14:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678457688;
	bh=h+AA5rhOUm/qbgFYYAyBRv5oXGeWsHthe1l+TFjSY7M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xPrrgQQRUMa+GoiuHh8c8qTnfU4e9uQehAGQjPvMSNWKsI8wBvIGSXPGka+N7sI3R
	 M8ZxWOTE9Iaqe3uSYSmI4C7cD5VGfjcqA2hLootqEw2SgddBTutfsg/JkTkJiJyQXk
	 qx+qMqabcCOmIp2Sq16CqYrMIvQ0Ng9BEAlWxnDo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vyacheslav Bocharov <adeep@lexina.in>,
	Martin Blumenstingl <martin.blumenstingl@googlemail.com>,
	Neil Armstrong <neil.armstrong@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 006/252] arm64: dts: meson-gx: Fix Ethernet MAC address unit name
Date: Fri, 10 Mar 2023 14:36:16 +0100
Message-Id: <20230310133719.004393209@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230310133718.803482157@linuxfoundation.org>
References: <20230310133718.803482157@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Martin Blumenstingl <martin.blumenstingl@googlemail.com>

[ Upstream commit 8ed5310356bfa47cc6bb4221ae6b21258c52e3d1 ]

Unit names should use hyphens instead of underscores to not cause
warnings.

Fixes: bfe59f92d306 ("ARM64: dts: amlogic: gxbb: Enable NVMEM")
Suggested-by: Vyacheslav Bocharov <adeep@lexina.in>
Signed-off-by: Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Reviewed-by: Neil Armstrong <neil.armstrong@linaro.org>
Link: https://lore.kernel.org/r/20230111211350.1461860-5-martin.blumenstingl@googlemail.com
Signed-off-by: Neil Armstrong <neil.armstrong@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/amlogic/meson-gx.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/amlogic/meson-gx.dtsi b/arch/arm64/boot/dts/amlogic/meson-gx.dtsi
index a127657526c7f..19feaec6a1ae8 100644
--- a/arch/arm64/boot/dts/amlogic/meson-gx.dtsi
+++ b/arch/arm64/boot/dts/amlogic/meson-gx.dtsi
@@ -150,7 +150,7 @@ sn: sn@14 {
 			reg = <0x14 0x10>;
 		};
 
-		eth_mac: eth_mac@34 {
+		eth_mac: eth-mac@34 {
 			reg = <0x34 0x10>;
 		};
 
-- 
2.39.2



