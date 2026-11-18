Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795040772;
	b=0S9kdMou4YmGr14XEKl7MHMmJH2JxROmgv4QvE7FRTZ1OpO4v16jovn5Yq+sBw/j/mFu
	 s4cjAW5mItoI+LucFsfgl0UBcD4NMAsobREyxoHym9zlvrlx6TCOfw9pR6Ezk2oUQww1w
	 unqnxFAO7TPeKqBJYKofvN0Kn/+bwTvMaEGaaXWi9qlJc9QvsNRyhuGOmmUSuTUU04o/V
	 B3lyZRksYFIOK5EaR/LujA8s9RoyG1MtgoI8iP7ka7VGV4r8pzeDXHQCd+cuxTGSWmApg
	 20/+puySBlrfOEHnew3rAOEZbdGm7STvI/XYNquHvmpHWsBnWMk0dwzUY4qkGylQBmQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795040772;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=agFw7DQfoy9aqnXeC4DeLojq9YpI5j9PVHg04zan3IU=;
	b=ObZ7lwUlUzW8nndMtuR6qbZuRnAUxJet4fPearaz3q89yuZ1kWJdc+lErQ1bYeabHttv
	 7sSN0SRkjLEfcUAtjHgy5TppO0W0Oj6Tg2e7hy4H2M9jrGC3wxklEoj+fTXZwpMTfFDAn
	 CxnbzjxP1d5J0i9nCwHNu6jAnyCxULEAffh1B9MmcwyL7lH+CsnBe4Q7zXKfYpsG2jOM/
	 DdjW6JnDQPkUK4u58kTHIur6bOwPA+L7Nl4Ub2Fa4JmFoZq6WnRxL9Y3PsVfrm6UrIjfX
	 YKCCbTv9dx8YX8j/apg8T+4MHZ30MLQqJ/L4R6uxtAIeyYxdJVLGvNzxIgLVt/1Bu9g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=iB5EEhf9;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E602606A32A;
	Wed, 18 Nov 2026 22:26:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=iB5EEhf9
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 704E71F000C4;
	Wed, 18 Nov 2026 22:26:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795040772;
	bh=agFw7DQfoy9aqnXeC4DeLojq9YpI5j9PVHg04zan3IU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=iB5EEhf9zeL4n8jpAf+wN1En9b13P+OdJKeaeNVc1/iSAH2u3kPp7ROocKcNc2Ukv
	 +yeYma4CMXiqjb8XwE0tG0e9WvJKqWLpy8s+Z//Xsf7rsEfhrZYS+WOyi5HWO55ehI
	 0QmPB3xOa6Rr4eh5Ta7qe8QrPRLr5buAzbu/brqg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Diederik de Haas <didi.debian@cknow.org>,
	Dragan Simic <dsimic@manjaro.org>,
	Heiko Stuebner <heiko@sntech.de>,
	Sasha Levin <sashal@kernel.org>,
	Jonas Karlman <jonas@kwiboo.se>
Subject: [PATCH 6.6 2575/3318] arm64: dts: rockchip: Update GPU OPP voltages in RK356x SoC dtsi
Date: Wed, 18 Nov 2026 15:53:17 +0100
Message-ID: <20261118150438.466494862@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index ce452def3b755..51004ffe35a29 100644
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



