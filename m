Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8DFB82472A0;
	Tue, 20 May 2025 14:18:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747750702; cv=none; b=lU2Yhq4hbQj+GwYT2Ffx5/xePhcWLSp0tlPNHKFC+YIdBfmvXaCfUfkk3UOUqul6vXPsmMHyvNt1s0u8YisI1XMtMKqZ7xzi6ZQy1PaqicLHgLZqjTFHtH7PFZ3m49XJ6IJTniZWg/A/gylNeOBK/QuQFwtU4f0WWWm1h/AHP4s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747750702; c=relaxed/simple;
	bh=PoxhI78+WIguACWID+W4ZcmHmQdD4GeJlDqsa6+/pwM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=X7DLH89IqmyMaRkIIVtfWV2QjukDk6Xev3lA8yt17m652C1Q3Zu3H2tFZUiwmxd+jNSQ1O+IcGSmBB1zuYSlpZ2LeoQoZqufACBJVIG5xaDxSAUPxEVkVy3Ot6wd9DExSFAXJf1C3gFDT6FKUV/WBORcfXBmfD05WloIyPknyGc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=glf2I7Dj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="glf2I7Dj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0EA8EC4CEE9;
	Tue, 20 May 2025 14:18:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1747750702;
	bh=PoxhI78+WIguACWID+W4ZcmHmQdD4GeJlDqsa6+/pwM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=glf2I7DjWfQrWgIdCdCy+OaSveZen7jzRvHF/SC3OEzud12N5Xihd2SOg60ZIgn2o
	 ZmyLW0HkDr+ArrUX/Qo+OOkNb37C4vpQ8EZtt6vxtwhzFz7HtxrD+5OGkS81x4AmVp
	 Twrjm4yKyFwrv6x8+nTp13M3Mq7G/uCWgFVh/inQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Heiko Stuebner <heiko@sntech.de>,
	Alexey Charkov <alchark@gmail.com>,
	Quentin Schulz <quentin.schulz@cherry.de>,
	Dragan Simic <dsimic@manjaro.org>
Subject: [PATCH 6.14 094/145] arm64: dts: rockchip: Remove overdrive-mode OPPs from RK3588J SoC dtsi
Date: Tue, 20 May 2025 15:51:04 +0200
Message-ID: <20250520125814.247548448@linuxfoundation.org>
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

From: Dragan Simic <dsimic@manjaro.org>

commit e0bd7ecf6b2dc71215af699dffbf14bf0bc3d978 upstream.

The differences in the vendor-approved CPU and GPU OPPs for the standard
Rockchip RK3588 variant [1] and the industrial Rockchip RK3588J variant [2]
come from the latter, presumably, supporting an extended temperature range
that's usually associated with industrial applications, despite the two SoC
variant datasheets specifying the same upper limit for the allowed ambient
temperature for both variants.  However, the lower temperature limit is
specified much lower for the RK3588J variant. [1][2]

To be on the safe side and to ensure maximum longevity of the RK3588J SoCs,
only the CPU and GPU OPPs that are declared by the vendor to be always safe
for this SoC variant may be provided.  As explained by the vendor [3] and
according to the RK3588J datasheet, [2] higher-frequency/higher-voltage
CPU and GPU OPPs can be used as well, but at the risk of reducing the SoC
lifetime expectancy.  Presumably, using the higher OPPs may be safe only
when not enjoying the assumed extended temperature range that the RK3588J,
as an SoC variant targeted specifically at higher-temperature, industrial
applications, is made (or binned) for.

Anyone able to keep their RK3588J-based board outside the above-presumed
extended temperature range at all times, and willing to take the associated
risk of possibly reducing the SoC lifetime expectancy, is free to apply
a DT overlay that adds the higher CPU and GPU OPPs.

With all this and the downstream RK3588(J) DT definitions [4][5] in mind,
let's delete the RK3588J CPU and GPU OPPs that are not considered belonging
to the normal operation mode for this SoC variant.  To quote the RK3588J
datasheet [2], "normal mode means the chipset works under safety voltage
and frequency;  for the industrial environment, highly recommend to keep in
normal mode, the lifetime is reasonably guaranteed", while "overdrive mode
brings higher frequency, and the voltage will increase accordingly;  under
the overdrive mode for a long time, the chipset may shorten the lifetime,
especially in high-temperature condition".

