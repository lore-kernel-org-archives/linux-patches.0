Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1FBCD5102A;
	Mon, 11 Dec 2023 18:50:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HOkOLHWJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9DA28C433CA;
	Mon, 11 Dec 2023 18:50:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1702320623;
	bh=3QrsrMS+488wnhLZruCz5gmHPr3pr9t3KhhwIWchBok=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HOkOLHWJWE5QRqOx8rX9ZwGUsDqgBx1355ro2YtjDJMXUWMt3FWgE2E3xQrwgl7CW
	 YHZXfG8buiA6fKx1uZBPm7boHB0Knfci9yD+LFfcQaB9a6x3mxxh2/gAIi/jC3MjMM
	 Kf4SQ/8cDCbocbkUTIjC+13RBqX9GYVadqIfrOPY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Subject: [PATCH 6.1 129/194] arm64: dts: mediatek: cherry: Fix interrupt cells for MT6360 on I2C7
Date: Mon, 11 Dec 2023 19:21:59 +0100
Message-ID: <20231211182042.285034297@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231211182036.606660304@linuxfoundation.org>
References: <20231211182036.606660304@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -207,7 +207,7 @@
 	pinctrl-0 = <&i2c7_pins>;
 
 	pmic@34 {
-		#interrupt-cells = <1>;
+		#interrupt-cells = <2>;
 		compatible = "mediatek,mt6360";
 		reg = <0x34>;
 		interrupt-controller;


