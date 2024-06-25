Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 35AD31465B7;
	Tue, 25 Jun 2024 10:01:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719309668; cv=none; b=YMslmBpNzyCb1nZ1dLvvF39TmkkXP7zT9JJdzecBiUTrvbzqKWZRnPAIDcfwmaXW0uFAMaXTrJLnDpyUbtgzs0M8AWuu2WTJfRXwN7JmHvbQ2S8gI7dNzsEwsrsbxvkFu7Tih8ifbdc2ExJhmUwWaFEuCs5FFU30Ib89v/lOhqU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719309668; c=relaxed/simple;
	bh=/n6L01Gzv74lRE9qRtQl4/C8U9gl/L1Ao+Ap0j9hUuE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=hhqOYAmmtJWGAvQF2VOCV7RmuE0KixhszFfWjIaLni2PSVumLUmOQ0iD7rdjHkw0a3j3/jeZnoq7/5RNmGmoNV1sZxyii+HroDM0ptTvMSHcztCdyPeOP6tp5zOrtl68ntiaWov5I9tikV0fy/Osh+dfJYsN2BZNbV9MkZu2u0c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LvOtfQis; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LvOtfQis"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B07D5C32781;
	Tue, 25 Jun 2024 10:01:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1719309668;
	bh=/n6L01Gzv74lRE9qRtQl4/C8U9gl/L1Ao+Ap0j9hUuE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LvOtfQisxr8Z8Yp12CwIZTaXOPrBG/Tb5PWMGQEdqsUxXuTifbgYcd9B8RMy+w7wW
	 cfq5ybZHLlNCsEXrvN+M1K55p6vV54tYRtV3UiGdtd1WLh2yg2UEzjjux33XROs4ht
	 qL9P06ECUP7SWk67RcsX60x/VmmDrcnpYWQ6GQt4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Florian Fainelli <f.fainelli@gmail.com>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Subject: [PATCH 6.1 093/131] MIPS: dts: bcm63268: Add missing properties to the TWD node
Date: Tue, 25 Jun 2024 11:34:08 +0200
Message-ID: <20240625085529.472950894@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240625085525.931079317@linuxfoundation.org>
References: <20240625085525.931079317@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Florian Fainelli <f.fainelli@gmail.com>

commit 24b333a866a10d4be47b9968b9c05a3e9f326ff5 upstream.

We currently have a DTC warning with the current DTS due to the lack of
a suitable #address-cells and #size-cells property:

  DTC     arch/mips/boot/dts/brcm/bcm63268-comtrend-vr-3032u.dtb
arch/mips/boot/dts/brcm/bcm63268.dtsi:115.5-22: Warning (reg_format): /ubus/timer-mfd@10000080/timer@0:reg: property has invalid length (8 bytes) (#address-cells == 2, #size-cells == 1)
arch/mips/boot/dts/brcm/bcm63268.dtsi:120.5-22: Warning (reg_format): /ubus/timer-mfd@10000080/watchdog@1c:reg: property has invalid length (8 bytes) (#address-cells == 2, #size-cells == 1)
arch/mips/boot/dts/brcm/bcm63268.dtsi:111.4-35: Warning (ranges_format): /ubus/timer-mfd@10000080:ranges: "ranges" property has invalid length (12 bytes) (parent #address-cells == 1, child #address-cells == 2, #size-cells == 1)

Fixes: d3db4b96ab7f ("mips: dts: bcm63268: add TWD block timer")
Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
Reviewed-by: Philippe Mathieu-Daudé <philmd@linaro.org>
Signed-off-by: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/mips/boot/dts/brcm/bcm63268.dtsi |    2 ++
 1 file changed, 2 insertions(+)

--- a/arch/mips/boot/dts/brcm/bcm63268.dtsi
+++ b/arch/mips/boot/dts/brcm/bcm63268.dtsi
@@ -109,6 +109,8 @@
 			compatible = "brcm,bcm7038-twd", "simple-mfd", "syscon";
 			reg = <0x10000080 0x30>;
 			ranges = <0x0 0x10000080 0x30>;
+			#address-cells = <1>;
+			#size-cells = <1>;
 
 			wdt: watchdog@1c {
 				compatible = "brcm,bcm7038-wdt";


