Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 75CFA244663;
	Tue, 20 May 2025 14:18:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747750699; cv=none; b=oOt6Ksykwo4pt1mIMJC5pD8Tw/K49MoKZ7qflj01Bf+t3njvSsc15axqw44aZGzHD/2r+EysoHhNAppIIMCugB1iYMZrj+24z2GX6pL51sRDgrR8+8zyCEid6E+bQlOKWkvaMtnYT97oT0BZeFr55EWvObiG324jNJCz1+J6VOU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747750699; c=relaxed/simple;
	bh=UWfpgd4nF9XM0/9OP7A3eCngxlNvI87n0MxjFwN24vc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tsE0lMbpHOF6OD+POC49SCdtyssZnuRjHU3hDXtG1XM1C3rDCyG9TRlycGcIU7XdzDXc8oVzC1ViZJ6t1wQ7vV4XVoXLhLb16l/hsMWot7QPn1AQUb50zp5kJEwwX2iX0KrdJ9UaYTr1ucUtKKvmEKSbo15ZD6nPmn3MXlxDD9M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0l3MLi+5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0l3MLi+5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DF20BC4CEE9;
	Tue, 20 May 2025 14:18:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1747750699;
	bh=UWfpgd4nF9XM0/9OP7A3eCngxlNvI87n0MxjFwN24vc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0l3MLi+5x+BjpmlW+5ojJXXXP4afc7K2ufkTlJ/ZfjC93PcWpq3pFyKupiBHmD2VU
	 zG7Cre3ABSBWl58q+rIZ8eX2nJKiu+Z7OW7oXUeJMhZqRInp44U0nP6M9btxanYf28
	 6KF/EdBO4cY8/QMq5sd+88IFIEnwSCBKEETdtUgk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sam Edwards <CFSworks@gmail.com>,
	Dragan Simic <dsimic@manjaro.org>,
	Heiko Stuebner <heiko@sntech.de>,
	stable@kernel.org
Subject: [PATCH 6.14 093/145] arm64: dts: rockchip: Allow Turing RK1 cooling fan to spin down
Date: Tue, 20 May 2025 15:51:03 +0200
Message-ID: <20250520125814.207216404@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250520125810.535475500@linuxfoundation.org>
References: <20250520125810.535475500@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sam Edwards <cfsworks@gmail.com>

commit fdc7bd909a5f38793468e9cf9b6a9063d96c6234 upstream.

The RK3588 thermal sensor driver only receives interrupts when a
higher-temperature threshold is crossed; it cannot notify when the
sensor cools back off. As a result, the driver must poll for temperature
changes to detect when the conditions for a thermal trip are no longer
met. However, it only does so if the DT enables polling.

Before this patch, the RK1 DT did not enable polling, causing the fan to
continue running at the speed corresponding to the highest temperature
reached.

Follow suit with similar RK3588 boards by setting a polling-delay of
1000ms, enabling the driver to detect when the sensor cools back off,
allowing the fan speed to decrease as appropriate.

Fixes: 7c8ec5e6b9d6 ("arm64: dts: rockchip: Enable automatic fan control on Turing RK1")
Cc: stable@kernel.org # v6.13+
Signed-off-by: Sam Edwards <CFSworks@gmail.com>
Reviewed-by: Dragan Simic <dsimic@manjaro.org>
Link: https://lore.kernel.org/r/20250329165017.3885-1-CFSworks@gmail.com
Signed-off-by: Heiko Stuebner <heiko@sntech.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/boot/dts/rockchip/rk3588-turing-rk1.dtsi | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/arm64/boot/dts/rockchip/rk3588-turing-rk1.dtsi b/arch/arm64/boot/dts/rockchip/rk3588-turing-rk1.dtsi
index 711ac4f2c7cb..60ad272982ad 100644
--- a/arch/arm64/boot/dts/rockchip/rk3588-turing-rk1.dtsi
+++ b/arch/arm64/boot/dts/rockchip/rk3588-turing-rk1.dtsi
@@ -214,6 +214,8 @@ rgmii_phy: ethernet-phy@1 {
 };
 
 &package_thermal {
+	polling-delay = <1000>;
+
 	trips {
 		package_active1: trip-active1 {
 			temperature = <45000>;
-- 
2.49.0