To sum the RK3588J datasheet [2] and the vendor-provided DTs up, [4][5]
the maximum allowed CPU core, GPU and NPU frequencies are as follows:

   IP core    | Normal mode | Overdrive mode
  ------------+-------------+----------------
   Cortex-A55 |   1,296 MHz |      1,704 MHz
   Cortex-A76 |   1,608 MHz |      2,016 MHz
   GPU        |     700 MHz |        850 MHz
   NPU        |     800 MHz |        950 MHz

Unfortunately, when it comes to the actual voltages for the RK3588J CPU and
GPU OPPs, there's a discrepancy between the RK3588J datasheet [2] and the
downstream kernel code. [4][5]  The RK3588J datasheet states that "the max.
working voltage of CPU/GPU/NPU is 0.75 V under the normal mode", while the
downstream kernel code actually allows voltage ranges that go up to 0.95 V,
which is still within the voltage range allowed by the datasheet.  However,
the RK3588J datasheet also tells us to "strictly refer to the software
configuration of SDK and the hardware reference design", so let's embrace
the voltage ranges provided by the downstream kernel code, which also
prevents the undesirable theoretical outcome of ending up with no usable
OPPs on a particular board, as a result of the board's voltage regulator(s)
being unable to deliver the exact voltages, for whatever reason.

The above-described voltage ranges for the RK3588J CPU OPPs remain taken
from the downstream kernel code [4][5] by picking the highest, worst-bin
values, which ensure that all RK3588J bins will work reliably.  Yes, with
some power inevitably wasted as unnecessarily generated heat, but the
reliability is paramount, together with the longevity.  This deficiency
may be revisited separately at some point in the future.

The provided RK3588J CPU OPPs follow the slightly debatable "provide only
the highest-frequency OPP from the same-voltage group" approach that's been
established earlier, [6] as a result of the "same-voltage, lower-frequency"
OPPs being considered inefficient from the IPA governor's standpoint, which
may also be revisited separately at some point in the future.

[1] https://wiki.friendlyelec.com/wiki/images/e/ee/Rockchip_RK3588_Datasheet_V1.6-20231016.pdf
[2] https://wmsc.lcsc.com/wmsc/upload/file/pdf/v2/lcsc/2403201054_Rockchip-RK3588J_C22364189.pdf
[3] https://lore.kernel.org/linux-rockchip/e55125ed-64fb-455e-b1e4-cebe2cf006e4@cherry.de/T/#u
[4] https://raw.githubusercontent.com/rockchip-linux/kernel/604cec4004abe5a96c734f2fab7b74809d2d742f/arch/arm64/boot/dts/rockchip/rk3588s.dtsi
[5] https://raw.githubusercontent.com/rockchip-linux/kernel/604cec4004abe5a96c734f2fab7b74809d2d742f/arch/arm64/boot/dts/rockchip/rk3588j.dtsi
[6] https://lore.kernel.org/all/20240229-rk-dts-additions-v3-5-6afe8473a631@gmail.com/

Fixes: 667885a68658 ("arm64: dts: rockchip: Add OPP data for CPU cores on RK3588j")
Fixes: a7b2070505a2 ("arm64: dts: rockchip: Split GPU OPPs of RK3588 and RK3588j")
Cc: stable@vger.kernel.org
Cc: Heiko Stuebner <heiko@sntech.de>
Cc: Alexey Charkov <alchark@gmail.com>
Helped-by: Quentin Schulz <quentin.schulz@cherry.de>
Reviewed-by: Quentin Schulz <quentin.schulz@cherry.de>
Signed-off-by: Dragan Simic <dsimic@manjaro.org>
Link: https://lore.kernel.org/r/eeec0d30d79b019d111b3f0aa2456e69896b2caa.1742813866.git.dsimic@manjaro.org
Signed-off-by: Heiko Stuebner <heiko@sntech.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/boot/dts/rockchip/rk3588j.dtsi |   53 +++++++++---------------------
 1 file changed, 17 insertions(+), 36 deletions(-)

