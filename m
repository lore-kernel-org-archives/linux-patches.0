Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A87DD331220;
	Wed, 20 May 2026 17:02:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779296546; cv=none; b=HLKW4pksdqt9bU7vNTIky6vv9QAIf+U9e2DN5l6p5Op8mYjyfalR5ufVLTCHxQz1lnHJpbZF/JpzvPVFs0wQPo/Qc67HoHvDVVJeEpMyLosK6/IuY4C9p0MZDaJApvv7d7J+PvCLrWu8eZRNtA++Nuso2fovahUle9DejfF3mNY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779296546; c=relaxed/simple;
	bh=vTBLswtlxnbRvwsCzJwxRKOEKeQuQuTx86xUJOcTRPw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZClE1HBPjABSfK3eBZaL4N6F5Chld/dvRiVJ9zp/tTbGLLq3eZZEUJj7BSW6AlKrbojl1t5Kjv/Kn4FopyKt+o3cx7DBfpPgLui+VhjOEY77TKxanVUpeBZQSWWL7hWAZeU1CAp1XCrt4vc8/oMfjGF/oDUffcbv/KHIcSav7Gg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lq+4kFUb; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lq+4kFUb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1A2EB1F000E9;
	Wed, 20 May 2026 17:02:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779296545;
	bh=CfLeZuIuTf96TSpp1+2gzzEHwZONHlF/f7wl6rI5C14=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=lq+4kFUbOXKanafzuKSKpNd1A5ti7abSW/noXnBJhKhX9wUtGJT3kOLRKJhpe2qne
	 y/p4qAn70QdV9KVN3yG1POR2Wx+7b02jtNmlSrYCx0kfHQL7dYdJGIrlrwlF56r6kZ
	 bJtZ/BJu2DMRE4IXS0FgjJ2+3B8tgsYTHKORshkA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jun Yan <jerrysteve1101@gmail.com>,
	Martin Blumenstingl <martin.blumenstingl@googlemail.com>,
	Neil Armstrong <neil.armstrong@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 0823/1146] arm64: dts: meson-gxl-p230: fix ethernet PHY interrupt number
Date: Wed, 20 May 2026 18:17:53 +0200
Message-ID: <20260520162206.857657998@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162148.390695140@linuxfoundation.org>
References: <20260520162148.390695140@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jun Yan <jerrysteve1101@gmail.com>

[ Upstream commit 174a0ef3b33434f475c87e66f37980e39b73805a ]

Correct the interrupt number assigned to the Realtek PHY in the p230

following the same logic as commit 3106507e1004 ("ARM64: dts: meson-gxm:
fix q200 interrupt number"),as reported in [PATCH 0/2] Ethernet PHY
interrupt improvements [1].

[1] https://lore.kernel.org/all/20171202214037.17017-1-martin.blumenstingl@googlemail.com/

Fixes: b94d22d94ad2 ("ARM64: dts: meson-gx: add external PHY interrupt on some platforms")
Signed-off-by: Jun Yan <jerrysteve1101@gmail.com>
Reviewed-by: Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Link: https://patch.msgid.link/20260330145111.115318-1-jerrysteve1101@gmail.com
Signed-off-by: Neil Armstrong <neil.armstrong@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/amlogic/meson-gxl-s905d-p230.dts | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/amlogic/meson-gxl-s905d-p230.dts b/arch/arm64/boot/dts/amlogic/meson-gxl-s905d-p230.dts
index 7dffeb5931c9b..701de57ff0f37 100644
--- a/arch/arm64/boot/dts/amlogic/meson-gxl-s905d-p230.dts
+++ b/arch/arm64/boot/dts/amlogic/meson-gxl-s905d-p230.dts
@@ -84,7 +84,8 @@ external_phy: ethernet-phy@0 {
 		reset-gpios = <&gpio GPIOZ_14 GPIO_ACTIVE_LOW>;
 
 		interrupt-parent = <&gpio_intc>;
-		interrupts = <29 IRQ_TYPE_LEVEL_LOW>;
+		/* MAC_INTR on GPIOZ_15 */
+		interrupts = <25 IRQ_TYPE_LEVEL_LOW>;
 		eee-broken-1000t;
 	};
 };
-- 
2.53.0



