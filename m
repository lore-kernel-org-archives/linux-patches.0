Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE74B39478D;
	Sat, 30 May 2026 18:08:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780164528; cv=none; b=k2faTFb2TZRRoYlW3xRZrvdxe4AmxJPjSbEuAKV7pGMPKvwdK53YSB/7HNS5MSC4LoNYP0wwFxQ/B5CyVCTfPst5M+UKXrVgREyKUxTrK1lisaOA19yQ6rtZCGY/oYNDSDTy1aUFvT7SRyN7pXQ1sUMyp67U9xPuW1/DT5PHlOI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780164528; c=relaxed/simple;
	bh=N7ExZx1plblCor6Lcz1ZMWESBCgg9aWQX6KcqRMMWHw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VGcNEMYcAXlmIF6jg7YrXezFL63TUUu4UpKbBnSNq2HZwVmR6xI5nnYH2LKiBb4mXiDpWl+0vJ7+fMNLvJDPHg2en+4qAz0HnKOHVfqH2tqLsSLjb9ZNc7GXj5Qub1FRyeWs0uvFjCilg9Y7O1gfHx2S9axQVWMT5MIBYCrtNZA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mY7YSAjz; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mY7YSAjz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F2B0D1F00893;
	Sat, 30 May 2026 18:08:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780164527;
	bh=Mr1Y1XxgBOvc8bzbGTVjNCLr8VClBAbA236f1J7cB8w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mY7YSAjzb/eoHpyJ8xl0PFaeH4QpHB8roR+uVdnB2A92TsZ/4+d2eelailuSjJ9US
	 ZMS2HMN3qByDsQ37B9nu7exHgLvZvPvUnyFyBji0XTNFdq0/yaMGkwPuY3L7AIXjUS
	 3oKiSjlfcvugUa6wBsIT3ncfCexKDAB4ugG0J3jg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jun Yan <jerrysteve1101@gmail.com>,
	Martin Blumenstingl <martin.blumenstingl@googlemail.com>,
	Neil Armstrong <neil.armstrong@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 581/776] arm64: dts: meson-gxl-p230: fix ethernet PHY interrupt number
Date: Sat, 30 May 2026 18:04:55 +0200
Message-ID: <20260530160255.103419769@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160240.228940103@linuxfoundation.org>
References: <20260530160240.228940103@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index b2ab05c220903..67c952fe8abc1 100644
--- a/arch/arm64/boot/dts/amlogic/meson-gxl-s905d-p230.dts
+++ b/arch/arm64/boot/dts/amlogic/meson-gxl-s905d-p230.dts
@@ -86,7 +86,8 @@ external_phy: ethernet-phy@0 {
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