--- a/arch/arm64/boot/dts/rockchip/rk3588j.dtsi
+++ b/arch/arm64/boot/dts/rockchip/rk3588j.dtsi
@@ -11,20 +11,15 @@
 		compatible = "operating-points-v2";
 		opp-shared;
 
-		opp-1416000000 {
-			opp-hz = /bits/ 64 <1416000000>;
+		opp-1200000000 {
+			opp-hz = /bits/ 64 <1200000000>;
 			opp-microvolt = <750000 750000 950000>;
 			clock-latency-ns = <40000>;
 			opp-suspend;
 		};
-		opp-1608000000 {
-			opp-hz = /bits/ 64 <1608000000>;
-			opp-microvolt = <887500 887500 950000>;
-			clock-latency-ns = <40000>;
-		};
-		opp-1704000000 {
-			opp-hz = /bits/ 64 <1704000000>;
-			opp-microvolt = <937500 937500 950000>;
+		opp-1296000000 {
+			opp-hz = /bits/ 64 <1296000000>;
+			opp-microvolt = <775000 775000 950000>;
 			clock-latency-ns = <40000>;
 		};
 	};
@@ -33,9 +28,14 @@
 		compatible = "operating-points-v2";
 		opp-shared;
 
+		opp-1200000000{
+			opp-hz = /bits/ 64 <1200000000>;
+			opp-microvolt = <750000 750000 950000>;
+			clock-latency-ns = <40000>;
+		};
 		opp-1416000000 {
 			opp-hz = /bits/ 64 <1416000000>;
-			opp-microvolt = <750000 750000 950000>;
+			opp-microvolt = <762500 762500 950000>;
 			clock-latency-ns = <40000>;
 		};
 		opp-1608000000 {
@@ -43,25 +43,20 @@
 			opp-microvolt = <787500 787500 950000>;
 			clock-latency-ns = <40000>;
 		};
-		opp-1800000000 {
-			opp-hz = /bits/ 64 <1800000000>;
-			opp-microvolt = <875000 875000 950000>;
-			clock-latency-ns = <40000>;
-		};
-		opp-2016000000 {
-			opp-hz = /bits/ 64 <2016000000>;
-			opp-microvolt = <950000 950000 950000>;
-			clock-latency-ns = <40000>;
-		};
 	};
 
 	cluster2_opp_table: opp-table-cluster2 {
 		compatible = "operating-points-v2";
 		opp-shared;
 
+		opp-1200000000{
+			opp-hz = /bits/ 64 <1200000000>;
+			opp-microvolt = <750000 750000 950000>;
+			clock-latency-ns = <40000>;
+		};
 		opp-1416000000 {
 			opp-hz = /bits/ 64 <1416000000>;
-			opp-microvolt = <750000 750000 950000>;
+			opp-microvolt = <762500 762500 950000>;
 			clock-latency-ns = <40000>;
 		};
 		opp-1608000000 {
@@ -69,16 +64,6 @@
 			opp-microvolt = <787500 787500 950000>;
 			clock-latency-ns = <40000>;
 		};
-		opp-1800000000 {
-			opp-hz = /bits/ 64 <1800000000>;
-			opp-microvolt = <875000 875000 950000>;
-			clock-latency-ns = <40000>;
-		};
-		opp-2016000000 {
-			opp-hz = /bits/ 64 <2016000000>;
-			opp-microvolt = <950000 950000 950000>;
-			clock-latency-ns = <40000>;
-		};
 	};
 
 	gpu_opp_table: opp-table {
@@ -104,10 +89,6 @@
 			opp-hz = /bits/ 64 <700000000>;
 			opp-microvolt = <750000 750000 850000>;
 		};
-		opp-850000000 {
-			opp-hz = /bits/ 64 <800000000>;
-			opp-microvolt = <787500 787500 850000>;
-		};
 	};
 };
 


