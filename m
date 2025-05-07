Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A9B114A4C7;
	Wed,  7 May 2025 18:43:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746643398; cv=none; b=EaMWZAj4zKl3MgDRXAJMZ5MccOb4lAlKIJ0fAg7X3TBbhBonHrcwIUKDZbOHhR4Sdr0Hacq5RAX5GAKOgJ3TQQhTQI52M+94586O8THtMpfj1WGkXK1darn+5MhKRZonQmJmWvgXSIMjn4IrBV0AUIDFNIgO/30sqbHJxfXDHJk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746643398; c=relaxed/simple;
	bh=1jG5a5mO7PxuA26B5WhVr42B5ZIicQ7NZbf11Zn5i9w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Qk5C/VKHjwNkJboXiTDDMIDcDZ7vAPWyKAj1jSrdVK8k5GqZSfKCLYn9ttj6KlqCTK/3wR/RSO10U7YTOF4QAnDgV12zd740AlzqLcQa6ocD5EyNxJBbN4lZ8D5NBP4ve/DXdXpkbILP3Kl/YIiY+m29qOfVKAcmML4vvs5u1rk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=F94gHaRg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="F94gHaRg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C7B94C4CEE2;
	Wed,  7 May 2025 18:43:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1746643398;
	bh=1jG5a5mO7PxuA26B5WhVr42B5ZIicQ7NZbf11Zn5i9w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=F94gHaRgnnwpJaboONOJIUB/o1X0NfV06Ei5cWlmxNBi0RcORyRDJ4Fcl6pIgqaTf
	 YOmcev7i6szuJyfpvIP8AAPv0ozDFf8zvvDOjdJaNRwW5N4hzPlj1T+ZHIe0gIbuGn
	 nvNUlbOnLZ/X6Sq3NUE7iAQ1qT4wUPxp5FD+nmHY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?S=C3=A9bastien=20Szymanski?= <sebastien.szymanski@armadeus.com>,
	Oleksij Rempel <o.rempel@pengutronix.de>,
	Shawn Guo <shawnguo@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 46/55] ARM: dts: opos6ul: add ksz8081 phy properties
Date: Wed,  7 May 2025 20:39:47 +0200
Message-ID: <20250507183800.894236218@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250507183759.048732653@linuxfoundation.org>
References: <20250507183759.048732653@linuxfoundation.org>
User-Agent: quilt/0.68
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sébastien Szymanski <sebastien.szymanski@armadeus.com>

[ Upstream commit 6e1a7bc8382b0d4208258f7d2a4474fae788dd90 ]

Commit c7e73b5051d6 ("ARM: imx: mach-imx6ul: remove 14x14 EVK specific
PHY fixup") removed a PHY fixup that setted the clock mode and the LED
mode.
Make the Ethernet interface work again by doing as advised in the
commit's log, set clock mode and the LED mode in the device tree.

Fixes: c7e73b5051d6 ("ARM: imx: mach-imx6ul: remove 14x14 EVK specific PHY fixup")
Signed-off-by: Sébastien Szymanski <sebastien.szymanski@armadeus.com>
Reviewed-by: Oleksij Rempel <o.rempel@pengutronix.de>
Signed-off-by: Shawn Guo <shawnguo@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/imx6ul-imx6ull-opos6ul.dtsi | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/arch/arm/boot/dts/imx6ul-imx6ull-opos6ul.dtsi b/arch/arm/boot/dts/imx6ul-imx6ull-opos6ul.dtsi
index f2386dcb9ff2c..dda4fa91b2f2c 100644
--- a/arch/arm/boot/dts/imx6ul-imx6ull-opos6ul.dtsi
+++ b/arch/arm/boot/dts/imx6ul-imx6ull-opos6ul.dtsi
@@ -40,6 +40,9 @@
 			reg = <1>;
 			interrupt-parent = <&gpio4>;
 			interrupts = <16 IRQ_TYPE_LEVEL_LOW>;
+			micrel,led-mode = <1>;
+			clocks = <&clks IMX6UL_CLK_ENET_REF>;
+			clock-names = "rmii-ref";
 			status = "okay";
 		};
 	};
-- 
2.39.5



