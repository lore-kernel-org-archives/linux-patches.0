Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 160C2296BDF;
	Tue, 26 Aug 2025 11:18:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756207125; cv=none; b=lHVwoC0xHnUMve9QgUnSiW/RW05Gc4x4bqH879SAr0MWSiSx7M8AbdrN4gKK+Xvnc97nDee8ABEz9pEC1l1neGxgCbf7DobN0vzE6/ytXGHFGqSoJrRqOunB5ptbw3RDPy9DSJ0BFbMLMBhywmXUzsqv6Vyu/FuBjuRaAGcSKl4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756207125; c=relaxed/simple;
	bh=0P+k+eCW/QowxlxGEb7fGiGTiCBzW7dmd751WBfhK40=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=e3PfLPc056I+34r6TdOMlcgUp43GCxTS3BTX4LrF+JCA4CZv3vi0HWNK+M17kye4eFzkxY5+P/SvfVCm47k1t2KaIBqaDXovobVk9hfNFarbiJlicAsyCSTa+b/vwZ9GGpuJlzbMIYE49k90NBZxhoAYKSmiSKWeywCTH2BggN8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dduVHbD3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dduVHbD3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 48143C4CEF1;
	Tue, 26 Aug 2025 11:18:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756207123;
	bh=0P+k+eCW/QowxlxGEb7fGiGTiCBzW7dmd751WBfhK40=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dduVHbD3sLoo73Ts4ITPbDpaTmu1jtKwUMmj0+eS6TKYfEZBAHAtdH1p1cUi7pPZJ
	 zb2wZOglvu9DnD+JogFqhiGdqMNVSt4ic5AWWASkb4p1Or8yFqPSXdRMg/Don+wPzx
	 aoiAghdfI3aKKhjBco+XhBDHJm3tU4GorhKrHqKg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sam Edwards <CFSworks@gmail.com>,
	Heiko Stuebner <heiko@sntech.de>
Subject: [PATCH 6.16 060/457] arm64: dts: rockchip: Remove workaround that prevented Turing RK1 GPU power regulator control
Date: Tue, 26 Aug 2025 13:05:44 +0200
Message-ID: <20250826110938.840529065@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110937.289866482@linuxfoundation.org>
References: <20250826110937.289866482@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sam Edwards <cfsworks@gmail.com>

commit de5b39d16318f9345f1ba7c1b684ba0c1cb6fdad upstream.

The RK3588 GPU power domain cannot be activated unless the external
power regulator is already on. When GPU support was added to this DT,
we had no way to represent this requirement, so `regulator-always-on`
was added to the `vdd_gpu_s0` regulator in order to ensure stability.
A later patch series (see "Fixes:" commit) resolved this shortcoming,
but that commit left the workaround -- and rendered the comment above
it no longer correct.

Remove the workaround to allow the GPU power regulator to power off, now
that the DT includes the necessary information to power it back on
correctly.

Fixes: f94500eb7328b ("arm64: dts: rockchip: Add GPU power domain regulator dependency for RK3588")
Signed-off-by: Sam Edwards <CFSworks@gmail.com>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20250608184855.130206-1-CFSworks@gmail.com
Signed-off-by: Heiko Stuebner <heiko@sntech.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/boot/dts/rockchip/rk3588-turing-rk1.dtsi | 11 -----------
 1 file changed, 11 deletions(-)

diff --git a/arch/arm64/boot/dts/rockchip/rk3588-turing-rk1.dtsi b/arch/arm64/boot/dts/rockchip/rk3588-turing-rk1.dtsi
index 60ad272982ad..6daea8961fdd 100644
--- a/arch/arm64/boot/dts/rockchip/rk3588-turing-rk1.dtsi
+++ b/arch/arm64/boot/dts/rockchip/rk3588-turing-rk1.dtsi
@@ -398,17 +398,6 @@
 
 		regulators {
 			vdd_gpu_s0: vdd_gpu_mem_s0: dcdc-reg1 {
-				/*
-				 * RK3588's GPU power domain cannot be enabled
-				 * without this regulator active, but it
-				 * doesn't have to be on when the GPU PD is
-				 * disabled.  Because the PD binding does not
-				 * currently allow us to express this
-				 * relationship, we have no choice but to do
-				 * this instead:
-				 */
-				regulator-always-on;
-
 				regulator-boot-on;
 				regulator-min-microvolt = <550000>;
 				regulator-max-microvolt = <950000>;
-- 
2.50.1



