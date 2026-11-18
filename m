Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795018235;
	b=h0yp0jj7fAkitHNtJhox7evcrH3acSztZ+pJNmjEmNR3tuqGo35/p/y485hDdXoqMTLv
	 s9JyJpxWmE2ncilCss3m8N5aGCsnCvn53IA3QfI7XZsuIiUY+liwDbOfjkQHQozpZFQoT
	 tIvEuSR4U0rpd1rGMzfWiurfwhh7BqJrOlE1ttknYv3Swn5n02Osr/oLxAHwf6NZxvQv6
	 ooErVzPg8oP2OQJCxOSDbflStGffLY/30BsV7thzcMNgRhVxX/Dgvw8AIC8t5Mz7yvsev
	 Fj2gJwi5B4nTK1FjQ4TsNj5clkOb5rkBI8fBGuzEBSmPVx9sejPV+EV1AJjvFXnmqnA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795018235;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Exsagz1J6sNvcSUlngo0oPMr4o0EBv5ELDjt1RzrXiY=;
	b=YD3vz3rKhqs/8+PedJ70oNIeKqK/ub444F0moeTjVRQ9L3+X4QlP527LImCunrZqPyGF
	 PH5suK4yzPe6siiPBoTyHyf2Wj/OS+SALP9HWPVfsSr8B/roFT2uWXkh909uByELFj3R+
	 qSB3HCLDr4F6AuoRn301Yx3RR9hxqOlfHcTfGkBXCVG6C5nnues1Efn3sSFBhse7wAGTZ
	 ILBiYZE+rSU2wGm1Gqwy8r13gW15cANB5ZIkbE2/hevm/oKQcO+XziTVidEFq6NeNdKX+
	 8B2OZ9/oyFxnXlz88QPEiJCGwhCptRvV7w1OaSU5QsCilNtQ4MZjuWZfD/ea2GvcNng==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=HdBMuP85;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 85FC1606A31C;
	Wed, 18 Nov 2026 16:10:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=HdBMuP85
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DEC781F000C4;
	Wed, 18 Nov 2026 16:10:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795018235;
	bh=Exsagz1J6sNvcSUlngo0oPMr4o0EBv5ELDjt1RzrXiY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=HdBMuP85BzUEeBH/CAUQsTIGvsYhp5pp7shSqPbEjMTqS7R8BKbf3xPAMUqRFwNRo
	 KDKaGvfxYQy2U67eH/2zt+LXHG680c64rgIjghzM/U9LjkVY/79DYCHsvXsUY3RLih
	 6Yg9gWyfwCNduiYmO9Sp0Dq1/5fym4UH1Le94eBY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Junhui Liu <junhui.liu@pigmoral.tech>,
	Yixun Lan <dlan@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1167/2651] riscv: dts: spacemit: k3: Replace incorrect CLINT node with ACLINT nodes
Date: Wed, 18 Nov 2026 15:40:07 +0100
Message-ID: <20261118150330.023555150@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Junhui Liu <junhui.liu@pigmoral.tech>

[ Upstream commit cc6371a7f5195387584e56054f3af671ff7354dc ]

The K3 implements separate ACLINT MSWI, MTIMER and SSWI devices. The
existing CLINT node at 0xe081c000 incorrectly describes the SSWI
register space in the non-secure window as a legacy CLINT.

The ACLINT register space is mapped at two base addresses: a secure
window at 0xf1810000 and a non-secure window at 0xe0810000. The
secure window exposes all three components, while the non-secure
window only exposes SSWI; the MSWI and MTIMER offsets are reserved
there. Moreover, depending on the eFuse configuration, the non-secure
window may be entirely inaccessible, whereas the secure window is
always available.

Replace the CLINT node with the three ACLINT devices, all using
secure-window addresses: MSWI and MTIMER for machine-level firmware
such as OpenSBI, and SSWI for supervisor software interrupts.

