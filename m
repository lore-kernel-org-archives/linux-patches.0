Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B9F6E1756F;
	Sat,  3 Feb 2024 04:12:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706933565; cv=none; b=gcrcuU9sfPi7sBOyvJMeLOZvMZWCnmKAVFfjK3qA+YzkeLuAj5cRxWm9KV1vg6EQ9LRmP5HrjTbiReAkhSlwyNwgZa7NaE6NSHuifhNNGoZtOjanW1kVW0ClOqn+q6qYYWepvkemeGOwk/CzUfK9npaZpkL14HPU52WpCEx03Fg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706933565; c=relaxed/simple;
	bh=48pMXsbwdB/6WKH0r4ObAU3bcETnjt4uGSnT5pVIGM0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ouVO0PLfoO8oJJlny9iy7RNtljRR6USucc5OaHpgxJ7IH1dhvTX8evWF1DxdtQgOS1JhIhr+gphmQM4hLF9JO7Gcx+x7GkoqRcAqY/lqtPBH5LBJCq33iw8T4ChRXjY4EVEld167IgYmltr48GKjX50KgN+OzF1f8iYknFpOIf4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zxOyPobD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zxOyPobD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8073EC433C7;
	Sat,  3 Feb 2024 04:12:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706933565;
	bh=48pMXsbwdB/6WKH0r4ObAU3bcETnjt4uGSnT5pVIGM0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zxOyPobDMvHu3IEArKlV5gfrHmYswxy2fj02BeXOUFPTjP8qb3M2yQV+LJvQr9fLs
	 lPkVw5/gnhjfds9U4vAPqSfJjna8NjLDqIwppFQK49RVuBZQEKCGYHjojWkAUWX+cX
	 vJVIOMivtmCExQi4EfCLXmDCmvcyzKaiUdWGJLus=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michal Simek <michal.simek@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 120/322] arm64: zynqmp: Fix clock node name in kv260 cards
Date: Fri,  2 Feb 2024 20:03:37 -0800
Message-ID: <20240203035403.014242980@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240203035359.041730947@linuxfoundation.org>
References: <20240203035359.041730947@linuxfoundation.org>
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

From: Michal Simek <michal.simek@amd.com>

[ Upstream commit 0bfb7950cc1975372c4c58c3d3f9803f05245d46 ]

node name shouldn't use '_' that's why convert it to '-'.

Signed-off-by: Michal Simek <michal.simek@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/xilinx/zynqmp-sck-kv-g-revA.dtso | 12 ++++++------
 arch/arm64/boot/dts/xilinx/zynqmp-sck-kv-g-revB.dtso | 12 ++++++------
 2 files changed, 12 insertions(+), 12 deletions(-)

diff --git a/arch/arm64/boot/dts/xilinx/zynqmp-sck-kv-g-revA.dtso b/arch/arm64/boot/dts/xilinx/zynqmp-sck-kv-g-revA.dtso
index dee238739290..92f4190d564d 100644
--- a/arch/arm64/boot/dts/xilinx/zynqmp-sck-kv-g-revA.dtso
+++ b/arch/arm64/boot/dts/xilinx/zynqmp-sck-kv-g-revA.dtso
@@ -22,37 +22,37 @@
 /plugin/;
 
 &{/} {
-	si5332_0: si5332_0 { /* u17 */
+	si5332_0: si5332-0 { /* u17 */
 		compatible = "fixed-clock";
 		#clock-cells = <0>;
 		clock-frequency = <125000000>;
 	};
 
-	si5332_1: si5332_1 { /* u17 */
+	si5332_1: si5332-1 { /* u17 */
 		compatible = "fixed-clock";
 		#clock-cells = <0>;
 		clock-frequency = <25000000>;
 	};
 
-	si5332_2: si5332_2 { /* u17 */
+	si5332_2: si5332-2 { /* u17 */
 		compatible = "fixed-clock";
 		#clock-cells = <0>;
 		clock-frequency = <48000000>;
 	};
 
-	si5332_3: si5332_3 { /* u17 */
+	si5332_3: si5332-3 { /* u17 */
 		compatible = "fixed-clock";
 		#clock-cells = <0>;
 		clock-frequency = <24000000>;
 	};
 
-	si5332_4: si5332_4 { /* u17 */
+	si5332_4: si5332-4 { /* u17 */
 		compatible = "fixed-clock";
 		#clock-cells = <0>;
 		clock-frequency = <26000000>;
 	};
 
-	si5332_5: si5332_5 { /* u17 */
+	si5332_5: si5332-5 { /* u17 */
 		compatible = "fixed-clock";
 		#clock-cells = <0>;
 		clock-frequency = <27000000>;
diff --git a/arch/arm64/boot/dts/xilinx/zynqmp-sck-kv-g-revB.dtso b/arch/arm64/boot/dts/xilinx/zynqmp-sck-kv-g-revB.dtso
index 73c5cb156caf..f88b71f5b07a 100644
--- a/arch/arm64/boot/dts/xilinx/zynqmp-sck-kv-g-revB.dtso
+++ b/arch/arm64/boot/dts/xilinx/zynqmp-sck-kv-g-revB.dtso
@@ -17,37 +17,37 @@
 /plugin/;
 
 &{/} {
-	si5332_0: si5332_0 { /* u17 */
+	si5332_0: si5332-0 { /* u17 */
 		compatible = "fixed-clock";
 		#clock-cells = <0>;
 		clock-frequency = <125000000>;
 	};
 
-	si5332_1: si5332_1 { /* u17 */
+	si5332_1: si5332-1 { /* u17 */
 		compatible = "fixed-clock";
 		#clock-cells = <0>;
 		clock-frequency = <25000000>;
 	};
 
-	si5332_2: si5332_2 { /* u17 */
+	si5332_2: si5332-2 { /* u17 */
 		compatible = "fixed-clock";
 		#clock-cells = <0>;
 		clock-frequency = <48000000>;
 	};
 
-	si5332_3: si5332_3 { /* u17 */
+	si5332_3: si5332-3 { /* u17 */
 		compatible = "fixed-clock";
 		#clock-cells = <0>;
 		clock-frequency = <24000000>;
 	};
 
-	si5332_4: si5332_4 { /* u17 */
+	si5332_4: si5332-4 { /* u17 */
 		compatible = "fixed-clock";
 		#clock-cells = <0>;
 		clock-frequency = <26000000>;
 	};
 
-	si5332_5: si5332_5 { /* u17 */
+	si5332_5: si5332-5 { /* u17 */
 		compatible = "fixed-clock";
 		#clock-cells = <0>;
 		clock-frequency = <27000000>;
-- 
2.43.0



