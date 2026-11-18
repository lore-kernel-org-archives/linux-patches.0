Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795040783;
	b=c3xUGVoKewABD7qX1wMXWu1/rrn6qGyXvRCy0dipEx1xcxQ5Eb4wJNV1vyg9f01q+YEU
	 k8xFqZhWogZ2VUubN04UP9fGFye9XUWqtj4rO7bFiaQsq8caz+kcUWZo8l/mnPGIOiBuy
	 vqf97KSKX1R9CB4qiwFesbuETg8Gokl7Un74zLGYs4L6HqiT9mrlVskcMCqC30+OfjUdx
	 OWKAnJ/r+hX46TXlBeqhhfTg5GSdv5RbjpPflsmpsL4zdnbRPi6u4iyGXQVLpIEpPcri7
	 ze11tDeoS0+SPc46Vsd1L5iMrtmu/4dO9+UmRjNmQreFo4lwOvWY+phfGOcUVOD6QoQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795040783;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=rmTPs/534bpT4LjYkOv5r8HrfHZh3g0t1JoWxQfrt+o=;
	b=4kVFt0AFrGFpTeGjdI6qNtQpHGTxbZac/+k5r147aebwZDCzCNpBdxcpS7/LqbWZ2bd/
	 zHKnXkVTMj6NtNxvtzE/oWmqH1vo7RSZiykiTTnJpHx3BAa7+12rlUChDSqO4K8WM6XNi
	 8e8Z/5+n+nhQy5f2LKcuWbb8+kXLt80JFYxNHM1Z89Cf1QnEwauqnTAF3DgDff/l404uC
	 9u3HNdOYsCF/TlEdNYiZjRKd9nj6xAKS5DoFxYDjX5Ts+Jb3YONeBsa9DPVz5aI8gfpaX
	 JWk3fICTspQDyatsje/VaKbuoeq7lkjsFDQsHrf5p90v6hpcF4Bg1Q+HImlR5Hje3xA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=V5DAHcIO;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5FD90606A31C;
	Wed, 18 Nov 2026 22:26:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=V5DAHcIO
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B210A1F000C4;
	Wed, 18 Nov 2026 22:26:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795040783;
	bh=rmTPs/534bpT4LjYkOv5r8HrfHZh3g0t1JoWxQfrt+o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=V5DAHcIOtKM8vwmM6T+mhSWBNI+btWmlR4OBFg3/mLU+0VFxar7WeZ5D1XQmoTClP
	 YhRJ7jYa4u0tFeU6rX6Xc4TjyR9+D5D3C8V3PB296CcccZshITnFF+gdfesLTHcl51
	 lwXOlzbwGysqHWns6nEEWLTz1mcNSABoGsCyiWoQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Detlev Casanova <detlev.casanova@collabora.com>,
	Heiko Stuebner <heiko@sntech.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 2578/3318] arm64: dts: rockchip: Rename rk3566 and rk3568 HDMI audio cards
Date: Wed, 18 Nov 2026 15:53:20 +0100
Message-ID: <20261118150438.547578027@linuxfoundation.org>
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

From: Detlev Casanova <detlev.casanova@collabora.com>

[ Upstream commit 8043ed0f40fe2b49df1c2c25409ab6bd3f88e806 ]

Move the HDMI audio card name for RK3566 and RK3568 to their
corresponding dtsi files so the name can be set to match the SoC
in user-visible ALSA fields and no longer collides with the identical
"HDMI" string used by other Rockchip SoCs.

Fixes: 697ee8546e241 ("arm64: dts: rockchip: Add HDMI audio nodes to rk356x")
Signed-off-by: Detlev Casanova <detlev.casanova@collabora.com>
Link: https://patch.msgid.link/20260910-fix-rockchip-hdmi-audio-names-v2-6-1396a6168e20@collabora.com
Signed-off-by: Heiko Stuebner <heiko@sntech.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/rockchip/rk3566-base.dtsi | 4 ++++
 arch/arm64/boot/dts/rockchip/rk3568.dtsi      | 4 ++++
 arch/arm64/boot/dts/rockchip/rk356x-base.dtsi | 1 -
 3 files changed, 8 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/rockchip/rk3566-base.dtsi b/arch/arm64/boot/dts/rockchip/rk3566-base.dtsi
index e56e0b6ba9411..3c365a1188d7b 100644
--- a/arch/arm64/boot/dts/rockchip/rk3566-base.dtsi
+++ b/arch/arm64/boot/dts/rockchip/rk3566-base.dtsi
@@ -6,6 +6,10 @@ / {
 	compatible = "rockchip,rk3566";
 };
 
+&hdmi_sound {
+	simple-audio-card,name = "RK3566 HDMI";
+};
+
 &pipegrf {
 	compatible = "rockchip,rk3566-pipe-grf", "syscon";
 };
diff --git a/arch/arm64/boot/dts/rockchip/rk3568.dtsi b/arch/arm64/boot/dts/rockchip/rk3568.dtsi
index 5919d041f4d05..ae4d7a0b9b603 100644
--- a/arch/arm64/boot/dts/rockchip/rk3568.dtsi
+++ b/arch/arm64/boot/dts/rockchip/rk3568.dtsi
@@ -338,6 +338,10 @@ &gpu {
 	operating-points-v2 = <&gpu_opp_table>;
 };
 
+&hdmi_sound {
+	simple-audio-card,name = "RK3568 HDMI";
+};
+
 &pipegrf {
 	compatible = "rockchip,rk3568-pipe-grf", "syscon";
 };
diff --git a/arch/arm64/boot/dts/rockchip/rk356x-base.dtsi b/arch/arm64/boot/dts/rockchip/rk356x-base.dtsi
index 58d08e2f0a692..faa4f7ec43a90 100644
--- a/arch/arm64/boot/dts/rockchip/rk356x-base.dtsi
+++ b/arch/arm64/boot/dts/rockchip/rk356x-base.dtsi
@@ -146,7 +146,6 @@ scmi_clk: protocol@14 {
 
 	hdmi_sound: hdmi-sound {
 		compatible = "simple-audio-card";
-		simple-audio-card,name = "HDMI";
 		simple-audio-card,format = "i2s";
 		simple-audio-card,mclk-fs = <256>;
 		status = "disabled";
-- 
2.53.0



