Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BDF3612D215;
	Tue, 30 Apr 2024 11:29:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714476583; cv=none; b=oDR9n3iSMEtgGiwAPjwrxWXB3bKC3SyiYjkH1A0mkutoPveuEiMd/BbzjhB5cZOOo6Q8RegwL2FtZp2ls5YSuKbyVsIIKgKQKiE+oovb4LB2LSlHde9rvn/R+7l8ht8orNAZIkRR1qauuRchzltvyEcoYbLkcs2eEDgw8HtiDEQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714476583; c=relaxed/simple;
	bh=0EBbTiax7rbDvjx7g/G0DLfCI9VtX55Ir/HBSFouzEU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lllmh0JxnVlKW36S/cEb2qp6JBWfQCyTjb1W8lzrvXO0j9KxDW3yCvNORAMNVG7mPeMDAezlJjJ+gKkfmB2P2AJ7nvJHlgy1nNsfviGWKkpe2KSBK/D2mhWGBLU8CXz8LqDuiSRZRA5oKZv42WW3f+M2+DD7IFOy6H0HUQIaM0w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IsKvp/KK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IsKvp/KK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C1EB0C2BBFC;
	Tue, 30 Apr 2024 11:29:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1714476583;
	bh=0EBbTiax7rbDvjx7g/G0DLfCI9VtX55Ir/HBSFouzEU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IsKvp/KKEMB1cbktSvmMESeIm6vBRNJuFYZuF7xyvrXZuxb4HP4VlORKNW5eHKZen
	 7pmfeqs3iOq33V6LrmQXQg9Ud69KvzbbY8reqELNAUZ/7Ois6cV5wAlw7Hrz8O2/CM
	 tufCi/DKKADqsLzvYTFmIwxoFt0a6dOrEkFipUWo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Iskander Amara <iskander.amara@theobroma-systems.com>,
	Quentin Schulz <quentin.schulz@theobroma-systems.com>,
	Heiko Stuebner <heiko@sntech.de>
Subject: [PATCH 6.1 077/110] arm64: dts: rockchip: enable internal pull-up for Q7_THRM# on RK3399 Puma
Date: Tue, 30 Apr 2024 12:40:46 +0200
Message-ID: <20240430103049.839664452@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240430103047.561802595@linuxfoundation.org>
References: <20240430103047.561802595@linuxfoundation.org>
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

From: Iskander Amara <iskander.amara@theobroma-systems.com>

commit 0ac417b8f124427c90ec8c2ef4f632b821d924cc upstream.

Q7_THRM# pin is connected to a diode on the module which is used
as a level shifter, and the pin have a pull-down enabled by
default. We need to configure it to internal pull-up, other-
wise whenever the pin is configured as INPUT and we try to
control it externally the value will always remain zero.

Signed-off-by: Iskander Amara <iskander.amara@theobroma-systems.com>
Fixes: 2c66fc34e945 ("arm64: dts: rockchip: add RK3399-Q7 (Puma) SoM")
Reviewed-by: Quentin Schulz <quentin.schulz@theobroma-systems.com>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20240308085243.69903-1-iskander.amara@theobroma-systems.com
Signed-off-by: Heiko Stuebner <heiko@sntech.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/boot/dts/rockchip/rk3399-puma.dtsi |   10 ++++++++++
 1 file changed, 10 insertions(+)

--- a/arch/arm64/boot/dts/rockchip/rk3399-puma.dtsi
+++ b/arch/arm64/boot/dts/rockchip/rk3399-puma.dtsi
@@ -407,6 +407,16 @@
 };
 
 &pinctrl {
+	pinctrl-names = "default";
+	pinctrl-0 = <&q7_thermal_pin>;
+
+	gpios {
+		q7_thermal_pin: q7-thermal-pin {
+			rockchip,pins =
+				<0 RK_PA3 RK_FUNC_GPIO &pcfg_pull_up>;
+		};
+	};
+
 	i2c8 {
 		i2c8_xfer_a: i2c8-xfer {
 			rockchip,pins =


