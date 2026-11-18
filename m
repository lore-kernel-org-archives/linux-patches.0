Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795049072;
	b=u+p3JmFefZ2Yh0PxZx/Vn0OxTfjwmue2OUcVXXoCdSKQG3MmFtVpX7aYoAWPu/MgYPP8
	 dMF4bsrjR1BuqLN1wDYr1WYu7Xko0SGZoHubZcQ+Yf30hb+kYGQls2nAvmZFlqsI38qdu
	 xan3AkgMN+wk1jhKpRwPJxw7xhm+AywI1PYLtJJC288x+fXuKdcH+o2Y1PQoBIcKVjp7k
	 gokFIxJZp58Rz44otd6P/lmlXOEnfZLhOsslvl0qWr4hCXWLctKEqsMcAu0hrljbqOg1X
	 8fckzC4WhejLJ9FCNVpnYjDKHIdELK5klvz+OlmxaoLZP7eGjrE5NzWbZi/7Z89C2Mg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795049072;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=DeJ7rXjEsfGyuRzzOaqumND09Aj8tkKvwR7tLuSFL4Q=;
	b=svusdQlaAvi/D2rZCE5f9Gl2bXpXlYHj+U4SWTRb5bN3D835uhFzVIi5oImOE9A8qpTK
	 pyVqKh5NyLk9bFmChMPzRQppQywxu+f2Y/vd+3XxfRXaLDmmGTYO9qqskByqL3QuGV0bp
	 AmHcwJU4a25AYuuXiP9USCYxZ1kVGagVUHRApusk2Uq2zYktNeTHC6oiQ8XXQdRT6LB+D
	 RrDSXDOnk23G++tcTHnKRMXn7IoqSDnHxmPNlaqPidY8NDttaGY4J9+J0yN2wGgcxrjC1
	 ZGIErSP7O/Q9r8cOsw/0fJw1Fdvo+71S+NHlfEViw2uQEqHCHdG4/CnLK+Kw08zS/Rw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="K0eaVJ2/";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D241606A32C;
	Thu, 19 Nov 2026 00:44:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=K0eaVJ2/
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 904501F000C4;
	Thu, 19 Nov 2026 00:44:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795049072;
	bh=DeJ7rXjEsfGyuRzzOaqumND09Aj8tkKvwR7tLuSFL4Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=K0eaVJ2/V6rYiBSO445I4wgOqLVMIYu6C91zsc8JR7pom1UyXsK2slyapJNtrxciy
	 SfVXQsIXooNnhJ/FWiizCsAwQsrbySINYrUnj5J77lhC6ktiomuhd1rMKXa4+6xSf5
	 rSfAqDirywolU2ursGgoezgCE5IOePzdfXORDufs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Detlev Casanova <detlev.casanova@collabora.com>,
	Heiko Stuebner <heiko@sntech.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 2220/2857] arm64: dts: rockchip: Rename rk3328 HDMI audio card
Date: Wed, 18 Nov 2026 15:54:14 +0100
Message-ID: <20261118150321.348934492@linuxfoundation.org>
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

From: Detlev Casanova <detlev.casanova@collabora.com>

[ Upstream commit daa0db717771d43c25d98c2798fa6a7b0252deb7 ]

Rename the card from "HDMI" to "RK3328 HDMI" so it identifies the SoC
in user-visible ALSA fields and no longer collides with the identical
"HDMI" string used by other Rockchip SoCs.

Fixes: 29e8976e604f1 ("arm64: dts: rockchip: Add RK3328 audio pipelines")
Signed-off-by: Detlev Casanova <detlev.casanova@collabora.com>
Link: https://patch.msgid.link/20260910-fix-rockchip-hdmi-audio-names-v2-4-1396a6168e20@collabora.com
Signed-off-by: Heiko Stuebner <heiko@sntech.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/rockchip/rk3328.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/rockchip/rk3328.dtsi b/arch/arm64/boot/dts/rockchip/rk3328.dtsi
index ce7c1d3c345e3..3db5f4acabc02 100644
--- a/arch/arm64/boot/dts/rockchip/rk3328.dtsi
+++ b/arch/arm64/boot/dts/rockchip/rk3328.dtsi
@@ -176,7 +176,7 @@ hdmi_sound: hdmi-sound {
 		compatible = "simple-audio-card";
 		simple-audio-card,format = "i2s";
 		simple-audio-card,mclk-fs = <128>;
-		simple-audio-card,name = "HDMI";
+		simple-audio-card,name = "RK3328 HDMI";
 		status = "disabled";
 
 		simple-audio-card,cpu {
-- 
2.53.0



