Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 92E768801;
	Tue, 30 Apr 2024 11:13:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714475581; cv=none; b=MYCOQu3VnR494luXI43i5stY9zYrILbIOPI76sf2o+LULC2OZuTybuH2udUWO25cKKhixWGelMU0S6e4S+OuWJVXSPdLM1DNvqUJ0cIwQkMNXt4tp3hYXNio8xxnaroK6TAMwFyfwESGsRryNYpmfozI/rKOALmX9JwMeu18BUo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714475581; c=relaxed/simple;
	bh=lRm3UdYkjPFSH7rL5UTL4wdG2ffRNiqKrptD1TkVsKI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RKcVRSuElVcIztDlMj2nTOP86MFQSSVqFembYf69m2Ke5v58bkPUYv/o+wxK19P7OgXvu+bP67YIEtpPBAbs0T2r1v7HpyNQ/z++4adJfwclR50OljIilsoggdzyPcIW048ButEXh/jD1Q2O8aKkmhXZ/arkrQRhDbOsL6cknWE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Zax/syAw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Zax/syAw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AA259C2BBFC;
	Tue, 30 Apr 2024 11:13:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1714475581;
	bh=lRm3UdYkjPFSH7rL5UTL4wdG2ffRNiqKrptD1TkVsKI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Zax/syAwE31+FecGmQCPERC+bO23N2U+/FveZyns4RuG4fkbOwr1tJen4ov5z3O49
	 leD6Gdj52O9b9PKkHUMSbQ66Gz0vAklFG+tJj8MJE3g8BWqLLKHBb+qOeFRlOuFw5e
	 dcXkPk9sM/TpSXMwQzGsZopvdxF6ntVAYdx9tdvU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Iskander Amara <iskander.amara@theobroma-systems.com>,
	Quentin Schulz <quentin.schulz@theobroma-systems.com>,
	Heiko Stuebner <heiko@sntech.de>
Subject: [PATCH 6.6 140/186] arm64: dts: rockchip: enable internal pull-up for Q7_THRM# on RK3399 Puma
Date: Tue, 30 Apr 2024 12:39:52 +0200
Message-ID: <20240430103102.098024119@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240430103058.010791820@linuxfoundation.org>
References: <20240430103058.010791820@linuxfoundation.org>
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


