Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F7C81E0B84;
	Wed,  6 Nov 2024 13:15:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730898959; cv=none; b=JaR7J4LUI6PnKFLvrbw4uL2vfj7d9x/jRCdAHM1iWkca7EP2n2E2airfRmReuDjo96J3f5lGszD1FJYsb8T8yMkRtsTaENFn5XJ9liQy2jHScGoe4niU4EezATIhM9giC6XG5XAtK1r6+Ja2lFpRJwOmYSB1SUJPzR14y01bcPs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730898959; c=relaxed/simple;
	bh=MgYn1fmL/m+rRhTflWyCGODsKIXMxvY+ovqXMJzOCQo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HsGFVhT3HaTneILO8DIuoSfirExLvqxQmWDJKplmYqeZCP6p/Bp8owSPzgiwfFZ5bdoHvkxg3/bL6uMx+RntoIzLIILd30rMYrlUzbPxnNj4pqZWgSMaB7vbu6bkWk44cOYDwgQulUi2oZ9RL4aZ6tP20ZQb49m/3ShwEuDn5kA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TTaYAn2L; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TTaYAn2L"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8A51FC4CECD;
	Wed,  6 Nov 2024 13:15:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730898958;
	bh=MgYn1fmL/m+rRhTflWyCGODsKIXMxvY+ovqXMJzOCQo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TTaYAn2LqoQa9BrSzHoYLTdpr4XBGKyUs2lLG+9u9T+YZKAcizzDHxszDfrlRVrBV
	 vqd1ucZ4893cfmtuPjtXe9n1Qt6Ck7KnEHPQfug//D8BiG+br+2vMxyoJOYpy1I3vR
	 QjT4GClr1dqtKfLlBpGTgAl8WGNu2nKAoAd7jNw0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Florian Klink <flokli@flokli.de>,
	Stefan Wahren <wahrenst@gmx.net>,
	Florian Fainelli <florian.fainelli@broadcom.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 386/462] ARM: dts: bcm2837-rpi-cm3-io3: Fix HDMI hpd-gpio pin
Date: Wed,  6 Nov 2024 13:04:39 +0100
Message-ID: <20241106120341.059009888@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241106120331.497003148@linuxfoundation.org>
References: <20241106120331.497003148@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
index 3dfce4312dfc4..a2ef43c2105aa 100644
--- a/arch/arm/boot/dts/bcm2837-rpi-cm3-io3.dts
+++ b/arch/arm/boot/dts/bcm2837-rpi-cm3-io3.dts
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



