Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C46953F7A9F;
	Wed, 20 May 2026 18:11:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779300707; cv=none; b=SkleebK7GCqVxgAvMwI1tGZYho24cmTkc4v0uYvQLvXCI+3FPmDi36RzEgoSuZFsJltuW2rPp0X/b9TJ1e3WUFoArzAdrPJtj31f0BqthzAw0lDeO3Jn/205F9uGLiODJOJht1MRWab9rIzpJVOG1R3Gm29OK4MUsDD1uDIaFeU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779300707; c=relaxed/simple;
	bh=2HVSJ1Vx4iVcJJanuosBZRbMmv4iHdZgMBxyWbjmINA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZKS/NCcefrnSoWKl+CAbdH1N8jTdh4B6ujaOvp2xZ1cT4VPkvOrMY5b+WSF9kERvNuZhH9POQjJYSp+imPYcXsEnbLFqSkgxSP/yLs481oRvSwkHscZNPCwYzB+pS3qB2gXDyEN+fsU2rR7G/R2ZSMPfB2UzfzwYO5DgiNwM62k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CXofwmb2; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CXofwmb2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 35AD31F000E9;
	Wed, 20 May 2026 18:11:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779300706;
	bh=HLyI92k9cNMBWxXWU4jPetIumMvnWCz6k0+HpqNkrQU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=CXofwmb2uwYTPm3zkh8bX0mZh5QcDAH1zUMZ4I/kYRtvrDMTSPt9hln0MAptnUR79
	 wxglh3VO6gjIRLx1MBFL+GNSzvfOGrFHpXADF9HX9oIEfm5GZJkBWHEA+KgjdN54uf
	 2OfbGSR/wvYEP8uwbXZ9vMNEkO3XEIZvAluSnwrM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chris Morgan <macromorgan@hotmail.com>,
	Heiko Stuebner <heiko@sntech.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 277/666] arm64: dts: rockchip: Correct Fan Supply for Gameforce Ace
Date: Wed, 20 May 2026 18:18:08 +0200
Message-ID: <20260520162117.217194215@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162111.222830634@linuxfoundation.org>
References: <20260520162111.222830634@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chris Morgan <macromorgan@hotmail.com>

[ Upstream commit c7079215b7dbf88b84a95ff13982bf3dab3cfbe1 ]

Correct the regulator providing power to the PWM controlled fan.
Without this fix the fan only runs when the audio path is playing
audio (because the speaker amplifier and PWM fan share the same
regulator).

Fixes: 4e946c447a04 ("arm64: dts: rockchip: Add GameForce Ace")
Signed-off-by: Chris Morgan <macromorgan@hotmail.com>
Link: https://patch.msgid.link/20260310134648.550006-1-macroalpha82@gmail.com
Signed-off-by: Heiko Stuebner <heiko@sntech.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/rockchip/rk3588s-gameforce-ace.dts | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/rockchip/rk3588s-gameforce-ace.dts b/arch/arm64/boot/dts/rockchip/rk3588s-gameforce-ace.dts
index 467f69594089b..dc1639574f367 100644
--- a/arch/arm64/boot/dts/rockchip/rk3588s-gameforce-ace.dts
+++ b/arch/arm64/boot/dts/rockchip/rk3588s-gameforce-ace.dts
@@ -303,7 +303,7 @@ pwm_fan: pwm-fan {
 		compatible = "pwm-fan";
 		#cooling-cells = <2>;
 		cooling-levels = <0 120 150 180 210 240 255>;
-		fan-supply = <&vcc5v0_sys>;
+		fan-supply = <&vcc5v0_spk>;
 		interrupt-parent = <&gpio4>;
 		interrupts = <RK_PB2 IRQ_TYPE_EDGE_RISING>;
 		pulses-per-revolution = <4>;
-- 
2.53.0



