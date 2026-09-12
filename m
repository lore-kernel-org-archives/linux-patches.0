Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 33AB738F255;
	Sat, 12 Sep 2026 19:54:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789242880; cv=none; b=iPjwAHZy+yOvCdOc18H82wrCtDp+oHUFIV5j5GWWcncbWsvxlH4Kw1wOECm78HPALJZ1fQVhlIBEP+qVIClt/C6njbk5pJuuPJSIt5VoknMzC6MLCvqbeDYoeZc2QiX86nM/gdqSeIJboQPFYqjIXVrN7HcDpcEK6k+d3Jd7J5E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789242880; c=relaxed/simple;
	bh=UOgYGPRrSx0N9hztQYeuZ7r+TThknmYyb8aGzlanlY8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ty0/In9s7E4t9vIkPmQAnhqqgo96iWVobsN6pdZbVnJGEXFX8IDNEU0/gU2TE+PyoaQmYwFSHC9sireWI26TYWuVGzhQAcB0rQ9Z05alrA8wTFVyXH3Hps2dYvvPZ6nNabavg4c3tQ01+sB/8G3lvd8NJ/g2plTXwzwywKwO8CQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mWhYCERj; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mWhYCERj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 655671F000FF;
	Sat, 12 Sep 2026 19:54:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789242878;
	bh=+O4HhRUxGO0dihAO7d/HEyDNcgEU8+JjBnAfNHFJgKE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mWhYCERjb1ebRvoJMrq+m/xjlwWw/ZQc3HGizB8ZSIYNHt381eZU+Vk2IW9V1ZslF
	 jzffCC0j5ShHwCcHzlzA5Prv8H9cQk9YMkzgjxj+LtTBBc6una6ybWP9ct1GPj4FfQ
	 EOwgYNrDt9XBQjuEHbvRcgd+0Hj8fVN8y5sohQT8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ondrej Jirman <megi@xff.cz>,
	Chen-Yu Tsai <wens@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 528/798] arm64: dts: allwinner: sun50i-a64-pinephone: Fix mpu6050 mount matrix
Date: Sat, 12 Sep 2026 09:02:36 +0200
Message-ID: <20260912065529.235134193@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065516.948645775@linuxfoundation.org>
References: <20260912065516.948645775@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ondrej Jirman <megi@xff.cz>

[ Upstream commit dfc735fd93e4814e65894916ec5f807f25a391d1 ]

The current mount matrix for mpu6050 is wrong. The mount matrix is a
simple transform from the sensor coordinate space to the device
coordinate space described in DT, where, looking at the screen, X
points to the right, Y to the top, and Z towards the user.

The mpu6050 is mounted like this (looking at the screen from the
front; the sensor is on the near side of the PCB, so its Z axis
points towards the user; o marks the pin 1 corner):

           +Xs
            ^
            |
         +------+
  +Ys <--|      |
         | o    |
         +------+

so this gives:

  Xd = -Ys  [0, -1, 0]
  Yd =  Xs  [1, 0, 0]
  Zd =  Zs  [0, 0, 1]

Fixes: 2496b2aaacf1 ("arm64: dts: allwinner: pinephone: Add mount matrix to accelerometer")
Signed-off-by: Ondrej Jirman <megi@xff.cz>
Link: https://patch.msgid.link/20260725111909.2244868-1-megi@xff.cz
Signed-off-by: Chen-Yu Tsai <wens@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/allwinner/sun50i-a64-pinephone.dtsi | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/boot/dts/allwinner/sun50i-a64-pinephone.dtsi b/arch/arm64/boot/dts/allwinner/sun50i-a64-pinephone.dtsi
index cf872e27d76d3..0ae30473ab0ad 100644
--- a/arch/arm64/boot/dts/allwinner/sun50i-a64-pinephone.dtsi
+++ b/arch/arm64/boot/dts/allwinner/sun50i-a64-pinephone.dtsi
@@ -157,8 +157,8 @@ mpu6050@68 {
 		interrupts = <7 5 IRQ_TYPE_EDGE_RISING>; /* PH5 */
 		vdd-supply = <&reg_dldo1>;
 		vddio-supply = <&reg_dldo1>;
-		mount-matrix = "0", "1", "0",
-			       "-1", "0", "0",
+		mount-matrix = "0", "-1", "0",
+			       "1", "0", "0",
 			       "0", "0", "1";
 	};
 };
-- 
2.53.0



