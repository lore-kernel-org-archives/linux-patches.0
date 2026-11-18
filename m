Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795049086;
	b=hfXAtr42TpmxMgKw7CjCdTU9knhBiUxOv9yDB0lawJ8aKNtY/HQ/MdfJpLuzQeUUpCJX
	 We2WatWOCtpzo4dlGV3j8Y63oE+Mh1e58mlDxQAW/+6fx4PkssGsoymRVW8xB5T+ixXqq
	 JCu0LZCLjduyrc3NQZp9dsG96a+ai6Nc1/OJ3hmOCi6EXM2Eznh2TqrO1aWF35jfl4Esf
	 iBbhCvwRQEYeiZyvpwxKD2Rr/a5wfxEKo8dAdJU5ExltL0OQmd9eATsDhU71cBeceN75R
	 FiK21o9LLCgauYDI6eINlfobS01m24U1Et3sqkYRdgpOu3NmIk+ktrNczXEee2I4QrA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795049086;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=H4As6NK59LMBfR/1c/I4QFlQIpsn9vf3eWI9zcR5V30=;
	b=R7B6K6wGaUnGx+M0MHC9ZNhPoP4H6UZaU50fnltcUeGNjQE336eeldACdK9BdlV0Vz2D
	 hRGs7TfVmPFqwCSXjWM/fxxzSjT66ZunPbDHen8yPRii934eq8YrUuI1O5bf8iHvdZTdb
	 bY0a5XfcGg/ULBFCIx1d1TDYO4XGGVrU4X9KEU40t1Y32jCMv45h30fu2LDRAWxxvF1lU
	 sw2Bp/Q90qYf8BwnSC1cjoJkwVtxCDy+VhR8Z2L/Usu9eHdZ2V2zzG/E/+uvbr3W2lz0d
	 OkzouDAIlbBp8MlTUv/perwCrl1Lm9YLH57q/oIrRc6ND4D13IuUYF8H4xOOAnN34Ag==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=m+n+L0JU;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9604F606A31C;
	Thu, 19 Nov 2026 00:44:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=m+n+L0JU
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A9A5D1F000C4;
	Thu, 19 Nov 2026 00:44:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795049086;
	bh=H4As6NK59LMBfR/1c/I4QFlQIpsn9vf3eWI9zcR5V30=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=m+n+L0JUvv3Qa1cADG7JGO+OsQBdMnr6UkuQnny2ujT5F3afaeF/JJhjPKlH5eWsC
	 BYz1U5Tii1o5D3k0tiZYcWioHyTXwD8C0WPNwy/O/95A1qs9momIFjxeENcPJfQGoF
	 guDB35jEK6GWWModWRkNs0HOO/Fv7yfaJnc0f3fE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Diederik de Haas <didi.debian@cknow.org>,
	Dragan Simic <dsimic@manjaro.org>,
	Heiko Stuebner <heiko@sntech.de>,
	Sasha Levin <sashal@kernel.org>,
	Jonas Karlman <jonas@kwiboo.se>
Subject: [PATCH 6.1 2224/2857] arm64: dts: rockchip: Update GPU OPP voltages in RK356x SoC dtsi
Date: Wed, 18 Nov 2026 15:54:18 +0100
Message-ID: <20261118150321.494132012@linuxfoundation.org>
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

[ Upstream commit eb665b1c06bcaf16df10018550d8f467ed4b2887 ]

Update the values for the exact Rockchip RK356x GPU OPP voltages and the
lower limits for the GPU OPP voltage ranges, using the most conservative
values (i.e. the highest per-OPP voltages) found in the vendor kernel source
(cf. downstream commit f8b9431ee38e ("arm64: dts: rockchip: rk3568: support
adjust opp-table by otp")). [1][2]

Using the most conservative per-OPP voltages ensures reliable GPU operation
regardless of the actual GPU binning, with the downside of possibly using
a bit more power than absolutely needed.

[1] https://github.com/rockchip-linux/kernel/commit/f8b9431ee38ed561650be7092ab93f564598daa9
[2] https://raw.githubusercontent.com/rockchip-linux/kernel/f8b9431ee38ed561650be7092ab93f564598daa9/arch/arm64/boot/dts/rockchip/rk3568.dtsi

Suggested-by: Diederik de Haas <didi.debian@cknow.org>
Helped-by: Jonas Karlman <jonas@kwiboo.se>
Signed-off-by: Dragan Simic <dsimic@manjaro.org>
Link: https://lore.kernel.org/r/80301764e8983c8410c806ed2256403823709897.1719763100.git.dsimic@manjaro.org
Signed-off-by: Heiko Stuebner <heiko@sntech.de>
Stable-dep-of: 8043ed0f40fe ("arm64: dts: rockchip: Rename rk3566 and rk3568 HDMI audio cards")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/rockchip/rk356x.dtsi | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/arch/arm64/boot/dts/rockchip/rk356x.dtsi b/arch/arm64/boot/dts/rockchip/rk356x.dtsi
index af1f809eb3762..b8de230a49ed4 100644
--- a/arch/arm64/boot/dts/rockchip/rk356x.dtsi
+++ b/arch/arm64/boot/dts/rockchip/rk356x.dtsi
@@ -195,27 +195,27 @@ gpu_opp_table: opp-table-1 {
 
 		opp-200000000 {
 			opp-hz = /bits/ 64 <200000000>;
-			opp-microvolt = <825000 825000 1000000>;
+			opp-microvolt = <850000 850000 1000000>;
 		};
 
 		opp-300000000 {
 			opp-hz = /bits/ 64 <300000000>;
-			opp-microvolt = <825000 825000 1000000>;
+			opp-microvolt = <850000 850000 1000000>;
 		};
 
 		opp-400000000 {
 			opp-hz = /bits/ 64 <400000000>;
-			opp-microvolt = <825000 825000 1000000>;
+			opp-microvolt = <850000 850000 1000000>;
 		};
 
 		opp-600000000 {
 			opp-hz = /bits/ 64 <600000000>;
-			opp-microvolt = <825000 825000 1000000>;
+			opp-microvolt = <900000 900000 1000000>;
 		};
 
 		opp-700000000 {
 			opp-hz = /bits/ 64 <700000000>;
-			opp-microvolt = <900000 900000 1000000>;
+			opp-microvolt = <950000 950000 1000000>;
 		};
 
 		opp-800000000 {
-- 
2.53.0



