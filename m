Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C756017BEC6;
	Mon, 24 Feb 2025 14:58:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740409119; cv=none; b=aA8BIi8QGhIA/59xyKpUkvRbgbmLcU81kd+ZSqMr9hdDY0VmZxH60sR77K3/ckcgV08Us5Fv9Nue0Lc+t4Yd41JRAD5v2CsJhZQQtzrGfLuRLSoVg2MHoY3PNToT1zzFpWR5Mqudp+XfdijKKy/uNPc66fGNPswK8lGsuBwZVfs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740409119; c=relaxed/simple;
	bh=M9pQPkp5wXnyVfJ7EpBR4dS7LidRJkILbqbSOJpl1ps=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=leZZU6yktj6UvyzOvAmZ6U0zMfz6tyGSeeqIS+aaojaFURchOqFJLg51vDKdHhXL6FIoEUUOESIyZu/aOEJoxEBCjvKimsH1x7mS5Uuczn6g5k6iQtedla7tQqKc2oABWMuKYAqKUhKg40aqZFq5bATZA73oh6KoU693BiGrIQc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DUS+s89O; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DUS+s89O"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 29B23C4CED6;
	Mon, 24 Feb 2025 14:58:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1740409119;
	bh=M9pQPkp5wXnyVfJ7EpBR4dS7LidRJkILbqbSOJpl1ps=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DUS+s89OGcV/aEqsQHG5tshd8bm/2lTU+3lnPdKOO5O06uRN+IRui+3dDAP5gWhT/
	 +W5X3tu4JDb3sA3G6kEw8PlvKlt907A6vXEa782TnunORP1QOCnx8mCfSJeNwXmJFS
	 d44DokacPajMZTB5e9GIiE7kBD2vqXtAdWY6dxW0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dragan Simic <dsimic@manjaro.org>,
	Alexander Shiyan <eagle.alexander923@gmail.com>,
	Heiko Stuebner <heiko@sntech.de>
Subject: [PATCH 6.13 103/138] arm64: dts: rockchip: Fix broken tsadc pinctrl names for rk3588
Date: Mon, 24 Feb 2025 15:35:33 +0100
Message-ID: <20250224142608.530297293@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250224142604.442289573@linuxfoundation.org>
References: <20250224142604.442289573@linuxfoundation.org>
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

From: Alexander Shiyan <eagle.alexander923@gmail.com>

commit 5c8f9a05336cf5cadbd57ad461621b386aadb762 upstream.

The tsadc driver does not handle pinctrl "gpio" and "otpout".
Let's use the correct pinctrl names "default" and "sleep".
Additionally, Alexey Charkov's testing [1] has established that
it is necessary for pinctrl state to reference the &tsadc_shut_org
configuration rather than &tsadc_shut for the driver to function correctly.

[1] https://lkml.org/lkml/2025/1/24/966

Fixes: 32641b8ab1a5 ("arm64: dts: rockchip: add rk3588 thermal sensor")
Cc: stable@vger.kernel.org
Reviewed-by: Dragan Simic <dsimic@manjaro.org>
Signed-off-by: Alexander Shiyan <eagle.alexander923@gmail.com>
Link: https://lore.kernel.org/r/20250130053849.4902-1-eagle.alexander923@gmail.com
Signed-off-by: Heiko Stuebner <heiko@sntech.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/boot/dts/rockchip/rk3588-base.dtsi |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/arch/arm64/boot/dts/rockchip/rk3588-base.dtsi
+++ b/arch/arm64/boot/dts/rockchip/rk3588-base.dtsi
@@ -2667,9 +2667,9 @@
 		rockchip,hw-tshut-temp = <120000>;
 		rockchip,hw-tshut-mode = <0>; /* tshut mode 0:CRU 1:GPIO */
 		rockchip,hw-tshut-polarity = <0>; /* tshut polarity 0:LOW 1:HIGH */
-		pinctrl-0 = <&tsadc_gpio_func>;
-		pinctrl-1 = <&tsadc_shut>;
-		pinctrl-names = "gpio", "otpout";
+		pinctrl-0 = <&tsadc_shut_org>;
+		pinctrl-1 = <&tsadc_gpio_func>;
+		pinctrl-names = "default", "sleep";
 		#thermal-sensor-cells = <1>;
 		status = "disabled";
 	};


