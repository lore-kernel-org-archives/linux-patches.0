Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C17DF22579E;
	Wed, 25 Feb 2026 01:30:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771983046; cv=none; b=lgKiOr+vaXGrcDHOi38Vv6enktVwbYnOQxN3Yk1DscCU3/wpVlbKYGqbUziaJQOcWNvsz4pi467WqJ/LGo/y8MJXq+Z6dQubx0YaYI/+6tv4CdxyXy2V6mYV9ZzdsLZiaUtVRlv+9pzuQ7vO1T6FIK+gvgZ22auhxDYDNCIy2Cc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771983046; c=relaxed/simple;
	bh=B4rBl/jpiRWz5BQNF624H/faO+d8q269yIupzcnOzKw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QolgQQVlcumq0TO51f6T7NmeQRH5GR341nmdDvfnc3UgVpBhKt3Gr1dqChH5asySQcAbnbama0V3al0yaX9YwWpoPBSYKABdM5s0VlRxi8dssM3ny1ue1mdDDlH615hEg4jQeNOfnG1CoDUz643xWiJvUCm/rggVr9WOnt/Le/0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Lqvdt/2c; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Lqvdt/2c"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 82C62C116D0;
	Wed, 25 Feb 2026 01:30:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1771983046;
	bh=B4rBl/jpiRWz5BQNF624H/faO+d8q269yIupzcnOzKw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Lqvdt/2c2mQLSJLkMJ8DmWSFM2R9+8D0nYzrnH4pENuYaBnOkGCG+zjqYMn6zPjX6
	 NaPWbNUCcGlmo/ikLdohkpM1qTkwAeZ79+efpX38sYk4telrAMlxcPyM15lIGDuYHo
	 LDhHMzh1NBQWCrPW0yObbgtoerts+S05YdPpEEyg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vladimir Zapolskiy <vz@mleia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 167/781] arm: dts: lpc32xx: add clocks property to Motor Control PWM device tree node
Date: Tue, 24 Feb 2026 17:14:36 -0800
Message-ID: <20260225012403.744582725@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260225012359.695468795@linuxfoundation.org>
References: <20260225012359.695468795@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Vladimir Zapolskiy <vz@mleia.com>

[ Upstream commit 71630e581a0e34c03757f5c1706f57c853b92555 ]

Motor Control PWM depends on its own supply clock, the clock gate control
is present in TIMCLK_CTRL1 register.

Fixes: b7d41c937ed7 ("ARM: LPC32xx: Add the motor PWM to base dts file")
Signed-off-by: Vladimir Zapolskiy <vz@mleia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/nxp/lpc/lpc32xx.dtsi | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm/boot/dts/nxp/lpc/lpc32xx.dtsi b/arch/arm/boot/dts/nxp/lpc/lpc32xx.dtsi
index 2236901a00313..8e9ed93da129e 100644
--- a/arch/arm/boot/dts/nxp/lpc/lpc32xx.dtsi
+++ b/arch/arm/boot/dts/nxp/lpc/lpc32xx.dtsi
@@ -302,6 +302,7 @@ i2c2: i2c@400a8000 {
 			mpwm: pwm@400e8000 {
 				compatible = "nxp,lpc3220-motor-pwm";
 				reg = <0x400e8000 0x78>;
+				clocks = <&clk LPC32XX_CLK_MCPWM>;
 				#pwm-cells = <3>;
 				status = "disabled";
 			};
-- 
2.51.0



