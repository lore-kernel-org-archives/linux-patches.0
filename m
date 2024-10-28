Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D06718E368;
	Mon, 28 Oct 2024 06:38:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730097481; cv=none; b=JtFGT4rFWh7YhXVpack/OIJw/iRfR8qmJ/Ym+ZO4n5jTYHvuYLo6Du0kJdhaJAM1SlybKdVbgZjbOAuT3rK9tiq8p8FQ1FVoaYfQZwYjgBXR/8+XR4qqBzP3wr4QHiUh7WF/PsStHQxd+Vok3gYRXDhIfghYJOLDwRq4nOLZ1vc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730097481; c=relaxed/simple;
	bh=byX1X5cAxVQgly4Rw0pdOdm5F9BKGULF4ddrNSJzTAs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CeXfy3SAOitioO3Ky9UTmJNQ5OgoQAx4EGiEo5xH88iM0mZK2gQuRiiHsWYJEuGOjWd4PLxdRGcXBd5bCVuaDNiTF/nK/1cdt/RZXOTzUoa8NB/iLyJ8Ptg6lwMWrrILoTvebjASeb6T3wjUq0kvv3qOPoPL5MZaKAfy2TcRyIg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RQQ3P//a; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RQQ3P//a"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B68D2C4CEC3;
	Mon, 28 Oct 2024 06:38:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730097481;
	bh=byX1X5cAxVQgly4Rw0pdOdm5F9BKGULF4ddrNSJzTAs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RQQ3P//arjyj6alzqBw/+0hTg7QUw1wiojNvdT/zoTZLu/G4mUSLQSerpUj7BDfmN
	 +ls6dJiLaSlUiPd9p8Atd99eLcEPDwXeLbwmZXylyNc2R15Xzu1YnhtjQSkZprbkeS
	 Fx/g8GwEf8bu09DfVLneZHAifIBVo2uXqq2TvnVQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Florian Klink <flokli@flokli.de>,
	Stefan Wahren <wahrenst@gmx.net>,
	Florian Fainelli <florian.fainelli@broadcom.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 012/208] ARM: dts: bcm2837-rpi-cm3-io3: Fix HDMI hpd-gpio pin
Date: Mon, 28 Oct 2024 07:23:12 +0100
Message-ID: <20241028062306.960165497@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241028062306.649733554@linuxfoundation.org>
References: <20241028062306.649733554@linuxfoundation.org>
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
 arch/arm/boot/dts/broadcom/bcm2837-rpi-cm3-io3.dts | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/boot/dts/broadcom/bcm2837-rpi-cm3-io3.dts b/arch/arm/boot/dts/broadcom/bcm2837-rpi-cm3-io3.dts
index 72d26d130efaa..85f54fa595aa8 100644
--- a/arch/arm/boot/dts/broadcom/bcm2837-rpi-cm3-io3.dts
+++ b/arch/arm/boot/dts/broadcom/bcm2837-rpi-cm3-io3.dts
@@ -77,7 +77,7 @@
 };
 
 &hdmi {
-	hpd-gpios = <&expgpio 1 GPIO_ACTIVE_LOW>;
+	hpd-gpios = <&expgpio 0 GPIO_ACTIVE_LOW>;
 	power-domains = <&power RPI_POWER_DOMAIN_HDMI>;
 	status = "okay";
 };
-- 
2.43.0



