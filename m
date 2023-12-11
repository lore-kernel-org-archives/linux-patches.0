Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F256FC06;
	Mon, 11 Dec 2023 18:34:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="k9FLP/NM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 99DC7C433C7;
	Mon, 11 Dec 2023 18:34:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1702319641;
	bh=fJ/LZws10QQ3EQLl6SpyPqdvdqmuG6hWIQVGvQ9AEns=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=k9FLP/NMP8K8VOzgr8hVbBDMKhQLfvDNPNOhtCyUaT9zE7UAHBI7tMDtQJFigthv3
	 Za54Nka7j2GKF4aeer9Ezu35f3pE7mHLkbTf11MwLxJv0tUukiEeG5rfo0soKzaviQ
	 2NW0dl9AssjZ2vLCKjPg6O/+0hSdNsO3PXm6yXzQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Subject: [PATCH 6.6 181/244] arm64: dts: mediatek: cherry: Fix interrupt cells for MT6360 on I2C7
Date: Mon, 11 Dec 2023 19:21:14 +0100
Message-ID: <20231211182054.055802059@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231211182045.784881756@linuxfoundation.org>
References: <20231211182045.784881756@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>

commit 5943b8f7449df9881b273db07bdde1e7120dccf0 upstream.

Change interrupt cells to 2 to suppress interrupts_property warning.

Cc: stable@vger.kernel.org
Fixes: 0de0fe950f1b ("arm64: dts: mediatek: cherry: Enable MT6360 sub-pmic on I2C7")
Link: https://lore.kernel.org/r/20231127132026.165027-1-angelogioacchino.delregno@collabora.com
Signed-off-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/boot/dts/mediatek/mt8195-cherry.dtsi |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/arm64/boot/dts/mediatek/mt8195-cherry.dtsi
+++ b/arch/arm64/boot/dts/mediatek/mt8195-cherry.dtsi
@@ -362,7 +362,7 @@
 	pinctrl-0 = <&i2c7_pins>;
 
 	pmic@34 {
-		#interrupt-cells = <1>;
+		#interrupt-cells = <2>;
 		compatible = "mediatek,mt6360";
 		reg = <0x34>;
 		interrupt-controller;


