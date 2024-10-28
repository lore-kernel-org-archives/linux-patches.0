Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8550718DF88;
	Mon, 28 Oct 2024 06:33:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730097206; cv=none; b=sqWxo9zhvW73AnltkXk9zNaIRXnjEFse2opeWCq9LfguQ9ekqdBOWpjgDqZrFr+AdTw4tPmYhXV68FGx/tNVtDBRAZN1f5dvayzDHxFIyyZo6yJgfcJB78ihFQr38J7lvCOg/1Fj0x5GtL4zGL9KpVwh4K7l/cESJwbkf7UwsUQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730097206; c=relaxed/simple;
	bh=GDEogbKHjuyzxNxBXwBmxor1vVs5oFzeUhidBCGr37U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VIljYBmMoLcSRgOzvM1n6ve4EehxPYqkADDJpOcG1PTBomoWDv7WfN/7r0Rxdn5hZEx1cuIqFVgs2kO77euJSkYOsND7pxs4KmsenK+DoBSSAwJvKGhWkXfopGsW5KIQdsSZls43S70hB7fuJU5AICuXbj6GVAGhH7wkWIKwEf0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ew1fQ66+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ew1fQ66+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BC8F7C4CECD;
	Mon, 28 Oct 2024 06:33:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730097206;
	bh=GDEogbKHjuyzxNxBXwBmxor1vVs5oFzeUhidBCGr37U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ew1fQ66+r57j9MzzzW6Aj7cX3tCbtAvcfn3eOmMpE/wd2+SUpa2kM0lKAwqMAZPdw
	 D3DNMvCKFYexT/MXZ00JUmF6MkteB+iSRv7rsvlkYiJv+5+LpWDypV08wCbBwq1Cy4
	 q+JOlYCf2n9g5JmNt5oHjjhYSVPX0OsHleDOToyY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Florian Klink <flokli@flokli.de>,
	Stefan Wahren <wahrenst@gmx.net>,
	Florian Fainelli <florian.fainelli@broadcom.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 009/137] ARM: dts: bcm2837-rpi-cm3-io3: Fix HDMI hpd-gpio pin
Date: Mon, 28 Oct 2024 07:24:06 +0100
Message-ID: <20241028062258.976592277@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241028062258.708872330@linuxfoundation.org>
References: <20241028062258.708872330@linuxfoundation.org>
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

From: Florian Klink <flokli@flokli.de>

[ Upstream commit dc7785e4723510616d776862ddb4c08857a1bdb2 ]

HDMI_HPD_N_1V8 is connected to GPIO pin 0, not 1.

This fixes HDMI hotplug/output detection.

See https://datasheets.raspberrypi.com/cm/cm3-schematics.pdf

Signed-off-by: Florian Klink <flokli@flokli.de>
Reviewed-by: Stefan Wahren <wahrenst@gmx.net>
Link: https://lore.kernel.org/r/20240715230311.685641-1-flokli@flokli.de
Reviewed-by: Stefan Wahren <wahrenst@gmx.net>
Fixes: a54fe8a6cf66 ("ARM: dts: add Raspberry Pi Compute Module 3 and IO board")
Signed-off-by: Florian Fainelli <florian.fainelli@broadcom.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/bcm2837-rpi-cm3-io3.dts | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/boot/dts/bcm2837-rpi-cm3-io3.dts b/arch/arm/boot/dts/bcm2837-rpi-cm3-io3.dts
index cf84e69fced83..4b2f63e0ae7c0 100644
--- a/arch/arm/boot/dts/bcm2837-rpi-cm3-io3.dts
+++ b/arch/arm/boot/dts/bcm2837-rpi-cm3-io3.dts
@@ -76,7 +76,7 @@
 };
 
 &hdmi {
-	hpd-gpios = <&expgpio 1 GPIO_ACTIVE_LOW>;
+	hpd-gpios = <&expgpio 0 GPIO_ACTIVE_LOW>;
 	power-domains = <&power RPI_POWER_DOMAIN_HDMI>;
 	status = "okay";
 };
-- 
2.43.0



