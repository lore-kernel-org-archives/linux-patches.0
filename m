Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5742239B949
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:15:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772302542; cv=none; b=ZaV+eXiTfFlbFPN3YT4O0vdRheQZEkX4UXRvlhbvSU9wHKIePk7EbIcYoNi+GKph+kaYGVou/FT9S6PyCvCehQ6TdpRwZJhIwi0a0ADYb3PU/867kHr70HsojK8UhXDigQI+8T1xaU7Pay+XGre0jZa7IK4LjsvLfF8nCn4sLSw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772302542; c=relaxed/simple;
	bh=ilqB3x3lZTcyaQqNkmvOWNwYYMUQOrEoy7u7k92dKYk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Wx8vjlyKMxugNiO/fhUXoPVQ/kgm3/DCo1HAZcDJaZ9OTL7+8DxIhqnKxW1Y7B46mP+aou/Q5K8NzoWRBY+juPHc5GVz/IrWW41vXm+HuTiq/C2SMTaDvT7sQPkGru4nDJNVBYCg7XJaBu6zh3u7LWzbmwLWnb/aDD9W9FzFB9w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Fhj4Vdb+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Fhj4Vdb+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9E5CEC19425;
	Sat, 28 Feb 2026 18:15:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772302542;
	bh=ilqB3x3lZTcyaQqNkmvOWNwYYMUQOrEoy7u7k92dKYk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Fhj4Vdb+kPNfD1Fx5RvQwKKM0zdUS/HnSUdGzi5mGtpIeldE95QGd4m0m4/SQEWn8
	 wOBBBXURS/RXHNpM9ZcZO4hGCknJpHEf6af8AX8oqmJ6iiWpESSSD9zR1/bSdemxxb
	 1R3wwEmxjHEdgr5M4TI3eaTyFTqYCt7q58iP46HhJBynC1TpM2YiVKEk+hpVjFVZs8
	 LCJ7H9hqdGLFrVo3iJO5kfm1RHbxL0AzVsgzfONr/5GABl0UgIcIMfzpZzMNqByeHr
	 q++BzoZtxMMFHGWq2p9KrBZx6Hp1e1HVXVND0AFJjjHqs4OqEz7OPP/vJ9LJSMXXk/
	 Xwo6MGWr59FzA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Vladimir Zapolskiy <vz@mleia.com>,
	=?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= <u.kleine-koenig@baylibre.com>,
	Frank Li <Frank.Li@nxp.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 043/164] ARM: dts: lpc32xx: Set motor PWM #pwm-cells property value to 3 cells
Date: Sat, 28 Feb 2026 13:13:02 -0500
Message-ID: <20260228181505.1600663-43-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228181505.1600663-1-sashal@kernel.org>
References: <20260228181505.1600663-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Vladimir Zapolskiy <vz@mleia.com>

[ Upstream commit 65ae9ea77e1f2a20ad2866f99596df7ccdbd3b95 ]

Since commit 4cd2f417a0ac ("dt-bindings: pwm: Convert lpc32xx-pwm.txt
to yaml format") both types of PWM controlles on NXP LPC32xx SoC
fairly gained 3 cells, reflect it in the platform dtsi file.

The change removes a dt binding checker warning:

    mpwm@400e8000: #pwm-cells:0:0: 3 was expected

Cc: Uwe Kleine-König <u.kleine-koenig@baylibre.com>
Acked-by: Uwe Kleine-König <u.kleine-koenig@baylibre.com>
Reviewed-by: Frank Li <Frank.Li@nxp.com>
Signed-off-by: Vladimir Zapolskiy <vz@mleia.com>
Stable-dep-of: 71630e581a0e ("arm: dts: lpc32xx: add clocks property to Motor Control PWM device tree node")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/lpc32xx.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/boot/dts/lpc32xx.dtsi b/arch/arm/boot/dts/lpc32xx.dtsi
index c87066d6c9950..4fb5d9dae1850 100644
--- a/arch/arm/boot/dts/lpc32xx.dtsi
+++ b/arch/arm/boot/dts/lpc32xx.dtsi
@@ -301,8 +301,8 @@ i2c2: i2c@400a8000 {
 			mpwm: mpwm@400e8000 {
 				compatible = "nxp,lpc3220-motor-pwm";
 				reg = <0x400e8000 0x78>;
+				#pwm-cells = <3>;
 				status = "disabled";
-				#pwm-cells = <2>;
 			};
 		};
 
-- 
2.51.0

