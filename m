Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA4CF48CFC;
	Sat, 12 Sep 2026 08:01:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789200067; cv=none; b=L8eh7m/8k9krxSoVZPPmot3ahEFq/MGcCotZOZwmfj2clr77MJM8QKDvSPehloWZSQYKac9YZBiZ0pAEvraL/HMp3iPJbTsg9Ewk931T3Jfu4AcxJxLeIL3piEhY14zro0lq1SW94VR6Fox6Qy0DYxNnb3Zev5u/H3ZlbLfEuXE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789200067; c=relaxed/simple;
	bh=y6hmmfLHbLzeaVEAKTMidtuWn8X+azxCTaOcRbMCHbA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=S60XC8wURRWcK80JPHEn2FYoLKoCQBSYe6chWEQ64y4hs6FyTItmfUBoZBIjBJNODQXw3xmcLs+++gPh5srNkJuaG31oIftnjN6C9E/+XyJ/j22qd1TEfjXcw+cyZJT54uV5zUO2lvfpO+6xvlMUgnD6+44U2jQ6VA2w/7qqeSk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yvmWD6ch; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yvmWD6ch"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 605691F000FF;
	Sat, 12 Sep 2026 08:01:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789200065;
	bh=kkSVhSu03sKL9mHCcF51RCGal9EbzienavuMMC0AlhM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=yvmWD6chL/PYZzpbDHlpt9piePHFsiQM53No+t87p61HBCHcmMfR2YsDOJdC+phMr
	 bbFwuobIny/PstXgrID6jyDOKZGVdbhLsJg13deyMDOC/dr05l0t8/i0Z6Sf9rxA3z
	 dwkqMMcruSXoSYStK/vgflm3hcp9OJAfRSckc+QY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ondrej Jirman <megi@xff.cz>,
	Chen-Yu Tsai <wens@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 0713/1815] arm64: dts: allwinner: sun50i-a64-pinephone: Fix mpu6050 mount matrix
Date: Sat, 12 Sep 2026 08:41:03 +0200
Message-ID: <20260912065705.635593597@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

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
index 4bc6c1ef2cde4..f958bdbb0d333 100644
--- a/arch/arm64/boot/dts/allwinner/sun50i-a64-pinephone.dtsi
+++ b/arch/arm64/boot/dts/allwinner/sun50i-a64-pinephone.dtsi
@@ -230,8 +230,8 @@ accelerometer@68 {
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