Fixes: 56f37e391a62 ("riscv: dts: spacemit: add initial support for K3 SoC")
Signed-off-by: Junhui Liu <junhui.liu@pigmoral.tech>
Reviewed-by: Yixun Lan <dlan@kernel.org>
Link: https://patch.msgid.link/20260918-k3-aclint-v3-6-cf4fd4050e14@pigmoral.tech
Signed-off-by: Yixun Lan <dlan@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/riscv/boot/dts/spacemit/k3.dtsi | 43 +++++++++++++++++++---------
 1 file changed, 30 insertions(+), 13 deletions(-)

diff --git a/arch/riscv/boot/dts/spacemit/k3.dtsi b/arch/riscv/boot/dts/spacemit/k3.dtsi
index b8c3fe5dbaa80..af56ab9f543a1 100644
--- a/arch/riscv/boot/dts/spacemit/k3.dtsi
+++ b/arch/riscv/boot/dts/spacemit/k3.dtsi
@@ -1258,19 +1258,6 @@ saplic: interrupt-controller@e0804000 {
 			riscv,num-sources = <512>;
 		};
 
-		clint: timer@e081c000 {
-			compatible = "spacemit,k3-clint", "sifive,clint0";
-			reg = <0x0 0xe081c000 0x0 0x4000>;
-			interrupts-extended = <&cpu0_intc 3>, <&cpu0_intc 7>,
-					      <&cpu1_intc 3>, <&cpu1_intc 7>,
-					      <&cpu2_intc 3>, <&cpu2_intc 7>,
-					      <&cpu3_intc 3>, <&cpu3_intc 7>,
-					      <&cpu4_intc 3>, <&cpu4_intc 7>,
-					      <&cpu5_intc 3>, <&cpu5_intc 7>,
-					      <&cpu6_intc 3>, <&cpu6_intc 7>,
-					      <&cpu7_intc 3>, <&cpu7_intc 7>;
-		};
-
 		/* sec_i2c3: 0xf0614000, not available from Linux */
 
 		mimsic: interrupt-controller@f1000000 {
@@ -1300,5 +1287,35 @@ maplic: interrupt-controller@f1800000 {
 			riscv,num-sources = <512>;
 			status = "reserved";
 		};
+
+		aclint_mswi: interrupt-controller@f1810000 {
+			compatible = "spacemit,k3-aclint-mswi";
+			reg = <0x0 0xf1810000 0x0 0x4000>;
+			interrupts-extended = <&cpu0_intc 3>, <&cpu1_intc 3>,
+					      <&cpu2_intc 3>, <&cpu3_intc 3>,
+					      <&cpu4_intc 3>, <&cpu5_intc 3>,
+					      <&cpu6_intc 3>, <&cpu7_intc 3>;
+		};
+
+		aclint_mtimer: timer@f1814000 {
+			compatible = "spacemit,k3-aclint-mtimer";
+			reg = <0x0 0xf1814000 0x0 0x8000>;
+			reg-names = "mtimecmp";
+			interrupts-extended = <&cpu0_intc 7>, <&cpu1_intc 7>,
+					      <&cpu2_intc 7>, <&cpu3_intc 7>,
+					      <&cpu4_intc 7>, <&cpu5_intc 7>,
+					      <&cpu6_intc 7>, <&cpu7_intc 7>;
+		};
+
+		aclint_sswi: interrupt-controller@f181c000 {
+			compatible = "spacemit,k3-aclint-sswi";
+			reg = <0x0 0xf181c000 0x0 0x4000>;
+			#interrupt-cells = <0>;
+			interrupt-controller;
+			interrupts-extended = <&cpu0_intc 1>, <&cpu1_intc 1>,
+					      <&cpu2_intc 1>, <&cpu3_intc 1>,
+					      <&cpu4_intc 1>, <&cpu5_intc 1>,
+					      <&cpu6_intc 1>, <&cpu7_intc 1>;
+		};
 	};
 };
-- 
2.53.0



