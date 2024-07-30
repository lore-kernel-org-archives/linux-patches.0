Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5024E1A6176;
	Tue, 30 Jul 2024 16:11:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722355894; cv=none; b=keUlPBYQ2WR13bSD6fFu330EjEmzLhujinOIjpeSDhKYEzapSRS9qkQMvdNzQp1BOAygnHif0ic0hf8GwsS2y7W3R0Dnwrx0D7BJl6usDlCdSE12rlYlZOKZtZSxhvgZpiKg5Tx3PRU9cL7iekF9ApJUH+n9Gq7TcN9l6X6PjvM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722355894; c=relaxed/simple;
	bh=tbORv7XTZAC4YidNxwM7AJyAncAkT65Z9+SdeG+KZq4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=vFh71m3UnQdM3BSjYliuclHLUrlUHFpaZ1Ge7Xj1y01iZjT1cloEBFu6ahwPyYbMIAi5Rx/C9CJoA29rWaCHb3M9eg61UJ1x3TizEz8WZAVa17xO/ls7H7lh2BQZD+WRJ9XVqzP01yUUaLbCG7IostJ/iZ0izxliB6Izl21AoX8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jfT8lxbN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jfT8lxbN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B9FCBC4AF0C;
	Tue, 30 Jul 2024 16:11:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722355894;
	bh=tbORv7XTZAC4YidNxwM7AJyAncAkT65Z9+SdeG+KZq4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jfT8lxbNHUppIZ3zTaU5/vPO9YypwYt1tOE2xcIqYJaUtUrZcpHl8bUSQOfH+kw+Y
	 I9ATJzW6sohrjYlyw3pTvAtLXFiuiG2ObRfKBNTZzSx0DXF46LFRvU5YhM0xYERzMo
	 ywfqXTlXD5nRDeB5QBTJbLbvUzTyZhFN351gw8F8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chukun Pan <amadeus@jmu.edu.cn>,
	Heiko Stuebner <heiko@sntech.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 100/568] arm64: dts: rockchip: disable display subsystem for Lunzn Fastrhino R6xS
Date: Tue, 30 Jul 2024 17:43:27 +0200
Message-ID: <20240730151643.784491007@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151639.792277039@linuxfoundation.org>
References: <20240730151639.792277039@linuxfoundation.org>
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

From: Chukun Pan <amadeus@jmu.edu.cn>

[ Upstream commit 2bf5d445df2ec89689d15ea259a916260c936959 ]

The R66S and R68S boards do not have HDMI output, so disable
the display subsystem.

Fixes: c79dab407afd ("arm64: dts: rockchip: Add Lunzn Fastrhino R66S")
Signed-off-by: Chukun Pan <amadeus@jmu.edu.cn>
Link: https://lore.kernel.org/r/20240701143028.1203997-3-amadeus@jmu.edu.cn
Signed-off-by: Heiko Stuebner <heiko@sntech.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/rockchip/rk3568-fastrhino-r66s.dtsi | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/arch/arm64/boot/dts/rockchip/rk3568-fastrhino-r66s.dtsi b/arch/arm64/boot/dts/rockchip/rk3568-fastrhino-r66s.dtsi
index e08c9eab6f170..25c49bdbadbcb 100644
--- a/arch/arm64/boot/dts/rockchip/rk3568-fastrhino-r66s.dtsi
+++ b/arch/arm64/boot/dts/rockchip/rk3568-fastrhino-r66s.dtsi
@@ -115,6 +115,10 @@ &cpu3 {
 	cpu-supply = <&vdd_cpu>;
 };
 
+&display_subsystem {
+	status = "disabled";
+};
+
 &gpu {
 	mali-supply = <&vdd_gpu>;
 	status = "okay";
-- 
2.43.0



