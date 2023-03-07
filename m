Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6AF11BA32
	for <patches@lists.linux.dev>; Tue,  7 Mar 2023 17:08:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 533F0C433EF;
	Tue,  7 Mar 2023 17:08:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678208892;
	bh=uu4fTqgmkgZcz/KVZl73vpBU7jZIanvK/uILpJ5R0bM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bFlac2qW9wKdxtaBLeN1GNlykqjROdKzVVX2EsHv9R1Pu+el6u1Fbh3FAYnEl4tJa
	 KpOqPocsNrwaFBsY36Jm0WxSmRCVZv/m5G9x3c3DCiUBlEfzCZkV9EBg4N46VFmQKl
	 RPcxRN+VG7FusYTXjdpvkLh0Prak9CEdlcGBlVJk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vyacheslav Bocharov <adeep@lexina.in>,
	Martin Blumenstingl <martin.blumenstingl@googlemail.com>,
	Neil Armstrong <neil.armstrong@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 0043/1001] arm64: dts: meson-gxl: jethub-j80: Fix WiFi MAC address node
Date: Tue,  7 Mar 2023 17:46:55 +0100
Message-Id: <20230307170023.998506583@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307170022.094103862@linuxfoundation.org>
References: <20230307170022.094103862@linuxfoundation.org>
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

[ Upstream commit f95acdb2b4af21caae2c76a48e565158181386ca ]

Unit addresses should be written using lower-case hex characters. Use
wifi_mac@c to fix a yaml schema validation error once the eFuse
dt-bindings have been converted to a yaml schema:
  efuse: Unevaluated properties are not allowed ('wifi_mac@C' was
  unexpected)

Also node names should use hyphens instead of underscores as the latter
can also cause warnings.

Fixes: abfaae24ecf3 ("arm64: dts: meson-gxl: add support for JetHub H1")
Acked-by: Vyacheslav Bocharov <adeep@lexina.in>
Signed-off-by: Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Reviewed-by: Neil Armstrong <neil.armstrong@linaro.org>
Link: https://lore.kernel.org/r/20230111211350.1461860-2-martin.blumenstingl@googlemail.com
Signed-off-by: Neil Armstrong <neil.armstrong@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../boot/dts/amlogic/meson-gxl-s905w-jethome-jethub-j80.dts     | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/amlogic/meson-gxl-s905w-jethome-jethub-j80.dts b/arch/arm64/boot/dts/amlogic/meson-gxl-s905w-jethome-jethub-j80.dts
index 6831137c5c109..270483e007bc8 100644
--- a/arch/arm64/boot/dts/amlogic/meson-gxl-s905w-jethome-jethub-j80.dts
+++ b/arch/arm64/boot/dts/amlogic/meson-gxl-s905w-jethome-jethub-j80.dts
@@ -90,7 +90,7 @@ bt_mac: bt_mac@6 {
 		reg = <0x6 0x6>;
 	};
 
-	wifi_mac: wifi_mac@C {
+	wifi_mac: wifi-mac@c {
 		reg = <0xc 0x6>;
 	};
 };
-- 
2.39.2



