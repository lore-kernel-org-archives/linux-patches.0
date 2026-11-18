Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795025429;
	b=MV3l3XxuGec5SUKlJXLgp73k2RMeBgSCU9ESeg1hQo3G2M0yyeI4T4l9piVJoVMvKDzH
	 DbuEPNyFPo4qufOo5KHG7mSsTLI2DIXO8SapSuVsxddNWUvu2VpOJZ3zJf/nrr4WIfBc0
	 QYws51kZwc3d42jdF2l4LkkQ/hhWXJCT3uDf0xkY5V2tZFfkLzTmeYuiTV/zJizCUF71v
	 SxkMKzUQ8986KDWsdEXdfxZUyWth6AwH5ZR684nEpm2riyMZQ0EFLTVzdwYfFQwPkPJzw
	 Xi1ywQqGlfIJ5lhfK4W43U/8IBjFrkOWIDL09AuhhQZa28OKL3ydYdbN3uvREU6Nn2A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795025429;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=FYvAnsMa12Gv3vy6WtNPSC7cmly2AlOxJG6fPvbGkKc=;
	b=oul5COJpbP1gs8Umiibj+CGrSDj2OGb/oqPdjdDTRJPFXPglO4p/zdIVN7Lqsb/vIncC
	 BDz66B6LeicaWsU/FoQIhA9xbhTBtO1UjjH/wUC7Hu4bXPlUYyNcc3zsY4WPqYdjcnG+H
	 PeWQNk6d7tPrk3Xvmn2qorwZkKhXU5+zousSWdFl4VzYwV8UYyc0K4+Mwzgmr+rTify7p
	 ++mGnkH3zACzIHrVB8xlZiWA0JpbXJv1TKNucgNqsbv4LoulFnMY6YnWhhLDcvRB4NNVp
	 qM1AkVeGTVt5NxyoAWPeCXfqoWCtlws5i1A2LGSsbqV2D6ckEWSc+0s5XLixgr16n9w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=l+yOB7eL;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 601EC606A320;
	Wed, 18 Nov 2026 18:10:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=l+yOB7eL
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B8CFD1F000C4;
	Wed, 18 Nov 2026 18:10:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795025429;
	bh=FYvAnsMa12Gv3vy6WtNPSC7cmly2AlOxJG6fPvbGkKc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=l+yOB7eL86skHm6QCsF7n07NwvSsMXz8Ns8l/RHdxOB/1pjoy6XEr0zBk0b9NB4ss
	 M7ikccDUp6mpb7rHuG/tHMG7Rlu7zKOQbVfF4Bbj0PByXDs5cKXxVI/nzUsQ03cCGF
	 TlLQuPhCH/mU56iaW44zzHzT2HdTZUuUmcbyIWxs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Detlev Casanova <detlev.casanova@collabora.com>,
	Heiko Stuebner <heiko@sntech.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1077/2151] arm64: dts: rockchip: Rename rk3576 HDMI audio card
Date: Wed, 18 Nov 2026 15:46:52 +0100
Message-ID: <20261118150201.511823819@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Detlev Casanova <detlev.casanova@collabora.com>

[ Upstream commit d3d3b67505fa5f10af587a6fc8e6d4640010d52e ]

Rename the card from "HDMI" to "RK3576 HDMI" so it identifies the SoC
in user-visible ALSA fields and no longer collides with the identical
"HDMI" string used by other Rockchip SoCs.

Fixes: 7f1561d82e3d3 ("arm64: dts: rockchip: Add RK3576 HDMI audio")
Signed-off-by: Detlev Casanova <detlev.casanova@collabora.com>
Link: https://patch.msgid.link/20260910-fix-rockchip-hdmi-audio-names-v2-7-1396a6168e20@collabora.com
Signed-off-by: Heiko Stuebner <heiko@sntech.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/rockchip/rk3576.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/rockchip/rk3576.dtsi b/arch/arm64/boot/dts/rockchip/rk3576.dtsi
index 5d69a81aecc64..96c27fa20ed48 100644
--- a/arch/arm64/boot/dts/rockchip/rk3576.dtsi
+++ b/arch/arm64/boot/dts/rockchip/rk3576.dtsi
@@ -410,7 +410,7 @@ scmi_clk: protocol@14 {
 
 	hdmi_sound: hdmi-sound {
 		compatible = "simple-audio-card";
-		simple-audio-card,name = "HDMI";
+		simple-audio-card,name = "RK3576 HDMI";
 		simple-audio-card,format = "i2s";
 		simple-audio-card,mclk-fs = <256>;
 		status = "disabled";
-- 
2.53.0



