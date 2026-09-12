Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 76A1178C9C;
	Sat, 12 Sep 2026 14:39:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789223988; cv=none; b=Z8uhVXfA43SshJk6V6SAcbcfo4157NXfxZ6hL5HJqDlUXplT/Ys9qP3wJfH4n6wMBznFNL9j1hrof2Cbl97zPvnaCu5JAjB+kJoQ2BcJ1AkdaXzESnzKiIWx+WTSNRy2cIhQTFjW88q+MOaIpP7QhCzOuatzS38tAeQ3QAq1j3c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789223988; c=relaxed/simple;
	bh=YNfOJ4ywIFeHVxR7wh8HPubjrBJAigp+b+INmzKd51E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=b2f5g/iQtGEcg98jb+XicLGmUMy8rSdzFRWQbhICBc8i+xNoPriMesUtCzWcsixM3zpTCF+YJPp4R2mm3kUH2f7AlfCogGWpeu6/fRuy392CQb3LEGWFuxFSMikyFFQ/l7FlPlVYpxoMetklIkQLkUSh+ykRE+ON2MtUpWPuviA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vLrYeFjn; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vLrYeFjn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 172A91F000FF;
	Sat, 12 Sep 2026 14:39:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789223987;
	bh=jNoZov3GYXbyw07VGFmBuOYyQ9yqbKBZ6emx91dckf4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=vLrYeFjn9cH96PhIbJpBDgIqEiYR1E33efbtwokSYtbaIJKfkXqHCIo8ERR/YyuqA
	 Yl0UPeQZsrMmND+noeSuBtYbBOp3J6p8BeWxaKlGs9WnkQXsV9LT5gnQHZmfLjg7Uk
	 v2j96UbndD/kQKUGcduEJ2jy6nHv09UUz3ukUL90=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ondrej Jirman <megi@xff.cz>,
	Chen-Yu Tsai <wens@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0899/1424] arm64: dts: allwinner: sun50i-a64-pinephone: Fix mpu6050 mount matrix
Date: Sat, 12 Sep 2026 08:55:31 +0200
Message-ID: <20260912065627.461122747@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.279695368@linuxfoundation.org>
References: <20260912065607.279695368@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index b0885a3899510..75116ae701f89 100644
--- a/arch/arm64/boot/dts/allwinner/sun50i-a64-pinephone.dtsi
+++ b/arch/arm64/boot/dts/allwinner/sun50i-a64-pinephone.dtsi
@@ -202,8 +202,8 @@ accelerometer@68 {
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



