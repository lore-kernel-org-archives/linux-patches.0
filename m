Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795049083;
	b=ObDeBJmZbdDhAnQHjJBtE+0+1LkD1Bw97peC/7DbWsj+WRUcjsXUdNuK6QfimNbpXXe6
	 +bPAzghr06vSQLXmUfUs5OSSWZVpvvm0+6Da4bgNeQBJ1ZV3NOJD8uWOvyRv0nAosBm/H
	 WnDGo0cPllEtR0/7ljFvRfpCzVgRarpj1rA5skala9dkzYnne3T9Cfc2I+cvxQbLYGRnr
	 kUN6e+O3TOGbSi8/SSm1V++Lc83TCxfQlxLyVxeeaOFBkuglyEORyQoShSdN+wGWC6Yl+
	 pl0D8NpfTVIPH9pVZkfHqaMDXNjuVnP7hoJwCrzfd29Gqg/iWpJzrquk28Fmf4JEiWA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795049083;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=wZdv8VgT03yw356tOstA5Ylgm6aEBYAIPeoi7VtRH4Q=;
	b=pzZ+x3VG9CuDF4wixSL43slURYlixD6hSw0fkzr/HOChFWyAc4gcesb+YvDDKYqHBpll
	 e46OqgHGdr2kdCCYRTT6m7tbS5gkeIy2wFUDNW3WcaoEZydvs6+u5L1wj24Z6dctZZ2VF
	 jx+tZ6u5N6uY4VjHZQmdDrS3V6fHDq2x7Cqq04W3Yc80z8gsGD5EBwKOQMxEZeVi6vayl
	 AgbBQs+AEu6ssis6NsZ7nXD/Vin7u85PW7dFQZAM5Jpz+h3dRa/ONprscHhjMbZ9CXHxA
	 1tNS8SHsKd6/3SSFZxp/qt9g8xg+jMWbI6NaDzwV0YBEmMC6+Eg/IeHtqFxXDheKF2w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=iKsIv1pU;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 82740606A31C;
	Thu, 19 Nov 2026 00:44:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=iKsIv1pU
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D09711F000C4;
	Thu, 19 Nov 2026 00:44:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795049083;
	bh=wZdv8VgT03yw356tOstA5Ylgm6aEBYAIPeoi7VtRH4Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=iKsIv1pUSZxjUttZsHBw9xDKEg4NYq0EhaVd/8Gw9tS3/Opn5fzV8pYivEtM9hMCG
	 ixJb5lGoZ7yvOLzElgs8VXcz2mCszsC+yEzTeDAjCO66Oub72MR5GAZPM1zJHePXKv
	 kyOOueGsW8Don80KdRMtN31xvZGgFI97+wSmy9hw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Diederik de Haas <didi.debian@cknow.org>,
	Dragan Simic <dsimic@manjaro.org>,
	Heiko Stuebner <heiko@sntech.de>,
	Sasha Levin <sashal@kernel.org>,
	Jonas Karlman <jonas@kwiboo.se>
Subject: [PATCH 6.1 2223/2857] arm64: dts: rockchip: Add GPU OPP voltage ranges to RK356x SoC dtsi
Date: Wed, 18 Nov 2026 15:54:17 +0100
Message-ID: <20261118150321.458426304@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dragan Simic <dsimic@manjaro.org>

[ Upstream commit 2e1fae80023a38ea03dfca3eab65b3b46617ef3b ]

Add support for voltage ranges to the GPU OPPs defined in the SoC dtsi for
Rockchip RK356x.  This is, for example, useful for RK356x-based boards that
are designed to use the same power supply for the GPU and NPU portions of
the SoC, which is described further in the following documents:

  - Rockchip RK3566 Hardware Design Guide, version 1.1.0, page 37
  - Rockchip RK3568 Hardware Design Guide, version 1.2, page 78

The values for the exact GPU OPP voltages and the lower limits for the GPU
OPP voltage ranges differ from the values found in the vendor kernel source
(cf. downstream commit f8b9431ee38e ("arm64: dts: rockchip: rk3568: support
adjust opp-table by otp")), [1][2] and present the exact GPU OPP voltage
values that have served us well so far.

[1] https://github.com/rockchip-linux/kernel/commit/f8b9431ee38ed561650be7092ab93f564598daa9
[2] https://raw.githubusercontent.com/rockchip-linux/kernel/f8b9431ee38ed561650be7092ab93f564598daa9/arch/arm64/boot/dts/rockchip/rk3568.dtsi

Suggested-by: Diederik de Haas <didi.debian@cknow.org>
Helped-by: Jonas Karlman <jonas@kwiboo.se>
Signed-off-by: Dragan Simic <dsimic@manjaro.org>
Link: https://lore.kernel.org/r/7e9ba70fd54a21d6f1f267df11e0acabff8d24e0.1719763100.git.dsimic@manjaro.org
Signed-off-by: Heiko Stuebner <heiko@sntech.de>
Stable-dep-of: 8043ed0f40fe ("arm64: dts: rockchip: Rename rk3566 and rk3568 HDMI audio cards")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/rockchip/rk356x.dtsi | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/arch/arm64/boot/dts/rockchip/rk356x.dtsi b/arch/arm64/boot/dts/rockchip/rk356x.dtsi
index 266f281140ae4..af1f809eb3762 100644
--- a/arch/arm64/boot/dts/rockchip/rk356x.dtsi
+++ b/arch/arm64/boot/dts/rockchip/rk356x.dtsi
@@ -195,32 +195,32 @@ gpu_opp_table: opp-table-1 {
 
 		opp-200000000 {
 			opp-hz = /bits/ 64 <200000000>;
-			opp-microvolt = <825000>;
+			opp-microvolt = <825000 825000 1000000>;
 		};
 
 		opp-300000000 {
 			opp-hz = /bits/ 64 <300000000>;
-			opp-microvolt = <825000>;
+			opp-microvolt = <825000 825000 1000000>;
 		};
 
 		opp-400000000 {
 			opp-hz = /bits/ 64 <400000000>;
-			opp-microvolt = <825000>;
+			opp-microvolt = <825000 825000 1000000>;
 		};
 
 		opp-600000000 {
 			opp-hz = /bits/ 64 <600000000>;
-			opp-microvolt = <825000>;
+			opp-microvolt = <825000 825000 1000000>;
 		};
 
 		opp-700000000 {
 			opp-hz = /bits/ 64 <700000000>;
-			opp-microvolt = <900000>;
+			opp-microvolt = <900000 900000 1000000>;
 		};
 
 		opp-800000000 {
 			opp-hz = /bits/ 64 <800000000>;
-			opp-microvolt = <1000000>;
+			opp-microvolt = <1000000 1000000 1000000>;
 		};
 	};
 
-- 
2.53.0



