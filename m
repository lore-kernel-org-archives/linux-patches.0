Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795018569;
	b=zBVAcjowQu/TfhMeomahCaK9YA4ecEKOBOc9JfI5hqESdmk2o4hyn7f0Gtkq4v/A6H0G
	 s44Y3UHBCywkUbZF9Anyt8Ve9B6KJ+WuJqMqj/MTh8OhlnA0H10m9cliCG1A500zL6aY6
	 JP9xxpBve17b6/CxkcAKcVbZiqvD4M9+7Qawqch7jWRiBS2Ghc0+ZqiebC0JCQbpDsvMm
	 D3cWBagV+aICDaE06BMzOTFeZfZrhsN5rYc/hFxcz6q/7MO8/KX26qiR3T6I3Uw0JEmjz
	 chYJxwBHwdX9eY0xINAV1fY+00+YO9qbBmbrQKs78oTnn8MYsnEhaeUKCLn+O41TDCg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795018569;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=WY9AAcDChXGUxyZzKzVMZPBrB61lLmYlYpcmDQG//rA=;
	b=2F9UQUse3r/oZAIBSAmRVNhGUpQDsyxYtvQ3JEa8nPzLyg5MVmaU274LZadCaLlwsj0w
	 wL3oTFh5KvJ//Aidv5M51V8/xmIvH/hXRe+HXzbkNXKWy0KhTsjZrbwXoIMuUtOBexagE
	 s81zGKCw7fUxJjdM6IwAWcdKTcPEY3IMevmBjBqynzOH5BhpIklgjUv4cRfIrcEl5ZwjU
	 e/hOz5a9J+n06h74aQt3xDRwh8VW3FRmDuXwI9/M17M8NL9BAuZFv8vco93CUmjvARtzk
	 nx+4w3s/s76QEUI0BS8Ug+z9qmsAFS9rtlAV5WEp/ncai8aToK1Edkby4XMtbyayMEA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="xC+x/lkD";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 75A82606A325;
	Wed, 18 Nov 2026 16:16:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=xC+x/lkD
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D1F3D1F000C4;
	Wed, 18 Nov 2026 16:16:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795018569;
	bh=WY9AAcDChXGUxyZzKzVMZPBrB61lLmYlYpcmDQG//rA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=xC+x/lkD89M8ekLg8QWNgEmtwRYwdW5k6VcERAhVl3kffygCWC2VC1QX2y0Emx0IP
	 75PsDpwWtohPa5t+15sFqWRWiNU3hfhGsgXlsbeyTsHptF0guSZnKZ0mt5vCeJpgX1
	 wI0dPcKsKm5t4C8J++2mBe2cNAT/ZBn8plcCaBaY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Detlev Casanova <detlev.casanova@collabora.com>,
	Heiko Stuebner <heiko@sntech.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1287/2651] arm64: dts: rockchip: Rename rk3576 HDMI audio card
Date: Wed, 18 Nov 2026 15:42:07 +0100
Message-ID: <20261118150334.274157728@linuxfoundation.org>
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
index b0c0d3c8b1b14..ca9cbf035265e 100644
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



