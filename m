Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0262E18C03B;
	Wed,  5 Feb 2025 14:58:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738767496; cv=none; b=GygvKn9vjx5Z2biqHKxvqRyatJk0bNChjbwiuW1QF/HviaKtQtsUnhEOOD5QAXvN4RdGIVrMIZD7/h7PCOYeaWhrGCjiFRiwHJUXYTuvQfwB/SQz1jX5YrvLJvnsjVREuKO4y6S1AxdNa287MqlGHRwuHg3HiiqKhIZ3ddSJefo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738767496; c=relaxed/simple;
	bh=N7ok4iISep8+Gvzej7A0htaktlhD8temlblhR27v1Wk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dNihK+1ugVdKWr0lJeSO2tCno3OTU3YR8Hs91cgYeUGxKS7aVhttTy5Ny/RDupy8Rz3LxV/x+15pMKCRAS4VcVdmPg98xI2m1WdbjLDHh3EOEtvbmB2O+uXeJqJCC0z2U7Xj9pPn5JUiWfcjk0Si98XBpUkhpGL7CxUftk5oTOI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wvqxajOO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wvqxajOO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D581FC4CED1;
	Wed,  5 Feb 2025 14:58:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738767494;
	bh=N7ok4iISep8+Gvzej7A0htaktlhD8temlblhR27v1Wk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wvqxajOO5Ba8CgWltDZ4SNMvIuoQDXo8MlhHREMxl/LsOkYIRDQcTqUSJ3vLj7YB7
	 0ywXAOlhrQ3fkqB1x0WAu+ntSGJvWyH9XqwLiJ1iv+gKk1lec1WGkRYEpEgYavIPTh
	 8u5s6DWY6KsVCUUmblsrbnytw9PX8TgvW4t7v/6E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mihai Sain <mihai.sain@microchip.com>,
	Cristian Birsan <cristian.birsan@microchip.com>,
	Andrei Simion <andrei.simion@microchip.com>,
	Claudiu Beznea <claudiu.beznea@tuxon.dev>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 394/623] ARM: dts: microchip: sama5d29_curiosity: Add no-1-8-v property to sdmmc0 node
Date: Wed,  5 Feb 2025 14:42:16 +0100
Message-ID: <20250205134511.294421922@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250205134456.221272033@linuxfoundation.org>
References: <20250205134456.221272033@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Cristian Birsan <cristian.birsan@microchip.com>

[ Upstream commit c21c23a0f2e9869676eff0d53fb89e151e14c873 ]

Add no-1-8-v property to sdmmc0 node to keep VDDSDMMC power rail at 3.3V.
This property will stop the LDO regulator from switching to 1.8V when the
MMC core detects an UHS SD Card. VDDSDMMC power rail is used by all the
SDMMC interface pins in GPIO mode (PA0 - PA13).

On this board, PA6 is used as GPIO to enable the power switch controlling
USB Vbus for the USB Host. The change is needed to fix the PA6 voltage
level to 3.3V instead of 1.8V.

Fixes: d85c4229e925 ("ARM: dts: at91: sama5d29_curiosity: Add device tree for sama5d29_curiosity board")
Suggested-by: Mihai Sain <mihai.sain@microchip.com>
Signed-off-by: Cristian Birsan <cristian.birsan@microchip.com>
Tested-by: Andrei Simion <andrei.simion@microchip.com>
Link: https://lore.kernel.org/r/20241119160107.598411-2-cristian.birsan@microchip.com
Signed-off-by: Claudiu Beznea <claudiu.beznea@tuxon.dev>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/microchip/at91-sama5d29_curiosity.dts | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm/boot/dts/microchip/at91-sama5d29_curiosity.dts b/arch/arm/boot/dts/microchip/at91-sama5d29_curiosity.dts
index b6684bf67d3e6..7be2157815497 100644
--- a/arch/arm/boot/dts/microchip/at91-sama5d29_curiosity.dts
+++ b/arch/arm/boot/dts/microchip/at91-sama5d29_curiosity.dts
@@ -514,6 +514,7 @@
 
 &sdmmc0 {
 	bus-width = <4>;
+	no-1-8-v;
 	pinctrl-names = "default";
 	pinctrl-0 = <&pinctrl_sdmmc0_default>;
 	disable-wp;
-- 
2.39.5



